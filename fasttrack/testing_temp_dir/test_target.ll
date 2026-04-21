; ModuleID = 'test.ll'
source_filename = "../targets/old_targets_dhruv/test_efficiency.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.PaddedLong = type { i64, [56 x i8] }
%struct.timespec = type { i64, i64 }

@_ZL9solo_vars = internal global [8 x %struct.PaddedLong] zeroinitializer, align 16, !dbg !0
@_ZL8race_var = internal global %struct.PaddedLong zeroinitializer, align 8, !dbg !51
@.str = private unnamed_addr constant [35 x i8] c"Launch to finish        : %llu ms\0A\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [47 x i8] c"Gate opened at          : %llu ms from launch\0A\00", align 1, !dbg !21
@.str.2 = private unnamed_addr constant [60 x i8] c"\0A--- Expected solo_vars[i] = %d (each thread ran solo) ---\0A\00", align 1, !dbg !26
@.str.3 = private unnamed_addr constant [19 x i8] c"solo_vars[%d]=%ld \00", align 1, !dbg !31
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1, !dbg !36
@.str.5 = private unnamed_addr constant [62 x i8] c"\0A--- Expected race_var < %d (racy, so updates were lost) ---\0A\00", align 1, !dbg !41
@.str.6 = private unnamed_addr constant [31 x i8] c"race_var final          : %ld\0A\00", align 1, !dbg !46

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z11solo_workerPv(ptr noundef %0) #0 !dbg !314 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !318, !DIExpression(), !319)
    #dbg_declare(ptr %3, !320, !DIExpression(), !321)
  %6 = load ptr, ptr %2, align 8, !dbg !322
  call void @__log_load(ptr %6), !dbg !323
  %7 = load i32, ptr %6, align 4, !dbg !323
  store i32 %7, ptr %3, align 4, !dbg !321
    #dbg_declare(ptr %4, !324, !DIExpression(), !326)
  store i32 0, ptr %4, align 4, !dbg !326
  br label %8, !dbg !327

8:                                                ; preds = %24, %1
  %9 = load i32, ptr %4, align 4, !dbg !328
  %10 = icmp slt i32 %9, 10000, !dbg !330
  br i1 %10, label %11, label %27, !dbg !331

11:                                               ; preds = %8
    #dbg_declare(ptr %5, !332, !DIExpression(), !334)
  %12 = load i32, ptr %3, align 4, !dbg !335
  %13 = sext i32 %12 to i64, !dbg !336
  %14 = getelementptr inbounds [8 x %struct.PaddedLong], ptr @_ZL9solo_vars, i64 0, i64 %13, !dbg !336
  %15 = getelementptr inbounds nuw %struct.PaddedLong, ptr %14, i32 0, i32 0, !dbg !337
  call void @__log_load(ptr %15), !dbg !337
  %16 = load i64, ptr %15, align 16, !dbg !337
  store i64 %16, ptr %5, align 8, !dbg !334
  %17 = load i64, ptr %5, align 8, !dbg !338
  %18 = add nsw i64 %17, 1, !dbg !339
  store i64 %18, ptr %5, align 8, !dbg !340
  %19 = load i64, ptr %5, align 8, !dbg !341
  %20 = load i32, ptr %3, align 4, !dbg !342
  %21 = sext i32 %20 to i64, !dbg !343
  %22 = getelementptr inbounds [8 x %struct.PaddedLong], ptr @_ZL9solo_vars, i64 0, i64 %21, !dbg !343
  %23 = getelementptr inbounds nuw %struct.PaddedLong, ptr %22, i32 0, i32 0, !dbg !344
  call void @__log_store(ptr %23), !dbg !345
  store i64 %19, ptr %23, align 16, !dbg !345
  br label %24, !dbg !346

24:                                               ; preds = %11
  %25 = load i32, ptr %4, align 4, !dbg !347
  %26 = add nsw i32 %25, 1, !dbg !347
  store i32 %26, ptr %4, align 4, !dbg !347
  br label %8, !dbg !348, !llvm.loop !349

27:                                               ; preds = %8
  ret ptr null, !dbg !352
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z13shared_workerPv(ptr noundef %0) #0 !dbg !353 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !354, !DIExpression(), !355)
    #dbg_declare(ptr %3, !356, !DIExpression(), !358)
  store i32 0, ptr %3, align 4, !dbg !358
  br label %5, !dbg !359

5:                                                ; preds = %13, %1
  %6 = load i32, ptr %3, align 4, !dbg !360
  %7 = icmp slt i32 %6, 10000, !dbg !362
  br i1 %7, label %8, label %16, !dbg !363

8:                                                ; preds = %5
    #dbg_declare(ptr %4, !364, !DIExpression(), !366)
  call void @__log_load(ptr @_ZL8race_var), !dbg !367
  %9 = load i64, ptr @_ZL8race_var, align 8, !dbg !367
  store i64 %9, ptr %4, align 8, !dbg !366
  %10 = load i64, ptr %4, align 8, !dbg !368
  %11 = add nsw i64 %10, 1, !dbg !369
  store i64 %11, ptr %4, align 8, !dbg !370
  %12 = load i64, ptr %4, align 8, !dbg !371
  call void @__log_store(ptr @_ZL8race_var), !dbg !372
  store i64 %12, ptr @_ZL8race_var, align 8, !dbg !372
  br label %13, !dbg !373

13:                                               ; preds = %8
  %14 = load i32, ptr %3, align 4, !dbg !374
  %15 = add nsw i32 %14, 1, !dbg !374
  store i32 %15, ptr %3, align 4, !dbg !374
  br label %5, !dbg !375, !llvm.loop !376

16:                                               ; preds = %5
  ret ptr null, !dbg !378
}

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #1 !dbg !379 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca [8 x i64], align 16
  %4 = alloca [8 x i32], align 16
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !380, !DIExpression(), !381)
  %8 = call ptr @memset(ptr noundef @_ZL9solo_vars, i32 noundef 0, i64 noundef 512) #4, !dbg !382
  %9 = call ptr @memset(ptr noundef @_ZL8race_var, i32 noundef 0, i64 noundef 64) #4, !dbg !383
  call void @__log_store(ptr @_ZL8race_var), !dbg !384
  store i64 0, ptr @_ZL8race_var, align 8, !dbg !384
    #dbg_declare(ptr %3, !385, !DIExpression(), !389)
    #dbg_declare(ptr %4, !390, !DIExpression(), !392)
    #dbg_declare(ptr %5, !393, !DIExpression(), !394)
  %10 = call noundef i64 @_ZL6now_nsv() #5, !dbg !395
  store i64 %10, ptr %5, align 8, !dbg !394
  store i32 0, ptr %2, align 4, !dbg !396
  br label %11, !dbg !398

11:                                               ; preds = %26, %0
  %12 = load i32, ptr %2, align 4, !dbg !399
  %13 = icmp slt i32 %12, 8, !dbg !401
  br i1 %13, label %14, label %29, !dbg !402

14:                                               ; preds = %11
  %15 = load i32, ptr %2, align 4, !dbg !403
  %16 = load i32, ptr %2, align 4, !dbg !405
  %17 = sext i32 %16 to i64, !dbg !406
  %18 = getelementptr inbounds [8 x i32], ptr %4, i64 0, i64 %17, !dbg !406
  call void @__log_store(ptr %18), !dbg !407
  store i32 %15, ptr %18, align 4, !dbg !407
  %19 = load i32, ptr %2, align 4, !dbg !408
  %20 = sext i32 %19 to i64, !dbg !409
  %21 = getelementptr inbounds [8 x i64], ptr %3, i64 0, i64 %20, !dbg !409
  %22 = load i32, ptr %2, align 4, !dbg !410
  %23 = sext i32 %22 to i64, !dbg !411
  %24 = getelementptr inbounds [8 x i32], ptr %4, i64 0, i64 %23, !dbg !411
  %25 = call i32 @pthread_create(ptr noundef %21, ptr noundef null, ptr noundef @_Z11solo_workerPv, ptr noundef %24) #4, !dbg !412
  br label %26, !dbg !413

26:                                               ; preds = %14
  %27 = load i32, ptr %2, align 4, !dbg !414
  %28 = add nsw i32 %27, 1, !dbg !414
  store i32 %28, ptr %2, align 4, !dbg !414
  br label %11, !dbg !415, !llvm.loop !416

29:                                               ; preds = %11
  store i32 0, ptr %2, align 4, !dbg !418
  br label %30, !dbg !420

30:                                               ; preds = %39, %29
  %31 = load i32, ptr %2, align 4, !dbg !421
  %32 = icmp slt i32 %31, 8, !dbg !423
  br i1 %32, label %33, label %42, !dbg !424

33:                                               ; preds = %30
  %34 = load i32, ptr %2, align 4, !dbg !425
  %35 = sext i32 %34 to i64, !dbg !427
  %36 = getelementptr inbounds [8 x i64], ptr %3, i64 0, i64 %35, !dbg !427
  call void @__log_load(ptr %36), !dbg !427
  %37 = load i64, ptr %36, align 8, !dbg !427
  %38 = call i32 @pthread_join(i64 noundef %37, ptr noundef null) #5, !dbg !428
  br label %39, !dbg !429

39:                                               ; preds = %33
  %40 = load i32, ptr %2, align 4, !dbg !430
  %41 = add nsw i32 %40, 1, !dbg !430
  store i32 %41, ptr %2, align 4, !dbg !430
  br label %30, !dbg !431, !llvm.loop !432

42:                                               ; preds = %30
    #dbg_declare(ptr %6, !434, !DIExpression(), !435)
  %43 = call noundef i64 @_ZL6now_nsv() #5, !dbg !436
  store i64 %43, ptr %6, align 8, !dbg !435
  store i32 0, ptr %2, align 4, !dbg !437
  br label %44, !dbg !439

44:                                               ; preds = %55, %42
  %45 = load i32, ptr %2, align 4, !dbg !440
  %46 = icmp slt i32 %45, 8, !dbg !442
  br i1 %46, label %47, label %58, !dbg !443

47:                                               ; preds = %44
  %48 = load i32, ptr %2, align 4, !dbg !444
  %49 = sext i32 %48 to i64, !dbg !446
  %50 = getelementptr inbounds [8 x i64], ptr %3, i64 0, i64 %49, !dbg !446
  %51 = load i32, ptr %2, align 4, !dbg !447
  %52 = sext i32 %51 to i64, !dbg !448
  %53 = getelementptr inbounds [8 x i32], ptr %4, i64 0, i64 %52, !dbg !448
  %54 = call i32 @pthread_create(ptr noundef %50, ptr noundef null, ptr noundef @_Z13shared_workerPv, ptr noundef %53) #4, !dbg !449
  br label %55, !dbg !450

55:                                               ; preds = %47
  %56 = load i32, ptr %2, align 4, !dbg !451
  %57 = add nsw i32 %56, 1, !dbg !451
  store i32 %57, ptr %2, align 4, !dbg !451
  br label %44, !dbg !452, !llvm.loop !453

58:                                               ; preds = %44
  store i32 0, ptr %2, align 4, !dbg !455
  br label %59, !dbg !457

59:                                               ; preds = %68, %58
  %60 = load i32, ptr %2, align 4, !dbg !458
  %61 = icmp slt i32 %60, 8, !dbg !460
  br i1 %61, label %62, label %71, !dbg !461

62:                                               ; preds = %59
  %63 = load i32, ptr %2, align 4, !dbg !462
  %64 = sext i32 %63 to i64, !dbg !464
  %65 = getelementptr inbounds [8 x i64], ptr %3, i64 0, i64 %64, !dbg !464
  call void @__log_load(ptr %65), !dbg !464
  %66 = load i64, ptr %65, align 8, !dbg !464
  %67 = call i32 @pthread_join(i64 noundef %66, ptr noundef null) #5, !dbg !465
  br label %68, !dbg !466

68:                                               ; preds = %62
  %69 = load i32, ptr %2, align 4, !dbg !467
  %70 = add nsw i32 %69, 1, !dbg !467
  store i32 %70, ptr %2, align 4, !dbg !467
  br label %59, !dbg !468, !llvm.loop !469

71:                                               ; preds = %59
    #dbg_declare(ptr %7, !471, !DIExpression(), !472)
  %72 = call noundef i64 @_ZL6now_nsv() #5, !dbg !473
  store i64 %72, ptr %7, align 8, !dbg !472
  %73 = load i64, ptr %7, align 8, !dbg !474
  %74 = load i64, ptr %5, align 8, !dbg !475
  %75 = sub i64 %73, %74, !dbg !476
  %76 = udiv i64 %75, 1000000, !dbg !477
  %77 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %76) #5, !dbg !478
  %78 = load i64, ptr %6, align 8, !dbg !479
  %79 = load i64, ptr %5, align 8, !dbg !480
  %80 = sub i64 %78, %79, !dbg !481
  %81 = udiv i64 %80, 1000000, !dbg !482
  %82 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i64 noundef %81) #5, !dbg !483
  %83 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef 10000) #5, !dbg !484
  store i32 0, ptr %2, align 4, !dbg !485
  br label %84, !dbg !487

84:                                               ; preds = %95, %71
  %85 = load i32, ptr %2, align 4, !dbg !488
  %86 = icmp slt i32 %85, 8, !dbg !490
  br i1 %86, label %87, label %98, !dbg !491

87:                                               ; preds = %84
  %88 = load i32, ptr %2, align 4, !dbg !492
  %89 = load i32, ptr %2, align 4, !dbg !494
  %90 = sext i32 %89 to i64, !dbg !495
  %91 = getelementptr inbounds [8 x %struct.PaddedLong], ptr @_ZL9solo_vars, i64 0, i64 %90, !dbg !495
  %92 = getelementptr inbounds nuw %struct.PaddedLong, ptr %91, i32 0, i32 0, !dbg !496
  call void @__log_load(ptr %92), !dbg !496
  %93 = load i64, ptr %92, align 16, !dbg !496
  %94 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i32 noundef %88, i64 noundef %93) #5, !dbg !497
  br label %95, !dbg !498

95:                                               ; preds = %87
  %96 = load i32, ptr %2, align 4, !dbg !499
  %97 = add nsw i32 %96, 1, !dbg !499
  store i32 %97, ptr %2, align 4, !dbg !499
  br label %84, !dbg !500, !llvm.loop !501

98:                                               ; preds = %84
  %99 = call i32 (ptr, ...) @printf(ptr noundef @.str.4) #5, !dbg !503
  %100 = call i32 (ptr, ...) @printf(ptr noundef @.str.5, i32 noundef 80000) #5, !dbg !504
  call void @__log_load(ptr @_ZL8race_var), !dbg !505
  %101 = load i64, ptr @_ZL8race_var, align 8, !dbg !505
  %102 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, i64 noundef %101) #5, !dbg !506
  ret i32 0, !dbg !507
}

; Function Attrs: nounwind
declare ptr @memset(ptr noundef, i32 noundef, i64 noundef) #2

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef i64 @_ZL6now_nsv() #0 !dbg !508 {
  %1 = alloca %struct.timespec, align 8
    #dbg_declare(ptr %1, !511, !DIExpression(), !519)
  %2 = call i32 @clock_gettime(i32 noundef 1, ptr noundef %1) #4, !dbg !520
  %3 = getelementptr inbounds nuw %struct.timespec, ptr %1, i32 0, i32 0, !dbg !521
  call void @__log_load(ptr %3), !dbg !521
  %4 = load i64, ptr %3, align 8, !dbg !521
  %5 = mul i64 %4, 1000000000, !dbg !522
  %6 = getelementptr inbounds nuw %struct.timespec, ptr %1, i32 0, i32 1, !dbg !523
  call void @__log_load(ptr %6), !dbg !523
  %7 = load i64, ptr %6, align 8, !dbg !523
  %8 = add i64 %5, %7, !dbg !524
  ret i64 %8, !dbg !525
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

declare i32 @printf(ptr noundef, ...) #3

; Function Attrs: nounwind
declare i32 @clock_gettime(i32 noundef, ptr noundef) #2

declare void @__log_load(ptr)

declare void @__log_store(ptr)

declare void @__log_lock(ptr)

declare void @__log_unlock(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nobuiltin nounwind "no-builtins" }
attributes #5 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.linker.options = !{}
!llvm.module.flags = !{!306, !307, !308, !309, !310, !311, !312}
!llvm.ident = !{!313}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "solo_vars", linkageName: "_ZL9solo_vars", scope: !2, file: !3, line: 17, type: !303, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 20.1.8 (0ubuntu4)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !13, imports: !61, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "../targets/old_targets_dhruv/test_efficiency.cpp", directory: "/home/rahulm/work/cs636/CS636_course_project_IITK/fasttrack/testing_temp_dir", checksumkind: CSK_MD5, checksum: "1281802291a0edf146c1e333b4f2e37b")
!4 = !{!5, !7, !8}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !9, line: 27, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "006a4d9ce94ea5734db820ef3fdd4790")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !11, line: 45, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!12 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!13 = !{!14, !21, !26, !31, !36, !41, !46, !0, !51}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 85, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 280, elements: !19)
!17 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !18)
!18 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!19 = !{!20}
!20 = !DISubrange(count: 35)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 87, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 376, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 47)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 90, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 480, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 60)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 92, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 152, elements: !34)
!34 = !{!35}
!35 = !DISubrange(count: 19)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 94, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 16, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 2)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 96, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 496, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 62)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !3, line: 97, type: !48, isLocal: true, isDefinition: true)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 248, elements: !49)
!49 = !{!50}
!50 = !DISubrange(count: 31)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "race_var", linkageName: "_ZL8race_var", scope: !2, file: !3, line: 18, type: !53, isLocal: true, isDefinition: true)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PaddedLong", file: !3, line: 12, size: 512, flags: DIFlagTypePassByValue, elements: !54, identifier: "_ZTS10PaddedLong")
!54 = !{!55, !57}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !53, file: !3, line: 13, baseType: !56, size: 64)
!56 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !53, file: !3, line: 14, baseType: !58, size: 448, offset: 64)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 448, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 56)
!61 = !{!62, !69, !73, !79, !83, !90, !95, !97, !103, !107, !111, !121, !123, !127, !131, !135, !140, !144, !148, !152, !156, !164, !168, !172, !174, !178, !182, !187, !193, !197, !201, !203, !211, !215, !223, !225, !229, !233, !237, !241, !245, !250, !255, !256, !257, !258, !260, !261, !262, !263, !264, !265, !266, !268, !269, !270, !271, !272, !273, !274, !275, !279, !280, !281, !282, !283, !284, !285, !286, !287, !288, !289, !290, !291, !292, !293, !294, !295, !296, !297, !298, !299, !300, !301, !302}
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
!77 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !75, file: !65, line: 69, baseType: !56, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !75, file: !65, line: 70, baseType: !56, size: 64, offset: 64)
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
!110 = !{!56, !102}
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
!143 = !{!56, !56}
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !145, file: !72, line: 160)
!145 = !DISubprogram(name: "ldiv", scope: !65, file: !65, line: 1000, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!146 = !DISubroutineType(types: !147)
!147 = !{!74, !56, !56}
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
!185 = !{null, !186}
!186 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !188, file: !72, line: 176)
!188 = !DISubprogram(name: "strtod", scope: !65, file: !65, line: 118, type: !189, flags: DIFlagPrototyped, spFlags: 0)
!189 = !DISubroutineType(types: !190)
!190 = !{!101, !163, !191}
!191 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !192)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !139, size: 64)
!193 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !194, file: !72, line: 177)
!194 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !65, file: !65, line: 215, type: !195, flags: DIFlagPrototyped, spFlags: 0)
!195 = !DISubroutineType(types: !196)
!196 = !{!56, !163, !191, !6}
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !198, file: !72, line: 178)
!198 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !65, file: !65, line: 219, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!199 = !DISubroutineType(types: !200)
!200 = !{!12, !163, !191, !6}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !202, file: !72, line: 179)
!202 = !DISubprogram(name: "system", scope: !65, file: !65, line: 923, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !204, file: !72, line: 181)
!204 = !DISubprogram(name: "wcstombs", scope: !65, file: !65, line: 1083, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!205 = !DISubroutineType(types: !206)
!206 = !{!88, !207, !208, !88}
!207 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !139)
!208 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !209)
!209 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !210, size: 64)
!210 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !162)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !212, file: !72, line: 182)
!212 = !DISubprogram(name: "wctomb", scope: !65, file: !65, line: 1075, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!213 = !DISubroutineType(types: !214)
!214 = !{!6, !139, !162}
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !217, file: !72, line: 210)
!216 = !DINamespace(name: "__gnu_cxx", scope: null)
!217 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !65, line: 81, baseType: !218)
!218 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !65, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !219, identifier: "_ZTS7lldiv_t")
!219 = !{!220, !222}
!220 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !218, file: !65, line: 79, baseType: !221, size: 64)
!221 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !218, file: !65, line: 80, baseType: !221, size: 64, offset: 64)
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !224, file: !72, line: 216)
!224 = !DISubprogram(name: "_Exit", scope: !65, file: !65, line: 768, type: !129, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !226, file: !72, line: 222)
!226 = !DISubprogram(name: "llabs", scope: !65, file: !65, line: 984, type: !227, flags: DIFlagPrototyped, spFlags: 0)
!227 = !DISubroutineType(types: !228)
!228 = !{!221, !221}
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !230, file: !72, line: 228)
!230 = !DISubprogram(name: "lldiv", scope: !65, file: !65, line: 1004, type: !231, flags: DIFlagPrototyped, spFlags: 0)
!231 = !DISubroutineType(types: !232)
!232 = !{!217, !221, !221}
!233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !234, file: !72, line: 240)
!234 = !DISubprogram(name: "atoll", scope: !65, file: !65, line: 113, type: !235, flags: DIFlagPrototyped, spFlags: 0)
!235 = !DISubroutineType(types: !236)
!236 = !{!221, !102}
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !238, file: !72, line: 241)
!238 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !65, file: !65, line: 238, type: !239, flags: DIFlagPrototyped, spFlags: 0)
!239 = !DISubroutineType(types: !240)
!240 = !{!221, !163, !191, !6}
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !242, file: !72, line: 242)
!242 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !65, file: !65, line: 243, type: !243, flags: DIFlagPrototyped, spFlags: 0)
!243 = !DISubroutineType(types: !244)
!244 = !{!7, !163, !191, !6}
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !246, file: !72, line: 244)
!246 = !DISubprogram(name: "strtof", scope: !65, file: !65, line: 124, type: !247, flags: DIFlagPrototyped, spFlags: 0)
!247 = !DISubroutineType(types: !248)
!248 = !{!249, !163, !191}
!249 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !251, file: !72, line: 245)
!251 = !DISubprogram(name: "strtold", scope: !65, file: !65, line: 127, type: !252, flags: DIFlagPrototyped, spFlags: 0)
!252 = !DISubroutineType(types: !253)
!253 = !{!254, !163, !191}
!254 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !217, file: !72, line: 253)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !224, file: !72, line: 255)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !226, file: !72, line: 257)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !259, file: !72, line: 258)
!259 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !216, file: !72, line: 225, type: !231, flags: DIFlagPrototyped, spFlags: 0)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !230, file: !72, line: 259)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !234, file: !72, line: 261)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !246, file: !72, line: 262)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !238, file: !72, line: 263)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !242, file: !72, line: 264)
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !251, file: !72, line: 265)
!266 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !80, file: !267, line: 38)
!267 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "6b5a21b1805b4429608f31a862826533")
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !91, file: !267, line: 39)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !128, file: !267, line: 40)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !96, file: !267, line: 43)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !173, file: !267, line: 46)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !224, file: !267, line: 49)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !70, file: !267, line: 54)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !74, file: !267, line: 55)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !276, file: !267, line: 57)
!276 = !DISubprogram(name: "abs", linkageName: "_ZSt3abse", scope: !63, file: !68, line: 85, type: !277, flags: DIFlagPrototyped, spFlags: 0)
!277 = !DISubroutineType(types: !278)
!278 = !{!254, !254}
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !98, file: !267, line: 58)
!280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !104, file: !267, line: 59)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !108, file: !267, line: 60)
!282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !112, file: !267, line: 61)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !122, file: !267, line: 62)
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !259, file: !267, line: 63)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !132, file: !267, line: 64)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !136, file: !267, line: 65)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !141, file: !267, line: 66)
!288 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !145, file: !267, line: 67)
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !149, file: !267, line: 68)
!290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !153, file: !267, line: 70)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !157, file: !267, line: 71)
!292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !165, file: !267, line: 72)
!293 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !169, file: !267, line: 74)
!294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !175, file: !267, line: 75)
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !179, file: !267, line: 76)
!296 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !183, file: !267, line: 77)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !188, file: !267, line: 78)
!298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !194, file: !267, line: 79)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !198, file: !267, line: 80)
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !202, file: !267, line: 81)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !204, file: !267, line: 83)
!302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !212, file: !267, line: 84)
!303 = !DICompositeType(tag: DW_TAG_array_type, baseType: !53, size: 4096, elements: !304)
!304 = !{!305}
!305 = !DISubrange(count: 8)
!306 = !{i32 7, !"Dwarf Version", i32 5}
!307 = !{i32 2, !"Debug Info Version", i32 3}
!308 = !{i32 1, !"wchar_size", i32 4}
!309 = !{i32 8, !"PIC Level", i32 2}
!310 = !{i32 7, !"PIE Level", i32 2}
!311 = !{i32 7, !"uwtable", i32 2}
!312 = !{i32 7, !"frame-pointer", i32 2}
!313 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!314 = distinct !DISubprogram(name: "solo_worker", linkageName: "_Z11solo_workerPv", scope: !3, file: !3, line: 21, type: !315, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !317)
!315 = !DISubroutineType(types: !316)
!316 = !{!87, !87}
!317 = !{}
!318 = !DILocalVariable(name: "arg", arg: 1, scope: !314, file: !3, line: 21, type: !87)
!319 = !DILocation(line: 21, column: 25, scope: !314)
!320 = !DILocalVariable(name: "id", scope: !314, file: !3, line: 22, type: !6)
!321 = !DILocation(line: 22, column: 9, scope: !314)
!322 = !DILocation(line: 22, column: 21, scope: !314)
!323 = !DILocation(line: 22, column: 14, scope: !314)
!324 = !DILocalVariable(name: "i", scope: !325, file: !3, line: 23, type: !6)
!325 = distinct !DILexicalBlock(scope: !314, file: !3, line: 23, column: 5)
!326 = !DILocation(line: 23, column: 14, scope: !325)
!327 = !DILocation(line: 23, column: 10, scope: !325)
!328 = !DILocation(line: 23, column: 21, scope: !329)
!329 = distinct !DILexicalBlock(scope: !325, file: !3, line: 23, column: 5)
!330 = !DILocation(line: 23, column: 23, scope: !329)
!331 = !DILocation(line: 23, column: 5, scope: !325)
!332 = !DILocalVariable(name: "v", scope: !333, file: !3, line: 24, type: !56)
!333 = distinct !DILexicalBlock(scope: !329, file: !3, line: 23, column: 42)
!334 = !DILocation(line: 24, column: 14, scope: !333)
!335 = !DILocation(line: 24, column: 28, scope: !333)
!336 = !DILocation(line: 24, column: 18, scope: !333)
!337 = !DILocation(line: 24, column: 32, scope: !333)
!338 = !DILocation(line: 25, column: 13, scope: !333)
!339 = !DILocation(line: 25, column: 15, scope: !333)
!340 = !DILocation(line: 25, column: 11, scope: !333)
!341 = !DILocation(line: 26, column: 31, scope: !333)
!342 = !DILocation(line: 26, column: 19, scope: !333)
!343 = !DILocation(line: 26, column: 9, scope: !333)
!344 = !DILocation(line: 26, column: 23, scope: !333)
!345 = !DILocation(line: 26, column: 29, scope: !333)
!346 = !DILocation(line: 27, column: 5, scope: !333)
!347 = !DILocation(line: 23, column: 38, scope: !329)
!348 = !DILocation(line: 23, column: 5, scope: !329)
!349 = distinct !{!349, !331, !350, !351}
!350 = !DILocation(line: 27, column: 5, scope: !325)
!351 = !{!"llvm.loop.mustprogress"}
!352 = !DILocation(line: 28, column: 5, scope: !314)
!353 = distinct !DISubprogram(name: "shared_worker", linkageName: "_Z13shared_workerPv", scope: !3, file: !3, line: 32, type: !315, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !317)
!354 = !DILocalVariable(name: "arg", arg: 1, scope: !353, file: !3, line: 32, type: !87)
!355 = !DILocation(line: 32, column: 27, scope: !353)
!356 = !DILocalVariable(name: "i", scope: !357, file: !3, line: 33, type: !6)
!357 = distinct !DILexicalBlock(scope: !353, file: !3, line: 33, column: 5)
!358 = !DILocation(line: 33, column: 14, scope: !357)
!359 = !DILocation(line: 33, column: 10, scope: !357)
!360 = !DILocation(line: 33, column: 21, scope: !361)
!361 = distinct !DILexicalBlock(scope: !357, file: !3, line: 33, column: 5)
!362 = !DILocation(line: 33, column: 23, scope: !361)
!363 = !DILocation(line: 33, column: 5, scope: !357)
!364 = !DILocalVariable(name: "v", scope: !365, file: !3, line: 34, type: !56)
!365 = distinct !DILexicalBlock(scope: !361, file: !3, line: 33, column: 44)
!366 = !DILocation(line: 34, column: 14, scope: !365)
!367 = !DILocation(line: 34, column: 27, scope: !365)
!368 = !DILocation(line: 35, column: 13, scope: !365)
!369 = !DILocation(line: 35, column: 15, scope: !365)
!370 = !DILocation(line: 35, column: 11, scope: !365)
!371 = !DILocation(line: 36, column: 26, scope: !365)
!372 = !DILocation(line: 36, column: 24, scope: !365)
!373 = !DILocation(line: 37, column: 5, scope: !365)
!374 = !DILocation(line: 33, column: 40, scope: !361)
!375 = !DILocation(line: 33, column: 5, scope: !361)
!376 = distinct !{!376, !363, !377, !351}
!377 = !DILocation(line: 37, column: 5, scope: !357)
!378 = !DILocation(line: 38, column: 5, scope: !353)
!379 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 47, type: !176, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !317)
!380 = !DILocalVariable(name: "i", scope: !379, file: !3, line: 48, type: !6)
!381 = !DILocation(line: 48, column: 9, scope: !379)
!382 = !DILocation(line: 49, column: 5, scope: !379)
!383 = !DILocation(line: 50, column: 5, scope: !379)
!384 = !DILocation(line: 51, column: 20, scope: !379)
!385 = !DILocalVariable(name: "threads", scope: !379, file: !3, line: 53, type: !386)
!386 = !DICompositeType(tag: DW_TAG_array_type, baseType: !387, size: 512, elements: !304)
!387 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !388, line: 27, baseType: !12)
!388 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8e06fe5d0f3f3d4ee6a7a8929dd2b809")
!389 = !DILocation(line: 53, column: 15, scope: !379)
!390 = !DILocalVariable(name: "ids", scope: !379, file: !3, line: 54, type: !391)
!391 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 256, elements: !304)
!392 = !DILocation(line: 54, column: 15, scope: !379)
!393 = !DILocalVariable(name: "launch_ns", scope: !379, file: !3, line: 56, type: !8)
!394 = !DILocation(line: 56, column: 14, scope: !379)
!395 = !DILocation(line: 56, column: 26, scope: !379)
!396 = !DILocation(line: 59, column: 12, scope: !397)
!397 = distinct !DILexicalBlock(scope: !379, file: !3, line: 59, column: 5)
!398 = !DILocation(line: 59, column: 10, scope: !397)
!399 = !DILocation(line: 59, column: 17, scope: !400)
!400 = distinct !DILexicalBlock(scope: !397, file: !3, line: 59, column: 5)
!401 = !DILocation(line: 59, column: 19, scope: !400)
!402 = !DILocation(line: 59, column: 5, scope: !397)
!403 = !DILocation(line: 60, column: 18, scope: !404)
!404 = distinct !DILexicalBlock(scope: !400, file: !3, line: 59, column: 39)
!405 = !DILocation(line: 60, column: 13, scope: !404)
!406 = !DILocation(line: 60, column: 9, scope: !404)
!407 = !DILocation(line: 60, column: 16, scope: !404)
!408 = !DILocation(line: 61, column: 33, scope: !404)
!409 = !DILocation(line: 61, column: 25, scope: !404)
!410 = !DILocation(line: 61, column: 61, scope: !404)
!411 = !DILocation(line: 61, column: 57, scope: !404)
!412 = !DILocation(line: 61, column: 9, scope: !404)
!413 = !DILocation(line: 62, column: 5, scope: !404)
!414 = !DILocation(line: 59, column: 35, scope: !400)
!415 = !DILocation(line: 59, column: 5, scope: !400)
!416 = distinct !{!416, !402, !417, !351}
!417 = !DILocation(line: 62, column: 5, scope: !397)
!418 = !DILocation(line: 66, column: 12, scope: !419)
!419 = distinct !DILexicalBlock(scope: !379, file: !3, line: 66, column: 5)
!420 = !DILocation(line: 66, column: 10, scope: !419)
!421 = !DILocation(line: 66, column: 17, scope: !422)
!422 = distinct !DILexicalBlock(scope: !419, file: !3, line: 66, column: 5)
!423 = !DILocation(line: 66, column: 19, scope: !422)
!424 = !DILocation(line: 66, column: 5, scope: !419)
!425 = !DILocation(line: 67, column: 30, scope: !426)
!426 = distinct !DILexicalBlock(scope: !422, file: !3, line: 66, column: 39)
!427 = !DILocation(line: 67, column: 22, scope: !426)
!428 = !DILocation(line: 67, column: 9, scope: !426)
!429 = !DILocation(line: 68, column: 5, scope: !426)
!430 = !DILocation(line: 66, column: 35, scope: !422)
!431 = !DILocation(line: 66, column: 5, scope: !422)
!432 = distinct !{!432, !424, !433, !351}
!433 = !DILocation(line: 68, column: 5, scope: !419)
!434 = !DILocalVariable(name: "gate_open_ns", scope: !379, file: !3, line: 70, type: !8)
!435 = !DILocation(line: 70, column: 14, scope: !379)
!436 = !DILocation(line: 70, column: 29, scope: !379)
!437 = !DILocation(line: 74, column: 12, scope: !438)
!438 = distinct !DILexicalBlock(scope: !379, file: !3, line: 74, column: 5)
!439 = !DILocation(line: 74, column: 10, scope: !438)
!440 = !DILocation(line: 74, column: 17, scope: !441)
!441 = distinct !DILexicalBlock(scope: !438, file: !3, line: 74, column: 5)
!442 = !DILocation(line: 74, column: 19, scope: !441)
!443 = !DILocation(line: 74, column: 5, scope: !438)
!444 = !DILocation(line: 75, column: 33, scope: !445)
!445 = distinct !DILexicalBlock(scope: !441, file: !3, line: 74, column: 39)
!446 = !DILocation(line: 75, column: 25, scope: !445)
!447 = !DILocation(line: 75, column: 63, scope: !445)
!448 = !DILocation(line: 75, column: 59, scope: !445)
!449 = !DILocation(line: 75, column: 9, scope: !445)
!450 = !DILocation(line: 76, column: 5, scope: !445)
!451 = !DILocation(line: 74, column: 35, scope: !441)
!452 = !DILocation(line: 74, column: 5, scope: !441)
!453 = distinct !{!453, !443, !454, !351}
!454 = !DILocation(line: 76, column: 5, scope: !438)
!455 = !DILocation(line: 79, column: 12, scope: !456)
!456 = distinct !DILexicalBlock(scope: !379, file: !3, line: 79, column: 5)
!457 = !DILocation(line: 79, column: 10, scope: !456)
!458 = !DILocation(line: 79, column: 17, scope: !459)
!459 = distinct !DILexicalBlock(scope: !456, file: !3, line: 79, column: 5)
!460 = !DILocation(line: 79, column: 19, scope: !459)
!461 = !DILocation(line: 79, column: 5, scope: !456)
!462 = !DILocation(line: 80, column: 30, scope: !463)
!463 = distinct !DILexicalBlock(scope: !459, file: !3, line: 79, column: 39)
!464 = !DILocation(line: 80, column: 22, scope: !463)
!465 = !DILocation(line: 80, column: 9, scope: !463)
!466 = !DILocation(line: 81, column: 5, scope: !463)
!467 = !DILocation(line: 79, column: 35, scope: !459)
!468 = !DILocation(line: 79, column: 5, scope: !459)
!469 = distinct !{!469, !461, !470, !351}
!470 = !DILocation(line: 81, column: 5, scope: !456)
!471 = !DILocalVariable(name: "finish_ns", scope: !379, file: !3, line: 83, type: !8)
!472 = !DILocation(line: 83, column: 14, scope: !379)
!473 = !DILocation(line: 83, column: 26, scope: !379)
!474 = !DILocation(line: 86, column: 34, scope: !379)
!475 = !DILocation(line: 86, column: 46, scope: !379)
!476 = !DILocation(line: 86, column: 44, scope: !379)
!477 = !DILocation(line: 86, column: 57, scope: !379)
!478 = !DILocation(line: 85, column: 5, scope: !379)
!479 = !DILocation(line: 88, column: 34, scope: !379)
!480 = !DILocation(line: 88, column: 49, scope: !379)
!481 = !DILocation(line: 88, column: 47, scope: !379)
!482 = !DILocation(line: 88, column: 60, scope: !379)
!483 = !DILocation(line: 87, column: 5, scope: !379)
!484 = !DILocation(line: 90, column: 5, scope: !379)
!485 = !DILocation(line: 91, column: 12, scope: !486)
!486 = distinct !DILexicalBlock(scope: !379, file: !3, line: 91, column: 5)
!487 = !DILocation(line: 91, column: 10, scope: !486)
!488 = !DILocation(line: 91, column: 17, scope: !489)
!489 = distinct !DILexicalBlock(scope: !486, file: !3, line: 91, column: 5)
!490 = !DILocation(line: 91, column: 19, scope: !489)
!491 = !DILocation(line: 91, column: 5, scope: !486)
!492 = !DILocation(line: 92, column: 38, scope: !493)
!493 = distinct !DILexicalBlock(scope: !489, file: !3, line: 91, column: 39)
!494 = !DILocation(line: 92, column: 51, scope: !493)
!495 = !DILocation(line: 92, column: 41, scope: !493)
!496 = !DILocation(line: 92, column: 54, scope: !493)
!497 = !DILocation(line: 92, column: 9, scope: !493)
!498 = !DILocation(line: 93, column: 5, scope: !493)
!499 = !DILocation(line: 91, column: 35, scope: !489)
!500 = !DILocation(line: 91, column: 5, scope: !489)
!501 = distinct !{!501, !491, !502, !351}
!502 = !DILocation(line: 93, column: 5, scope: !486)
!503 = !DILocation(line: 94, column: 5, scope: !379)
!504 = !DILocation(line: 96, column: 5, scope: !379)
!505 = !DILocation(line: 97, column: 56, scope: !379)
!506 = !DILocation(line: 97, column: 5, scope: !379)
!507 = !DILocation(line: 99, column: 5, scope: !379)
!508 = distinct !DISubprogram(name: "now_ns", linkageName: "_ZL6now_nsv", scope: !3, file: !3, line: 41, type: !509, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !317)
!509 = !DISubroutineType(types: !510)
!510 = !{!8}
!511 = !DILocalVariable(name: "ts", scope: !508, file: !3, line: 42, type: !512)
!512 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !513, line: 11, size: 128, flags: DIFlagTypePassByValue, elements: !514, identifier: "_ZTS8timespec")
!513 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "9378e9ebbd658baccf881d3300eb1828")
!514 = !{!515, !517}
!515 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !512, file: !513, line: 16, baseType: !516, size: 64)
!516 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !11, line: 160, baseType: !56)
!517 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !512, file: !513, line: 21, baseType: !518, size: 64, offset: 64)
!518 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !11, line: 197, baseType: !56)
!519 = !DILocation(line: 42, column: 21, scope: !508)
!520 = !DILocation(line: 43, column: 5, scope: !508)
!521 = !DILocation(line: 44, column: 25, scope: !508)
!522 = !DILocation(line: 44, column: 32, scope: !508)
!523 = !DILocation(line: 44, column: 63, scope: !508)
!524 = !DILocation(line: 44, column: 48, scope: !508)
!525 = !DILocation(line: 44, column: 5, scope: !508)
