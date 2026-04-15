; ModuleID = 'target.ll'
source_filename = "target.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@shared_var = dso_local global i32 0, align 4
@my_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8
@0 = private unnamed_addr constant [32 x i8] c"  store ptr %0, ptr %2, align 8\00", align 1
@1 = private unnamed_addr constant [42 x i8] c"  %4 = load i32, ptr @shared_var, align 4\00", align 1
@2 = private unnamed_addr constant [32 x i8] c"  store i32 %4, ptr %3, align 4\00", align 1
@3 = private unnamed_addr constant [33 x i8] c"  %6 = load i32, ptr %3, align 4\00", align 1
@4 = private unnamed_addr constant [41 x i8] c"  store i32 %7, ptr @shared_var, align 4\00", align 1
@5 = private unnamed_addr constant [31 x i8] c"  store i32 0, ptr %1, align 4\00", align 1
@6 = private unnamed_addr constant [40 x i8] c"  store i32 5, ptr @shared_var, align 4\00", align 1
@7 = private unnamed_addr constant [33 x i8] c"  %6 = load i64, ptr %2, align 8\00", align 1
@8 = private unnamed_addr constant [42 x i8] c"  %8 = load i32, ptr @shared_var, align 4\00", align 1
@9 = private unnamed_addr constant [41 x i8] c"  store i32 %9, ptr @shared_var, align 4\00", align 1
@10 = private unnamed_addr constant [34 x i8] c"  %11 = load i64, ptr %2, align 8\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z13thread_workerPv(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  call void @__wcp_write(ptr %2, ptr @0)
  store ptr %0, ptr %2, align 8
  call void @__wcp_read(ptr @shared_var, ptr @1)
  %4 = load i32, ptr @shared_var, align 4
  call void @__wcp_write(ptr %3, ptr @2)
  store i32 %4, ptr %3, align 4
  %5 = call i32 @pthread_mutex_lock(ptr noundef @my_mutex) #4
  call void @__wcp_lock(ptr @my_mutex)
  call void @__wcp_read(ptr %3, ptr @3)
  %6 = load i32, ptr %3, align 4
  %7 = add nsw i32 %6, 10
  call void @__wcp_write(ptr @shared_var, ptr @4)
  store i32 %7, ptr @shared_var, align 4
  call void @__wcp_unlock(ptr @my_mutex)
  %8 = call i32 @pthread_mutex_unlock(ptr noundef @my_mutex) #4
  ret ptr null
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #2 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  call void @__wcp_write(ptr %1, ptr @5)
  store i32 0, ptr %1, align 4
  %3 = call i32 @pthread_mutex_init(ptr noundef @my_mutex, ptr noundef null) #4
  call void @__wcp_write(ptr @shared_var, ptr @6)
  store i32 5, ptr @shared_var, align 4
  %4 = call ptr @__wcp_prepare_context(ptr @_Z13thread_workerPv, ptr null)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_wrapper, ptr noundef %4) #4
  call void @__wcp_read(ptr %2, ptr @7)
  %6 = load i64, ptr %2, align 8
  call void @__wcp_thread_create(i64 %6)
  %7 = call i32 @pthread_mutex_lock(ptr noundef @my_mutex) #4
  call void @__wcp_lock(ptr @my_mutex)
  call void @__wcp_read(ptr @shared_var, ptr @8)
  %8 = load i32, ptr @shared_var, align 4
  %9 = add nsw i32 %8, 5
  call void @__wcp_write(ptr @shared_var, ptr @9)
  store i32 %9, ptr @shared_var, align 4
  call void @__wcp_unlock(ptr @my_mutex)
  %10 = call i32 @pthread_mutex_unlock(ptr noundef @my_mutex) #4
  call void @__wcp_read(ptr %2, ptr @10)
  %11 = load i64, ptr %2, align 8
  %12 = call i32 @pthread_join(i64 noundef %11, ptr noundef null)
  call void @__wcp_thread_join(i64 %11)
  %13 = call i32 @pthread_mutex_destroy(ptr noundef @my_mutex) #4
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(ptr noundef) #1

declare void @__wcp_read(ptr, ptr)

declare void @__wcp_write(ptr, ptr)

declare void @__wcp_lock(ptr)

declare void @__wcp_unlock(ptr)

declare void @__wcp_thread_create(i64)

declare void @__wcp_thread_join(i64)

declare ptr @__wcp_prepare_context(ptr, ptr)

declare ptr @thread_wrapper(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
