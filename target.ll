; ModuleID = 'target.cpp'
source_filename = "target.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@shared_var = dso_local global i32 0, align 4
@my_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z13thread_workerPv(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load i32, ptr @shared_var, align 4
  store i32 %4, ptr %3, align 4
  %5 = call i32 @pthread_mutex_lock(ptr noundef @my_mutex) #4
  %6 = load i32, ptr %3, align 4
  %7 = add nsw i32 %6, 10
  store i32 %7, ptr @shared_var, align 4
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
  store i32 0, ptr %1, align 4
  %3 = call i32 @pthread_mutex_init(ptr noundef @my_mutex, ptr noundef null) #4
  store i32 5, ptr @shared_var, align 4
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @_Z13thread_workerPv, ptr noundef null) #4
  %5 = call i32 @pthread_mutex_lock(ptr noundef @my_mutex) #4
  %6 = load i32, ptr @shared_var, align 4
  %7 = add nsw i32 %6, 5
  store i32 %7, ptr @shared_var, align 4
  %8 = call i32 @pthread_mutex_unlock(ptr noundef @my_mutex) #4
  %9 = load i64, ptr %2, align 8
  %10 = call i32 @pthread_join(i64 noundef %9, ptr noundef null)
  %11 = call i32 @pthread_mutex_destroy(ptr noundef @my_mutex) #4
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(ptr noundef) #1

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
