; ModuleID = 'shell.ll'
source_filename = "sqlite-amalgamation-3530400/shell.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.qrfBoxLine.azDash = external hidden unnamed_addr constant [2 x ptr], align 16

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #0

declare void @sqlite3_str_append(ptr noundef, ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind sspstrong uwtable
define hidden void @qrfBoxLine(ptr noundef %0, i32 noundef %1, i32 noundef %2) #2 {
  %4 = alloca [2 x ptr], align 16
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %4, ptr align 16 @__const.qrfBoxLine.azDash, i64 16, i1 false)
  %5 = mul nsw i32 %1, 3
  br label %6

6:                                                ; preds = %8, %3
  %.0 = phi i32 [ %5, %3 ], [ %12, %8 ]
  %7 = icmp sgt i32 %.0, 30
  br i1 %7, label %8, label %13

8:                                                ; preds = %6
  %9 = sext i32 %2 to i64
  %10 = getelementptr inbounds [2 x ptr], ptr %4, i64 0, i64 %9
  %11 = load ptr, ptr %10, align 8
  call void @sqlite3_str_append(ptr noundef %0, ptr noundef %11, i32 noundef 30)
  %12 = sub nsw i32 %.0, 30
  br label %6, !llvm.loop !5

13:                                               ; preds = %6
  %14 = sext i32 %2 to i64
  %15 = getelementptr inbounds [2 x ptr], ptr %4, i64 0, i64 %14
  %16 = load ptr, ptr %15, align 8
  call void @sqlite3_str_append(ptr noundef %0, ptr noundef %16, i32 noundef %.0)
  ret void
}

attributes #0 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{!"clang version 23.1.1"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
