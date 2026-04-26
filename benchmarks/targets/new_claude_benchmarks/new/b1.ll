; ModuleID = 'b1.c'
source_filename = "b1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.arg_t = type { i32 }

@.str = private unnamed_addr constant [48 x i8] c"[O1B1] volatile globals: %d threads x %d iters\0A\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"[O1B1] Done. cnt[0]=%ld\0A\00", align 1
@cnt = internal global [16 x i64] zeroinitializer, align 16
@g_int_a = internal global i32 0, align 4
@g_int_b = internal global i32 0, align 4
@g_int_c = internal global i32 0, align 4
@g_int_d = internal global i32 0, align 4
@g_long_a = internal global i64 0, align 8
@g_long_b = internal global i64 0, align 8
@g_float_a = internal global float 0.000000e+00, align 4
@g_double_a = internal global double 0.000000e+00, align 8
@status = internal global [32 x i32] zeroinitializer, align 16
@matrix = internal global [8 x [16 x i32]] zeroinitializer, align 16
@str = private unnamed_addr constant [49 x i8] c"       Expected IR loads+stores per thread: ~400\00", align 1

; Function Attrs: nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca [8 x i64], align 16
  %2 = alloca [8 x %struct.arg_t], align 16
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %1) #8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #8
  %3 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef 8, i32 noundef 2000)
  %4 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  br label %5

5:                                                ; preds = %0, %5
  %6 = phi i64 [ 0, %0 ], [ %11, %5 ]
  %7 = getelementptr inbounds nuw [8 x %struct.arg_t], ptr %2, i64 0, i64 %6
  %8 = trunc nuw nsw i64 %6 to i32
  store i32 %8, ptr %7, align 4, !tbaa !5
  %9 = getelementptr inbounds nuw [8 x i64], ptr %1, i64 0, i64 %6
  %10 = call i32 @pthread_create(ptr noundef nonnull %9, ptr noundef null, ptr noundef nonnull @worker, ptr noundef nonnull %7) #8
  %11 = add nuw nsw i64 %6, 1
  %12 = icmp eq i64 %11, 8
  br i1 %12, label %16, label %5, !llvm.loop !10

13:                                               ; preds = %16
  %14 = load volatile i64, ptr @cnt, align 16, !tbaa !13
  %15 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i64 noundef %14)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #8
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %1) #8
  ret i32 0

16:                                               ; preds = %5, %16
  %17 = phi i64 [ %21, %16 ], [ 0, %5 ]
  %18 = getelementptr inbounds nuw [8 x i64], ptr %1, i64 0, i64 %17
  %19 = load i64, ptr %18, align 8, !tbaa !13
  %20 = call i32 @pthread_join(i64 noundef %19, ptr noundef null) #8
  %21 = add nuw nsw i64 %17, 1
  %22 = icmp eq i64 %21, 8
  br i1 %22, label %13, label %16, !llvm.loop !15
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: nofree norecurse nounwind uwtable
define internal noalias noundef ptr @worker(ptr nocapture noundef readonly %0) #4 {
  %2 = load i32, ptr %0, align 4, !tbaa !5
  br label %4

3:                                                ; preds = %4
  ret ptr null

4:                                                ; preds = %1, %4
  %5 = phi i32 [ 0, %1 ], [ %6, %4 ]
  tail call fastcc void @touch_globals(i32 noundef %2, i32 noundef %5)
  tail call fastcc void @touch_status(i32 noundef %2, i32 noundef %5)
  tail call fastcc void @touch_matrix(i32 noundef %2, i32 noundef %5)
  %6 = add nuw nsw i32 %5, 1
  %7 = icmp eq i32 %6, 2000
  br i1 %7, label %3, label %4, !llvm.loop !16
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: nofree noinline norecurse nounwind memory(readwrite, argmem: none) uwtable
define internal fastcc void @touch_globals(i32 noundef %0, i32 noundef range(i32 -2147483648, 2000) %1) unnamed_addr #6 {
  %3 = load volatile i64, ptr @cnt, align 16, !tbaa !13
  %4 = sext i32 %0 to i64
  %5 = add nsw i64 %3, %4
  store volatile i64 %5, ptr @cnt, align 16, !tbaa !13
  %6 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 8), align 8, !tbaa !13
  %7 = sext i32 %1 to i64
  %8 = add nsw i64 %6, %7
  store volatile i64 %8, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 8), align 8, !tbaa !13
  %9 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 16), align 16, !tbaa !13
  %10 = xor i64 %9, %4
  store volatile i64 %10, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 16), align 16, !tbaa !13
  %11 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 24), align 8, !tbaa !13
  %12 = mul nsw i32 %1, %0
  %13 = sext i32 %12 to i64
  %14 = add nsw i64 %11, %13
  store volatile i64 %14, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 24), align 8, !tbaa !13
  %15 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 32), align 16, !tbaa !13
  %16 = sub nsw i64 %15, %4
  store volatile i64 %16, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 32), align 16, !tbaa !13
  %17 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 40), align 8, !tbaa !13
  %18 = or i64 %17, %7
  store volatile i64 %18, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 40), align 8, !tbaa !13
  %19 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 48), align 16, !tbaa !13
  %20 = add nsw i64 %7, %4
  %21 = add i64 %20, %19
  store volatile i64 %21, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 48), align 16, !tbaa !13
  %22 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 56), align 8, !tbaa !13
  %23 = xor i64 %4, -1
  %24 = and i64 %22, %23
  store volatile i64 %24, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 56), align 8, !tbaa !13
  %25 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 64), align 16, !tbaa !13
  %26 = add nsw i64 %25, 1
  store volatile i64 %26, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 64), align 16, !tbaa !13
  %27 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 72), align 8, !tbaa !13
  %28 = add nsw i64 %27, %4
  store volatile i64 %28, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 72), align 8, !tbaa !13
  %29 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 80), align 16, !tbaa !13
  %30 = sub nsw i64 %29, %7
  store volatile i64 %30, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 80), align 16, !tbaa !13
  %31 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 88), align 8, !tbaa !13
  %32 = xor i32 %1, %0
  %33 = sext i32 %32 to i64
  %34 = add nsw i64 %31, %33
  store volatile i64 %34, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 88), align 8, !tbaa !13
  %35 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 96), align 16, !tbaa !13
  %36 = or i32 %0, 1
  %37 = sext i32 %36 to i64
  %38 = mul nsw i64 %35, %37
  store volatile i64 %38, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 96), align 16, !tbaa !13
  %39 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 104), align 8, !tbaa !13
  %40 = add nsw i64 %7, 1
  %41 = add i64 %40, %39
  store volatile i64 %41, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 104), align 8, !tbaa !13
  %42 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 112), align 16, !tbaa !13
  %43 = add nsw i32 %1, %0
  %44 = sext i32 %43 to i64
  %45 = xor i64 %42, %44
  store volatile i64 %45, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 112), align 16, !tbaa !13
  %46 = load volatile i64, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 120), align 8, !tbaa !13
  %47 = mul nsw i32 %0, 3
  %48 = sext i32 %47 to i64
  %49 = add nsw i64 %46, %48
  store volatile i64 %49, ptr getelementptr inbounds nuw (i8, ptr @cnt, i64 120), align 8, !tbaa !13
  %50 = load volatile i32, ptr @g_int_a, align 4, !tbaa !17
  %51 = add nsw i32 %50, %0
  store volatile i32 %51, ptr @g_int_a, align 4, !tbaa !17
  %52 = load volatile i32, ptr @g_int_b, align 4, !tbaa !17
  %53 = xor i32 %52, %1
  store volatile i32 %53, ptr @g_int_b, align 4, !tbaa !17
  %54 = load volatile i32, ptr @g_int_c, align 4, !tbaa !17
  %55 = and i32 %1, %0
  %56 = add nsw i32 %54, %55
  store volatile i32 %56, ptr @g_int_c, align 4, !tbaa !17
  %57 = load volatile i32, ptr @g_int_d, align 4, !tbaa !17
  %58 = sub nsw i32 %57, %0
  store volatile i32 %58, ptr @g_int_d, align 4, !tbaa !17
  %59 = load volatile i64, ptr @g_long_a, align 8, !tbaa !13
  %60 = add nsw i64 %59, %7
  store volatile i64 %60, ptr @g_long_a, align 8, !tbaa !13
  %61 = load volatile i64, ptr @g_long_b, align 8, !tbaa !13
  %62 = xor i64 %61, %4
  store volatile i64 %62, ptr @g_long_b, align 8, !tbaa !13
  %63 = load volatile float, ptr @g_float_a, align 4, !tbaa !18
  %64 = sitofp i32 %0 to float
  %65 = fadd float %63, %64
  store volatile float %65, ptr @g_float_a, align 4, !tbaa !18
  %66 = load volatile double, ptr @g_double_a, align 8, !tbaa !20
  %67 = sitofp i32 %1 to double
  %68 = fadd double %66, %67
  store volatile double %68, ptr @g_double_a, align 8, !tbaa !20
  ret void
}

; Function Attrs: nofree noinline norecurse nounwind memory(readwrite, argmem: none) uwtable
define internal fastcc void @touch_status(i32 noundef %0, i32 noundef range(i32 -2147483648, 2000) %1) unnamed_addr #6 {
  br label %4

3:                                                ; preds = %4
  ret void

4:                                                ; preds = %2, %4
  %5 = phi i64 [ 0, %2 ], [ %12, %4 ]
  %6 = getelementptr inbounds nuw [32 x i32], ptr @status, i64 0, i64 %5
  %7 = load volatile i32, ptr %6, align 4, !tbaa !17
  %8 = trunc nuw nsw i64 %5 to i32
  %9 = and i32 %1, %8
  %10 = add i32 %9, %0
  %11 = add i32 %10, %7
  store volatile i32 %11, ptr %6, align 4, !tbaa !17
  %12 = add nuw nsw i64 %5, 1
  %13 = icmp eq i64 %12, 32
  br i1 %13, label %3, label %4, !llvm.loop !22
}

; Function Attrs: nofree noinline norecurse nounwind memory(readwrite, argmem: none) uwtable
define internal fastcc void @touch_matrix(i32 noundef %0, i32 noundef range(i32 -2147483648, 2000) %1) unnamed_addr #6 {
  br label %3

3:                                                ; preds = %2, %8
  %4 = phi i64 [ 0, %2 ], [ %9, %8 ]
  %5 = trunc i64 %4 to i32
  %6 = mul i32 %0, %5
  br label %11

7:                                                ; preds = %8
  ret void

8:                                                ; preds = %11
  %9 = add nuw nsw i64 %4, 1
  %10 = icmp eq i64 %9, 8
  br i1 %10, label %7, label %3, !llvm.loop !23

11:                                               ; preds = %3, %11
  %12 = phi i64 [ 0, %3 ], [ %19, %11 ]
  %13 = getelementptr inbounds nuw [8 x [16 x i32]], ptr @matrix, i64 0, i64 %4, i64 %12
  %14 = load volatile i32, ptr %13, align 4, !tbaa !17
  %15 = trunc i64 %12 to i32
  %16 = mul i32 %1, %15
  %17 = add i32 %16, %6
  %18 = add i32 %17, %14
  store volatile i32 %18, ptr %13, align 4, !tbaa !17
  %19 = add nuw nsw i64 %12, 1
  %20 = icmp eq i64 %19, 16
  br i1 %20, label %8, label %11, !llvm.loop !24
}

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr nocapture noundef readonly) local_unnamed_addr #7

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree norecurse nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree noinline norecurse nounwind memory(readwrite, argmem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nofree nounwind }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!5 = !{!6, !7, i64 0}
!6 = !{!"", !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = !{!14, !14, i64 0}
!14 = !{!"long", !8, i64 0}
!15 = distinct !{!15, !11, !12}
!16 = distinct !{!16, !11, !12}
!17 = !{!7, !7, i64 0}
!18 = !{!19, !19, i64 0}
!19 = !{!"float", !8, i64 0}
!20 = !{!21, !21, i64 0}
!21 = !{!"double", !8, i64 0}
!22 = distinct !{!22, !11, !12}
!23 = distinct !{!23, !11, !12}
!24 = distinct !{!24, !11, !12}
