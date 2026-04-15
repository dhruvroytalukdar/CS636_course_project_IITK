; ModuleID = 'efficiency.bc'
source_filename = "test_efficiency_no_race.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.PaddedBuffer = type { i64, [100 x i64], [64 x i8] }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.timespec = type { i64, i64 }

@_ZL14thread_buffers = internal global [4 x %struct.PaddedBuffer] zeroinitializer, align 16, !dbg !0
@_ZL9total_mtx = internal global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !26
@_ZL12global_total = internal global i64 0, align 8, !dbg !59
@.str = private unnamed_addr constant [30 x i8] c"Launch to finish   : %llu ms\0A\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [31 x i8] c"Global Total            : %ld\0A\00", align 1, !dbg !21
@0 = private unnamed_addr constant [44 x i8] c"  %7 = load i32, ptr %6, align 4, !dbg !334\00", align 1
@1 = private unnamed_addr constant [46 x i8] c"  %23 = load i64, ptr %22, align 8, !dbg !354\00", align 1
@2 = private unnamed_addr constant [45 x i8] c"  store i64 %24, ptr %22, align 8, !dbg !354\00", align 1
@3 = private unnamed_addr constant [46 x i8] c"  %33 = load i64, ptr %32, align 8, !dbg !356\00", align 1
@4 = private unnamed_addr constant [45 x i8] c"  store i64 %40, ptr %44, align 8, !dbg !371\00", align 1
@5 = private unnamed_addr constant [46 x i8] c"  %50 = load i64, ptr %49, align 8, !dbg !375\00", align 1
@6 = private unnamed_addr constant [61 x i8] c"  %51 = load i64, ptr @_ZL12global_total, align 8, !dbg !376\00", align 1
@7 = private unnamed_addr constant [60 x i8] c"  store i64 %52, ptr @_ZL12global_total, align 8, !dbg !376\00", align 1
@8 = private unnamed_addr constant [43 x i8] c"  store i64 0, ptr %18, align 8, !dbg !349\00", align 1
@9 = private unnamed_addr constant [43 x i8] c"  store i64 0, ptr %29, align 8, !dbg !363\00", align 1
@10 = private unnamed_addr constant [45 x i8] c"  store i32 %42, ptr %45, align 4, !dbg !387\00", align 1
@11 = private unnamed_addr constant [46 x i8] c"  %54 = load i64, ptr %48, align 8, !dbg !393\00", align 1
@12 = private unnamed_addr constant [46 x i8] c"  %66 = load i64, ptr %65, align 8, !dbg !408\00", align 1
@13 = private unnamed_addr constant [61 x i8] c"  %78 = load i64, ptr @_ZL12global_total, align 8, !dbg !423\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z6workerPv(ptr noundef %0) #0 !dbg !325 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !329, !DIExpression(), !330)
    #dbg_declare(ptr %3, !331, !DIExpression(), !332)
  %6 = load ptr, ptr %2, align 8, !dbg !333
  call void @__ft_read(ptr %6, ptr @0), !dbg !334
  %7 = load i32, ptr %6, align 4, !dbg !334
  store i32 %7, ptr %3, align 4, !dbg !332
    #dbg_declare(ptr %4, !335, !DIExpression(), !336)
  store i64 0, ptr %4, align 8, !dbg !336
    #dbg_declare(ptr %5, !337, !DIExpression(), !339)
  store i32 0, ptr %5, align 4, !dbg !339
  br label %8, !dbg !340

8:                                                ; preds = %36, %1
  %9 = load i32, ptr %5, align 4, !dbg !341
  %10 = icmp slt i32 %9, 5000000, !dbg !343
  br i1 %10, label %11, label %39, !dbg !344

11:                                               ; preds = %8
  %12 = load i32, ptr %5, align 4, !dbg !345
  %13 = srem i32 %12, 5, !dbg !347
  %14 = sext i32 %13 to i64, !dbg !348
  %15 = load i32, ptr %3, align 4, !dbg !349
  %16 = sext i32 %15 to i64, !dbg !350
  %17 = getelementptr inbounds [4 x %struct.PaddedBuffer], ptr @_ZL14thread_buffers, i64 0, i64 %16, !dbg !350
  %18 = getelementptr inbounds nuw %struct.PaddedBuffer, ptr %17, i32 0, i32 1, !dbg !351
  %19 = load i32, ptr %5, align 4, !dbg !352
  %20 = srem i32 %19, 100, !dbg !353
  %21 = sext i32 %20 to i64, !dbg !350
  %22 = getelementptr inbounds [100 x i64], ptr %18, i64 0, i64 %21, !dbg !350
  call void @__ft_read(ptr %22, ptr @1), !dbg !354
  %23 = load i64, ptr %22, align 8, !dbg !354
  %24 = add nsw i64 %23, %14, !dbg !354
  call void @__ft_write(ptr %22, ptr @2), !dbg !354
  store i64 %24, ptr %22, align 8, !dbg !354
  %25 = load i32, ptr %3, align 4, !dbg !355
  %26 = sext i32 %25 to i64, !dbg !356
  %27 = getelementptr inbounds [4 x %struct.PaddedBuffer], ptr @_ZL14thread_buffers, i64 0, i64 %26, !dbg !356
  %28 = getelementptr inbounds nuw %struct.PaddedBuffer, ptr %27, i32 0, i32 1, !dbg !357
  %29 = load i32, ptr %5, align 4, !dbg !358
  %30 = srem i32 %29, 100, !dbg !359
  %31 = sext i32 %30 to i64, !dbg !356
  %32 = getelementptr inbounds [100 x i64], ptr %28, i64 0, i64 %31, !dbg !356
  call void @__ft_read(ptr %32, ptr @3), !dbg !356
  %33 = load i64, ptr %32, align 8, !dbg !356
  %34 = load i64, ptr %4, align 8, !dbg !360
  %35 = add nsw i64 %34, %33, !dbg !360
  store i64 %35, ptr %4, align 8, !dbg !360
  br label %36, !dbg !361

36:                                               ; preds = %11
  %37 = load i32, ptr %5, align 4, !dbg !362
  %38 = add nsw i32 %37, 1, !dbg !362
  store i32 %38, ptr %5, align 4, !dbg !362
  br label %8, !dbg !363, !llvm.loop !364

39:                                               ; preds = %8
  %40 = load i64, ptr %4, align 8, !dbg !367
  %41 = load i32, ptr %3, align 4, !dbg !368
  %42 = sext i32 %41 to i64, !dbg !369
  %43 = getelementptr inbounds [4 x %struct.PaddedBuffer], ptr @_ZL14thread_buffers, i64 0, i64 %42, !dbg !369
  %44 = getelementptr inbounds nuw %struct.PaddedBuffer, ptr %43, i32 0, i32 0, !dbg !370
  call void @__ft_write(ptr %44, ptr @4), !dbg !371
  store i64 %40, ptr %44, align 8, !dbg !371
  %45 = call i32 @pthread_mutex_lock(ptr noundef @_ZL9total_mtx) #4, !dbg !372
  call void @__ft_lock(ptr @_ZL9total_mtx), !dbg !373
  %46 = load i32, ptr %3, align 4, !dbg !373
  %47 = sext i32 %46 to i64, !dbg !374
  %48 = getelementptr inbounds [4 x %struct.PaddedBuffer], ptr @_ZL14thread_buffers, i64 0, i64 %47, !dbg !374
  %49 = getelementptr inbounds nuw %struct.PaddedBuffer, ptr %48, i32 0, i32 0, !dbg !375
  call void @__ft_read(ptr %49, ptr @5), !dbg !375
  %50 = load i64, ptr %49, align 8, !dbg !375
  call void @__ft_read(ptr @_ZL12global_total, ptr @6), !dbg !376
  %51 = load i64, ptr @_ZL12global_total, align 8, !dbg !376
  %52 = add nsw i64 %51, %50, !dbg !376
  call void @__ft_write(ptr @_ZL12global_total, ptr @7), !dbg !376
  store i64 %52, ptr @_ZL12global_total, align 8, !dbg !376
  call void @__ft_unlock(ptr @_ZL9total_mtx), !dbg !377
  %53 = call i32 @pthread_mutex_unlock(ptr noundef @_ZL9total_mtx) #4, !dbg !377
  ret ptr null, !dbg !378
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #2 !dbg !379 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca [4 x i32], align 16
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !380, !DIExpression(), !383)
    #dbg_declare(ptr %3, !384, !DIExpression(), !386)
    #dbg_declare(ptr %4, !387, !DIExpression(), !388)
  %10 = call noundef i64 @_ZL6now_nsv() #5, !dbg !389
  store i64 %10, ptr %4, align 8, !dbg !388
    #dbg_declare(ptr %5, !390, !DIExpression(), !392)
  store i32 0, ptr %5, align 4, !dbg !392
  br label %11, !dbg !393

11:                                               ; preds = %34, %0
  %12 = load i32, ptr %5, align 4, !dbg !394
  %13 = icmp slt i32 %12, 4, !dbg !396
  br i1 %13, label %14, label %37, !dbg !397

14:                                               ; preds = %11
  %15 = load i32, ptr %5, align 4, !dbg !398
  %16 = sext i32 %15 to i64, !dbg !400
  %17 = getelementptr inbounds [4 x %struct.PaddedBuffer], ptr @_ZL14thread_buffers, i64 0, i64 %16, !dbg !400
  %18 = getelementptr inbounds nuw %struct.PaddedBuffer, ptr %17, i32 0, i32 0, !dbg !401
  call void @__ft_write(ptr %18, ptr @8), !dbg !402
  store i64 0, ptr %18, align 8, !dbg !402
    #dbg_declare(ptr %6, !403, !DIExpression(), !405)
  store i32 0, ptr %6, align 4, !dbg !405
  br label %19, !dbg !406

19:                                               ; preds = %30, %14
  %20 = load i32, ptr %6, align 4, !dbg !407
  %21 = icmp slt i32 %20, 100, !dbg !409
  br i1 %21, label %22, label %33, !dbg !410

22:                                               ; preds = %19
  %23 = load i32, ptr %5, align 4, !dbg !411
  %24 = sext i32 %23 to i64, !dbg !413
  %25 = getelementptr inbounds [4 x %struct.PaddedBuffer], ptr @_ZL14thread_buffers, i64 0, i64 %24, !dbg !413
  %26 = getelementptr inbounds nuw %struct.PaddedBuffer, ptr %25, i32 0, i32 1, !dbg !414
  %27 = load i32, ptr %6, align 4, !dbg !415
  %28 = sext i32 %27 to i64, !dbg !413
  %29 = getelementptr inbounds [100 x i64], ptr %26, i64 0, i64 %28, !dbg !413
  call void @__ft_write(ptr %29, ptr @9), !dbg !416
  store i64 0, ptr %29, align 8, !dbg !416
  br label %30, !dbg !417

30:                                               ; preds = %22
  %31 = load i32, ptr %6, align 4, !dbg !418
  %32 = add nsw i32 %31, 1, !dbg !418
  store i32 %32, ptr %6, align 4, !dbg !418
  br label %19, !dbg !419, !llvm.loop !420

33:                                               ; preds = %19
  br label %34, !dbg !422

34:                                               ; preds = %33
  %35 = load i32, ptr %5, align 4, !dbg !423
  %36 = add nsw i32 %35, 1, !dbg !423
  store i32 %36, ptr %5, align 4, !dbg !423
  br label %11, !dbg !424, !llvm.loop !425

37:                                               ; preds = %11
    #dbg_declare(ptr %7, !427, !DIExpression(), !429)
  store i32 0, ptr %7, align 4, !dbg !429
  br label %38, !dbg !430

38:                                               ; preds = %55, %37
  %39 = load i32, ptr %7, align 4, !dbg !431
  %40 = icmp slt i32 %39, 4, !dbg !433
  br i1 %40, label %41, label %58, !dbg !434

41:                                               ; preds = %38
  %42 = load i32, ptr %7, align 4, !dbg !435
  %43 = load i32, ptr %7, align 4, !dbg !437
  %44 = sext i32 %43 to i64, !dbg !438
  %45 = getelementptr inbounds [4 x i32], ptr %3, i64 0, i64 %44, !dbg !438
  call void @__ft_write(ptr %45, ptr @10), !dbg !439
  store i32 %42, ptr %45, align 4, !dbg !439
  %46 = load i32, ptr %7, align 4, !dbg !440
  %47 = sext i32 %46 to i64, !dbg !441
  %48 = getelementptr inbounds [4 x i64], ptr %2, i64 0, i64 %47, !dbg !441
  %49 = load i32, ptr %7, align 4, !dbg !442
  %50 = sext i32 %49 to i64, !dbg !443
  %51 = getelementptr inbounds [4 x i32], ptr %3, i64 0, i64 %50, !dbg !443
  %52 = call ptr @__ft_prepare_context(ptr @_Z6workerPv, ptr %51), !dbg !444
  %53 = call i32 @pthread_create(ptr noundef %48, ptr noundef null, ptr noundef @thread_wrapper, ptr noundef %52) #4, !dbg !444
  call void @__ft_read(ptr %48, ptr @11), !dbg !445
  %54 = load i64, ptr %48, align 8, !dbg !445
  call void @__ft_thread_create(i64 %54), !dbg !445
  br label %55, !dbg !445

55:                                               ; preds = %41
  %56 = load i32, ptr %7, align 4, !dbg !446
  %57 = add nsw i32 %56, 1, !dbg !446
  store i32 %57, ptr %7, align 4, !dbg !446
  br label %38, !dbg !447, !llvm.loop !448

58:                                               ; preds = %38
    #dbg_declare(ptr %8, !450, !DIExpression(), !452)
  store i32 0, ptr %8, align 4, !dbg !452
  br label %59, !dbg !453

59:                                               ; preds = %68, %58
  %60 = load i32, ptr %8, align 4, !dbg !454
  %61 = icmp slt i32 %60, 4, !dbg !456
  br i1 %61, label %62, label %71, !dbg !457

62:                                               ; preds = %59
  %63 = load i32, ptr %8, align 4, !dbg !458
  %64 = sext i32 %63 to i64, !dbg !460
  %65 = getelementptr inbounds [4 x i64], ptr %2, i64 0, i64 %64, !dbg !460
  call void @__ft_read(ptr %65, ptr @12), !dbg !460
  %66 = load i64, ptr %65, align 8, !dbg !460
  %67 = call i32 @pthread_join(i64 noundef %66, ptr noundef null) #5, !dbg !461
  call void @__ft_thread_join(i64 %66), !dbg !462
  br label %68, !dbg !462

68:                                               ; preds = %62
  %69 = load i32, ptr %8, align 4, !dbg !463
  %70 = add nsw i32 %69, 1, !dbg !463
  store i32 %70, ptr %8, align 4, !dbg !463
  br label %59, !dbg !464, !llvm.loop !465

71:                                               ; preds = %59
    #dbg_declare(ptr %9, !467, !DIExpression(), !468)
  %72 = call noundef i64 @_ZL6now_nsv() #5, !dbg !469
  store i64 %72, ptr %9, align 8, !dbg !468
  %73 = load i64, ptr %9, align 8, !dbg !470
  %74 = load i64, ptr %4, align 8, !dbg !471
  %75 = sub i64 %73, %74, !dbg !472
  %76 = udiv i64 %75, 1000000, !dbg !473
  %77 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %76) #5, !dbg !474
  call void @__ft_read(ptr @_ZL12global_total, ptr @13), !dbg !475
  %78 = load i64, ptr @_ZL12global_total, align 8, !dbg !475
  %79 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i64 noundef %78) #5, !dbg !476
  ret i32 0, !dbg !477
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef i64 @_ZL6now_nsv() #0 !dbg !478 {
  %1 = alloca %struct.timespec, align 8
    #dbg_declare(ptr %1, !481, !DIExpression(), !489)
  %2 = call i32 @clock_gettime(i32 noundef 1, ptr noundef %1) #4, !dbg !490
  %3 = getelementptr inbounds nuw %struct.timespec, ptr %1, i32 0, i32 0, !dbg !491
  %4 = load i64, ptr %3, align 8, !dbg !491
  %5 = mul i64 %4, 1000000000, !dbg !492
  %6 = getelementptr inbounds nuw %struct.timespec, ptr %1, i32 0, i32 1, !dbg !493
  %7 = load i64, ptr %6, align 8, !dbg !493
  %8 = add i64 %5, %7, !dbg !494
  ret i64 %8, !dbg !495
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

declare i32 @printf(ptr noundef, ...) #3

; Function Attrs: nounwind
declare i32 @clock_gettime(i32 noundef, ptr noundef) #1

declare void @__ft_read(ptr, ptr)

declare void @__ft_write(ptr, ptr)

declare void @__ft_lock(ptr)

declare void @__ft_unlock(ptr)

declare void @__ft_thread_create(i64)

declare void @__ft_thread_join(i64)

declare ptr @__ft_prepare_context(ptr, ptr)

declare ptr @thread_wrapper(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nobuiltin nounwind "no-builtins" }
attributes #5 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!317, !318, !319, !320, !321, !322, !323}
!llvm.ident = !{!324}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "thread_buffers", linkageName: "_ZL14thread_buffers", scope: !2, file: !3, line: 28, type: !303, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 20.1.8 (0ubuntu4)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !13, imports: !61, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "test_efficiency_no_race.cpp", directory: "/home/rahulm/work/cs636/CS636_course_project_IITK/fasttrack", checksumkind: CSK_MD5, checksum: "a634d446db45572b99c4a1d0c5a023c2")
!4 = !{!5, !7, !8}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !9, line: 27, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "006a4d9ce94ea5734db820ef3fdd4790")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !11, line: 45, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!12 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!13 = !{!14, !21, !0, !26, !59}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 93, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 240, elements: !19)
!17 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !18)
!18 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!19 = !{!20}
!20 = !DISubrange(count: 30)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 95, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 248, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 31)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "total_mtx", linkageName: "_ZL9total_mtx", scope: !2, file: !3, line: 30, type: !28, isLocal: true, isDefinition: true)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !29, line: 72, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8e06fe5d0f3f3d4ee6a7a8929dd2b809")
!30 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !29, line: 67, size: 320, flags: DIFlagTypePassByValue, elements: !31, identifier: "_ZTS15pthread_mutex_t")
!31 = !{!32, !53, !57}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !30, file: !29, line: 69, baseType: !33, size: 320)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !34, line: 22, size: 320, flags: DIFlagTypePassByValue, elements: !35, identifier: "_ZTS17__pthread_mutex_s")
!34 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "dd3989155840df74989f662ad537bbcc")
!35 = !{!36, !37, !39, !40, !41, !42, !44, !45}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !33, file: !34, line: 24, baseType: !6, size: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !33, file: !34, line: 25, baseType: !38, size: 32, offset: 32)
!38 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !33, file: !34, line: 26, baseType: !6, size: 32, offset: 64)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !33, file: !34, line: 28, baseType: !38, size: 32, offset: 96)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !33, file: !34, line: 32, baseType: !6, size: 32, offset: 128)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !33, file: !34, line: 34, baseType: !43, size: 16, offset: 160)
!43 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !33, file: !34, line: 35, baseType: !43, size: 16, offset: 176)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !33, file: !34, line: 36, baseType: !46, size: 128, offset: 192)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !47, line: 55, baseType: !48)
!47 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4de73b5923ab08445dd348713aeb0a37")
!48 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !47, line: 51, size: 128, flags: DIFlagTypePassByValue, elements: !49, identifier: "_ZTS23__pthread_internal_list")
!49 = !{!50, !52}
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !48, file: !47, line: 53, baseType: !51, size: 64)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !48, file: !47, line: 54, baseType: !51, size: 64, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !30, file: !29, line: 70, baseType: !54, size: 320)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 320, elements: !55)
!55 = !{!56}
!56 = !DISubrange(count: 40)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !30, file: !29, line: 71, baseType: !58, size: 64)
!58 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "global_total", linkageName: "_ZL12global_total", scope: !2, file: !3, line: 29, type: !58, isLocal: true, isDefinition: true)
!61 = !{!62, !69, !73, !79, !83, !90, !95, !97, !103, !107, !111, !121, !123, !127, !131, !135, !140, !144, !148, !152, !156, !164, !168, !172, !174, !178, !182, !186, !192, !196, !200, !202, !210, !214, !222, !224, !228, !232, !236, !240, !244, !249, !254, !255, !256, !257, !259, !260, !261, !262, !263, !264, !265, !267, !268, !269, !270, !271, !272, !273, !274, !279, !280, !281, !282, !283, !284, !285, !286, !287, !288, !289, !290, !291, !292, !293, !294, !295, !296, !297, !298, !299, !300, !301, !302}
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !64, file: !68, line: 58)
!63 = !DINamespace(name: "std", scope: null)
!64 = !DISubprogram(name: "abs", scope: !65, file: !65, line: 980, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!65 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "2ebb4e08912aad41774217f29ad02c9e")
!66 = !DISubroutineType(types: !67)
!67 = !{!6, !6}
!68 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/std_abs.h", directory: "", checksumkind: CSK_MD5, checksum: "b04fe3ed420747a2e528c0e678ab45db")
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !70, file: !72, line: 137)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !65, line: 63, baseType: !71)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !65, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!72 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstdlib", directory: "", checksumkind: CSK_MD5, checksum: "745c77d592b579358a91081122d152be")
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !74, file: !72, line: 138)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !65, line: 71, baseType: !75)
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !65, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !76, identifier: "_ZTS6ldiv_t")
!76 = !{!77, !78}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !75, file: !65, line: 69, baseType: !58, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !75, file: !65, line: 70, baseType: !58, size: 64, offset: 64)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !80, file: !72, line: 140)
!80 = !DISubprogram(name: "abort", scope: !65, file: !65, line: 730, type: !81, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!81 = !DISubroutineType(types: !82)
!82 = !{null}
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !84, file: !72, line: 142)
!84 = !DISubprogram(name: "aligned_alloc", scope: !65, file: !65, line: 724, type: !85, flags: DIFlagPrototyped, spFlags: 0)
!85 = !DISubroutineType(types: !86)
!86 = !{!87, !88, !88}
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !89, line: 18, baseType: !12)
!89 = !DIFile(filename: "/usr/lib/llvm-20/lib/clang/20/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !91, file: !72, line: 144)
!91 = !DISubprogram(name: "atexit", scope: !65, file: !65, line: 734, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!6, !94}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !96, file: !72, line: 147)
!96 = !DISubprogram(name: "at_quick_exit", scope: !65, file: !65, line: 739, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !98, file: !72, line: 150)
!98 = !DISubprogram(name: "atof", scope: !65, file: !65, line: 102, type: !99, flags: DIFlagPrototyped, spFlags: 0)
!99 = !DISubroutineType(types: !100)
!100 = !{!101, !102}
!101 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !104, file: !72, line: 151)
!104 = !DISubprogram(name: "atoi", scope: !65, file: !65, line: 105, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!105 = !DISubroutineType(types: !106)
!106 = !{!6, !102}
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !108, file: !72, line: 152)
!108 = !DISubprogram(name: "atol", scope: !65, file: !65, line: 108, type: !109, flags: DIFlagPrototyped, spFlags: 0)
!109 = !DISubroutineType(types: !110)
!110 = !{!58, !102}
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !112, file: !72, line: 153)
!112 = !DISubprogram(name: "bsearch", scope: !65, file: !65, line: 960, type: !113, flags: DIFlagPrototyped, spFlags: 0)
!113 = !DISubroutineType(types: !114)
!114 = !{!87, !115, !115, !88, !88, !117}
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !65, line: 948, baseType: !118)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!119 = !DISubroutineType(types: !120)
!120 = !{!6, !115, !115}
!121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !122, file: !72, line: 154)
!122 = !DISubprogram(name: "calloc", scope: !65, file: !65, line: 675, type: !85, flags: DIFlagPrototyped, spFlags: 0)
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !124, file: !72, line: 155)
!124 = !DISubprogram(name: "div", scope: !65, file: !65, line: 998, type: !125, flags: DIFlagPrototyped, spFlags: 0)
!125 = !DISubroutineType(types: !126)
!126 = !{!70, !6, !6}
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !128, file: !72, line: 156)
!128 = !DISubprogram(name: "exit", scope: !65, file: !65, line: 756, type: !129, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!129 = !DISubroutineType(types: !130)
!130 = !{null, !6}
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !132, file: !72, line: 157)
!132 = !DISubprogram(name: "free", scope: !65, file: !65, line: 687, type: !133, flags: DIFlagPrototyped, spFlags: 0)
!133 = !DISubroutineType(types: !134)
!134 = !{null, !87}
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !136, file: !72, line: 158)
!136 = !DISubprogram(name: "getenv", scope: !65, file: !65, line: 773, type: !137, flags: DIFlagPrototyped, spFlags: 0)
!137 = !DISubroutineType(types: !138)
!138 = !{!139, !102}
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !141, file: !72, line: 159)
!141 = !DISubprogram(name: "labs", scope: !65, file: !65, line: 981, type: !142, flags: DIFlagPrototyped, spFlags: 0)
!142 = !DISubroutineType(types: !143)
!143 = !{!58, !58}
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !145, file: !72, line: 160)
!145 = !DISubprogram(name: "ldiv", scope: !65, file: !65, line: 1000, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!146 = !DISubroutineType(types: !147)
!147 = !{!74, !58, !58}
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !149, file: !72, line: 161)
!149 = !DISubprogram(name: "malloc", scope: !65, file: !65, line: 672, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DISubroutineType(types: !151)
!151 = !{!87, !88}
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !153, file: !72, line: 163)
!153 = !DISubprogram(name: "mblen", scope: !65, file: !65, line: 1068, type: !154, flags: DIFlagPrototyped, spFlags: 0)
!154 = !DISubroutineType(types: !155)
!155 = !{!6, !102, !88}
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !157, file: !72, line: 164)
!157 = !DISubprogram(name: "mbstowcs", scope: !65, file: !65, line: 1079, type: !158, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DISubroutineType(types: !159)
!159 = !{!88, !160, !163, !88}
!160 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !161)
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!163 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !102)
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !165, file: !72, line: 165)
!165 = !DISubprogram(name: "mbtowc", scope: !65, file: !65, line: 1071, type: !166, flags: DIFlagPrototyped, spFlags: 0)
!166 = !DISubroutineType(types: !167)
!167 = !{!6, !160, !163, !88}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !169, file: !72, line: 167)
!169 = !DISubprogram(name: "qsort", scope: !65, file: !65, line: 970, type: !170, flags: DIFlagPrototyped, spFlags: 0)
!170 = !DISubroutineType(types: !171)
!171 = !{null, !87, !88, !88, !117}
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !173, file: !72, line: 170)
!173 = !DISubprogram(name: "quick_exit", scope: !65, file: !65, line: 762, type: !129, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !175, file: !72, line: 173)
!175 = !DISubprogram(name: "rand", scope: !65, file: !65, line: 573, type: !176, flags: DIFlagPrototyped, spFlags: 0)
!176 = !DISubroutineType(types: !177)
!177 = !{!6}
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !179, file: !72, line: 174)
!179 = !DISubprogram(name: "realloc", scope: !65, file: !65, line: 683, type: !180, flags: DIFlagPrototyped, spFlags: 0)
!180 = !DISubroutineType(types: !181)
!181 = !{!87, !87, !88}
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !183, file: !72, line: 175)
!183 = !DISubprogram(name: "srand", scope: !65, file: !65, line: 575, type: !184, flags: DIFlagPrototyped, spFlags: 0)
!184 = !DISubroutineType(types: !185)
!185 = !{null, !38}
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !187, file: !72, line: 176)
!187 = !DISubprogram(name: "strtod", scope: !65, file: !65, line: 118, type: !188, flags: DIFlagPrototyped, spFlags: 0)
!188 = !DISubroutineType(types: !189)
!189 = !{!101, !163, !190}
!190 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !191)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !139, size: 64)
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !193, file: !72, line: 177)
!193 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !65, file: !65, line: 215, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DISubroutineType(types: !195)
!195 = !{!58, !163, !190, !6}
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !197, file: !72, line: 178)
!197 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !65, file: !65, line: 219, type: !198, flags: DIFlagPrototyped, spFlags: 0)
!198 = !DISubroutineType(types: !199)
!199 = !{!12, !163, !190, !6}
!200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !201, file: !72, line: 179)
!201 = !DISubprogram(name: "system", scope: !65, file: !65, line: 923, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !203, file: !72, line: 181)
!203 = !DISubprogram(name: "wcstombs", scope: !65, file: !65, line: 1083, type: !204, flags: DIFlagPrototyped, spFlags: 0)
!204 = !DISubroutineType(types: !205)
!205 = !{!88, !206, !207, !88}
!206 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !139)
!207 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !208)
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !209, size: 64)
!209 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !162)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !211, file: !72, line: 182)
!211 = !DISubprogram(name: "wctomb", scope: !65, file: !65, line: 1075, type: !212, flags: DIFlagPrototyped, spFlags: 0)
!212 = !DISubroutineType(types: !213)
!213 = !{!6, !139, !162}
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !216, file: !72, line: 210)
!215 = !DINamespace(name: "__gnu_cxx", scope: null)
!216 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !65, line: 81, baseType: !217)
!217 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !65, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !218, identifier: "_ZTS7lldiv_t")
!218 = !{!219, !221}
!219 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !217, file: !65, line: 79, baseType: !220, size: 64)
!220 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!221 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !217, file: !65, line: 80, baseType: !220, size: 64, offset: 64)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !223, file: !72, line: 216)
!223 = !DISubprogram(name: "_Exit", scope: !65, file: !65, line: 768, type: !129, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !225, file: !72, line: 222)
!225 = !DISubprogram(name: "llabs", scope: !65, file: !65, line: 984, type: !226, flags: DIFlagPrototyped, spFlags: 0)
!226 = !DISubroutineType(types: !227)
!227 = !{!220, !220}
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !229, file: !72, line: 228)
!229 = !DISubprogram(name: "lldiv", scope: !65, file: !65, line: 1004, type: !230, flags: DIFlagPrototyped, spFlags: 0)
!230 = !DISubroutineType(types: !231)
!231 = !{!216, !220, !220}
!232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !233, file: !72, line: 240)
!233 = !DISubprogram(name: "atoll", scope: !65, file: !65, line: 113, type: !234, flags: DIFlagPrototyped, spFlags: 0)
!234 = !DISubroutineType(types: !235)
!235 = !{!220, !102}
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !237, file: !72, line: 241)
!237 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !65, file: !65, line: 238, type: !238, flags: DIFlagPrototyped, spFlags: 0)
!238 = !DISubroutineType(types: !239)
!239 = !{!220, !163, !190, !6}
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !241, file: !72, line: 242)
!241 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !65, file: !65, line: 243, type: !242, flags: DIFlagPrototyped, spFlags: 0)
!242 = !DISubroutineType(types: !243)
!243 = !{!7, !163, !190, !6}
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !245, file: !72, line: 244)
!245 = !DISubprogram(name: "strtof", scope: !65, file: !65, line: 124, type: !246, flags: DIFlagPrototyped, spFlags: 0)
!246 = !DISubroutineType(types: !247)
!247 = !{!248, !163, !190}
!248 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !215, entity: !250, file: !72, line: 245)
!250 = !DISubprogram(name: "strtold", scope: !65, file: !65, line: 127, type: !251, flags: DIFlagPrototyped, spFlags: 0)
!251 = !DISubroutineType(types: !252)
!252 = !{!253, !163, !190}
!253 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !216, file: !72, line: 253)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !223, file: !72, line: 255)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !225, file: !72, line: 257)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !258, file: !72, line: 258)
!258 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !215, file: !72, line: 225, type: !230, flags: DIFlagPrototyped, spFlags: 0)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !229, file: !72, line: 259)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !233, file: !72, line: 261)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !245, file: !72, line: 262)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !237, file: !72, line: 263)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !241, file: !72, line: 264)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !250, file: !72, line: 265)
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !80, file: !266, line: 38)
!266 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "6b5a21b1805b4429608f31a862826533")
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !91, file: !266, line: 39)
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !128, file: !266, line: 40)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !96, file: !266, line: 43)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !173, file: !266, line: 46)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !223, file: !266, line: 49)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !70, file: !266, line: 54)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !74, file: !266, line: 55)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !275, file: !266, line: 57)
!275 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !63, file: !68, line: 143, type: !276, flags: DIFlagPrototyped, spFlags: 0)
!276 = !DISubroutineType(types: !277)
!277 = !{!278, !278}
!278 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !98, file: !266, line: 58)
!280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !104, file: !266, line: 59)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !108, file: !266, line: 60)
!282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !112, file: !266, line: 61)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !122, file: !266, line: 62)
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !258, file: !266, line: 63)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !132, file: !266, line: 64)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !136, file: !266, line: 65)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !141, file: !266, line: 66)
!288 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !145, file: !266, line: 67)
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !149, file: !266, line: 68)
!290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !153, file: !266, line: 70)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !157, file: !266, line: 71)
!292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !165, file: !266, line: 72)
!293 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !169, file: !266, line: 74)
!294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !175, file: !266, line: 75)
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !179, file: !266, line: 76)
!296 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !183, file: !266, line: 77)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !187, file: !266, line: 78)
!298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !193, file: !266, line: 79)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !197, file: !266, line: 80)
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !201, file: !266, line: 81)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !203, file: !266, line: 83)
!302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !211, file: !266, line: 84)
!303 = !DICompositeType(tag: DW_TAG_array_type, baseType: !304, size: 27904, elements: !315)
!304 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PaddedBuffer", file: !3, line: 22, size: 6976, flags: DIFlagTypePassByValue, elements: !305, identifier: "_ZTS12PaddedBuffer")
!305 = !{!306, !307, !311}
!306 = !DIDerivedType(tag: DW_TAG_member, name: "local_sum", scope: !304, file: !3, line: 23, baseType: !58, size: 64)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "array", scope: !304, file: !3, line: 24, baseType: !308, size: 6400, offset: 64)
!308 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 6400, elements: !309)
!309 = !{!310}
!310 = !DISubrange(count: 100)
!311 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !304, file: !3, line: 25, baseType: !312, size: 512, offset: 6464)
!312 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 512, elements: !313)
!313 = !{!314}
!314 = !DISubrange(count: 64)
!315 = !{!316}
!316 = !DISubrange(count: 4)
!317 = !{i32 7, !"Dwarf Version", i32 5}
!318 = !{i32 2, !"Debug Info Version", i32 3}
!319 = !{i32 1, !"wchar_size", i32 4}
!320 = !{i32 8, !"PIC Level", i32 2}
!321 = !{i32 7, !"PIE Level", i32 2}
!322 = !{i32 7, !"uwtable", i32 2}
!323 = !{i32 7, !"frame-pointer", i32 2}
!324 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!325 = distinct !DISubprogram(name: "worker", linkageName: "_Z6workerPv", scope: !3, file: !3, line: 40, type: !326, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !328)
!326 = !DISubroutineType(types: !327)
!327 = !{!87, !87}
!328 = !{}
!329 = !DILocalVariable(name: "arg", arg: 1, scope: !325, file: !3, line: 40, type: !87)
!330 = !DILocation(line: 40, column: 20, scope: !325)
!331 = !DILocalVariable(name: "id", scope: !325, file: !3, line: 41, type: !6)
!332 = !DILocation(line: 41, column: 9, scope: !325)
!333 = !DILocation(line: 41, column: 21, scope: !325)
!334 = !DILocation(line: 41, column: 14, scope: !325)
!335 = !DILocalVariable(name: "temp_sum", scope: !325, file: !3, line: 45, type: !58)
!336 = !DILocation(line: 45, column: 10, scope: !325)
!337 = !DILocalVariable(name: "i", scope: !338, file: !3, line: 46, type: !6)
!338 = distinct !DILexicalBlock(scope: !325, file: !3, line: 46, column: 5)
!339 = !DILocation(line: 46, column: 14, scope: !338)
!340 = !DILocation(line: 46, column: 10, scope: !338)
!341 = !DILocation(line: 46, column: 21, scope: !342)
!342 = distinct !DILexicalBlock(scope: !338, file: !3, line: 46, column: 5)
!343 = !DILocation(line: 46, column: 23, scope: !342)
!344 = !DILocation(line: 46, column: 5, scope: !338)
!345 = !DILocation(line: 48, column: 47, scope: !346)
!346 = distinct !DILexicalBlock(scope: !342, file: !3, line: 46, column: 42)
!347 = !DILocation(line: 48, column: 49, scope: !346)
!348 = !DILocation(line: 48, column: 46, scope: !346)
!349 = !DILocation(line: 48, column: 24, scope: !346)
!350 = !DILocation(line: 48, column: 9, scope: !346)
!351 = !DILocation(line: 48, column: 28, scope: !346)
!352 = !DILocation(line: 48, column: 34, scope: !346)
!353 = !DILocation(line: 48, column: 36, scope: !346)
!354 = !DILocation(line: 48, column: 43, scope: !346)
!355 = !DILocation(line: 49, column: 36, scope: !346)
!356 = !DILocation(line: 49, column: 21, scope: !346)
!357 = !DILocation(line: 49, column: 40, scope: !346)
!358 = !DILocation(line: 49, column: 46, scope: !346)
!359 = !DILocation(line: 49, column: 48, scope: !346)
!360 = !DILocation(line: 49, column: 18, scope: !346)
!361 = !DILocation(line: 50, column: 5, scope: !346)
!362 = !DILocation(line: 46, column: 38, scope: !342)
!363 = !DILocation(line: 46, column: 5, scope: !342)
!364 = distinct !{!364, !344, !365, !366}
!365 = !DILocation(line: 50, column: 5, scope: !338)
!366 = !{!"llvm.loop.mustprogress"}
!367 = !DILocation(line: 51, column: 36, scope: !325)
!368 = !DILocation(line: 51, column: 20, scope: !325)
!369 = !DILocation(line: 51, column: 5, scope: !325)
!370 = !DILocation(line: 51, column: 24, scope: !325)
!371 = !DILocation(line: 51, column: 34, scope: !325)
!372 = !DILocation(line: 56, column: 5, scope: !325)
!373 = !DILocation(line: 57, column: 36, scope: !325)
!374 = !DILocation(line: 57, column: 21, scope: !325)
!375 = !DILocation(line: 57, column: 40, scope: !325)
!376 = !DILocation(line: 57, column: 18, scope: !325)
!377 = !DILocation(line: 58, column: 5, scope: !325)
!378 = !DILocation(line: 60, column: 5, scope: !325)
!379 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 63, type: !176, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !328)
!380 = !DILocalVariable(name: "threads", scope: !379, file: !3, line: 64, type: !381)
!381 = !DICompositeType(tag: DW_TAG_array_type, baseType: !382, size: 256, elements: !315)
!382 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !29, line: 27, baseType: !12)
!383 = !DILocation(line: 64, column: 15, scope: !379)
!384 = !DILocalVariable(name: "ids", scope: !379, file: !3, line: 65, type: !385)
!385 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 128, elements: !315)
!386 = !DILocation(line: 65, column: 9, scope: !379)
!387 = !DILocalVariable(name: "start_ns", scope: !379, file: !3, line: 66, type: !8)
!388 = !DILocation(line: 66, column: 14, scope: !379)
!389 = !DILocation(line: 66, column: 25, scope: !379)
!390 = !DILocalVariable(name: "i", scope: !391, file: !3, line: 71, type: !6)
!391 = distinct !DILexicalBlock(scope: !379, file: !3, line: 71, column: 5)
!392 = !DILocation(line: 71, column: 14, scope: !391)
!393 = !DILocation(line: 71, column: 10, scope: !391)
!394 = !DILocation(line: 71, column: 21, scope: !395)
!395 = distinct !DILexicalBlock(scope: !391, file: !3, line: 71, column: 5)
!396 = !DILocation(line: 71, column: 23, scope: !395)
!397 = !DILocation(line: 71, column: 5, scope: !391)
!398 = !DILocation(line: 72, column: 24, scope: !399)
!399 = distinct !DILexicalBlock(scope: !395, file: !3, line: 71, column: 43)
!400 = !DILocation(line: 72, column: 9, scope: !399)
!401 = !DILocation(line: 72, column: 27, scope: !399)
!402 = !DILocation(line: 72, column: 37, scope: !399)
!403 = !DILocalVariable(name: "j", scope: !404, file: !3, line: 73, type: !6)
!404 = distinct !DILexicalBlock(scope: !399, file: !3, line: 73, column: 9)
!405 = !DILocation(line: 73, column: 18, scope: !404)
!406 = !DILocation(line: 73, column: 14, scope: !404)
!407 = !DILocation(line: 73, column: 25, scope: !408)
!408 = distinct !DILexicalBlock(scope: !404, file: !3, line: 73, column: 9)
!409 = !DILocation(line: 73, column: 27, scope: !408)
!410 = !DILocation(line: 73, column: 9, scope: !404)
!411 = !DILocation(line: 74, column: 28, scope: !412)
!412 = distinct !DILexicalBlock(scope: !408, file: !3, line: 73, column: 39)
!413 = !DILocation(line: 74, column: 13, scope: !412)
!414 = !DILocation(line: 74, column: 31, scope: !412)
!415 = !DILocation(line: 74, column: 37, scope: !412)
!416 = !DILocation(line: 74, column: 40, scope: !412)
!417 = !DILocation(line: 75, column: 9, scope: !412)
!418 = !DILocation(line: 73, column: 35, scope: !408)
!419 = !DILocation(line: 73, column: 9, scope: !408)
!420 = distinct !{!420, !410, !421, !366}
!421 = !DILocation(line: 75, column: 9, scope: !404)
!422 = !DILocation(line: 76, column: 5, scope: !399)
!423 = !DILocation(line: 71, column: 39, scope: !395)
!424 = !DILocation(line: 71, column: 5, scope: !395)
!425 = distinct !{!425, !397, !426, !366}
!426 = !DILocation(line: 76, column: 5, scope: !391)
!427 = !DILocalVariable(name: "i", scope: !428, file: !3, line: 80, type: !6)
!428 = distinct !DILexicalBlock(scope: !379, file: !3, line: 80, column: 5)
!429 = !DILocation(line: 80, column: 14, scope: !428)
!430 = !DILocation(line: 80, column: 10, scope: !428)
!431 = !DILocation(line: 80, column: 21, scope: !432)
!432 = distinct !DILexicalBlock(scope: !428, file: !3, line: 80, column: 5)
!433 = !DILocation(line: 80, column: 23, scope: !432)
!434 = !DILocation(line: 80, column: 5, scope: !428)
!435 = !DILocation(line: 81, column: 18, scope: !436)
!436 = distinct !DILexicalBlock(scope: !432, file: !3, line: 80, column: 43)
!437 = !DILocation(line: 81, column: 13, scope: !436)
!438 = !DILocation(line: 81, column: 9, scope: !436)
!439 = !DILocation(line: 81, column: 16, scope: !436)
!440 = !DILocation(line: 82, column: 33, scope: !436)
!441 = !DILocation(line: 82, column: 25, scope: !436)
!442 = !DILocation(line: 82, column: 56, scope: !436)
!443 = !DILocation(line: 82, column: 52, scope: !436)
!444 = !DILocation(line: 82, column: 9, scope: !436)
!445 = !DILocation(line: 83, column: 5, scope: !436)
!446 = !DILocation(line: 80, column: 39, scope: !432)
!447 = !DILocation(line: 80, column: 5, scope: !432)
!448 = distinct !{!448, !434, !449, !366}
!449 = !DILocation(line: 83, column: 5, scope: !428)
!450 = !DILocalVariable(name: "i", scope: !451, file: !3, line: 87, type: !6)
!451 = distinct !DILexicalBlock(scope: !379, file: !3, line: 87, column: 5)
!452 = !DILocation(line: 87, column: 14, scope: !451)
!453 = !DILocation(line: 87, column: 10, scope: !451)
!454 = !DILocation(line: 87, column: 21, scope: !455)
!455 = distinct !DILexicalBlock(scope: !451, file: !3, line: 87, column: 5)
!456 = !DILocation(line: 87, column: 23, scope: !455)
!457 = !DILocation(line: 87, column: 5, scope: !451)
!458 = !DILocation(line: 88, column: 30, scope: !459)
!459 = distinct !DILexicalBlock(scope: !455, file: !3, line: 87, column: 43)
!460 = !DILocation(line: 88, column: 22, scope: !459)
!461 = !DILocation(line: 88, column: 9, scope: !459)
!462 = !DILocation(line: 89, column: 5, scope: !459)
!463 = !DILocation(line: 87, column: 39, scope: !455)
!464 = !DILocation(line: 87, column: 5, scope: !455)
!465 = distinct !{!465, !457, !466, !366}
!466 = !DILocation(line: 89, column: 5, scope: !451)
!467 = !DILocalVariable(name: "end_ns", scope: !379, file: !3, line: 91, type: !8)
!468 = !DILocation(line: 91, column: 14, scope: !379)
!469 = !DILocation(line: 91, column: 23, scope: !379)
!470 = !DILocation(line: 94, column: 34, scope: !379)
!471 = !DILocation(line: 94, column: 43, scope: !379)
!472 = !DILocation(line: 94, column: 41, scope: !379)
!473 = !DILocation(line: 94, column: 53, scope: !379)
!474 = !DILocation(line: 93, column: 5, scope: !379)
!475 = !DILocation(line: 95, column: 47, scope: !379)
!476 = !DILocation(line: 95, column: 5, scope: !379)
!477 = !DILocation(line: 97, column: 5, scope: !379)
!478 = distinct !DISubprogram(name: "now_ns", linkageName: "_ZL6now_nsv", scope: !3, file: !3, line: 33, type: !479, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !328)
!479 = !DISubroutineType(types: !480)
!480 = !{!8}
!481 = !DILocalVariable(name: "ts", scope: !478, file: !3, line: 34, type: !482)
!482 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !483, line: 11, size: 128, flags: DIFlagTypePassByValue, elements: !484, identifier: "_ZTS8timespec")
!483 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "9378e9ebbd658baccf881d3300eb1828")
!484 = !{!485, !487}
!485 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !482, file: !483, line: 16, baseType: !486, size: 64)
!486 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !11, line: 160, baseType: !58)
!487 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !482, file: !483, line: 21, baseType: !488, size: 64, offset: 64)
!488 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !11, line: 197, baseType: !58)
!489 = !DILocation(line: 34, column: 21, scope: !478)
!490 = !DILocation(line: 35, column: 5, scope: !478)
!491 = !DILocation(line: 36, column: 25, scope: !478)
!492 = !DILocation(line: 36, column: 32, scope: !478)
!493 = !DILocation(line: 36, column: 63, scope: !478)
!494 = !DILocation(line: 36, column: 48, scope: !478)
!495 = !DILocation(line: 36, column: 5, scope: !478)
