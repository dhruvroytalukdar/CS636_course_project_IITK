; ModuleID = 'test.cpp'
source_filename = "test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.timespec = type { i64, i64 }

@gl = dso_local global ptr null, align 8
@_ZL11g_vec_mutex = internal global %union.pthread_mutex_t zeroinitializer, align 8

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local void @_Z6setterPi(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  store ptr %3, ptr @gl, align 8
  ret void
}

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #1 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @_ZL23test5_escape_via_vectorv()
  ret i32 0
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL23test5_escape_via_vectorv() #2 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %4 = call i32 @pthread_mutex_lock(ptr noundef @_ZL11g_vec_mutex) #5
  call void @_Z6setterPi(ptr noundef %1)
  %5 = call i32 @pthread_mutex_unlock(ptr noundef @_ZL11g_vec_mutex) #5
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @_ZL7worker5Pv, ptr noundef null) #5
  call void @_ZL12busy_wait_msi(i32 noundef 1)
  %7 = load i32, ptr %1, align 4
  store i32 %7, ptr %3, align 4
  %8 = load i64, ptr %2, align 8
  %9 = call i32 @pthread_join(i64 noundef %8, ptr noundef null)
  store ptr null, ptr @gl, align 8
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef ptr @_ZL7worker5Pv(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = call i32 @pthread_mutex_lock(ptr noundef @_ZL11g_vec_mutex) #5
  %5 = load ptr, ptr @gl, align 8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %8

7:                                                ; preds = %1
  br label %10

8:                                                ; preds = %1
  %9 = load ptr, ptr @gl, align 8
  br label %10

10:                                               ; preds = %8, %7
  %11 = phi ptr [ null, %7 ], [ %9, %8 ]
  store ptr %11, ptr %3, align 8
  %12 = call i32 @pthread_mutex_unlock(ptr noundef @_ZL11g_vec_mutex) #5
  %13 = load ptr, ptr %3, align 8
  %14 = icmp ne ptr %13, null
  br i1 %14, label %15, label %17

15:                                               ; preds = %10
  %16 = load ptr, ptr %3, align 8
  store i32 55, ptr %16, align 4
  br label %17

17:                                               ; preds = %15, %10
  ret ptr null
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL12busy_wait_msi(i32 noundef %0) #2 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.timespec, align 8
  store i32 %0, ptr %2, align 4
  %4 = getelementptr inbounds nuw %struct.timespec, ptr %3, i32 0, i32 0
  store i64 0, ptr %4, align 8
  %5 = getelementptr inbounds nuw %struct.timespec, ptr %3, i32 0, i32 1
  %6 = load i32, ptr %2, align 4
  %7 = sext i32 %6 to i64
  %8 = mul nsw i64 %7, 1000000
  store i64 %8, ptr %5, align 8
  %9 = call i32 @nanosleep(ptr noundef %3, ptr noundef null)
  ret void
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #4

declare i32 @nanosleep(ptr noundef, ptr noundef) #4

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
