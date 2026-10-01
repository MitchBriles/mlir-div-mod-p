# mod-p-analysis

An MLIR sparse dataflow analysis that tracks the remainder of each integer
value modulo p, over the lattice

```
          top
    /  /   |    \
   0  1   ...   p-1
    \  \   |    /
         bottom
```

It is built as an `mlir-opt` pass plugin. p is a pass option, and can be 2, 3, 5, or 7.

## Building

You need an LLVM build with MLIR enabled
(`-DLLVM_ENABLE_PROJECTS=mlir`). Point
`LLVM_BUILD` at that build directory:

```sh
cmake -S . -B build -G Ninja -DLLVM_BUILD=/path/to/llvm-project/build-mlir
cmake --build build
```

You must specify an `LLVM_BUILD`.

## Running

Configuring generates `build/run.sh`, which runs that build's `mlir-opt`
with the plugin loaded:

```sh
./build/run.sh 3 test/basic.mlir
```

Output is one line per operation, annotated with what is known about its
result:

```
@join:
  ^bb3:
    %3: 3 (mod 7)
    %4: top
    %5 = llvm.add %3, %4 : i32                      // top
```

To get LLVM-dialect input from C:

```sh
clang -S -emit-llvm -o - input.c | mlir-translate --import-llvm
```

## Files

| File | |
|---|---|
| `ModPDomain.h` | The lattice: `ModPState<P>`, its join and printing. |
| `ModPAnalysis.cpp` | Transfer functions, the pass, and the plugin entry point. |
| `run.sh.in` | Template for `build/run.sh`. |
| `test/basic.mlir` | Example input. |
