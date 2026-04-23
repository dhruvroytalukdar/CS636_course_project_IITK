; ModuleID = 'build_wcp/test2.bc'
source_filename = "../benchmarks/targets/new_claude_benchmarks/test2.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@private_chunks = dso_local global [4096 x i32] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [26 x i8] c"Fast path test complete.\0A\00", align 1, !dbg !8
@0 = private unnamed_addr constant [45 x i8] c"  %23 = load i32, ptr %22, align 4, !dbg !63\00", align 1
@1 = private unnamed_addr constant [44 x i8] c"  store i32 %24, ptr %22, align 4, !dbg !63\00", align 1
@2 = private unnamed_addr constant [45 x i8] c"  %15 = load i64, ptr %10, align 8, !dbg !53\00", align 1
@3 = private unnamed_addr constant [45 x i8] c"  %27 = load i64, ptr %26, align 8, !dbg !69\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef ptr @_Z16worker_fast_pathPv(ptr noundef %0) #0 !dbg !27 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !31, !DIExpression(), !32)
    #dbg_declare(ptr %3, !33, !DIExpression(), !34)
  %7 = load ptr, ptr %2, align 8, !dbg !35
  %8 = ptrtoint ptr %7 to i64, !dbg !36
  store i64 %8, ptr %3, align 8, !dbg !34
    #dbg_declare(ptr %4, !37, !DIExpression(), !38)
  %9 = load i64, ptr %3, align 8, !dbg !39
  %10 = mul nsw i64 %9, 1024, !dbg !40
  store i64 %10, ptr %4, align 8, !dbg !38
    #dbg_declare(ptr %5, !41, !DIExpression(), !43)
  store i32 0, ptr %5, align 4, !dbg !43
  br label %11, !dbg !44

11:                                               ; preds = %29, %1
  %12 = load i32, ptr %5, align 4, !dbg !45
  %13 = icmp slt i32 %12, 1000000, !dbg !47
  br i1 %13, label %14, label %32, !dbg !48

14:                                               ; preds = %11
    #dbg_declare(ptr %6, !49, !DIExpression(), !52)
  store i64 0, ptr %6, align 8, !dbg !52
  br label %15, !dbg !53

15:                                               ; preds = %25, %14
  %16 = load i64, ptr %6, align 8, !dbg !54
  %17 = icmp slt i64 %16, 10, !dbg !56
  br i1 %17, label %18, label %28, !dbg !57

18:                                               ; preds = %15
  %19 = load i64, ptr %4, align 8, !dbg !58
  %20 = load i64, ptr %6, align 8, !dbg !60
  %21 = add nsw i64 %19, %20, !dbg !61
  %22 = getelementptr inbounds [4096 x i32], ptr @private_chunks, i64 0, i64 %21, !dbg !62
  call void @__wcp_read(ptr %22, ptr @0), !dbg !63
  %23 = load i32, ptr %22, align 4, !dbg !63
  %24 = add nsw i32 %23, 1, !dbg !63
  call void @__wcp_write(ptr %22, ptr @1), !dbg !63
  store i32 %24, ptr %22, align 4, !dbg !63
  br label %25, !dbg !64

25:                                               ; preds = %18
  %26 = load i64, ptr %6, align 8, !dbg !65
  %27 = add nsw i64 %26, 1, !dbg !65
  store i64 %27, ptr %6, align 8, !dbg !65
  br label %15, !dbg !66, !llvm.loop !67

28:                                               ; preds = %15
  br label %29, !dbg !70

29:                                               ; preds = %28
  %30 = load i32, ptr %5, align 4, !dbg !71
  %31 = add nsw i32 %30, 1, !dbg !71
  store i32 %31, ptr %5, align 4, !dbg !71
  br label %11, !dbg !72, !llvm.loop !73

32:                                               ; preds = %11
  ret ptr null, !dbg !75
}

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #1 !dbg !76 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !79, !DIExpression(), !86)
    #dbg_declare(ptr %3, !87, !DIExpression(), !89)
  store i64 0, ptr %3, align 8, !dbg !89
  br label %5, !dbg !90

5:                                                ; preds = %16, %0
  %6 = load i64, ptr %3, align 8, !dbg !91
  %7 = icmp slt i64 %6, 4, !dbg !93
  br i1 %7, label %8, label %19, !dbg !94

8:                                                ; preds = %5
  %9 = load i64, ptr %3, align 8, !dbg !95
  %10 = getelementptr inbounds [4 x i64], ptr %2, i64 0, i64 %9, !dbg !97
  %11 = load i64, ptr %3, align 8, !dbg !98
  %12 = inttoptr i64 %11 to ptr, !dbg !99
  %13 = call ptr @__wcp_prepare_context(ptr @_Z16worker_fast_pathPv, ptr %12), !dbg !100
  %14 = call i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @thread_wrapper, ptr noundef %13) #4, !dbg !100
  call void @__wcp_read(ptr %10, ptr @2), !dbg !101
  %15 = load i64, ptr %10, align 8, !dbg !101
  call void @__wcp_thread_create(i64 %15), !dbg !101
  br label %16, !dbg !101

16:                                               ; preds = %8
  %17 = load i64, ptr %3, align 8, !dbg !102
  %18 = add nsw i64 %17, 1, !dbg !102
  store i64 %18, ptr %3, align 8, !dbg !102
  br label %5, !dbg !103, !llvm.loop !104

19:                                               ; preds = %5
    #dbg_declare(ptr %4, !106, !DIExpression(), !108)
  store i32 0, ptr %4, align 4, !dbg !108
  br label %20, !dbg !109

20:                                               ; preds = %29, %19
  %21 = load i32, ptr %4, align 4, !dbg !110
  %22 = icmp slt i32 %21, 4, !dbg !112
  br i1 %22, label %23, label %32, !dbg !113

23:                                               ; preds = %20
  %24 = load i32, ptr %4, align 4, !dbg !114
  %25 = sext i32 %24 to i64, !dbg !116
  %26 = getelementptr inbounds [4 x i64], ptr %2, i64 0, i64 %25, !dbg !116
  call void @__wcp_read(ptr %26, ptr @3), !dbg !116
  %27 = load i64, ptr %26, align 8, !dbg !116
  %28 = call i32 @pthread_join(i64 noundef %27, ptr noundef null) #5, !dbg !117
  call void @__wcp_thread_join(i64 %27), !dbg !118
  br label %29, !dbg !118

29:                                               ; preds = %23
  %30 = load i32, ptr %4, align 4, !dbg !119
  %31 = add nsw i32 %30, 1, !dbg !119
  store i32 %31, ptr %4, align 4, !dbg !119
  br label %20, !dbg !120, !llvm.loop !121

32:                                               ; preds = %20
  %33 = call i32 (ptr, ...) @printf(ptr noundef @.str) #5, !dbg !123
  ret i32 0, !dbg !124
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

declare i32 @printf(ptr noundef, ...) #3

declare void @__wcp_read(ptr, ptr)

declare void @__wcp_write(ptr, ptr)

declare void @__wcp_lock(ptr)

declare void @__wcp_unlock(ptr)

declare void @__wcp_thread_create(i64)

declare void @__wcp_thread_join(i64)

declare ptr @__wcp_prepare_context(ptr, ptr)

declare ptr @thread_wrapper(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nobuiltin nounwind "no-builtins" }
attributes #5 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!19, !20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "private_chunks", scope: !2, file: !3, line: 8, type: !15, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "../benchmarks/targets/new_claude_benchmarks/test2.cpp", directory: "/mnt/c/Users/dhruv/Desktop/IIT-Kanpur/Sem 2/CS636/course_project/CS636_course_project_IITK/wcp", checksumkind: CSK_MD5, checksum: "62d1226f530a5d2de4342099f393ed02")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 208, elements: !13)
!11 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!12 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!13 = !{!14}
!14 = !DISubrange(count: 26)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 131072, elements: !17)
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{!18}
!18 = !DISubrange(count: 4096)
!19 = !{i32 7, !"Dwarf Version", i32 5}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{i32 8, !"PIC Level", i32 2}
!23 = !{i32 7, !"PIE Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 2}
!25 = !{i32 7, !"frame-pointer", i32 2}
!26 = !{!"clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)"}
!27 = distinct !DISubprogram(name: "worker_fast_path", linkageName: "_Z16worker_fast_pathPv", scope: !3, file: !3, line: 10, type: !28, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!28 = !DISubroutineType(types: !29)
!29 = !{!6, !6}
!30 = !{}
!31 = !DILocalVariable(name: "arg", arg: 1, scope: !27, file: !3, line: 10, type: !6)
!32 = !DILocation(line: 10, column: 30, scope: !27)
!33 = !DILocalVariable(name: "tid", scope: !27, file: !3, line: 11, type: !5)
!34 = !DILocation(line: 11, column: 10, scope: !27)
!35 = !DILocation(line: 11, column: 22, scope: !27)
!36 = !DILocation(line: 11, column: 16, scope: !27)
!37 = !DILocalVariable(name: "start", scope: !27, file: !3, line: 12, type: !5)
!38 = !DILocation(line: 12, column: 10, scope: !27)
!39 = !DILocation(line: 12, column: 18, scope: !27)
!40 = !DILocation(line: 12, column: 22, scope: !27)
!41 = !DILocalVariable(name: "iter", scope: !42, file: !3, line: 15, type: !16)
!42 = distinct !DILexicalBlock(scope: !27, file: !3, line: 15, column: 5)
!43 = !DILocation(line: 15, column: 14, scope: !42)
!44 = !DILocation(line: 15, column: 10, scope: !42)
!45 = !DILocation(line: 15, column: 24, scope: !46)
!46 = distinct !DILexicalBlock(scope: !42, file: !3, line: 15, column: 5)
!47 = !DILocation(line: 15, column: 29, scope: !46)
!48 = !DILocation(line: 15, column: 5, scope: !42)
!49 = !DILocalVariable(name: "i", scope: !50, file: !3, line: 16, type: !5)
!50 = distinct !DILexicalBlock(scope: !51, file: !3, line: 16, column: 9)
!51 = distinct !DILexicalBlock(scope: !46, file: !3, line: 15, column: 51)
!52 = !DILocation(line: 16, column: 19, scope: !50)
!53 = !DILocation(line: 16, column: 14, scope: !50)
!54 = !DILocation(line: 16, column: 26, scope: !55)
!55 = distinct !DILexicalBlock(scope: !50, file: !3, line: 16, column: 9)
!56 = !DILocation(line: 16, column: 28, scope: !55)
!57 = !DILocation(line: 16, column: 9, scope: !50)
!58 = !DILocation(line: 17, column: 28, scope: !59)
!59 = distinct !DILexicalBlock(scope: !55, file: !3, line: 16, column: 39)
!60 = !DILocation(line: 17, column: 36, scope: !59)
!61 = !DILocation(line: 17, column: 34, scope: !59)
!62 = !DILocation(line: 17, column: 13, scope: !59)
!63 = !DILocation(line: 17, column: 38, scope: !59)
!64 = !DILocation(line: 18, column: 9, scope: !59)
!65 = !DILocation(line: 16, column: 34, scope: !55)
!66 = !DILocation(line: 16, column: 9, scope: !55)
!67 = distinct !{!67, !57, !68, !69}
!68 = !DILocation(line: 18, column: 9, scope: !50)
!69 = !{!"llvm.loop.mustprogress"}
!70 = !DILocation(line: 19, column: 5, scope: !51)
!71 = !DILocation(line: 15, column: 43, scope: !46)
!72 = !DILocation(line: 15, column: 5, scope: !46)
!73 = distinct !{!73, !48, !74, !69}
!74 = !DILocation(line: 19, column: 5, scope: !42)
!75 = !DILocation(line: 20, column: 5, scope: !27)
!76 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !77, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!77 = !DISubroutineType(types: !78)
!78 = !{!16}
!79 = !DILocalVariable(name: "threads", scope: !76, file: !3, line: 24, type: !80)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !81, size: 256, elements: !84)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !82, line: 27, baseType: !83)
!82 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!83 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!84 = !{!85}
!85 = !DISubrange(count: 4)
!86 = !DILocation(line: 24, column: 15, scope: !76)
!87 = !DILocalVariable(name: "i", scope: !88, file: !3, line: 25, type: !5)
!88 = distinct !DILexicalBlock(scope: !76, file: !3, line: 25, column: 5)
!89 = !DILocation(line: 25, column: 15, scope: !88)
!90 = !DILocation(line: 25, column: 10, scope: !88)
!91 = !DILocation(line: 25, column: 22, scope: !92)
!92 = distinct !DILexicalBlock(scope: !88, file: !3, line: 25, column: 5)
!93 = !DILocation(line: 25, column: 24, scope: !92)
!94 = !DILocation(line: 25, column: 5, scope: !88)
!95 = !DILocation(line: 26, column: 33, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !3, line: 25, column: 44)
!97 = !DILocation(line: 26, column: 25, scope: !96)
!98 = !DILocation(line: 26, column: 68, scope: !96)
!99 = !DILocation(line: 26, column: 61, scope: !96)
!100 = !DILocation(line: 26, column: 9, scope: !96)
!101 = !DILocation(line: 27, column: 5, scope: !96)
!102 = !DILocation(line: 25, column: 39, scope: !92)
!103 = !DILocation(line: 25, column: 5, scope: !92)
!104 = distinct !{!104, !94, !105, !69}
!105 = !DILocation(line: 27, column: 5, scope: !88)
!106 = !DILocalVariable(name: "i", scope: !107, file: !3, line: 28, type: !16)
!107 = distinct !DILexicalBlock(scope: !76, file: !3, line: 28, column: 5)
!108 = !DILocation(line: 28, column: 14, scope: !107)
!109 = !DILocation(line: 28, column: 10, scope: !107)
!110 = !DILocation(line: 28, column: 21, scope: !111)
!111 = distinct !DILexicalBlock(scope: !107, file: !3, line: 28, column: 5)
!112 = !DILocation(line: 28, column: 23, scope: !111)
!113 = !DILocation(line: 28, column: 5, scope: !107)
!114 = !DILocation(line: 29, column: 30, scope: !115)
!115 = distinct !DILexicalBlock(scope: !111, file: !3, line: 28, column: 43)
!116 = !DILocation(line: 29, column: 22, scope: !115)
!117 = !DILocation(line: 29, column: 9, scope: !115)
!118 = !DILocation(line: 30, column: 5, scope: !115)
!119 = !DILocation(line: 28, column: 38, scope: !111)
!120 = !DILocation(line: 28, column: 5, scope: !111)
!121 = distinct !{!121, !113, !122, !69}
!122 = !DILocation(line: 30, column: 5, scope: !107)
!123 = !DILocation(line: 31, column: 5, scope: !76)
!124 = !DILocation(line: 32, column: 5, scope: !76)
