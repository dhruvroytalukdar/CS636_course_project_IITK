; ModuleID = 'build/efficiency.bc'
source_filename = "test_efficiency.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.PaddedLong = type { i64, [56 x i8] }
%struct.timespec = type { i64, i64 }

@_ZL9solo_vars = internal global [4 x %struct.PaddedLong] zeroinitializer, align 16, !dbg !0
@_ZL8race_var = internal global %struct.PaddedLong zeroinitializer, align 8, !dbg !51
@.str = private unnamed_addr constant [35 x i8] c"Launch to finish        : %llu ms\0A\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [47 x i8] c"Gate opened at          : %llu ms from launch\0A\00", align 1, !dbg !21
@.str.2 = private unnamed_addr constant [60 x i8] c"\0A--- Expected solo_vars[i] = %d (each thread ran solo) ---\0A\00", align 1, !dbg !26
@.str.3 = private unnamed_addr constant [19 x i8] c"solo_vars[%d]=%ld \00", align 1, !dbg !31
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1, !dbg !36
@.str.5 = private unnamed_addr constant [62 x i8] c"\0A--- Expected race_var < %d (racy, so updates were lost) ---\0A\00", align 1, !dbg !41
@.str.6 = private unnamed_addr constant [31 x i8] c"race_var final          : %ld\0A\00", align 1, !dbg !46
@0 = private unnamed_addr constant [44 x i8] c"  %7 = load i32, ptr %6, align 4, !dbg !324\00", align 1
@1 = private unnamed_addr constant [47 x i8] c"  %16 = load i64, ptr %15, align 16, !dbg !338\00", align 1
@2 = private unnamed_addr constant [46 x i8] c"  store i64 %19, ptr %23, align 16, !dbg !346\00", align 1
@3 = private unnamed_addr constant [55 x i8] c"  %9 = load i64, ptr @_ZL8race_var, align 8, !dbg !332\00", align 1
@4 = private unnamed_addr constant [55 x i8] c"  store i64 %12, ptr @_ZL8race_var, align 8, !dbg !337\00", align 1
@5 = private unnamed_addr constant [53 x i8] c"  store i64 0, ptr @_ZL8race_var, align 8, !dbg !321\00", align 1
@6 = private unnamed_addr constant [45 x i8] c"  store i32 %15, ptr %18, align 4, !dbg !344\00", align 1
@7 = private unnamed_addr constant [46 x i8] c"  %27 = load i64, ptr %21, align 8, !dbg !350\00", align 1
@8 = private unnamed_addr constant [46 x i8] c"  %39 = load i64, ptr %38, align 8, !dbg !365\00", align 1
@9 = private unnamed_addr constant [46 x i8] c"  %58 = load i64, ptr %52, align 8, !dbg !388\00", align 1
@10 = private unnamed_addr constant [46 x i8] c"  %70 = load i64, ptr %69, align 8, !dbg !402\00", align 1
@11 = private unnamed_addr constant [47 x i8] c"  %97 = load i64, ptr %96, align 16, !dbg !434\00", align 1
@12 = private unnamed_addr constant [57 x i8] c"  %105 = load i64, ptr @_ZL8race_var, align 8, !dbg !443\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z11solo_workerPv(ptr noundef %0) #0 !dbg !315 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !319, metadata !DIExpression()), !dbg !320
  call void @llvm.dbg.declare(metadata ptr %3, metadata !321, metadata !DIExpression()), !dbg !322
  %6 = load ptr, ptr %2, align 8, !dbg !323
  call void @__ft_read(ptr %6, ptr @0), !dbg !324
  %7 = load i32, ptr %6, align 4, !dbg !324
  store i32 %7, ptr %3, align 4, !dbg !322
  call void @llvm.dbg.declare(metadata ptr %4, metadata !325, metadata !DIExpression()), !dbg !327
  store i32 0, ptr %4, align 4, !dbg !327
  br label %8, !dbg !328

8:                                                ; preds = %24, %1
  %9 = load i32, ptr %4, align 4, !dbg !329
  %10 = icmp slt i32 %9, 1000000, !dbg !331
  br i1 %10, label %11, label %27, !dbg !332

11:                                               ; preds = %8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !333, metadata !DIExpression()), !dbg !335
  %12 = load i32, ptr %3, align 4, !dbg !336
  %13 = sext i32 %12 to i64, !dbg !337
  %14 = getelementptr inbounds [4 x %struct.PaddedLong], ptr @_ZL9solo_vars, i64 0, i64 %13, !dbg !337
  %15 = getelementptr inbounds %struct.PaddedLong, ptr %14, i32 0, i32 0, !dbg !338
  call void @__ft_read(ptr %15, ptr @1), !dbg !338
  %16 = load i64, ptr %15, align 16, !dbg !338
  store i64 %16, ptr %5, align 8, !dbg !335
  %17 = load i64, ptr %5, align 8, !dbg !339
  %18 = add nsw i64 %17, 1, !dbg !340
  store i64 %18, ptr %5, align 8, !dbg !341
  %19 = load i64, ptr %5, align 8, !dbg !342
  %20 = load i32, ptr %3, align 4, !dbg !343
  %21 = sext i32 %20 to i64, !dbg !344
  %22 = getelementptr inbounds [4 x %struct.PaddedLong], ptr @_ZL9solo_vars, i64 0, i64 %21, !dbg !344
  %23 = getelementptr inbounds %struct.PaddedLong, ptr %22, i32 0, i32 0, !dbg !345
  call void @__ft_write(ptr %23, ptr @2), !dbg !346
  store i64 %19, ptr %23, align 16, !dbg !346
  br label %24, !dbg !347

24:                                               ; preds = %11
  %25 = load i32, ptr %4, align 4, !dbg !348
  %26 = add nsw i32 %25, 1, !dbg !348
  store i32 %26, ptr %4, align 4, !dbg !348
  br label %8, !dbg !349, !llvm.loop !350

27:                                               ; preds = %8
  ret ptr null, !dbg !353
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z13shared_workerPv(ptr noundef %0) #0 !dbg !354 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !355, metadata !DIExpression()), !dbg !356
  call void @llvm.dbg.declare(metadata ptr %3, metadata !357, metadata !DIExpression()), !dbg !359
  store i32 0, ptr %3, align 4, !dbg !359
  br label %5, !dbg !360

5:                                                ; preds = %13, %1
  %6 = load i32, ptr %3, align 4, !dbg !361
  %7 = icmp slt i32 %6, 100, !dbg !363
  br i1 %7, label %8, label %16, !dbg !364

8:                                                ; preds = %5
  call void @llvm.dbg.declare(metadata ptr %4, metadata !365, metadata !DIExpression()), !dbg !367
  call void @__ft_read(ptr @_ZL8race_var, ptr @3), !dbg !368
  %9 = load i64, ptr @_ZL8race_var, align 8, !dbg !368
  store i64 %9, ptr %4, align 8, !dbg !367
  %10 = load i64, ptr %4, align 8, !dbg !369
  %11 = add nsw i64 %10, 1, !dbg !370
  store i64 %11, ptr %4, align 8, !dbg !371
  %12 = load i64, ptr %4, align 8, !dbg !372
  call void @__ft_write(ptr @_ZL8race_var, ptr @4), !dbg !373
  store i64 %12, ptr @_ZL8race_var, align 8, !dbg !373
  br label %13, !dbg !374

13:                                               ; preds = %8
  %14 = load i32, ptr %3, align 4, !dbg !375
  %15 = add nsw i32 %14, 1, !dbg !375
  store i32 %15, ptr %3, align 4, !dbg !375
  br label %5, !dbg !376, !llvm.loop !377

16:                                               ; preds = %5
  ret ptr null, !dbg !379
}

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #2 !dbg !380 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca [4 x i64], align 16
  %4 = alloca [4 x i32], align 16
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !381, metadata !DIExpression()), !dbg !382
  %8 = call ptr @memset(ptr noundef @_ZL9solo_vars, i32 noundef 0, i64 noundef 256) #5, !dbg !383
  %9 = call ptr @memset(ptr noundef @_ZL8race_var, i32 noundef 0, i64 noundef 64) #5, !dbg !384
  call void @__ft_write(ptr @_ZL8race_var, ptr @5), !dbg !385
  store i64 0, ptr @_ZL8race_var, align 8, !dbg !385
  call void @llvm.dbg.declare(metadata ptr %3, metadata !386, metadata !DIExpression()), !dbg !390
  call void @llvm.dbg.declare(metadata ptr %4, metadata !391, metadata !DIExpression()), !dbg !393
  call void @llvm.dbg.declare(metadata ptr %5, metadata !394, metadata !DIExpression()), !dbg !395
  %10 = call noundef i64 @_ZL6now_nsv() #6, !dbg !396
  store i64 %10, ptr %5, align 8, !dbg !395
  store i32 0, ptr %2, align 4, !dbg !397
  br label %11, !dbg !399

11:                                               ; preds = %28, %0
  %12 = load i32, ptr %2, align 4, !dbg !400
  %13 = icmp slt i32 %12, 4, !dbg !402
  br i1 %13, label %14, label %31, !dbg !403

14:                                               ; preds = %11
  %15 = load i32, ptr %2, align 4, !dbg !404
  %16 = load i32, ptr %2, align 4, !dbg !406
  %17 = sext i32 %16 to i64, !dbg !407
  %18 = getelementptr inbounds [4 x i32], ptr %4, i64 0, i64 %17, !dbg !407
  call void @__ft_write(ptr %18, ptr @6), !dbg !408
  store i32 %15, ptr %18, align 4, !dbg !408
  %19 = load i32, ptr %2, align 4, !dbg !409
  %20 = sext i32 %19 to i64, !dbg !410
  %21 = getelementptr inbounds [4 x i64], ptr %3, i64 0, i64 %20, !dbg !410
  %22 = load i32, ptr %2, align 4, !dbg !411
  %23 = sext i32 %22 to i64, !dbg !412
  %24 = getelementptr inbounds [4 x i32], ptr %4, i64 0, i64 %23, !dbg !412
  %25 = call ptr @__ft_prepare_context(ptr @_Z11solo_workerPv, ptr %24), !dbg !413
  %26 = call i32 @pthread_create(ptr noundef %21, ptr noundef null, ptr noundef @thread_wrapper, ptr noundef %25) #5, !dbg !413
  call void @__ft_read(ptr %21, ptr @7), !dbg !414
  %27 = load i64, ptr %21, align 8, !dbg !414
  call void @__ft_thread_create(i64 %27), !dbg !414
  br label %28, !dbg !414

28:                                               ; preds = %14
  %29 = load i32, ptr %2, align 4, !dbg !415
  %30 = add nsw i32 %29, 1, !dbg !415
  store i32 %30, ptr %2, align 4, !dbg !415
  br label %11, !dbg !416, !llvm.loop !417

31:                                               ; preds = %11
  store i32 0, ptr %2, align 4, !dbg !419
  br label %32, !dbg !421

32:                                               ; preds = %41, %31
  %33 = load i32, ptr %2, align 4, !dbg !422
  %34 = icmp slt i32 %33, 4, !dbg !424
  br i1 %34, label %35, label %44, !dbg !425

35:                                               ; preds = %32
  %36 = load i32, ptr %2, align 4, !dbg !426
  %37 = sext i32 %36 to i64, !dbg !428
  %38 = getelementptr inbounds [4 x i64], ptr %3, i64 0, i64 %37, !dbg !428
  call void @__ft_read(ptr %38, ptr @8), !dbg !428
  %39 = load i64, ptr %38, align 8, !dbg !428
  %40 = call i32 @pthread_join(i64 noundef %39, ptr noundef null) #6, !dbg !429
  call void @__ft_thread_join(i64 %39), !dbg !430
  br label %41, !dbg !430

41:                                               ; preds = %35
  %42 = load i32, ptr %2, align 4, !dbg !431
  %43 = add nsw i32 %42, 1, !dbg !431
  store i32 %43, ptr %2, align 4, !dbg !431
  br label %32, !dbg !432, !llvm.loop !433

44:                                               ; preds = %32
  call void @llvm.dbg.declare(metadata ptr %6, metadata !435, metadata !DIExpression()), !dbg !436
  %45 = call noundef i64 @_ZL6now_nsv() #6, !dbg !437
  store i64 %45, ptr %6, align 8, !dbg !436
  store i32 0, ptr %2, align 4, !dbg !438
  br label %46, !dbg !440

46:                                               ; preds = %59, %44
  %47 = load i32, ptr %2, align 4, !dbg !441
  %48 = icmp slt i32 %47, 4, !dbg !443
  br i1 %48, label %49, label %62, !dbg !444

49:                                               ; preds = %46
  %50 = load i32, ptr %2, align 4, !dbg !445
  %51 = sext i32 %50 to i64, !dbg !447
  %52 = getelementptr inbounds [4 x i64], ptr %3, i64 0, i64 %51, !dbg !447
  %53 = load i32, ptr %2, align 4, !dbg !448
  %54 = sext i32 %53 to i64, !dbg !449
  %55 = getelementptr inbounds [4 x i32], ptr %4, i64 0, i64 %54, !dbg !449
  %56 = call ptr @__ft_prepare_context(ptr @_Z13shared_workerPv, ptr %55), !dbg !450
  %57 = call i32 @pthread_create(ptr noundef %52, ptr noundef null, ptr noundef @thread_wrapper, ptr noundef %56) #5, !dbg !450
  call void @__ft_read(ptr %52, ptr @9), !dbg !451
  %58 = load i64, ptr %52, align 8, !dbg !451
  call void @__ft_thread_create(i64 %58), !dbg !451
  br label %59, !dbg !451

59:                                               ; preds = %49
  %60 = load i32, ptr %2, align 4, !dbg !452
  %61 = add nsw i32 %60, 1, !dbg !452
  store i32 %61, ptr %2, align 4, !dbg !452
  br label %46, !dbg !453, !llvm.loop !454

62:                                               ; preds = %46
  store i32 0, ptr %2, align 4, !dbg !456
  br label %63, !dbg !458

63:                                               ; preds = %72, %62
  %64 = load i32, ptr %2, align 4, !dbg !459
  %65 = icmp slt i32 %64, 4, !dbg !461
  br i1 %65, label %66, label %75, !dbg !462

66:                                               ; preds = %63
  %67 = load i32, ptr %2, align 4, !dbg !463
  %68 = sext i32 %67 to i64, !dbg !465
  %69 = getelementptr inbounds [4 x i64], ptr %3, i64 0, i64 %68, !dbg !465
  call void @__ft_read(ptr %69, ptr @10), !dbg !465
  %70 = load i64, ptr %69, align 8, !dbg !465
  %71 = call i32 @pthread_join(i64 noundef %70, ptr noundef null) #6, !dbg !466
  call void @__ft_thread_join(i64 %70), !dbg !467
  br label %72, !dbg !467

72:                                               ; preds = %66
  %73 = load i32, ptr %2, align 4, !dbg !468
  %74 = add nsw i32 %73, 1, !dbg !468
  store i32 %74, ptr %2, align 4, !dbg !468
  br label %63, !dbg !469, !llvm.loop !470

75:                                               ; preds = %63
  call void @llvm.dbg.declare(metadata ptr %7, metadata !472, metadata !DIExpression()), !dbg !473
  %76 = call noundef i64 @_ZL6now_nsv() #6, !dbg !474
  store i64 %76, ptr %7, align 8, !dbg !473
  %77 = load i64, ptr %7, align 8, !dbg !475
  %78 = load i64, ptr %5, align 8, !dbg !476
  %79 = sub i64 %77, %78, !dbg !477
  %80 = udiv i64 %79, 1000000, !dbg !478
  %81 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %80) #6, !dbg !479
  %82 = load i64, ptr %6, align 8, !dbg !480
  %83 = load i64, ptr %5, align 8, !dbg !481
  %84 = sub i64 %82, %83, !dbg !482
  %85 = udiv i64 %84, 1000000, !dbg !483
  %86 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i64 noundef %85) #6, !dbg !484
  %87 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef 1000000) #6, !dbg !485
  store i32 0, ptr %2, align 4, !dbg !486
  br label %88, !dbg !488

88:                                               ; preds = %99, %75
  %89 = load i32, ptr %2, align 4, !dbg !489
  %90 = icmp slt i32 %89, 4, !dbg !491
  br i1 %90, label %91, label %102, !dbg !492

91:                                               ; preds = %88
  %92 = load i32, ptr %2, align 4, !dbg !493
  %93 = load i32, ptr %2, align 4, !dbg !495
  %94 = sext i32 %93 to i64, !dbg !496
  %95 = getelementptr inbounds [4 x %struct.PaddedLong], ptr @_ZL9solo_vars, i64 0, i64 %94, !dbg !496
  %96 = getelementptr inbounds %struct.PaddedLong, ptr %95, i32 0, i32 0, !dbg !497
  call void @__ft_read(ptr %96, ptr @11), !dbg !497
  %97 = load i64, ptr %96, align 16, !dbg !497
  %98 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i32 noundef %92, i64 noundef %97) #6, !dbg !498
  br label %99, !dbg !499

99:                                               ; preds = %91
  %100 = load i32, ptr %2, align 4, !dbg !500
  %101 = add nsw i32 %100, 1, !dbg !500
  store i32 %101, ptr %2, align 4, !dbg !500
  br label %88, !dbg !501, !llvm.loop !502

102:                                              ; preds = %88
  %103 = call i32 (ptr, ...) @printf(ptr noundef @.str.4) #6, !dbg !504
  %104 = call i32 (ptr, ...) @printf(ptr noundef @.str.5, i32 noundef 400) #6, !dbg !505
  call void @__ft_read(ptr @_ZL8race_var, ptr @12), !dbg !506
  %105 = load i64, ptr @_ZL8race_var, align 8, !dbg !506
  %106 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, i64 noundef %105) #6, !dbg !507
  ret i32 0, !dbg !508
}

; Function Attrs: nounwind
declare ptr @memset(ptr noundef, i32 noundef, i64 noundef) #3

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef i64 @_ZL6now_nsv() #0 !dbg !509 {
  %1 = alloca %struct.timespec, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !512, metadata !DIExpression()), !dbg !520
  %2 = call i32 @clock_gettime(i32 noundef 1, ptr noundef %1) #5, !dbg !521
  %3 = getelementptr inbounds %struct.timespec, ptr %1, i32 0, i32 0, !dbg !522
  %4 = load i64, ptr %3, align 8, !dbg !522
  %5 = mul i64 %4, 1000000000, !dbg !523
  %6 = getelementptr inbounds %struct.timespec, ptr %1, i32 0, i32 1, !dbg !524
  %7 = load i64, ptr %6, align 8, !dbg !524
  %8 = add i64 %5, %7, !dbg !525
  ret i64 %8, !dbg !526
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @pthread_join(i64 noundef, ptr noundef) #4

declare i32 @printf(ptr noundef, ...) #4

; Function Attrs: nounwind
declare i32 @clock_gettime(i32 noundef, ptr noundef) #3

declare void @__ft_read(ptr, ptr)

declare void @__ft_write(ptr, ptr)

declare void @__ft_lock(ptr)

declare void @__ft_unlock(ptr)

declare void @__ft_thread_create(i64)

declare void @__ft_thread_join(i64)

declare ptr @__ft_prepare_context(ptr, ptr)

declare ptr @thread_wrapper(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nobuiltin nounwind "no-builtins" }
attributes #6 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!307, !308, !309, !310, !311, !312, !313}
!llvm.ident = !{!314}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "solo_vars", linkageName: "_ZL9solo_vars", scope: !2, file: !3, line: 17, type: !304, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !13, imports: !61, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "test_efficiency.cpp", directory: "/mnt/c/Users/dhruv/Desktop/IIT-Kanpur/Sem 2/CS636/course_project/CS636_course_project_IITK/fasttrack", checksumkind: CSK_MD5, checksum: "c3a87d23d0824334bef4579761cc29a0")
!4 = !{!5, !7, !8}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !9, line: 27, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "256fcabbefa27ca8cf5e6d37525e6e16")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !11, line: 45, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e1865d9fe29fe1b5ced550b7ba458f9e")
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
!61 = !{!62, !69, !73, !79, !83, !90, !95, !97, !103, !107, !111, !121, !123, !127, !131, !135, !140, !144, !148, !152, !156, !164, !168, !172, !174, !178, !182, !187, !193, !197, !201, !203, !211, !215, !223, !225, !229, !233, !237, !241, !245, !250, !255, !256, !257, !258, !260, !261, !262, !263, !264, !265, !266, !268, !269, !270, !271, !272, !273, !274, !275, !280, !281, !282, !283, !284, !285, !286, !287, !288, !289, !290, !291, !292, !293, !294, !295, !296, !297, !298, !299, !300, !301, !302, !303}
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !64, file: !68, line: 52)
!63 = !DINamespace(name: "std", scope: null)
!64 = !DISubprogram(name: "abs", scope: !65, file: !65, line: 980, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!65 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!66 = !DISubroutineType(types: !67)
!67 = !{!6, !6}
!68 = !DIFile(filename: "/usr/bin/../lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !70, file: !72, line: 131)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !65, line: 63, baseType: !71)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !65, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!72 = !DIFile(filename: "/usr/bin/../lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/cstdlib", directory: "")
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !74, file: !72, line: 132)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !65, line: 71, baseType: !75)
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !65, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !76, identifier: "_ZTS6ldiv_t")
!76 = !{!77, !78}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !75, file: !65, line: 69, baseType: !56, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !75, file: !65, line: 70, baseType: !56, size: 64, offset: 64)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !80, file: !72, line: 134)
!80 = !DISubprogram(name: "abort", scope: !65, file: !65, line: 730, type: !81, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!81 = !DISubroutineType(types: !82)
!82 = !{null}
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !84, file: !72, line: 136)
!84 = !DISubprogram(name: "aligned_alloc", scope: !65, file: !65, line: 724, type: !85, flags: DIFlagPrototyped, spFlags: 0)
!85 = !DISubroutineType(types: !86)
!86 = !{!87, !88, !88}
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !89, line: 18, baseType: !12)
!89 = !DIFile(filename: "/usr/lib/llvm-18/lib/clang/18/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !91, file: !72, line: 138)
!91 = !DISubprogram(name: "atexit", scope: !65, file: !65, line: 734, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!6, !94}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !96, file: !72, line: 141)
!96 = !DISubprogram(name: "at_quick_exit", scope: !65, file: !65, line: 739, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !98, file: !72, line: 144)
!98 = !DISubprogram(name: "atof", scope: !65, file: !65, line: 102, type: !99, flags: DIFlagPrototyped, spFlags: 0)
!99 = !DISubroutineType(types: !100)
!100 = !{!101, !102}
!101 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !104, file: !72, line: 145)
!104 = !DISubprogram(name: "atoi", scope: !65, file: !65, line: 105, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!105 = !DISubroutineType(types: !106)
!106 = !{!6, !102}
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !108, file: !72, line: 146)
!108 = !DISubprogram(name: "atol", scope: !65, file: !65, line: 108, type: !109, flags: DIFlagPrototyped, spFlags: 0)
!109 = !DISubroutineType(types: !110)
!110 = !{!56, !102}
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !112, file: !72, line: 147)
!112 = !DISubprogram(name: "bsearch", scope: !65, file: !65, line: 960, type: !113, flags: DIFlagPrototyped, spFlags: 0)
!113 = !DISubroutineType(types: !114)
!114 = !{!87, !115, !115, !88, !88, !117}
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !65, line: 948, baseType: !118)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!119 = !DISubroutineType(types: !120)
!120 = !{!6, !115, !115}
!121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !122, file: !72, line: 148)
!122 = !DISubprogram(name: "calloc", scope: !65, file: !65, line: 675, type: !85, flags: DIFlagPrototyped, spFlags: 0)
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !124, file: !72, line: 149)
!124 = !DISubprogram(name: "div", scope: !65, file: !65, line: 992, type: !125, flags: DIFlagPrototyped, spFlags: 0)
!125 = !DISubroutineType(types: !126)
!126 = !{!70, !6, !6}
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !128, file: !72, line: 150)
!128 = !DISubprogram(name: "exit", scope: !65, file: !65, line: 756, type: !129, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!129 = !DISubroutineType(types: !130)
!130 = !{null, !6}
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !132, file: !72, line: 151)
!132 = !DISubprogram(name: "free", scope: !65, file: !65, line: 687, type: !133, flags: DIFlagPrototyped, spFlags: 0)
!133 = !DISubroutineType(types: !134)
!134 = !{null, !87}
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !136, file: !72, line: 152)
!136 = !DISubprogram(name: "getenv", scope: !65, file: !65, line: 773, type: !137, flags: DIFlagPrototyped, spFlags: 0)
!137 = !DISubroutineType(types: !138)
!138 = !{!139, !102}
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !141, file: !72, line: 153)
!141 = !DISubprogram(name: "labs", scope: !65, file: !65, line: 981, type: !142, flags: DIFlagPrototyped, spFlags: 0)
!142 = !DISubroutineType(types: !143)
!143 = !{!56, !56}
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !145, file: !72, line: 154)
!145 = !DISubprogram(name: "ldiv", scope: !65, file: !65, line: 994, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!146 = !DISubroutineType(types: !147)
!147 = !{!74, !56, !56}
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !149, file: !72, line: 155)
!149 = !DISubprogram(name: "malloc", scope: !65, file: !65, line: 672, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DISubroutineType(types: !151)
!151 = !{!87, !88}
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !153, file: !72, line: 157)
!153 = !DISubprogram(name: "mblen", scope: !65, file: !65, line: 1062, type: !154, flags: DIFlagPrototyped, spFlags: 0)
!154 = !DISubroutineType(types: !155)
!155 = !{!6, !102, !88}
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !157, file: !72, line: 158)
!157 = !DISubprogram(name: "mbstowcs", scope: !65, file: !65, line: 1073, type: !158, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DISubroutineType(types: !159)
!159 = !{!88, !160, !163, !88}
!160 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !161)
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!163 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !102)
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !165, file: !72, line: 159)
!165 = !DISubprogram(name: "mbtowc", scope: !65, file: !65, line: 1065, type: !166, flags: DIFlagPrototyped, spFlags: 0)
!166 = !DISubroutineType(types: !167)
!167 = !{!6, !160, !163, !88}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !169, file: !72, line: 161)
!169 = !DISubprogram(name: "qsort", scope: !65, file: !65, line: 970, type: !170, flags: DIFlagPrototyped, spFlags: 0)
!170 = !DISubroutineType(types: !171)
!171 = !{null, !87, !88, !88, !117}
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !173, file: !72, line: 164)
!173 = !DISubprogram(name: "quick_exit", scope: !65, file: !65, line: 762, type: !129, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !175, file: !72, line: 167)
!175 = !DISubprogram(name: "rand", scope: !65, file: !65, line: 573, type: !176, flags: DIFlagPrototyped, spFlags: 0)
!176 = !DISubroutineType(types: !177)
!177 = !{!6}
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !179, file: !72, line: 168)
!179 = !DISubprogram(name: "realloc", scope: !65, file: !65, line: 683, type: !180, flags: DIFlagPrototyped, spFlags: 0)
!180 = !DISubroutineType(types: !181)
!181 = !{!87, !87, !88}
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !183, file: !72, line: 169)
!183 = !DISubprogram(name: "srand", scope: !65, file: !65, line: 575, type: !184, flags: DIFlagPrototyped, spFlags: 0)
!184 = !DISubroutineType(types: !185)
!185 = !{null, !186}
!186 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !188, file: !72, line: 170)
!188 = !DISubprogram(name: "strtod", scope: !65, file: !65, line: 118, type: !189, flags: DIFlagPrototyped, spFlags: 0)
!189 = !DISubroutineType(types: !190)
!190 = !{!101, !163, !191}
!191 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !192)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !139, size: 64)
!193 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !194, file: !72, line: 171)
!194 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !65, file: !65, line: 215, type: !195, flags: DIFlagPrototyped, spFlags: 0)
!195 = !DISubroutineType(types: !196)
!196 = !{!56, !163, !191, !6}
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !198, file: !72, line: 172)
!198 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !65, file: !65, line: 219, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!199 = !DISubroutineType(types: !200)
!200 = !{!12, !163, !191, !6}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !202, file: !72, line: 173)
!202 = !DISubprogram(name: "system", scope: !65, file: !65, line: 923, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !204, file: !72, line: 175)
!204 = !DISubprogram(name: "wcstombs", scope: !65, file: !65, line: 1077, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!205 = !DISubroutineType(types: !206)
!206 = !{!88, !207, !208, !88}
!207 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !139)
!208 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !209)
!209 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !210, size: 64)
!210 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !162)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !212, file: !72, line: 176)
!212 = !DISubprogram(name: "wctomb", scope: !65, file: !65, line: 1069, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!213 = !DISubroutineType(types: !214)
!214 = !{!6, !139, !162}
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !217, file: !72, line: 204)
!216 = !DINamespace(name: "__gnu_cxx", scope: null)
!217 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !65, line: 81, baseType: !218)
!218 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !65, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !219, identifier: "_ZTS7lldiv_t")
!219 = !{!220, !222}
!220 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !218, file: !65, line: 79, baseType: !221, size: 64)
!221 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !218, file: !65, line: 80, baseType: !221, size: 64, offset: 64)
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !224, file: !72, line: 210)
!224 = !DISubprogram(name: "_Exit", scope: !65, file: !65, line: 768, type: !129, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !226, file: !72, line: 214)
!226 = !DISubprogram(name: "llabs", scope: !65, file: !65, line: 984, type: !227, flags: DIFlagPrototyped, spFlags: 0)
!227 = !DISubroutineType(types: !228)
!228 = !{!221, !221}
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !230, file: !72, line: 220)
!230 = !DISubprogram(name: "lldiv", scope: !65, file: !65, line: 998, type: !231, flags: DIFlagPrototyped, spFlags: 0)
!231 = !DISubroutineType(types: !232)
!232 = !{!217, !221, !221}
!233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !234, file: !72, line: 231)
!234 = !DISubprogram(name: "atoll", scope: !65, file: !65, line: 113, type: !235, flags: DIFlagPrototyped, spFlags: 0)
!235 = !DISubroutineType(types: !236)
!236 = !{!221, !102}
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !238, file: !72, line: 232)
!238 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !65, file: !65, line: 238, type: !239, flags: DIFlagPrototyped, spFlags: 0)
!239 = !DISubroutineType(types: !240)
!240 = !{!221, !163, !191, !6}
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !242, file: !72, line: 233)
!242 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !65, file: !65, line: 243, type: !243, flags: DIFlagPrototyped, spFlags: 0)
!243 = !DISubroutineType(types: !244)
!244 = !{!7, !163, !191, !6}
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !246, file: !72, line: 235)
!246 = !DISubprogram(name: "strtof", scope: !65, file: !65, line: 124, type: !247, flags: DIFlagPrototyped, spFlags: 0)
!247 = !DISubroutineType(types: !248)
!248 = !{!249, !163, !191}
!249 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !216, entity: !251, file: !72, line: 236)
!251 = !DISubprogram(name: "strtold", scope: !65, file: !65, line: 127, type: !252, flags: DIFlagPrototyped, spFlags: 0)
!252 = !DISubroutineType(types: !253)
!253 = !{!254, !163, !191}
!254 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !217, file: !72, line: 244)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !224, file: !72, line: 246)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !226, file: !72, line: 248)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !259, file: !72, line: 249)
!259 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !216, file: !72, line: 217, type: !231, flags: DIFlagPrototyped, spFlags: 0)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !230, file: !72, line: 250)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !234, file: !72, line: 252)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !246, file: !72, line: 253)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !238, file: !72, line: 254)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !242, file: !72, line: 255)
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !63, entity: !251, file: !72, line: 256)
!266 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !80, file: !267, line: 38)
!267 = !DIFile(filename: "/usr/bin/../lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "3f24ff2a8eef595875da96e5466bd4aa")
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !91, file: !267, line: 39)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !128, file: !267, line: 40)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !96, file: !267, line: 43)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !173, file: !267, line: 46)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !224, file: !267, line: 49)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !70, file: !267, line: 54)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !74, file: !267, line: 55)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !276, file: !267, line: 57)
!276 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !63, file: !68, line: 137, type: !277, flags: DIFlagPrototyped, spFlags: 0)
!277 = !DISubroutineType(types: !278)
!278 = !{!279, !279}
!279 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !98, file: !267, line: 58)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !104, file: !267, line: 59)
!282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !108, file: !267, line: 60)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !112, file: !267, line: 61)
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !122, file: !267, line: 62)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !259, file: !267, line: 63)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !132, file: !267, line: 64)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !136, file: !267, line: 65)
!288 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !141, file: !267, line: 66)
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !145, file: !267, line: 67)
!290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !149, file: !267, line: 68)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !153, file: !267, line: 70)
!292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !157, file: !267, line: 71)
!293 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !165, file: !267, line: 72)
!294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !169, file: !267, line: 74)
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !175, file: !267, line: 75)
!296 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !179, file: !267, line: 76)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !183, file: !267, line: 77)
!298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !188, file: !267, line: 78)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !194, file: !267, line: 79)
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !198, file: !267, line: 80)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !202, file: !267, line: 81)
!302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !204, file: !267, line: 83)
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !212, file: !267, line: 84)
!304 = !DICompositeType(tag: DW_TAG_array_type, baseType: !53, size: 2048, elements: !305)
!305 = !{!306}
!306 = !DISubrange(count: 4)
!307 = !{i32 7, !"Dwarf Version", i32 5}
!308 = !{i32 2, !"Debug Info Version", i32 3}
!309 = !{i32 1, !"wchar_size", i32 4}
!310 = !{i32 8, !"PIC Level", i32 2}
!311 = !{i32 7, !"PIE Level", i32 2}
!312 = !{i32 7, !"uwtable", i32 2}
!313 = !{i32 7, !"frame-pointer", i32 2}
!314 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!315 = distinct !DISubprogram(name: "solo_worker", linkageName: "_Z11solo_workerPv", scope: !3, file: !3, line: 21, type: !316, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !318)
!316 = !DISubroutineType(types: !317)
!317 = !{!87, !87}
!318 = !{}
!319 = !DILocalVariable(name: "arg", arg: 1, scope: !315, file: !3, line: 21, type: !87)
!320 = !DILocation(line: 21, column: 25, scope: !315)
!321 = !DILocalVariable(name: "id", scope: !315, file: !3, line: 22, type: !6)
!322 = !DILocation(line: 22, column: 9, scope: !315)
!323 = !DILocation(line: 22, column: 21, scope: !315)
!324 = !DILocation(line: 22, column: 14, scope: !315)
!325 = !DILocalVariable(name: "i", scope: !326, file: !3, line: 23, type: !6)
!326 = distinct !DILexicalBlock(scope: !315, file: !3, line: 23, column: 5)
!327 = !DILocation(line: 23, column: 14, scope: !326)
!328 = !DILocation(line: 23, column: 10, scope: !326)
!329 = !DILocation(line: 23, column: 21, scope: !330)
!330 = distinct !DILexicalBlock(scope: !326, file: !3, line: 23, column: 5)
!331 = !DILocation(line: 23, column: 23, scope: !330)
!332 = !DILocation(line: 23, column: 5, scope: !326)
!333 = !DILocalVariable(name: "v", scope: !334, file: !3, line: 24, type: !56)
!334 = distinct !DILexicalBlock(scope: !330, file: !3, line: 23, column: 42)
!335 = !DILocation(line: 24, column: 14, scope: !334)
!336 = !DILocation(line: 24, column: 28, scope: !334)
!337 = !DILocation(line: 24, column: 18, scope: !334)
!338 = !DILocation(line: 24, column: 32, scope: !334)
!339 = !DILocation(line: 25, column: 13, scope: !334)
!340 = !DILocation(line: 25, column: 15, scope: !334)
!341 = !DILocation(line: 25, column: 11, scope: !334)
!342 = !DILocation(line: 26, column: 31, scope: !334)
!343 = !DILocation(line: 26, column: 19, scope: !334)
!344 = !DILocation(line: 26, column: 9, scope: !334)
!345 = !DILocation(line: 26, column: 23, scope: !334)
!346 = !DILocation(line: 26, column: 29, scope: !334)
!347 = !DILocation(line: 27, column: 5, scope: !334)
!348 = !DILocation(line: 23, column: 38, scope: !330)
!349 = !DILocation(line: 23, column: 5, scope: !330)
!350 = distinct !{!350, !332, !351, !352}
!351 = !DILocation(line: 27, column: 5, scope: !326)
!352 = !{!"llvm.loop.mustprogress"}
!353 = !DILocation(line: 28, column: 5, scope: !315)
!354 = distinct !DISubprogram(name: "shared_worker", linkageName: "_Z13shared_workerPv", scope: !3, file: !3, line: 32, type: !316, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !318)
!355 = !DILocalVariable(name: "arg", arg: 1, scope: !354, file: !3, line: 32, type: !87)
!356 = !DILocation(line: 32, column: 27, scope: !354)
!357 = !DILocalVariable(name: "i", scope: !358, file: !3, line: 33, type: !6)
!358 = distinct !DILexicalBlock(scope: !354, file: !3, line: 33, column: 5)
!359 = !DILocation(line: 33, column: 14, scope: !358)
!360 = !DILocation(line: 33, column: 10, scope: !358)
!361 = !DILocation(line: 33, column: 21, scope: !362)
!362 = distinct !DILexicalBlock(scope: !358, file: !3, line: 33, column: 5)
!363 = !DILocation(line: 33, column: 23, scope: !362)
!364 = !DILocation(line: 33, column: 5, scope: !358)
!365 = !DILocalVariable(name: "v", scope: !366, file: !3, line: 34, type: !56)
!366 = distinct !DILexicalBlock(scope: !362, file: !3, line: 33, column: 44)
!367 = !DILocation(line: 34, column: 14, scope: !366)
!368 = !DILocation(line: 34, column: 27, scope: !366)
!369 = !DILocation(line: 35, column: 13, scope: !366)
!370 = !DILocation(line: 35, column: 15, scope: !366)
!371 = !DILocation(line: 35, column: 11, scope: !366)
!372 = !DILocation(line: 36, column: 26, scope: !366)
!373 = !DILocation(line: 36, column: 24, scope: !366)
!374 = !DILocation(line: 37, column: 5, scope: !366)
!375 = !DILocation(line: 33, column: 40, scope: !362)
!376 = !DILocation(line: 33, column: 5, scope: !362)
!377 = distinct !{!377, !364, !378, !352}
!378 = !DILocation(line: 37, column: 5, scope: !358)
!379 = !DILocation(line: 38, column: 5, scope: !354)
!380 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 47, type: !176, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !318)
!381 = !DILocalVariable(name: "i", scope: !380, file: !3, line: 48, type: !6)
!382 = !DILocation(line: 48, column: 9, scope: !380)
!383 = !DILocation(line: 49, column: 5, scope: !380)
!384 = !DILocation(line: 50, column: 5, scope: !380)
!385 = !DILocation(line: 51, column: 20, scope: !380)
!386 = !DILocalVariable(name: "threads", scope: !380, file: !3, line: 53, type: !387)
!387 = !DICompositeType(tag: DW_TAG_array_type, baseType: !388, size: 256, elements: !305)
!388 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !389, line: 27, baseType: !12)
!389 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!390 = !DILocation(line: 53, column: 15, scope: !380)
!391 = !DILocalVariable(name: "ids", scope: !380, file: !3, line: 54, type: !392)
!392 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 128, elements: !305)
!393 = !DILocation(line: 54, column: 15, scope: !380)
!394 = !DILocalVariable(name: "launch_ns", scope: !380, file: !3, line: 56, type: !8)
!395 = !DILocation(line: 56, column: 14, scope: !380)
!396 = !DILocation(line: 56, column: 26, scope: !380)
!397 = !DILocation(line: 59, column: 12, scope: !398)
!398 = distinct !DILexicalBlock(scope: !380, file: !3, line: 59, column: 5)
!399 = !DILocation(line: 59, column: 10, scope: !398)
!400 = !DILocation(line: 59, column: 17, scope: !401)
!401 = distinct !DILexicalBlock(scope: !398, file: !3, line: 59, column: 5)
!402 = !DILocation(line: 59, column: 19, scope: !401)
!403 = !DILocation(line: 59, column: 5, scope: !398)
!404 = !DILocation(line: 60, column: 18, scope: !405)
!405 = distinct !DILexicalBlock(scope: !401, file: !3, line: 59, column: 39)
!406 = !DILocation(line: 60, column: 13, scope: !405)
!407 = !DILocation(line: 60, column: 9, scope: !405)
!408 = !DILocation(line: 60, column: 16, scope: !405)
!409 = !DILocation(line: 61, column: 33, scope: !405)
!410 = !DILocation(line: 61, column: 25, scope: !405)
!411 = !DILocation(line: 61, column: 61, scope: !405)
!412 = !DILocation(line: 61, column: 57, scope: !405)
!413 = !DILocation(line: 61, column: 9, scope: !405)
!414 = !DILocation(line: 62, column: 5, scope: !405)
!415 = !DILocation(line: 59, column: 35, scope: !401)
!416 = !DILocation(line: 59, column: 5, scope: !401)
!417 = distinct !{!417, !403, !418, !352}
!418 = !DILocation(line: 62, column: 5, scope: !398)
!419 = !DILocation(line: 66, column: 12, scope: !420)
!420 = distinct !DILexicalBlock(scope: !380, file: !3, line: 66, column: 5)
!421 = !DILocation(line: 66, column: 10, scope: !420)
!422 = !DILocation(line: 66, column: 17, scope: !423)
!423 = distinct !DILexicalBlock(scope: !420, file: !3, line: 66, column: 5)
!424 = !DILocation(line: 66, column: 19, scope: !423)
!425 = !DILocation(line: 66, column: 5, scope: !420)
!426 = !DILocation(line: 67, column: 30, scope: !427)
!427 = distinct !DILexicalBlock(scope: !423, file: !3, line: 66, column: 39)
!428 = !DILocation(line: 67, column: 22, scope: !427)
!429 = !DILocation(line: 67, column: 9, scope: !427)
!430 = !DILocation(line: 68, column: 5, scope: !427)
!431 = !DILocation(line: 66, column: 35, scope: !423)
!432 = !DILocation(line: 66, column: 5, scope: !423)
!433 = distinct !{!433, !425, !434, !352}
!434 = !DILocation(line: 68, column: 5, scope: !420)
!435 = !DILocalVariable(name: "gate_open_ns", scope: !380, file: !3, line: 70, type: !8)
!436 = !DILocation(line: 70, column: 14, scope: !380)
!437 = !DILocation(line: 70, column: 29, scope: !380)
!438 = !DILocation(line: 74, column: 12, scope: !439)
!439 = distinct !DILexicalBlock(scope: !380, file: !3, line: 74, column: 5)
!440 = !DILocation(line: 74, column: 10, scope: !439)
!441 = !DILocation(line: 74, column: 17, scope: !442)
!442 = distinct !DILexicalBlock(scope: !439, file: !3, line: 74, column: 5)
!443 = !DILocation(line: 74, column: 19, scope: !442)
!444 = !DILocation(line: 74, column: 5, scope: !439)
!445 = !DILocation(line: 75, column: 33, scope: !446)
!446 = distinct !DILexicalBlock(scope: !442, file: !3, line: 74, column: 39)
!447 = !DILocation(line: 75, column: 25, scope: !446)
!448 = !DILocation(line: 75, column: 63, scope: !446)
!449 = !DILocation(line: 75, column: 59, scope: !446)
!450 = !DILocation(line: 75, column: 9, scope: !446)
!451 = !DILocation(line: 76, column: 5, scope: !446)
!452 = !DILocation(line: 74, column: 35, scope: !442)
!453 = !DILocation(line: 74, column: 5, scope: !442)
!454 = distinct !{!454, !444, !455, !352}
!455 = !DILocation(line: 76, column: 5, scope: !439)
!456 = !DILocation(line: 79, column: 12, scope: !457)
!457 = distinct !DILexicalBlock(scope: !380, file: !3, line: 79, column: 5)
!458 = !DILocation(line: 79, column: 10, scope: !457)
!459 = !DILocation(line: 79, column: 17, scope: !460)
!460 = distinct !DILexicalBlock(scope: !457, file: !3, line: 79, column: 5)
!461 = !DILocation(line: 79, column: 19, scope: !460)
!462 = !DILocation(line: 79, column: 5, scope: !457)
!463 = !DILocation(line: 80, column: 30, scope: !464)
!464 = distinct !DILexicalBlock(scope: !460, file: !3, line: 79, column: 39)
!465 = !DILocation(line: 80, column: 22, scope: !464)
!466 = !DILocation(line: 80, column: 9, scope: !464)
!467 = !DILocation(line: 81, column: 5, scope: !464)
!468 = !DILocation(line: 79, column: 35, scope: !460)
!469 = !DILocation(line: 79, column: 5, scope: !460)
!470 = distinct !{!470, !462, !471, !352}
!471 = !DILocation(line: 81, column: 5, scope: !457)
!472 = !DILocalVariable(name: "finish_ns", scope: !380, file: !3, line: 83, type: !8)
!473 = !DILocation(line: 83, column: 14, scope: !380)
!474 = !DILocation(line: 83, column: 26, scope: !380)
!475 = !DILocation(line: 86, column: 34, scope: !380)
!476 = !DILocation(line: 86, column: 46, scope: !380)
!477 = !DILocation(line: 86, column: 44, scope: !380)
!478 = !DILocation(line: 86, column: 57, scope: !380)
!479 = !DILocation(line: 85, column: 5, scope: !380)
!480 = !DILocation(line: 88, column: 34, scope: !380)
!481 = !DILocation(line: 88, column: 49, scope: !380)
!482 = !DILocation(line: 88, column: 47, scope: !380)
!483 = !DILocation(line: 88, column: 60, scope: !380)
!484 = !DILocation(line: 87, column: 5, scope: !380)
!485 = !DILocation(line: 90, column: 5, scope: !380)
!486 = !DILocation(line: 91, column: 12, scope: !487)
!487 = distinct !DILexicalBlock(scope: !380, file: !3, line: 91, column: 5)
!488 = !DILocation(line: 91, column: 10, scope: !487)
!489 = !DILocation(line: 91, column: 17, scope: !490)
!490 = distinct !DILexicalBlock(scope: !487, file: !3, line: 91, column: 5)
!491 = !DILocation(line: 91, column: 19, scope: !490)
!492 = !DILocation(line: 91, column: 5, scope: !487)
!493 = !DILocation(line: 92, column: 38, scope: !494)
!494 = distinct !DILexicalBlock(scope: !490, file: !3, line: 91, column: 39)
!495 = !DILocation(line: 92, column: 51, scope: !494)
!496 = !DILocation(line: 92, column: 41, scope: !494)
!497 = !DILocation(line: 92, column: 54, scope: !494)
!498 = !DILocation(line: 92, column: 9, scope: !494)
!499 = !DILocation(line: 93, column: 5, scope: !494)
!500 = !DILocation(line: 91, column: 35, scope: !490)
!501 = !DILocation(line: 91, column: 5, scope: !490)
!502 = distinct !{!502, !492, !503, !352}
!503 = !DILocation(line: 93, column: 5, scope: !487)
!504 = !DILocation(line: 94, column: 5, scope: !380)
!505 = !DILocation(line: 96, column: 5, scope: !380)
!506 = !DILocation(line: 97, column: 56, scope: !380)
!507 = !DILocation(line: 97, column: 5, scope: !380)
!508 = !DILocation(line: 99, column: 5, scope: !380)
!509 = distinct !DISubprogram(name: "now_ns", linkageName: "_ZL6now_nsv", scope: !3, file: !3, line: 41, type: !510, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !318)
!510 = !DISubroutineType(types: !511)
!511 = !{!8}
!512 = !DILocalVariable(name: "ts", scope: !509, file: !3, line: 42, type: !513)
!513 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !514, line: 11, size: 128, flags: DIFlagTypePassByValue, elements: !515, identifier: "_ZTS8timespec")
!514 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "55dc154df3f21a5aa944dcafba9b43f6")
!515 = !{!516, !518}
!516 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !513, file: !514, line: 16, baseType: !517, size: 64)
!517 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !11, line: 160, baseType: !56)
!518 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !513, file: !514, line: 21, baseType: !519, size: 64, offset: 64)
!519 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !11, line: 197, baseType: !56)
!520 = !DILocation(line: 42, column: 21, scope: !509)
!521 = !DILocation(line: 43, column: 5, scope: !509)
!522 = !DILocation(line: 44, column: 25, scope: !509)
!523 = !DILocation(line: 44, column: 32, scope: !509)
!524 = !DILocation(line: 44, column: 63, scope: !509)
!525 = !DILocation(line: 44, column: 48, scope: !509)
!526 = !DILocation(line: 44, column: 5, scope: !509)
