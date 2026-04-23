; ModuleID = 'build_wcp/test1.bc'
source_filename = "../benchmarks/targets/new_claude_benchmarks/test1.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.WorkArg = type { i32 }

@_ZL11shared_vars = internal global [100 x i32] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [33 x i8] c"[TEST1] Done. shared_vars[0]=%d\0A\00", align 1, !dbg !11
@0 = private unnamed_addr constant [8 x i8] c"unknown\00", align 1
@1 = private unnamed_addr constant [17 x i8] c"_ZL11shared_vars\00", align 1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #0 !dbg !29 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca [4 x %struct.WorkArg], align 16
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %6 = call ptr @memset(ptr noundef @_ZL11shared_vars, i32 noundef 0, i64 noundef 400) #4, !dbg !33
    #dbg_declare(ptr %2, !34, !DIExpression(), !41)
    #dbg_declare(ptr %3, !42, !DIExpression(), !44)
    #dbg_declare(ptr %4, !45, !DIExpression(), !47)
  store i32 0, ptr %4, align 4, !dbg !47
  br label %7, !dbg !48

7:                                                ; preds = %25, %0
  %8 = load i32, ptr %4, align 4, !dbg !49
  %9 = icmp slt i32 %8, 4, !dbg !51
  br i1 %9, label %10, label %28, !dbg !52

10:                                               ; preds = %7
  %11 = load i32, ptr %4, align 4, !dbg !53
  %12 = load i32, ptr %4, align 4, !dbg !55
  %13 = sext i32 %12 to i64, !dbg !56
  %14 = getelementptr inbounds [4 x %struct.WorkArg], ptr %3, i64 0, i64 %13, !dbg !56
  %15 = getelementptr inbounds nuw %struct.WorkArg, ptr %14, i32 0, i32 0, !dbg !57
  call void @__wcp_write(ptr %15, i32 64, ptr @0), !dbg !58
  store i32 %11, ptr %15, align 4, !dbg !58
  %16 = load i32, ptr %4, align 4, !dbg !59
  %17 = sext i32 %16 to i64, !dbg !60
  %18 = getelementptr inbounds [4 x i64], ptr %2, i64 0, i64 %17, !dbg !60
  %19 = load i32, ptr %4, align 4, !dbg !61
  %20 = sext i32 %19 to i64, !dbg !62
  %21 = getelementptr inbounds [4 x %struct.WorkArg], ptr %3, i64 0, i64 %20, !dbg !62
  %22 = call ptr @__wcp_prepare_context(ptr @_ZL6workerPv, ptr %21), !dbg !63
  %23 = call i32 @pthread_create(ptr noundef %18, ptr noundef null, ptr noundef @thread_wrapper, ptr noundef %22) #4, !dbg !63
  %24 = load i64, ptr %18, align 8, !dbg !64
  call void @__wcp_thread_create(i64 %24), !dbg !64
  br label %25, !dbg !64

25:                                               ; preds = %10
  %26 = load i32, ptr %4, align 4, !dbg !65
  %27 = add nsw i32 %26, 1, !dbg !65
  store i32 %27, ptr %4, align 4, !dbg !65
  br label %7, !dbg !66, !llvm.loop !67

28:                                               ; preds = %7
    #dbg_declare(ptr %5, !70, !DIExpression(), !72)
  store i32 0, ptr %5, align 4, !dbg !72
  br label %29, !dbg !73

29:                                               ; preds = %38, %28
  %30 = load i32, ptr %5, align 4, !dbg !74
  %31 = icmp slt i32 %30, 4, !dbg !76
  br i1 %31, label %32, label %41, !dbg !77

32:                                               ; preds = %29
  %33 = load i32, ptr %5, align 4, !dbg !78
  %34 = sext i32 %33 to i64, !dbg !79
  %35 = getelementptr inbounds [4 x i64], ptr %2, i64 0, i64 %34, !dbg !79
  call void @__wcp_read(ptr %35, i32 68, ptr @0), !dbg !79
  %36 = load i64, ptr %35, align 8, !dbg !79
  %37 = call i32 @pthread_join(i64 noundef %36, ptr noundef null) #5, !dbg !80
  call void @__wcp_thread_join(i64 %36), !dbg !80
  br label %38, !dbg !80

38:                                               ; preds = %32
  %39 = load i32, ptr %5, align 4, !dbg !81
  %40 = add nsw i32 %39, 1, !dbg !81
  store i32 %40, ptr %5, align 4, !dbg !81
  br label %29, !dbg !82, !llvm.loop !83

41:                                               ; preds = %29
  call void @__wcp_read(ptr @_ZL11shared_vars, i32 70, ptr @1), !dbg !85
  %42 = load i32, ptr @_ZL11shared_vars, align 16, !dbg !85
  %43 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %42) #5, !dbg !86
  ret i32 0, !dbg !87
}

; Function Attrs: nounwind
declare ptr @memset(ptr noundef, i32 noundef, i64 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef ptr @_ZL6workerPv(ptr noundef %0) #2 !dbg !88 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !92, !DIExpression(), !93)
    #dbg_declare(ptr %3, !94, !DIExpression(), !95)
  %8 = load ptr, ptr %2, align 8, !dbg !96
  store ptr %8, ptr %3, align 8, !dbg !95
    #dbg_declare(ptr %4, !97, !DIExpression(), !99)
  store i32 0, ptr %4, align 4, !dbg !99
  br label %9, !dbg !100

9:                                                ; preds = %40, %1
  %10 = load i32, ptr %4, align 4, !dbg !101
  %11 = icmp slt i32 %10, 2000, !dbg !103
  br i1 %11, label %12, label %43, !dbg !104

12:                                               ; preds = %9
    #dbg_declare(ptr %5, !105, !DIExpression(), !108)
  store i32 0, ptr %5, align 4, !dbg !108
  br label %13, !dbg !109

13:                                               ; preds = %21, %12
  %14 = load i32, ptr %5, align 4, !dbg !110
  %15 = icmp slt i32 %14, 100, !dbg !112
  br i1 %15, label %16, label %24, !dbg !113

16:                                               ; preds = %13
  %17 = load i32, ptr %4, align 4, !dbg !114
  %18 = load i32, ptr %5, align 4, !dbg !115
  %19 = sext i32 %18 to i64, !dbg !116
  %20 = getelementptr inbounds [100 x i32], ptr @_ZL11shared_vars, i64 0, i64 %19, !dbg !116
  call void @__wcp_write(ptr %20, i32 46, ptr @1), !dbg !117
  store i32 %17, ptr %20, align 4, !dbg !117
  br label %21, !dbg !116

21:                                               ; preds = %16
  %22 = load i32, ptr %5, align 4, !dbg !118
  %23 = add nsw i32 %22, 1, !dbg !118
  store i32 %23, ptr %5, align 4, !dbg !118
  br label %13, !dbg !119, !llvm.loop !120

24:                                               ; preds = %13
    #dbg_declare(ptr %6, !122, !DIExpression(), !124)
  store volatile i32 0, ptr %6, align 4, !dbg !124
    #dbg_declare(ptr %7, !125, !DIExpression(), !127)
  store i32 0, ptr %7, align 4, !dbg !127
  br label %25, !dbg !128

25:                                               ; preds = %35, %24
  %26 = load i32, ptr %7, align 4, !dbg !129
  %27 = icmp slt i32 %26, 100, !dbg !131
  br i1 %27, label %28, label %38, !dbg !132

28:                                               ; preds = %25
  %29 = load i32, ptr %7, align 4, !dbg !133
  %30 = sext i32 %29 to i64, !dbg !134
  %31 = getelementptr inbounds [100 x i32], ptr @_ZL11shared_vars, i64 0, i64 %30, !dbg !134
  call void @__wcp_read(ptr %31, i32 51, ptr @1), !dbg !134
  %32 = load i32, ptr %31, align 4, !dbg !134
  %33 = load volatile i32, ptr %6, align 4, !dbg !135
  %34 = add nsw i32 %33, %32, !dbg !135
  store volatile i32 %34, ptr %6, align 4, !dbg !135
  br label %35, !dbg !136

35:                                               ; preds = %28
  %36 = load i32, ptr %7, align 4, !dbg !137
  %37 = add nsw i32 %36, 1, !dbg !137
  store i32 %37, ptr %7, align 4, !dbg !137
  br label %25, !dbg !138, !llvm.loop !139

38:                                               ; preds = %25
  %39 = load volatile i32, ptr %6, align 4, !dbg !141
  br label %40, !dbg !142

40:                                               ; preds = %38
  %41 = load i32, ptr %4, align 4, !dbg !143
  %42 = add nsw i32 %41, 1, !dbg !143
  store i32 %42, ptr %4, align 4, !dbg !143
  br label %9, !dbg !144, !llvm.loop !145

43:                                               ; preds = %9
  ret ptr null, !dbg !147
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

declare i32 @printf(ptr noundef, ...) #3

declare void @__wcp_read(ptr, i32, ptr)

declare void @__wcp_write(ptr, i32, ptr)

declare void @__wcp_lock(ptr)

declare void @__wcp_unlock(ptr)

declare void @__wcp_thread_create(i64)

declare void @__wcp_thread_join(i64)

declare ptr @__wcp_prepare_context(ptr, ptr)

declare ptr @thread_wrapper(ptr)

attributes #0 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nobuiltin nounwind "no-builtins" }
attributes #5 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26, !27}
!llvm.ident = !{!28}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "shared_vars", linkageName: "_ZL11shared_vars", scope: !2, file: !3, line: 33, type: !18, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !10, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "../benchmarks/targets/new_claude_benchmarks/test1.cpp", directory: "/mnt/c/Users/dhruv/Desktop/IIT-Kanpur/Sem 2/CS636/course_project/CS636_course_project_IITK/wcp", checksumkind: CSK_MD5, checksum: "7972819d48c5dce2b99bf70baf0e5dbb")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "WorkArg", file: !3, line: 36, size: 32, flags: DIFlagTypePassByValue, elements: !7, identifier: "_ZTS7WorkArg")
!7 = !{!8}
!8 = !DIDerivedType(tag: DW_TAG_member, name: "tid", scope: !6, file: !3, line: 36, baseType: !9, size: 32)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{!11, !0}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !3, line: 70, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 264, elements: !16)
!14 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !{!17}
!17 = !DISubrange(count: 33)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 3200, elements: !19)
!19 = !{!20}
!20 = !DISubrange(count: 100)
!21 = !{i32 7, !"Dwarf Version", i32 5}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 8, !"PIC Level", i32 2}
!25 = !{i32 7, !"PIE Level", i32 2}
!26 = !{i32 7, !"uwtable", i32 2}
!27 = !{i32 7, !"frame-pointer", i32 2}
!28 = !{!"clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)"}
!29 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 57, type: !30, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !32)
!30 = !DISubroutineType(types: !31)
!31 = !{!9}
!32 = !{}
!33 = !DILocation(line: 58, column: 5, scope: !29)
!34 = !DILocalVariable(name: "threads", scope: !29, file: !3, line: 60, type: !35)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 256, elements: !39)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !37, line: 27, baseType: !38)
!37 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!38 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!39 = !{!40}
!40 = !DISubrange(count: 4)
!41 = !DILocation(line: 60, column: 15, scope: !29)
!42 = !DILocalVariable(name: "args", scope: !29, file: !3, line: 61, type: !43)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 128, elements: !39)
!44 = !DILocation(line: 61, column: 15, scope: !29)
!45 = !DILocalVariable(name: "i", scope: !46, file: !3, line: 63, type: !9)
!46 = distinct !DILexicalBlock(scope: !29, file: !3, line: 63, column: 5)
!47 = !DILocation(line: 63, column: 14, scope: !46)
!48 = !DILocation(line: 63, column: 10, scope: !46)
!49 = !DILocation(line: 63, column: 21, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !3, line: 63, column: 5)
!51 = !DILocation(line: 63, column: 23, scope: !50)
!52 = !DILocation(line: 63, column: 5, scope: !46)
!53 = !DILocation(line: 64, column: 23, scope: !54)
!54 = distinct !DILexicalBlock(scope: !50, file: !3, line: 63, column: 43)
!55 = !DILocation(line: 64, column: 14, scope: !54)
!56 = !DILocation(line: 64, column: 9, scope: !54)
!57 = !DILocation(line: 64, column: 17, scope: !54)
!58 = !DILocation(line: 64, column: 21, scope: !54)
!59 = !DILocation(line: 65, column: 33, scope: !54)
!60 = !DILocation(line: 65, column: 25, scope: !54)
!61 = !DILocation(line: 65, column: 60, scope: !54)
!62 = !DILocation(line: 65, column: 55, scope: !54)
!63 = !DILocation(line: 65, column: 9, scope: !54)
!64 = !DILocation(line: 66, column: 5, scope: !54)
!65 = !DILocation(line: 63, column: 38, scope: !50)
!66 = !DILocation(line: 63, column: 5, scope: !50)
!67 = distinct !{!67, !52, !68, !69}
!68 = !DILocation(line: 66, column: 5, scope: !46)
!69 = !{!"llvm.loop.mustprogress"}
!70 = !DILocalVariable(name: "i", scope: !71, file: !3, line: 67, type: !9)
!71 = distinct !DILexicalBlock(scope: !29, file: !3, line: 67, column: 5)
!72 = !DILocation(line: 67, column: 14, scope: !71)
!73 = !DILocation(line: 67, column: 10, scope: !71)
!74 = !DILocation(line: 67, column: 21, scope: !75)
!75 = distinct !DILexicalBlock(scope: !71, file: !3, line: 67, column: 5)
!76 = !DILocation(line: 67, column: 23, scope: !75)
!77 = !DILocation(line: 67, column: 5, scope: !71)
!78 = !DILocation(line: 68, column: 30, scope: !75)
!79 = !DILocation(line: 68, column: 22, scope: !75)
!80 = !DILocation(line: 68, column: 9, scope: !75)
!81 = !DILocation(line: 67, column: 38, scope: !75)
!82 = !DILocation(line: 67, column: 5, scope: !75)
!83 = distinct !{!83, !77, !84, !69}
!84 = !DILocation(line: 68, column: 41, scope: !71)
!85 = !DILocation(line: 70, column: 49, scope: !29)
!86 = !DILocation(line: 70, column: 5, scope: !29)
!87 = !DILocation(line: 71, column: 5, scope: !29)
!88 = distinct !DISubprogram(name: "worker", linkageName: "_ZL6workerPv", scope: !3, file: !3, line: 38, type: !89, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !32)
!89 = !DISubroutineType(types: !90)
!90 = !{!91, !91}
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!92 = !DILocalVariable(name: "arg", arg: 1, scope: !88, file: !3, line: 38, type: !91)
!93 = !DILocation(line: 38, column: 27, scope: !88)
!94 = !DILocalVariable(name: "wa", scope: !88, file: !3, line: 39, type: !5)
!95 = !DILocation(line: 39, column: 14, scope: !88)
!96 = !DILocation(line: 39, column: 29, scope: !88)
!97 = !DILocalVariable(name: "iter", scope: !98, file: !3, line: 42, type: !9)
!98 = distinct !DILexicalBlock(scope: !88, file: !3, line: 42, column: 5)
!99 = !DILocation(line: 42, column: 14, scope: !98)
!100 = !DILocation(line: 42, column: 10, scope: !98)
!101 = !DILocation(line: 42, column: 24, scope: !102)
!102 = distinct !DILexicalBlock(scope: !98, file: !3, line: 42, column: 5)
!103 = !DILocation(line: 42, column: 29, scope: !102)
!104 = !DILocation(line: 42, column: 5, scope: !98)
!105 = !DILocalVariable(name: "i", scope: !106, file: !3, line: 45, type: !9)
!106 = distinct !DILexicalBlock(scope: !107, file: !3, line: 45, column: 9)
!107 = distinct !DILexicalBlock(scope: !102, file: !3, line: 42, column: 51)
!108 = !DILocation(line: 45, column: 18, scope: !106)
!109 = !DILocation(line: 45, column: 14, scope: !106)
!110 = !DILocation(line: 45, column: 25, scope: !111)
!111 = distinct !DILexicalBlock(scope: !106, file: !3, line: 45, column: 9)
!112 = !DILocation(line: 45, column: 27, scope: !111)
!113 = !DILocation(line: 45, column: 9, scope: !106)
!114 = !DILocation(line: 46, column: 30, scope: !111)
!115 = !DILocation(line: 46, column: 25, scope: !111)
!116 = !DILocation(line: 46, column: 13, scope: !111)
!117 = !DILocation(line: 46, column: 28, scope: !111)
!118 = !DILocation(line: 45, column: 39, scope: !111)
!119 = !DILocation(line: 45, column: 9, scope: !111)
!120 = distinct !{!120, !113, !121, !69}
!121 = !DILocation(line: 46, column: 30, scope: !106)
!122 = !DILocalVariable(name: "sum", scope: !107, file: !3, line: 49, type: !123)
!123 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !9)
!124 = !DILocation(line: 49, column: 22, scope: !107)
!125 = !DILocalVariable(name: "i", scope: !126, file: !3, line: 50, type: !9)
!126 = distinct !DILexicalBlock(scope: !107, file: !3, line: 50, column: 9)
!127 = !DILocation(line: 50, column: 18, scope: !126)
!128 = !DILocation(line: 50, column: 14, scope: !126)
!129 = !DILocation(line: 50, column: 25, scope: !130)
!130 = distinct !DILexicalBlock(scope: !126, file: !3, line: 50, column: 9)
!131 = !DILocation(line: 50, column: 27, scope: !130)
!132 = !DILocation(line: 50, column: 9, scope: !126)
!133 = !DILocation(line: 51, column: 32, scope: !130)
!134 = !DILocation(line: 51, column: 20, scope: !130)
!135 = !DILocation(line: 51, column: 17, scope: !130)
!136 = !DILocation(line: 51, column: 13, scope: !130)
!137 = !DILocation(line: 50, column: 39, scope: !130)
!138 = !DILocation(line: 50, column: 9, scope: !130)
!139 = distinct !{!139, !132, !140, !69}
!140 = !DILocation(line: 51, column: 33, scope: !126)
!141 = !DILocation(line: 52, column: 15, scope: !107)
!142 = !DILocation(line: 53, column: 5, scope: !107)
!143 = !DILocation(line: 42, column: 43, scope: !102)
!144 = !DILocation(line: 42, column: 5, scope: !102)
!145 = distinct !{!145, !104, !146, !69}
!146 = !DILocation(line: 53, column: 5, scope: !98)
!147 = !DILocation(line: 54, column: 5, scope: !88)
