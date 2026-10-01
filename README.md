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

To analyze C code, convert it to the LLVM dialect as in the example below.

## Example: SQLite's command-line shell

### The code

SQLite's amalgamation includes the `sqlite3` command-line shell as a single
file, `shell.c`, which compiles without any configuration:

```sh
curl -LO https://www.sqlite.org/2026/sqlite-amalgamation-3530400.zip
unzip sqlite-amalgamation-3530400.zip
cd sqlite-amalgamation-3530400
```

The function of interest is `qrfBoxLine` (`shell.c`, line 2518, SQLite 3.53.4):

```c
/* Draw horizontal line N characters long using unicode box
** characters
*/
static void qrfBoxLine(sqlite3_str *pOut, int N, int bDbl){
  const char *azDash[2] = {
      BOX_24 BOX_24 BOX_24 BOX_24 BOX_24   BOX_24 BOX_24 BOX_24 BOX_24 BOX_24,
      DBL_24 DBL_24 DBL_24 DBL_24 DBL_24   DBL_24 DBL_24 DBL_24 DBL_24 DBL_24
  };
  const int nDash = 30;
  N *= 3;
  while( N>nDash ){
    sqlite3_str_append(pOut, azDash[bDbl], nDash);
    N -= nDash;
  }
  sqlite3_str_append(pOut, azDash[bDbl], N);
}
```

### Converting to the LLVM dialect

```sh
clang -O0 -Xclang -disable-O0-optnone -S -emit-llvm shell.c -o shell.ll
$LLVM_BUILD/bin/opt -S -passes=mem2reg shell.ll -o shell.ll
$LLVM_BUILD/bin/mlir-translate --import-llvm shell.ll -o shell.mlir
```

The analysis tracks SSA values, not memory, so local variables must be
promoted to registers. Plain `-O0` keeps them in memory, and `-O1` and above
rewrite the arithmetic (folding `i + 1` into pointer offsets, for example).
`-disable-O0-optnone` lets `mem2reg` run on unoptimized code. Use a clang no
newer than the LLVM in `LLVM_BUILD`, since an older IR parser may not read
newer IR.

### Running

```sh
./build/run.sh 3 test/sqlite3.mlir
```

### The result

(Trimmed to just the interesting lines):

```
@qrfBoxLine:
  ^bb0:
    %arg1: top
    %3 = llvm.mlir.constant(3 : i32) : i32          // 0 (mod 3)
    %4 = llvm.mlir.constant(30 : i32) : i32         // 0 (mod 3)
    %7 = llvm.mul %arg1, %3 overflow<nsw> : i32     // 0 (mod 3)
    llvm.br ^bb1(%7 : i32)
  ^bb1:
    %8: 0 (mod 3)
    %9 = llvm.icmp "sgt" %8, %4 : i32               // top
    llvm.cond_br %9, ^bb2, ^bb3
  ^bb2:
    llvm.call @sqlite3_str_append(%arg0, %12, %4) : ...
    %13 = llvm.sub %8, %4 overflow<nsw> : i32       // 0 (mod 3)
    llvm.br ^bb1(%13 : i32) loop_annotation = #loop_annotation
  ^bb3:
    llvm.call @sqlite3_str_append(%arg0, %16, %8) : ...
```

`%arg1` is `N`, `%8` is `N` at the head of the loop, and `%3` and `%4` are the
constants 3 and 30. The box characters
`─` and `═` are 3 bytes each in UTF-8 (`BOX_24` is `"\342\224\200"`), so the
function writes 3N bytes in chunks of at most 30. The analysis proves
`N ≡ 0 (mod 3)` at the loop head, so both calls to `sqlite3_str_append` write a
multiple of 3 bytes: the line is never cut in the middle of a character, and
**the output stays valid UTF-8**.

The proof needs `N *= 3` to be `0 (mod 3)` even though `N` is an unknown
argument, `N -= 30` to preserve that, and both edges into the loop head to
agree. Constant propagation finds nothing here, since `N` is a parameter, and
with p = 2 or 5, `%8` is `top`.

### Other facts in the same code

- `sqlite3.c`, `vdbeSorterTreeDepth`: `nDiv` starts at 16 and is multiplied
  by 16 each iteration. It comes out `0 (mod 2)`, `1 (mod 3)` and `1 (mod 5)`,
  and `top` for p = 7, where powers of 16 cycle through 2, 4 and 1.
- `shell.c`, `toBase85`: the column counter `nCol` grows by 5 and resets to 0,
  so it is `0 (mod 5)`.
- `shell.c`, `local_getline`: the buffer size grows as `nLine*2 + 100` from 0
  or 100, so it is `0 (mod 2)` and `0 (mod 5)`, always a multiple of 10.
- bzip2 1.0.8, `blocksort.c`, `mainSort`: Knuth's Shell sort gaps
  `h = 3*h + 1` (1, 4, 13, 40, ...) are all `1 (mod 3)`.

## Files

| File | |
|---|---|
| `ModPDomain.h` | The lattice: `ModPState<P>`, its join and printing. |
| `ModPAnalysis.cpp` | Transfer functions, the pass, and the plugin entry point. |
| `run.sh.in` | Template for `build/run.sh`. |
| `test/basic.mlir` | Example input. |
| `test/sqlite3.mlir` | `qrfBoxLine` from the SQLite example. |
