module {
  llvm.func @constants(%arg0: i32) -> i32 {
    %a = llvm.mlir.constant(7 : i32) : i32
    %b = llvm.mlir.constant(-1 : i32) : i32
    %c = llvm.mlir.constant(1000000007 : i64) : i64
    %d = llvm.add %a, %b : i32
    llvm.return %d : i32
  }

  llvm.func @join(%flag: i1) -> i32 {
    %c3 = llvm.mlir.constant(3 : i32) : i32
    %c10 = llvm.mlir.constant(10 : i32) : i32
    %c4 = llvm.mlir.constant(4 : i32) : i32
    llvm.cond_br %flag, ^lhs, ^rhs
  ^lhs:
    llvm.br ^exit(%c3, %c3 : i32, i32)
  ^rhs:
    llvm.br ^exit(%c10, %c4 : i32, i32)
  ^exit(%x: i32, %y: i32):
    // %x: 3 vs 10 agree mod 7; %y: 3 vs 4 never agree.
    %sum = llvm.add %x, %y : i32
    llvm.return %sum : i32
  }

  llvm.func @add(%arg0: i32) -> i32 {
    %c5 = llvm.mlir.constant(5 : i32) : i32
    %c7 = llvm.mlir.constant(7 : i32) : i32
    %cm1 = llvm.mlir.constant(-1 : i32) : i32
    // Without nsw only p = 2 survives wraparound.
    %wrap = llvm.add %c5, %c7 : i32
    %nsw = llvm.add %c5, %c7 overflow<nsw> : i32
    // nuw is not enough: constants are read as signed.
    %nuw = llvm.add %c5, %c7 overflow<nuw> : i32
    %neg = llvm.add %c5, %cm1 overflow<nsw> : i32
    %unknown = llvm.add %c5, %arg0 overflow<nsw> : i32
    %chain = llvm.add %nsw, %neg overflow<nsw> : i32
    llvm.return %chain : i32
  }

  // %i is bottom on the first visit of %next; the solver must revisit.
  llvm.func @loop(%n: i1) -> i32 {
    %c0 = llvm.mlir.constant(0 : i32) : i32
    %c6 = llvm.mlir.constant(6 : i32) : i32
    llvm.br ^head(%c0 : i32)
  ^head(%i: i32):
    %next = llvm.add %i, %c6 overflow<nsw> : i32
    llvm.cond_br %n, ^head(%next : i32), ^exit
  ^exit:
    llvm.return %next : i32
  }
}
