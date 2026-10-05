; ModuleID = 'sqlite3.ll'
source_filename = "sqlite-amalgamation-3530400/sqlite3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind sspstrong uwtable
define hidden i32 @vdbeSorterTreeDepth(i32 noundef %0) #0 {
  br label %2

2:                                                ; preds = %5, %1
  %.01 = phi i32 [ 0, %1 ], [ %7, %5 ]
  %.0 = phi i64 [ 16, %1 ], [ %6, %5 ]
  %3 = sext i32 %0 to i64
  %4 = icmp slt i64 %.0, %3
  br i1 %4, label %5, label %8

5:                                                ; preds = %2
  %6 = mul nsw i64 %.0, 16
  %7 = add nsw i32 %.01, 1
  br label %2, !llvm.loop !5

8:                                                ; preds = %2
  ret i32 %.01
}

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{!"clang version 23.1.1"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
