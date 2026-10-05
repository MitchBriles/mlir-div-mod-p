#!/bin/sh
$LLVM_BUILD/bin/mlir-translate --import-llvm $1 -o /tmp/test1.mlir
v=$(../build/run.sh 3 /tmp/test1.mlir | sed -n 's/^ *\(%[0-9]*\): 1 (mod 3)$/\1/p' | head -1)
[ -n "$v" ] &&
../build/run.sh 3 /tmp/test1.mlir | grep -q "llvm.mul.*$v[ ,]" &&
../build/run.sh 2 /tmp/test1.mlir | grep -q "$v: 0 (mod 2)" &&
../build/run.sh 5 /tmp/test1.mlir | grep -q "$v: 1 (mod 5)" &&
../build/run.sh 7 /tmp/test1.mlir | grep -q "$v: top"
