; ModuleID = 'test_target.bc'
source_filename = "src/test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.timespec = type { i64, i64 }

@gl = dso_local local_unnamed_addr global ptr null, align 8, !dbg !0
@_ZL11g_vec_mutex = internal global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write, argmem: none, inaccessiblemem: none) uwtable
define dso_local void @_Z6setterPi(ptr noundef %0) local_unnamed_addr #0 !dbg !54 {
    #dbg_value(ptr %0, !58, !DIExpression(), !59)
  call void @__log_store(ptr @gl), !dbg !60
  store ptr %0, ptr @gl, align 8, !dbg !60, !tbaa !61
  ret void, !dbg !66
}

; Function Attrs: mustprogress noinline norecurse uwtable
define dso_local noundef i32 @main() local_unnamed_addr #1 !dbg !67 {
  tail call fastcc void @_ZL23test5_escape_via_vectorv() #6, !dbg !70
  ret i32 0, !dbg !71
}

; Function Attrs: mustprogress noinline norecurse uwtable
define internal fastcc void @_ZL23test5_escape_via_vectorv() unnamed_addr #1 !dbg !72 {
  %1 = alloca i32, align 4, !DIAssignID !81
    #dbg_assign(i1 undef, !76, !DIExpression(), !81, ptr %1, !DIExpression(), !82)
  %2 = alloca i64, align 8, !DIAssignID !83
    #dbg_assign(i1 undef, !77, !DIExpression(), !83, ptr %2, !DIExpression(), !82)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #7, !dbg !84
  store i32 0, ptr %1, align 4, !dbg !85, !tbaa !86, !DIAssignID !88
    #dbg_assign(i32 0, !76, !DIExpression(), !88, ptr %1, !DIExpression(), !82)
  %3 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @_ZL11g_vec_mutex) #8, !dbg !89
  call void @__log_lock(ptr @_ZL11g_vec_mutex), !dbg !90
  call void @_Z6setterPi(ptr noundef nonnull %1) #6, !dbg !90
  call void @__log_unlock(ptr @_ZL11g_vec_mutex), !dbg !91
  %4 = call i32 @pthread_mutex_unlock(ptr noundef nonnull @_ZL11g_vec_mutex) #8, !dbg !91
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #7, !dbg !92
  %5 = call i32 @pthread_create(ptr noundef nonnull %2, ptr noundef null, ptr noundef nonnull @_ZL7worker5Pv, ptr noundef null) #8, !dbg !93
  call fastcc void @_ZL12busy_wait_msi() #6, !dbg !94
    #dbg_value(i32 poison, !80, !DIExpression(), !82)
  call void @__log_load(ptr %2), !dbg !95
  %6 = load i64, ptr %2, align 8, !dbg !95, !tbaa !96
  %7 = call i32 @pthread_join(i64 noundef %6, ptr noundef null) #6, !dbg !98
  call void @__log_store(ptr @gl), !dbg !99
  store ptr null, ptr @gl, align 8, !dbg !99, !tbaa !61
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7, !dbg !100
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #7, !dbg !100
  ret void, !dbg !100
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: nounwind
declare !dbg !101 i32 @pthread_mutex_lock(ptr noundef) local_unnamed_addr #3

; Function Attrs: nounwind
declare !dbg !106 i32 @pthread_mutex_unlock(ptr noundef) local_unnamed_addr #3

; Function Attrs: nounwind
declare !dbg !107 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: mustprogress noinline nounwind uwtable
define internal noalias noundef ptr @_ZL7worker5Pv(ptr nocapture readnone %0) #4 !dbg !122 {
    #dbg_value(ptr poison, !124, !DIExpression(), !126)
  %2 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @_ZL11g_vec_mutex) #8, !dbg !127
  call void @__log_lock(ptr @_ZL11g_vec_mutex), !dbg !128
  call void @__log_load(ptr @gl), !dbg !128
  %3 = load ptr, ptr @gl, align 8, !dbg !128, !tbaa !61
    #dbg_value(ptr %3, !125, !DIExpression(), !126)
  call void @__log_unlock(ptr @_ZL11g_vec_mutex), !dbg !129
  %4 = tail call i32 @pthread_mutex_unlock(ptr noundef nonnull @_ZL11g_vec_mutex) #8, !dbg !129
  %5 = icmp eq ptr %3, null, !dbg !130
  br i1 %5, label %7, label %6, !dbg !130

6:                                                ; preds = %1
  call void @__log_store(ptr %3), !dbg !132
  store i32 55, ptr %3, align 4, !dbg !132, !tbaa !86
  br label %7, !dbg !133

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !134
}

; Function Attrs: mustprogress noinline norecurse uwtable
define internal fastcc void @_ZL12busy_wait_msi() unnamed_addr #1 !dbg !135 {
  %1 = alloca %struct.timespec, align 8, !DIAssignID !149
    #dbg_assign(i1 undef, !140, !DIExpression(), !149, ptr %1, !DIExpression(), !150)
    #dbg_value(i32 1, !139, !DIExpression(), !150)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %1) #7, !dbg !151
  call void @__log_store(ptr %1), !dbg !152
  store i64 0, ptr %1, align 8, !dbg !152, !tbaa !153, !DIAssignID !155
    #dbg_assign(i64 0, !140, !DIExpression(DW_OP_LLVM_fragment, 0, 64), !155, ptr %1, !DIExpression(), !150)
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 8, !dbg !152
  call void @__log_store(ptr %2), !dbg !152
  store i64 1000000, ptr %2, align 8, !dbg !152, !tbaa !156, !DIAssignID !157
    #dbg_assign(i64 1000000, !140, !DIExpression(DW_OP_LLVM_fragment, 64, 64), !157, ptr %2, !DIExpression(), !150)
  %3 = call i32 @nanosleep(ptr noundef nonnull %1, ptr noundef null) #6, !dbg !158
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %1) #7, !dbg !159
  ret void, !dbg !159
}

declare !dbg !160 i32 @pthread_join(i64 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

declare !dbg !164 i32 @nanosleep(ptr noundef, ptr noundef) local_unnamed_addr #5

declare void @__log_load(ptr)

declare void @__log_store(ptr)

declare void @__log_lock(ptr)

declare void @__log_unlock(ptr)

attributes #0 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write, argmem: none, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nobuiltin "no-builtins" }
attributes #7 = { nounwind }
attributes #8 = { nobuiltin nounwind "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.linker.options = !{}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51, !52}
!llvm.ident = !{!53}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "gl", scope: !2, file: !3, line: 8, type: !44, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 20.1.8 (0ubuntu4)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, imports: !41, splitDebugInlining: false, nameTableKind: None)
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
!52 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!53 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!54 = distinct !DISubprogram(name: "setter", linkageName: "_Z6setterPi", scope: !3, file: !3, line: 22, type: !55, scopeLine: 22, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !57)
!55 = !DISubroutineType(types: !56)
!56 = !{null, !44}
!57 = !{!58}
!58 = !DILocalVariable(name: "ptr", arg: 1, scope: !54, file: !3, line: 22, type: !44)
!59 = !DILocation(line: 0, scope: !54)
!60 = !DILocation(line: 23, column: 8, scope: !54)
!61 = !{!62, !62, i64 0}
!62 = !{!"p1 int", !63, i64 0}
!63 = !{!"any pointer", !64, i64 0}
!64 = !{!"omnipotent char", !65, i64 0}
!65 = !{!"Simple C++ TBAA"}
!66 = !DILocation(line: 24, column: 5, scope: !54)
!67 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 43, type: !68, scopeLine: 43, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!68 = !DISubroutineType(types: !69)
!69 = !{!18}
!70 = !DILocation(line: 44, column: 5, scope: !67)
!71 = !DILocation(line: 45, column: 5, scope: !67)
!72 = distinct !DISubprogram(name: "test5_escape_via_vector", linkageName: "_ZL23test5_escape_via_vectorv", scope: !3, file: !3, line: 26, type: !73, scopeLine: 26, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !75)
!73 = !DISubroutineType(types: !74)
!74 = !{null}
!75 = !{!76, !77, !80}
!76 = !DILocalVariable(name: "val", scope: !72, file: !3, line: 27, type: !18)
!77 = !DILocalVariable(name: "t", scope: !72, file: !3, line: 33, type: !78)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !10, line: 27, baseType: !79)
!79 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!80 = !DILocalVariable(name: "x", scope: !72, file: !3, line: 36, type: !18)
!81 = distinct !DIAssignID()
!82 = !DILocation(line: 0, scope: !72)
!83 = distinct !DIAssignID()
!84 = !DILocation(line: 27, column: 5, scope: !72)
!85 = !DILocation(line: 27, column: 9, scope: !72)
!86 = !{!87, !87, i64 0}
!87 = !{!"int", !64, i64 0}
!88 = distinct !DIAssignID()
!89 = !DILocation(line: 28, column: 5, scope: !72)
!90 = !DILocation(line: 30, column: 5, scope: !72)
!91 = !DILocation(line: 31, column: 5, scope: !72)
!92 = !DILocation(line: 33, column: 5, scope: !72)
!93 = !DILocation(line: 34, column: 5, scope: !72)
!94 = !DILocation(line: 35, column: 5, scope: !72)
!95 = !DILocation(line: 38, column: 18, scope: !72)
!96 = !{!97, !97, i64 0}
!97 = !{!"long", !64, i64 0}
!98 = !DILocation(line: 38, column: 5, scope: !72)
!99 = !DILocation(line: 40, column: 8, scope: !72)
!100 = !DILocation(line: 41, column: 1, scope: !72)
!101 = !DISubprogram(name: "pthread_mutex_lock", scope: !102, file: !102, line: 794, type: !103, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!102 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "6e3fd55f44fd51456665b56ba786ebd8")
!103 = !DISubroutineType(types: !104)
!104 = !{!18, !105}
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!106 = !DISubprogram(name: "pthread_mutex_unlock", scope: !102, file: !102, line: 835, type: !103, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!107 = !DISubprogram(name: "pthread_create", scope: !102, file: !102, line: 202, type: !108, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!108 = !DISubroutineType(types: !109)
!109 = !{!18, !110, !112, !117, !121}
!110 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !111)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!112 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !113)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !115)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !10, line: 62, baseType: !116)
!116 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !10, line: 56, size: 448, flags: DIFlagFwdDecl, identifier: "_ZTS14pthread_attr_t")
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DISubroutineType(types: !119)
!119 = !{!120, !120}
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !120)
!122 = distinct !DISubprogram(name: "worker5", linkageName: "_ZL7worker5Pv", scope: !3, file: !3, line: 9, type: !118, scopeLine: 9, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !123)
!123 = !{!124, !125}
!124 = !DILocalVariable(arg: 1, scope: !122, file: !3, line: 9, type: !120)
!125 = !DILocalVariable(name: "p", scope: !122, file: !3, line: 12, type: !44)
!126 = !DILocation(line: 0, scope: !122)
!127 = !DILocation(line: 10, column: 5, scope: !122)
!128 = !DILocation(line: 12, column: 15, scope: !122)
!129 = !DILocation(line: 13, column: 5, scope: !122)
!130 = !DILocation(line: 14, column: 9, scope: !131)
!131 = distinct !DILexicalBlock(scope: !122, file: !3, line: 14, column: 9)
!132 = !DILocation(line: 14, column: 15, scope: !131)
!133 = !DILocation(line: 14, column: 12, scope: !131)
!134 = !DILocation(line: 15, column: 5, scope: !122)
!135 = distinct !DISubprogram(name: "busy_wait_ms", linkageName: "_ZL12busy_wait_msi", scope: !3, file: !3, line: 18, type: !136, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !138)
!136 = !DISubroutineType(cc: DW_CC_nocall, types: !137)
!137 = !{null, !18}
!138 = !{!139, !140}
!139 = !DILocalVariable(name: "ms", arg: 1, scope: !135, file: !3, line: 18, type: !18)
!140 = !DILocalVariable(name: "ts", scope: !135, file: !3, line: 19, type: !141)
!141 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !142, line: 11, size: 128, flags: DIFlagTypePassByValue, elements: !143, identifier: "_ZTS8timespec")
!142 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "9378e9ebbd658baccf881d3300eb1828")
!143 = !{!144, !147}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !141, file: !142, line: 16, baseType: !145, size: 64)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !146, line: 160, baseType: !5)
!146 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!147 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !141, file: !142, line: 21, baseType: !148, size: 64, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !146, line: 197, baseType: !5)
!149 = distinct !DIAssignID()
!150 = !DILocation(line: 0, scope: !135)
!151 = !DILocation(line: 19, column: 5, scope: !135)
!152 = !DILocation(line: 19, column: 26, scope: !135)
!153 = !{!154, !97, i64 0}
!154 = !{!"_ZTS8timespec", !97, i64 0, !97, i64 8}
!155 = distinct !DIAssignID()
!156 = !{!154, !97, i64 8}
!157 = distinct !DIAssignID()
!158 = !DILocation(line: 20, column: 5, scope: !135)
!159 = !DILocation(line: 21, column: 1, scope: !135)
!160 = !DISubprogram(name: "pthread_join", scope: !102, file: !102, line: 219, type: !161, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!161 = !DISubroutineType(types: !162)
!162 = !{!18, !78, !163}
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!164 = !DISubprogram(name: "nanosleep", scope: !165, file: !165, line: 281, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!165 = !DIFile(filename: "/usr/include/time.h", directory: "", checksumkind: CSK_MD5, checksum: "3ef5cd00638ddc7c5c68875f9c70f463")
!166 = !DISubroutineType(types: !167)
!167 = !{!18, !168, !170}
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !141)
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
