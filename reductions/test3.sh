#!/bin/sh
$LLVM_BUILD/bin/mlir-translate --import-llvm $1 -o /tmp/test3.mlir
v=$(../build/run.sh 3 /tmp/test3.mlir | sed -n 's/^ *\(%[0-9]*\): 1 (mod 3)$/\1/p' | head -1)
a=$(../build/run.sh 3 /tmp/test3.mlir | sed -n 's/^ *\(%[0-9]*\) = llvm.add.*1 (mod 3)$/\1/p' | head -1)
[ -n "$v" ] && [ -n "$a" ] &&
../build/run.sh 3 /tmp/test3.mlir | grep -q "llvm.mul.*$v[ ,]" &&
../build/run.sh 3 /tmp/test3.mlir | grep -q "br.*$a[ ,)]" &&
../build/run.sh 2 /tmp/test3.mlir | grep -q "$v: top" &&
../build/run.sh 2 /tmp/test3.mlir | grep -q "$a = llvm.add.*top"
