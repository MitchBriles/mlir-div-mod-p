#include "ModPDomain.h"

#include "mlir/Analysis/DataFlow/ConstantPropagationAnalysis.h"
#include "mlir/Analysis/DataFlow/DeadCodeAnalysis.h"
#include "mlir/Analysis/DataFlow/SparseAnalysis.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/AsmState.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Matchers.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassRegistry.h"
#include "mlir/Tools/Plugins/PassPlugin.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/Support/Compiler.h"
#include <llvm/IR/Operator.h>
#include <llvm/IR/PatternMatch.h>

using namespace mlir;

namespace modp {

template <unsigned P> using ModPLattice = dataflow::Lattice<ModPState<P>>;

template <unsigned P>
class ModPAnalysis
    : public dataflow::SparseForwardDataFlowAnalysis<ModPLattice<P>> {
public:
  using State = ModPState<P>;
  using Lattice = ModPLattice<P>;
  using dataflow::SparseForwardDataFlowAnalysis<
      Lattice>::SparseForwardDataFlowAnalysis;

  void setToEntryState(Lattice *lattice) override {
    this->propagateIfChanged(lattice, lattice->join(State::top()));
  }

  LogicalResult visitOperation(Operation *op,
                               ArrayRef<const Lattice *> operands,
                               ArrayRef<Lattice *> results) override {
    auto unknown = [&] {
      this->setAllToEntryStates(results);
      return success();
    };

    if (op->getNumResults() != 1 || !op->getResult(0).getType().isIntOrIndex())
      return unknown();
    Lattice *result = results[0];

    // constants are read as signed, so -1 : i32 is p - 1.
    IntegerAttr value;
    if (matchPattern(op, m_Constant(&value))) {
      int64_t r = value.getValue().srem(P);
      if (r < 0)
        r += P;
      this->propagateIfChanged(result, result->join(State(unsigned(r))));
      return success();
    }

    // we need nsw for soundness.
    // Proof: Consider an i4. If we have 7 + 1, the analysis sees:
    //
    // 1 (mod 3) + 1 (mod 3) = 2 (mod 3)
    //
    // But 7 + 1 is -8 in an i4, which is 1 (mod 3).

    if (isa<LLVM::AddOp, LLVM::SubOp, LLVM::MulOp, LLVM::ShlOp>(op)) {
      auto flags = cast<LLVM::IntegerOverflowFlagsInterface>(op);
      if (!wrapPreservesRemainder(op->getResult(0).getType()) &&
          !flags.hasNoSignedWrap())
        return unknown();
      State lhs = operands[0]->getValue(), rhs = operands[1]->getValue();
      // x << k is x * 2^k, so a constant k becomes the factor 2^k mod P.
      if (isa<LLVM::ShlOp>(op)) {
        APInt k;
        if (!matchPattern(op->getOperand(1), m_ConstantInt(&k)) ||
            k.uge(k.getBitWidth()))
          return unknown();
        unsigned factor = 1;
        for (uint64_t i = 0; i < k.getZExtValue(); ++i)
          factor = factor * 2 % P;
        rhs = State(factor);
      }
      // Bottom waits for the solver to revisit.
      if (lhs.isBottom() || rhs.isBottom())
        return success();
      // A multiple of P times anything is a multiple of P.
      if (isa<LLVM::MulOp, LLVM::ShlOp>(op) &&
          (lhs == State(0) || rhs == State(0))) {
        this->propagateIfChanged(result, result->join(State(0)));
        return success();
      }
      if (lhs.isTop() || rhs.isTop())
        return unknown();
      unsigned a = lhs.remainder;
      unsigned b = rhs.remainder;
      unsigned r;
      if (isa<LLVM::AddOp>(op))
        r = a + b;
      else if (isa<LLVM::SubOp>(op))
        r = a + P - b;
      else
        r = a * b;
      this->propagateIfChanged(result, result->join(State(r)));
      return success();
    }

    // For P = 2 the remainder is the low bit, which and, or and xor compute
    // bitwise. A 0 operand decides an and, and a 1 operand decides an or.
    if (P == 2 && isa<LLVM::AndOp, LLVM::OrOp, LLVM::XOrOp>(op)) {
      State lhs = operands[0]->getValue(), rhs = operands[1]->getValue();
      if (lhs.isBottom() || rhs.isBottom())
        return success();
      State out = State::top();
      if (isa<LLVM::AndOp>(op) && (lhs == State(0) || rhs == State(0)))
        out = State(0);
      else if (isa<LLVM::OrOp>(op) && (lhs == State(1) || rhs == State(1)))
        out = State(1);
      else if (!lhs.isTop() && !rhs.isTop()) {
        unsigned a = lhs.remainder;
        unsigned b = rhs.remainder;
        if (isa<LLVM::AndOp>(op))
          out = State(a & b);
        else if (isa<LLVM::OrOp>(op))
          out = State(a | b);
        else
          out = State(a ^ b);
      }
      this->propagateIfChanged(result, result->join(out));
      return success();
    }

    // either value may be chosen, so the result is the join.
    if (isa<LLVM::SelectOp>(op)) {
      State either =
          State::join(operands[1]->getValue(), operands[2]->getValue());
      this->propagateIfChanged(result, result->join(either));
      return success();
    }

    // some ops that preserve remainder.
    if (isa<LLVM::SExtOp, LLVM::ZExtOp, LLVM::TruncOp, LLVM::SRemOp,
            LLVM::URemOp>(op)) {
      // sext preserves the signed value. zext and trunc preserve the low
      // bits, which suffices when P divides 2^N for the narrower width;
      // otherwise nneg (zext) or nsw (trunc) says the signed value is
      // preserved.
      bool keepsRemainder = isa<LLVM::SExtOp>(op);
      if (auto zext = dyn_cast<LLVM::ZExtOp>(op))
        keepsRemainder =
            zext.getNonNeg() || wrapPreservesRemainder(zext.getArg().getType());
      if (auto trunc = dyn_cast<LLVM::TruncOp>(op))
        keepsRemainder =
            trunc.hasNoSignedWrap() || wrapPreservesRemainder(trunc.getType());
      // x = q*c + (x srem c), so if P divides c then x srem c = x (mod P).
      APInt c;
      if (auto srem = dyn_cast<LLVM::SRemOp>(op))
        keepsRemainder = matchPattern(srem.getRhs(), m_ConstantInt(&c)) &&
                         !c.isZero() && c.srem(P) == 0;
      if (!keepsRemainder)
        return unknown();
      this->propagateIfChanged(result, result->join(operands[0]->getValue()));
      return success();
    }

    return unknown();
  }

private:
  // iN arithmetic is exact modulo 2^N, so the true sum and the wrapped sum
  // agree mod P only when P divides 2^N. Otherwise the op needs nsw, under
  // which a signed overflow is poison and any claim about it is sound. nuw
  // does not help: it bounds the unsigned value, but constants are signed.
  static bool wrapPreservesRemainder(Type type) {
    auto intType = dyn_cast<IntegerType>(type);
    return intType && llvm::isPowerOf2_32(P) &&
           llvm::Log2_32(P) <= intType.getWidth();
  }
};

struct ModPPass : PassWrapper<ModPPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(ModPPass)

  ModPPass() = default;
  ModPPass(const ModPPass &pass) : PassWrapper(pass) {}

  StringRef getArgument() const final { return "mod-p-analysis"; }
  StringRef getDescription() const final {
    return "Compute the remainder of integer values modulo p";
  }

  Option<unsigned> p{*this, "p", llvm::cl::desc("Modulus: 2, 3, 5, or 7"),
                     llvm::cl::init(2)};

  void runOnOperation() override {
    switch (p) {
    case 2:
      return run<2>();
    case 3:
      return run<3>();
    case 5:
      return run<5>();
    case 7:
      return run<7>();
    default:
      emitError(getOperation().getLoc())
          << "mod-p-analysis: unsupported p = " << p.getValue();
      return signalPassFailure();
    }
  }

  template <unsigned P> void run() {
    DataFlowConfig config;
    config.setInterprocedural(false);
    DataFlowSolver solver(config);
    solver.load<dataflow::DeadCodeAnalysis>();
    solver.load<dataflow::SparseConstantPropagation>();
    solver.load<ModPAnalysis<P>>();
    if (failed(solver.initializeAndRun(getOperation())))
      return signalPassFailure();

    print<P>(solver, llvm::outs());
    markAllAnalysesPreserved();
  }

  template <unsigned P>
  void print(DataFlowSolver &solver, llvm::raw_ostream &os) {
    AsmState asmState(getOperation());
    getOperation()->print(llvm::nulls(), asmState);

    auto fact = [&](Value value) {
      const auto *lattice = solver.lookupState<ModPLattice<P>>(value);
      return lattice ? lattice->getValue() : ModPState<P>::bottom();
    };

    os << "mod-p-analysis (p = " << P << ")\n";
    getOperation().walk([&](FunctionOpInterface fn) {
      if (fn.isExternal())
        return;
      os << "\n@" << fn.getName() << ":\n";
      for (Block &block : fn.getFunctionBody()) {
        os << "  ";
        block.printAsOperand(os, asmState);
        os << ":\n";
        for (BlockArgument arg : block.getArguments()) {
          if (!arg.getType().isIntOrIndex())
            continue;
          os << "    ";
          arg.printAsOperand(os, asmState);
          os << ": " << fact(arg) << "\n";
        }
        for (Operation &op : block) {
          std::string line;
          llvm::raw_string_ostream lineOs(line);
          op.print(lineOs, asmState);
          os << "    " << line;

          SmallVector<ModPState<P>> facts;
          for (Value result : op.getResults())
            if (result.getType().isIntOrIndex())
              facts.push_back(fact(result));
          if (!facts.empty()) {
            os.indent(line.size() < 48 ? 48 - line.size() : 1) << "// ";
            llvm::interleaveComma(facts, os);
          }
          os << "\n";
        }
      }
    });
  }
};

} // namespace modp

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo mlirGetPassPluginInfo() {
  return {MLIR_PLUGIN_API_VERSION, "ModPAnalysis", LLVM_VERSION_STRING,
          []() { PassRegistration<modp::ModPPass>(); }};
}
