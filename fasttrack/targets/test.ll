; ModuleID = 'test_target.bc'
source_filename = "src/sharing_patterns.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.ReadOnly14 = type { [8 x i32] }
%struct.Args7 = type { ptr, i32 }
%struct.Args8 = type { ptr }
%struct.Outer12 = type { %struct.Inner12, i32 }
%struct.Inner12 = type { i32, i32 }
%struct.Args13 = type { i64 }
%struct.CB15 = type { ptr, ptr }
%struct.timespec = type { i64, i64 }
%"struct.std::vector<int *>::_Guard_alloc" = type { ptr, i64, ptr }

$_ZNSt6vectorIPiSaIS0_EED2Ev = comdat any

$_ZNSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv = comdat any

$__clang_call_terminate = comdat any

$_ZNSt12_Vector_baseIPiSaIS0_EED2Ev = comdat any

$_ZSt8_DestroyIPPiEvT_S2_ = comdat any

$_ZNSt12_Vector_baseIPiSaIS0_EE13_M_deallocateEPS0_m = comdat any

$_ZNSt15__new_allocatorIPiE10deallocateEPS0_m = comdat any

$_ZNSt6vectorIPiSaIS0_EE9push_backEOS0_ = comdat any

$_ZNSt6vectorIPiSaIS0_EE5clearEv = comdat any

$_ZNSt6vectorIPiSaIS0_EE12emplace_backIJS0_EEERS0_DpOT_ = comdat any

$_ZNSt6vectorIPiSaIS0_EE17_M_realloc_appendIJS0_EEEvDpOT_ = comdat any

$_ZNSt6vectorIPiSaIS0_EE4backEv = comdat any

$_ZSt12construct_atIPiJS0_EQaant20is_unbounded_array_vIT_ErqXgsnwcvPvLi0E_S1_pispclsr3stdE7declvalIT0_EEEEEPS1_S4_DpOS3_ = comdat any

$_ZNKSt6vectorIPiSaIS0_EE12_M_check_lenEmPKc = comdat any

$_ZNSt6vectorIPiSaIS0_EE3endEv = comdat any

$_ZNSt6vectorIPiSaIS0_EE5beginEv = comdat any

$_ZNSt12_Vector_baseIPiSaIS0_EE11_M_allocateEm = comdat any

$_ZNSt6vectorIPiSaIS0_EE12_Guard_allocC2EPS0_mRSt12_Vector_baseIS0_S1_E = comdat any

$_ZNSt6vectorIPiSaIS0_EE11_S_relocateEPS0_S3_S3_RS1_ = comdat any

$_ZNSt6vectorIPiSaIS0_EE12_Guard_allocD2Ev = comdat any

$_ZNKSt6vectorIPiSaIS0_EE8max_sizeEv = comdat any

$_ZNKSt6vectorIPiSaIS0_EE4sizeEv = comdat any

$_ZSt3maxImERKT_S2_S2_ = comdat any

$_ZNSt6vectorIPiSaIS0_EE11_S_max_sizeERKS1_ = comdat any

$_ZNKSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv = comdat any

$_ZSt3minImERKT_S2_S2_ = comdat any

$_ZNSt15__new_allocatorIPiE8allocateEmPKv = comdat any

$_ZSt12__relocate_aIPPiS1_SaIS0_EET0_T_S4_S3_RT1_ = comdat any

$_ZSt14__relocate_a_1IPiS0_ENSt9enable_ifIXsr3std24__is_bitwise_relocatableIT_EE5valueEPS2_E4typeES3_S3_S3_RSaIT0_E = comdat any

$_ZNKSt6vectorIPiSaIS0_EE5emptyEv = comdat any

$_ZNSt6vectorIPiSaIS0_EEixEm = comdat any

$_ZNKSt6vectorIPiSaIS0_EE5beginEv = comdat any

$_ZNKSt6vectorIPiSaIS0_EE3endEv = comdat any

$_ZNSt6vectorIPiSaIS0_EE15_M_erase_at_endEPS0_ = comdat any

@_ZL6g_ptrs = internal global { { ptr, ptr, ptr } } zeroinitializer, align 8, !dbg !0
@__dso_handle = external hidden global i8
@.str = private unnamed_addr constant [165 x i8] c"\0A\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\0A\00", align 1, !dbg !685
@.str.1 = private unnamed_addr constant [56 x i8] c"  sharing_patterns_test  \E2\80\94  escape analysis coverage\0A\00", align 1, !dbg !690
@.str.2 = private unnamed_addr constant [165 x i8] c"\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\0A\0A\00", align 1, !dbg !695
@_ZL5TESTS = internal unnamed_addr constant [15 x ptr] [ptr @_ZL17test1_heap_escapev, ptr @_ZL12test2_globalv, ptr @_ZL26test3_stack_addr_in_structv, ptr @_ZL26test4_stack_via_global_ptrv, ptr @_ZL23test5_escape_via_vectorv, ptr @_ZL24test6_double_indirectionv, ptr @_ZL27test7_disjoint_array_accessv, ptr @_ZL23test8_overlapping_arrayv, ptr @_ZL31test9_pointer_arithmetic_escapev, ptr @_ZL19test10_thread_localv, ptr @_ZL19test11_private_heapv, ptr @_ZL27test12_nested_struct_escapev, ptr @_ZL24test13_escape_via_memcpyv, ptr @_ZL22test14_readonly_sharedv, ptr @_ZL30test15_function_pointer_escapev], align 16, !dbg !722
@.str.3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1, !dbg !697
@.str.4 = private unnamed_addr constant [164 x i8] c"\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\0A\00", align 1, !dbg !702
@.str.5 = private unnamed_addr constant [11 x i8] c"  Legend:\0A\00", align 1, !dbg !707
@.str.6 = private unnamed_addr constant [48 x i8] c"  [RACE EXPECTED]  \E2\80\94 detector MUST fire here\0A\00", align 1, !dbg !712
@.str.7 = private unnamed_addr constant [53 x i8] c"  [PASS]           \E2\80\94 detector must be SILENT here\0A\00", align 1, !dbg !717
@.str.8 = private unnamed_addr constant [198 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 1  heap object passed as void* arg\0A\00", align 1, !dbg !730
@.str.9 = private unnamed_addr constant [84 x i8] c"  [RACE EXPECTED] heap object passed via arg: store in thread, load in main (racy)\0A\00", align 1, !dbg !735
@.str.10 = private unnamed_addr constant [189 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 2  global variable access\0A\00", align 1, !dbg !740
@_ZL8g_global = internal global i32 0, align 4, !dbg !752
@.str.11 = private unnamed_addr constant [62 x i8] c"  [RACE EXPECTED] global: concurrent read/write without lock\0A\00", align 1, !dbg !745
@_ZL9g_mutex_2 = internal global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !755
@.str.12 = private unnamed_addr constant [62 x i8] c"  [PASS] global: concurrent read/write WITH lock \E2\80\93 no race\0A\00", align 1, !dbg !750
@.str.13 = private unnamed_addr constant [211 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 3  stack variable address stored in heap struct\0A\00", align 1, !dbg !787
@.str.14 = private unnamed_addr constant [75 x i8] c"  [RACE EXPECTED] stack var address in heap struct: concurrent r/w (racy)\0A\00", align 1, !dbg !792
@.str.15 = private unnamed_addr constant [222 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 4  stack variable address published through global pointer\0A\00", align 1, !dbg !797
@_ZL11g_stack_ptr = internal unnamed_addr global ptr null, align 8, !dbg !804
@.str.16 = private unnamed_addr constant [75 x i8] c"  [RACE EXPECTED] stack var through global pointer: concurrent r/w (racy)\0A\00", align 1, !dbg !802
@.str.17 = private unnamed_addr constant [205 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 5  pointer escapes via global std::vector\0A\00", align 1, !dbg !806
@_ZL11g_vec_mutex = internal global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !816
@.str.18 = private unnamed_addr constant [72 x i8] c"  [RACE EXPECTED] pointer through global vector: concurrent r/w (racy)\0A\00", align 1, !dbg !811
@.str.19 = private unnamed_addr constant [26 x i8] c"vector::_M_realloc_append\00", align 1, !dbg !818
@.str.20 = private unnamed_addr constant [206 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 6  double indirection (pointer-to-pointer)\0A\00", align 1, !dbg !824
@.str.21 = private unnamed_addr constant [66 x i8] c"  [RACE EXPECTED] double indirection: **pp=66 vs read val (racy)\0A\00", align 1, !dbg !829
@.str.22 = private unnamed_addr constant [216 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 7  shared array, disjoint per-thread elements (safe)\0A\00", align 1, !dbg !834
@.str.23 = private unnamed_addr constant [78 x i8] c"  [PASS] disjoint array elements: each thread writes arr[i] only \E2\80\93 no race\0A\00", align 1, !dbg !839
@.str.24 = private unnamed_addr constant [205 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 8  shared array, overlapping index (racy)\0A\00", align 1, !dbg !844
@.str.25 = private unnamed_addr constant [78 x i8] c"  [RACE EXPECTED] arr[0] incremented & decremented concurrently without sync\0A\00", align 1, !dbg !846
@.str.26 = private unnamed_addr constant [217 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 9  stack array escapes via &arr[2] pointer arithmetic\0A\00", align 1, !dbg !848
@.str.27 = private unnamed_addr constant [78 x i8] c"  [RACE EXPECTED] stack array escapes via interior pointer &arr[2]: r/w racy\0A\00", align 1, !dbg !853
@.str.28 = private unnamed_addr constant [224 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 10 thread-local storage (__thread) \E2\80\93 should NOT instrument\0A\00", align 1, !dbg !855
@.str.29 = private unnamed_addr constant [71 x i8] c"  [PASS] TLS accesses: no sharing, no race; detector should be silent\0A\00", align 1, !dbg !860
@_ZL11tls_counter = internal thread_local unnamed_addr global i32 0, align 4, !dbg !865
@.str.30 = private unnamed_addr constant [219 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 11 thread-private heap object \E2\80\93 should NOT instrument\0A\00", align 1, !dbg !867
@.str.31 = private unnamed_addr constant [76 x i8] c"  [PASS] private heap: each thread owns its allocation; no escape, no race\0A\00", align 1, !dbg !872
@.str.32 = private unnamed_addr constant [193 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 12 nested struct field escape\0A\00", align 1, !dbg !877
@.str.33 = private unnamed_addr constant [82 x i8] c"  [RACE EXPECTED] nested struct: concurrent read of inner.x and write of inner.x\0A\00", align 1, !dbg !882
@.str.34 = private unnamed_addr constant [192 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 13 pointer escape via memcpy\0A\00", align 1, !dbg !887
@.str.35 = private unnamed_addr constant [86 x i8] c"  [RACE EXPECTED] pointer memcpy'd into struct: thread writes *p concurrently (racy)\0A\00", align 1, !dbg !892
@.str.36 = private unnamed_addr constant [209 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 14 read-only shared struct (safe \E2\80\93 no race)\0A\00", align 1, !dbg !897
@__const._ZL22test14_readonly_sharedv.ro = private unnamed_addr constant %struct.ReadOnly14 { [8 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8] }, align 4
@.str.37 = private unnamed_addr constant [80 x i8] c"  [PASS] read-only shared: N threads read same const object, no write \E2\80\93 safe\0A\00", align 1, !dbg !902
@.str.38 = private unnamed_addr constant [205 x i8] c"\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\E2\94\80\0ATEST 15 escape via function pointer / callback\0A\00", align 1, !dbg !907
@.str.39 = private unnamed_addr constant [93 x i8] c"  [RACE EXPECTED] function-pointer callback writes to caller's local: concurrent r/w (racy)\0A\00", align 1, !dbg !909
@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @_GLOBAL__sub_I_sharing_patterns.cpp, ptr null }]

; Function Attrs: nofree noinline nounwind uwtable
define internal fastcc void @__cxx_global_var_init() unnamed_addr #0 section ".text.startup" !dbg !1247 {
  %1 = tail call i32 @__cxa_atexit(ptr nonnull @_ZNSt6vectorIPiSaIS0_EED2Ev, ptr nonnull @_ZL6g_ptrs, ptr nonnull @__dso_handle) #26, !dbg !1248
  ret void, !dbg !1248
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt6vectorIPiSaIS0_EED2Ev(ptr noundef nonnull align 8 dereferenceable(24) %0) unnamed_addr #1 comdat align 2 personality ptr @__gxx_personality_v0 !dbg !1249 {
    #dbg_value(ptr %0, !1251, !DIExpression(), !1253)
  call void @__log_load(ptr %0), !dbg !1254
  %2 = load ptr, ptr %0, align 8, !dbg !1254, !tbaa !1256
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !1262
  call void @__log_load(ptr %3), !dbg !1262
  %4 = load ptr, ptr %3, align 8, !dbg !1262, !tbaa !1263
  %5 = tail call noundef nonnull align 1 dereferenceable(1) ptr @_ZNSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !1264
    #dbg_value(ptr %2, !1265, !DIExpression(), !1274)
    #dbg_value(ptr %4, !1270, !DIExpression(), !1274)
    #dbg_value(ptr %5, !1271, !DIExpression(), !1274)
  tail call void @_ZSt8_DestroyIPPiEvT_S2_(ptr noundef %2, ptr noundef %4) #28, !dbg !1276
  tail call void @_ZNSt12_Vector_baseIPiSaIS0_EED2Ev(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !1277
  ret void, !dbg !1278
}

; Function Attrs: nofree nounwind
declare i32 @__cxa_atexit(ptr, ptr, ptr) local_unnamed_addr #2

; Function Attrs: mustprogress noinline norecurse uwtable
define dso_local noundef i32 @main(i32 noundef %0, ptr nocapture noundef readonly %1) local_unnamed_addr #3 !dbg !1279 {
    #dbg_value(i32 %0, !1283, !DIExpression(), !1289)
    #dbg_value(ptr %1, !1284, !DIExpression(), !1289)
  %3 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str) #28, !dbg !1290
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.1) #28, !dbg !1291
  %5 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.2) #28, !dbg !1292
    #dbg_value(i32 -1, !1285, !DIExpression(), !1289)
  %6 = icmp eq i32 %0, 2, !dbg !1293
  br i1 %6, label %7, label %12, !dbg !1293

7:                                                ; preds = %2
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 8, !dbg !1295
  call void @__log_load(ptr %8), !dbg !1295
  %9 = load ptr, ptr %8, align 8, !dbg !1295, !tbaa !1296
  %10 = tail call i32 @atoi(ptr noundef %9) #29, !dbg !1298
  %11 = add nsw i32 %10, -1, !dbg !1299
    #dbg_value(i32 %11, !1285, !DIExpression(), !1289)
  br label %12, !dbg !1300

12:                                               ; preds = %7, %2
  %13 = phi i32 [ %11, %7 ], [ -1, %2 ], !dbg !1289
    #dbg_value(i32 %13, !1285, !DIExpression(), !1289)
    #dbg_value(i32 15, !1286, !DIExpression(), !1289)
    #dbg_value(i32 0, !1287, !DIExpression(), !1301)
  %14 = icmp slt i32 %13, 0
    #dbg_value(i32 0, !1287, !DIExpression(), !1301)
  %15 = zext i32 %13 to i64, !dbg !1302
  br label %22, !dbg !1302

16:                                               ; preds = %30
  %17 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.4) #28, !dbg !1303
  %18 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.5) #28, !dbg !1304
  %19 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.6) #28, !dbg !1305
  %20 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.7) #28, !dbg !1306
  %21 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.2) #28, !dbg !1307
  ret i32 0, !dbg !1308

22:                                               ; preds = %12, %30
  %23 = phi i64 [ 0, %12 ], [ %31, %30 ]
    #dbg_value(i64 %23, !1287, !DIExpression(), !1301)
  %24 = icmp eq i64 %23, %15
  %25 = or i1 %14, %24, !dbg !1309
  br i1 %25, label %26, label %30, !dbg !1309

26:                                               ; preds = %22
  %27 = getelementptr inbounds nuw [15 x ptr], ptr @_ZL5TESTS, i64 0, i64 %23, !dbg !1313
  call void @__log_load(ptr %27), !dbg !1313
  %28 = load ptr, ptr %27, align 8, !dbg !1313, !tbaa !1314
  tail call void %28() #28, !dbg !1313
  %29 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.3) #28, !dbg !1315
  br label %30, !dbg !1316

30:                                               ; preds = %22, %26
  %31 = add nuw nsw i64 %23, 1, !dbg !1317
    #dbg_value(i64 %31, !1287, !DIExpression(), !1301)
  %32 = icmp eq i64 %31, 15, !dbg !1318
  br i1 %32, label %16, label %22, !dbg !1302, !llvm.loop !1319
}

declare !dbg !1323 i32 @printf(ptr noundef, ...) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #5

; Function Attrs: mustprogress nofree nounwind willreturn memory(read)
declare !dbg !951 i32 @atoi(ptr noundef) local_unnamed_addr #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #5

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef nonnull align 1 dereferenceable(1) ptr @_ZNSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !1327 {
    #dbg_value(ptr %0, !1329, !DIExpression(), !1331)
  ret ptr %0, !dbg !1332
}

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind uwtable
define linkonce_odr hidden void @__clang_call_terminate(ptr noundef %0) local_unnamed_addr #7 comdat {
  %2 = tail call ptr @__cxa_begin_catch(ptr %0) #26
  tail call void @_ZSt9terminatev() #30
  unreachable
}

declare ptr @__cxa_begin_catch(ptr) local_unnamed_addr

; Function Attrs: cold nofree noreturn
declare void @_ZSt9terminatev() local_unnamed_addr #8

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt12_Vector_baseIPiSaIS0_EED2Ev(ptr noundef nonnull align 8 dereferenceable(24) %0) unnamed_addr #1 comdat align 2 personality ptr @__gxx_personality_v0 !dbg !1333 {
    #dbg_value(ptr %0, !1335, !DIExpression(), !1336)
  call void @__log_load(ptr %0), !dbg !1337
  %2 = load ptr, ptr %0, align 8, !dbg !1337, !tbaa !1256
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 16, !dbg !1339
  call void @__log_load(ptr %3), !dbg !1339
  %4 = load ptr, ptr %3, align 8, !dbg !1339, !tbaa !1340
  %5 = ptrtoint ptr %4 to i64, !dbg !1341
  %6 = ptrtoint ptr %2 to i64, !dbg !1341
  %7 = sub i64 %5, %6, !dbg !1341
  %8 = ashr exact i64 %7, 3, !dbg !1341
  invoke void @_ZNSt12_Vector_baseIPiSaIS0_EE13_M_deallocateEPS0_m(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef %2, i64 noundef %8) #28
          to label %9 unwind label %10, !dbg !1342

9:                                                ; preds = %1
  ret void, !dbg !1343

10:                                               ; preds = %1
  %11 = landingpad { ptr, i32 }
          catch ptr null, !dbg !1342
  %12 = extractvalue { ptr, i32 } %11, 0, !dbg !1342
  tail call void @__clang_call_terminate(ptr %12) #30, !dbg !1342
  unreachable, !dbg !1342
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZSt8_DestroyIPPiEvT_S2_(ptr noundef %0, ptr noundef %1) local_unnamed_addr #1 comdat !dbg !1344 {
    #dbg_value(ptr %0, !1349, !DIExpression(), !1352)
    #dbg_value(ptr %1, !1350, !DIExpression(), !1352)
  ret void, !dbg !1353
}

; Function Attrs: mustprogress noinline uwtable
define linkonce_odr dso_local void @_ZNSt12_Vector_baseIPiSaIS0_EE13_M_deallocateEPS0_m(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef %1, i64 noundef %2) local_unnamed_addr #9 comdat align 2 !dbg !1354 {
    #dbg_value(ptr %0, !1356, !DIExpression(), !1359)
    #dbg_value(ptr %1, !1357, !DIExpression(), !1359)
    #dbg_value(i64 %2, !1358, !DIExpression(), !1359)
  %4 = icmp eq ptr %1, null, !dbg !1360
  br i1 %4, label %6, label %5, !dbg !1360

5:                                                ; preds = %3
    #dbg_value(ptr %0, !1362, !DIExpression(), !1367)
    #dbg_value(ptr %1, !1365, !DIExpression(), !1367)
    #dbg_value(i64 %2, !1366, !DIExpression(), !1367)
    #dbg_value(ptr %0, !1369, !DIExpression(), !1375)
    #dbg_value(ptr %1, !1372, !DIExpression(), !1375)
    #dbg_value(i64 %2, !1373, !DIExpression(), !1375)
  tail call void @_ZNSt15__new_allocatorIPiE10deallocateEPS0_m(ptr noundef nonnull align 1 dereferenceable(1) %0, ptr noundef nonnull %1, i64 noundef %2) #28, !dbg !1377
  br label %6, !dbg !1378

6:                                                ; preds = %5, %3
  ret void, !dbg !1379
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt15__new_allocatorIPiE10deallocateEPS0_m(ptr noundef nonnull align 1 dereferenceable(1) %0, ptr noundef %1, i64 noundef %2) local_unnamed_addr #1 comdat align 2 !dbg !1380 {
    #dbg_value(ptr %0, !1382, !DIExpression(), !1386)
    #dbg_value(ptr %1, !1384, !DIExpression(), !1386)
    #dbg_value(i64 %2, !1385, !DIExpression(), !1386)
  %4 = shl i64 %2, 3, !dbg !1387
  tail call void @_ZdlPvm(ptr noundef %1, i64 noundef %4) #31, !dbg !1388
  ret void, !dbg !1389
}

; Function Attrs: nobuiltin nounwind
declare void @_ZdlPvm(ptr noundef, i64 noundef) local_unnamed_addr #10

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL17test1_heap_escapev() #9 !dbg !1390 {
  %1 = alloca i64, align 8, !DIAssignID !1396
    #dbg_assign(i1 undef, !1393, !DIExpression(), !1396, ptr %1, !DIExpression(), !1397)
  %2 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.8) #28, !dbg !1398
  %3 = tail call noalias ptr @malloc(i64 noundef 4) #27, !dbg !1399
    #dbg_value(ptr %3, !1392, !DIExpression(), !1397)
  call void @__log_store(ptr %3), !dbg !1400
  store i32 0, ptr %3, align 4, !dbg !1400, !tbaa !1401
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %1) #26, !dbg !1404
  %4 = call i32 @pthread_create(ptr noundef nonnull %1, ptr noundef null, ptr noundef nonnull @_ZL14worker1_writerPv, ptr noundef nonnull %3) #27, !dbg !1405
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1406
    #dbg_value(i32 poison, !1395, !DIExpression(), !1397)
  call void @__log_load(ptr %1), !dbg !1407
  %5 = load i64, ptr %1, align 8, !dbg !1407, !tbaa !1408
  %6 = call i32 @pthread_join(i64 noundef %5, ptr noundef null) #28, !dbg !1410
  %7 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.9) #28, !dbg !1411
  call void @free(ptr noundef nonnull %3) #27, !dbg !1412
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %1) #26, !dbg !1413
  ret void, !dbg !1413
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL12test2_globalv() #9 !dbg !1414 {
  %1 = alloca i64, align 8, !DIAssignID !1419
    #dbg_assign(i1 undef, !1416, !DIExpression(), !1419, ptr %1, !DIExpression(), !1420)
  %2 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.10) #28, !dbg !1421
  call void @__log_store(ptr @_ZL8g_global), !dbg !1422
  store volatile i32 0, ptr @_ZL8g_global, align 4, !dbg !1422, !tbaa !1423
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %1) #26, !dbg !1424
  %3 = call i32 @pthread_create(ptr noundef nonnull %1, ptr noundef null, ptr noundef nonnull @_ZL12worker2_racePv, ptr noundef null) #27, !dbg !1425
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1426
  call void @__log_load(ptr @_ZL8g_global), !dbg !1427
  %4 = load volatile i32, ptr @_ZL8g_global, align 4, !dbg !1427, !tbaa !1423
    #dbg_value(i32 %4, !1417, !DIExpression(), !1420)
  call void @__log_load(ptr %1), !dbg !1428
  %5 = load i64, ptr %1, align 8, !dbg !1428, !tbaa !1408
  %6 = call i32 @pthread_join(i64 noundef %5, ptr noundef null) #28, !dbg !1429
  %7 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.11) #28, !dbg !1430
  %8 = call i32 @pthread_create(ptr noundef nonnull %1, ptr noundef null, ptr noundef nonnull @_ZL12worker2_safePv, ptr noundef null) #27, !dbg !1431
  %9 = call i32 @pthread_mutex_lock(ptr noundef nonnull @_ZL9g_mutex_2) #27, !dbg !1432
  call void @__log_lock(ptr @_ZL9g_mutex_2), !dbg !1433
  call void @__log_load(ptr @_ZL8g_global), !dbg !1433
  %10 = load volatile i32, ptr @_ZL8g_global, align 4, !dbg !1433, !tbaa !1423
    #dbg_value(i32 %10, !1418, !DIExpression(), !1420)
  call void @__log_unlock(ptr @_ZL9g_mutex_2), !dbg !1434
  %11 = call i32 @pthread_mutex_unlock(ptr noundef nonnull @_ZL9g_mutex_2) #27, !dbg !1434
  call void @__log_load(ptr %1), !dbg !1435
  %12 = load i64, ptr %1, align 8, !dbg !1435, !tbaa !1408
  %13 = call i32 @pthread_join(i64 noundef %12, ptr noundef null) #28, !dbg !1436
  %14 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.12) #28, !dbg !1437
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %1) #26, !dbg !1438
  ret void, !dbg !1438
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL26test3_stack_addr_in_structv() #9 !dbg !1439 {
  %1 = alloca i32, align 4, !DIAssignID !1445
    #dbg_assign(i1 undef, !1441, !DIExpression(), !1445, ptr %1, !DIExpression(), !1446)
  %2 = alloca i64, align 8, !DIAssignID !1447
    #dbg_assign(i1 undef, !1443, !DIExpression(), !1447, ptr %2, !DIExpression(), !1446)
  %3 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.13) #28, !dbg !1448
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #26, !dbg !1449
  call void @__log_store(ptr %1), !dbg !1450
  store i32 0, ptr %1, align 4, !dbg !1450, !tbaa !1423, !DIAssignID !1451
    #dbg_assign(i32 0, !1441, !DIExpression(), !1451, ptr %1, !DIExpression(), !1446)
  %4 = tail call noalias noundef nonnull dereferenceable(8) ptr @_Znwm(i64 noundef 8) #32, !dbg !1452, !heapallocsite !12
    #dbg_value(ptr %4, !1442, !DIExpression(), !1446)
  call void @__log_store(ptr %4), !dbg !1453
  store ptr %1, ptr %4, align 8, !dbg !1453, !tbaa !1454
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1457
  %5 = call i32 @pthread_create(ptr noundef nonnull %2, ptr noundef null, ptr noundef nonnull @_ZL7worker3Pv, ptr noundef nonnull %4) #27, !dbg !1458
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1459
    #dbg_value(i32 poison, !1444, !DIExpression(), !1446)
  call void @__log_load(ptr %2), !dbg !1460
  %6 = load i64, ptr %2, align 8, !dbg !1460, !tbaa !1408
  %7 = call i32 @pthread_join(i64 noundef %6, ptr noundef null) #28, !dbg !1461
  %8 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.14) #28, !dbg !1462
  call void @_ZdlPvm(ptr noundef nonnull %4, i64 noundef 8) #31, !dbg !1463
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1464
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #26, !dbg !1464
  ret void, !dbg !1464
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL26test4_stack_via_global_ptrv() #9 !dbg !1465 {
  %1 = alloca i32, align 4, !DIAssignID !1470
    #dbg_assign(i1 undef, !1467, !DIExpression(), !1470, ptr %1, !DIExpression(), !1471)
  %2 = alloca i64, align 8, !DIAssignID !1472
    #dbg_assign(i1 undef, !1468, !DIExpression(), !1472, ptr %2, !DIExpression(), !1471)
  %3 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.15) #28, !dbg !1473
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #26, !dbg !1474
  call void @__log_store(ptr %1), !dbg !1475
  store i32 0, ptr %1, align 4, !dbg !1475, !tbaa !1423, !DIAssignID !1476
    #dbg_assign(i32 0, !1467, !DIExpression(), !1476, ptr %1, !DIExpression(), !1471)
  call void @__log_store(ptr @_ZL11g_stack_ptr), !dbg !1477
  store ptr %1, ptr @_ZL11g_stack_ptr, align 8, !dbg !1477, !tbaa !1478
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1479
  %4 = call i32 @pthread_create(ptr noundef nonnull %2, ptr noundef null, ptr noundef nonnull @_ZL7worker4Pv, ptr noundef null) #27, !dbg !1480
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1481
    #dbg_value(i32 poison, !1469, !DIExpression(), !1471)
  call void @__log_load(ptr %2), !dbg !1482
  %5 = load i64, ptr %2, align 8, !dbg !1482, !tbaa !1408
  %6 = call i32 @pthread_join(i64 noundef %5, ptr noundef null) #28, !dbg !1483
  call void @__log_store(ptr @_ZL11g_stack_ptr), !dbg !1484
  store ptr null, ptr @_ZL11g_stack_ptr, align 8, !dbg !1484, !tbaa !1478
  %7 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.16) #28, !dbg !1485
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1486
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #26, !dbg !1486
  ret void, !dbg !1486
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL23test5_escape_via_vectorv() #9 !dbg !1487 {
  %1 = alloca i32, align 4, !DIAssignID !1492
    #dbg_assign(i1 undef, !1489, !DIExpression(), !1492, ptr %1, !DIExpression(), !1493)
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8, !DIAssignID !1494
    #dbg_assign(i1 undef, !1490, !DIExpression(), !1494, ptr %3, !DIExpression(), !1493)
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.17) #28, !dbg !1495
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #26, !dbg !1496
  store i32 0, ptr %1, align 4, !dbg !1497, !tbaa !1423, !DIAssignID !1498
    #dbg_assign(i32 0, !1489, !DIExpression(), !1498, ptr %1, !DIExpression(), !1493)
  %5 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @_ZL11g_vec_mutex) #27, !dbg !1499
  call void @__log_lock(ptr @_ZL11g_vec_mutex), !dbg !1500
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1500
  store ptr %1, ptr %2, align 8, !dbg !1500, !tbaa !1478
  call void @_ZNSt6vectorIPiSaIS0_EE9push_backEOS0_(ptr noundef nonnull align 8 dereferenceable(24) @_ZL6g_ptrs, ptr noundef nonnull align 8 dereferenceable(8) %2) #28, !dbg !1501
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1502
  call void @__log_unlock(ptr @_ZL11g_vec_mutex), !dbg !1503
  %6 = call i32 @pthread_mutex_unlock(ptr noundef nonnull @_ZL11g_vec_mutex) #27, !dbg !1503
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #26, !dbg !1504
  %7 = call i32 @pthread_create(ptr noundef nonnull %3, ptr noundef null, ptr noundef nonnull @_ZL7worker5Pv, ptr noundef null) #27, !dbg !1505
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1506
    #dbg_value(i32 poison, !1491, !DIExpression(), !1493)
  call void @__log_load(ptr %3), !dbg !1507
  %8 = load i64, ptr %3, align 8, !dbg !1507, !tbaa !1408
  %9 = call i32 @pthread_join(i64 noundef %8, ptr noundef null) #28, !dbg !1508
  call void @_ZNSt6vectorIPiSaIS0_EE5clearEv(ptr noundef nonnull align 8 dereferenceable(24) @_ZL6g_ptrs) #27, !dbg !1509
  %10 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.18) #28, !dbg !1510
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #26, !dbg !1511
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #26, !dbg !1511
  ret void, !dbg !1511
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL24test6_double_indirectionv() #9 !dbg !1512 {
  %1 = alloca i32, align 4, !DIAssignID !1519
    #dbg_assign(i1 undef, !1514, !DIExpression(), !1519, ptr %1, !DIExpression(), !1520)
  %2 = alloca ptr, align 8, !DIAssignID !1521
    #dbg_assign(i1 undef, !1515, !DIExpression(), !1521, ptr %2, !DIExpression(), !1520)
  %3 = alloca i64, align 8, !DIAssignID !1522
    #dbg_assign(i1 undef, !1517, !DIExpression(), !1522, ptr %3, !DIExpression(), !1520)
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.20) #28, !dbg !1523
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #26, !dbg !1524
  call void @__log_store(ptr %1), !dbg !1525
  store i32 0, ptr %1, align 4, !dbg !1525, !tbaa !1423, !DIAssignID !1526
    #dbg_assign(i32 0, !1514, !DIExpression(), !1526, ptr %1, !DIExpression(), !1520)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1527
  call void @__log_store(ptr %2), !dbg !1528
  store ptr %1, ptr %2, align 8, !dbg !1528, !tbaa !1478, !DIAssignID !1529
    #dbg_assign(ptr %1, !1515, !DIExpression(), !1529, ptr %2, !DIExpression(), !1520)
    #dbg_value(ptr %2, !1516, !DIExpression(), !1520)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #26, !dbg !1530
  %5 = call i32 @pthread_create(ptr noundef nonnull %3, ptr noundef null, ptr noundef nonnull @_ZL7worker6Pv, ptr noundef nonnull %2) #27, !dbg !1531
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1532
    #dbg_value(i32 poison, !1518, !DIExpression(), !1520)
  call void @__log_load(ptr %3), !dbg !1533
  %6 = load i64, ptr %3, align 8, !dbg !1533, !tbaa !1408
  %7 = call i32 @pthread_join(i64 noundef %6, ptr noundef null) #28, !dbg !1534
  %8 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.21) #28, !dbg !1535
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #26, !dbg !1536
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1536
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #26, !dbg !1536
  ret void, !dbg !1536
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL27test7_disjoint_array_accessv() #9 !dbg !1537 {
  %1 = alloca [4 x i32], align 16, !DIAssignID !1552
    #dbg_assign(i1 undef, !1540, !DIExpression(), !1552, ptr %1, !DIExpression(), !1553)
  %2 = alloca [4 x i64], align 16, !DIAssignID !1554
    #dbg_assign(i1 undef, !1544, !DIExpression(), !1554, ptr %2, !DIExpression(), !1553)
  %3 = alloca [4 x %struct.Args7], align 16, !DIAssignID !1555
    #dbg_assign(i1 undef, !1546, !DIExpression(), !1555, ptr %3, !DIExpression(), !1553)
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.22) #28, !dbg !1556
    #dbg_value(i32 4, !1539, !DIExpression(), !1553)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %1) #26, !dbg !1557
  %5 = call ptr @memset(ptr noundef nonnull %1, i32 noundef 0, i64 noundef 16) #27, !dbg !1558
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #26, !dbg !1559
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %3) #26, !dbg !1560
    #dbg_value(i32 0, !1548, !DIExpression(), !1561)
  br label %6, !dbg !1562

6:                                                ; preds = %0, %6
  %7 = phi i64 [ 0, %0 ], [ %13, %6 ]
    #dbg_value(i64 %7, !1548, !DIExpression(), !1561)
  %8 = getelementptr inbounds nuw [4 x %struct.Args7], ptr %3, i64 0, i64 %7, !dbg !1563
  call void @__log_store(ptr %8), !dbg !1566
  store ptr %1, ptr %8, align 16, !dbg !1566, !tbaa !1567
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 8, !dbg !1569
  %10 = trunc nuw nsw i64 %7 to i32, !dbg !1570
  call void @__log_store(ptr %9), !dbg !1570
  store i32 %10, ptr %9, align 8, !dbg !1570, !tbaa !1571
  %11 = getelementptr inbounds nuw [4 x i64], ptr %2, i64 0, i64 %7, !dbg !1572
  %12 = call i32 @pthread_create(ptr noundef nonnull %11, ptr noundef null, ptr noundef nonnull @_ZL7worker7Pv, ptr noundef nonnull %8) #27, !dbg !1573
  %13 = add nuw nsw i64 %7, 1, !dbg !1574
    #dbg_value(i64 %13, !1548, !DIExpression(), !1561)
  %14 = icmp eq i64 %13, 4, !dbg !1575
  br i1 %14, label %17, label %6, !dbg !1562, !llvm.loop !1576

15:                                               ; preds = %17
  %16 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.23) #28, !dbg !1578
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %3) #26, !dbg !1579
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #26, !dbg !1579
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %1) #26, !dbg !1579
  ret void, !dbg !1579

17:                                               ; preds = %6, %17
  %18 = phi i64 [ %22, %17 ], [ 0, %6 ]
    #dbg_value(i64 %18, !1550, !DIExpression(), !1580)
  %19 = getelementptr inbounds nuw [4 x i64], ptr %2, i64 0, i64 %18, !dbg !1581
  call void @__log_load(ptr %19), !dbg !1581
  %20 = load i64, ptr %19, align 8, !dbg !1581, !tbaa !1408
  %21 = call i32 @pthread_join(i64 noundef %20, ptr noundef null) #28, !dbg !1583
  %22 = add nuw nsw i64 %18, 1, !dbg !1584
    #dbg_value(i64 %22, !1550, !DIExpression(), !1580)
  %23 = icmp eq i64 %22, 4, !dbg !1585
  br i1 %23, label %15, label %17, !dbg !1586, !llvm.loop !1587
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL23test8_overlapping_arrayv() #9 !dbg !1589 {
  %1 = alloca [4 x i32], align 16, !DIAssignID !1595
    #dbg_assign(i1 undef, !1591, !DIExpression(), !1595, ptr %1, !DIExpression(), !1596)
  %2 = alloca %struct.Args8, align 8, !DIAssignID !1597
    #dbg_assign(i1 undef, !1592, !DIExpression(), !1597, ptr %2, !DIExpression(), !1596)
  %3 = alloca i64, align 8, !DIAssignID !1598
    #dbg_assign(i1 undef, !1593, !DIExpression(), !1598, ptr %3, !DIExpression(), !1596)
  %4 = alloca i64, align 8, !DIAssignID !1599
    #dbg_assign(i1 undef, !1594, !DIExpression(), !1599, ptr %4, !DIExpression(), !1596)
  %5 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.24) #28, !dbg !1600
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %1) #26, !dbg !1601
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %1, i8 0, i64 16, i1 false), !dbg !1602, !DIAssignID !1603
    #dbg_assign(i8 0, !1591, !DIExpression(), !1603, ptr %1, !DIExpression(), !1596)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1604
  call void @__log_store(ptr %2), !dbg !1605
  store ptr %1, ptr %2, align 8, !dbg !1605, !tbaa !1606, !DIAssignID !1608
    #dbg_assign(ptr %1, !1592, !DIExpression(), !1608, ptr %2, !DIExpression(), !1596)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #26, !dbg !1609
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %4) #26, !dbg !1609
  %6 = call i32 @pthread_create(ptr noundef nonnull %3, ptr noundef null, ptr noundef nonnull @_ZL8worker8aPv, ptr noundef nonnull %2) #27, !dbg !1610
  %7 = call i32 @pthread_create(ptr noundef nonnull %4, ptr noundef null, ptr noundef nonnull @_ZL8worker8bPv, ptr noundef nonnull %2) #27, !dbg !1611
  call void @__log_load(ptr %3), !dbg !1612
  %8 = load i64, ptr %3, align 8, !dbg !1612, !tbaa !1408
  %9 = call i32 @pthread_join(i64 noundef %8, ptr noundef null) #28, !dbg !1613
  call void @__log_load(ptr %4), !dbg !1614
  %10 = load i64, ptr %4, align 8, !dbg !1614, !tbaa !1408
  %11 = call i32 @pthread_join(i64 noundef %10, ptr noundef null) #28, !dbg !1615
  %12 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.25) #28, !dbg !1616
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %4) #26, !dbg !1617
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #26, !dbg !1617
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1617
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %1) #26, !dbg !1617
  ret void, !dbg !1617
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL31test9_pointer_arithmetic_escapev() #9 !dbg !1618 {
  %1 = alloca [6 x i32], align 16, !DIAssignID !1626
    #dbg_assign(i1 undef, !1620, !DIExpression(), !1626, ptr %1, !DIExpression(), !1627)
  %2 = alloca i64, align 8, !DIAssignID !1628
    #dbg_assign(i1 undef, !1624, !DIExpression(), !1628, ptr %2, !DIExpression(), !1627)
  %3 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.26) #28, !dbg !1629
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %1) #26, !dbg !1630
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(24) %1, i8 0, i64 24, i1 false), !dbg !1631, !DIAssignID !1632
    #dbg_assign(i8 0, !1620, !DIExpression(), !1632, ptr %1, !DIExpression(), !1627)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1633
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 8, !dbg !1634
  %5 = call i32 @pthread_create(ptr noundef nonnull %2, ptr noundef null, ptr noundef nonnull @_ZL7worker9Pv, ptr noundef nonnull %4) #27, !dbg !1635
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1636
    #dbg_value(!DIArgList(i32 poison, i32 poison), !1625, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !1627)
  call void @__log_load(ptr %2), !dbg !1637
  %6 = load i64, ptr %2, align 8, !dbg !1637, !tbaa !1408
  %7 = call i32 @pthread_join(i64 noundef %6, ptr noundef null) #28, !dbg !1638
  %8 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.27) #28, !dbg !1639
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1640
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %1) #26, !dbg !1640
  ret void, !dbg !1640
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL19test10_thread_localv() #9 !dbg !1641 {
  %1 = alloca [4 x i64], align 16, !DIAssignID !1649
    #dbg_assign(i1 undef, !1644, !DIExpression(), !1649, ptr %1, !DIExpression(), !1650)
  %2 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.28) #28, !dbg !1651
    #dbg_value(i32 4, !1643, !DIExpression(), !1650)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #26, !dbg !1652
    #dbg_value(i32 0, !1645, !DIExpression(), !1653)
  br label %3, !dbg !1654

3:                                                ; preds = %0, %3
  %4 = phi i64 [ 0, %0 ], [ %7, %3 ]
    #dbg_value(i64 %4, !1645, !DIExpression(), !1653)
  %5 = getelementptr inbounds nuw [4 x i64], ptr %1, i64 0, i64 %4, !dbg !1655
  %6 = call i32 @pthread_create(ptr noundef nonnull %5, ptr noundef null, ptr noundef nonnull @_ZL8worker10Pv, ptr noundef null) #27, !dbg !1657
  %7 = add nuw nsw i64 %4, 1, !dbg !1658
    #dbg_value(i64 %7, !1645, !DIExpression(), !1653)
  %8 = icmp eq i64 %7, 4, !dbg !1659
  br i1 %8, label %11, label %3, !dbg !1654, !llvm.loop !1660

9:                                                ; preds = %11
  %10 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.29) #28, !dbg !1662
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #26, !dbg !1663
  ret void, !dbg !1663

11:                                               ; preds = %3, %11
  %12 = phi i64 [ %16, %11 ], [ 0, %3 ]
    #dbg_value(i64 %12, !1647, !DIExpression(), !1664)
  %13 = getelementptr inbounds nuw [4 x i64], ptr %1, i64 0, i64 %12, !dbg !1665
  call void @__log_load(ptr %13), !dbg !1665
  %14 = load i64, ptr %13, align 8, !dbg !1665, !tbaa !1408
  %15 = call i32 @pthread_join(i64 noundef %14, ptr noundef null) #28, !dbg !1667
  %16 = add nuw nsw i64 %12, 1, !dbg !1668
    #dbg_value(i64 %16, !1647, !DIExpression(), !1664)
  %17 = icmp eq i64 %16, 4, !dbg !1669
  br i1 %17, label %9, label %11, !dbg !1670, !llvm.loop !1671
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL19test11_private_heapv() #9 !dbg !1673 {
  %1 = alloca [4 x i64], align 16, !DIAssignID !1681
    #dbg_assign(i1 undef, !1676, !DIExpression(), !1681, ptr %1, !DIExpression(), !1682)
  %2 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.30) #28, !dbg !1683
    #dbg_value(i32 4, !1675, !DIExpression(), !1682)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #26, !dbg !1684
    #dbg_value(i32 0, !1677, !DIExpression(), !1685)
  br label %3, !dbg !1686

3:                                                ; preds = %0, %3
  %4 = phi i64 [ 0, %0 ], [ %7, %3 ]
    #dbg_value(i64 %4, !1677, !DIExpression(), !1685)
  %5 = getelementptr inbounds nuw [4 x i64], ptr %1, i64 0, i64 %4, !dbg !1687
  %6 = call i32 @pthread_create(ptr noundef nonnull %5, ptr noundef null, ptr noundef nonnull @_ZL8worker11Pv, ptr noundef null) #27, !dbg !1689
  %7 = add nuw nsw i64 %4, 1, !dbg !1690
    #dbg_value(i64 %7, !1677, !DIExpression(), !1685)
  %8 = icmp eq i64 %7, 4, !dbg !1691
  br i1 %8, label %11, label %3, !dbg !1686, !llvm.loop !1692

9:                                                ; preds = %11
  %10 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.31) #28, !dbg !1694
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #26, !dbg !1695
  ret void, !dbg !1695

11:                                               ; preds = %3, %11
  %12 = phi i64 [ %16, %11 ], [ 0, %3 ]
    #dbg_value(i64 %12, !1679, !DIExpression(), !1696)
  %13 = getelementptr inbounds nuw [4 x i64], ptr %1, i64 0, i64 %12, !dbg !1697
  call void @__log_load(ptr %13), !dbg !1697
  %14 = load i64, ptr %13, align 8, !dbg !1697, !tbaa !1408
  %15 = call i32 @pthread_join(i64 noundef %14, ptr noundef null) #28, !dbg !1699
  %16 = add nuw nsw i64 %12, 1, !dbg !1700
    #dbg_value(i64 %16, !1679, !DIExpression(), !1696)
  %17 = icmp eq i64 %16, 4, !dbg !1701
  br i1 %17, label %9, label %11, !dbg !1702, !llvm.loop !1703
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL27test12_nested_struct_escapev() #9 !dbg !1705 {
  %1 = alloca %struct.Outer12, align 4, !DIAssignID !1710
    #dbg_assign(i1 undef, !1707, !DIExpression(), !1710, ptr %1, !DIExpression(), !1711)
  %2 = alloca i64, align 8, !DIAssignID !1712
    #dbg_assign(i1 undef, !1708, !DIExpression(), !1712, ptr %2, !DIExpression(), !1711)
  %3 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.32) #28, !dbg !1713
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %1) #26, !dbg !1714
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %1, i8 0, i64 12, i1 false), !dbg !1715, !DIAssignID !1716
    #dbg_assign(i8 0, !1707, !DIExpression(), !1716, ptr %1, !DIExpression(), !1711)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1717
  %4 = call i32 @pthread_create(ptr noundef nonnull %2, ptr noundef null, ptr noundef nonnull @_ZL8worker12Pv, ptr noundef nonnull %1) #27, !dbg !1718
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1719
    #dbg_value(i32 poison, !1709, !DIExpression(), !1711)
  call void @__log_load(ptr %2), !dbg !1720
  %5 = load i64, ptr %2, align 8, !dbg !1720, !tbaa !1408
  %6 = call i32 @pthread_join(i64 noundef %5, ptr noundef null) #28, !dbg !1721
  %7 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.33) #28, !dbg !1722
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1723
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %1) #26, !dbg !1723
  ret void, !dbg !1723
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL24test13_escape_via_memcpyv() #9 !dbg !1724 {
  %1 = alloca i32, align 4, !DIAssignID !1731
    #dbg_assign(i1 undef, !1726, !DIExpression(), !1731, ptr %1, !DIExpression(), !1732)
  %2 = alloca %struct.Args13, align 8, !DIAssignID !1733
    #dbg_assign(i1 undef, !1727, !DIExpression(), !1733, ptr %2, !DIExpression(), !1732)
  %3 = alloca i64, align 8, !DIAssignID !1734
    #dbg_assign(i1 undef, !1728, !DIExpression(), !1734, ptr %3, !DIExpression(), !1732)
  %4 = alloca i64, align 8, !DIAssignID !1735
    #dbg_assign(i1 undef, !1729, !DIExpression(), !1735, ptr %4, !DIExpression(), !1732)
  %5 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.34) #28, !dbg !1736
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #26, !dbg !1737
  call void @__log_store(ptr %1), !dbg !1738
  store i32 0, ptr %1, align 4, !dbg !1738, !tbaa !1423, !DIAssignID !1739
    #dbg_assign(i32 0, !1726, !DIExpression(), !1739, ptr %1, !DIExpression(), !1732)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !1740
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #26, !dbg !1741
  %6 = ptrtoint ptr %1 to i64, !dbg !1742
  call void @__log_store(ptr %3), !dbg !1743
  store i64 %6, ptr %3, align 8, !dbg !1743, !tbaa !1408, !DIAssignID !1744
    #dbg_assign(i64 %6, !1728, !DIExpression(), !1744, ptr %3, !DIExpression(), !1732)
  %7 = call ptr @memcpy(ptr noundef nonnull %2, ptr noundef nonnull %3, i64 noundef 8) #27, !dbg !1745
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %4) #26, !dbg !1746
  %8 = call i32 @pthread_create(ptr noundef nonnull %4, ptr noundef null, ptr noundef nonnull @_ZL8worker13Pv, ptr noundef nonnull %2) #27, !dbg !1747
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1748
    #dbg_value(i32 poison, !1730, !DIExpression(), !1732)
  call void @__log_load(ptr %4), !dbg !1749
  %9 = load i64, ptr %4, align 8, !dbg !1749, !tbaa !1408
  %10 = call i32 @pthread_join(i64 noundef %9, ptr noundef null) #28, !dbg !1750
  %11 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.35) #28, !dbg !1751
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %4) #26, !dbg !1752
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #26, !dbg !1752
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !1752
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #26, !dbg !1752
  ret void, !dbg !1752
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL22test14_readonly_sharedv() #9 !dbg !1753 {
  %1 = alloca %struct.ReadOnly14, align 4, !DIAssignID !1762
    #dbg_assign(i1 undef, !1755, !DIExpression(), !1762, ptr %1, !DIExpression(), !1763)
  %2 = alloca [4 x i64], align 16, !DIAssignID !1764
    #dbg_assign(i1 undef, !1757, !DIExpression(), !1764, ptr %2, !DIExpression(), !1763)
  %3 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.36) #28, !dbg !1765
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #26, !dbg !1766
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %1, ptr noundef nonnull align 4 dereferenceable(32) @__const._ZL22test14_readonly_sharedv.ro, i64 32, i1 false), !dbg !1767, !DIAssignID !1768
    #dbg_assign(i1 undef, !1755, !DIExpression(), !1768, ptr %1, !DIExpression(), !1763)
    #dbg_value(i32 4, !1756, !DIExpression(), !1763)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #26, !dbg !1769
    #dbg_value(i32 0, !1758, !DIExpression(), !1770)
  br label %4, !dbg !1771

4:                                                ; preds = %0, %4
  %5 = phi i64 [ 0, %0 ], [ %8, %4 ]
    #dbg_value(i64 %5, !1758, !DIExpression(), !1770)
  %6 = getelementptr inbounds nuw [4 x i64], ptr %2, i64 0, i64 %5, !dbg !1772
  %7 = call i32 @pthread_create(ptr noundef nonnull %6, ptr noundef null, ptr noundef nonnull @_ZL8worker14Pv, ptr noundef nonnull %1) #27, !dbg !1774
  %8 = add nuw nsw i64 %5, 1, !dbg !1775
    #dbg_value(i64 %8, !1758, !DIExpression(), !1770)
  %9 = icmp eq i64 %8, 4, !dbg !1776
  br i1 %9, label %12, label %4, !dbg !1771, !llvm.loop !1777

10:                                               ; preds = %12
  %11 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.37) #28, !dbg !1779
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #26, !dbg !1780
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #26, !dbg !1780
  ret void, !dbg !1780

12:                                               ; preds = %4, %12
  %13 = phi i64 [ %17, %12 ], [ 0, %4 ]
    #dbg_value(i64 %13, !1760, !DIExpression(), !1781)
  %14 = getelementptr inbounds nuw [4 x i64], ptr %2, i64 0, i64 %13, !dbg !1782
  call void @__log_load(ptr %14), !dbg !1782
  %15 = load i64, ptr %14, align 8, !dbg !1782, !tbaa !1408
  %16 = call i32 @pthread_join(i64 noundef %15, ptr noundef null) #28, !dbg !1784
  %17 = add nuw nsw i64 %13, 1, !dbg !1785
    #dbg_value(i64 %17, !1760, !DIExpression(), !1781)
  %18 = icmp eq i64 %17, 4, !dbg !1786
  br i1 %18, label %10, label %12, !dbg !1787, !llvm.loop !1788
}

; Function Attrs: mustprogress noinline uwtable
define internal void @_ZL30test15_function_pointer_escapev() #9 !dbg !1790 {
  %1 = alloca i32, align 4, !DIAssignID !1796
    #dbg_assign(i1 undef, !1792, !DIExpression(), !1796, ptr %1, !DIExpression(), !1797)
  %2 = alloca %struct.CB15, align 8, !DIAssignID !1798
    #dbg_assign(i1 undef, !1793, !DIExpression(), !1798, ptr %2, !DIExpression(), !1797)
  %3 = alloca i64, align 8, !DIAssignID !1799
    #dbg_assign(i1 undef, !1794, !DIExpression(), !1799, ptr %3, !DIExpression(), !1797)
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.38) #28, !dbg !1800
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #26, !dbg !1801
  call void @__log_store(ptr %1), !dbg !1802
  store i32 0, ptr %1, align 4, !dbg !1802, !tbaa !1423, !DIAssignID !1803
    #dbg_assign(i32 0, !1792, !DIExpression(), !1803, ptr %1, !DIExpression(), !1797)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #26, !dbg !1804
  call void @__log_store(ptr %2), !dbg !1805
  store ptr @_ZL10cb15_writePv, ptr %2, align 8, !dbg !1805, !tbaa !1806, !DIAssignID !1808
    #dbg_assign(ptr @_ZL10cb15_writePv, !1793, !DIExpression(DW_OP_LLVM_fragment, 0, 64), !1808, ptr %2, !DIExpression(), !1797)
  %5 = getelementptr inbounds nuw i8, ptr %2, i64 8, !dbg !1805
  call void @__log_store(ptr %5), !dbg !1805
  store ptr %1, ptr %5, align 8, !dbg !1805, !tbaa !1809, !DIAssignID !1810
    #dbg_assign(ptr %1, !1793, !DIExpression(DW_OP_LLVM_fragment, 64, 64), !1810, ptr %5, !DIExpression(), !1797)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #26, !dbg !1811
  %6 = call i32 @pthread_create(ptr noundef nonnull %3, ptr noundef null, ptr noundef nonnull @_ZL8worker15Pv, ptr noundef nonnull %2) #27, !dbg !1812
  call fastcc void @_ZL12busy_wait_msi() #28, !dbg !1813
    #dbg_value(i32 poison, !1795, !DIExpression(), !1797)
  call void @__log_load(ptr %3), !dbg !1814
  %7 = load i64, ptr %3, align 8, !dbg !1814, !tbaa !1408
  %8 = call i32 @pthread_join(i64 noundef %7, ptr noundef null) #28, !dbg !1815
  %9 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.39) #28, !dbg !1816
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #26, !dbg !1817
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #26, !dbg !1817
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #26, !dbg !1817
  ret void, !dbg !1817
}

; Function Attrs: nounwind
declare !dbg !992 noalias ptr @malloc(i64 noundef) local_unnamed_addr #11

; Function Attrs: nounwind
declare !dbg !1818 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #11

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
define internal noalias noundef ptr @_ZL14worker1_writerPv(ptr nocapture noundef writeonly initializes((0, 4)) %0) #12 !dbg !1833 {
    #dbg_value(ptr %0, !1835, !DIExpression(), !1837)
    #dbg_value(ptr %0, !1836, !DIExpression(), !1837)
  call void @__log_store(ptr %0), !dbg !1838
  store i32 42, ptr %0, align 4, !dbg !1838, !tbaa !1401
  ret ptr null, !dbg !1839
}

; Function Attrs: mustprogress noinline uwtable
define internal fastcc void @_ZL12busy_wait_msi() unnamed_addr #9 !dbg !1840 {
  %1 = alloca %struct.timespec, align 8, !DIAssignID !1852
    #dbg_assign(i1 undef, !1844, !DIExpression(), !1852, ptr %1, !DIExpression(), !1853)
    #dbg_value(i32 1, !1843, !DIExpression(), !1853)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %1) #26, !dbg !1854
  call void @__log_store(ptr %1), !dbg !1855
  store i64 0, ptr %1, align 8, !dbg !1855, !tbaa !1856, !DIAssignID !1858
    #dbg_assign(i64 0, !1844, !DIExpression(DW_OP_LLVM_fragment, 0, 64), !1858, ptr %1, !DIExpression(), !1853)
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 8, !dbg !1855
  call void @__log_store(ptr %2), !dbg !1855
  store i64 1000000, ptr %2, align 8, !dbg !1855, !tbaa !1859, !DIAssignID !1860
    #dbg_assign(i64 1000000, !1844, !DIExpression(DW_OP_LLVM_fragment, 64, 64), !1860, ptr %2, !DIExpression(), !1853)
  %3 = call i32 @nanosleep(ptr noundef nonnull %1, ptr noundef null) #28, !dbg !1861
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %1) #26, !dbg !1862
  ret void, !dbg !1862
}

declare !dbg !1863 i32 @pthread_join(i64 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: nounwind
declare !dbg !977 void @free(ptr noundef) local_unnamed_addr #11

declare !dbg !1867 i32 @nanosleep(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nofree noinline norecurse nounwind memory(readwrite, argmem: none) uwtable
define internal noalias noundef ptr @_ZL12worker2_racePv(ptr nocapture readnone %0) #13 !dbg !1874 {
    #dbg_value(ptr poison, !1876, !DIExpression(), !1877)
  call void @__log_store(ptr @_ZL8g_global), !dbg !1878
  store volatile i32 1, ptr @_ZL8g_global, align 4, !dbg !1878, !tbaa !1423
  ret ptr null, !dbg !1879
}

; Function Attrs: mustprogress noinline nounwind uwtable
define internal noalias noundef ptr @_ZL12worker2_safePv(ptr nocapture readnone %0) #1 !dbg !1880 {
    #dbg_value(ptr poison, !1882, !DIExpression(), !1883)
  %2 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @_ZL9g_mutex_2) #27, !dbg !1884
  call void @__log_lock(ptr @_ZL9g_mutex_2), !dbg !1885
  call void @__log_store(ptr @_ZL8g_global), !dbg !1885
  store volatile i32 1, ptr @_ZL8g_global, align 4, !dbg !1885, !tbaa !1423
  call void @__log_unlock(ptr @_ZL9g_mutex_2), !dbg !1886
  %3 = tail call i32 @pthread_mutex_unlock(ptr noundef nonnull @_ZL9g_mutex_2) #27, !dbg !1886
  ret ptr null, !dbg !1887
}

; Function Attrs: nounwind
declare !dbg !1888 i32 @pthread_mutex_lock(ptr noundef) local_unnamed_addr #11

; Function Attrs: nounwind
declare !dbg !1892 i32 @pthread_mutex_unlock(ptr noundef) local_unnamed_addr #11

; Function Attrs: nobuiltin allocsize(0)
declare noalias noundef nonnull ptr @_Znwm(i64 noundef) local_unnamed_addr #14

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none) uwtable
define internal noalias noundef ptr @_ZL7worker3Pv(ptr nocapture noundef readonly %0) #15 !dbg !1893 {
    #dbg_value(ptr %0, !1895, !DIExpression(), !1897)
    #dbg_value(ptr %0, !1896, !DIExpression(), !1897)
  call void @__log_load(ptr %0), !dbg !1898
  %2 = load ptr, ptr %0, align 8, !dbg !1898, !tbaa !1454
  call void @__log_store(ptr %2), !dbg !1899
  store i32 99, ptr %2, align 4, !dbg !1899, !tbaa !1423
  ret ptr null, !dbg !1900
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(readwrite, argmem: write, inaccessiblemem: none) uwtable
define internal noalias noundef ptr @_ZL7worker4Pv(ptr nocapture readnone %0) #16 !dbg !1901 {
    #dbg_value(ptr poison, !1903, !DIExpression(), !1904)
  call void @__log_load(ptr @_ZL11g_stack_ptr), !dbg !1905
  %2 = load ptr, ptr @_ZL11g_stack_ptr, align 8, !dbg !1905, !tbaa !1478
  %3 = icmp eq ptr %2, null, !dbg !1905
  br i1 %3, label %5, label %4, !dbg !1905

4:                                                ; preds = %1
  call void @__log_store(ptr %2), !dbg !1907
  store i32 77, ptr %2, align 4, !dbg !1907, !tbaa !1423
  br label %5, !dbg !1908

5:                                                ; preds = %4, %1
  ret ptr null, !dbg !1909
}

; Function Attrs: mustprogress noinline uwtable
define linkonce_odr dso_local void @_ZNSt6vectorIPiSaIS0_EE9push_backEOS0_(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef nonnull align 8 dereferenceable(8) %1) local_unnamed_addr #9 comdat align 2 !dbg !1910 {
    #dbg_value(ptr %0, !1912, !DIExpression(), !1914)
    #dbg_value(ptr %1, !1913, !DIExpression(), !1914)
  %3 = tail call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSt6vectorIPiSaIS0_EE12emplace_backIJS0_EEERS0_DpOT_(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef nonnull align 8 dereferenceable(8) %1) #28, !dbg !1915
  ret void, !dbg !1916
}

; Function Attrs: mustprogress noinline nounwind uwtable
define internal noalias noundef ptr @_ZL7worker5Pv(ptr nocapture readnone %0) #1 !dbg !1917 {
    #dbg_value(ptr poison, !1919, !DIExpression(), !1921)
  %2 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @_ZL11g_vec_mutex) #27, !dbg !1922
  call void @__log_lock(ptr @_ZL11g_vec_mutex), !dbg !1923
  %3 = tail call noundef zeroext i1 @_ZNKSt6vectorIPiSaIS0_EE5emptyEv(ptr noundef nonnull align 8 dereferenceable(24) @_ZL6g_ptrs) #27, !dbg !1923
  br i1 %3, label %7, label %4, !dbg !1924

4:                                                ; preds = %1
  %5 = tail call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSt6vectorIPiSaIS0_EEixEm(ptr noundef nonnull align 8 dereferenceable(24) @_ZL6g_ptrs, i64 noundef 0) #27, !dbg !1925
  call void @__log_load(ptr %5), !dbg !1925
  %6 = load ptr, ptr %5, align 8, !dbg !1925, !tbaa !1478
  br label %7, !dbg !1924

7:                                                ; preds = %1, %4
  %8 = phi ptr [ %6, %4 ], [ null, %1 ], !dbg !1924
    #dbg_value(ptr %8, !1920, !DIExpression(), !1921)
  call void @__log_unlock(ptr @_ZL11g_vec_mutex), !dbg !1926
  %9 = tail call i32 @pthread_mutex_unlock(ptr noundef nonnull @_ZL11g_vec_mutex) #27, !dbg !1926
  %10 = icmp eq ptr %8, null, !dbg !1927
  br i1 %10, label %12, label %11, !dbg !1927

11:                                               ; preds = %7
  call void @__log_store(ptr %8), !dbg !1929
  store i32 55, ptr %8, align 4, !dbg !1929, !tbaa !1423
  br label %12, !dbg !1930

12:                                               ; preds = %11, %7
  ret ptr null, !dbg !1931
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt6vectorIPiSaIS0_EE5clearEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !1932 {
    #dbg_value(ptr %0, !1934, !DIExpression(), !1935)
  call void @__log_load(ptr %0), !dbg !1936
  %2 = load ptr, ptr %0, align 8, !dbg !1936, !tbaa !1256
  tail call void @_ZNSt6vectorIPiSaIS0_EE15_M_erase_at_endEPS0_(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef %2) #27, !dbg !1937
  ret void, !dbg !1938
}

; Function Attrs: mustprogress noinline uwtable
define linkonce_odr dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZNSt6vectorIPiSaIS0_EE12emplace_backIJS0_EEERS0_DpOT_(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef nonnull align 8 dereferenceable(8) %1) local_unnamed_addr #9 comdat align 2 !dbg !1939 {
    #dbg_value(ptr %0, !1949, !DIExpression(), !1951)
    #dbg_value(ptr %1, !1950, !DIExpression(), !1951)
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !1952
  call void @__log_load(ptr %3), !dbg !1952
  %4 = load ptr, ptr %3, align 8, !dbg !1952, !tbaa !1263
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16, !dbg !1954
  call void @__log_load(ptr %5), !dbg !1954
  %6 = load ptr, ptr %5, align 8, !dbg !1954, !tbaa !1340
  %7 = icmp eq ptr %4, %6, !dbg !1955
  br i1 %7, label %12, label %8, !dbg !1955

8:                                                ; preds = %2
    #dbg_value(ptr %0, !1956, !DIExpression(), !1966)
    #dbg_value(ptr %4, !1964, !DIExpression(), !1966)
    #dbg_value(ptr %1, !1965, !DIExpression(), !1966)
  %9 = tail call noundef ptr @_ZSt12construct_atIPiJS0_EQaant20is_unbounded_array_vIT_ErqXgsnwcvPvLi0E_S1_pispclsr3stdE7declvalIT0_EEEEEPS1_S4_DpOS3_(ptr noundef %4, ptr noundef nonnull align 8 dereferenceable(8) %1) #27, !dbg !1969
  call void @__log_load(ptr %3), !dbg !1970
  %10 = load ptr, ptr %3, align 8, !dbg !1970, !tbaa !1263
  %11 = getelementptr inbounds nuw i8, ptr %10, i64 8, !dbg !1970
  call void @__log_store(ptr %3), !dbg !1970
  store ptr %11, ptr %3, align 8, !dbg !1970, !tbaa !1263
  br label %13, !dbg !1971

12:                                               ; preds = %2
  tail call void @_ZNSt6vectorIPiSaIS0_EE17_M_realloc_appendIJS0_EEEvDpOT_(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef nonnull align 8 dereferenceable(8) %1) #28, !dbg !1972
  br label %13

13:                                               ; preds = %12, %8
  %14 = tail call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSt6vectorIPiSaIS0_EE4backEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !1973
  ret ptr %14, !dbg !1974
}

; Function Attrs: mustprogress noinline uwtable
define linkonce_odr dso_local void @_ZNSt6vectorIPiSaIS0_EE17_M_realloc_appendIJS0_EEEvDpOT_(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef nonnull align 8 dereferenceable(8) %1) local_unnamed_addr #9 comdat align 2 !dbg !1975 {
    #dbg_value(ptr undef, !1991, !DIExpression(), !1998)
    #dbg_value(ptr undef, !1997, !DIExpression(), !1998)
  %3 = alloca %"struct.std::vector<int *>::_Guard_alloc", align 8, !DIAssignID !2000
    #dbg_assign(i1 undef, !1989, !DIExpression(), !2000, ptr %3, !DIExpression(), !2001)
    #dbg_value(ptr %0, !1980, !DIExpression(), !2002)
    #dbg_value(ptr %1, !1981, !DIExpression(), !2002)
  %4 = tail call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE12_M_check_lenEmPKc(ptr noundef nonnull align 8 dereferenceable(24) %0, i64 noundef 1, ptr noundef nonnull @.str.19) #28, !dbg !2003
    #dbg_value(i64 %4, !1982, !DIExpression(), !2002)
  %5 = icmp ne i64 %4, 0, !dbg !2004
  tail call void @llvm.assume(i1 %5), !dbg !2004
  call void @__log_load(ptr %0), !dbg !2006
  %6 = load ptr, ptr %0, align 8, !dbg !2006, !tbaa !1256
    #dbg_value(ptr %6, !1984, !DIExpression(), !2002)
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2007
  call void @__log_load(ptr %7), !dbg !2007
  %8 = load ptr, ptr %7, align 8, !dbg !2007, !tbaa !1263
    #dbg_value(ptr %8, !1985, !DIExpression(), !2002)
  %9 = tail call ptr @_ZNSt6vectorIPiSaIS0_EE3endEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2008
  %10 = tail call ptr @_ZNSt6vectorIPiSaIS0_EE5beginEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2009
  %11 = ptrtoint ptr %9 to i64, !dbg !2010
  %12 = ptrtoint ptr %10 to i64, !dbg !2010
  %13 = sub i64 %11, %12, !dbg !2010
    #dbg_value(i64 %13, !1986, !DIExpression(DW_OP_constu, 3, DW_OP_shra, DW_OP_stack_value), !2002)
  %14 = tail call noundef ptr @_ZNSt12_Vector_baseIPiSaIS0_EE11_M_allocateEm(ptr noundef nonnull align 8 dereferenceable(24) %0, i64 noundef %4) #28, !dbg !2011
    #dbg_value(ptr %14, !1987, !DIExpression(), !2002)
    #dbg_value(ptr %14, !1988, !DIExpression(), !2002)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %3) #26, !dbg !2012
  call void @_ZNSt6vectorIPiSaIS0_EE12_Guard_allocC2EPS0_mRSt12_Vector_baseIS0_S1_E(ptr noundef nonnull align 8 dereferenceable(24) %3, ptr noundef %14, i64 noundef %4, ptr noundef nonnull align 8 dereferenceable(24) %0) #28, !dbg !2013
  %15 = getelementptr inbounds nuw i8, ptr %14, i64 %13, !dbg !2014
    #dbg_value(ptr %0, !1956, !DIExpression(), !2015)
    #dbg_value(ptr %15, !1964, !DIExpression(), !2015)
    #dbg_value(ptr %1, !1965, !DIExpression(), !2015)
  %16 = call noundef ptr @_ZSt12construct_atIPiJS0_EQaant20is_unbounded_array_vIT_ErqXgsnwcvPvLi0E_S1_pispclsr3stdE7declvalIT0_EEEEEPS1_S4_DpOS3_(ptr noundef %15, ptr noundef nonnull align 8 dereferenceable(8) %1) #27, !dbg !2017
  %17 = call noundef nonnull align 1 dereferenceable(1) ptr @_ZNSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2018
  %18 = call noundef ptr @_ZNSt6vectorIPiSaIS0_EE11_S_relocateEPS0_S3_S3_RS1_(ptr noundef %6, ptr noundef %8, ptr noundef %14, ptr noundef nonnull align 1 dereferenceable(1) %17) #27, !dbg !2021
    #dbg_value(ptr %18, !1988, !DIExpression(), !2002)
  %19 = getelementptr inbounds nuw i8, ptr %18, i64 8, !dbg !2022
    #dbg_value(ptr %19, !1988, !DIExpression(), !2002)
  call void @__log_store(ptr %3), !dbg !2023
  store ptr %6, ptr %3, align 8, !dbg !2023, !tbaa !2024, !DIAssignID !2027
    #dbg_assign(ptr %6, !1989, !DIExpression(DW_OP_LLVM_fragment, 0, 64), !2027, ptr %3, !DIExpression(), !2001)
  %20 = getelementptr inbounds nuw i8, ptr %0, i64 16, !dbg !2028
  call void @__log_load(ptr %20), !dbg !2028
  %21 = load ptr, ptr %20, align 8, !dbg !2028, !tbaa !1340
  %22 = ptrtoint ptr %21 to i64, !dbg !2029
  %23 = ptrtoint ptr %6 to i64, !dbg !2029
  %24 = sub i64 %22, %23, !dbg !2029
  %25 = ashr exact i64 %24, 3, !dbg !2029
  %26 = getelementptr inbounds nuw i8, ptr %3, i64 8, !dbg !2030
  call void @__log_store(ptr %26), !dbg !2031
  store i64 %25, ptr %26, align 8, !dbg !2031, !tbaa !2032, !DIAssignID !2033
    #dbg_assign(i64 %25, !1989, !DIExpression(DW_OP_LLVM_fragment, 64, 64), !2033, ptr %26, !DIExpression(), !2001)
  call void @_ZNSt6vectorIPiSaIS0_EE12_Guard_allocD2Ev(ptr noundef nonnull align 8 dereferenceable(24) %3) #27, !dbg !2034
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %3) #26, !dbg !2034
  call void @__log_store(ptr %0), !dbg !2035
  store ptr %14, ptr %0, align 8, !dbg !2035, !tbaa !1256
  call void @__log_store(ptr %7), !dbg !2036
  store ptr %19, ptr %7, align 8, !dbg !2036, !tbaa !1263
  %27 = getelementptr inbounds nuw ptr, ptr %14, i64 %4, !dbg !2037
  call void @__log_store(ptr %20), !dbg !2038
  store ptr %27, ptr %20, align 8, !dbg !2038, !tbaa !1340
  ret void, !dbg !2039
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZNSt6vectorIPiSaIS0_EE4backEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2040 {
    #dbg_value(ptr undef, !2043, !DIExpression(), !2048)
    #dbg_value(ptr %0, !2042, !DIExpression(), !2050)
  %2 = tail call ptr @_ZNSt6vectorIPiSaIS0_EE3endEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2051
    #dbg_value(i64 1, !2046, !DIExpression(), !2048)
  %3 = getelementptr inbounds i8, ptr %2, i64 -8, !dbg !2052
  ret ptr %3, !dbg !2053
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef ptr @_ZSt12construct_atIPiJS0_EQaant20is_unbounded_array_vIT_ErqXgsnwcvPvLi0E_S1_pispclsr3stdE7declvalIT0_EEEEEPS1_S4_DpOS3_(ptr noundef %0, ptr noundef nonnull align 8 dereferenceable(8) %1) local_unnamed_addr #1 comdat !dbg !2054 {
    #dbg_value(ptr %0, !2058, !DIExpression(), !2062)
    #dbg_value(ptr %1, !2059, !DIExpression(), !2062)
    #dbg_value(ptr %0, !2060, !DIExpression(), !2062)
  call void @__log_load(ptr %1), !dbg !2063
  %3 = load ptr, ptr %1, align 8, !dbg !2063, !tbaa !1478
  call void @__log_store(ptr %0), !dbg !2065
  store ptr %3, ptr %0, align 8, !dbg !2065, !tbaa !1478
  ret ptr %0, !dbg !2066
}

; Function Attrs: mustprogress noinline uwtable
define linkonce_odr dso_local noundef i64 @_ZNKSt6vectorIPiSaIS0_EE12_M_check_lenEmPKc(ptr noundef nonnull align 8 dereferenceable(24) %0, i64 noundef %1, ptr noundef %2) local_unnamed_addr #9 comdat align 2 !dbg !2067 {
  %4 = alloca i64, align 8, !DIAssignID !2074
    #dbg_assign(i1 undef, !2071, !DIExpression(), !2074, ptr %4, !DIExpression(), !2075)
  %5 = alloca i64, align 8
    #dbg_value(ptr %0, !2069, !DIExpression(), !2075)
  store i64 %1, ptr %4, align 8, !tbaa !1408, !DIAssignID !2076
    #dbg_assign(i64 %1, !2071, !DIExpression(), !2076, ptr %4, !DIExpression(), !2075)
    #dbg_value(ptr %2, !2072, !DIExpression(), !2075)
  %6 = tail call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE8max_sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2077
  %7 = tail call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE4sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2079
  %8 = sub i64 %6, %7, !dbg !2080
  %9 = load i64, ptr %4, align 8, !dbg !2081, !tbaa !1408
  %10 = icmp ult i64 %8, %9, !dbg !2082
  br i1 %10, label %11, label %12, !dbg !2082

11:                                               ; preds = %3
  tail call void @_ZSt20__throw_length_errorPKc(ptr noundef %2) #33, !dbg !2083
  unreachable, !dbg !2083

12:                                               ; preds = %3
  %13 = tail call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE4sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2084
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %5) #26, !dbg !2085
  %14 = tail call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE4sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2085
  store i64 %14, ptr %5, align 8, !dbg !2085, !tbaa !1408
  %15 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt3maxImERKT_S2_S2_(ptr noundef nonnull align 8 dereferenceable(8) %5, ptr noundef nonnull align 8 dereferenceable(8) %4) #28, !dbg !2086
  call void @__log_load(ptr %15), !dbg !2086
  %16 = load i64, ptr %15, align 8, !dbg !2086, !tbaa !1408
  %17 = add i64 %16, %13, !dbg !2087
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %5) #26, !dbg !2084
    #dbg_value(i64 %17, !2073, !DIExpression(), !2075)
  %18 = call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE4sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2088
  %19 = icmp ult i64 %17, %18, !dbg !2089
  br i1 %19, label %23, label %20, !dbg !2090

20:                                               ; preds = %12
  %21 = call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE8max_sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2091
  %22 = icmp ugt i64 %17, %21, !dbg !2092
  br i1 %22, label %23, label %25, !dbg !2093

23:                                               ; preds = %20, %12
  %24 = call noundef i64 @_ZNKSt6vectorIPiSaIS0_EE8max_sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2094
  br label %25, !dbg !2093

25:                                               ; preds = %20, %23
  %26 = phi i64 [ %24, %23 ], [ %17, %20 ], !dbg !2093
  ret i64 %26, !dbg !2095
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local ptr @_ZNSt6vectorIPiSaIS0_EE3endEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2096 {
    #dbg_value(ptr undef, !2099, !DIExpression(), !2104)
    #dbg_value(ptr %0, !2098, !DIExpression(), !2106)
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2107
    #dbg_value(ptr %2, !2102, !DIExpression(), !2104)
  call void @__log_load(ptr %2), !dbg !2108
  %3 = load ptr, ptr %2, align 8, !dbg !2108, !tbaa !2109
  ret ptr %3, !dbg !2110
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local ptr @_ZNSt6vectorIPiSaIS0_EE5beginEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2111 {
    #dbg_value(ptr %0, !2113, !DIExpression(), !2114)
    #dbg_value(ptr undef, !2099, !DIExpression(), !2115)
    #dbg_value(ptr %0, !2102, !DIExpression(), !2115)
  call void @__log_load(ptr %0), !dbg !2117
  %2 = load ptr, ptr %0, align 8, !dbg !2117, !tbaa !2109
  ret ptr %2, !dbg !2118
}

; Function Attrs: mustprogress noinline uwtable
define linkonce_odr dso_local noundef ptr @_ZNSt12_Vector_baseIPiSaIS0_EE11_M_allocateEm(ptr noundef nonnull align 8 dereferenceable(24) %0, i64 noundef %1) local_unnamed_addr #9 comdat align 2 !dbg !2119 {
    #dbg_value(ptr %0, !2121, !DIExpression(), !2123)
    #dbg_value(i64 %1, !2122, !DIExpression(), !2123)
  %3 = icmp eq i64 %1, 0, !dbg !2124
  br i1 %3, label %6, label %4, !dbg !2125

4:                                                ; preds = %2
    #dbg_value(ptr %0, !2126, !DIExpression(), !2130)
    #dbg_value(i64 %1, !2129, !DIExpression(), !2130)
    #dbg_value(ptr %0, !2132, !DIExpression(), !2136)
    #dbg_value(i64 %1, !2135, !DIExpression(), !2136)
  %5 = tail call noundef ptr @_ZNSt15__new_allocatorIPiE8allocateEmPKv(ptr noundef nonnull align 1 dereferenceable(1) %0, i64 noundef %1, ptr noundef null) #28, !dbg !2138
  br label %6, !dbg !2125

6:                                                ; preds = %2, %4
  %7 = phi ptr [ %5, %4 ], [ null, %2 ], !dbg !2125
  ret ptr %7, !dbg !2139
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt6vectorIPiSaIS0_EE12_Guard_allocC2EPS0_mRSt12_Vector_baseIS0_S1_E(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef %1, i64 noundef %2, ptr noundef nonnull align 8 dereferenceable(24) %3) unnamed_addr #1 comdat align 2 !dbg !2140 {
    #dbg_value(ptr %0, !2142, !DIExpression(), !2147)
    #dbg_value(ptr %1, !2144, !DIExpression(), !2147)
    #dbg_value(i64 %2, !2145, !DIExpression(), !2147)
    #dbg_value(ptr %3, !2146, !DIExpression(), !2147)
  call void @__log_store(ptr %0), !dbg !2148
  store ptr %1, ptr %0, align 8, !dbg !2148, !tbaa !2024
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2149
  call void @__log_store(ptr %5), !dbg !2149
  store i64 %2, ptr %5, align 8, !dbg !2149, !tbaa !2032
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 16, !dbg !2150
  call void @__log_store(ptr %6), !dbg !2150
  store ptr %3, ptr %6, align 8, !dbg !2150, !tbaa !2151
  ret void, !dbg !2152
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef ptr @_ZNSt6vectorIPiSaIS0_EE11_S_relocateEPS0_S3_S3_RS1_(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef nonnull align 1 dereferenceable(1) %3) local_unnamed_addr #1 comdat align 2 !dbg !2153 {
    #dbg_value(ptr %0, !2155, !DIExpression(), !2159)
    #dbg_value(ptr %1, !2156, !DIExpression(), !2159)
    #dbg_value(ptr %2, !2157, !DIExpression(), !2159)
    #dbg_value(ptr %3, !2158, !DIExpression(), !2159)
  %5 = tail call noundef ptr @_ZSt12__relocate_aIPPiS1_SaIS0_EET0_T_S4_S3_RT1_(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef nonnull align 1 dereferenceable(1) %3) #27, !dbg !2160
  ret ptr %5, !dbg !2161
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt6vectorIPiSaIS0_EE12_Guard_allocD2Ev(ptr noundef nonnull align 8 dereferenceable(24) %0) unnamed_addr #1 comdat align 2 personality ptr @__gxx_personality_v0 !dbg !2162 {
    #dbg_value(ptr %0, !2164, !DIExpression(), !2165)
  call void @__log_load(ptr %0), !dbg !2166
  %2 = load ptr, ptr %0, align 8, !dbg !2166, !tbaa !2024
  %3 = icmp eq ptr %2, null, !dbg !2166
  br i1 %3, label %9, label %4, !dbg !2166

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16, !dbg !2169
  call void @__log_load(ptr %5), !dbg !2169
  %6 = load ptr, ptr %5, align 8, !dbg !2169, !tbaa !2170
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2171
  call void @__log_load(ptr %7), !dbg !2171
  %8 = load i64, ptr %7, align 8, !dbg !2171, !tbaa !2032
  invoke void @_ZNSt12_Vector_baseIPiSaIS0_EE13_M_deallocateEPS0_m(ptr noundef nonnull align 8 dereferenceable(24) %6, ptr noundef nonnull %2, i64 noundef %8) #28
          to label %9 unwind label %10, !dbg !2172

9:                                                ; preds = %4, %1
  ret void, !dbg !2173

10:                                               ; preds = %4
  %11 = landingpad { ptr, i32 }
          catch ptr null, !dbg !2172
  %12 = extractvalue { ptr, i32 } %11, 0, !dbg !2172
  tail call void @__clang_call_terminate(ptr %12) #30, !dbg !2172
  unreachable, !dbg !2172
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef i64 @_ZNKSt6vectorIPiSaIS0_EE8max_sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2174 {
    #dbg_value(ptr %0, !2176, !DIExpression(), !2177)
  %2 = tail call noundef nonnull align 1 dereferenceable(1) ptr @_ZNKSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2178
  %3 = tail call noundef i64 @_ZNSt6vectorIPiSaIS0_EE11_S_max_sizeERKS1_(ptr noundef nonnull align 1 dereferenceable(1) %2) #27, !dbg !2179
  ret i64 %3, !dbg !2180
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef i64 @_ZNKSt6vectorIPiSaIS0_EE4sizeEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2181 {
    #dbg_value(ptr %0, !2183, !DIExpression(), !2185)
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2186
  call void @__log_load(ptr %2), !dbg !2186
  %3 = load ptr, ptr %2, align 8, !dbg !2186, !tbaa !1263
  call void @__log_load(ptr %0), !dbg !2187
  %4 = load ptr, ptr %0, align 8, !dbg !2187, !tbaa !1256
  %5 = ptrtoint ptr %3 to i64, !dbg !2188
  %6 = ptrtoint ptr %4 to i64, !dbg !2188
  %7 = sub i64 %5, %6, !dbg !2188
  %8 = ashr exact i64 %7, 3, !dbg !2188
    #dbg_value(i64 %8, !2184, !DIExpression(), !2185)
  %9 = icmp sgt i64 %8, -1, !dbg !2189
  tail call void @llvm.assume(i1 %9), !dbg !2189
  ret i64 %8, !dbg !2191
}

; Function Attrs: cold noreturn
declare !dbg !2192 void @_ZSt20__throw_length_errorPKc(ptr noundef) local_unnamed_addr #17

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZSt3maxImERKT_S2_S2_(ptr noundef nonnull align 8 dereferenceable(8) %0, ptr noundef nonnull align 8 dereferenceable(8) %1) local_unnamed_addr #1 comdat !dbg !2196 {
    #dbg_value(ptr %0, !2203, !DIExpression(), !2207)
    #dbg_value(ptr %1, !2204, !DIExpression(), !2207)
  call void @__log_load(ptr %0), !dbg !2208
  %3 = load i64, ptr %0, align 8, !dbg !2208, !tbaa !1408
  call void @__log_load(ptr %1), !dbg !2210
  %4 = load i64, ptr %1, align 8, !dbg !2210, !tbaa !1408
  %5 = icmp ult i64 %3, %4, !dbg !2211
  %6 = select i1 %5, ptr %1, ptr %0, !dbg !2207
  ret ptr %6, !dbg !2212
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef i64 @_ZNSt6vectorIPiSaIS0_EE11_S_max_sizeERKS1_(ptr noundef nonnull align 1 dereferenceable(1) %0) local_unnamed_addr #1 comdat align 2 personality ptr @__gxx_personality_v0 !dbg !2213 {
  %2 = alloca i64, align 8, !DIAssignID !2219
    #dbg_assign(i1 undef, !2216, !DIExpression(), !2219, ptr %2, !DIExpression(), !2220)
  %3 = alloca i64, align 8, !DIAssignID !2221
    #dbg_assign(i1 undef, !2218, !DIExpression(), !2221, ptr %3, !DIExpression(), !2220)
    #dbg_value(ptr %0, !2215, !DIExpression(), !2220)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !2222
  store i64 1152921504606846975, ptr %2, align 8, !dbg !2223, !tbaa !1408, !DIAssignID !2224
    #dbg_assign(i64 1152921504606846975, !2216, !DIExpression(), !2224, ptr %2, !DIExpression(), !2220)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #26, !dbg !2225
  store i64 2305843009213693951, ptr %3, align 8, !dbg !2226, !tbaa !1408, !DIAssignID !2227
    #dbg_assign(i64 2305843009213693951, !2218, !DIExpression(), !2227, ptr %3, !DIExpression(), !2220)
  %4 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt3minImERKT_S2_S2_(ptr noundef nonnull align 8 dereferenceable(8) %2, ptr noundef nonnull align 8 dereferenceable(8) %3) #28, !dbg !2228
  call void @__log_load(ptr %4), !dbg !2228
  %5 = load i64, ptr %4, align 8, !dbg !2228, !tbaa !1408
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #26, !dbg !2229
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !2229
  ret i64 %5, !dbg !2230
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef nonnull align 1 dereferenceable(1) ptr @_ZNKSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2231 {
    #dbg_value(ptr %0, !2233, !DIExpression(), !2235)
  ret ptr %0, !dbg !2236
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZSt3minImERKT_S2_S2_(ptr noundef nonnull align 8 dereferenceable(8) %0, ptr noundef nonnull align 8 dereferenceable(8) %1) local_unnamed_addr #1 comdat !dbg !2237 {
    #dbg_value(ptr %0, !2239, !DIExpression(), !2241)
    #dbg_value(ptr %1, !2240, !DIExpression(), !2241)
  call void @__log_load(ptr %1), !dbg !2242
  %3 = load i64, ptr %1, align 8, !dbg !2242, !tbaa !1408
  call void @__log_load(ptr %0), !dbg !2244
  %4 = load i64, ptr %0, align 8, !dbg !2244, !tbaa !1408
  %5 = icmp ult i64 %3, %4, !dbg !2245
  %6 = select i1 %5, ptr %1, ptr %0, !dbg !2241
  ret ptr %6, !dbg !2246
}

; Function Attrs: mustprogress noinline uwtable
define linkonce_odr dso_local noundef ptr @_ZNSt15__new_allocatorIPiE8allocateEmPKv(ptr noundef nonnull align 1 dereferenceable(1) %0, i64 noundef %1, ptr noundef %2) local_unnamed_addr #9 comdat align 2 !dbg !2247 {
    #dbg_value(ptr %0, !2249, !DIExpression(), !2252)
    #dbg_value(i64 %1, !2250, !DIExpression(), !2252)
    #dbg_value(ptr %2, !2251, !DIExpression(), !2252)
  %4 = icmp ugt i64 %1, 1152921504606846975, !dbg !2253
  br i1 %4, label %5, label %9, !dbg !2255, !prof !2256

5:                                                ; preds = %3
  %6 = icmp ugt i64 %1, 2305843009213693951, !dbg !2257
  br i1 %6, label %7, label %8, !dbg !2257

7:                                                ; preds = %5
  tail call void @_ZSt28__throw_bad_array_new_lengthv() #34, !dbg !2260
  unreachable, !dbg !2260

8:                                                ; preds = %5
  tail call void @_ZSt17__throw_bad_allocv() #34, !dbg !2261
  unreachable, !dbg !2261

9:                                                ; preds = %3
  %10 = shl nuw nsw i64 %1, 3, !dbg !2262
  %11 = tail call noalias noundef nonnull ptr @_Znwm(i64 noundef %10) #32, !dbg !2263
  ret ptr %11, !dbg !2264
}

; Function Attrs: noreturn
declare !dbg !2265 void @_ZSt28__throw_bad_array_new_lengthv() local_unnamed_addr #18

; Function Attrs: noreturn
declare !dbg !2266 void @_ZSt17__throw_bad_allocv() local_unnamed_addr #18

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef ptr @_ZSt12__relocate_aIPPiS1_SaIS0_EET0_T_S4_S3_RT1_(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef nonnull align 1 dereferenceable(1) %3) local_unnamed_addr #1 comdat !dbg !2267 {
    #dbg_value(ptr %0, !2272, !DIExpression(), !2279)
    #dbg_value(ptr %1, !2273, !DIExpression(), !2279)
    #dbg_value(ptr %2, !2274, !DIExpression(), !2279)
    #dbg_value(ptr %3, !2275, !DIExpression(), !2279)
  %5 = tail call noundef ptr @_ZSt14__relocate_a_1IPiS0_ENSt9enable_ifIXsr3std24__is_bitwise_relocatableIT_EE5valueEPS2_E4typeES3_S3_S3_RSaIT0_E(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef nonnull align 1 dereferenceable(1) %3) #27, !dbg !2280
  ret ptr %5, !dbg !2281
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef ptr @_ZSt14__relocate_a_1IPiS0_ENSt9enable_ifIXsr3std24__is_bitwise_relocatableIT_EE5valueEPS2_E4typeES3_S3_S3_RSaIT0_E(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef nonnull align 1 dereferenceable(1) %3) local_unnamed_addr #1 comdat !dbg !2282 {
    #dbg_value(ptr %0, !2292, !DIExpression(), !2298)
    #dbg_value(ptr %1, !2293, !DIExpression(), !2298)
    #dbg_value(ptr %2, !2294, !DIExpression(), !2298)
    #dbg_value(ptr %3, !2295, !DIExpression(), !2298)
  %5 = ptrtoint ptr %1 to i64, !dbg !2299
  %6 = ptrtoint ptr %0 to i64, !dbg !2299
  %7 = sub i64 %5, %6, !dbg !2299
    #dbg_value(i64 %7, !2296, !DIExpression(DW_OP_constu, 3, DW_OP_shra, DW_OP_stack_value), !2298)
  %8 = icmp sgt i64 %7, 0, !dbg !2300
  br i1 %8, label %9, label %10, !dbg !2300

9:                                                ; preds = %4
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 8 %2, ptr align 8 %0, i64 %7, i1 false), !dbg !2302
  br label %10, !dbg !2304

10:                                               ; preds = %9, %4
  %11 = getelementptr inbounds i8, ptr %2, i64 %7, !dbg !2305
  ret ptr %11, !dbg !2306
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #19

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef zeroext i1 @_ZNKSt6vectorIPiSaIS0_EE5emptyEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2307 {
    #dbg_value(ptr undef, !2310, !DIExpression(), !2317)
    #dbg_value(ptr undef, !2316, !DIExpression(), !2317)
    #dbg_value(ptr %0, !2309, !DIExpression(), !2319)
  %2 = tail call ptr @_ZNKSt6vectorIPiSaIS0_EE5beginEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2320
  %3 = tail call ptr @_ZNKSt6vectorIPiSaIS0_EE3endEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2321
  %4 = icmp eq ptr %2, %3, !dbg !2322
  ret i1 %4, !dbg !2323
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZNSt6vectorIPiSaIS0_EEixEm(ptr noundef nonnull align 8 dereferenceable(24) %0, i64 noundef %1) local_unnamed_addr #1 comdat align 2 !dbg !2324 {
    #dbg_value(ptr %0, !2326, !DIExpression(), !2328)
    #dbg_value(i64 %1, !2327, !DIExpression(), !2328)
  call void @__log_load(ptr %0), !dbg !2329
  %3 = load ptr, ptr %0, align 8, !dbg !2329, !tbaa !1256
  %4 = getelementptr inbounds nuw ptr, ptr %3, i64 %1, !dbg !2330
  ret ptr %4, !dbg !2331
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local ptr @_ZNKSt6vectorIPiSaIS0_EE5beginEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2332 {
    #dbg_value(ptr %0, !2334, !DIExpression(), !2335)
    #dbg_value(ptr undef, !2336, !DIExpression(), !2341)
    #dbg_value(ptr %0, !2339, !DIExpression(), !2341)
  call void @__log_load(ptr %0), !dbg !2343
  %2 = load ptr, ptr %0, align 8, !dbg !2343, !tbaa !2109
  ret ptr %2, !dbg !2344
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local ptr @_ZNKSt6vectorIPiSaIS0_EE3endEv(ptr noundef nonnull align 8 dereferenceable(24) %0) local_unnamed_addr #1 comdat align 2 !dbg !2345 {
    #dbg_value(ptr undef, !2336, !DIExpression(), !2348)
    #dbg_value(ptr %0, !2347, !DIExpression(), !2350)
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2351
    #dbg_value(ptr %2, !2339, !DIExpression(), !2348)
  call void @__log_load(ptr %2), !dbg !2352
  %3 = load ptr, ptr %2, align 8, !dbg !2352, !tbaa !2109
  ret ptr %3, !dbg !2353
}

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt6vectorIPiSaIS0_EE15_M_erase_at_endEPS0_(ptr noundef nonnull align 8 dereferenceable(24) %0, ptr noundef %1) local_unnamed_addr #1 comdat align 2 personality ptr @__gxx_personality_v0 !dbg !2354 {
    #dbg_value(ptr %0, !2356, !DIExpression(), !2360)
    #dbg_value(ptr %1, !2357, !DIExpression(), !2360)
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2361
  call void @__log_load(ptr %3), !dbg !2361
  %4 = load ptr, ptr %3, align 8, !dbg !2361, !tbaa !1263
    #dbg_value(!DIArgList(ptr %4, ptr %1), !2358, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_minus, DW_OP_constu, 3, DW_OP_shra, DW_OP_stack_value), !2362)
  %5 = icmp eq ptr %4, %1, !dbg !2363
  br i1 %5, label %8, label %6, !dbg !2363

6:                                                ; preds = %2
  %7 = tail call noundef nonnull align 1 dereferenceable(1) ptr @_ZNSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv(ptr noundef nonnull align 8 dereferenceable(24) %0) #27, !dbg !2364
    #dbg_value(ptr %1, !1265, !DIExpression(), !2366)
    #dbg_value(ptr %4, !1270, !DIExpression(), !2366)
    #dbg_value(ptr %7, !1271, !DIExpression(), !2366)
  tail call void @_ZSt8_DestroyIPPiEvT_S2_(ptr noundef %1, ptr noundef %4) #28, !dbg !2368
  call void @__log_store(ptr %3), !dbg !2369
  store ptr %1, ptr %3, align 8, !dbg !2369, !tbaa !1263
  br label %8, !dbg !2370

8:                                                ; preds = %6, %2
  ret void, !dbg !2371
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none) uwtable
define internal noalias noundef ptr @_ZL7worker6Pv(ptr nocapture noundef readonly %0) #15 !dbg !2372 {
    #dbg_value(ptr %0, !2374, !DIExpression(), !2376)
    #dbg_value(ptr %0, !2375, !DIExpression(), !2376)
  call void @__log_load(ptr %0), !dbg !2377
  %2 = load ptr, ptr %0, align 8, !dbg !2377, !tbaa !1478
  call void @__log_store(ptr %2), !dbg !2378
  store i32 66, ptr %2, align 4, !dbg !2378, !tbaa !1423
  ret ptr null, !dbg !2379
}

; Function Attrs: nounwind
declare !dbg !2380 ptr @memset(ptr noundef, i32 noundef, i64 noundef) local_unnamed_addr #11

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none) uwtable
define internal noalias noundef ptr @_ZL7worker7Pv(ptr nocapture noundef readonly %0) #15 !dbg !2384 {
    #dbg_value(ptr %0, !2386, !DIExpression(), !2388)
    #dbg_value(ptr %0, !2387, !DIExpression(), !2388)
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2389
  call void @__log_load(ptr %2), !dbg !2389
  %3 = load i32, ptr %2, align 8, !dbg !2389, !tbaa !1571
  %4 = mul nsw i32 %3, 10, !dbg !2390
  call void @__log_load(ptr %0), !dbg !2391
  %5 = load ptr, ptr %0, align 8, !dbg !2391, !tbaa !1567
  %6 = sext i32 %3 to i64, !dbg !2392
  %7 = getelementptr inbounds i32, ptr %5, i64 %6, !dbg !2392
  call void @__log_store(ptr %7), !dbg !2393
  store i32 %4, ptr %7, align 4, !dbg !2393, !tbaa !1423
  ret ptr null, !dbg !2394
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #20

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none) uwtable
define internal noalias noundef ptr @_ZL8worker8aPv(ptr nocapture noundef readonly %0) #21 !dbg !2395 {
    #dbg_value(ptr %0, !2397, !DIExpression(), !2401)
    #dbg_value(ptr poison, !2398, !DIExpression(), !2401)
    #dbg_value(i32 0, !2399, !DIExpression(), !2402)
    #dbg_value(i32 0, !2399, !DIExpression(), !2402)
  call void @__log_load(ptr %0), !dbg !2403
  %2 = load ptr, ptr %0, align 8, !dbg !2403, !tbaa !1606
    #dbg_value(ptr %2, !2398, !DIExpression(), !2401)
  call void @__log_load(ptr %2)
  %3 = load i32, ptr %2, align 4, !tbaa !1423
    #dbg_value(i32 poison, !2399, !DIExpression(), !2402)
  %4 = add i32 %3, 1000, !dbg !2404
  call void @__log_store(ptr %2), !dbg !2405
  store i32 %4, ptr %2, align 4, !dbg !2405, !tbaa !1423
  ret ptr null, !dbg !2407
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none) uwtable
define internal noalias noundef ptr @_ZL8worker8bPv(ptr nocapture noundef readonly %0) #21 !dbg !2408 {
    #dbg_value(ptr %0, !2410, !DIExpression(), !2414)
    #dbg_value(ptr poison, !2411, !DIExpression(), !2414)
    #dbg_value(i32 0, !2412, !DIExpression(), !2415)
    #dbg_value(i32 0, !2412, !DIExpression(), !2415)
  call void @__log_load(ptr %0), !dbg !2416
  %2 = load ptr, ptr %0, align 8, !dbg !2416, !tbaa !1606
    #dbg_value(ptr %2, !2411, !DIExpression(), !2414)
  call void @__log_load(ptr %2)
  %3 = load i32, ptr %2, align 4, !tbaa !1423
    #dbg_value(i32 poison, !2412, !DIExpression(), !2415)
  %4 = add i32 %3, -1000, !dbg !2417
  call void @__log_store(ptr %2), !dbg !2418
  store i32 %4, ptr %2, align 4, !dbg !2418, !tbaa !1423
  ret ptr null, !dbg !2420
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
define internal noalias noundef ptr @_ZL7worker9Pv(ptr nocapture noundef writeonly initializes((-4, 8)) %0) #12 !dbg !2421 {
    #dbg_value(ptr %0, !2423, !DIExpression(), !2425)
    #dbg_value(ptr %0, !2424, !DIExpression(), !2425)
  %2 = getelementptr inbounds i8, ptr %0, i64 -4, !dbg !2426
  call void @__log_store(ptr %2), !dbg !2427
  store i32 11, ptr %2, align 4, !dbg !2427, !tbaa !1423
  call void @__log_store(ptr %0), !dbg !2428
  store i32 22, ptr %0, align 4, !dbg !2428, !tbaa !1423
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 4, !dbg !2429
  call void @__log_store(ptr %3), !dbg !2430
  store i32 33, ptr %3, align 4, !dbg !2430, !tbaa !1423
  ret ptr null, !dbg !2431
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none) uwtable
define internal noalias noundef ptr @_ZL8worker10Pv(ptr nocapture readnone %0) #22 !dbg !2432 {
    #dbg_value(ptr poison, !2434, !DIExpression(), !2437)
    #dbg_value(i32 0, !2435, !DIExpression(), !2438)
    #dbg_value(i32 0, !2435, !DIExpression(), !2438)
  %2 = tail call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @_ZL11tls_counter)
  call void @__log_load(ptr %2)
  %3 = load i32, ptr %2, align 4, !tbaa !1423
    #dbg_value(i32 poison, !2435, !DIExpression(), !2438)
  %4 = add i32 %3, 300000, !dbg !2439
  call void @__log_store(ptr %2), !dbg !2440
  store i32 %4, ptr %2, align 4, !dbg !2440, !tbaa !1423
  ret ptr null, !dbg !2443
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #23

; Function Attrs: mustprogress noinline nounwind uwtable
define internal noalias noundef ptr @_ZL8worker11Pv(ptr nocapture readnone %0) #1 !dbg !2444 {
    #dbg_value(ptr poison, !2446, !DIExpression(), !2453)
  %2 = tail call noalias ptr @malloc(i64 noundef 16384) #27, !dbg !2454
    #dbg_value(ptr %2, !2447, !DIExpression(), !2453)
    #dbg_value(i32 0, !2448, !DIExpression(), !2455)
  br label %3, !dbg !2456

3:                                                ; preds = %1, %3
  %4 = phi i64 [ 0, %1 ], [ %8, %3 ]
    #dbg_value(i64 %4, !2448, !DIExpression(), !2455)
  %5 = mul nuw nsw i64 %4, %4, !dbg !2457
  %6 = getelementptr inbounds nuw i32, ptr %2, i64 %4, !dbg !2459
  %7 = trunc nuw i64 %5 to i32, !dbg !2460
  store i32 %7, ptr %6, align 4, !dbg !2460, !tbaa !1423
  %8 = add nuw nsw i64 %4, 1, !dbg !2461
    #dbg_value(i64 %8, !2448, !DIExpression(), !2455)
  %9 = icmp eq i64 %8, 4096, !dbg !2462
  br i1 %9, label %10, label %3, !dbg !2456, !llvm.loop !2463

10:                                               ; preds = %3
    #dbg_value(i32 poison, !2451, !DIExpression(), !2465)
    #dbg_value(i64 poison, !2450, !DIExpression(), !2453)
  tail call void @free(ptr noundef %2) #27, !dbg !2466
  ret ptr null, !dbg !2467
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
define internal noalias noundef ptr @_ZL8worker12Pv(ptr nocapture noundef writeonly initializes((0, 8)) %0) #12 !dbg !2468 {
    #dbg_value(ptr %0, !2470, !DIExpression(), !2472)
    #dbg_value(ptr %0, !2471, !DIExpression(), !2472)
  call void @__log_store(ptr %0), !dbg !2473
  store i32 1, ptr %0, align 4, !dbg !2473, !tbaa !2474
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 4, !dbg !2477
  call void @__log_store(ptr %2), !dbg !2478
  store i32 2, ptr %2, align 4, !dbg !2478, !tbaa !2479
  ret ptr null, !dbg !2480
}

; Function Attrs: nounwind
declare !dbg !2481 ptr @memcpy(ptr noundef, ptr noundef, i64 noundef) local_unnamed_addr #11

; Function Attrs: mustprogress noinline nounwind uwtable
define internal noalias noundef ptr @_ZL8worker13Pv(ptr noundef %0) #1 !dbg !2485 {
  %2 = alloca ptr, align 8, !DIAssignID !2490
    #dbg_assign(i1 undef, !2489, !DIExpression(), !2490, ptr %2, !DIExpression(), !2491)
    #dbg_value(ptr %0, !2487, !DIExpression(), !2491)
    #dbg_value(ptr %0, !2488, !DIExpression(), !2491)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #26, !dbg !2492
  %3 = call ptr @memcpy(ptr noundef nonnull %2, ptr noundef %0, i64 noundef 8) #27, !dbg !2493
  call void @__log_load(ptr %2), !dbg !2494
  %4 = load ptr, ptr %2, align 8, !dbg !2494, !tbaa !1478
  call void @__log_store(ptr %4), !dbg !2495
  store i32 13, ptr %4, align 4, !dbg !2495, !tbaa !1423
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #26, !dbg !2496
  ret ptr null, !dbg !2497
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable
define internal noalias noundef ptr @_ZL8worker14Pv(ptr nocapture readnone %0) #24 !dbg !2498 {
    #dbg_value(ptr poison, !2500, !DIExpression(), !2505)
    #dbg_value(ptr poison, !2501, !DIExpression(), !2505)
    #dbg_value(i64 0, !2502, !DIExpression(), !2505)
    #dbg_value(i32 0, !2503, !DIExpression(), !2506)
    #dbg_value(i32 poison, !2503, !DIExpression(), !2506)
    #dbg_value(i64 poison, !2502, !DIExpression(), !2505)
  ret ptr null, !dbg !2507
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
define internal void @_ZL10cb15_writePv(ptr nocapture noundef writeonly initializes((0, 4)) %0) #12 !dbg !2508 {
    #dbg_value(ptr %0, !2510, !DIExpression(), !2512)
    #dbg_value(ptr %0, !2511, !DIExpression(), !2512)
  call void @__log_store(ptr %0), !dbg !2513
  store i32 15, ptr %0, align 4, !dbg !2513, !tbaa !1423
  ret void, !dbg !2514
}

; Function Attrs: mustprogress noinline uwtable
define internal noundef ptr @_ZL8worker15Pv(ptr nocapture noundef readonly %0) #9 !dbg !2515 {
    #dbg_value(ptr %0, !2517, !DIExpression(), !2519)
    #dbg_value(ptr %0, !2518, !DIExpression(), !2519)
  call void @__log_load(ptr %0), !dbg !2520
  %2 = load ptr, ptr %0, align 8, !dbg !2520, !tbaa !1806
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8, !dbg !2521
  call void @__log_load(ptr %3), !dbg !2521
  %4 = load ptr, ptr %3, align 8, !dbg !2521, !tbaa !1809
  tail call void %2(ptr noundef %4) #28, !dbg !2522
  ret ptr null, !dbg !2523
}

; Function Attrs: nofree noinline nounwind uwtable
define internal void @_GLOBAL__sub_I_sharing_patterns.cpp() #0 section ".text.startup" !dbg !2524 {
  tail call fastcc void @__cxx_global_var_init(), !dbg !2526
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #25

declare void @__log_load(ptr)

declare void @__log_store(ptr)

declare void @__log_lock(ptr)

declare void @__log_unlock(ptr)

attributes #0 = { nofree noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress noinline norecurse uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { mustprogress nofree nounwind willreturn memory(read) "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { noinline noreturn nounwind uwtable "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { cold nofree noreturn }
attributes #9 = { mustprogress noinline uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { nobuiltin nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #13 = { mustprogress nofree noinline norecurse nounwind memory(readwrite, argmem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #14 = { nobuiltin allocsize(0) "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #15 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #16 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(readwrite, argmem: write, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #17 = { cold noreturn "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #18 = { noreturn "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #19 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #20 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #21 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #22 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #23 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #24 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #25 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #26 = { nounwind }
attributes #27 = { nobuiltin nounwind "no-builtins" }
attributes #28 = { nobuiltin "no-builtins" }
attributes #29 = { nobuiltin nounwind willreturn memory(read) "no-builtins" }
attributes #30 = { noreturn nounwind }
attributes #31 = { builtin nobuiltin nounwind "no-builtins" }
attributes #32 = { builtin nobuiltin allocsize(0) "no-builtins" }
attributes #33 = { cold nobuiltin noreturn "no-builtins" }
attributes #34 = { nobuiltin noreturn "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.linker.options = !{}
!llvm.module.flags = !{!1238, !1239, !1240, !1241, !1242, !1243, !1244, !1245}
!llvm.ident = !{!1246}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_ptrs", linkageName: "_ZL6g_ptrs", scope: !2, file: !3, line: 216, type: !23, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 20.1.8 (0ubuntu4)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !684, imports: !914, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "src/sharing_patterns.cpp", directory: "/home/rahulm/work/cs636/CS636_course_project_IITK/fasttrack/targets", checksumkind: CSK_MD5, checksum: "2f40f261ed6babae3210d5db9675a9a5")
!4 = !{!5, !6, !10, !11, !16, !20, !22, !47, !566, !364, !620, !625, !15, !629, !638, !640, !644, !653, !56, !50, !145, !29, !26, !23, !365, !662}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "SharedInt", file: !3, line: 90, size: 32, flags: DIFlagTypePassByValue, elements: !8, identifier: "_ZTS9SharedInt")
!8 = !{!9}
!9 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !7, file: !3, line: 90, baseType: !5, size: 32)
!10 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Args3", file: !3, line: 162, size: 64, flags: DIFlagTypePassByValue, elements: !13, identifier: "_ZTS5Args3")
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "ptr", scope: !12, file: !3, line: 162, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", scope: !18, file: !17, line: 338, baseType: !19)
!17 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/x86_64-linux-gnu/c++/15/bits/c++config.h", directory: "", checksumkind: CSK_MD5, checksum: "fc6fc56984c4acc296cc5ea44b283270")
!18 = !DINamespace(name: "std", scope: null)
!19 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_type", file: !21, line: 493, baseType: !16, flags: DIFlagPublic)
!21 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/stl_vector.h", directory: "", checksumkind: CSK_MD5, checksum: "396190da81f504591c361c73a800287e")
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "iterator", scope: !23, file: !21, line: 488, baseType: !566, flags: DIFlagPublic)
!23 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "vector<int *, std::allocator<int *> >", scope: !18, file: !21, line: 458, size: 192, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !24, templateParams: !564, identifier: "_ZTSSt6vectorIPiSaIS0_EE")
!24 = !{!25, !239, !259, !276, !277, !283, !286, !289, !293, !299, !302, !308, !313, !317, !327, !330, !333, !336, !341, !342, !346, !349, !352, !355, !358, !361, !426, !427, !428, !433, !438, !439, !440, !441, !442, !443, !444, !447, !448, !451, !452, !453, !454, !457, !458, !466, !473, !476, !477, !478, !481, !484, !485, !486, !489, !492, !495, !499, !500, !503, !506, !509, !512, !515, !518, !521, !522, !523, !524, !525, !528, !529, !532, !533, !534, !541, !544, !549, !552, !555, !558, !561}
!25 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !23, baseType: !26, flags: DIFlagProtected, extraData: i32 0)
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_Vector_base<int *, std::allocator<int *> >", scope: !18, file: !21, line: 91, size: 192, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !27, templateParams: !238, identifier: "_ZTSSt12_Vector_baseIPiSaIS0_EE")
!27 = !{!28, !189, !194, !199, !203, !206, !211, !214, !217, !221, !224, !227, !230, !231, !234, !237}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "_M_impl", scope: !26, file: !21, line: 380, baseType: !29, size: 192)
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_Vector_impl", scope: !26, file: !21, line: 139, size: 192, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !30, identifier: "_ZTSNSt12_Vector_baseIPiSaIS0_EE12_Vector_implE")
!30 = !{!31, !144, !169, !173, !178, !182, !186}
!31 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !29, baseType: !32, extraData: i32 0)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "_Tp_alloc_type", scope: !26, file: !21, line: 94, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "other", scope: !35, file: !34, line: 128, baseType: !143)
!34 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/ext/alloc_traits.h", directory: "", checksumkind: CSK_MD5, checksum: "b538cf34d296f3161c57558eea3bca8b")
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rebind<int *>", scope: !36, file: !34, line: 127, size: 8, flags: DIFlagTypePassByValue, elements: !142, templateParams: !85, identifier: "_ZTSN9__gnu_cxx14__alloc_traitsISaIPiES1_E6rebindIS1_EE")
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__alloc_traits<std::allocator<int *>, int *>", scope: !37, file: !34, line: 47, size: 8, flags: DIFlagTypePassByValue, elements: !38, templateParams: !140, identifier: "_ZTSN9__gnu_cxx14__alloc_traitsISaIPiES1_EE")
!37 = !DINamespace(name: "__gnu_cxx", scope: null)
!38 = !{!39, !126, !129, !132, !136, !137, !138, !139}
!39 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !36, baseType: !40, extraData: i32 0)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "allocator_traits<std::allocator<int *> >", scope: !18, file: !41, line: 560, size: 8, flags: DIFlagTypePassByValue, elements: !42, templateParams: !124, identifier: "_ZTSSt16allocator_traitsISaIPiEE")
!41 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/alloc_traits.h", directory: "", checksumkind: CSK_MD5, checksum: "c2f5862787920c2fc07b4f499e362a00")
!42 = !{!43, !108, !112, !115, !121}
!43 = !DISubprogram(name: "allocate", linkageName: "_ZNSt16allocator_traitsISaIPiEE8allocateERS1_m", scope: !40, file: !41, line: 613, type: !44, scopeLine: 613, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!44 = !DISubroutineType(types: !45)
!45 = !{!46, !48, !107}
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !40, file: !41, line: 569, baseType: !47)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !49, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "allocator_type", scope: !40, file: !41, line: 563, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "allocator<int *>", scope: !18, file: !51, line: 133, size: 8, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !52, templateParams: !85, identifier: "_ZTSSaIPiE")
!51 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/allocator.h", directory: "", checksumkind: CSK_MD5, checksum: "d18c16b3c9c3ab2e7d487de90ec27d17")
!52 = !{!53, !87, !91, !96, !100, !101, !104}
!53 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !50, baseType: !54, flags: DIFlagPublic, extraData: i32 0)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "__allocator_base<int *>", scope: !18, file: !55, line: 47, baseType: !56)
!55 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/x86_64-linux-gnu/c++/15/bits/c++allocator.h", directory: "", checksumkind: CSK_MD5, checksum: "229729de73da6f9ba6e1bf4c48f51f24")
!56 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "__new_allocator<int *>", scope: !18, file: !57, line: 63, size: 8, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !58, templateParams: !85, identifier: "_ZTSSt15__new_allocatorIPiE")
!57 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/new_allocator.h", directory: "", checksumkind: CSK_MD5, checksum: "46c2f3b679b1978ddb4dff0bf8b97610")
!58 = !{!59, !63, !68, !72, !78, !81}
!59 = !DISubprogram(name: "__new_allocator", scope: !56, file: !57, line: 88, type: !60, scopeLine: 88, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!60 = !DISubroutineType(types: !61)
!61 = !{null, !62}
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!63 = !DISubprogram(name: "__new_allocator", scope: !56, file: !57, line: 92, type: !64, scopeLine: 92, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!64 = !DISubroutineType(types: !65)
!65 = !{null, !62, !66}
!66 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !56)
!68 = !DISubprogram(name: "operator=", linkageName: "_ZNSt15__new_allocatorIPiEaSERKS1_", scope: !56, file: !57, line: 100, type: !69, scopeLine: 100, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!69 = !DISubroutineType(types: !70)
!70 = !{!71, !62, !66}
!71 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !56, size: 64)
!72 = !DISubprogram(name: "allocate", linkageName: "_ZNSt15__new_allocatorIPiE8allocateEmPKv", scope: !56, file: !57, line: 126, type: !73, scopeLine: 126, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!73 = !DISubroutineType(types: !74)
!74 = !{!47, !62, !75, !76}
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_type", file: !57, line: 67, baseType: !16, flags: DIFlagPublic)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!78 = !DISubprogram(name: "deallocate", linkageName: "_ZNSt15__new_allocatorIPiE10deallocateEPS0_m", scope: !56, file: !57, line: 156, type: !79, scopeLine: 156, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!79 = !DISubroutineType(types: !80)
!80 = !{null, !62, !47, !75}
!81 = !DISubprogram(name: "_M_max_size", linkageName: "_ZNKSt15__new_allocatorIPiE11_M_max_sizeEv", scope: !56, file: !57, line: 230, type: !82, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!82 = !DISubroutineType(types: !83)
!83 = !{!75, !84}
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!85 = !{!86}
!86 = !DITemplateTypeParameter(name: "_Tp", type: !15)
!87 = !DISubprogram(name: "allocator", scope: !50, file: !51, line: 168, type: !88, scopeLine: 168, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!88 = !DISubroutineType(types: !89)
!89 = !{null, !90}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!91 = !DISubprogram(name: "allocator", scope: !50, file: !51, line: 172, type: !92, scopeLine: 172, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!92 = !DISubroutineType(types: !93)
!93 = !{null, !90, !94}
!94 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !95, size: 64)
!95 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !50)
!96 = !DISubprogram(name: "operator=", linkageName: "_ZNSaIPiEaSERKS0_", scope: !50, file: !51, line: 177, type: !97, scopeLine: 177, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!97 = !DISubroutineType(types: !98)
!98 = !{!99, !90, !94}
!99 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !50, size: 64)
!100 = !DISubprogram(name: "~allocator", scope: !50, file: !51, line: 189, type: !88, scopeLine: 189, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!101 = !DISubprogram(name: "allocate", linkageName: "_ZNSaIPiE8allocateEm", scope: !50, file: !51, line: 194, type: !102, scopeLine: 194, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!102 = !DISubroutineType(types: !103)
!103 = !{!47, !90, !16}
!104 = !DISubprogram(name: "deallocate", linkageName: "_ZNSaIPiE10deallocateEPS_m", scope: !50, file: !51, line: 208, type: !105, scopeLine: 208, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!105 = !DISubroutineType(types: !106)
!106 = !{null, !90, !47, !16}
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_type", file: !41, line: 584, baseType: !16)
!108 = !DISubprogram(name: "allocate", linkageName: "_ZNSt16allocator_traitsISaIPiEE8allocateERS1_mPKv", scope: !40, file: !41, line: 628, type: !109, scopeLine: 628, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!109 = !DISubroutineType(types: !110)
!110 = !{!46, !48, !107, !111}
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "const_void_pointer", file: !41, line: 578, baseType: !76)
!112 = !DISubprogram(name: "deallocate", linkageName: "_ZNSt16allocator_traitsISaIPiEE10deallocateERS1_PS0_m", scope: !40, file: !41, line: 648, type: !113, scopeLine: 648, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!113 = !DISubroutineType(types: !114)
!114 = !{null, !48, !46, !107}
!115 = !DISubprogram(name: "max_size", linkageName: "_ZNSt16allocator_traitsISaIPiEE8max_sizeERKS1_", scope: !40, file: !41, line: 709, type: !116, scopeLine: 709, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!116 = !DISubroutineType(types: !117)
!117 = !{!118, !119}
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_type", scope: !40, file: !41, line: 584, baseType: !16)
!119 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !120, size: 64)
!120 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !49)
!121 = !DISubprogram(name: "select_on_container_copy_construction", linkageName: "_ZNSt16allocator_traitsISaIPiEE37select_on_container_copy_constructionERKS1_", scope: !40, file: !41, line: 725, type: !122, scopeLine: 725, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!122 = !DISubroutineType(types: !123)
!123 = !{!49, !119}
!124 = !{!125}
!125 = !DITemplateTypeParameter(name: "_Alloc", type: !50)
!126 = !DISubprogram(name: "_S_select_on_copy", linkageName: "_ZN9__gnu_cxx14__alloc_traitsISaIPiES1_E17_S_select_on_copyERKS2_", scope: !36, file: !34, line: 99, type: !127, scopeLine: 99, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!127 = !DISubroutineType(types: !128)
!128 = !{!50, !94}
!129 = !DISubprogram(name: "_S_on_swap", linkageName: "_ZN9__gnu_cxx14__alloc_traitsISaIPiES1_E10_S_on_swapERS2_S4_", scope: !36, file: !34, line: 103, type: !130, scopeLine: 103, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!130 = !DISubroutineType(types: !131)
!131 = !{null, !99, !99}
!132 = !DISubprogram(name: "_S_propagate_on_copy_assign", linkageName: "_ZN9__gnu_cxx14__alloc_traitsISaIPiES1_E27_S_propagate_on_copy_assignEv", scope: !36, file: !34, line: 107, type: !133, scopeLine: 107, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!133 = !DISubroutineType(types: !134)
!134 = !{!135}
!135 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!136 = !DISubprogram(name: "_S_propagate_on_move_assign", linkageName: "_ZN9__gnu_cxx14__alloc_traitsISaIPiES1_E27_S_propagate_on_move_assignEv", scope: !36, file: !34, line: 111, type: !133, scopeLine: 111, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!137 = !DISubprogram(name: "_S_propagate_on_swap", linkageName: "_ZN9__gnu_cxx14__alloc_traitsISaIPiES1_E20_S_propagate_on_swapEv", scope: !36, file: !34, line: 115, type: !133, scopeLine: 115, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!138 = !DISubprogram(name: "_S_always_equal", linkageName: "_ZN9__gnu_cxx14__alloc_traitsISaIPiES1_E15_S_always_equalEv", scope: !36, file: !34, line: 119, type: !133, scopeLine: 119, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!139 = !DISubprogram(name: "_S_nothrow_move", linkageName: "_ZN9__gnu_cxx14__alloc_traitsISaIPiES1_E15_S_nothrow_moveEv", scope: !36, file: !34, line: 123, type: !133, scopeLine: 123, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!140 = !{!125, !141}
!141 = !DITemplateTypeParameter(type: !15, defaulted: true)
!142 = !{}
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "template rebind_alloc<int *>", scope: !40, file: !41, line: 599, baseType: !50)
!144 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !29, baseType: !145, extraData: i32 0)
!145 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_Vector_impl_data", scope: !26, file: !21, line: 98, size: 192, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !146, identifier: "_ZTSNSt12_Vector_baseIPiSaIS0_EE17_Vector_impl_dataE")
!146 = !{!147, !150, !151, !152, !156, !160, !165}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "_M_start", scope: !145, file: !21, line: 100, baseType: !148, size: 64)
!148 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !26, file: !21, line: 96, baseType: !149)
!149 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !36, file: !34, line: 56, baseType: !46)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "_M_finish", scope: !145, file: !21, line: 101, baseType: !148, size: 64, offset: 64)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "_M_end_of_storage", scope: !145, file: !21, line: 102, baseType: !148, size: 64, offset: 128)
!152 = !DISubprogram(name: "_Vector_impl_data", scope: !145, file: !21, line: 105, type: !153, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!153 = !DISubroutineType(types: !154)
!154 = !{null, !155}
!155 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!156 = !DISubprogram(name: "_Vector_impl_data", scope: !145, file: !21, line: 111, type: !157, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!157 = !DISubroutineType(types: !158)
!158 = !{null, !155, !159}
!159 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !145, size: 64)
!160 = !DISubprogram(name: "_M_copy_data", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE17_Vector_impl_data12_M_copy_dataERKS3_", scope: !145, file: !21, line: 119, type: !161, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!161 = !DISubroutineType(types: !162)
!162 = !{null, !155, !163}
!163 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !164, size: 64)
!164 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !145)
!165 = !DISubprogram(name: "_M_swap_data", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE17_Vector_impl_data12_M_swap_dataERS3_", scope: !145, file: !21, line: 128, type: !166, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!166 = !DISubroutineType(types: !167)
!167 = !{null, !155, !168}
!168 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !145, size: 64)
!169 = !DISubprogram(name: "_Vector_impl", scope: !29, file: !21, line: 143, type: !170, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!170 = !DISubroutineType(types: !171)
!171 = !{null, !172}
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!173 = !DISubprogram(name: "_Vector_impl", scope: !29, file: !21, line: 152, type: !174, scopeLine: 152, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!174 = !DISubroutineType(types: !175)
!175 = !{null, !172, !176}
!176 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !177, size: 64)
!177 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !32)
!178 = !DISubprogram(name: "_Vector_impl", scope: !29, file: !21, line: 160, type: !179, scopeLine: 160, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!179 = !DISubroutineType(types: !180)
!180 = !{null, !172, !181}
!181 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !29, size: 64)
!182 = !DISubprogram(name: "_Vector_impl", scope: !29, file: !21, line: 165, type: !183, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!183 = !DISubroutineType(types: !184)
!184 = !{null, !172, !185}
!185 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !32, size: 64)
!186 = !DISubprogram(name: "_Vector_impl", scope: !29, file: !21, line: 170, type: !187, scopeLine: 170, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!187 = !DISubroutineType(types: !188)
!188 = !{null, !172, !185, !181}
!189 = !DISubprogram(name: "_M_get_Tp_allocator", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv", scope: !26, file: !21, line: 307, type: !190, scopeLine: 307, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!190 = !DISubroutineType(types: !191)
!191 = !{!192, !193}
!192 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !32, size: 64)
!193 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!194 = !DISubprogram(name: "_M_get_Tp_allocator", linkageName: "_ZNKSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv", scope: !26, file: !21, line: 312, type: !195, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!195 = !DISubroutineType(types: !196)
!196 = !{!176, !197}
!197 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !198, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!198 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!199 = !DISubprogram(name: "get_allocator", linkageName: "_ZNKSt12_Vector_baseIPiSaIS0_EE13get_allocatorEv", scope: !26, file: !21, line: 317, type: !200, scopeLine: 317, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!200 = !DISubroutineType(types: !201)
!201 = !{!202, !197}
!202 = !DIDerivedType(tag: DW_TAG_typedef, name: "allocator_type", scope: !26, file: !21, line: 303, baseType: !50)
!203 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 321, type: !204, scopeLine: 321, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!204 = !DISubroutineType(types: !205)
!205 = !{null, !193}
!206 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 327, type: !207, scopeLine: 327, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!207 = !DISubroutineType(types: !208)
!208 = !{null, !193, !209}
!209 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !210, size: 64)
!210 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !202)
!211 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 333, type: !212, scopeLine: 333, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!212 = !DISubroutineType(types: !213)
!213 = !{null, !193, !16}
!214 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 339, type: !215, scopeLine: 339, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!215 = !DISubroutineType(types: !216)
!216 = !{null, !193, !16, !209}
!217 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 344, type: !218, scopeLine: 344, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!218 = !DISubroutineType(types: !219)
!219 = !{null, !193, !220}
!220 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !26, size: 64)
!221 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 349, type: !222, scopeLine: 349, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!222 = !DISubroutineType(types: !223)
!223 = !{null, !193, !185}
!224 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 353, type: !225, scopeLine: 353, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!225 = !DISubroutineType(types: !226)
!226 = !{null, !193, !220, !209}
!227 = !DISubprogram(name: "_Vector_base", scope: !26, file: !21, line: 367, type: !228, scopeLine: 367, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!228 = !DISubroutineType(types: !229)
!229 = !{null, !193, !209, !220}
!230 = !DISubprogram(name: "~_Vector_base", scope: !26, file: !21, line: 373, type: !204, scopeLine: 373, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!231 = !DISubprogram(name: "_M_allocate", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE11_M_allocateEm", scope: !26, file: !21, line: 384, type: !232, scopeLine: 384, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!232 = !DISubroutineType(types: !233)
!233 = !{!148, !193, !16}
!234 = !DISubprogram(name: "_M_deallocate", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE13_M_deallocateEPS0_m", scope: !26, file: !21, line: 392, type: !235, scopeLine: 392, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!235 = !DISubroutineType(types: !236)
!236 = !{null, !193, !148, !16}
!237 = !DISubprogram(name: "_M_create_storage", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE17_M_create_storageEm", scope: !26, file: !21, line: 403, type: !212, scopeLine: 403, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!238 = !{!86, !125}
!239 = !DISubprogram(name: "_S_nothrow_relocate", linkageName: "_ZNSt6vectorIPiSaIS0_EE19_S_nothrow_relocateESt17integral_constantIbLb1EE", scope: !23, file: !21, line: 500, type: !240, scopeLine: 500, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!240 = !DISubroutineType(types: !241)
!241 = !{!135, !242}
!242 = !DIDerivedType(tag: DW_TAG_typedef, name: "true_type", scope: !18, file: !243, line: 116, baseType: !244)
!243 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/type_traits", directory: "", checksumkind: CSK_MD5, checksum: "8201d7a43c44bad495d095d0d983e9c9")
!244 = !DIDerivedType(tag: DW_TAG_typedef, name: "__bool_constant<true>", scope: !18, file: !243, line: 112, baseType: !245)
!245 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "integral_constant<bool, true>", scope: !18, file: !243, line: 92, size: 8, flags: DIFlagTypePassByValue, elements: !246, templateParams: !256, identifier: "_ZTSSt17integral_constantIbLb1EE")
!246 = !{!247, !249, !255}
!247 = !DIDerivedType(tag: DW_TAG_variable, name: "value", scope: !245, file: !243, line: 94, baseType: !248, flags: DIFlagStaticMember, extraData: i1 true)
!248 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !135)
!249 = !DISubprogram(name: "operator bool", linkageName: "_ZNKSt17integral_constantIbLb1EEcvbEv", scope: !245, file: !243, line: 97, type: !250, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!250 = !DISubroutineType(types: !251)
!251 = !{!252, !253}
!252 = !DIDerivedType(tag: DW_TAG_typedef, name: "value_type", scope: !245, file: !243, line: 95, baseType: !135)
!253 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !254, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!254 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !245)
!255 = !DISubprogram(name: "operator()", linkageName: "_ZNKSt17integral_constantIbLb1EEclEv", scope: !245, file: !243, line: 100, type: !250, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!256 = !{!257, !258}
!257 = !DITemplateTypeParameter(name: "_Tp", type: !135)
!258 = !DITemplateValueParameter(name: "__v", type: !135, value: i1 true)
!259 = !DISubprogram(name: "_S_nothrow_relocate", linkageName: "_ZNSt6vectorIPiSaIS0_EE19_S_nothrow_relocateESt17integral_constantIbLb0EE", scope: !23, file: !21, line: 509, type: !260, scopeLine: 509, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!260 = !DISubroutineType(types: !261)
!261 = !{!135, !262}
!262 = !DIDerivedType(tag: DW_TAG_typedef, name: "false_type", scope: !18, file: !243, line: 119, baseType: !263)
!263 = !DIDerivedType(tag: DW_TAG_typedef, name: "__bool_constant<false>", scope: !18, file: !243, line: 112, baseType: !264)
!264 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "integral_constant<bool, false>", scope: !18, file: !243, line: 92, size: 8, flags: DIFlagTypePassByValue, elements: !265, templateParams: !274, identifier: "_ZTSSt17integral_constantIbLb0EE")
!265 = !{!266, !267, !273}
!266 = !DIDerivedType(tag: DW_TAG_variable, name: "value", scope: !264, file: !243, line: 94, baseType: !248, flags: DIFlagStaticMember, extraData: i1 false)
!267 = !DISubprogram(name: "operator bool", linkageName: "_ZNKSt17integral_constantIbLb0EEcvbEv", scope: !264, file: !243, line: 97, type: !268, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!268 = !DISubroutineType(types: !269)
!269 = !{!270, !271}
!270 = !DIDerivedType(tag: DW_TAG_typedef, name: "value_type", scope: !264, file: !243, line: 95, baseType: !135)
!271 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !272, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!272 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !264)
!273 = !DISubprogram(name: "operator()", linkageName: "_ZNKSt17integral_constantIbLb0EEclEv", scope: !264, file: !243, line: 100, type: !268, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!274 = !{!257, !275}
!275 = !DITemplateValueParameter(name: "__v", type: !135, value: i1 false)
!276 = !DISubprogram(name: "_S_use_relocate", linkageName: "_ZNSt6vectorIPiSaIS0_EE15_S_use_relocateEv", scope: !23, file: !21, line: 513, type: !133, scopeLine: 513, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!277 = !DISubprogram(name: "_S_do_relocate", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_S_do_relocateEPS0_S3_S3_RS1_St17integral_constantIbLb1EE", scope: !23, file: !21, line: 522, type: !278, scopeLine: 522, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!278 = !DISubroutineType(types: !279)
!279 = !{!280, !280, !280, !280, !281, !242}
!280 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !23, file: !21, line: 484, baseType: !148, flags: DIFlagPublic)
!281 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !282, size: 64)
!282 = !DIDerivedType(tag: DW_TAG_typedef, name: "_Tp_alloc_type", scope: !23, file: !21, line: 479, baseType: !32)
!283 = !DISubprogram(name: "_S_do_relocate", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_S_do_relocateEPS0_S3_S3_RS1_St17integral_constantIbLb0EE", scope: !23, file: !21, line: 529, type: !284, scopeLine: 529, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!284 = !DISubroutineType(types: !285)
!285 = !{!280, !280, !280, !280, !281, !262}
!286 = !DISubprogram(name: "_S_relocate", linkageName: "_ZNSt6vectorIPiSaIS0_EE11_S_relocateEPS0_S3_S3_RS1_", scope: !23, file: !21, line: 534, type: !287, scopeLine: 534, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!287 = !DISubroutineType(types: !288)
!288 = !{!280, !280, !280, !280, !281}
!289 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 561, type: !290, scopeLine: 561, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!290 = !DISubroutineType(types: !291)
!291 = !{null, !292}
!292 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!293 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 572, type: !294, scopeLine: 572, flags: DIFlagPublic | DIFlagExplicit | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!294 = !DISubroutineType(types: !295)
!295 = !{null, !292, !296}
!296 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !297, size: 64)
!297 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !298)
!298 = !DIDerivedType(tag: DW_TAG_typedef, name: "allocator_type", scope: !23, file: !21, line: 495, baseType: !50, flags: DIFlagPublic)
!299 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 586, type: !300, scopeLine: 586, flags: DIFlagPublic | DIFlagExplicit | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!300 = !DISubroutineType(types: !301)
!301 = !{null, !292, !20, !296}
!302 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 599, type: !303, scopeLine: 599, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!303 = !DISubroutineType(types: !304)
!304 = !{null, !292, !20, !305, !296}
!305 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !306, size: 64)
!306 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !307)
!307 = !DIDerivedType(tag: DW_TAG_typedef, name: "value_type", scope: !23, file: !21, line: 483, baseType: !15, flags: DIFlagPublic)
!308 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 631, type: !309, scopeLine: 631, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!309 = !DISubroutineType(types: !310)
!310 = !{null, !292, !311}
!311 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !312, size: 64)
!312 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!313 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 650, type: !314, scopeLine: 650, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!314 = !DISubroutineType(types: !315)
!315 = !{null, !292, !316}
!316 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !23, size: 64)
!317 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 654, type: !318, scopeLine: 654, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!318 = !DISubroutineType(types: !319)
!319 = !{null, !292, !311, !320}
!320 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !321, size: 64)
!321 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !322)
!322 = !DIDerivedType(tag: DW_TAG_typedef, name: "__type_identity_t<std::allocator<int *> >", scope: !18, file: !243, line: 170, baseType: !323)
!323 = !DIDerivedType(tag: DW_TAG_typedef, name: "type", scope: !324, file: !243, line: 167, baseType: !50)
!324 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__type_identity<std::allocator<int *> >", scope: !18, file: !243, line: 166, size: 8, flags: DIFlagTypePassByValue, elements: !142, templateParams: !325, identifier: "_ZTSSt15__type_identityISaIPiEE")
!325 = !{!326}
!326 = !DITemplateTypeParameter(name: "_Type", type: !50)
!327 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 665, type: !328, scopeLine: 665, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!328 = !DISubroutineType(types: !329)
!329 = !{null, !292, !316, !296, !242}
!330 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 670, type: !331, scopeLine: 670, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!331 = !DISubroutineType(types: !332)
!332 = !{null, !292, !316, !296, !262}
!333 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 689, type: !334, scopeLine: 689, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!334 = !DISubroutineType(types: !335)
!335 = !{null, !292, !316, !320}
!336 = !DISubprogram(name: "vector", scope: !23, file: !21, line: 708, type: !337, scopeLine: 708, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!337 = !DISubroutineType(types: !338)
!338 = !{null, !292, !339, !296}
!339 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "initializer_list<int *>", scope: !18, file: !340, line: 47, flags: DIFlagFwdDecl | DIFlagNonTrivial, identifier: "_ZTSSt16initializer_listIPiE")
!340 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/initializer_list", directory: "", checksumkind: CSK_MD5, checksum: "6d66eea53ad7b08f1adb945346f5d756")
!341 = !DISubprogram(name: "~vector", scope: !23, file: !21, line: 800, type: !290, scopeLine: 800, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!342 = !DISubprogram(name: "operator=", linkageName: "_ZNSt6vectorIPiSaIS0_EEaSERKS2_", scope: !23, file: !21, line: 818, type: !343, scopeLine: 818, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!343 = !DISubroutineType(types: !344)
!344 = !{!345, !292, !311}
!345 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !23, size: 64)
!346 = !DISubprogram(name: "operator=", linkageName: "_ZNSt6vectorIPiSaIS0_EEaSEOS2_", scope: !23, file: !21, line: 833, type: !347, scopeLine: 833, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!347 = !DISubroutineType(types: !348)
!348 = !{!345, !292, !316}
!349 = !DISubprogram(name: "operator=", linkageName: "_ZNSt6vectorIPiSaIS0_EEaSESt16initializer_listIS0_E", scope: !23, file: !21, line: 855, type: !350, scopeLine: 855, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!350 = !DISubroutineType(types: !351)
!351 = !{!345, !292, !339}
!352 = !DISubprogram(name: "assign", linkageName: "_ZNSt6vectorIPiSaIS0_EE6assignEmRKS0_", scope: !23, file: !21, line: 875, type: !353, scopeLine: 875, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!353 = !DISubroutineType(types: !354)
!354 = !{null, !292, !20, !305}
!355 = !DISubprogram(name: "assign", linkageName: "_ZNSt6vectorIPiSaIS0_EE6assignESt16initializer_listIS0_E", scope: !23, file: !21, line: 922, type: !356, scopeLine: 922, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!356 = !DISubroutineType(types: !357)
!357 = !{null, !292, !339}
!358 = !DISubprogram(name: "begin", linkageName: "_ZNSt6vectorIPiSaIS0_EE5beginEv", scope: !23, file: !21, line: 998, type: !359, scopeLine: 998, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!359 = !DISubroutineType(types: !360)
!360 = !{!22, !292}
!361 = !DISubprogram(name: "begin", linkageName: "_ZNKSt6vectorIPiSaIS0_EE5beginEv", scope: !23, file: !21, line: 1008, type: !362, scopeLine: 1008, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!362 = !DISubroutineType(types: !363)
!363 = !{!364, !425}
!364 = !DIDerivedType(tag: DW_TAG_typedef, name: "const_iterator", scope: !23, file: !21, line: 490, baseType: !365, flags: DIFlagPublic)
!365 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "__normal_iterator<int *const *, std::vector<int *, std::allocator<int *> > >", scope: !37, file: !366, line: 1026, size: 64, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !367, templateParams: !423, identifier: "_ZTSN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEE")
!366 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/stl_iterator.h", directory: "", checksumkind: CSK_MD5, checksum: "1863181d6606bfedafc789dd95b2c52d")
!367 = !{!368, !371, !375, !380, !392, !397, !401, !404, !405, !406, !412, !415, !418, !419, !420}
!368 = !DIDerivedType(tag: DW_TAG_member, name: "_M_current", scope: !365, file: !366, line: 1029, baseType: !369, size: 64, flags: DIFlagProtected)
!369 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !370, size: 64)
!370 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!371 = !DISubprogram(name: "__normal_iterator", scope: !365, file: !366, line: 1053, type: !372, scopeLine: 1053, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!372 = !DISubroutineType(types: !373)
!373 = !{null, !374}
!374 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !365, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!375 = !DISubprogram(name: "__normal_iterator", scope: !365, file: !366, line: 1058, type: !376, scopeLine: 1058, flags: DIFlagPublic | DIFlagExplicit | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!376 = !DISubroutineType(types: !377)
!377 = !{null, !374, !378}
!378 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !379, size: 64)
!379 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !369)
!380 = !DISubprogram(name: "operator*", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEdeEv", scope: !365, file: !366, line: 1089, type: !381, scopeLine: 1089, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!381 = !DISubroutineType(types: !382)
!382 = !{!383, !390}
!383 = !DIDerivedType(tag: DW_TAG_typedef, name: "reference", scope: !365, file: !366, line: 1044, baseType: !384, flags: DIFlagPublic)
!384 = !DIDerivedType(tag: DW_TAG_typedef, name: "reference", scope: !386, file: !385, line: 207, baseType: !389)
!385 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/stl_iterator_base_types.h", directory: "", checksumkind: CSK_MD5, checksum: "252307c6170fb8ddbc0bb33c0c80f35b")
!386 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iterator_traits<int *const *>", scope: !18, file: !385, line: 200, size: 8, flags: DIFlagTypePassByValue, elements: !142, templateParams: !387, identifier: "_ZTSSt15iterator_traitsIPKPiE")
!387 = !{!388}
!388 = !DITemplateTypeParameter(name: "_Iterator", type: !369)
!389 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !370, size: 64)
!390 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !391, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!391 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !365)
!392 = !DISubprogram(name: "operator->", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEptEv", scope: !365, file: !366, line: 1095, type: !393, scopeLine: 1095, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!393 = !DISubroutineType(types: !394)
!394 = !{!395, !390}
!395 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !365, file: !366, line: 1045, baseType: !396, flags: DIFlagPublic)
!396 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !386, file: !385, line: 206, baseType: !369)
!397 = !DISubprogram(name: "operator++", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEppEv", scope: !365, file: !366, line: 1101, type: !398, scopeLine: 1101, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!398 = !DISubroutineType(types: !399)
!399 = !{!400, !374}
!400 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !365, size: 64)
!401 = !DISubprogram(name: "operator++", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEppEi", scope: !365, file: !366, line: 1110, type: !402, scopeLine: 1110, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!402 = !DISubroutineType(types: !403)
!403 = !{!365, !374, !5}
!404 = !DISubprogram(name: "operator--", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEmmEv", scope: !365, file: !366, line: 1118, type: !398, scopeLine: 1118, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!405 = !DISubprogram(name: "operator--", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEmmEi", scope: !365, file: !366, line: 1127, type: !402, scopeLine: 1127, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!406 = !DISubprogram(name: "operator[]", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEixEl", scope: !365, file: !366, line: 1135, type: !407, scopeLine: 1135, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!407 = !DISubroutineType(types: !408)
!408 = !{!383, !390, !409}
!409 = !DIDerivedType(tag: DW_TAG_typedef, name: "difference_type", scope: !365, file: !366, line: 1043, baseType: !410, flags: DIFlagPublic)
!410 = !DIDerivedType(tag: DW_TAG_typedef, name: "difference_type", scope: !386, file: !385, line: 205, baseType: !411)
!411 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", scope: !18, file: !17, line: 339, baseType: !10)
!412 = !DISubprogram(name: "operator+=", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEpLEl", scope: !365, file: !366, line: 1141, type: !413, scopeLine: 1141, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!413 = !DISubroutineType(types: !414)
!414 = !{!400, !374, !409}
!415 = !DISubprogram(name: "operator+", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEplEl", scope: !365, file: !366, line: 1147, type: !416, scopeLine: 1147, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!416 = !DISubroutineType(types: !417)
!417 = !{!365, !390, !409}
!418 = !DISubprogram(name: "operator-=", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEmIEl", scope: !365, file: !366, line: 1153, type: !413, scopeLine: 1153, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!419 = !DISubprogram(name: "operator-", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEmiEl", scope: !365, file: !366, line: 1159, type: !416, scopeLine: 1159, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!420 = !DISubprogram(name: "base", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEE4baseEv", scope: !365, file: !366, line: 1165, type: !421, scopeLine: 1165, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!421 = !DISubroutineType(types: !422)
!422 = !{!378, !390}
!423 = !{!388, !424}
!424 = !DITemplateTypeParameter(name: "_Container", type: !23)
!425 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !312, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!426 = !DISubprogram(name: "end", linkageName: "_ZNSt6vectorIPiSaIS0_EE3endEv", scope: !23, file: !21, line: 1018, type: !359, scopeLine: 1018, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!427 = !DISubprogram(name: "end", linkageName: "_ZNKSt6vectorIPiSaIS0_EE3endEv", scope: !23, file: !21, line: 1028, type: !362, scopeLine: 1028, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!428 = !DISubprogram(name: "rbegin", linkageName: "_ZNSt6vectorIPiSaIS0_EE6rbeginEv", scope: !23, file: !21, line: 1038, type: !429, scopeLine: 1038, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!429 = !DISubroutineType(types: !430)
!430 = !{!431, !292}
!431 = !DIDerivedType(tag: DW_TAG_typedef, name: "reverse_iterator", scope: !23, file: !21, line: 492, baseType: !432, flags: DIFlagPublic)
!432 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "reverse_iterator<__gnu_cxx::__normal_iterator<int **, std::vector<int *, std::allocator<int *> > > >", scope: !18, file: !366, line: 131, flags: DIFlagFwdDecl | DIFlagNonTrivial, identifier: "_ZTSSt16reverse_iteratorIN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS2_SaIS2_EEEEE")
!433 = !DISubprogram(name: "rbegin", linkageName: "_ZNKSt6vectorIPiSaIS0_EE6rbeginEv", scope: !23, file: !21, line: 1048, type: !434, scopeLine: 1048, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!434 = !DISubroutineType(types: !435)
!435 = !{!436, !425}
!436 = !DIDerivedType(tag: DW_TAG_typedef, name: "const_reverse_iterator", scope: !23, file: !21, line: 491, baseType: !437, flags: DIFlagPublic)
!437 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "reverse_iterator<__gnu_cxx::__normal_iterator<int *const *, std::vector<int *, std::allocator<int *> > > >", scope: !18, file: !366, line: 131, flags: DIFlagFwdDecl | DIFlagNonTrivial, identifier: "_ZTSSt16reverse_iteratorIN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS2_SaIS2_EEEEE")
!438 = !DISubprogram(name: "rend", linkageName: "_ZNSt6vectorIPiSaIS0_EE4rendEv", scope: !23, file: !21, line: 1058, type: !429, scopeLine: 1058, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!439 = !DISubprogram(name: "rend", linkageName: "_ZNKSt6vectorIPiSaIS0_EE4rendEv", scope: !23, file: !21, line: 1068, type: !434, scopeLine: 1068, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!440 = !DISubprogram(name: "cbegin", linkageName: "_ZNKSt6vectorIPiSaIS0_EE6cbeginEv", scope: !23, file: !21, line: 1079, type: !362, scopeLine: 1079, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!441 = !DISubprogram(name: "cend", linkageName: "_ZNKSt6vectorIPiSaIS0_EE4cendEv", scope: !23, file: !21, line: 1089, type: !362, scopeLine: 1089, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!442 = !DISubprogram(name: "crbegin", linkageName: "_ZNKSt6vectorIPiSaIS0_EE7crbeginEv", scope: !23, file: !21, line: 1099, type: !434, scopeLine: 1099, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!443 = !DISubprogram(name: "crend", linkageName: "_ZNKSt6vectorIPiSaIS0_EE5crendEv", scope: !23, file: !21, line: 1109, type: !434, scopeLine: 1109, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!444 = !DISubprogram(name: "size", linkageName: "_ZNKSt6vectorIPiSaIS0_EE4sizeEv", scope: !23, file: !21, line: 1117, type: !445, scopeLine: 1117, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!445 = !DISubroutineType(types: !446)
!446 = !{!20, !425}
!447 = !DISubprogram(name: "max_size", linkageName: "_ZNKSt6vectorIPiSaIS0_EE8max_sizeEv", scope: !23, file: !21, line: 1128, type: !445, scopeLine: 1128, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!448 = !DISubprogram(name: "resize", linkageName: "_ZNSt6vectorIPiSaIS0_EE6resizeEm", scope: !23, file: !21, line: 1143, type: !449, scopeLine: 1143, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!449 = !DISubroutineType(types: !450)
!450 = !{null, !292, !20}
!451 = !DISubprogram(name: "resize", linkageName: "_ZNSt6vectorIPiSaIS0_EE6resizeEmRKS0_", scope: !23, file: !21, line: 1164, type: !353, scopeLine: 1164, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!452 = !DISubprogram(name: "shrink_to_fit", linkageName: "_ZNSt6vectorIPiSaIS0_EE13shrink_to_fitEv", scope: !23, file: !21, line: 1198, type: !290, scopeLine: 1198, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!453 = !DISubprogram(name: "capacity", linkageName: "_ZNKSt6vectorIPiSaIS0_EE8capacityEv", scope: !23, file: !21, line: 1208, type: !445, scopeLine: 1208, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!454 = !DISubprogram(name: "empty", linkageName: "_ZNKSt6vectorIPiSaIS0_EE5emptyEv", scope: !23, file: !21, line: 1223, type: !455, scopeLine: 1223, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!455 = !DISubroutineType(types: !456)
!456 = !{!135, !425}
!457 = !DISubprogram(name: "reserve", linkageName: "_ZNSt6vectorIPiSaIS0_EE7reserveEm", scope: !23, file: !21, line: 1245, type: !449, scopeLine: 1245, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!458 = !DISubprogram(name: "operator[]", linkageName: "_ZNSt6vectorIPiSaIS0_EEixEm", scope: !23, file: !21, line: 1261, type: !459, scopeLine: 1261, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!459 = !DISubroutineType(types: !460)
!460 = !{!461, !292, !20}
!461 = !DIDerivedType(tag: DW_TAG_typedef, name: "reference", scope: !23, file: !21, line: 486, baseType: !462, flags: DIFlagPublic)
!462 = !DIDerivedType(tag: DW_TAG_typedef, name: "reference", scope: !36, file: !34, line: 61, baseType: !463)
!463 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !464, size: 64)
!464 = !DIDerivedType(tag: DW_TAG_typedef, name: "value_type", scope: !36, file: !34, line: 55, baseType: !465)
!465 = !DIDerivedType(tag: DW_TAG_typedef, name: "value_type", scope: !40, file: !41, line: 566, baseType: !15)
!466 = !DISubprogram(name: "operator[]", linkageName: "_ZNKSt6vectorIPiSaIS0_EEixEm", scope: !23, file: !21, line: 1280, type: !467, scopeLine: 1280, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!467 = !DISubroutineType(types: !468)
!468 = !{!469, !425, !20}
!469 = !DIDerivedType(tag: DW_TAG_typedef, name: "const_reference", scope: !23, file: !21, line: 487, baseType: !470, flags: DIFlagPublic)
!470 = !DIDerivedType(tag: DW_TAG_typedef, name: "const_reference", scope: !36, file: !34, line: 62, baseType: !471)
!471 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !472, size: 64)
!472 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !464)
!473 = !DISubprogram(name: "_M_range_check", linkageName: "_ZNKSt6vectorIPiSaIS0_EE14_M_range_checkEm", scope: !23, file: !21, line: 1290, type: !474, scopeLine: 1290, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!474 = !DISubroutineType(types: !475)
!475 = !{null, !425, !20}
!476 = !DISubprogram(name: "at", linkageName: "_ZNSt6vectorIPiSaIS0_EE2atEm", scope: !23, file: !21, line: 1313, type: !459, scopeLine: 1313, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!477 = !DISubprogram(name: "at", linkageName: "_ZNKSt6vectorIPiSaIS0_EE2atEm", scope: !23, file: !21, line: 1332, type: !467, scopeLine: 1332, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!478 = !DISubprogram(name: "front", linkageName: "_ZNSt6vectorIPiSaIS0_EE5frontEv", scope: !23, file: !21, line: 1344, type: !479, scopeLine: 1344, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!479 = !DISubroutineType(types: !480)
!480 = !{!461, !292}
!481 = !DISubprogram(name: "front", linkageName: "_ZNKSt6vectorIPiSaIS0_EE5frontEv", scope: !23, file: !21, line: 1356, type: !482, scopeLine: 1356, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!482 = !DISubroutineType(types: !483)
!483 = !{!469, !425}
!484 = !DISubprogram(name: "back", linkageName: "_ZNSt6vectorIPiSaIS0_EE4backEv", scope: !23, file: !21, line: 1368, type: !479, scopeLine: 1368, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!485 = !DISubprogram(name: "back", linkageName: "_ZNKSt6vectorIPiSaIS0_EE4backEv", scope: !23, file: !21, line: 1380, type: !482, scopeLine: 1380, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!486 = !DISubprogram(name: "data", linkageName: "_ZNSt6vectorIPiSaIS0_EE4dataEv", scope: !23, file: !21, line: 1395, type: !487, scopeLine: 1395, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!487 = !DISubroutineType(types: !488)
!488 = !{!47, !292}
!489 = !DISubprogram(name: "data", linkageName: "_ZNKSt6vectorIPiSaIS0_EE4dataEv", scope: !23, file: !21, line: 1400, type: !490, scopeLine: 1400, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!490 = !DISubroutineType(types: !491)
!491 = !{!369, !425}
!492 = !DISubprogram(name: "push_back", linkageName: "_ZNSt6vectorIPiSaIS0_EE9push_backERKS0_", scope: !23, file: !21, line: 1416, type: !493, scopeLine: 1416, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!493 = !DISubroutineType(types: !494)
!494 = !{null, !292, !305}
!495 = !DISubprogram(name: "push_back", linkageName: "_ZNSt6vectorIPiSaIS0_EE9push_backEOS0_", scope: !23, file: !21, line: 1433, type: !496, scopeLine: 1433, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!496 = !DISubroutineType(types: !497)
!497 = !{null, !292, !498}
!498 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !307, size: 64)
!499 = !DISubprogram(name: "pop_back", linkageName: "_ZNSt6vectorIPiSaIS0_EE8pop_backEv", scope: !23, file: !21, line: 1457, type: !290, scopeLine: 1457, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!500 = !DISubprogram(name: "insert", linkageName: "_ZNSt6vectorIPiSaIS0_EE6insertEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EERS5_", scope: !23, file: !21, line: 1497, type: !501, scopeLine: 1497, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!501 = !DISubroutineType(types: !502)
!502 = !{!22, !292, !364, !305}
!503 = !DISubprogram(name: "insert", linkageName: "_ZNSt6vectorIPiSaIS0_EE6insertEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EEOS0_", scope: !23, file: !21, line: 1528, type: !504, scopeLine: 1528, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!504 = !DISubroutineType(types: !505)
!505 = !{!22, !292, !364, !498}
!506 = !DISubprogram(name: "insert", linkageName: "_ZNSt6vectorIPiSaIS0_EE6insertEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EESt16initializer_listIS0_E", scope: !23, file: !21, line: 1546, type: !507, scopeLine: 1546, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!507 = !DISubroutineType(types: !508)
!508 = !{!22, !292, !364, !339}
!509 = !DISubprogram(name: "insert", linkageName: "_ZNSt6vectorIPiSaIS0_EE6insertEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EEmRS5_", scope: !23, file: !21, line: 1572, type: !510, scopeLine: 1572, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!510 = !DISubroutineType(types: !511)
!511 = !{!22, !292, !364, !20, !305}
!512 = !DISubprogram(name: "erase", linkageName: "_ZNSt6vectorIPiSaIS0_EE5eraseEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EE", scope: !23, file: !21, line: 1792, type: !513, scopeLine: 1792, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!513 = !DISubroutineType(types: !514)
!514 = !{!22, !292, !364}
!515 = !DISubprogram(name: "erase", linkageName: "_ZNSt6vectorIPiSaIS0_EE5eraseEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EES7_", scope: !23, file: !21, line: 1820, type: !516, scopeLine: 1820, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!516 = !DISubroutineType(types: !517)
!517 = !{!22, !292, !364, !364}
!518 = !DISubprogram(name: "swap", linkageName: "_ZNSt6vectorIPiSaIS0_EE4swapERS2_", scope: !23, file: !21, line: 1844, type: !519, scopeLine: 1844, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!519 = !DISubroutineType(types: !520)
!520 = !{null, !292, !345}
!521 = !DISubprogram(name: "clear", linkageName: "_ZNSt6vectorIPiSaIS0_EE5clearEv", scope: !23, file: !21, line: 1863, type: !290, scopeLine: 1863, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!522 = !DISubprogram(name: "_M_fill_initialize", linkageName: "_ZNSt6vectorIPiSaIS0_EE18_M_fill_initializeEmRKS0_", scope: !23, file: !21, line: 1997, type: !353, scopeLine: 1997, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!523 = !DISubprogram(name: "_M_default_initialize", linkageName: "_ZNSt6vectorIPiSaIS0_EE21_M_default_initializeEm", scope: !23, file: !21, line: 2008, type: !449, scopeLine: 2008, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!524 = !DISubprogram(name: "_M_fill_assign", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_M_fill_assignEmRKS0_", scope: !23, file: !21, line: 2055, type: !353, scopeLine: 2055, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!525 = !DISubprogram(name: "_M_fill_insert", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_M_fill_insertEN9__gnu_cxx17__normal_iteratorIPS0_S2_EEmRKS0_", scope: !23, file: !21, line: 2099, type: !526, scopeLine: 2099, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!526 = !DISubroutineType(types: !527)
!527 = !{null, !292, !22, !20, !305}
!528 = !DISubprogram(name: "_M_default_append", linkageName: "_ZNSt6vectorIPiSaIS0_EE17_M_default_appendEm", scope: !23, file: !21, line: 2105, type: !449, scopeLine: 2105, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!529 = !DISubprogram(name: "_M_shrink_to_fit", linkageName: "_ZNSt6vectorIPiSaIS0_EE16_M_shrink_to_fitEv", scope: !23, file: !21, line: 2109, type: !530, scopeLine: 2109, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!530 = !DISubroutineType(types: !531)
!531 = !{!135, !292}
!532 = !DISubprogram(name: "_M_insert_rval", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_M_insert_rvalEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EEOS0_", scope: !23, file: !21, line: 2179, type: !504, scopeLine: 2179, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!533 = !DISubprogram(name: "_M_emplace_aux", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_M_emplace_auxEN9__gnu_cxx17__normal_iteratorIPKS0_S2_EEOS0_", scope: !23, file: !21, line: 2190, type: !504, scopeLine: 2190, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!534 = !DISubprogram(name: "_M_check_len", linkageName: "_ZNKSt6vectorIPiSaIS0_EE12_M_check_lenEmPKc", scope: !23, file: !21, line: 2197, type: !535, scopeLine: 2197, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!535 = !DISubroutineType(types: !536)
!536 = !{!537, !425, !20, !538}
!537 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_type", scope: !23, file: !21, line: 493, baseType: !16, flags: DIFlagPublic)
!538 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !539, size: 64)
!539 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !540)
!540 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!541 = !DISubprogram(name: "_S_check_init_len", linkageName: "_ZNSt6vectorIPiSaIS0_EE17_S_check_init_lenEmRKS1_", scope: !23, file: !21, line: 2208, type: !542, scopeLine: 2208, flags: DIFlagProtected | DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!542 = !DISubroutineType(types: !543)
!543 = !{!537, !20, !296}
!544 = !DISubprogram(name: "_S_max_size", linkageName: "_ZNSt6vectorIPiSaIS0_EE11_S_max_sizeERKS1_", scope: !23, file: !21, line: 2217, type: !545, scopeLine: 2217, flags: DIFlagProtected | DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized)
!545 = !DISubroutineType(types: !546)
!546 = !{!537, !547}
!547 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !548, size: 64)
!548 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !282)
!549 = !DISubprogram(name: "_M_erase_at_end", linkageName: "_ZNSt6vectorIPiSaIS0_EE15_M_erase_at_endEPS0_", scope: !23, file: !21, line: 2234, type: !550, scopeLine: 2234, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!550 = !DISubroutineType(types: !551)
!551 = !{null, !292, !280}
!552 = !DISubprogram(name: "_M_erase", linkageName: "_ZNSt6vectorIPiSaIS0_EE8_M_eraseEN9__gnu_cxx17__normal_iteratorIPS0_S2_EE", scope: !23, file: !21, line: 2247, type: !553, scopeLine: 2247, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!553 = !DISubroutineType(types: !554)
!554 = !{!22, !292, !22}
!555 = !DISubprogram(name: "_M_erase", linkageName: "_ZNSt6vectorIPiSaIS0_EE8_M_eraseEN9__gnu_cxx17__normal_iteratorIPS0_S2_EES6_", scope: !23, file: !21, line: 2251, type: !556, scopeLine: 2251, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!556 = !DISubroutineType(types: !557)
!557 = !{!22, !292, !22, !22}
!558 = !DISubprogram(name: "_M_move_assign", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_M_move_assignEOS2_St17integral_constantIbLb1EE", scope: !23, file: !21, line: 2260, type: !559, scopeLine: 2260, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!559 = !DISubroutineType(types: !560)
!560 = !{null, !292, !316, !242}
!561 = !DISubprogram(name: "_M_move_assign", linkageName: "_ZNSt6vectorIPiSaIS0_EE14_M_move_assignEOS2_St17integral_constantIbLb0EE", scope: !23, file: !21, line: 2272, type: !562, scopeLine: 2272, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!562 = !DISubroutineType(types: !563)
!563 = !{null, !292, !316, !262}
!564 = !{!86, !565}
!565 = !DITemplateTypeParameter(name: "_Alloc", type: !50, defaulted: true)
!566 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "__normal_iterator<int **, std::vector<int *, std::allocator<int *> > >", scope: !37, file: !366, line: 1026, size: 64, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !567, templateParams: !619, identifier: "_ZTSN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEE")
!567 = !{!568, !569, !573, !578, !589, !594, !598, !601, !602, !603, !608, !611, !614, !615, !616}
!568 = !DIDerivedType(tag: DW_TAG_member, name: "_M_current", scope: !566, file: !366, line: 1029, baseType: !47, size: 64, flags: DIFlagProtected)
!569 = !DISubprogram(name: "__normal_iterator", scope: !566, file: !366, line: 1053, type: !570, scopeLine: 1053, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!570 = !DISubroutineType(types: !571)
!571 = !{null, !572}
!572 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !566, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!573 = !DISubprogram(name: "__normal_iterator", scope: !566, file: !366, line: 1058, type: !574, scopeLine: 1058, flags: DIFlagPublic | DIFlagExplicit | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!574 = !DISubroutineType(types: !575)
!575 = !{null, !572, !576}
!576 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !577, size: 64)
!577 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !47)
!578 = !DISubprogram(name: "operator*", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEdeEv", scope: !566, file: !366, line: 1089, type: !579, scopeLine: 1089, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!579 = !DISubroutineType(types: !580)
!580 = !{!581, !587}
!581 = !DIDerivedType(tag: DW_TAG_typedef, name: "reference", scope: !566, file: !366, line: 1044, baseType: !582, flags: DIFlagPublic)
!582 = !DIDerivedType(tag: DW_TAG_typedef, name: "reference", scope: !583, file: !385, line: 207, baseType: !586)
!583 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iterator_traits<int **>", scope: !18, file: !385, line: 200, size: 8, flags: DIFlagTypePassByValue, elements: !142, templateParams: !584, identifier: "_ZTSSt15iterator_traitsIPPiE")
!584 = !{!585}
!585 = !DITemplateTypeParameter(name: "_Iterator", type: !47)
!586 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !15, size: 64)
!587 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !588, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!588 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !566)
!589 = !DISubprogram(name: "operator->", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEptEv", scope: !566, file: !366, line: 1095, type: !590, scopeLine: 1095, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!590 = !DISubroutineType(types: !591)
!591 = !{!592, !587}
!592 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !566, file: !366, line: 1045, baseType: !593, flags: DIFlagPublic)
!593 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", scope: !583, file: !385, line: 206, baseType: !47)
!594 = !DISubprogram(name: "operator++", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEppEv", scope: !566, file: !366, line: 1101, type: !595, scopeLine: 1101, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!595 = !DISubroutineType(types: !596)
!596 = !{!597, !572}
!597 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !566, size: 64)
!598 = !DISubprogram(name: "operator++", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEppEi", scope: !566, file: !366, line: 1110, type: !599, scopeLine: 1110, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!599 = !DISubroutineType(types: !600)
!600 = !{!566, !572, !5}
!601 = !DISubprogram(name: "operator--", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEmmEv", scope: !566, file: !366, line: 1118, type: !595, scopeLine: 1118, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!602 = !DISubprogram(name: "operator--", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEmmEi", scope: !566, file: !366, line: 1127, type: !599, scopeLine: 1127, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!603 = !DISubprogram(name: "operator[]", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEixEl", scope: !566, file: !366, line: 1135, type: !604, scopeLine: 1135, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!604 = !DISubroutineType(types: !605)
!605 = !{!581, !587, !606}
!606 = !DIDerivedType(tag: DW_TAG_typedef, name: "difference_type", scope: !566, file: !366, line: 1043, baseType: !607, flags: DIFlagPublic)
!607 = !DIDerivedType(tag: DW_TAG_typedef, name: "difference_type", scope: !583, file: !385, line: 205, baseType: !411)
!608 = !DISubprogram(name: "operator+=", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEpLEl", scope: !566, file: !366, line: 1141, type: !609, scopeLine: 1141, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!609 = !DISubroutineType(types: !610)
!610 = !{!597, !572, !606}
!611 = !DISubprogram(name: "operator+", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEplEl", scope: !566, file: !366, line: 1147, type: !612, scopeLine: 1147, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!612 = !DISubroutineType(types: !613)
!613 = !{!566, !587, !606}
!614 = !DISubprogram(name: "operator-=", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEmIEl", scope: !566, file: !366, line: 1153, type: !609, scopeLine: 1153, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!615 = !DISubprogram(name: "operator-", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEmiEl", scope: !566, file: !366, line: 1159, type: !612, scopeLine: 1159, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!616 = !DISubprogram(name: "base", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEE4baseEv", scope: !566, file: !366, line: 1165, type: !617, scopeLine: 1165, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!617 = !DISubroutineType(types: !618)
!618 = !{!576, !587}
!619 = !{!585, !424}
!620 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !621, size: 64)
!621 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Args7", file: !3, line: 277, size: 128, flags: DIFlagTypePassByValue, elements: !622, identifier: "_ZTS5Args7")
!622 = !{!623, !624}
!623 = !DIDerivedType(tag: DW_TAG_member, name: "arr", scope: !621, file: !3, line: 277, baseType: !15, size: 64)
!624 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !621, file: !3, line: 277, baseType: !5, size: 32, offset: 64)
!625 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !626, size: 64)
!626 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Args8", file: !3, line: 304, size: 64, flags: DIFlagTypePassByValue, elements: !627, identifier: "_ZTS5Args8")
!627 = !{!628}
!628 = !DIDerivedType(tag: DW_TAG_member, name: "arr", scope: !626, file: !3, line: 304, baseType: !15, size: 64)
!629 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !630, size: 64)
!630 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Outer12", file: !3, line: 416, size: 96, flags: DIFlagTypePassByValue, elements: !631, identifier: "_ZTS7Outer12")
!631 = !{!632, !637}
!632 = !DIDerivedType(tag: DW_TAG_member, name: "inner", scope: !630, file: !3, line: 416, baseType: !633, size: 64)
!633 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Inner12", file: !3, line: 415, size: 64, flags: DIFlagTypePassByValue, elements: !634, identifier: "_ZTS7Inner12")
!634 = !{!635, !636}
!635 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !633, file: !3, line: 415, baseType: !5, size: 32)
!636 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !633, file: !3, line: 415, baseType: !5, size: 32, offset: 32)
!637 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !630, file: !3, line: 416, baseType: !5, size: 32, offset: 64)
!638 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !639, line: 79, baseType: !19)
!639 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a010b332c1b55b6d664dc31f0502baaf")
!640 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !641, size: 64)
!641 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Args13", file: !3, line: 443, size: 64, flags: DIFlagTypePassByValue, elements: !642, identifier: "_ZTS6Args13")
!642 = !{!643}
!643 = !DIDerivedType(tag: DW_TAG_member, name: "ptr_bits", scope: !641, file: !3, line: 443, baseType: !638, size: 64)
!644 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !645, size: 64)
!645 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !646)
!646 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ReadOnly14", file: !3, line: 474, size: 256, flags: DIFlagTypePassByValue, elements: !647, identifier: "_ZTS10ReadOnly14")
!647 = !{!648}
!648 = !DIDerivedType(tag: DW_TAG_member, name: "values", scope: !646, file: !3, line: 474, baseType: !649, size: 256)
!649 = !DICompositeType(tag: DW_TAG_array_type, baseType: !650, size: 256, elements: !651)
!650 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!651 = !{!652}
!652 = !DISubrange(count: 8)
!653 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !654, size: 64)
!654 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "CB15", file: !3, line: 500, size: 128, flags: DIFlagTypePassByValue, elements: !655, identifier: "_ZTS4CB15")
!655 = !{!656, !661}
!656 = !DIDerivedType(tag: DW_TAG_member, name: "fn", scope: !654, file: !3, line: 501, baseType: !657, size: 64)
!657 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !658, size: 64)
!658 = !DISubroutineType(types: !659)
!659 = !{null, !660}
!660 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!661 = !DIDerivedType(tag: DW_TAG_member, name: "ctx", scope: !654, file: !3, line: 502, baseType: !660, size: 64, offset: 64)
!662 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_Guard_alloc", scope: !23, file: !21, line: 1868, size: 192, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !663, identifier: "_ZTSNSt6vectorIPiSaIS0_EE12_Guard_allocE")
!663 = !{!664, !665, !666, !669, !673, !676, !679}
!664 = !DIDerivedType(tag: DW_TAG_member, name: "_M_storage", scope: !662, file: !21, line: 1870, baseType: !280, size: 64)
!665 = !DIDerivedType(tag: DW_TAG_member, name: "_M_len", scope: !662, file: !21, line: 1871, baseType: !20, size: 64, offset: 64)
!666 = !DIDerivedType(tag: DW_TAG_member, name: "_M_vect", scope: !662, file: !21, line: 1872, baseType: !667, size: 64, offset: 128)
!667 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !668, size: 64)
!668 = !DIDerivedType(tag: DW_TAG_typedef, name: "_Base", scope: !23, file: !21, line: 478, baseType: !26)
!669 = !DISubprogram(name: "_Guard_alloc", scope: !662, file: !21, line: 1875, type: !670, scopeLine: 1875, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!670 = !DISubroutineType(types: !671)
!671 = !{null, !672, !280, !20, !667}
!672 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !662, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!673 = !DISubprogram(name: "~_Guard_alloc", scope: !662, file: !21, line: 1880, type: !674, scopeLine: 1880, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!674 = !DISubroutineType(types: !675)
!675 = !{null, !672}
!676 = !DISubprogram(name: "_M_release", linkageName: "_ZNSt6vectorIPiSaIS0_EE12_Guard_alloc10_M_releaseEv", scope: !662, file: !21, line: 1888, type: !677, scopeLine: 1888, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!677 = !DISubroutineType(types: !678)
!678 = !{!280, !672}
!679 = !DISubprogram(name: "_Guard_alloc", scope: !662, file: !21, line: 1896, type: !680, scopeLine: 1896, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!680 = !DISubroutineType(types: !681)
!681 = !{null, !672, !682}
!682 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !683, size: 64)
!683 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !662)
!684 = !{!0, !685, !690, !695, !697, !702, !707, !712, !717, !722, !730, !735, !740, !745, !750, !752, !755, !787, !792, !797, !802, !804, !806, !811, !816, !818, !824, !829, !834, !839, !844, !846, !848, !853, !855, !860, !865, !867, !872, !877, !882, !887, !892, !897, !902, !907, !909}
!685 = !DIGlobalVariableExpression(var: !686, expr: !DIExpression())
!686 = distinct !DIGlobalVariable(scope: null, file: !3, line: 549, type: !687, isLocal: true, isDefinition: true)
!687 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1320, elements: !688)
!688 = !{!689}
!689 = !DISubrange(count: 165)
!690 = !DIGlobalVariableExpression(var: !691, expr: !DIExpression())
!691 = distinct !DIGlobalVariable(scope: null, file: !3, line: 550, type: !692, isLocal: true, isDefinition: true)
!692 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 448, elements: !693)
!693 = !{!694}
!694 = !DISubrange(count: 56)
!695 = !DIGlobalVariableExpression(var: !696, expr: !DIExpression())
!696 = distinct !DIGlobalVariable(scope: null, file: !3, line: 551, type: !687, isLocal: true, isDefinition: true)
!697 = !DIGlobalVariableExpression(var: !698, expr: !DIExpression())
!698 = distinct !DIGlobalVariable(scope: null, file: !3, line: 560, type: !699, isLocal: true, isDefinition: true)
!699 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 16, elements: !700)
!700 = !{!701}
!701 = !DISubrange(count: 2)
!702 = !DIGlobalVariableExpression(var: !703, expr: !DIExpression())
!703 = distinct !DIGlobalVariable(scope: null, file: !3, line: 562, type: !704, isLocal: true, isDefinition: true)
!704 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1312, elements: !705)
!705 = !{!706}
!706 = !DISubrange(count: 164)
!707 = !DIGlobalVariableExpression(var: !708, expr: !DIExpression())
!708 = distinct !DIGlobalVariable(scope: null, file: !3, line: 563, type: !709, isLocal: true, isDefinition: true)
!709 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 88, elements: !710)
!710 = !{!711}
!711 = !DISubrange(count: 11)
!712 = !DIGlobalVariableExpression(var: !713, expr: !DIExpression())
!713 = distinct !DIGlobalVariable(scope: null, file: !3, line: 564, type: !714, isLocal: true, isDefinition: true)
!714 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 384, elements: !715)
!715 = !{!716}
!716 = !DISubrange(count: 48)
!717 = !DIGlobalVariableExpression(var: !718, expr: !DIExpression())
!718 = distinct !DIGlobalVariable(scope: null, file: !3, line: 565, type: !719, isLocal: true, isDefinition: true)
!719 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 424, elements: !720)
!720 = !{!721}
!721 = !DISubrange(count: 53)
!722 = !DIGlobalVariableExpression(var: !723, expr: !DIExpression())
!723 = distinct !DIGlobalVariable(name: "TESTS", linkageName: "_ZL5TESTS", scope: !2, file: !3, line: 530, type: !724, isLocal: true, isDefinition: true)
!724 = !DICompositeType(tag: DW_TAG_array_type, baseType: !725, size: 960, elements: !728)
!725 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !726, size: 64)
!726 = !DISubroutineType(types: !727)
!727 = !{null}
!728 = !{!729}
!729 = !DISubrange(count: 15)
!730 = !DIGlobalVariableExpression(var: !731, expr: !DIExpression())
!731 = distinct !DIGlobalVariable(scope: null, file: !3, line: 99, type: !732, isLocal: true, isDefinition: true)
!732 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1584, elements: !733)
!733 = !{!734}
!734 = !DISubrange(count: 198)
!735 = !DIGlobalVariableExpression(var: !736, expr: !DIExpression())
!736 = distinct !DIGlobalVariable(scope: null, file: !3, line: 109, type: !737, isLocal: true, isDefinition: true)
!737 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 672, elements: !738)
!738 = !{!739}
!739 = !DISubrange(count: 84)
!740 = !DIGlobalVariableExpression(var: !741, expr: !DIExpression())
!741 = distinct !DIGlobalVariable(scope: null, file: !3, line: 133, type: !742, isLocal: true, isDefinition: true)
!742 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1512, elements: !743)
!743 = !{!744}
!744 = !DISubrange(count: 189)
!745 = !DIGlobalVariableExpression(var: !746, expr: !DIExpression())
!746 = distinct !DIGlobalVariable(scope: null, file: !3, line: 142, type: !747, isLocal: true, isDefinition: true)
!747 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 496, elements: !748)
!748 = !{!749}
!749 = !DISubrange(count: 62)
!750 = !DIGlobalVariableExpression(var: !751, expr: !DIExpression())
!751 = distinct !DIGlobalVariable(scope: null, file: !3, line: 151, type: !747, isLocal: true, isDefinition: true)
!752 = !DIGlobalVariableExpression(var: !753, expr: !DIExpression())
!753 = distinct !DIGlobalVariable(name: "g_global", linkageName: "_ZL8g_global", scope: !2, file: !3, line: 119, type: !754, isLocal: true, isDefinition: true)
!754 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !5)
!755 = !DIGlobalVariableExpression(var: !756, expr: !DIExpression())
!756 = distinct !DIGlobalVariable(name: "g_mutex_2", linkageName: "_ZL9g_mutex_2", scope: !2, file: !3, line: 120, type: !757, isLocal: true, isDefinition: true)
!757 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !758, line: 72, baseType: !759)
!758 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8e06fe5d0f3f3d4ee6a7a8929dd2b809")
!759 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !758, line: 67, size: 320, flags: DIFlagTypePassByValue, elements: !760, identifier: "_ZTS15pthread_mutex_t")
!760 = !{!761, !782, !786}
!761 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !759, file: !758, line: 69, baseType: !762, size: 320)
!762 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !763, line: 22, size: 320, flags: DIFlagTypePassByValue, elements: !764, identifier: "_ZTS17__pthread_mutex_s")
!763 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "dd3989155840df74989f662ad537bbcc")
!764 = !{!765, !766, !768, !769, !770, !771, !773, !774}
!765 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !762, file: !763, line: 24, baseType: !5, size: 32)
!766 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !762, file: !763, line: 25, baseType: !767, size: 32, offset: 32)
!767 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!768 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !762, file: !763, line: 26, baseType: !5, size: 32, offset: 64)
!769 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !762, file: !763, line: 28, baseType: !767, size: 32, offset: 96)
!770 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !762, file: !763, line: 32, baseType: !5, size: 32, offset: 128)
!771 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !762, file: !763, line: 34, baseType: !772, size: 16, offset: 160)
!772 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!773 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !762, file: !763, line: 35, baseType: !772, size: 16, offset: 176)
!774 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !762, file: !763, line: 36, baseType: !775, size: 128, offset: 192)
!775 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !776, line: 55, baseType: !777)
!776 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4de73b5923ab08445dd348713aeb0a37")
!777 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !776, line: 51, size: 128, flags: DIFlagTypePassByValue, elements: !778, identifier: "_ZTS23__pthread_internal_list")
!778 = !{!779, !781}
!779 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !777, file: !776, line: 53, baseType: !780, size: 64)
!780 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !777, size: 64)
!781 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !777, file: !776, line: 54, baseType: !780, size: 64, offset: 64)
!782 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !759, file: !758, line: 70, baseType: !783, size: 320)
!783 = !DICompositeType(tag: DW_TAG_array_type, baseType: !540, size: 320, elements: !784)
!784 = !{!785}
!785 = !DISubrange(count: 40)
!786 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !759, file: !758, line: 71, baseType: !10, size: 64)
!787 = !DIGlobalVariableExpression(var: !788, expr: !DIExpression())
!788 = distinct !DIGlobalVariable(scope: null, file: !3, line: 170, type: !789, isLocal: true, isDefinition: true)
!789 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1688, elements: !790)
!790 = !{!791}
!791 = !DISubrange(count: 211)
!792 = !DIGlobalVariableExpression(var: !793, expr: !DIExpression())
!793 = distinct !DIGlobalVariable(scope: null, file: !3, line: 180, type: !794, isLocal: true, isDefinition: true)
!794 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 600, elements: !795)
!795 = !{!796}
!796 = !DISubrange(count: 75)
!797 = !DIGlobalVariableExpression(var: !798, expr: !DIExpression())
!798 = distinct !DIGlobalVariable(scope: null, file: !3, line: 197, type: !799, isLocal: true, isDefinition: true)
!799 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1776, elements: !800)
!800 = !{!801}
!801 = !DISubrange(count: 222)
!802 = !DIGlobalVariableExpression(var: !803, expr: !DIExpression())
!803 = distinct !DIGlobalVariable(scope: null, file: !3, line: 207, type: !794, isLocal: true, isDefinition: true)
!804 = !DIGlobalVariableExpression(var: !805, expr: !DIExpression())
!805 = distinct !DIGlobalVariable(name: "g_stack_ptr", linkageName: "_ZL11g_stack_ptr", scope: !2, file: !3, line: 190, type: !15, isLocal: true, isDefinition: true)
!806 = !DIGlobalVariableExpression(var: !807, expr: !DIExpression())
!807 = distinct !DIGlobalVariable(scope: null, file: !3, line: 227, type: !808, isLocal: true, isDefinition: true)
!808 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1640, elements: !809)
!809 = !{!810}
!810 = !DISubrange(count: 205)
!811 = !DIGlobalVariableExpression(var: !812, expr: !DIExpression())
!812 = distinct !DIGlobalVariable(scope: null, file: !3, line: 240, type: !813, isLocal: true, isDefinition: true)
!813 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 576, elements: !814)
!814 = !{!815}
!815 = !DISubrange(count: 72)
!816 = !DIGlobalVariableExpression(var: !817, expr: !DIExpression())
!817 = distinct !DIGlobalVariable(name: "g_vec_mutex", linkageName: "_ZL11g_vec_mutex", scope: !2, file: !3, line: 217, type: !757, isLocal: true, isDefinition: true)
!818 = !DIGlobalVariableExpression(var: !819, expr: !DIExpression())
!819 = distinct !DIGlobalVariable(scope: null, file: !820, line: 566, type: !821, isLocal: true, isDefinition: true)
!820 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/vector.tcc", directory: "", checksumkind: CSK_MD5, checksum: "64f75edbe1420af49b20c6a8641361c4")
!821 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 208, elements: !822)
!822 = !{!823}
!823 = !DISubrange(count: 26)
!824 = !DIGlobalVariableExpression(var: !825, expr: !DIExpression())
!825 = distinct !DIGlobalVariable(scope: null, file: !3, line: 255, type: !826, isLocal: true, isDefinition: true)
!826 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1648, elements: !827)
!827 = !{!828}
!828 = !DISubrange(count: 206)
!829 = !DIGlobalVariableExpression(var: !830, expr: !DIExpression())
!830 = distinct !DIGlobalVariable(scope: null, file: !3, line: 265, type: !831, isLocal: true, isDefinition: true)
!831 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 528, elements: !832)
!832 = !{!833}
!833 = !DISubrange(count: 66)
!834 = !DIGlobalVariableExpression(var: !835, expr: !DIExpression())
!835 = distinct !DIGlobalVariable(scope: null, file: !3, line: 285, type: !836, isLocal: true, isDefinition: true)
!836 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1728, elements: !837)
!837 = !{!838}
!838 = !DISubrange(count: 216)
!839 = !DIGlobalVariableExpression(var: !840, expr: !DIExpression())
!840 = distinct !DIGlobalVariable(scope: null, file: !3, line: 297, type: !841, isLocal: true, isDefinition: true)
!841 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 624, elements: !842)
!842 = !{!843}
!843 = !DISubrange(count: 78)
!844 = !DIGlobalVariableExpression(var: !845, expr: !DIExpression())
!845 = distinct !DIGlobalVariable(scope: null, file: !3, line: 317, type: !808, isLocal: true, isDefinition: true)
!846 = !DIGlobalVariableExpression(var: !847, expr: !DIExpression())
!847 = distinct !DIGlobalVariable(scope: null, file: !3, line: 325, type: !841, isLocal: true, isDefinition: true)
!848 = !DIGlobalVariableExpression(var: !849, expr: !DIExpression())
!849 = distinct !DIGlobalVariable(scope: null, file: !3, line: 343, type: !850, isLocal: true, isDefinition: true)
!850 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1736, elements: !851)
!851 = !{!852}
!852 = !DISubrange(count: 217)
!853 = !DIGlobalVariableExpression(var: !854, expr: !DIExpression())
!854 = distinct !DIGlobalVariable(scope: null, file: !3, line: 351, type: !841, isLocal: true, isDefinition: true)
!855 = !DIGlobalVariableExpression(var: !856, expr: !DIExpression())
!856 = distinct !DIGlobalVariable(scope: null, file: !3, line: 372, type: !857, isLocal: true, isDefinition: true)
!857 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1792, elements: !858)
!858 = !{!859}
!859 = !DISubrange(count: 224)
!860 = !DIGlobalVariableExpression(var: !861, expr: !DIExpression())
!861 = distinct !DIGlobalVariable(scope: null, file: !3, line: 377, type: !862, isLocal: true, isDefinition: true)
!862 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 568, elements: !863)
!863 = !{!864}
!864 = !DISubrange(count: 71)
!865 = !DIGlobalVariableExpression(var: !866, expr: !DIExpression())
!866 = distinct !DIGlobalVariable(name: "tls_counter", linkageName: "_ZL11tls_counter", scope: !2, file: !3, line: 361, type: !5, isLocal: true, isDefinition: true)
!867 = !DIGlobalVariableExpression(var: !868, expr: !DIExpression())
!868 = distinct !DIGlobalVariable(scope: null, file: !3, line: 399, type: !869, isLocal: true, isDefinition: true)
!869 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1752, elements: !870)
!870 = !{!871}
!871 = !DISubrange(count: 219)
!872 = !DIGlobalVariableExpression(var: !873, expr: !DIExpression())
!873 = distinct !DIGlobalVariable(scope: null, file: !3, line: 404, type: !874, isLocal: true, isDefinition: true)
!874 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 608, elements: !875)
!875 = !{!876}
!876 = !DISubrange(count: 76)
!877 = !DIGlobalVariableExpression(var: !878, expr: !DIExpression())
!878 = distinct !DIGlobalVariable(scope: null, file: !3, line: 425, type: !879, isLocal: true, isDefinition: true)
!879 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1544, elements: !880)
!880 = !{!881}
!881 = !DISubrange(count: 193)
!882 = !DIGlobalVariableExpression(var: !883, expr: !DIExpression())
!883 = distinct !DIGlobalVariable(scope: null, file: !3, line: 433, type: !884, isLocal: true, isDefinition: true)
!884 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 656, elements: !885)
!885 = !{!886}
!886 = !DISubrange(count: 82)
!887 = !DIGlobalVariableExpression(var: !888, expr: !DIExpression())
!888 = distinct !DIGlobalVariable(scope: null, file: !3, line: 453, type: !889, isLocal: true, isDefinition: true)
!889 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1536, elements: !890)
!890 = !{!891}
!891 = !DISubrange(count: 192)
!892 = !DIGlobalVariableExpression(var: !893, expr: !DIExpression())
!893 = distinct !DIGlobalVariable(scope: null, file: !3, line: 464, type: !894, isLocal: true, isDefinition: true)
!894 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 688, elements: !895)
!895 = !{!896}
!896 = !DISubrange(count: 86)
!897 = !DIGlobalVariableExpression(var: !898, expr: !DIExpression())
!898 = distinct !DIGlobalVariable(scope: null, file: !3, line: 484, type: !899, isLocal: true, isDefinition: true)
!899 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 1672, elements: !900)
!900 = !{!901}
!901 = !DISubrange(count: 209)
!902 = !DIGlobalVariableExpression(var: !903, expr: !DIExpression())
!903 = distinct !DIGlobalVariable(scope: null, file: !3, line: 490, type: !904, isLocal: true, isDefinition: true)
!904 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 640, elements: !905)
!905 = !{!906}
!906 = !DISubrange(count: 80)
!907 = !DIGlobalVariableExpression(var: !908, expr: !DIExpression())
!908 = distinct !DIGlobalVariable(scope: null, file: !3, line: 515, type: !808, isLocal: true, isDefinition: true)
!909 = !DIGlobalVariableExpression(var: !910, expr: !DIExpression())
!910 = distinct !DIGlobalVariable(scope: null, file: !3, line: 524, type: !911, isLocal: true, isDefinition: true)
!911 = !DICompositeType(tag: DW_TAG_array_type, baseType: !539, size: 744, elements: !912)
!912 = !{!913}
!913 = !DISubrange(count: 93)
!914 = !{!915, !921, !925, !931, !933, !939, !943, !945, !950, !954, !958, !966, !968, !972, !976, !978, !983, !987, !991, !995, !999, !1007, !1011, !1015, !1017, !1021, !1025, !1029, !1035, !1039, !1043, !1045, !1053, !1057, !1064, !1066, !1070, !1074, !1078, !1082, !1087, !1092, !1097, !1098, !1099, !1100, !1102, !1103, !1104, !1105, !1106, !1107, !1108, !1110, !1111, !1112, !1113, !1114, !1115, !1116, !1117, !1121, !1122, !1123, !1124, !1125, !1126, !1127, !1128, !1129, !1130, !1131, !1132, !1133, !1134, !1135, !1136, !1137, !1138, !1139, !1140, !1141, !1142, !1143, !1144, !1145, !1149, !1157, !1164, !1167, !1170, !1173, !1175, !1177, !1179, !1181, !1185, !1188, !1191, !1194, !1197, !1199, !1204, !1208, !1211, !1214, !1216, !1218, !1220, !1222, !1225, !1228, !1231, !1234, !1237}
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !916, file: !920, line: 58)
!916 = !DISubprogram(name: "abs", scope: !917, file: !917, line: 980, type: !918, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!917 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "2ebb4e08912aad41774217f29ad02c9e")
!918 = !DISubroutineType(types: !919)
!919 = !{!5, !5}
!920 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/std_abs.h", directory: "", checksumkind: CSK_MD5, checksum: "b04fe3ed420747a2e528c0e678ab45db")
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !922, file: !924, line: 137)
!922 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !917, line: 63, baseType: !923)
!923 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !917, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!924 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstdlib", directory: "", checksumkind: CSK_MD5, checksum: "745c77d592b579358a91081122d152be")
!925 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !926, file: !924, line: 138)
!926 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !917, line: 71, baseType: !927)
!927 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !917, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !928, identifier: "_ZTS6ldiv_t")
!928 = !{!929, !930}
!929 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !927, file: !917, line: 69, baseType: !10, size: 64)
!930 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !927, file: !917, line: 70, baseType: !10, size: 64, offset: 64)
!931 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !932, file: !924, line: 140)
!932 = !DISubprogram(name: "abort", scope: !917, file: !917, line: 730, type: !726, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !934, file: !924, line: 142)
!934 = !DISubprogram(name: "aligned_alloc", scope: !917, file: !917, line: 724, type: !935, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!935 = !DISubroutineType(types: !936)
!936 = !{!660, !937, !937}
!937 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !938, line: 18, baseType: !19)
!938 = !DIFile(filename: "/usr/lib/llvm-20/lib/clang/20/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !940, file: !924, line: 144)
!940 = !DISubprogram(name: "atexit", scope: !917, file: !917, line: 734, type: !941, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!941 = !DISubroutineType(types: !942)
!942 = !{!5, !725}
!943 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !944, file: !924, line: 147)
!944 = !DISubprogram(name: "at_quick_exit", scope: !917, file: !917, line: 739, type: !941, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !946, file: !924, line: 150)
!946 = !DISubprogram(name: "atof", scope: !917, file: !917, line: 102, type: !947, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!947 = !DISubroutineType(types: !948)
!948 = !{!949, !538}
!949 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!950 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !951, file: !924, line: 151)
!951 = !DISubprogram(name: "atoi", scope: !917, file: !917, line: 105, type: !952, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!952 = !DISubroutineType(types: !953)
!953 = !{!5, !538}
!954 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !955, file: !924, line: 152)
!955 = !DISubprogram(name: "atol", scope: !917, file: !917, line: 108, type: !956, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!956 = !DISubroutineType(types: !957)
!957 = !{!10, !538}
!958 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !959, file: !924, line: 153)
!959 = !DISubprogram(name: "bsearch", scope: !917, file: !917, line: 960, type: !960, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!960 = !DISubroutineType(types: !961)
!961 = !{!660, !76, !76, !937, !937, !962}
!962 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !917, line: 948, baseType: !963)
!963 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !964, size: 64)
!964 = !DISubroutineType(types: !965)
!965 = !{!5, !76, !76}
!966 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !967, file: !924, line: 154)
!967 = !DISubprogram(name: "calloc", scope: !917, file: !917, line: 675, type: !935, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!968 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !969, file: !924, line: 155)
!969 = !DISubprogram(name: "div", scope: !917, file: !917, line: 998, type: !970, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!970 = !DISubroutineType(types: !971)
!971 = !{!922, !5, !5}
!972 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !973, file: !924, line: 156)
!973 = !DISubprogram(name: "exit", scope: !917, file: !917, line: 756, type: !974, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!974 = !DISubroutineType(types: !975)
!975 = !{null, !5}
!976 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !977, file: !924, line: 157)
!977 = !DISubprogram(name: "free", scope: !917, file: !917, line: 687, type: !658, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!978 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !979, file: !924, line: 158)
!979 = !DISubprogram(name: "getenv", scope: !917, file: !917, line: 773, type: !980, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!980 = !DISubroutineType(types: !981)
!981 = !{!982, !538}
!982 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !540, size: 64)
!983 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !984, file: !924, line: 159)
!984 = !DISubprogram(name: "labs", scope: !917, file: !917, line: 981, type: !985, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!985 = !DISubroutineType(types: !986)
!986 = !{!10, !10}
!987 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !988, file: !924, line: 160)
!988 = !DISubprogram(name: "ldiv", scope: !917, file: !917, line: 1000, type: !989, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!989 = !DISubroutineType(types: !990)
!990 = !{!926, !10, !10}
!991 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !992, file: !924, line: 161)
!992 = !DISubprogram(name: "malloc", scope: !917, file: !917, line: 672, type: !993, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!993 = !DISubroutineType(types: !994)
!994 = !{!660, !937}
!995 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !996, file: !924, line: 163)
!996 = !DISubprogram(name: "mblen", scope: !917, file: !917, line: 1068, type: !997, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!997 = !DISubroutineType(types: !998)
!998 = !{!5, !538, !937}
!999 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1000, file: !924, line: 164)
!1000 = !DISubprogram(name: "mbstowcs", scope: !917, file: !917, line: 1079, type: !1001, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1001 = !DISubroutineType(types: !1002)
!1002 = !{!937, !1003, !1006, !937}
!1003 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1004)
!1004 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1005, size: 64)
!1005 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!1006 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !538)
!1007 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1008, file: !924, line: 165)
!1008 = !DISubprogram(name: "mbtowc", scope: !917, file: !917, line: 1071, type: !1009, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1009 = !DISubroutineType(types: !1010)
!1010 = !{!5, !1003, !1006, !937}
!1011 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1012, file: !924, line: 167)
!1012 = !DISubprogram(name: "qsort", scope: !917, file: !917, line: 970, type: !1013, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1013 = !DISubroutineType(types: !1014)
!1014 = !{null, !660, !937, !937, !962}
!1015 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1016, file: !924, line: 170)
!1016 = !DISubprogram(name: "quick_exit", scope: !917, file: !917, line: 762, type: !974, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!1017 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1018, file: !924, line: 173)
!1018 = !DISubprogram(name: "rand", scope: !917, file: !917, line: 573, type: !1019, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1019 = !DISubroutineType(types: !1020)
!1020 = !{!5}
!1021 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1022, file: !924, line: 174)
!1022 = !DISubprogram(name: "realloc", scope: !917, file: !917, line: 683, type: !1023, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1023 = !DISubroutineType(types: !1024)
!1024 = !{!660, !660, !937}
!1025 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1026, file: !924, line: 175)
!1026 = !DISubprogram(name: "srand", scope: !917, file: !917, line: 575, type: !1027, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1027 = !DISubroutineType(types: !1028)
!1028 = !{null, !767}
!1029 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1030, file: !924, line: 176)
!1030 = !DISubprogram(name: "strtod", scope: !917, file: !917, line: 118, type: !1031, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1031 = !DISubroutineType(types: !1032)
!1032 = !{!949, !1006, !1033}
!1033 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1034)
!1034 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !982, size: 64)
!1035 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1036, file: !924, line: 177)
!1036 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !917, file: !917, line: 215, type: !1037, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1037 = !DISubroutineType(types: !1038)
!1038 = !{!10, !1006, !1033, !5}
!1039 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1040, file: !924, line: 178)
!1040 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !917, file: !917, line: 219, type: !1041, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1041 = !DISubroutineType(types: !1042)
!1042 = !{!19, !1006, !1033, !5}
!1043 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1044, file: !924, line: 179)
!1044 = !DISubprogram(name: "system", scope: !917, file: !917, line: 923, type: !952, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1045 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1046, file: !924, line: 181)
!1046 = !DISubprogram(name: "wcstombs", scope: !917, file: !917, line: 1083, type: !1047, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1047 = !DISubroutineType(types: !1048)
!1048 = !{!937, !1049, !1050, !937}
!1049 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !982)
!1050 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1051)
!1051 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1052, size: 64)
!1052 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1005)
!1053 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1054, file: !924, line: 182)
!1054 = !DISubprogram(name: "wctomb", scope: !917, file: !917, line: 1075, type: !1055, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1055 = !DISubroutineType(types: !1056)
!1056 = !{!5, !982, !1005}
!1057 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1058, file: !924, line: 210)
!1058 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !917, line: 81, baseType: !1059)
!1059 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !917, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !1060, identifier: "_ZTS7lldiv_t")
!1060 = !{!1061, !1063}
!1061 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !1059, file: !917, line: 79, baseType: !1062, size: 64)
!1062 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!1063 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !1059, file: !917, line: 80, baseType: !1062, size: 64, offset: 64)
!1064 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1065, file: !924, line: 216)
!1065 = !DISubprogram(name: "_Exit", scope: !917, file: !917, line: 768, type: !974, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!1066 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1067, file: !924, line: 222)
!1067 = !DISubprogram(name: "llabs", scope: !917, file: !917, line: 984, type: !1068, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1068 = !DISubroutineType(types: !1069)
!1069 = !{!1062, !1062}
!1070 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1071, file: !924, line: 228)
!1071 = !DISubprogram(name: "lldiv", scope: !917, file: !917, line: 1004, type: !1072, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1072 = !DISubroutineType(types: !1073)
!1073 = !{!1058, !1062, !1062}
!1074 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1075, file: !924, line: 240)
!1075 = !DISubprogram(name: "atoll", scope: !917, file: !917, line: 113, type: !1076, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1076 = !DISubroutineType(types: !1077)
!1077 = !{!1062, !538}
!1078 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1079, file: !924, line: 241)
!1079 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !917, file: !917, line: 238, type: !1080, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1080 = !DISubroutineType(types: !1081)
!1081 = !{!1062, !1006, !1033, !5}
!1082 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1083, file: !924, line: 242)
!1083 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !917, file: !917, line: 243, type: !1084, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1084 = !DISubroutineType(types: !1085)
!1085 = !{!1086, !1006, !1033, !5}
!1086 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!1087 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1088, file: !924, line: 244)
!1088 = !DISubprogram(name: "strtof", scope: !917, file: !917, line: 124, type: !1089, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1089 = !DISubroutineType(types: !1090)
!1090 = !{!1091, !1006, !1033}
!1091 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!1092 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !37, entity: !1093, file: !924, line: 245)
!1093 = !DISubprogram(name: "strtold", scope: !917, file: !917, line: 127, type: !1094, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1094 = !DISubroutineType(types: !1095)
!1095 = !{!1096, !1006, !1033}
!1096 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!1097 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1058, file: !924, line: 253)
!1098 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1065, file: !924, line: 255)
!1099 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1067, file: !924, line: 257)
!1100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1101, file: !924, line: 258)
!1101 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !37, file: !924, line: 225, type: !1072, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1071, file: !924, line: 259)
!1103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1075, file: !924, line: 261)
!1104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1088, file: !924, line: 262)
!1105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1079, file: !924, line: 263)
!1106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1083, file: !924, line: 264)
!1107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1093, file: !924, line: 265)
!1108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !932, file: !1109, line: 38)
!1109 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "6b5a21b1805b4429608f31a862826533")
!1110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !940, file: !1109, line: 39)
!1111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !973, file: !1109, line: 40)
!1112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !944, file: !1109, line: 43)
!1113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1016, file: !1109, line: 46)
!1114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1065, file: !1109, line: 49)
!1115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !922, file: !1109, line: 54)
!1116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !926, file: !1109, line: 55)
!1117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1118, file: !1109, line: 57)
!1118 = !DISubprogram(name: "abs", linkageName: "_ZSt3abse", scope: !18, file: !920, line: 85, type: !1119, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1119 = !DISubroutineType(types: !1120)
!1120 = !{!1096, !1096}
!1121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !946, file: !1109, line: 58)
!1122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !951, file: !1109, line: 59)
!1123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !955, file: !1109, line: 60)
!1124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !959, file: !1109, line: 61)
!1125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !967, file: !1109, line: 62)
!1126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1101, file: !1109, line: 63)
!1127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !977, file: !1109, line: 64)
!1128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !979, file: !1109, line: 65)
!1129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !984, file: !1109, line: 66)
!1130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !988, file: !1109, line: 67)
!1131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !992, file: !1109, line: 68)
!1132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !996, file: !1109, line: 70)
!1133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1000, file: !1109, line: 71)
!1134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1008, file: !1109, line: 72)
!1135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1012, file: !1109, line: 74)
!1136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1018, file: !1109, line: 75)
!1137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1022, file: !1109, line: 76)
!1138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1026, file: !1109, line: 77)
!1139 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1030, file: !1109, line: 78)
!1140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1036, file: !1109, line: 79)
!1141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1040, file: !1109, line: 80)
!1142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1044, file: !1109, line: 81)
!1143 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1046, file: !1109, line: 83)
!1144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !1054, file: !1109, line: 84)
!1145 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1146, entity: !1147, file: !1148, line: 58)
!1146 = !DINamespace(name: "__gnu_debug", scope: null)
!1147 = !DINamespace(name: "__debug", scope: !18)
!1148 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/debug/debug.h", directory: "", checksumkind: CSK_MD5, checksum: "80ffd9396e36ed0eb5124a5fe3264bd2")
!1149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1150, file: !1156, line: 66)
!1150 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !1151, line: 24, baseType: !1152)
!1151 = !DIFile(filename: "/usr/lib/llvm-20/lib/clang/20/include/__stddef_max_align_t.h", directory: "", checksumkind: CSK_MD5, checksum: "3c0a2f19d136d39aa835c737c7105def")
!1152 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !1151, line: 19, size: 256, flags: DIFlagTypePassByValue, elements: !1153, identifier: "_ZTS11max_align_t")
!1153 = !{!1154, !1155}
!1154 = !DIDerivedType(tag: DW_TAG_member, name: "__clang_max_align_nonce1", scope: !1152, file: !1151, line: 20, baseType: !1062, size: 64, align: 64)
!1155 = !DIDerivedType(tag: DW_TAG_member, name: "__clang_max_align_nonce2", scope: !1152, file: !1151, line: 22, baseType: !1096, size: 128, align: 128, offset: 128)
!1156 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstddef", directory: "", checksumkind: CSK_MD5, checksum: "706d8a8b8e4539901a932f881126a58d")
!1157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1158, file: !1163, line: 53)
!1158 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !1159, line: 24, baseType: !1160)
!1159 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "d8f6972fff852003b8782e6edd3802e7")
!1160 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !1161, line: 37, baseType: !1162)
!1161 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!1162 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!1163 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstdint", directory: "", checksumkind: CSK_MD5, checksum: "7536ee1dcc999c08a41c991ca26edbcf")
!1164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1165, file: !1163, line: 54)
!1165 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !1159, line: 25, baseType: !1166)
!1166 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !1161, line: 39, baseType: !772)
!1167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1168, file: !1163, line: 55)
!1168 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !1159, line: 26, baseType: !1169)
!1169 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !1161, line: 41, baseType: !5)
!1170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1171, file: !1163, line: 56)
!1171 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !1159, line: 27, baseType: !1172)
!1172 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !1161, line: 44, baseType: !10)
!1173 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1174, file: !1163, line: 58)
!1174 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !639, line: 47, baseType: !1162)
!1175 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1176, file: !1163, line: 59)
!1176 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !639, line: 49, baseType: !10)
!1177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1178, file: !1163, line: 60)
!1178 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !639, line: 50, baseType: !10)
!1179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1180, file: !1163, line: 61)
!1180 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !639, line: 51, baseType: !10)
!1181 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1182, file: !1163, line: 63)
!1182 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !1183, line: 25, baseType: !1184)
!1183 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-least.h", directory: "", checksumkind: CSK_MD5, checksum: "b93fda0210cd6f4c5a0fd5c186961bbe")
!1184 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least8_t", file: !1161, line: 52, baseType: !1160)
!1185 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1186, file: !1163, line: 64)
!1186 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !1183, line: 26, baseType: !1187)
!1187 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least16_t", file: !1161, line: 54, baseType: !1166)
!1188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1189, file: !1163, line: 65)
!1189 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !1183, line: 27, baseType: !1190)
!1190 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least32_t", file: !1161, line: 56, baseType: !1169)
!1191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1192, file: !1163, line: 66)
!1192 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !1183, line: 28, baseType: !1193)
!1193 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least64_t", file: !1161, line: 58, baseType: !1172)
!1194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1195, file: !1163, line: 68)
!1195 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !639, line: 90, baseType: !1196)
!1196 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !1161, line: 72, baseType: !10)
!1197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1198, file: !1163, line: 69)
!1198 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !639, line: 76, baseType: !10)
!1199 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1200, file: !1163, line: 71)
!1200 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !1201, line: 24, baseType: !1202)
!1201 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "006a4d9ce94ea5734db820ef3fdd4790")
!1202 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !1161, line: 38, baseType: !1203)
!1203 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!1204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1205, file: !1163, line: 72)
!1205 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !1201, line: 25, baseType: !1206)
!1206 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !1161, line: 40, baseType: !1207)
!1207 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!1208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1209, file: !1163, line: 73)
!1209 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !1201, line: 26, baseType: !1210)
!1210 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !1161, line: 42, baseType: !767)
!1211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1212, file: !1163, line: 74)
!1212 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !1201, line: 27, baseType: !1213)
!1213 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !1161, line: 45, baseType: !19)
!1214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1215, file: !1163, line: 76)
!1215 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !639, line: 60, baseType: !1203)
!1216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1217, file: !1163, line: 77)
!1217 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !639, line: 62, baseType: !19)
!1218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1219, file: !1163, line: 78)
!1219 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !639, line: 63, baseType: !19)
!1220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1221, file: !1163, line: 79)
!1221 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !639, line: 64, baseType: !19)
!1222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1223, file: !1163, line: 81)
!1223 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !1183, line: 31, baseType: !1224)
!1224 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least8_t", file: !1161, line: 53, baseType: !1202)
!1225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1226, file: !1163, line: 82)
!1226 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !1183, line: 32, baseType: !1227)
!1227 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least16_t", file: !1161, line: 55, baseType: !1206)
!1228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1229, file: !1163, line: 83)
!1229 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !1183, line: 33, baseType: !1230)
!1230 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least32_t", file: !1161, line: 57, baseType: !1210)
!1231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1232, file: !1163, line: 84)
!1232 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !1183, line: 34, baseType: !1233)
!1233 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least64_t", file: !1161, line: 59, baseType: !1213)
!1234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !1235, file: !1163, line: 86)
!1235 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !639, line: 91, baseType: !1236)
!1236 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !1161, line: 73, baseType: !19)
!1237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !638, file: !1163, line: 87)
!1238 = !{i32 7, !"Dwarf Version", i32 5}
!1239 = !{i32 2, !"Debug Info Version", i32 3}
!1240 = !{i32 1, !"wchar_size", i32 4}
!1241 = !{i32 8, !"PIC Level", i32 2}
!1242 = !{i32 7, !"PIE Level", i32 2}
!1243 = !{i32 7, !"uwtable", i32 2}
!1244 = !{i32 7, !"frame-pointer", i32 2}
!1245 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!1246 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!1247 = distinct !DISubprogram(name: "__cxx_global_var_init", scope: !3, file: !3, type: !726, flags: DIFlagArtificial | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!1248 = !DILocation(line: 0, scope: !1247)
!1249 = distinct !DISubprogram(name: "~vector", linkageName: "_ZNSt6vectorIPiSaIS0_EED2Ev", scope: !23, file: !21, line: 800, type: !290, scopeLine: 801, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !341, retainedNodes: !1250)
!1250 = !{!1251}
!1251 = !DILocalVariable(name: "this", arg: 1, scope: !1249, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!1252 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!1253 = !DILocation(line: 0, scope: !1249)
!1254 = !DILocation(line: 802, column: 30, scope: !1255)
!1255 = distinct !DILexicalBlock(scope: !1249, file: !21, line: 801, column: 7)
!1256 = !{!1257, !1258, i64 0}
!1257 = !{!"_ZTSNSt12_Vector_baseIPiSaIS0_EE17_Vector_impl_dataE", !1258, i64 0, !1258, i64 8, !1258, i64 16}
!1258 = !{!"p2 int", !1259, i64 0}
!1259 = !{!"any pointer", !1260, i64 0}
!1260 = !{!"omnipotent char", !1261, i64 0}
!1261 = !{!"Simple C++ TBAA"}
!1262 = !DILocation(line: 802, column: 54, scope: !1255)
!1263 = !{!1257, !1258, i64 8}
!1264 = !DILocation(line: 803, column: 9, scope: !1255)
!1265 = !DILocalVariable(name: "__first", arg: 1, scope: !1266, file: !41, line: 1042, type: !47)
!1266 = distinct !DISubprogram(name: "_Destroy<int **, int *>", linkageName: "_ZSt8_DestroyIPPiS0_EvT_S2_RSaIT0_E", scope: !18, file: !41, line: 1042, type: !1267, scopeLine: 1044, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !1272, retainedNodes: !1269)
!1267 = !DISubroutineType(types: !1268)
!1268 = !{null, !47, !47, !99}
!1269 = !{!1265, !1270, !1271}
!1270 = !DILocalVariable(name: "__last", arg: 2, scope: !1266, file: !41, line: 1042, type: !47)
!1271 = !DILocalVariable(arg: 3, scope: !1266, file: !41, line: 1043, type: !99)
!1272 = !{!1273, !86}
!1273 = !DITemplateTypeParameter(name: "_ForwardIterator", type: !47)
!1274 = !DILocation(line: 0, scope: !1266, inlinedAt: !1275)
!1275 = distinct !DILocation(line: 802, column: 2, scope: !1255)
!1276 = !DILocation(line: 1045, column: 7, scope: !1266, inlinedAt: !1275)
!1277 = !DILocation(line: 805, column: 7, scope: !1255)
!1278 = !DILocation(line: 805, column: 7, scope: !1249)
!1279 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 548, type: !1280, scopeLine: 548, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1282)
!1280 = !DISubroutineType(types: !1281)
!1281 = !{!5, !5, !1034}
!1282 = !{!1283, !1284, !1285, !1286, !1287}
!1283 = !DILocalVariable(name: "argc", arg: 1, scope: !1279, file: !3, line: 548, type: !5)
!1284 = !DILocalVariable(name: "argv", arg: 2, scope: !1279, file: !3, line: 548, type: !1034)
!1285 = !DILocalVariable(name: "which", scope: !1279, file: !3, line: 553, type: !5)
!1286 = !DILocalVariable(name: "n", scope: !1279, file: !3, line: 556, type: !5)
!1287 = !DILocalVariable(name: "i", scope: !1288, file: !3, line: 557, type: !5)
!1288 = distinct !DILexicalBlock(scope: !1279, file: !3, line: 557, column: 5)
!1289 = !DILocation(line: 0, scope: !1279)
!1290 = !DILocation(line: 549, column: 5, scope: !1279)
!1291 = !DILocation(line: 550, column: 5, scope: !1279)
!1292 = !DILocation(line: 551, column: 5, scope: !1279)
!1293 = !DILocation(line: 554, column: 14, scope: !1294)
!1294 = distinct !DILexicalBlock(scope: !1279, file: !3, line: 554, column: 9)
!1295 = !DILocation(line: 554, column: 33, scope: !1294)
!1296 = !{!1297, !1297, i64 0}
!1297 = !{!"p1 omnipotent char", !1259, i64 0}
!1298 = !DILocation(line: 554, column: 28, scope: !1294)
!1299 = !DILocation(line: 554, column: 42, scope: !1294)
!1300 = !DILocation(line: 554, column: 20, scope: !1294)
!1301 = !DILocation(line: 0, scope: !1288)
!1302 = !DILocation(line: 557, column: 5, scope: !1288)
!1303 = !DILocation(line: 562, column: 5, scope: !1279)
!1304 = !DILocation(line: 563, column: 5, scope: !1279)
!1305 = !DILocation(line: 564, column: 5, scope: !1279)
!1306 = !DILocation(line: 565, column: 5, scope: !1279)
!1307 = !DILocation(line: 566, column: 5, scope: !1279)
!1308 = !DILocation(line: 567, column: 5, scope: !1279)
!1309 = !DILocation(line: 558, column: 24, scope: !1310)
!1310 = distinct !DILexicalBlock(scope: !1311, file: !3, line: 558, column: 13)
!1311 = distinct !DILexicalBlock(scope: !1312, file: !3, line: 557, column: 33)
!1312 = distinct !DILexicalBlock(scope: !1288, file: !3, line: 557, column: 5)
!1313 = !DILocation(line: 559, column: 9, scope: !1311)
!1314 = !{!1259, !1259, i64 0}
!1315 = !DILocation(line: 560, column: 9, scope: !1311)
!1316 = !DILocation(line: 561, column: 5, scope: !1311)
!1317 = !DILocation(line: 557, column: 29, scope: !1312)
!1318 = !DILocation(line: 557, column: 23, scope: !1312)
!1319 = distinct !{!1319, !1302, !1320, !1321, !1322}
!1320 = !DILocation(line: 561, column: 5, scope: !1288)
!1321 = !{!"llvm.loop.mustprogress"}
!1322 = !{!"llvm.loop.unroll.disable"}
!1323 = !DISubprogram(name: "printf", scope: !1324, file: !1324, line: 366, type: !1325, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1324 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "2b86e735d437d54be7e36ccbb6a06d84")
!1325 = !DISubroutineType(types: !1326)
!1326 = !{!5, !1006, null}
!1327 = distinct !DISubprogram(name: "_M_get_Tp_allocator", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv", scope: !26, file: !21, line: 307, type: !190, scopeLine: 308, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !189, retainedNodes: !1328)
!1328 = !{!1329}
!1329 = !DILocalVariable(name: "this", arg: 1, scope: !1327, type: !1330, flags: DIFlagArtificial | DIFlagObjectPointer)
!1330 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!1331 = !DILocation(line: 0, scope: !1327)
!1332 = !DILocation(line: 308, column: 9, scope: !1327)
!1333 = distinct !DISubprogram(name: "~_Vector_base", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EED2Ev", scope: !26, file: !21, line: 373, type: !204, scopeLine: 374, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !230, retainedNodes: !1334)
!1334 = !{!1335}
!1335 = !DILocalVariable(name: "this", arg: 1, scope: !1333, type: !1330, flags: DIFlagArtificial | DIFlagObjectPointer)
!1336 = !DILocation(line: 0, scope: !1333)
!1337 = !DILocation(line: 375, column: 24, scope: !1338)
!1338 = distinct !DILexicalBlock(scope: !1333, file: !21, line: 374, column: 7)
!1339 = !DILocation(line: 376, column: 17, scope: !1338)
!1340 = !{!1257, !1258, i64 16}
!1341 = !DILocation(line: 376, column: 35, scope: !1338)
!1342 = !DILocation(line: 375, column: 2, scope: !1338)
!1343 = !DILocation(line: 377, column: 7, scope: !1333)
!1344 = distinct !DISubprogram(name: "_Destroy<int **>", linkageName: "_ZSt8_DestroyIPPiEvT_S2_", scope: !18, file: !1345, line: 219, type: !1346, scopeLine: 220, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !1351, retainedNodes: !1348)
!1345 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/stl_construct.h", directory: "", checksumkind: CSK_MD5, checksum: "f65ad579a9fde04c6c8620718aa6be84")
!1346 = !DISubroutineType(types: !1347)
!1347 = !{null, !47, !47}
!1348 = !{!1349, !1350}
!1349 = !DILocalVariable(name: "__first", arg: 1, scope: !1344, file: !1345, line: 219, type: !47)
!1350 = !DILocalVariable(name: "__last", arg: 2, scope: !1344, file: !1345, line: 219, type: !47)
!1351 = !{!1273}
!1352 = !DILocation(line: 0, scope: !1344)
!1353 = !DILocation(line: 236, column: 5, scope: !1344)
!1354 = distinct !DISubprogram(name: "_M_deallocate", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE13_M_deallocateEPS0_m", scope: !26, file: !21, line: 392, type: !235, scopeLine: 393, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !234, retainedNodes: !1355)
!1355 = !{!1356, !1357, !1358}
!1356 = !DILocalVariable(name: "this", arg: 1, scope: !1354, type: !1330, flags: DIFlagArtificial | DIFlagObjectPointer)
!1357 = !DILocalVariable(name: "__p", arg: 2, scope: !1354, file: !21, line: 392, type: !148)
!1358 = !DILocalVariable(name: "__n", arg: 3, scope: !1354, file: !21, line: 392, type: !16)
!1359 = !DILocation(line: 0, scope: !1354)
!1360 = !DILocation(line: 395, column: 6, scope: !1361)
!1361 = distinct !DILexicalBlock(scope: !1354, file: !21, line: 395, column: 6)
!1362 = !DILocalVariable(name: "__a", arg: 1, scope: !1363, file: !41, line: 648, type: !48)
!1363 = distinct !DISubprogram(name: "deallocate", linkageName: "_ZNSt16allocator_traitsISaIPiEE10deallocateERS1_PS0_m", scope: !40, file: !41, line: 648, type: !113, scopeLine: 649, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !112, retainedNodes: !1364)
!1364 = !{!1362, !1365, !1366}
!1365 = !DILocalVariable(name: "__p", arg: 2, scope: !1363, file: !41, line: 648, type: !46)
!1366 = !DILocalVariable(name: "__n", arg: 3, scope: !1363, file: !41, line: 648, type: !107)
!1367 = !DILocation(line: 0, scope: !1363, inlinedAt: !1368)
!1368 = distinct !DILocation(line: 396, column: 4, scope: !1361)
!1369 = !DILocalVariable(name: "this", arg: 1, scope: !1370, type: !1374, flags: DIFlagArtificial | DIFlagObjectPointer)
!1370 = distinct !DISubprogram(name: "deallocate", linkageName: "_ZNSaIPiE10deallocateEPS_m", scope: !50, file: !51, line: 208, type: !105, scopeLine: 209, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !104, retainedNodes: !1371)
!1371 = !{!1369, !1372, !1373}
!1372 = !DILocalVariable(name: "__p", arg: 2, scope: !1370, file: !51, line: 208, type: !47)
!1373 = !DILocalVariable(name: "__n", arg: 3, scope: !1370, file: !51, line: 208, type: !16)
!1374 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!1375 = !DILocation(line: 0, scope: !1370, inlinedAt: !1376)
!1376 = distinct !DILocation(line: 649, column: 13, scope: !1363, inlinedAt: !1368)
!1377 = !DILocation(line: 215, column: 25, scope: !1370, inlinedAt: !1376)
!1378 = !DILocation(line: 396, column: 4, scope: !1361)
!1379 = !DILocation(line: 397, column: 7, scope: !1354)
!1380 = distinct !DISubprogram(name: "deallocate", linkageName: "_ZNSt15__new_allocatorIPiE10deallocateEPS0_m", scope: !56, file: !57, line: 156, type: !79, scopeLine: 157, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !78, retainedNodes: !1381)
!1381 = !{!1382, !1384, !1385}
!1382 = !DILocalVariable(name: "this", arg: 1, scope: !1380, type: !1383, flags: DIFlagArtificial | DIFlagObjectPointer)
!1383 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!1384 = !DILocalVariable(name: "__p", arg: 2, scope: !1380, file: !57, line: 156, type: !47)
!1385 = !DILocalVariable(name: "__n", arg: 3, scope: !1380, file: !57, line: 156, type: !75)
!1386 = !DILocation(line: 0, scope: !1380)
!1387 = !DILocation(line: 172, column: 27, scope: !1380)
!1388 = !DILocation(line: 172, column: 2, scope: !1380)
!1389 = !DILocation(line: 173, column: 7, scope: !1380)
!1390 = distinct !DISubprogram(name: "test1_heap_escape", linkageName: "_ZL17test1_heap_escapev", scope: !3, file: !3, line: 98, type: !726, scopeLine: 98, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1391)
!1391 = !{!1392, !1393, !1395}
!1392 = !DILocalVariable(name: "shared", scope: !1390, file: !3, line: 100, type: !6)
!1393 = !DILocalVariable(name: "t", scope: !1390, file: !3, line: 102, type: !1394)
!1394 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !758, line: 27, baseType: !19)
!1395 = !DILocalVariable(name: "x", scope: !1390, file: !3, line: 106, type: !5)
!1396 = distinct !DIAssignID()
!1397 = !DILocation(line: 0, scope: !1390)
!1398 = !DILocation(line: 99, column: 5, scope: !1390)
!1399 = !DILocation(line: 100, column: 38, scope: !1390)
!1400 = !DILocation(line: 101, column: 19, scope: !1390)
!1401 = !{!1402, !1403, i64 0}
!1402 = !{!"_ZTS9SharedInt", !1403, i64 0}
!1403 = !{!"int", !1260, i64 0}
!1404 = !DILocation(line: 102, column: 5, scope: !1390)
!1405 = !DILocation(line: 103, column: 5, scope: !1390)
!1406 = !DILocation(line: 105, column: 5, scope: !1390)
!1407 = !DILocation(line: 108, column: 18, scope: !1390)
!1408 = !{!1409, !1409, i64 0}
!1409 = !{!"long", !1260, i64 0}
!1410 = !DILocation(line: 108, column: 5, scope: !1390)
!1411 = !DILocation(line: 109, column: 5, scope: !1390)
!1412 = !DILocation(line: 110, column: 5, scope: !1390)
!1413 = !DILocation(line: 111, column: 1, scope: !1390)
!1414 = distinct !DISubprogram(name: "test2_global", linkageName: "_ZL12test2_globalv", scope: !3, file: !3, line: 132, type: !726, scopeLine: 132, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1415)
!1415 = !{!1416, !1417, !1418}
!1416 = !DILocalVariable(name: "t", scope: !1414, file: !3, line: 135, type: !1394)
!1417 = !DILocalVariable(name: "x", scope: !1414, file: !3, line: 139, type: !5)
!1418 = !DILocalVariable(name: "y", scope: !1414, file: !3, line: 147, type: !5)
!1419 = distinct !DIAssignID()
!1420 = !DILocation(line: 0, scope: !1414)
!1421 = !DILocation(line: 133, column: 5, scope: !1414)
!1422 = !DILocation(line: 134, column: 14, scope: !1414)
!1423 = !{!1403, !1403, i64 0}
!1424 = !DILocation(line: 135, column: 5, scope: !1414)
!1425 = !DILocation(line: 137, column: 5, scope: !1414)
!1426 = !DILocation(line: 138, column: 5, scope: !1414)
!1427 = !DILocation(line: 139, column: 13, scope: !1414)
!1428 = !DILocation(line: 141, column: 18, scope: !1414)
!1429 = !DILocation(line: 141, column: 5, scope: !1414)
!1430 = !DILocation(line: 142, column: 5, scope: !1414)
!1431 = !DILocation(line: 145, column: 5, scope: !1414)
!1432 = !DILocation(line: 146, column: 5, scope: !1414)
!1433 = !DILocation(line: 147, column: 13, scope: !1414)
!1434 = !DILocation(line: 149, column: 5, scope: !1414)
!1435 = !DILocation(line: 150, column: 18, scope: !1414)
!1436 = !DILocation(line: 150, column: 5, scope: !1414)
!1437 = !DILocation(line: 151, column: 5, scope: !1414)
!1438 = !DILocation(line: 152, column: 1, scope: !1414)
!1439 = distinct !DISubprogram(name: "test3_stack_addr_in_struct", linkageName: "_ZL26test3_stack_addr_in_structv", scope: !3, file: !3, line: 169, type: !726, scopeLine: 169, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1440)
!1440 = !{!1441, !1442, !1443, !1444}
!1441 = !DILocalVariable(name: "local_val", scope: !1439, file: !3, line: 171, type: !5)
!1442 = !DILocalVariable(name: "args", scope: !1439, file: !3, line: 172, type: !11)
!1443 = !DILocalVariable(name: "t", scope: !1439, file: !3, line: 174, type: !1394)
!1444 = !DILocalVariable(name: "x", scope: !1439, file: !3, line: 177, type: !5)
!1445 = distinct !DIAssignID()
!1446 = !DILocation(line: 0, scope: !1439)
!1447 = distinct !DIAssignID()
!1448 = !DILocation(line: 170, column: 5, scope: !1439)
!1449 = !DILocation(line: 171, column: 5, scope: !1439)
!1450 = !DILocation(line: 171, column: 9, scope: !1439)
!1451 = distinct !DIAssignID()
!1452 = !DILocation(line: 172, column: 19, scope: !1439)
!1453 = !DILocation(line: 173, column: 15, scope: !1439)
!1454 = !{!1455, !1456, i64 0}
!1455 = !{!"_ZTS5Args3", !1456, i64 0}
!1456 = !{!"p1 int", !1259, i64 0}
!1457 = !DILocation(line: 174, column: 5, scope: !1439)
!1458 = !DILocation(line: 175, column: 5, scope: !1439)
!1459 = !DILocation(line: 176, column: 5, scope: !1439)
!1460 = !DILocation(line: 179, column: 18, scope: !1439)
!1461 = !DILocation(line: 179, column: 5, scope: !1439)
!1462 = !DILocation(line: 180, column: 5, scope: !1439)
!1463 = !DILocation(line: 181, column: 5, scope: !1439)
!1464 = !DILocation(line: 182, column: 1, scope: !1439)
!1465 = distinct !DISubprogram(name: "test4_stack_via_global_ptr", linkageName: "_ZL26test4_stack_via_global_ptrv", scope: !3, file: !3, line: 196, type: !726, scopeLine: 196, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1466)
!1466 = !{!1467, !1468, !1469}
!1467 = !DILocalVariable(name: "local", scope: !1465, file: !3, line: 198, type: !5)
!1468 = !DILocalVariable(name: "t", scope: !1465, file: !3, line: 200, type: !1394)
!1469 = !DILocalVariable(name: "x", scope: !1465, file: !3, line: 203, type: !5)
!1470 = distinct !DIAssignID()
!1471 = !DILocation(line: 0, scope: !1465)
!1472 = distinct !DIAssignID()
!1473 = !DILocation(line: 197, column: 5, scope: !1465)
!1474 = !DILocation(line: 198, column: 5, scope: !1465)
!1475 = !DILocation(line: 198, column: 9, scope: !1465)
!1476 = distinct !DIAssignID()
!1477 = !DILocation(line: 199, column: 17, scope: !1465)
!1478 = !{!1456, !1456, i64 0}
!1479 = !DILocation(line: 200, column: 5, scope: !1465)
!1480 = !DILocation(line: 201, column: 5, scope: !1465)
!1481 = !DILocation(line: 202, column: 5, scope: !1465)
!1482 = !DILocation(line: 205, column: 18, scope: !1465)
!1483 = !DILocation(line: 205, column: 5, scope: !1465)
!1484 = !DILocation(line: 206, column: 17, scope: !1465)
!1485 = !DILocation(line: 207, column: 5, scope: !1465)
!1486 = !DILocation(line: 208, column: 1, scope: !1465)
!1487 = distinct !DISubprogram(name: "test5_escape_via_vector", linkageName: "_ZL23test5_escape_via_vectorv", scope: !3, file: !3, line: 226, type: !726, scopeLine: 226, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1488)
!1488 = !{!1489, !1490, !1491}
!1489 = !DILocalVariable(name: "val", scope: !1487, file: !3, line: 228, type: !5)
!1490 = !DILocalVariable(name: "t", scope: !1487, file: !3, line: 233, type: !1394)
!1491 = !DILocalVariable(name: "x", scope: !1487, file: !3, line: 236, type: !5)
!1492 = distinct !DIAssignID()
!1493 = !DILocation(line: 0, scope: !1487)
!1494 = distinct !DIAssignID()
!1495 = !DILocation(line: 227, column: 5, scope: !1487)
!1496 = !DILocation(line: 228, column: 5, scope: !1487)
!1497 = !DILocation(line: 228, column: 9, scope: !1487)
!1498 = distinct !DIAssignID()
!1499 = !DILocation(line: 229, column: 5, scope: !1487)
!1500 = !DILocation(line: 230, column: 22, scope: !1487)
!1501 = !DILocation(line: 230, column: 12, scope: !1487)
!1502 = !DILocation(line: 230, column: 5, scope: !1487)
!1503 = !DILocation(line: 231, column: 5, scope: !1487)
!1504 = !DILocation(line: 233, column: 5, scope: !1487)
!1505 = !DILocation(line: 234, column: 5, scope: !1487)
!1506 = !DILocation(line: 235, column: 5, scope: !1487)
!1507 = !DILocation(line: 238, column: 18, scope: !1487)
!1508 = !DILocation(line: 238, column: 5, scope: !1487)
!1509 = !DILocation(line: 239, column: 12, scope: !1487)
!1510 = !DILocation(line: 240, column: 5, scope: !1487)
!1511 = !DILocation(line: 241, column: 1, scope: !1487)
!1512 = distinct !DISubprogram(name: "test6_double_indirection", linkageName: "_ZL24test6_double_indirectionv", scope: !3, file: !3, line: 254, type: !726, scopeLine: 254, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1513)
!1513 = !{!1514, !1515, !1516, !1517, !1518}
!1514 = !DILocalVariable(name: "val", scope: !1512, file: !3, line: 256, type: !5)
!1515 = !DILocalVariable(name: "p", scope: !1512, file: !3, line: 257, type: !15)
!1516 = !DILocalVariable(name: "pp", scope: !1512, file: !3, line: 258, type: !47)
!1517 = !DILocalVariable(name: "t", scope: !1512, file: !3, line: 259, type: !1394)
!1518 = !DILocalVariable(name: "x", scope: !1512, file: !3, line: 262, type: !5)
!1519 = distinct !DIAssignID()
!1520 = !DILocation(line: 0, scope: !1512)
!1521 = distinct !DIAssignID()
!1522 = distinct !DIAssignID()
!1523 = !DILocation(line: 255, column: 5, scope: !1512)
!1524 = !DILocation(line: 256, column: 5, scope: !1512)
!1525 = !DILocation(line: 256, column: 9, scope: !1512)
!1526 = distinct !DIAssignID()
!1527 = !DILocation(line: 257, column: 5, scope: !1512)
!1528 = !DILocation(line: 257, column: 10, scope: !1512)
!1529 = distinct !DIAssignID()
!1530 = !DILocation(line: 259, column: 5, scope: !1512)
!1531 = !DILocation(line: 260, column: 5, scope: !1512)
!1532 = !DILocation(line: 261, column: 5, scope: !1512)
!1533 = !DILocation(line: 264, column: 18, scope: !1512)
!1534 = !DILocation(line: 264, column: 5, scope: !1512)
!1535 = !DILocation(line: 265, column: 5, scope: !1512)
!1536 = !DILocation(line: 266, column: 1, scope: !1512)
!1537 = distinct !DISubprogram(name: "test7_disjoint_array_access", linkageName: "_ZL27test7_disjoint_array_accessv", scope: !3, file: !3, line: 284, type: !726, scopeLine: 284, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1538)
!1538 = !{!1539, !1540, !1544, !1546, !1548, !1550}
!1539 = !DILocalVariable(name: "N", scope: !1537, file: !3, line: 286, type: !650)
!1540 = !DILocalVariable(name: "arr", scope: !1537, file: !3, line: 287, type: !1541)
!1541 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 128, elements: !1542)
!1542 = !{!1543}
!1543 = !DISubrange(count: 4)
!1544 = !DILocalVariable(name: "threads", scope: !1537, file: !3, line: 289, type: !1545)
!1545 = !DICompositeType(tag: DW_TAG_array_type, baseType: !1394, size: 256, elements: !1542)
!1546 = !DILocalVariable(name: "args", scope: !1537, file: !3, line: 290, type: !1547)
!1547 = !DICompositeType(tag: DW_TAG_array_type, baseType: !621, size: 512, elements: !1542)
!1548 = !DILocalVariable(name: "i", scope: !1549, file: !3, line: 291, type: !5)
!1549 = distinct !DILexicalBlock(scope: !1537, file: !3, line: 291, column: 5)
!1550 = !DILocalVariable(name: "i", scope: !1551, file: !3, line: 296, type: !5)
!1551 = distinct !DILexicalBlock(scope: !1537, file: !3, line: 296, column: 5)
!1552 = distinct !DIAssignID()
!1553 = !DILocation(line: 0, scope: !1537)
!1554 = distinct !DIAssignID()
!1555 = distinct !DIAssignID()
!1556 = !DILocation(line: 285, column: 5, scope: !1537)
!1557 = !DILocation(line: 287, column: 5, scope: !1537)
!1558 = !DILocation(line: 288, column: 5, scope: !1537)
!1559 = !DILocation(line: 289, column: 5, scope: !1537)
!1560 = !DILocation(line: 290, column: 5, scope: !1537)
!1561 = !DILocation(line: 0, scope: !1549)
!1562 = !DILocation(line: 291, column: 5, scope: !1549)
!1563 = !DILocation(line: 292, column: 9, scope: !1564)
!1564 = distinct !DILexicalBlock(scope: !1565, file: !3, line: 291, column: 33)
!1565 = distinct !DILexicalBlock(scope: !1549, file: !3, line: 291, column: 5)
!1566 = !DILocation(line: 292, column: 21, scope: !1564)
!1567 = !{!1568, !1456, i64 0}
!1568 = !{!"_ZTS5Args7", !1456, i64 0, !1403, i64 8}
!1569 = !DILocation(line: 293, column: 17, scope: !1564)
!1570 = !DILocation(line: 293, column: 21, scope: !1564)
!1571 = !{!1568, !1403, i64 8}
!1572 = !DILocation(line: 294, column: 25, scope: !1564)
!1573 = !DILocation(line: 294, column: 9, scope: !1564)
!1574 = !DILocation(line: 291, column: 29, scope: !1565)
!1575 = !DILocation(line: 291, column: 23, scope: !1565)
!1576 = distinct !{!1576, !1562, !1577, !1321, !1322}
!1577 = !DILocation(line: 295, column: 5, scope: !1549)
!1578 = !DILocation(line: 297, column: 5, scope: !1537)
!1579 = !DILocation(line: 298, column: 1, scope: !1537)
!1580 = !DILocation(line: 0, scope: !1551)
!1581 = !DILocation(line: 296, column: 46, scope: !1582)
!1582 = distinct !DILexicalBlock(scope: !1551, file: !3, line: 296, column: 5)
!1583 = !DILocation(line: 296, column: 33, scope: !1582)
!1584 = !DILocation(line: 296, column: 29, scope: !1582)
!1585 = !DILocation(line: 296, column: 23, scope: !1582)
!1586 = !DILocation(line: 296, column: 5, scope: !1551)
!1587 = distinct !{!1587, !1586, !1588, !1321, !1322}
!1588 = !DILocation(line: 296, column: 65, scope: !1551)
!1589 = distinct !DISubprogram(name: "test8_overlapping_array", linkageName: "_ZL23test8_overlapping_arrayv", scope: !3, file: !3, line: 316, type: !726, scopeLine: 316, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1590)
!1590 = !{!1591, !1592, !1593, !1594}
!1591 = !DILocalVariable(name: "arr", scope: !1589, file: !3, line: 318, type: !1541)
!1592 = !DILocalVariable(name: "a", scope: !1589, file: !3, line: 319, type: !626)
!1593 = !DILocalVariable(name: "t1", scope: !1589, file: !3, line: 320, type: !1394)
!1594 = !DILocalVariable(name: "t2", scope: !1589, file: !3, line: 320, type: !1394)
!1595 = distinct !DIAssignID()
!1596 = !DILocation(line: 0, scope: !1589)
!1597 = distinct !DIAssignID()
!1598 = distinct !DIAssignID()
!1599 = distinct !DIAssignID()
!1600 = !DILocation(line: 317, column: 5, scope: !1589)
!1601 = !DILocation(line: 318, column: 5, scope: !1589)
!1602 = !DILocation(line: 318, column: 9, scope: !1589)
!1603 = distinct !DIAssignID()
!1604 = !DILocation(line: 319, column: 5, scope: !1589)
!1605 = !DILocation(line: 319, column: 15, scope: !1589)
!1606 = !{!1607, !1456, i64 0}
!1607 = !{!"_ZTS5Args8", !1456, i64 0}
!1608 = distinct !DIAssignID()
!1609 = !DILocation(line: 320, column: 5, scope: !1589)
!1610 = !DILocation(line: 321, column: 5, scope: !1589)
!1611 = !DILocation(line: 322, column: 5, scope: !1589)
!1612 = !DILocation(line: 323, column: 18, scope: !1589)
!1613 = !DILocation(line: 323, column: 5, scope: !1589)
!1614 = !DILocation(line: 324, column: 18, scope: !1589)
!1615 = !DILocation(line: 324, column: 5, scope: !1589)
!1616 = !DILocation(line: 325, column: 5, scope: !1589)
!1617 = !DILocation(line: 326, column: 1, scope: !1589)
!1618 = distinct !DISubprogram(name: "test9_pointer_arithmetic_escape", linkageName: "_ZL31test9_pointer_arithmetic_escapev", scope: !3, file: !3, line: 342, type: !726, scopeLine: 342, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1619)
!1619 = !{!1620, !1624, !1625}
!1620 = !DILocalVariable(name: "arr", scope: !1618, file: !3, line: 344, type: !1621)
!1621 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 192, elements: !1622)
!1622 = !{!1623}
!1623 = !DISubrange(count: 6)
!1624 = !DILocalVariable(name: "t", scope: !1618, file: !3, line: 345, type: !1394)
!1625 = !DILocalVariable(name: "x", scope: !1618, file: !3, line: 348, type: !5)
!1626 = distinct !DIAssignID()
!1627 = !DILocation(line: 0, scope: !1618)
!1628 = distinct !DIAssignID()
!1629 = !DILocation(line: 343, column: 5, scope: !1618)
!1630 = !DILocation(line: 344, column: 5, scope: !1618)
!1631 = !DILocation(line: 344, column: 9, scope: !1618)
!1632 = distinct !DIAssignID()
!1633 = !DILocation(line: 345, column: 5, scope: !1618)
!1634 = !DILocation(line: 346, column: 43, scope: !1618)
!1635 = !DILocation(line: 346, column: 5, scope: !1618)
!1636 = !DILocation(line: 347, column: 5, scope: !1618)
!1637 = !DILocation(line: 350, column: 18, scope: !1618)
!1638 = !DILocation(line: 350, column: 5, scope: !1618)
!1639 = !DILocation(line: 351, column: 5, scope: !1618)
!1640 = !DILocation(line: 352, column: 1, scope: !1618)
!1641 = distinct !DISubprogram(name: "test10_thread_local", linkageName: "_ZL19test10_thread_localv", scope: !3, file: !3, line: 371, type: !726, scopeLine: 371, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1642)
!1642 = !{!1643, !1644, !1645, !1647}
!1643 = !DILocalVariable(name: "N", scope: !1641, file: !3, line: 373, type: !650)
!1644 = !DILocalVariable(name: "threads", scope: !1641, file: !3, line: 374, type: !1545)
!1645 = !DILocalVariable(name: "i", scope: !1646, file: !3, line: 375, type: !5)
!1646 = distinct !DILexicalBlock(scope: !1641, file: !3, line: 375, column: 5)
!1647 = !DILocalVariable(name: "i", scope: !1648, file: !3, line: 376, type: !5)
!1648 = distinct !DILexicalBlock(scope: !1641, file: !3, line: 376, column: 5)
!1649 = distinct !DIAssignID()
!1650 = !DILocation(line: 0, scope: !1641)
!1651 = !DILocation(line: 372, column: 5, scope: !1641)
!1652 = !DILocation(line: 374, column: 5, scope: !1641)
!1653 = !DILocation(line: 0, scope: !1646)
!1654 = !DILocation(line: 375, column: 5, scope: !1646)
!1655 = !DILocation(line: 375, column: 49, scope: !1656)
!1656 = distinct !DILexicalBlock(scope: !1646, file: !3, line: 375, column: 5)
!1657 = !DILocation(line: 375, column: 33, scope: !1656)
!1658 = !DILocation(line: 375, column: 29, scope: !1656)
!1659 = !DILocation(line: 375, column: 23, scope: !1656)
!1660 = distinct !{!1660, !1654, !1661, !1321, !1322}
!1661 = !DILocation(line: 375, column: 87, scope: !1646)
!1662 = !DILocation(line: 377, column: 5, scope: !1641)
!1663 = !DILocation(line: 378, column: 1, scope: !1641)
!1664 = !DILocation(line: 0, scope: !1648)
!1665 = !DILocation(line: 376, column: 46, scope: !1666)
!1666 = distinct !DILexicalBlock(scope: !1648, file: !3, line: 376, column: 5)
!1667 = !DILocation(line: 376, column: 33, scope: !1666)
!1668 = !DILocation(line: 376, column: 29, scope: !1666)
!1669 = !DILocation(line: 376, column: 23, scope: !1666)
!1670 = !DILocation(line: 376, column: 5, scope: !1648)
!1671 = distinct !{!1671, !1670, !1672, !1321, !1322}
!1672 = !DILocation(line: 376, column: 65, scope: !1648)
!1673 = distinct !DISubprogram(name: "test11_private_heap", linkageName: "_ZL19test11_private_heapv", scope: !3, file: !3, line: 398, type: !726, scopeLine: 398, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1674)
!1674 = !{!1675, !1676, !1677, !1679}
!1675 = !DILocalVariable(name: "N", scope: !1673, file: !3, line: 400, type: !650)
!1676 = !DILocalVariable(name: "threads", scope: !1673, file: !3, line: 401, type: !1545)
!1677 = !DILocalVariable(name: "i", scope: !1678, file: !3, line: 402, type: !5)
!1678 = distinct !DILexicalBlock(scope: !1673, file: !3, line: 402, column: 5)
!1679 = !DILocalVariable(name: "i", scope: !1680, file: !3, line: 403, type: !5)
!1680 = distinct !DILexicalBlock(scope: !1673, file: !3, line: 403, column: 5)
!1681 = distinct !DIAssignID()
!1682 = !DILocation(line: 0, scope: !1673)
!1683 = !DILocation(line: 399, column: 5, scope: !1673)
!1684 = !DILocation(line: 401, column: 5, scope: !1673)
!1685 = !DILocation(line: 0, scope: !1678)
!1686 = !DILocation(line: 402, column: 5, scope: !1678)
!1687 = !DILocation(line: 402, column: 49, scope: !1688)
!1688 = distinct !DILexicalBlock(scope: !1678, file: !3, line: 402, column: 5)
!1689 = !DILocation(line: 402, column: 33, scope: !1688)
!1690 = !DILocation(line: 402, column: 29, scope: !1688)
!1691 = !DILocation(line: 402, column: 23, scope: !1688)
!1692 = distinct !{!1692, !1686, !1693, !1321, !1322}
!1693 = !DILocation(line: 402, column: 87, scope: !1678)
!1694 = !DILocation(line: 404, column: 5, scope: !1673)
!1695 = !DILocation(line: 405, column: 1, scope: !1673)
!1696 = !DILocation(line: 0, scope: !1680)
!1697 = !DILocation(line: 403, column: 46, scope: !1698)
!1698 = distinct !DILexicalBlock(scope: !1680, file: !3, line: 403, column: 5)
!1699 = !DILocation(line: 403, column: 33, scope: !1698)
!1700 = !DILocation(line: 403, column: 29, scope: !1698)
!1701 = !DILocation(line: 403, column: 23, scope: !1698)
!1702 = !DILocation(line: 403, column: 5, scope: !1680)
!1703 = distinct !{!1703, !1702, !1704, !1321, !1322}
!1704 = !DILocation(line: 403, column: 65, scope: !1680)
!1705 = distinct !DISubprogram(name: "test12_nested_struct_escape", linkageName: "_ZL27test12_nested_struct_escapev", scope: !3, file: !3, line: 424, type: !726, scopeLine: 424, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1706)
!1706 = !{!1707, !1708, !1709}
!1707 = !DILocalVariable(name: "obj", scope: !1705, file: !3, line: 426, type: !630)
!1708 = !DILocalVariable(name: "t", scope: !1705, file: !3, line: 427, type: !1394)
!1709 = !DILocalVariable(name: "x", scope: !1705, file: !3, line: 430, type: !5)
!1710 = distinct !DIAssignID()
!1711 = !DILocation(line: 0, scope: !1705)
!1712 = distinct !DIAssignID()
!1713 = !DILocation(line: 425, column: 5, scope: !1705)
!1714 = !DILocation(line: 426, column: 5, scope: !1705)
!1715 = !DILocation(line: 426, column: 13, scope: !1705)
!1716 = distinct !DIAssignID()
!1717 = !DILocation(line: 427, column: 5, scope: !1705)
!1718 = !DILocation(line: 428, column: 5, scope: !1705)
!1719 = !DILocation(line: 429, column: 5, scope: !1705)
!1720 = !DILocation(line: 432, column: 18, scope: !1705)
!1721 = !DILocation(line: 432, column: 5, scope: !1705)
!1722 = !DILocation(line: 433, column: 5, scope: !1705)
!1723 = !DILocation(line: 434, column: 1, scope: !1705)
!1724 = distinct !DISubprogram(name: "test13_escape_via_memcpy", linkageName: "_ZL24test13_escape_via_memcpyv", scope: !3, file: !3, line: 452, type: !726, scopeLine: 452, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1725)
!1725 = !{!1726, !1727, !1728, !1729, !1730}
!1726 = !DILocalVariable(name: "val", scope: !1724, file: !3, line: 454, type: !5)
!1727 = !DILocalVariable(name: "args", scope: !1724, file: !3, line: 455, type: !641)
!1728 = !DILocalVariable(name: "addr", scope: !1724, file: !3, line: 456, type: !638)
!1729 = !DILocalVariable(name: "t", scope: !1724, file: !3, line: 458, type: !1394)
!1730 = !DILocalVariable(name: "x", scope: !1724, file: !3, line: 461, type: !5)
!1731 = distinct !DIAssignID()
!1732 = !DILocation(line: 0, scope: !1724)
!1733 = distinct !DIAssignID()
!1734 = distinct !DIAssignID()
!1735 = distinct !DIAssignID()
!1736 = !DILocation(line: 453, column: 5, scope: !1724)
!1737 = !DILocation(line: 454, column: 5, scope: !1724)
!1738 = !DILocation(line: 454, column: 9, scope: !1724)
!1739 = distinct !DIAssignID()
!1740 = !DILocation(line: 455, column: 5, scope: !1724)
!1741 = !DILocation(line: 456, column: 5, scope: !1724)
!1742 = !DILocation(line: 456, column: 22, scope: !1724)
!1743 = !DILocation(line: 456, column: 15, scope: !1724)
!1744 = distinct !DIAssignID()
!1745 = !DILocation(line: 457, column: 5, scope: !1724)
!1746 = !DILocation(line: 458, column: 5, scope: !1724)
!1747 = !DILocation(line: 459, column: 5, scope: !1724)
!1748 = !DILocation(line: 460, column: 5, scope: !1724)
!1749 = !DILocation(line: 463, column: 18, scope: !1724)
!1750 = !DILocation(line: 463, column: 5, scope: !1724)
!1751 = !DILocation(line: 464, column: 5, scope: !1724)
!1752 = !DILocation(line: 465, column: 1, scope: !1724)
!1753 = distinct !DISubprogram(name: "test14_readonly_shared", linkageName: "_ZL22test14_readonly_sharedv", scope: !3, file: !3, line: 483, type: !726, scopeLine: 483, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1754)
!1754 = !{!1755, !1756, !1757, !1758, !1760}
!1755 = !DILocalVariable(name: "ro", scope: !1753, file: !3, line: 485, type: !646)
!1756 = !DILocalVariable(name: "N", scope: !1753, file: !3, line: 486, type: !650)
!1757 = !DILocalVariable(name: "threads", scope: !1753, file: !3, line: 487, type: !1545)
!1758 = !DILocalVariable(name: "i", scope: !1759, file: !3, line: 488, type: !5)
!1759 = distinct !DILexicalBlock(scope: !1753, file: !3, line: 488, column: 5)
!1760 = !DILocalVariable(name: "i", scope: !1761, file: !3, line: 489, type: !5)
!1761 = distinct !DILexicalBlock(scope: !1753, file: !3, line: 489, column: 5)
!1762 = distinct !DIAssignID()
!1763 = !DILocation(line: 0, scope: !1753)
!1764 = distinct !DIAssignID()
!1765 = !DILocation(line: 484, column: 5, scope: !1753)
!1766 = !DILocation(line: 485, column: 5, scope: !1753)
!1767 = !DILocation(line: 485, column: 16, scope: !1753)
!1768 = distinct !DIAssignID()
!1769 = !DILocation(line: 487, column: 5, scope: !1753)
!1770 = !DILocation(line: 0, scope: !1759)
!1771 = !DILocation(line: 488, column: 5, scope: !1759)
!1772 = !DILocation(line: 488, column: 49, scope: !1773)
!1773 = distinct !DILexicalBlock(scope: !1759, file: !3, line: 488, column: 5)
!1774 = !DILocation(line: 488, column: 33, scope: !1773)
!1775 = !DILocation(line: 488, column: 29, scope: !1773)
!1776 = !DILocation(line: 488, column: 23, scope: !1773)
!1777 = distinct !{!1777, !1771, !1778, !1321, !1322}
!1778 = !DILocation(line: 488, column: 83, scope: !1759)
!1779 = !DILocation(line: 490, column: 5, scope: !1753)
!1780 = !DILocation(line: 491, column: 1, scope: !1753)
!1781 = !DILocation(line: 0, scope: !1761)
!1782 = !DILocation(line: 489, column: 46, scope: !1783)
!1783 = distinct !DILexicalBlock(scope: !1761, file: !3, line: 489, column: 5)
!1784 = !DILocation(line: 489, column: 33, scope: !1783)
!1785 = !DILocation(line: 489, column: 29, scope: !1783)
!1786 = !DILocation(line: 489, column: 23, scope: !1783)
!1787 = !DILocation(line: 489, column: 5, scope: !1761)
!1788 = distinct !{!1788, !1787, !1789, !1321, !1322}
!1789 = !DILocation(line: 489, column: 65, scope: !1761)
!1790 = distinct !DISubprogram(name: "test15_function_pointer_escape", linkageName: "_ZL30test15_function_pointer_escapev", scope: !3, file: !3, line: 514, type: !726, scopeLine: 514, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1791)
!1791 = !{!1792, !1793, !1794, !1795}
!1792 = !DILocalVariable(name: "local", scope: !1790, file: !3, line: 516, type: !5)
!1793 = !DILocalVariable(name: "cb", scope: !1790, file: !3, line: 517, type: !654)
!1794 = !DILocalVariable(name: "t", scope: !1790, file: !3, line: 518, type: !1394)
!1795 = !DILocalVariable(name: "x", scope: !1790, file: !3, line: 521, type: !5)
!1796 = distinct !DIAssignID()
!1797 = !DILocation(line: 0, scope: !1790)
!1798 = distinct !DIAssignID()
!1799 = distinct !DIAssignID()
!1800 = !DILocation(line: 515, column: 5, scope: !1790)
!1801 = !DILocation(line: 516, column: 5, scope: !1790)
!1802 = !DILocation(line: 516, column: 9, scope: !1790)
!1803 = distinct !DIAssignID()
!1804 = !DILocation(line: 517, column: 5, scope: !1790)
!1805 = !DILocation(line: 517, column: 15, scope: !1790)
!1806 = !{!1807, !1259, i64 0}
!1807 = !{!"_ZTS4CB15", !1259, i64 0, !1259, i64 8}
!1808 = distinct !DIAssignID()
!1809 = !{!1807, !1259, i64 8}
!1810 = distinct !DIAssignID()
!1811 = !DILocation(line: 518, column: 5, scope: !1790)
!1812 = !DILocation(line: 519, column: 5, scope: !1790)
!1813 = !DILocation(line: 520, column: 5, scope: !1790)
!1814 = !DILocation(line: 523, column: 18, scope: !1790)
!1815 = !DILocation(line: 523, column: 5, scope: !1790)
!1816 = !DILocation(line: 524, column: 5, scope: !1790)
!1817 = !DILocation(line: 525, column: 1, scope: !1790)
!1818 = !DISubprogram(name: "pthread_create", scope: !1819, file: !1819, line: 202, type: !1820, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1819 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "6e3fd55f44fd51456665b56ba786ebd8")
!1820 = !DISubroutineType(types: !1821)
!1821 = !{!5, !1822, !1824, !1829, !1832}
!1822 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1823)
!1823 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1394, size: 64)
!1824 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1825)
!1825 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1826, size: 64)
!1826 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1827)
!1827 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !758, line: 62, baseType: !1828)
!1828 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !758, line: 56, size: 448, flags: DIFlagFwdDecl, identifier: "_ZTS14pthread_attr_t")
!1829 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1830, size: 64)
!1830 = !DISubroutineType(types: !1831)
!1831 = !{!660, !660}
!1832 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !660)
!1833 = distinct !DISubprogram(name: "worker1_writer", linkageName: "_ZL14worker1_writerPv", scope: !3, file: !3, line: 92, type: !1830, scopeLine: 92, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1834)
!1834 = !{!1835, !1836}
!1835 = !DILocalVariable(name: "arg", arg: 1, scope: !1833, file: !3, line: 92, type: !660)
!1836 = !DILocalVariable(name: "s", scope: !1833, file: !3, line: 94, type: !6)
!1837 = !DILocation(line: 0, scope: !1833)
!1838 = !DILocation(line: 95, column: 14, scope: !1833)
!1839 = !DILocation(line: 96, column: 5, scope: !1833)
!1840 = distinct !DISubprogram(name: "busy_wait_ms", linkageName: "_ZL12busy_wait_msi", scope: !3, file: !3, line: 67, type: !1841, scopeLine: 67, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1842)
!1841 = !DISubroutineType(cc: DW_CC_nocall, types: !975)
!1842 = !{!1843, !1844}
!1843 = !DILocalVariable(name: "ms", arg: 1, scope: !1840, file: !3, line: 67, type: !5)
!1844 = !DILocalVariable(name: "ts", scope: !1840, file: !3, line: 68, type: !1845)
!1845 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !1846, line: 11, size: 128, flags: DIFlagTypePassByValue, elements: !1847, identifier: "_ZTS8timespec")
!1846 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "9378e9ebbd658baccf881d3300eb1828")
!1847 = !{!1848, !1850}
!1848 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !1845, file: !1846, line: 16, baseType: !1849, size: 64)
!1849 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !1161, line: 160, baseType: !10)
!1850 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !1845, file: !1846, line: 21, baseType: !1851, size: 64, offset: 64)
!1851 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !1161, line: 197, baseType: !10)
!1852 = distinct !DIAssignID()
!1853 = !DILocation(line: 0, scope: !1840)
!1854 = !DILocation(line: 68, column: 5, scope: !1840)
!1855 = !DILocation(line: 68, column: 26, scope: !1840)
!1856 = !{!1857, !1409, i64 0}
!1857 = !{!"_ZTS8timespec", !1409, i64 0, !1409, i64 8}
!1858 = distinct !DIAssignID()
!1859 = !{!1857, !1409, i64 8}
!1860 = distinct !DIAssignID()
!1861 = !DILocation(line: 69, column: 5, scope: !1840)
!1862 = !DILocation(line: 70, column: 1, scope: !1840)
!1863 = !DISubprogram(name: "pthread_join", scope: !1819, file: !1819, line: 219, type: !1864, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1864 = !DISubroutineType(types: !1865)
!1865 = !{!5, !1394, !1866}
!1866 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !660, size: 64)
!1867 = !DISubprogram(name: "nanosleep", scope: !1868, file: !1868, line: 281, type: !1869, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1868 = !DIFile(filename: "/usr/include/time.h", directory: "", checksumkind: CSK_MD5, checksum: "3ef5cd00638ddc7c5c68875f9c70f463")
!1869 = !DISubroutineType(types: !1870)
!1870 = !{!5, !1871, !1873}
!1871 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1872, size: 64)
!1872 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1845)
!1873 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1845, size: 64)
!1874 = distinct !DISubprogram(name: "worker2_race", linkageName: "_ZL12worker2_racePv", scope: !3, file: !3, line: 122, type: !1830, scopeLine: 122, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1875)
!1875 = !{!1876}
!1876 = !DILocalVariable(arg: 1, scope: !1874, file: !3, line: 122, type: !660)
!1877 = !DILocation(line: 0, scope: !1874)
!1878 = !DILocation(line: 123, column: 14, scope: !1874)
!1879 = !DILocation(line: 124, column: 5, scope: !1874)
!1880 = distinct !DISubprogram(name: "worker2_safe", linkageName: "_ZL12worker2_safePv", scope: !3, file: !3, line: 126, type: !1830, scopeLine: 126, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1881)
!1881 = !{!1882}
!1882 = !DILocalVariable(arg: 1, scope: !1880, file: !3, line: 126, type: !660)
!1883 = !DILocation(line: 0, scope: !1880)
!1884 = !DILocation(line: 127, column: 5, scope: !1880)
!1885 = !DILocation(line: 128, column: 14, scope: !1880)
!1886 = !DILocation(line: 129, column: 5, scope: !1880)
!1887 = !DILocation(line: 130, column: 5, scope: !1880)
!1888 = !DISubprogram(name: "pthread_mutex_lock", scope: !1819, file: !1819, line: 794, type: !1889, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1889 = !DISubroutineType(types: !1890)
!1890 = !{!5, !1891}
!1891 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !757, size: 64)
!1892 = !DISubprogram(name: "pthread_mutex_unlock", scope: !1819, file: !1819, line: 835, type: !1889, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1893 = distinct !DISubprogram(name: "worker3", linkageName: "_ZL7worker3Pv", scope: !3, file: !3, line: 164, type: !1830, scopeLine: 164, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1894)
!1894 = !{!1895, !1896}
!1895 = !DILocalVariable(name: "arg", arg: 1, scope: !1893, file: !3, line: 164, type: !660)
!1896 = !DILocalVariable(name: "a", scope: !1893, file: !3, line: 165, type: !11)
!1897 = !DILocation(line: 0, scope: !1893)
!1898 = !DILocation(line: 166, column: 9, scope: !1893)
!1899 = !DILocation(line: 166, column: 13, scope: !1893)
!1900 = !DILocation(line: 167, column: 5, scope: !1893)
!1901 = distinct !DISubprogram(name: "worker4", linkageName: "_ZL7worker4Pv", scope: !3, file: !3, line: 192, type: !1830, scopeLine: 192, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1902)
!1902 = !{!1903}
!1903 = !DILocalVariable(arg: 1, scope: !1901, file: !3, line: 192, type: !660)
!1904 = !DILocation(line: 0, scope: !1901)
!1905 = !DILocation(line: 193, column: 9, scope: !1906)
!1906 = distinct !DILexicalBlock(scope: !1901, file: !3, line: 193, column: 9)
!1907 = !DILocation(line: 193, column: 35, scope: !1906)
!1908 = !DILocation(line: 193, column: 22, scope: !1906)
!1909 = !DILocation(line: 194, column: 5, scope: !1901)
!1910 = distinct !DISubprogram(name: "push_back", linkageName: "_ZNSt6vectorIPiSaIS0_EE9push_backEOS0_", scope: !23, file: !21, line: 1433, type: !496, scopeLine: 1434, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !495, retainedNodes: !1911)
!1911 = !{!1912, !1913}
!1912 = !DILocalVariable(name: "this", arg: 1, scope: !1910, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!1913 = !DILocalVariable(name: "__x", arg: 2, scope: !1910, file: !21, line: 1433, type: !498)
!1914 = !DILocation(line: 0, scope: !1910)
!1915 = !DILocation(line: 1434, column: 9, scope: !1910)
!1916 = !DILocation(line: 1434, column: 39, scope: !1910)
!1917 = distinct !DISubprogram(name: "worker5", linkageName: "_ZL7worker5Pv", scope: !3, file: !3, line: 219, type: !1830, scopeLine: 219, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1918)
!1918 = !{!1919, !1920}
!1919 = !DILocalVariable(arg: 1, scope: !1917, file: !3, line: 219, type: !660)
!1920 = !DILocalVariable(name: "p", scope: !1917, file: !3, line: 221, type: !15)
!1921 = !DILocation(line: 0, scope: !1917)
!1922 = !DILocation(line: 220, column: 5, scope: !1917)
!1923 = !DILocation(line: 221, column: 21, scope: !1917)
!1924 = !DILocation(line: 221, column: 14, scope: !1917)
!1925 = !DILocation(line: 221, column: 41, scope: !1917)
!1926 = !DILocation(line: 222, column: 5, scope: !1917)
!1927 = !DILocation(line: 223, column: 9, scope: !1928)
!1928 = distinct !DILexicalBlock(scope: !1917, file: !3, line: 223, column: 9)
!1929 = !DILocation(line: 223, column: 15, scope: !1928)
!1930 = !DILocation(line: 223, column: 12, scope: !1928)
!1931 = !DILocation(line: 224, column: 5, scope: !1917)
!1932 = distinct !DISubprogram(name: "clear", linkageName: "_ZNSt6vectorIPiSaIS0_EE5clearEv", scope: !23, file: !21, line: 1863, type: !290, scopeLine: 1864, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !521, retainedNodes: !1933)
!1933 = !{!1934}
!1934 = !DILocalVariable(name: "this", arg: 1, scope: !1932, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!1935 = !DILocation(line: 0, scope: !1932)
!1936 = !DILocation(line: 1864, column: 39, scope: !1932)
!1937 = !DILocation(line: 1864, column: 9, scope: !1932)
!1938 = !DILocation(line: 1864, column: 50, scope: !1932)
!1939 = distinct !DISubprogram(name: "emplace_back<int *>", linkageName: "_ZNSt6vectorIPiSaIS0_EE12emplace_backIJS0_EEERS0_DpOT_", scope: !23, file: !820, line: 112, type: !1940, scopeLine: 113, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !1944, declaration: !1943, retainedNodes: !1948)
!1940 = !DISubroutineType(types: !1941)
!1941 = !{!461, !292, !1942}
!1942 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !15, size: 64)
!1943 = !DISubprogram(name: "emplace_back<int *>", linkageName: "_ZNSt6vectorIPiSaIS0_EE12emplace_backIJS0_EEERS0_DpOT_", scope: !23, file: !820, line: 112, type: !1940, scopeLine: 112, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized, templateParams: !1944)
!1944 = !{!1945}
!1945 = !DITemplateValueParameter(tag: DW_TAG_GNU_template_parameter_pack, name: "_Args", value: !1946)
!1946 = !{!1947}
!1947 = !DITemplateTypeParameter(type: !15)
!1948 = !{!1949, !1950}
!1949 = !DILocalVariable(name: "this", arg: 1, scope: !1939, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!1950 = !DILocalVariable(name: "__args", arg: 2, scope: !1939, file: !21, line: 1443, type: !1942)
!1951 = !DILocation(line: 0, scope: !1939)
!1952 = !DILocation(line: 114, column: 20, scope: !1953)
!1953 = distinct !DILexicalBlock(scope: !1939, file: !820, line: 114, column: 6)
!1954 = !DILocation(line: 114, column: 47, scope: !1953)
!1955 = !DILocation(line: 114, column: 30, scope: !1953)
!1956 = !DILocalVariable(name: "__a", arg: 1, scope: !1957, file: !41, line: 665, type: !48)
!1957 = distinct !DISubprogram(name: "construct<int *, int *>", linkageName: "_ZNSt16allocator_traitsISaIPiEE9constructIS0_JS0_EEEvRS1_PT_DpOT0_", scope: !40, file: !41, line: 665, type: !1958, scopeLine: 672, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !1961, declaration: !1960, retainedNodes: !1963)
!1958 = !DISubroutineType(types: !1959)
!1959 = !{null, !48, !47, !1942}
!1960 = !DISubprogram(name: "construct<int *, int *>", linkageName: "_ZNSt16allocator_traitsISaIPiEE9constructIS0_JS0_EEEvRS1_PT_DpOT0_", scope: !40, file: !41, line: 665, type: !1958, scopeLine: 665, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: DISPFlagOptimized, templateParams: !1961)
!1961 = !{!1962, !1945}
!1962 = !DITemplateTypeParameter(name: "_Up", type: !15)
!1963 = !{!1956, !1964, !1965}
!1964 = !DILocalVariable(name: "__p", arg: 2, scope: !1957, file: !41, line: 666, type: !47)
!1965 = !DILocalVariable(name: "__args", arg: 3, scope: !1957, file: !41, line: 666, type: !1942)
!1966 = !DILocation(line: 0, scope: !1957, inlinedAt: !1967)
!1967 = distinct !DILocation(line: 117, column: 6, scope: !1968)
!1968 = distinct !DILexicalBlock(scope: !1953, file: !820, line: 115, column: 4)
!1969 = !DILocation(line: 676, column: 4, scope: !1957, inlinedAt: !1967)
!1970 = !DILocation(line: 119, column: 6, scope: !1968)
!1971 = !DILocation(line: 121, column: 4, scope: !1968)
!1972 = !DILocation(line: 123, column: 4, scope: !1953)
!1973 = !DILocation(line: 125, column: 9, scope: !1939)
!1974 = !DILocation(line: 125, column: 2, scope: !1939)
!1975 = distinct !DISubprogram(name: "_M_realloc_append<int *>", linkageName: "_ZNSt6vectorIPiSaIS0_EE17_M_realloc_appendIJS0_EEEvDpOT_", scope: !23, file: !820, line: 558, type: !1976, scopeLine: 565, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !1944, declaration: !1978, retainedNodes: !1979)
!1976 = !DISubroutineType(types: !1977)
!1977 = !{null, !292, !1942}
!1978 = !DISubprogram(name: "_M_realloc_append<int *>", linkageName: "_ZNSt6vectorIPiSaIS0_EE17_M_realloc_appendIJS0_EEEvDpOT_", scope: !23, file: !820, line: 558, type: !1976, scopeLine: 558, flags: DIFlagProtected | DIFlagPrototyped, spFlags: DISPFlagOptimized, templateParams: !1944)
!1979 = !{!1980, !1981, !1982, !1984, !1985, !1986, !1987, !1988, !1989}
!1980 = !DILocalVariable(name: "this", arg: 1, scope: !1975, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!1981 = !DILocalVariable(name: "__args", arg: 2, scope: !1975, file: !21, line: 2174, type: !1942)
!1982 = !DILocalVariable(name: "__len", scope: !1975, file: !820, line: 566, type: !1983)
!1983 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!1984 = !DILocalVariable(name: "__old_start", scope: !1975, file: !820, line: 569, type: !280)
!1985 = !DILocalVariable(name: "__old_finish", scope: !1975, file: !820, line: 570, type: !280)
!1986 = !DILocalVariable(name: "__elems", scope: !1975, file: !820, line: 571, type: !1983)
!1987 = !DILocalVariable(name: "__new_start", scope: !1975, file: !820, line: 572, type: !280)
!1988 = !DILocalVariable(name: "__new_finish", scope: !1975, file: !820, line: 573, type: !280)
!1989 = !DILocalVariable(name: "__guard", scope: !1990, file: !820, line: 576, type: !662)
!1990 = distinct !DILexicalBlock(scope: !1975, file: !820, line: 575, column: 7)
!1991 = !DILocalVariable(name: "__lhs", arg: 1, scope: !1992, file: !366, line: 1337, type: !1995)
!1992 = distinct !DISubprogram(name: "operator-<int **, std::vector<int *, std::allocator<int *> > >", linkageName: "_ZN9__gnu_cxxmiIPPiSt6vectorIS1_SaIS1_EEEENS_17__normal_iteratorIT_T0_E15difference_typeERKS9_SC_", scope: !37, file: !366, line: 1337, type: !1993, scopeLine: 1340, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !619, retainedNodes: !1996)
!1993 = !DISubroutineType(types: !1994)
!1994 = !{!606, !1995, !1995}
!1995 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !588, size: 64)
!1996 = !{!1991, !1997}
!1997 = !DILocalVariable(name: "__rhs", arg: 2, scope: !1992, file: !366, line: 1338, type: !1995)
!1998 = !DILocation(line: 0, scope: !1992, inlinedAt: !1999)
!1999 = distinct !DILocation(line: 571, column: 39, scope: !1975)
!2000 = distinct !DIAssignID()
!2001 = !DILocation(line: 0, scope: !1990)
!2002 = !DILocation(line: 0, scope: !1975)
!2003 = !DILocation(line: 566, column: 31, scope: !1975)
!2004 = !DILocation(line: 567, column: 17, scope: !2005)
!2005 = distinct !DILexicalBlock(scope: !1975, file: !820, line: 567, column: 11)
!2006 = !DILocation(line: 569, column: 43, scope: !1975)
!2007 = !DILocation(line: 570, column: 44, scope: !1975)
!2008 = !DILocation(line: 571, column: 33, scope: !1975)
!2009 = !DILocation(line: 571, column: 41, scope: !1975)
!2010 = !DILocation(line: 1340, column: 27, scope: !1992, inlinedAt: !1999)
!2011 = !DILocation(line: 572, column: 33, scope: !1975)
!2012 = !DILocation(line: 576, column: 2, scope: !1990)
!2013 = !DILocation(line: 576, column: 15, scope: !1990)
!2014 = !DILocation(line: 587, column: 36, scope: !1990)
!2015 = !DILocation(line: 0, scope: !1957, inlinedAt: !2016)
!2016 = distinct !DILocation(line: 586, column: 2, scope: !1990)
!2017 = !DILocation(line: 676, column: 4, scope: !1957, inlinedAt: !2016)
!2018 = !DILocation(line: 600, column: 25, scope: !2019)
!2019 = distinct !DILexicalBlock(scope: !2020, file: !820, line: 597, column: 4)
!2020 = distinct !DILexicalBlock(scope: !1990, file: !820, line: 596, column: 27)
!2021 = !DILocation(line: 599, column: 21, scope: !2019)
!2022 = !DILocation(line: 601, column: 6, scope: !2019)
!2023 = !DILocation(line: 638, column: 21, scope: !1990)
!2024 = !{!2025, !1258, i64 0}
!2025 = !{!"_ZTSNSt6vectorIPiSaIS0_EE12_Guard_allocE", !1258, i64 0, !1409, i64 8, !2026, i64 16}
!2026 = !{!"p1 _ZTSSt12_Vector_baseIPiSaIS0_EE", !1259, i64 0}
!2027 = distinct !DIAssignID()
!2028 = !DILocation(line: 639, column: 33, scope: !1990)
!2029 = !DILocation(line: 639, column: 51, scope: !1990)
!2030 = !DILocation(line: 639, column: 10, scope: !1990)
!2031 = !DILocation(line: 639, column: 17, scope: !1990)
!2032 = !{!2025, !1409, i64 8}
!2033 = distinct !DIAssignID()
!2034 = !DILocation(line: 640, column: 7, scope: !1975)
!2035 = !DILocation(line: 644, column: 30, scope: !1975)
!2036 = !DILocation(line: 645, column: 31, scope: !1975)
!2037 = !DILocation(line: 646, column: 53, scope: !1975)
!2038 = !DILocation(line: 646, column: 39, scope: !1975)
!2039 = !DILocation(line: 647, column: 5, scope: !1975)
!2040 = distinct !DISubprogram(name: "back", linkageName: "_ZNSt6vectorIPiSaIS0_EE4backEv", scope: !23, file: !21, line: 1368, type: !479, scopeLine: 1369, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !484, retainedNodes: !2041)
!2041 = !{!2042}
!2042 = !DILocalVariable(name: "this", arg: 1, scope: !2040, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!2043 = !DILocalVariable(name: "this", arg: 1, scope: !2044, type: !2047, flags: DIFlagArtificial | DIFlagObjectPointer)
!2044 = distinct !DISubprogram(name: "operator-", linkageName: "_ZNK9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEmiEl", scope: !566, file: !366, line: 1159, type: !612, scopeLine: 1160, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !615, retainedNodes: !2045)
!2045 = !{!2043, !2046}
!2046 = !DILocalVariable(name: "__n", arg: 2, scope: !2044, file: !366, line: 1159, type: !606)
!2047 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !588, size: 64)
!2048 = !DILocation(line: 0, scope: !2044, inlinedAt: !2049)
!2049 = distinct !DILocation(line: 1371, column: 17, scope: !2040)
!2050 = !DILocation(line: 0, scope: !2040)
!2051 = !DILocation(line: 1371, column: 11, scope: !2040)
!2052 = !DILocation(line: 1160, column: 45, scope: !2044, inlinedAt: !2049)
!2053 = !DILocation(line: 1371, column: 2, scope: !2040)
!2054 = distinct !DISubprogram(name: "construct_at<int *, int *>", linkageName: "_ZSt12construct_atIPiJS0_EQaant20is_unbounded_array_vIT_ErqXgsnwcvPvLi0E_S1_pispclsr3stdE7declvalIT0_EEEEEPS1_S4_DpOS3_", scope: !18, file: !1345, line: 96, type: !2055, scopeLine: 98, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !2061, retainedNodes: !2057)
!2055 = !DISubroutineType(types: !2056)
!2056 = !{!47, !47, !1942}
!2057 = !{!2058, !2059, !2060}
!2058 = !DILocalVariable(name: "__location", arg: 1, scope: !2054, file: !1345, line: 96, type: !47)
!2059 = !DILocalVariable(name: "__args", arg: 2, scope: !2054, file: !1345, line: 96, type: !1942)
!2060 = !DILocalVariable(name: "__loc", scope: !2054, file: !1345, line: 99, type: !660)
!2061 = !{!86, !1945}
!2062 = !DILocation(line: 0, scope: !2054)
!2063 = !DILocation(line: 110, column: 26, scope: !2064)
!2064 = distinct !DILexicalBlock(scope: !2054, file: !1345, line: 102, column: 21)
!2065 = !DILocation(line: 110, column: 9, scope: !2064)
!2066 = !DILocation(line: 110, column: 2, scope: !2064)
!2067 = distinct !DISubprogram(name: "_M_check_len", linkageName: "_ZNKSt6vectorIPiSaIS0_EE12_M_check_lenEmPKc", scope: !23, file: !21, line: 2197, type: !535, scopeLine: 2198, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !534, retainedNodes: !2068)
!2068 = !{!2069, !2071, !2072, !2073}
!2069 = !DILocalVariable(name: "this", arg: 1, scope: !2067, type: !2070, flags: DIFlagArtificial | DIFlagObjectPointer)
!2070 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !312, size: 64)
!2071 = !DILocalVariable(name: "__n", arg: 2, scope: !2067, file: !21, line: 2197, type: !20)
!2072 = !DILocalVariable(name: "__s", arg: 3, scope: !2067, file: !21, line: 2197, type: !538)
!2073 = !DILocalVariable(name: "__len", scope: !2067, file: !21, line: 2202, type: !1983)
!2074 = distinct !DIAssignID()
!2075 = !DILocation(line: 0, scope: !2067)
!2076 = distinct !DIAssignID()
!2077 = !DILocation(line: 2199, column: 6, scope: !2078)
!2078 = distinct !DILexicalBlock(scope: !2067, file: !21, line: 2199, column: 6)
!2079 = !DILocation(line: 2199, column: 19, scope: !2078)
!2080 = !DILocation(line: 2199, column: 17, scope: !2078)
!2081 = !DILocation(line: 2199, column: 28, scope: !2078)
!2082 = !DILocation(line: 2199, column: 26, scope: !2078)
!2083 = !DILocation(line: 2200, column: 4, scope: !2078)
!2084 = !DILocation(line: 2202, column: 26, scope: !2067)
!2085 = !DILocation(line: 2202, column: 46, scope: !2067)
!2086 = !DILocation(line: 2202, column: 35, scope: !2067)
!2087 = !DILocation(line: 2202, column: 33, scope: !2067)
!2088 = !DILocation(line: 2203, column: 18, scope: !2067)
!2089 = !DILocation(line: 2203, column: 16, scope: !2067)
!2090 = !DILocation(line: 2203, column: 25, scope: !2067)
!2091 = !DILocation(line: 2203, column: 36, scope: !2067)
!2092 = !DILocation(line: 2203, column: 34, scope: !2067)
!2093 = !DILocation(line: 2203, column: 9, scope: !2067)
!2094 = !DILocation(line: 2203, column: 50, scope: !2067)
!2095 = !DILocation(line: 2203, column: 2, scope: !2067)
!2096 = distinct !DISubprogram(name: "end", linkageName: "_ZNSt6vectorIPiSaIS0_EE3endEv", scope: !23, file: !21, line: 1018, type: !359, scopeLine: 1019, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !426, retainedNodes: !2097)
!2097 = !{!2098}
!2098 = !DILocalVariable(name: "this", arg: 1, scope: !2096, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!2099 = !DILocalVariable(name: "this", arg: 1, scope: !2100, type: !2103, flags: DIFlagArtificial | DIFlagObjectPointer)
!2100 = distinct !DISubprogram(name: "__normal_iterator", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPPiSt6vectorIS1_SaIS1_EEEC2ERKS2_", scope: !566, file: !366, line: 1058, type: !574, scopeLine: 1059, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !573, retainedNodes: !2101)
!2101 = !{!2099, !2102}
!2102 = !DILocalVariable(name: "__i", arg: 2, scope: !2100, file: !366, line: 1058, type: !576)
!2103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !566, size: 64)
!2104 = !DILocation(line: 0, scope: !2100, inlinedAt: !2105)
!2105 = distinct !DILocation(line: 1019, column: 16, scope: !2096)
!2106 = !DILocation(line: 0, scope: !2096)
!2107 = !DILocation(line: 1019, column: 39, scope: !2096)
!2108 = !DILocation(line: 1059, column: 20, scope: !2100, inlinedAt: !2105)
!2109 = !{!1258, !1258, i64 0}
!2110 = !DILocation(line: 1019, column: 9, scope: !2096)
!2111 = distinct !DISubprogram(name: "begin", linkageName: "_ZNSt6vectorIPiSaIS0_EE5beginEv", scope: !23, file: !21, line: 998, type: !359, scopeLine: 999, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !358, retainedNodes: !2112)
!2112 = !{!2113}
!2113 = !DILocalVariable(name: "this", arg: 1, scope: !2111, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!2114 = !DILocation(line: 0, scope: !2111)
!2115 = !DILocation(line: 0, scope: !2100, inlinedAt: !2116)
!2116 = distinct !DILocation(line: 999, column: 16, scope: !2111)
!2117 = !DILocation(line: 1059, column: 20, scope: !2100, inlinedAt: !2116)
!2118 = !DILocation(line: 999, column: 9, scope: !2111)
!2119 = distinct !DISubprogram(name: "_M_allocate", linkageName: "_ZNSt12_Vector_baseIPiSaIS0_EE11_M_allocateEm", scope: !26, file: !21, line: 384, type: !232, scopeLine: 385, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !231, retainedNodes: !2120)
!2120 = !{!2121, !2122}
!2121 = !DILocalVariable(name: "this", arg: 1, scope: !2119, type: !1330, flags: DIFlagArtificial | DIFlagObjectPointer)
!2122 = !DILocalVariable(name: "__n", arg: 2, scope: !2119, file: !21, line: 384, type: !16)
!2123 = !DILocation(line: 0, scope: !2119)
!2124 = !DILocation(line: 387, column: 13, scope: !2119)
!2125 = !DILocation(line: 387, column: 9, scope: !2119)
!2126 = !DILocalVariable(name: "__a", arg: 1, scope: !2127, file: !41, line: 613, type: !48)
!2127 = distinct !DISubprogram(name: "allocate", linkageName: "_ZNSt16allocator_traitsISaIPiEE8allocateERS1_m", scope: !40, file: !41, line: 613, type: !44, scopeLine: 614, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !43, retainedNodes: !2128)
!2128 = !{!2126, !2129}
!2129 = !DILocalVariable(name: "__n", arg: 2, scope: !2127, file: !41, line: 613, type: !107)
!2130 = !DILocation(line: 0, scope: !2127, inlinedAt: !2131)
!2131 = distinct !DILocation(line: 387, column: 20, scope: !2119)
!2132 = !DILocalVariable(name: "this", arg: 1, scope: !2133, type: !1374, flags: DIFlagArtificial | DIFlagObjectPointer)
!2133 = distinct !DISubprogram(name: "allocate", linkageName: "_ZNSaIPiE8allocateEm", scope: !50, file: !51, line: 194, type: !102, scopeLine: 195, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !101, retainedNodes: !2134)
!2134 = !{!2132, !2135}
!2135 = !DILocalVariable(name: "__n", arg: 2, scope: !2133, file: !51, line: 194, type: !16)
!2136 = !DILocation(line: 0, scope: !2133, inlinedAt: !2137)
!2137 = distinct !DILocation(line: 614, column: 20, scope: !2127, inlinedAt: !2131)
!2138 = !DILocation(line: 203, column: 32, scope: !2133, inlinedAt: !2137)
!2139 = !DILocation(line: 387, column: 2, scope: !2119)
!2140 = distinct !DISubprogram(name: "_Guard_alloc", linkageName: "_ZNSt6vectorIPiSaIS0_EE12_Guard_allocC2EPS0_mRSt12_Vector_baseIS0_S1_E", scope: !662, file: !21, line: 1875, type: !670, scopeLine: 1877, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !669, retainedNodes: !2141)
!2141 = !{!2142, !2144, !2145, !2146}
!2142 = !DILocalVariable(name: "this", arg: 1, scope: !2140, type: !2143, flags: DIFlagArtificial | DIFlagObjectPointer)
!2143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !662, size: 64)
!2144 = !DILocalVariable(name: "__s", arg: 2, scope: !2140, file: !21, line: 1875, type: !280)
!2145 = !DILocalVariable(name: "__l", arg: 3, scope: !2140, file: !21, line: 1875, type: !20)
!2146 = !DILocalVariable(name: "__vect", arg: 4, scope: !2140, file: !21, line: 1875, type: !667)
!2147 = !DILocation(line: 0, scope: !2140)
!2148 = !DILocation(line: 1876, column: 4, scope: !2140)
!2149 = !DILocation(line: 1876, column: 21, scope: !2140)
!2150 = !DILocation(line: 1876, column: 34, scope: !2140)
!2151 = !{!2026, !2026, i64 0}
!2152 = !DILocation(line: 1877, column: 4, scope: !2140)
!2153 = distinct !DISubprogram(name: "_S_relocate", linkageName: "_ZNSt6vectorIPiSaIS0_EE11_S_relocateEPS0_S3_S3_RS1_", scope: !23, file: !21, line: 534, type: !287, scopeLine: 536, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !286, retainedNodes: !2154)
!2154 = !{!2155, !2156, !2157, !2158}
!2155 = !DILocalVariable(name: "__first", arg: 1, scope: !2153, file: !21, line: 534, type: !280)
!2156 = !DILocalVariable(name: "__last", arg: 2, scope: !2153, file: !21, line: 534, type: !280)
!2157 = !DILocalVariable(name: "__result", arg: 3, scope: !2153, file: !21, line: 534, type: !280)
!2158 = !DILocalVariable(name: "__alloc", arg: 4, scope: !2153, file: !21, line: 535, type: !281)
!2159 = !DILocation(line: 0, scope: !2153)
!2160 = !DILocation(line: 539, column: 9, scope: !2153)
!2161 = !DILocation(line: 539, column: 2, scope: !2153)
!2162 = distinct !DISubprogram(name: "~_Guard_alloc", linkageName: "_ZNSt6vectorIPiSaIS0_EE12_Guard_allocD2Ev", scope: !662, file: !21, line: 1880, type: !674, scopeLine: 1881, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !673, retainedNodes: !2163)
!2163 = !{!2164}
!2164 = !DILocalVariable(name: "this", arg: 1, scope: !2162, type: !2143, flags: DIFlagArtificial | DIFlagObjectPointer)
!2165 = !DILocation(line: 0, scope: !2162)
!2166 = !DILocation(line: 1882, column: 8, scope: !2167)
!2167 = distinct !DILexicalBlock(scope: !2168, file: !21, line: 1882, column: 8)
!2168 = distinct !DILexicalBlock(scope: !2162, file: !21, line: 1881, column: 2)
!2169 = !DILocation(line: 1883, column: 6, scope: !2167)
!2170 = !{!2025, !2026, i64 16}
!2171 = !DILocation(line: 1883, column: 40, scope: !2167)
!2172 = !DILocation(line: 1883, column: 14, scope: !2167)
!2173 = !DILocation(line: 1884, column: 2, scope: !2162)
!2174 = distinct !DISubprogram(name: "max_size", linkageName: "_ZNKSt6vectorIPiSaIS0_EE8max_sizeEv", scope: !23, file: !21, line: 1128, type: !445, scopeLine: 1129, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !447, retainedNodes: !2175)
!2175 = !{!2176}
!2176 = !DILocalVariable(name: "this", arg: 1, scope: !2174, type: !2070, flags: DIFlagArtificial | DIFlagObjectPointer)
!2177 = !DILocation(line: 0, scope: !2174)
!2178 = !DILocation(line: 1129, column: 28, scope: !2174)
!2179 = !DILocation(line: 1129, column: 16, scope: !2174)
!2180 = !DILocation(line: 1129, column: 9, scope: !2174)
!2181 = distinct !DISubprogram(name: "size", linkageName: "_ZNKSt6vectorIPiSaIS0_EE4sizeEv", scope: !23, file: !21, line: 1117, type: !445, scopeLine: 1118, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !444, retainedNodes: !2182)
!2182 = !{!2183, !2184}
!2183 = !DILocalVariable(name: "this", arg: 1, scope: !2181, type: !2070, flags: DIFlagArtificial | DIFlagObjectPointer)
!2184 = !DILocalVariable(name: "__dif", scope: !2181, file: !21, line: 1119, type: !411)
!2185 = !DILocation(line: 0, scope: !2181)
!2186 = !DILocation(line: 1119, column: 34, scope: !2181)
!2187 = !DILocation(line: 1119, column: 60, scope: !2181)
!2188 = !DILocation(line: 1119, column: 44, scope: !2181)
!2189 = !DILocation(line: 1120, column: 12, scope: !2190)
!2190 = distinct !DILexicalBlock(scope: !2181, file: !21, line: 1120, column: 6)
!2191 = !DILocation(line: 1122, column: 2, scope: !2181)
!2192 = !DISubprogram(name: "__throw_length_error", linkageName: "_ZSt20__throw_length_errorPKc", scope: !18, file: !2193, line: 76, type: !2194, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!2193 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/functexcept.h", directory: "", checksumkind: CSK_MD5, checksum: "bda3ca60f2214f1bd6656e6612aff428")
!2194 = !DISubroutineType(types: !2195)
!2195 = !{null, !538}
!2196 = distinct !DISubprogram(name: "max<unsigned long>", linkageName: "_ZSt3maxImERKT_S2_S2_", scope: !18, file: !2197, line: 258, type: !2198, scopeLine: 259, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !2205, retainedNodes: !2202)
!2197 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/stl_algobase.h", directory: "", checksumkind: CSK_MD5, checksum: "3c7b64acc2cfe4efdb8e6f4dd577e0b5")
!2198 = !DISubroutineType(types: !2199)
!2199 = !{!2200, !2200, !2200}
!2200 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !2201, size: 64)
!2201 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !19)
!2202 = !{!2203, !2204}
!2203 = !DILocalVariable(name: "__a", arg: 1, scope: !2196, file: !2197, line: 258, type: !2200)
!2204 = !DILocalVariable(name: "__b", arg: 2, scope: !2196, file: !2197, line: 258, type: !2200)
!2205 = !{!2206}
!2206 = !DITemplateTypeParameter(name: "_Tp", type: !19)
!2207 = !DILocation(line: 0, scope: !2196)
!2208 = !DILocation(line: 263, column: 11, scope: !2209)
!2209 = distinct !DILexicalBlock(scope: !2196, file: !2197, line: 263, column: 11)
!2210 = !DILocation(line: 263, column: 17, scope: !2209)
!2211 = !DILocation(line: 263, column: 15, scope: !2209)
!2212 = !DILocation(line: 266, column: 5, scope: !2196)
!2213 = distinct !DISubprogram(name: "_S_max_size", linkageName: "_ZNSt6vectorIPiSaIS0_EE11_S_max_sizeERKS1_", scope: !23, file: !21, line: 2217, type: !545, scopeLine: 2218, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !544, retainedNodes: !2214)
!2214 = !{!2215, !2216, !2218}
!2215 = !DILocalVariable(name: "__a", arg: 1, scope: !2213, file: !21, line: 2217, type: !547)
!2216 = !DILocalVariable(name: "__diffmax", scope: !2213, file: !21, line: 2222, type: !2217)
!2217 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !16)
!2218 = !DILocalVariable(name: "__allocmax", scope: !2213, file: !21, line: 2224, type: !2217)
!2219 = distinct !DIAssignID()
!2220 = !DILocation(line: 0, scope: !2213)
!2221 = distinct !DIAssignID()
!2222 = !DILocation(line: 2222, column: 2, scope: !2213)
!2223 = !DILocation(line: 2222, column: 15, scope: !2213)
!2224 = distinct !DIAssignID()
!2225 = !DILocation(line: 2224, column: 2, scope: !2213)
!2226 = !DILocation(line: 2224, column: 15, scope: !2213)
!2227 = distinct !DIAssignID()
!2228 = !DILocation(line: 2225, column: 9, scope: !2213)
!2229 = !DILocation(line: 2226, column: 7, scope: !2213)
!2230 = !DILocation(line: 2225, column: 2, scope: !2213)
!2231 = distinct !DISubprogram(name: "_M_get_Tp_allocator", linkageName: "_ZNKSt12_Vector_baseIPiSaIS0_EE19_M_get_Tp_allocatorEv", scope: !26, file: !21, line: 312, type: !195, scopeLine: 313, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !194, retainedNodes: !2232)
!2232 = !{!2233}
!2233 = !DILocalVariable(name: "this", arg: 1, scope: !2231, type: !2234, flags: DIFlagArtificial | DIFlagObjectPointer)
!2234 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !198, size: 64)
!2235 = !DILocation(line: 0, scope: !2231)
!2236 = !DILocation(line: 313, column: 9, scope: !2231)
!2237 = distinct !DISubprogram(name: "min<unsigned long>", linkageName: "_ZSt3minImERKT_S2_S2_", scope: !18, file: !2197, line: 234, type: !2198, scopeLine: 235, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !2205, retainedNodes: !2238)
!2238 = !{!2239, !2240}
!2239 = !DILocalVariable(name: "__a", arg: 1, scope: !2237, file: !2197, line: 234, type: !2200)
!2240 = !DILocalVariable(name: "__b", arg: 2, scope: !2237, file: !2197, line: 234, type: !2200)
!2241 = !DILocation(line: 0, scope: !2237)
!2242 = !DILocation(line: 239, column: 11, scope: !2243)
!2243 = distinct !DILexicalBlock(scope: !2237, file: !2197, line: 239, column: 11)
!2244 = !DILocation(line: 239, column: 17, scope: !2243)
!2245 = !DILocation(line: 239, column: 15, scope: !2243)
!2246 = !DILocation(line: 242, column: 5, scope: !2237)
!2247 = distinct !DISubprogram(name: "allocate", linkageName: "_ZNSt15__new_allocatorIPiE8allocateEmPKv", scope: !56, file: !57, line: 126, type: !73, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !72, retainedNodes: !2248)
!2248 = !{!2249, !2250, !2251}
!2249 = !DILocalVariable(name: "this", arg: 1, scope: !2247, type: !1383, flags: DIFlagArtificial | DIFlagObjectPointer)
!2250 = !DILocalVariable(name: "__n", arg: 2, scope: !2247, file: !57, line: 126, type: !75)
!2251 = !DILocalVariable(arg: 3, scope: !2247, file: !57, line: 126, type: !76)
!2252 = !DILocation(line: 0, scope: !2247)
!2253 = !DILocation(line: 134, column: 27, scope: !2254)
!2254 = distinct !DILexicalBlock(scope: !2247, file: !57, line: 134, column: 6)
!2255 = !DILocation(line: 134, column: 6, scope: !2254)
!2256 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!2257 = !DILocation(line: 138, column: 14, scope: !2258)
!2258 = distinct !DILexicalBlock(scope: !2259, file: !57, line: 138, column: 10)
!2259 = distinct !DILexicalBlock(scope: !2254, file: !57, line: 135, column: 4)
!2260 = !DILocation(line: 139, column: 8, scope: !2258)
!2261 = !DILocation(line: 140, column: 6, scope: !2259)
!2262 = !DILocation(line: 151, column: 53, scope: !2247)
!2263 = !DILocation(line: 151, column: 27, scope: !2247)
!2264 = !DILocation(line: 151, column: 2, scope: !2247)
!2265 = !DISubprogram(name: "__throw_bad_array_new_length", linkageName: "_ZSt28__throw_bad_array_new_lengthv", scope: !18, file: !2193, line: 56, type: !726, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!2266 = !DISubprogram(name: "__throw_bad_alloc", linkageName: "_ZSt17__throw_bad_allocv", scope: !18, file: !2193, line: 53, type: !726, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!2267 = distinct !DISubprogram(name: "__relocate_a<int **, int **, std::allocator<int *> >", linkageName: "_ZSt12__relocate_aIPPiS1_SaIS0_EET0_T_S4_S3_RT1_", scope: !18, file: !2268, line: 1353, type: !2269, scopeLine: 1358, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !2276, retainedNodes: !2271)
!2268 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/stl_uninitialized.h", directory: "", checksumkind: CSK_MD5, checksum: "39e026c8777c826d5bfa7a763d177052")
!2269 = !DISubroutineType(types: !2270)
!2270 = !{!47, !47, !47, !47, !99}
!2271 = !{!2272, !2273, !2274, !2275}
!2272 = !DILocalVariable(name: "__first", arg: 1, scope: !2267, file: !2268, line: 1353, type: !47)
!2273 = !DILocalVariable(name: "__last", arg: 2, scope: !2267, file: !2268, line: 1353, type: !47)
!2274 = !DILocalVariable(name: "__result", arg: 3, scope: !2267, file: !2268, line: 1354, type: !47)
!2275 = !DILocalVariable(name: "__alloc", arg: 4, scope: !2267, file: !2268, line: 1354, type: !99)
!2276 = !{!2277, !1273, !2278}
!2277 = !DITemplateTypeParameter(name: "_InputIterator", type: !47)
!2278 = !DITemplateTypeParameter(name: "_Allocator", type: !50)
!2279 = !DILocation(line: 0, scope: !2267)
!2280 = !DILocation(line: 1359, column: 14, scope: !2267)
!2281 = !DILocation(line: 1359, column: 7, scope: !2267)
!2282 = distinct !DISubprogram(name: "__relocate_a_1<int *, int *>", linkageName: "_ZSt14__relocate_a_1IPiS0_ENSt9enable_ifIXsr3std24__is_bitwise_relocatableIT_EE5valueEPS2_E4typeES3_S3_S3_RSaIT0_E", scope: !18, file: !2268, line: 1326, type: !2283, scopeLine: 1329, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !2297, retainedNodes: !2291)
!2283 = !DISubroutineType(types: !2284)
!2284 = !{!2285, !47, !47, !47, !99}
!2285 = !DIDerivedType(tag: DW_TAG_typedef, name: "__enable_if_t<std::__is_bitwise_relocatable<int *>::value, int **>", scope: !18, file: !243, line: 143, baseType: !2286)
!2286 = !DIDerivedType(tag: DW_TAG_typedef, name: "type", scope: !2287, file: !243, line: 139, baseType: !47)
!2287 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "enable_if<true, int **>", scope: !18, file: !243, line: 138, size: 8, flags: DIFlagTypePassByValue, elements: !142, templateParams: !2288, identifier: "_ZTSSt9enable_ifILb1EPPiE")
!2288 = !{!2289, !2290}
!2289 = !DITemplateValueParameter(type: !135, value: i1 true)
!2290 = !DITemplateTypeParameter(name: "_Tp", type: !47)
!2291 = !{!2292, !2293, !2294, !2295, !2296}
!2292 = !DILocalVariable(name: "__first", arg: 1, scope: !2282, file: !2268, line: 1326, type: !47)
!2293 = !DILocalVariable(name: "__last", arg: 2, scope: !2282, file: !2268, line: 1326, type: !47)
!2294 = !DILocalVariable(name: "__result", arg: 3, scope: !2282, file: !2268, line: 1327, type: !47)
!2295 = !DILocalVariable(name: "__alloc", arg: 4, scope: !2282, file: !2268, line: 1328, type: !99)
!2296 = !DILocalVariable(name: "__count", scope: !2282, file: !2268, line: 1330, type: !411)
!2297 = !{!86, !1962}
!2298 = !DILocation(line: 0, scope: !2282)
!2299 = !DILocation(line: 1330, column: 34, scope: !2282)
!2300 = !DILocation(line: 1331, column: 19, scope: !2301)
!2301 = distinct !DILexicalBlock(scope: !2282, file: !2268, line: 1331, column: 11)
!2302 = !DILocation(line: 1343, column: 4, scope: !2303)
!2303 = distinct !DILexicalBlock(scope: !2301, file: !2268, line: 1332, column: 2)
!2304 = !DILocation(line: 1344, column: 2, scope: !2303)
!2305 = !DILocation(line: 1345, column: 23, scope: !2282)
!2306 = !DILocation(line: 1345, column: 7, scope: !2282)
!2307 = distinct !DISubprogram(name: "empty", linkageName: "_ZNKSt6vectorIPiSaIS0_EE5emptyEv", scope: !23, file: !21, line: 1223, type: !455, scopeLine: 1224, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !454, retainedNodes: !2308)
!2308 = !{!2309}
!2309 = !DILocalVariable(name: "this", arg: 1, scope: !2307, type: !2070, flags: DIFlagArtificial | DIFlagObjectPointer)
!2310 = !DILocalVariable(name: "__lhs", arg: 1, scope: !2311, file: !366, line: 1200, type: !2314)
!2311 = distinct !DISubprogram(name: "operator==<int *const *, std::vector<int *, std::allocator<int *> > >", linkageName: "_ZN9__gnu_cxxeqIPKPiSt6vectorIS1_SaIS1_EEEEbRKNS_17__normal_iteratorIT_T0_EESC_QrqXeqcldtfp_4baseEcldtfp0_4baseERSt14convertible_toIbEE", scope: !37, file: !366, line: 1200, type: !2312, scopeLine: 1206, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !423, retainedNodes: !2315)
!2312 = !DISubroutineType(types: !2313)
!2313 = !{!135, !2314, !2314}
!2314 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !391, size: 64)
!2315 = !{!2310, !2316}
!2316 = !DILocalVariable(name: "__rhs", arg: 2, scope: !2311, file: !366, line: 1201, type: !2314)
!2317 = !DILocation(line: 0, scope: !2311, inlinedAt: !2318)
!2318 = distinct !DILocation(line: 1224, column: 24, scope: !2307)
!2319 = !DILocation(line: 0, scope: !2307)
!2320 = !DILocation(line: 1224, column: 16, scope: !2307)
!2321 = !DILocation(line: 1224, column: 27, scope: !2307)
!2322 = !DILocation(line: 1206, column: 27, scope: !2311, inlinedAt: !2318)
!2323 = !DILocation(line: 1224, column: 9, scope: !2307)
!2324 = distinct !DISubprogram(name: "operator[]", linkageName: "_ZNSt6vectorIPiSaIS0_EEixEm", scope: !23, file: !21, line: 1261, type: !459, scopeLine: 1262, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !458, retainedNodes: !2325)
!2325 = !{!2326, !2327}
!2326 = !DILocalVariable(name: "this", arg: 1, scope: !2324, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!2327 = !DILocalVariable(name: "__n", arg: 2, scope: !2324, file: !21, line: 1261, type: !20)
!2328 = !DILocation(line: 0, scope: !2324)
!2329 = !DILocation(line: 1264, column: 25, scope: !2324)
!2330 = !DILocation(line: 1264, column: 34, scope: !2324)
!2331 = !DILocation(line: 1264, column: 2, scope: !2324)
!2332 = distinct !DISubprogram(name: "begin", linkageName: "_ZNKSt6vectorIPiSaIS0_EE5beginEv", scope: !23, file: !21, line: 1008, type: !362, scopeLine: 1009, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !361, retainedNodes: !2333)
!2333 = !{!2334}
!2334 = !DILocalVariable(name: "this", arg: 1, scope: !2332, type: !2070, flags: DIFlagArtificial | DIFlagObjectPointer)
!2335 = !DILocation(line: 0, scope: !2332)
!2336 = !DILocalVariable(name: "this", arg: 1, scope: !2337, type: !2340, flags: DIFlagArtificial | DIFlagObjectPointer)
!2337 = distinct !DISubprogram(name: "__normal_iterator", linkageName: "_ZN9__gnu_cxx17__normal_iteratorIPKPiSt6vectorIS1_SaIS1_EEEC2ERKS3_", scope: !365, file: !366, line: 1058, type: !376, scopeLine: 1059, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !375, retainedNodes: !2338)
!2338 = !{!2336, !2339}
!2339 = !DILocalVariable(name: "__i", arg: 2, scope: !2337, file: !366, line: 1058, type: !378)
!2340 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !365, size: 64)
!2341 = !DILocation(line: 0, scope: !2337, inlinedAt: !2342)
!2342 = distinct !DILocation(line: 1009, column: 16, scope: !2332)
!2343 = !DILocation(line: 1059, column: 20, scope: !2337, inlinedAt: !2342)
!2344 = !DILocation(line: 1009, column: 9, scope: !2332)
!2345 = distinct !DISubprogram(name: "end", linkageName: "_ZNKSt6vectorIPiSaIS0_EE3endEv", scope: !23, file: !21, line: 1028, type: !362, scopeLine: 1029, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !427, retainedNodes: !2346)
!2346 = !{!2347}
!2347 = !DILocalVariable(name: "this", arg: 1, scope: !2345, type: !2070, flags: DIFlagArtificial | DIFlagObjectPointer)
!2348 = !DILocation(line: 0, scope: !2337, inlinedAt: !2349)
!2349 = distinct !DILocation(line: 1029, column: 16, scope: !2345)
!2350 = !DILocation(line: 0, scope: !2345)
!2351 = !DILocation(line: 1029, column: 45, scope: !2345)
!2352 = !DILocation(line: 1059, column: 20, scope: !2337, inlinedAt: !2349)
!2353 = !DILocation(line: 1029, column: 9, scope: !2345)
!2354 = distinct !DISubprogram(name: "_M_erase_at_end", linkageName: "_ZNSt6vectorIPiSaIS0_EE15_M_erase_at_endEPS0_", scope: !23, file: !21, line: 2234, type: !550, scopeLine: 2235, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !549, retainedNodes: !2355)
!2355 = !{!2356, !2357, !2358}
!2356 = !DILocalVariable(name: "this", arg: 1, scope: !2354, type: !1252, flags: DIFlagArtificial | DIFlagObjectPointer)
!2357 = !DILocalVariable(name: "__pos", arg: 2, scope: !2354, file: !21, line: 2234, type: !280)
!2358 = !DILocalVariable(name: "__n", scope: !2359, file: !21, line: 2236, type: !20)
!2359 = distinct !DILexicalBlock(scope: !2354, file: !21, line: 2236, column: 16)
!2360 = !DILocation(line: 0, scope: !2354)
!2361 = !DILocation(line: 2236, column: 36, scope: !2359)
!2362 = !DILocation(line: 0, scope: !2359)
!2363 = !DILocation(line: 2236, column: 16, scope: !2359)
!2364 = !DILocation(line: 2239, column: 6, scope: !2365)
!2365 = distinct !DILexicalBlock(scope: !2359, file: !21, line: 2237, column: 4)
!2366 = !DILocation(line: 0, scope: !1266, inlinedAt: !2367)
!2367 = distinct !DILocation(line: 2238, column: 6, scope: !2365)
!2368 = !DILocation(line: 1045, column: 7, scope: !1266, inlinedAt: !2367)
!2369 = !DILocation(line: 2240, column: 30, scope: !2365)
!2370 = !DILocation(line: 2242, column: 4, scope: !2365)
!2371 = !DILocation(line: 2243, column: 7, scope: !2354)
!2372 = distinct !DISubprogram(name: "worker6", linkageName: "_ZL7worker6Pv", scope: !3, file: !3, line: 249, type: !1830, scopeLine: 249, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2373)
!2373 = !{!2374, !2375}
!2374 = !DILocalVariable(name: "arg", arg: 1, scope: !2372, file: !3, line: 249, type: !660)
!2375 = !DILocalVariable(name: "pp", scope: !2372, file: !3, line: 250, type: !47)
!2376 = !DILocation(line: 0, scope: !2372)
!2377 = !DILocation(line: 251, column: 6, scope: !2372)
!2378 = !DILocation(line: 251, column: 10, scope: !2372)
!2379 = !DILocation(line: 252, column: 5, scope: !2372)
!2380 = !DISubprogram(name: "memset", scope: !2381, file: !2381, line: 61, type: !2382, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!2381 = !DIFile(filename: "/usr/include/string.h", directory: "", checksumkind: CSK_MD5, checksum: "c7907c19389b51414f4e5651f579e243")
!2382 = !DISubroutineType(types: !2383)
!2383 = !{!660, !660, !5, !937}
!2384 = distinct !DISubprogram(name: "worker7", linkageName: "_ZL7worker7Pv", scope: !3, file: !3, line: 279, type: !1830, scopeLine: 279, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2385)
!2385 = !{!2386, !2387}
!2386 = !DILocalVariable(name: "arg", arg: 1, scope: !2384, file: !3, line: 279, type: !660)
!2387 = !DILocalVariable(name: "a", scope: !2384, file: !3, line: 280, type: !620)
!2388 = !DILocation(line: 0, scope: !2384)
!2389 = !DILocation(line: 281, column: 25, scope: !2384)
!2390 = !DILocation(line: 281, column: 29, scope: !2384)
!2391 = !DILocation(line: 281, column: 8, scope: !2384)
!2392 = !DILocation(line: 281, column: 5, scope: !2384)
!2393 = !DILocation(line: 281, column: 20, scope: !2384)
!2394 = !DILocation(line: 282, column: 5, scope: !2384)
!2395 = distinct !DISubprogram(name: "worker8a", linkageName: "_ZL8worker8aPv", scope: !3, file: !3, line: 306, type: !1830, scopeLine: 306, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2396)
!2396 = !{!2397, !2398, !2399}
!2397 = !DILocalVariable(name: "arg", arg: 1, scope: !2395, file: !3, line: 306, type: !660)
!2398 = !DILocalVariable(name: "arr", scope: !2395, file: !3, line: 307, type: !15)
!2399 = !DILocalVariable(name: "i", scope: !2400, file: !3, line: 308, type: !5)
!2400 = distinct !DILexicalBlock(scope: !2395, file: !3, line: 308, column: 5)
!2401 = !DILocation(line: 0, scope: !2395)
!2402 = !DILocation(line: 0, scope: !2400)
!2403 = !DILocation(line: 307, column: 32, scope: !2395)
!2404 = !DILocation(line: 308, column: 5, scope: !2400)
!2405 = !DILocation(line: 308, column: 42, scope: !2406)
!2406 = distinct !DILexicalBlock(scope: !2400, file: !3, line: 308, column: 5)
!2407 = !DILocation(line: 309, column: 5, scope: !2395)
!2408 = distinct !DISubprogram(name: "worker8b", linkageName: "_ZL8worker8bPv", scope: !3, file: !3, line: 311, type: !1830, scopeLine: 311, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2409)
!2409 = !{!2410, !2411, !2412}
!2410 = !DILocalVariable(name: "arg", arg: 1, scope: !2408, file: !3, line: 311, type: !660)
!2411 = !DILocalVariable(name: "arr", scope: !2408, file: !3, line: 312, type: !15)
!2412 = !DILocalVariable(name: "i", scope: !2413, file: !3, line: 313, type: !5)
!2413 = distinct !DILexicalBlock(scope: !2408, file: !3, line: 313, column: 5)
!2414 = !DILocation(line: 0, scope: !2408)
!2415 = !DILocation(line: 0, scope: !2413)
!2416 = !DILocation(line: 312, column: 32, scope: !2408)
!2417 = !DILocation(line: 313, column: 5, scope: !2413)
!2418 = !DILocation(line: 313, column: 42, scope: !2419)
!2419 = distinct !DILexicalBlock(scope: !2413, file: !3, line: 313, column: 5)
!2420 = !DILocation(line: 314, column: 5, scope: !2408)
!2421 = distinct !DISubprogram(name: "worker9", linkageName: "_ZL7worker9Pv", scope: !3, file: !3, line: 335, type: !1830, scopeLine: 335, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2422)
!2422 = !{!2423, !2424}
!2423 = !DILocalVariable(name: "arg", arg: 1, scope: !2421, file: !3, line: 335, type: !660)
!2424 = !DILocalVariable(name: "p", scope: !2421, file: !3, line: 336, type: !15)
!2425 = !DILocation(line: 0, scope: !2421)
!2426 = !DILocation(line: 337, column: 5, scope: !2421)
!2427 = !DILocation(line: 337, column: 11, scope: !2421)
!2428 = !DILocation(line: 338, column: 11, scope: !2421)
!2429 = !DILocation(line: 339, column: 5, scope: !2421)
!2430 = !DILocation(line: 339, column: 11, scope: !2421)
!2431 = !DILocation(line: 340, column: 5, scope: !2421)
!2432 = distinct !DISubprogram(name: "worker10", linkageName: "_ZL8worker10Pv", scope: !3, file: !3, line: 363, type: !1830, scopeLine: 363, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2433)
!2433 = !{!2434, !2435}
!2434 = !DILocalVariable(arg: 1, scope: !2432, file: !3, line: 363, type: !660)
!2435 = !DILocalVariable(name: "i", scope: !2436, file: !3, line: 365, type: !5)
!2436 = distinct !DILexicalBlock(scope: !2432, file: !3, line: 365, column: 5)
!2437 = !DILocation(line: 0, scope: !2432)
!2438 = !DILocation(line: 0, scope: !2436)
!2439 = !DILocation(line: 365, column: 5, scope: !2436)
!2440 = !DILocation(line: 0, scope: !2441)
!2441 = distinct !DILexicalBlock(scope: !2442, file: !3, line: 365, column: 38)
!2442 = distinct !DILexicalBlock(scope: !2436, file: !3, line: 365, column: 5)
!2443 = !DILocation(line: 369, column: 5, scope: !2432)
!2444 = distinct !DISubprogram(name: "worker11", linkageName: "_ZL8worker11Pv", scope: !3, file: !3, line: 388, type: !1830, scopeLine: 388, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2445)
!2445 = !{!2446, !2447, !2448, !2450, !2451}
!2446 = !DILocalVariable(arg: 1, scope: !2444, file: !3, line: 388, type: !660)
!2447 = !DILocalVariable(name: "private_arr", scope: !2444, file: !3, line: 390, type: !15)
!2448 = !DILocalVariable(name: "i", scope: !2449, file: !3, line: 391, type: !5)
!2449 = distinct !DILexicalBlock(scope: !2444, file: !3, line: 391, column: 5)
!2450 = !DILocalVariable(name: "sum", scope: !2444, file: !3, line: 392, type: !10)
!2451 = !DILocalVariable(name: "i", scope: !2452, file: !3, line: 393, type: !5)
!2452 = distinct !DILexicalBlock(scope: !2444, file: !3, line: 393, column: 5)
!2453 = !DILocation(line: 0, scope: !2444)
!2454 = !DILocation(line: 390, column: 31, scope: !2444)
!2455 = !DILocation(line: 0, scope: !2449)
!2456 = !DILocation(line: 391, column: 5, scope: !2449)
!2457 = !DILocation(line: 391, column: 55, scope: !2458)
!2458 = distinct !DILexicalBlock(scope: !2449, file: !3, line: 391, column: 5)
!2459 = !DILocation(line: 391, column: 36, scope: !2458)
!2460 = !DILocation(line: 391, column: 51, scope: !2458)
!2461 = !DILocation(line: 391, column: 32, scope: !2458)
!2462 = !DILocation(line: 391, column: 23, scope: !2458)
!2463 = distinct !{!2463, !2456, !2464, !1321, !1322}
!2464 = !DILocation(line: 391, column: 57, scope: !2449)
!2465 = !DILocation(line: 0, scope: !2452)
!2466 = !DILocation(line: 395, column: 5, scope: !2444)
!2467 = !DILocation(line: 396, column: 5, scope: !2444)
!2468 = distinct !DISubprogram(name: "worker12", linkageName: "_ZL8worker12Pv", scope: !3, file: !3, line: 418, type: !1830, scopeLine: 418, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2469)
!2469 = !{!2470, !2471}
!2470 = !DILocalVariable(name: "arg", arg: 1, scope: !2468, file: !3, line: 418, type: !660)
!2471 = !DILocalVariable(name: "o", scope: !2468, file: !3, line: 419, type: !629)
!2472 = !DILocation(line: 0, scope: !2468)
!2473 = !DILocation(line: 420, column: 16, scope: !2468)
!2474 = !{!2475, !1403, i64 0}
!2475 = !{!"_ZTS7Outer12", !2476, i64 0, !1403, i64 8}
!2476 = !{!"_ZTS7Inner12", !1403, i64 0, !1403, i64 4}
!2477 = !DILocation(line: 421, column: 14, scope: !2468)
!2478 = !DILocation(line: 421, column: 16, scope: !2468)
!2479 = !{!2475, !1403, i64 4}
!2480 = !DILocation(line: 422, column: 5, scope: !2468)
!2481 = !DISubprogram(name: "memcpy", scope: !2381, file: !2381, line: 43, type: !2482, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!2482 = !DISubroutineType(types: !2483)
!2483 = !{!660, !1832, !2484, !937}
!2484 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !76)
!2485 = distinct !DISubprogram(name: "worker13", linkageName: "_ZL8worker13Pv", scope: !3, file: !3, line: 445, type: !1830, scopeLine: 445, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2486)
!2486 = !{!2487, !2488, !2489}
!2487 = !DILocalVariable(name: "arg", arg: 1, scope: !2485, file: !3, line: 445, type: !660)
!2488 = !DILocalVariable(name: "a", scope: !2485, file: !3, line: 446, type: !640)
!2489 = !DILocalVariable(name: "p", scope: !2485, file: !3, line: 447, type: !15)
!2490 = distinct !DIAssignID()
!2491 = !DILocation(line: 0, scope: !2485)
!2492 = !DILocation(line: 447, column: 5, scope: !2485)
!2493 = !DILocation(line: 448, column: 5, scope: !2485)
!2494 = !DILocation(line: 449, column: 6, scope: !2485)
!2495 = !DILocation(line: 449, column: 8, scope: !2485)
!2496 = !DILocation(line: 451, column: 1, scope: !2485)
!2497 = !DILocation(line: 450, column: 5, scope: !2485)
!2498 = distinct !DISubprogram(name: "worker14", linkageName: "_ZL8worker14Pv", scope: !3, file: !3, line: 476, type: !1830, scopeLine: 476, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2499)
!2499 = !{!2500, !2501, !2502, !2503}
!2500 = !DILocalVariable(name: "arg", arg: 1, scope: !2498, file: !3, line: 476, type: !660)
!2501 = !DILocalVariable(name: "ro", scope: !2498, file: !3, line: 477, type: !644)
!2502 = !DILocalVariable(name: "sum", scope: !2498, file: !3, line: 478, type: !10)
!2503 = !DILocalVariable(name: "i", scope: !2504, file: !3, line: 479, type: !5)
!2504 = distinct !DILexicalBlock(scope: !2498, file: !3, line: 479, column: 5)
!2505 = !DILocation(line: 0, scope: !2498)
!2506 = !DILocation(line: 0, scope: !2504)
!2507 = !DILocation(line: 481, column: 5, scope: !2498)
!2508 = distinct !DISubprogram(name: "cb15_write", linkageName: "_ZL10cb15_writePv", scope: !3, file: !3, line: 505, type: !658, scopeLine: 505, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2509)
!2509 = !{!2510, !2511}
!2510 = !DILocalVariable(name: "ctx", arg: 1, scope: !2508, file: !3, line: 505, type: !660)
!2511 = !DILocalVariable(name: "p", scope: !2508, file: !3, line: 506, type: !15)
!2512 = !DILocation(line: 0, scope: !2508)
!2513 = !DILocation(line: 507, column: 8, scope: !2508)
!2514 = !DILocation(line: 508, column: 1, scope: !2508)
!2515 = distinct !DISubprogram(name: "worker15", linkageName: "_ZL8worker15Pv", scope: !3, file: !3, line: 509, type: !1830, scopeLine: 509, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !2516)
!2516 = !{!2517, !2518}
!2517 = !DILocalVariable(name: "arg", arg: 1, scope: !2515, file: !3, line: 509, type: !660)
!2518 = !DILocalVariable(name: "cb", scope: !2515, file: !3, line: 510, type: !653)
!2519 = !DILocation(line: 0, scope: !2515)
!2520 = !DILocation(line: 511, column: 9, scope: !2515)
!2521 = !DILocation(line: 511, column: 16, scope: !2515)
!2522 = !DILocation(line: 511, column: 5, scope: !2515)
!2523 = !DILocation(line: 512, column: 5, scope: !2515)
!2524 = distinct !DISubprogram(linkageName: "_GLOBAL__sub_I_sharing_patterns.cpp", scope: !3, file: !3, type: !2525, flags: DIFlagArtificial | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!2525 = !DISubroutineType(types: !142)
!2526 = !DILocation(line: 0, scope: !2524)
