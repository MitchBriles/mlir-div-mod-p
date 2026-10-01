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

    // Constants are read as signed, so -1 : i32 is p - 1.
    IntegerAttr value;
    if (matchPattern(op, m_Constant(&value))) {
      int64_t r = value.getValue().srem(P);
      if (r < 0)
        r += P;
      this->propagateIfChanged(result, result->join(State(unsigned(r))));
      return success();
    }

    // A bottom operand yields bottom, so joining it leaves the result alone
    // until the solver revisits.
    if (auto add = dyn_cast<LLVM::AddOp>(op)) {
      if (!wrapPreservesRemainder(add.getType()) && !add.hasNoSignedWrap())
        return unknown();
      State sum = State::add(operands[0]->getValue(), operands[1]->getValue());
      this->propagateIfChanged(result, result->join(sum));
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
