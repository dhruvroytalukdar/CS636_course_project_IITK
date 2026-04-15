; ModuleID = 'test_target.bc'
source_filename = "src/test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.timespec = type { i64, i64 }

@gl = dso_local global ptr null, align 8, !dbg !0
@_ZL11g_vec_mutex = internal global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local void @_Z6setterPi(ptr noundef %0) #0 !dbg !53 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !57, !DIExpression(), !58)
  %3 = load ptr, ptr %2, align 8, !dbg !59
  call void @__log_store(ptr @gl), !dbg !60
  store ptr %3, ptr @gl, align 8, !dbg !60
  ret void, !dbg !61
}

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #1 !dbg !62 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @_ZL23test5_escape_via_vectorv() #5, !dbg !65
  ret i32 0, !dbg !66
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL23test5_escape_via_vectorv() #2 !dbg !67 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
    #dbg_declare(ptr %1, !70, !DIExpression(), !71)
  store i32 0, ptr %1, align 4, !dbg !71
  %4 = call i32 @pthread_mutex_lock(ptr noundef @_ZL11g_vec_mutex) #6, !dbg !72
  call void @__log_lock(ptr @_ZL11g_vec_mutex), !dbg !73
  call void @_Z6setterPi(ptr noundef %1) #5, !dbg !73
  call void @__log_unlock(ptr @_ZL11g_vec_mutex), !dbg !74
  %5 = call i32 @pthread_mutex_unlock(ptr noundef @_ZL11g_vec_mutex) #6, !dbg !74
    #dbg_declare(ptr %2, !75, !DIExpression(), !78)
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @_ZL7worker5Pv, ptr noundef null) #6, !dbg !79
  call void @_ZL12busy_wait_msi(i32 noundef 1) #5, !dbg !80
    #dbg_declare(ptr %3, !81, !DIExpression(), !82)
  %7 = load i32, ptr %1, align 4, !dbg !83
  store i32 %7, ptr %3, align 4, !dbg !82
  call void @__log_load(ptr %2), !dbg !84
  %8 = load i64, ptr %2, align 8, !dbg !84
  %9 = call i32 @pthread_join(i64 noundef %8, ptr noundef null) #5, !dbg !85
  call void @__log_store(ptr @gl), !dbg !86
  store ptr null, ptr @gl, align 8, !dbg !86
  ret void, !dbg !87
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef ptr @_ZL7worker5Pv(ptr noundef %0) #0 !dbg !88 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !92, !DIExpression(), !93)
  %4 = call i32 @pthread_mutex_lock(ptr noundef @_ZL11g_vec_mutex) #6, !dbg !94
    #dbg_declare(ptr %3, !95, !DIExpression(), !96)
  call void @__log_lock(ptr @_ZL11g_vec_mutex), !dbg !97
  call void @__log_load(ptr @gl), !dbg !97
  %5 = load ptr, ptr @gl, align 8, !dbg !97
  %6 = icmp eq ptr %5, null, !dbg !98
  br i1 %6, label %7, label %8, !dbg !97

7:                                                ; preds = %1
  br label %10, !dbg !97

8:                                                ; preds = %1
  call void @__log_load(ptr @gl), !dbg !99
  %9 = load ptr, ptr @gl, align 8, !dbg !99
  br label %10, !dbg !97

10:                                               ; preds = %8, %7
  %11 = phi ptr [ null, %7 ], [ %9, %8 ], !dbg !97
  store ptr %11, ptr %3, align 8, !dbg !96
  call void @__log_unlock(ptr @_ZL11g_vec_mutex), !dbg !100
  %12 = call i32 @pthread_mutex_unlock(ptr noundef @_ZL11g_vec_mutex) #6, !dbg !100
  %13 = load ptr, ptr %3, align 8, !dbg !101
  %14 = icmp ne ptr %13, null, !dbg !101
  br i1 %14, label %15, label %17, !dbg !101

15:                                               ; preds = %10
  %16 = load ptr, ptr %3, align 8, !dbg !103
  call void @__log_store(ptr %16), !dbg !104
  store i32 55, ptr %16, align 4, !dbg !104
  br label %17, !dbg !105

17:                                               ; preds = %15, %10
  ret ptr null, !dbg !106
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL12busy_wait_msi(i32 noundef %0) #2 !dbg !107 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.timespec, align 8
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !110, !DIExpression(), !111)
    #dbg_declare(ptr %3, !112, !DIExpression(), !121)
  %4 = getelementptr inbounds nuw %struct.timespec, ptr %3, i32 0, i32 0, !dbg !122
  call void @__log_store(ptr %4), !dbg !122
  store i64 0, ptr %4, align 8, !dbg !122
  %5 = getelementptr inbounds nuw %struct.timespec, ptr %3, i32 0, i32 1, !dbg !122
  %6 = load i32, ptr %2, align 4, !dbg !123
  %7 = sext i32 %6 to i64, !dbg !123
  %8 = mul nsw i64 %7, 1000000, !dbg !124
  call void @__log_store(ptr %5), !dbg !122
  store i64 %8, ptr %5, align 8, !dbg !122
  %9 = call i32 @nanosleep(ptr noundef %3, ptr noundef null) #5, !dbg !125
  ret void, !dbg !126
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #4

declare i32 @nanosleep(ptr noundef, ptr noundef) #4

declare void @__log_load(ptr)

declare void @__log_store(ptr)

declare void @__log_lock(ptr)

declare void @__log_unlock(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nobuiltin "no-builtins" }
attributes #6 = { nobuiltin nounwind "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.linker.options = !{}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "gl", scope: !2, file: !3, line: 8, type: !44, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 20.1.8 (0ubuntu4)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, imports: !41, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "src/test.cpp", directory: "/home/rahulm/work/cs636/CS636_course_project_IITK/fasttrack/targets", checksumkind: CSK_MD5, checksum: "5b021ee22ae0e732cfdc17cad2c17f80")
!4 = !{!5}
!5 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "g_vec_mutex", linkageName: "_ZL11g_vec_mutex", scope: !2, file: !3, line: 6, type: !9, isLocal: true, isDefinition: true)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !10, line: 72, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8e06fe5d0f3f3d4ee6a7a8929dd2b809")
!11 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !10, line: 67, size: 320, flags: DIFlagTypePassByValue, elements: !12, identifier: "_ZTS15pthread_mutex_t")
!12 = !{!13, !35, !40}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !11, file: !10, line: 69, baseType: !14, size: 320)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !15, line: 22, size: 320, flags: DIFlagTypePassByValue, elements: !16, identifier: "_ZTS17__pthread_mutex_s")
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "dd3989155840df74989f662ad537bbcc")
!16 = !{!17, !19, !21, !22, !23, !24, !26, !27}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !14, file: !15, line: 24, baseType: !18, size: 32)
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !14, file: !15, line: 25, baseType: !20, size: 32, offset: 32)
!20 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !14, file: !15, line: 26, baseType: !18, size: 32, offset: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !14, file: !15, line: 28, baseType: !20, size: 32, offset: 96)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !14, file: !15, line: 32, baseType: !18, size: 32, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !14, file: !15, line: 34, baseType: !25, size: 16, offset: 160)
!25 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !14, file: !15, line: 35, baseType: !25, size: 16, offset: 176)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !14, file: !15, line: 36, baseType: !28, size: 128, offset: 192)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !29, line: 55, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4de73b5923ab08445dd348713aeb0a37")
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !29, line: 51, size: 128, flags: DIFlagTypePassByValue, elements: !31, identifier: "_ZTS23__pthread_internal_list")
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !30, file: !29, line: 53, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !30, file: !29, line: 54, baseType: !33, size: 64, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !11, file: !10, line: 70, baseType: !36, size: 320)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 320, elements: !38)
!37 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!38 = !{!39}
!39 = !DISubrange(count: 40)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !11, file: !10, line: 71, baseType: !5, size: 64)
!41 = !{!42}
!42 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !2, entity: !43, file: !3, line: 3)
!43 = !DINamespace(name: "std", scope: null)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 8, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 2}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!53 = distinct !DISubprogram(name: "setter", linkageName: "_Z6setterPi", scope: !3, file: !3, line: 22, type: !54, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{null, !44}
!56 = !{}
!57 = !DILocalVariable(name: "ptr", arg: 1, scope: !53, file: !3, line: 22, type: !44)
!58 = !DILocation(line: 22, column: 18, scope: !53)
!59 = !DILocation(line: 23, column: 10, scope: !53)
!60 = !DILocation(line: 23, column: 8, scope: !53)
!61 = !DILocation(line: 24, column: 5, scope: !53)
!62 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 43, type: !63, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2)
!63 = !DISubroutineType(types: !64)
!64 = !{!18}
!65 = !DILocation(line: 44, column: 5, scope: !62)
!66 = !DILocation(line: 45, column: 5, scope: !62)
!67 = distinct !DISubprogram(name: "test5_escape_via_vector", linkageName: "_ZL23test5_escape_via_vectorv", scope: !3, file: !3, line: 26, type: !68, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!68 = !DISubroutineType(types: !69)
!69 = !{null}
!70 = !DILocalVariable(name: "val", scope: !67, file: !3, line: 27, type: !18)
!71 = !DILocation(line: 27, column: 9, scope: !67)
!72 = !DILocation(line: 28, column: 5, scope: !67)
!73 = !DILocation(line: 30, column: 5, scope: !67)
!74 = !DILocation(line: 31, column: 5, scope: !67)
!75 = !DILocalVariable(name: "t", scope: !67, file: !3, line: 33, type: !76)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !10, line: 27, baseType: !77)
!77 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!78 = !DILocation(line: 33, column: 15, scope: !67)
!79 = !DILocation(line: 34, column: 5, scope: !67)
!80 = !DILocation(line: 35, column: 5, scope: !67)
!81 = !DILocalVariable(name: "x", scope: !67, file: !3, line: 36, type: !18)
!82 = !DILocation(line: 36, column: 9, scope: !67)
!83 = !DILocation(line: 36, column: 13, scope: !67)
!84 = !DILocation(line: 38, column: 18, scope: !67)
!85 = !DILocation(line: 38, column: 5, scope: !67)
!86 = !DILocation(line: 40, column: 8, scope: !67)
!87 = !DILocation(line: 41, column: 1, scope: !67)
!88 = distinct !DISubprogram(name: "worker5", linkageName: "_ZL7worker5Pv", scope: !3, file: !3, line: 9, type: !89, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!89 = !DISubroutineType(types: !90)
!90 = !{!91, !91}
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!92 = !DILocalVariable(arg: 1, scope: !88, file: !3, line: 9, type: !91)
!93 = !DILocation(line: 9, column: 28, scope: !88)
!94 = !DILocation(line: 10, column: 5, scope: !88)
!95 = !DILocalVariable(name: "p", scope: !88, file: !3, line: 12, type: !44)
!96 = !DILocation(line: 12, column: 10, scope: !88)
!97 = !DILocation(line: 12, column: 15, scope: !88)
!98 = !DILocation(line: 12, column: 18, scope: !88)
!99 = !DILocation(line: 12, column: 41, scope: !88)
!100 = !DILocation(line: 13, column: 5, scope: !88)
!101 = !DILocation(line: 14, column: 9, scope: !102)
!102 = distinct !DILexicalBlock(scope: !88, file: !3, line: 14, column: 9)
!103 = !DILocation(line: 14, column: 13, scope: !102)
!104 = !DILocation(line: 14, column: 15, scope: !102)
!105 = !DILocation(line: 14, column: 12, scope: !102)
!106 = !DILocation(line: 15, column: 5, scope: !88)
!107 = distinct !DISubprogram(name: "busy_wait_ms", linkageName: "_ZL12busy_wait_msi", scope: !3, file: !3, line: 18, type: !108, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!108 = !DISubroutineType(types: !109)
!109 = !{null, !18}
!110 = !DILocalVariable(name: "ms", arg: 1, scope: !107, file: !3, line: 18, type: !18)
!111 = !DILocation(line: 18, column: 30, scope: !107)
!112 = !DILocalVariable(name: "ts", scope: !107, file: !3, line: 19, type: !113)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !114, line: 11, size: 128, flags: DIFlagTypePassByValue, elements: !115, identifier: "_ZTS8timespec")
!114 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "9378e9ebbd658baccf881d3300eb1828")
!115 = !{!116, !119}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !113, file: !114, line: 16, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !118, line: 160, baseType: !5)
!118 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!119 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !113, file: !114, line: 21, baseType: !120, size: 64, offset: 64)
!120 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !118, line: 197, baseType: !5)
!121 = !DILocation(line: 19, column: 21, scope: !107)
!122 = !DILocation(line: 19, column: 26, scope: !107)
!123 = !DILocation(line: 19, column: 36, scope: !107)
!124 = !DILocation(line: 19, column: 39, scope: !107)
!125 = !DILocation(line: 20, column: 5, scope: !107)
!126 = !DILocation(line: 21, column: 1, scope: !107)
