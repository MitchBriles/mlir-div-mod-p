// qrfBoxLine from SQLite 3.53.4 shell.c, converted as in the README, with the
// globals and declaration it uses. Run with p = 3.
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
module {
  llvm.mlir.global private unnamed_addr constant @".str.218"("\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\00") {addr_space = 0 : i32, alignment = 1 : i64, dso_local}
  llvm.mlir.global private unnamed_addr constant @".str.219"("\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\00") {addr_space = 0 : i32, alignment = 1 : i64, dso_local}
  llvm.mlir.global private unnamed_addr constant @__const.qrfBoxLine.azDash() {addr_space = 0 : i32, alignment = 16 : i64, dso_local} : !llvm.array<2 x ptr> {
    %0 = llvm.mlir.addressof @".str.219" : !llvm.ptr
    %1 = llvm.mlir.addressof @".str.218" : !llvm.ptr
    %2 = llvm.mlir.undef : !llvm.array<2 x ptr>
    %3 = llvm.insertvalue %1, %2[0] : !llvm.array<2 x ptr>
    %4 = llvm.insertvalue %0, %3[1] : !llvm.array<2 x ptr>
    llvm.return %4 : !llvm.array<2 x ptr>
  }
  llvm.func @sqlite3_str_append(!llvm.ptr {llvm.noundef}, !llvm.ptr {llvm.noundef}, i32 {llvm.noundef}) attributes {frame_pointer = #llvm.framePointerKind<all>, passthrough = [["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic"}
  llvm.func internal @qrfBoxLine(%arg0: !llvm.ptr {llvm.noundef}, %arg1: i32 {llvm.noundef}, %arg2: i32 {llvm.noundef}) attributes {dso_local, frame_pointer = #llvm.framePointerKind<all>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", uwtable_kind = #llvm.uwtableKind<async>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.addressof @__const.qrfBoxLine.azDash : !llvm.ptr
    %2 = llvm.mlir.constant(16 : i64) : i64
    %3 = llvm.mlir.constant(3 : i32) : i32
    %4 = llvm.mlir.constant(30 : i32) : i32
    %5 = llvm.mlir.constant(0 : i64) : i64
    %6 = llvm.alloca %0 x !llvm.array<2 x ptr> {alignment = 16 : i64} : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%6, %1, %2) <{arg_attrs = [{llvm.align = 16 : i64}, {llvm.align = 16 : i64}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %7 = llvm.mul %arg1, %3 overflow<nsw> : i32
    llvm.br ^bb1(%7 : i32)
  ^bb1(%8: i32):  // 2 preds: ^bb0, ^bb2
    %9 = llvm.icmp "sgt" %8, %4 : i32
    llvm.cond_br %9, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %10 = llvm.sext %arg2 : i32 to i64
    %11 = llvm.getelementptr inbounds %6[%5, %10] : (!llvm.ptr, i64, i64) -> !llvm.ptr, !llvm.array<2 x ptr>
    %12 = llvm.load %11 <alignment = 8> : !llvm.ptr -> !llvm.ptr
    llvm.call @sqlite3_str_append(%arg0, %12, %4) : (!llvm.ptr {llvm.noundef}, !llvm.ptr {llvm.noundef}, i32 {llvm.noundef}) -> ()
    %13 = llvm.sub %8, %4 overflow<nsw> : i32
    llvm.br ^bb1(%13 : i32) loop_annotation = #loop_annotation
  ^bb3:  // pred: ^bb1
    %14 = llvm.sext %arg2 : i32 to i64
    %15 = llvm.getelementptr inbounds %6[%5, %14] : (!llvm.ptr, i64, i64) -> !llvm.ptr, !llvm.array<2 x ptr>
    %16 = llvm.load %15 <alignment = 8> : !llvm.ptr -> !llvm.ptr
    llvm.call @sqlite3_str_append(%arg0, %16, %8) : (!llvm.ptr {llvm.noundef}, !llvm.ptr {llvm.noundef}, i32 {llvm.noundef}) -> ()
    llvm.return
  }
}
