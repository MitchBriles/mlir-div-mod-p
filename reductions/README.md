# Reductions

Each `input*.ll` is a function from real code. Reduce with:

```sh
LLVM_BUILD=/path/to/build llvm-reduce --test=./test1.sh input1.ll -o reduced1.ll
$LLVM_BUILD/bin/mlir-translate --import-llvm reduced1.ll -o reduced1.mlir
```

Each test runs the analysis for several p and combines the results.

1. SQLite `vdbeSorterTreeDepth`: `nDiv` starts at 16 and is multiplied by 16
   in a loop. Mod 2, 3 and 5 it is 0, 1 and 1, so `nDiv` is `16 (mod 30)`. mod 7
   it's unknown, so it's not a constant.
2. SQLite shell `qrfBoxLine`: the length passed to `sqlite3_str_append` is
   `3 * N` for an unknown `N`, so it's a multiple of 3 (whole 3-byte UTF-8
   characters) and unknown for every other p.
3. bzip2 `mainSort`: Knuth's Shell sort gaps `h = 3h + 1` are all `1 (mod 3)`,
   and unknown for every other p.
