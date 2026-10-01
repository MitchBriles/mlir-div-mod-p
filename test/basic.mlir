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

  llvm.func @mul(%arg0: i32) -> i32 {
    %c2 = llvm.mlir.constant(2 : i32) : i32
    %c3 = llvm.mlir.constant(3 : i32) : i32
    %wrap = llvm.mul %c2, %c3 : i32
    %nsw = llvm.mul %c2, %c3 overflow<nsw> : i32
    %unknown = llvm.mul %c2, %arg0 overflow<nsw> : i32
    llvm.return %nsw : i32
  }

  llvm.func @sub(%flag: i1) -> i32 {
    %c5 = llvm.mlir.constant(5 : i32) : i32
    %c7 = llvm.mlir.constant(7 : i32) : i32
    %wrap = llvm.sub %c5, %c7 : i32
    %nsw = llvm.sub %c5, %c7 overflow<nsw> : i32
    llvm.return %nsw : i32
  }

  llvm.func @select(%flag: i1) -> i32 {
    %c3 = llvm.mlir.constant(3 : i32) : i32
    %c10 = llvm.mlir.constant(10 : i32) : i32
    // 3 and 10 agree mod 7 only.
    %s = llvm.select %flag, %c3, %c10 : i1, i32
    llvm.return %s : i32
  }

  llvm.func @casts() -> i64 {
    %m1 = llvm.mlir.constant(-1 : i32) : i32
    %c5 = llvm.mlir.constant(5 : i32) : i32
    %big = llvm.mlir.constant(4294967297 : i64) : i64
    %fits = llvm.mlir.constant(1000000007 : i64) : i64
    %sext = llvm.sext %m1 : i32 to i64
    // Unsigned 2^32 - 1 is 0 (mod 3), not the 2 (mod 3) that -1 is.
    %zext = llvm.zext %m1 : i32 to i64
    %zext_nneg = llvm.zext nneg %c5 : i32 to i64
    // 2^32 + 1 truncates to 1.
    %trunc = llvm.trunc %big : i64 to i32
    %trunc_nsw = llvm.trunc %fits overflow<nsw> : i64 to i32
    llvm.return %sext : i64
  }

  llvm.func @srem(%arg0: i32) -> i32 {
    %c7 = llvm.mlir.constant(7 : i32) : i32
    %m7 = llvm.mlir.constant(-7 : i32) : i32
    %c0 = llvm.mlir.constant(0 : i32) : i32
    %c4 = llvm.mlir.constant(4 : i32) : i32
    %c6 = llvm.mlir.constant(6 : i32) : i32
    %pos = llvm.srem %c7, %c6 : i32
    %neg = llvm.srem %m7, %c6 : i32
    %by4 = llvm.srem %c7, %c4 : i32
    %by0 = llvm.srem %c7, %c0 : i32
    %top = llvm.srem %arg0, %c6 : i32
    llvm.return %pos : i32
  }

  llvm.func @mul_by_multiple(%arg0: i32) -> i32 {
    %c6 = llvm.mlir.constant(6 : i32) : i32
    // 6 * x is 0 (mod 2) and 0 (mod 3) even though x is unknown.
    %nsw = llvm.mul %arg0, %c6 overflow<nsw> : i32
    // Without nsw only p = 2 survives wraparound.
    %wrap = llvm.mul %c6, %arg0 : i32
    llvm.return %nsw : i32
  }

  llvm.func @shl(%arg0: i32) -> i32 {
    %c1 = llvm.mlir.constant(1 : i32) : i32
    %c3 = llvm.mlir.constant(3 : i32) : i32
    %c5 = llvm.mlir.constant(5 : i32) : i32
    %c40 = llvm.mlir.constant(40 : i32) : i32
    // 5 << 3 = 40.
    %const = llvm.shl %c5, %c3 overflow<nsw> : i32
    // x << 1 is even, flags or not.
    %even = llvm.shl %arg0, %c1 : i32
    %unknown = llvm.shl %arg0, %c1 overflow<nsw> : i32
    %by_var = llvm.shl %c5, %arg0 overflow<nsw> : i32
    // Shifting by the bit width or more is poison.
    %too_far = llvm.shl %c5, %c40 overflow<nsw> : i32
    llvm.return %const : i32
  }

  llvm.func @bitwise(%arg0: i32) -> i32 {
    %c5 = llvm.mlir.constant(5 : i32) : i32
    %c6 = llvm.mlir.constant(6 : i32) : i32
    %c7 = llvm.mlir.constant(7 : i32) : i32
    // For p = 2 only.
    %and_even = llvm.and %arg0, %c6 : i32
    %or_odd = llvm.or %arg0, %c5 : i32
    %and = llvm.and %c5, %c7 : i32
    %xor = llvm.xor %c5, %c7 : i32
    %xor_unknown = llvm.xor %arg0, %c5 : i32
    llvm.return %and : i32
  }

  llvm.func @urem() -> i32 {
    %c7 = llvm.mlir.constant(7 : i32) : i32
    %m7 = llvm.mlir.constant(-7 : i32) : i32
    %c4 = llvm.mlir.constant(4 : i32) : i32
    %c6 = llvm.mlir.constant(6 : i32) : i32
    // For p = 2 only: 7 urem 6 = 1, and -7 urem 4 = 2^32 - 7 urem 4 = 1.
    %pos = llvm.urem %c7, %c6 : i32
    %neg = llvm.urem %m7, %c4 : i32
    llvm.return %pos : i32
  }

}
