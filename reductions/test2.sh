#!/bin/sh
$LLVM_BUILD/bin/mlir-translate --import-llvm $1 -o /tmp/test2.mlir
v=$(../build/run.sh 3 /tmp/test2.mlir | sed -n 's/^ *\(%[0-9]*\): 0 (mod 3)$/\1/p' | head -1)
[ -n "$v" ] &&
../build/run.sh 3 /tmp/test2.mlir | grep -q "llvm.call.*$v)" &&
../build/run.sh 2 /tmp/test2.mlir | grep -q "$v: top"
