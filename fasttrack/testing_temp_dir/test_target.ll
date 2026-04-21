; ModuleID = 'test.ll'
source_filename = "src/benchmark_load.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.SharedList = type { ptr, %union.pthread_rwlock_t }
%union.pthread_rwlock_t = type { %struct.__pthread_rwlock_arch_t }
%struct.__pthread_rwlock_arch_t = type { i32, i32, i32, i32, i32, i32, i32, i32, i8, [7 x i8], i64, i32 }
%struct.PackedCounters = type { [16 x i32] }
%struct.PaddedCounter = type { i32, [60 x i8] }
%class.anon = type { i8 }
%struct.PhaseA_Args = type { i32, i64, i64 }
%struct.RingQueue = type <{ [16384 x %struct.WorkItem], i32, i32, %union.pthread_mutex_t, %"struct.std::atomic.0", [4 x i8] }>
%struct.WorkItem = type { i32, i32, [56 x i8] }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%"struct.std::atomic.0" = type { %"struct.std::__atomic_base.1" }
%"struct.std::__atomic_base.1" = type { i32 }
%struct.PhaseB_ConsumerArgs = type { i32, i64, i64, i64 }
%struct.PhaseB_ProducerArgs = type { i32, i32, i64 }
%struct.PhaseC_Args = type { i32, i32, i32, i64, i64 }
%struct.PhaseD_Args = type { i32, i32, double, double }
%struct.timespec = type { i64, i64 }
%struct.ListNode = type { i32, i32, ptr }

$_ZSt3maxIiERKT_S2_S2_ = comdat any

$_ZNSt13__atomic_baseIlEaSEl = comdat any

$_ZStanSt12memory_orderSt23__memory_order_modifier = comdat any

@_ZL10G_NTHREADS = internal global i32 4, align 4, !dbg !0
@_ZL7G_SCALE = internal global i32 1, align 4, !dbg !570
@stderr = external global ptr, align 8
@.str = private unnamed_addr constant [16 x i8] c"max 16 threads\0A\00", align 1, !dbg !532
@.str.1 = private unnamed_addr constant [141 x i8] c"\0A\E2\95\94\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\97\0A\00", align 1, !dbg !538
@.str.2 = private unnamed_addr constant [55 x i8] c"\E2\95\91  benchmark_workload  \E2\80\94  sharing ratio test  \E2\95\91\0A\00", align 1, !dbg !543
@.str.3 = private unnamed_addr constant [53 x i8] c"\E2\95\91  threads=%-4d  scale=%-4d                   \E2\95\91\0A\00", align 1, !dbg !548
@.str.4 = private unnamed_addr constant [140 x i8] c"\E2\95\9A\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\9D\0A\00", align 1, !dbg !553
@.str.5 = private unnamed_addr constant [69 x i8] c"\0A\E2\94\80\E2\94\80 PHASE A  Private matrix multiply  (N=%d, threads=%d) \E2\94\80\E2\94\80\0A\00", align 1, !dbg !558
@.str.6 = private unnamed_addr constant [36 x i8] c"  private_accesses : %ld  (%.2f%%)\0A\00", align 1, !dbg !563
@.str.7 = private unnamed_addr constant [36 x i8] c"  shared_accesses  : %ld  (%.2f%%)\0A\00", align 1, !dbg !568
@_ZL10g_checksum = internal global { i64 } zeroinitializer, align 8, !dbg !572
@.str.9 = private unnamed_addr constant [84 x i8] c"\0A\E2\94\80\E2\94\80 PHASE B  Producer-consumer queue  (prod=%d, cons=%d, items=%d each) \E2\94\80\E2\94\80\0A\00", align 1, !dbg !577
@_ZL7g_queue = internal global ptr null, align 8, !dbg !594
@.str.10 = private unnamed_addr constant [27 x i8] c"  wall_ms          : %.1f\0A\00", align 1, !dbg !584
@.str.11 = private unnamed_addr constant [29 x i8] c"METRIC B %d %d %.1f %ld %ld\0A\00", align 1, !dbg !589
@.str.12 = private unnamed_addr constant [79 x i8] c"/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/atomic_base.h\00", align 1, !dbg !598
@__PRETTY_FUNCTION__._ZNKSt13__atomic_baseIiE4loadESt12memory_order = private unnamed_addr constant [74 x i8] c"__int_type std::__atomic_base<int>::load(memory_order) const [_ITp = int]\00", align 1, !dbg !603
@.str.13 = private unnamed_addr constant [28 x i8] c"__b != memory_order_release\00", align 1, !dbg !608
@.str.14 = private unnamed_addr constant [28 x i8] c"__b != memory_order_acq_rel\00", align 1, !dbg !615
@__PRETTY_FUNCTION__._ZNSt13__atomic_baseIiE5storeEiSt12memory_order = private unnamed_addr constant [75 x i8] c"void std::__atomic_base<int>::store(__int_type, memory_order) [_ITp = int]\00", align 1, !dbg !617
@.str.15 = private unnamed_addr constant [28 x i8] c"__b != memory_order_acquire\00", align 1, !dbg !622
@.str.16 = private unnamed_addr constant [28 x i8] c"__b != memory_order_consume\00", align 1, !dbg !626
@.str.17 = private unnamed_addr constant [77 x i8] c"\0A\E2\94\80\E2\94\80 PHASE C  RW-locked sorted list  (threads=%d, ins=%d, lkp=%d) \E2\94\80\E2\94\80\0A\00", align 1, !dbg !628
@_ZL6g_list = internal global %struct.SharedList zeroinitializer, align 8, !dbg !635
@.str.18 = private unnamed_addr constant [29 x i8] c"METRIC C %d %d %.1f %ld %ld\0A\00", align 1, !dbg !633
@.str.19 = private unnamed_addr constant [73 x i8] c"\0A\E2\94\80\E2\94\80 PHASE D  False-sharing benchmark  (threads=%d, iters=%d) \E2\94\80\E2\94\80\0A\00", align 1, !dbg !667
@_ZL8g_packed = internal global %struct.PackedCounters zeroinitializer, align 4, !dbg !690
@_ZL8g_padded = internal global [16 x %struct.PaddedCounter] zeroinitializer, align 64, !dbg !696
@.str.20 = private unnamed_addr constant [27 x i8] c"  packed_wall_ms   : %.1f\0A\00", align 1, !dbg !672
@.str.21 = private unnamed_addr constant [27 x i8] c"  padded_wall_ms   : %.1f\0A\00", align 1, !dbg !674
@.str.22 = private unnamed_addr constant [28 x i8] c"  speedup (padded) : %.2fx\0A\00", align 1, !dbg !676
@.str.23 = private unnamed_addr constant [64 x i8] c"  NOTE: both arrays ARE shared \E2\86\92 both should be instrumented\0A\00", align 1, !dbg !678
@.str.24 = private unnamed_addr constant [69 x i8] c"  NOTE: speedup collapse under instrumentation = overhead dominates\0A\00", align 1, !dbg !683
@.str.25 = private unnamed_addr constant [34 x i8] c"METRIC D %d %d %.1f+%.1f %ld %ld\0A\00", align 1, !dbg !685
@.str.26 = private unnamed_addr constant [183 x i8] c"\0A\E2\95\94\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\97\0A\00", align 1, !dbg !706
@.str.27 = private unnamed_addr constant [66 x i8] c"\E2\95\91              INSTRUMENTATION RATIO SUMMARY               \E2\95\91\0A\00", align 1, !dbg !711
@.str.28 = private unnamed_addr constant [182 x i8] c"\E2\95\A0\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\A3\0A\00", align 1, !dbg !716
@.str.29 = private unnamed_addr constant [72 x i8] c"\E2\95\91  Phase  \E2\94\82 Shared accesses \E2\94\82 Private accesses \E2\94\82  Ratio    \E2\95\91\0A\00", align 1, !dbg !721
@__const._ZL13print_summaryllllllll.pct = private unnamed_addr constant %class.anon undef, align 1
@.str.30 = private unnamed_addr constant [51 x i8] c"\E2\95\91  A      \E2\94\82 %15ld \E2\94\82 %16ld \E2\94\82 %5.2f%%   \E2\95\91\0A\00", align 1, !dbg !726
@.str.31 = private unnamed_addr constant [51 x i8] c"\E2\95\91  B      \E2\94\82 %15ld \E2\94\82 %16ld \E2\94\82 %5.2f%%   \E2\95\91\0A\00", align 1, !dbg !731
@.str.32 = private unnamed_addr constant [51 x i8] c"\E2\95\91  C      \E2\94\82 %15ld \E2\94\82 %16ld \E2\94\82 %5.2f%%   \E2\95\91\0A\00", align 1, !dbg !733
@.str.33 = private unnamed_addr constant [51 x i8] c"\E2\95\91  D      \E2\94\82 %15ld \E2\94\82 %16ld \E2\94\82 %5.2f%%   \E2\95\91\0A\00", align 1, !dbg !735
@.str.34 = private unnamed_addr constant [51 x i8] c"\E2\95\91  TOTAL  \E2\94\82 %15ld \E2\94\82 %16ld \E2\94\82 %5.2f%%   \E2\95\91\0A\00", align 1, !dbg !737
@.str.35 = private unnamed_addr constant [67 x i8] c"\E2\95\91  Max instrumentation reduction if sharing analysis        \E2\95\91\0A\00", align 1, !dbg !739
@.str.36 = private unnamed_addr constant [67 x i8] c"\E2\95\91  perfectly classifies private accesses:  %.1f%%           \E2\95\91\0A\00", align 1, !dbg !744
@.str.37 = private unnamed_addr constant [182 x i8] c"\E2\95\9A\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\90\E2\95\9D\0A\00", align 1, !dbg !746
@.str.38 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1, !dbg !748
@.str.39 = private unnamed_addr constant [17 x i8] c"INTERPRETATION:\0A\00", align 1, !dbg !753
@.str.40 = private unnamed_addr constant [58 x i8] c"  * 'Shared accesses' = accesses your detector MUST see.\0A\00", align 1, !dbg !758
@.str.41 = private unnamed_addr constant [61 x i8] c"  * 'Private accesses' = accesses analysis CAN safely skip.\0A\00", align 1, !dbg !763
@.str.42 = private unnamed_addr constant [68 x i8] c"  * Phase A has very low shared ratio \E2\86\92 large speedup potential.\0A\00", align 1, !dbg !768
@.str.43 = private unnamed_addr constant [68 x i8] c"  * Phase D is all shared \E2\86\92 no speedup possible; tests overhead.\0A\00", align 1, !dbg !773
@.str.44 = private unnamed_addr constant [70 x i8] c"  * Actual speedup = (1 - instrumented_frac) \C3\97 overhead_per_access.\0A\00", align 1, !dbg !775
@__PRETTY_FUNCTION__._ZNSt13__atomic_baseIlE5storeElSt12memory_order = private unnamed_addr constant [77 x i8] c"void std::__atomic_base<long>::store(__int_type, memory_order) [_ITp = long]\00", align 1, !dbg !780

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !1764 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca ptr, align 8
  %13 = alloca ptr, align 8
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i64, align 8
  %18 = alloca i64, align 8
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  %22 = alloca i64, align 8
  %23 = alloca i64, align 8
  %24 = alloca i32, align 4
  %25 = alloca i32, align 4
  %26 = alloca i64, align 8
  %27 = alloca i64, align 8
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
    #dbg_declare(ptr %4, !1768, !DIExpression(), !1769)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !1770, !DIExpression(), !1771)
  %28 = load i32, ptr %4, align 4, !dbg !1772
  %29 = icmp sgt i32 %28, 1, !dbg !1774
  br i1 %29, label %30, label %37, !dbg !1774

30:                                               ; preds = %2
  call void @__log_store(ptr %6), !dbg !1775
  store i32 1, ptr %6, align 4, !dbg !1775
  %31 = load ptr, ptr %5, align 8, !dbg !1776
  %32 = getelementptr inbounds ptr, ptr %31, i64 1, !dbg !1776
  call void @__log_load(ptr %32), !dbg !1776
  %33 = load ptr, ptr %32, align 8, !dbg !1776
  %34 = call i32 @atoi(ptr noundef %33) #9, !dbg !1777
  call void @__log_store(ptr %7), !dbg !1777
  store i32 %34, ptr %7, align 4, !dbg !1777
  %35 = call noundef nonnull align 4 dereferenceable(4) ptr @_ZSt3maxIiERKT_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %6, ptr noundef nonnull align 4 dereferenceable(4) %7) #10, !dbg !1778
  call void @__log_load(ptr %35), !dbg !1778
  %36 = load i32, ptr %35, align 4, !dbg !1778
  call void @__log_store(ptr @_ZL10G_NTHREADS), !dbg !1779
  store i32 %36, ptr @_ZL10G_NTHREADS, align 4, !dbg !1779
  br label %37, !dbg !1780

37:                                               ; preds = %30, %2
  %38 = load i32, ptr %4, align 4, !dbg !1781
  %39 = icmp sgt i32 %38, 2, !dbg !1783
  br i1 %39, label %40, label %47, !dbg !1783

40:                                               ; preds = %37
  call void @__log_store(ptr %8), !dbg !1784
  store i32 1, ptr %8, align 4, !dbg !1784
  %41 = load ptr, ptr %5, align 8, !dbg !1785
  %42 = getelementptr inbounds ptr, ptr %41, i64 2, !dbg !1785
  call void @__log_load(ptr %42), !dbg !1785
  %43 = load ptr, ptr %42, align 8, !dbg !1785
  %44 = call i32 @atoi(ptr noundef %43) #9, !dbg !1786
  call void @__log_store(ptr %9), !dbg !1786
  store i32 %44, ptr %9, align 4, !dbg !1786
  %45 = call noundef nonnull align 4 dereferenceable(4) ptr @_ZSt3maxIiERKT_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %8, ptr noundef nonnull align 4 dereferenceable(4) %9) #10, !dbg !1787
  call void @__log_load(ptr %45), !dbg !1787
  %46 = load i32, ptr %45, align 4, !dbg !1787
  call void @__log_store(ptr @_ZL7G_SCALE), !dbg !1788
  store i32 %46, ptr @_ZL7G_SCALE, align 4, !dbg !1788
  br label %47, !dbg !1789

47:                                               ; preds = %40, %37
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1790
  %48 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1790
  %49 = icmp sgt i32 %48, 16, !dbg !1792
  br i1 %49, label %50, label %53, !dbg !1792

50:                                               ; preds = %47
  call void @__log_load(ptr @stderr), !dbg !1793
  %51 = load ptr, ptr @stderr, align 8, !dbg !1793
  %52 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %51, ptr noundef @.str) #10, !dbg !1795
  call void @__log_store(ptr @_ZL10G_NTHREADS), !dbg !1796
  store i32 16, ptr @_ZL10G_NTHREADS, align 4, !dbg !1796
  br label %53, !dbg !1797

53:                                               ; preds = %50, %47
  %54 = call i32 (ptr, ...) @printf(ptr noundef @.str.1) #10, !dbg !1798
  %55 = call i32 (ptr, ...) @printf(ptr noundef @.str.2) #10, !dbg !1799
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1800
  %56 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1800
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !1801
  %57 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !1801
  %58 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i32 noundef %56, i32 noundef %57) #10, !dbg !1802
  %59 = call i32 (ptr, ...) @printf(ptr noundef @.str.4) #10, !dbg !1803
    #dbg_declare(ptr %10, !1804, !DIExpression(), !1805)
  store i64 0, ptr %10, align 8, !dbg !1805
    #dbg_declare(ptr %11, !1806, !DIExpression(), !1807)
  store i64 0, ptr %11, align 8, !dbg !1807
    #dbg_declare(ptr %12, !1808, !DIExpression(), !1810)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1811
  %60 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1811
  %61 = sext i32 %60 to i64, !dbg !1811
  %62 = call noalias ptr @calloc(i64 noundef %61, i64 noundef 24) #11, !dbg !1812
  store ptr %62, ptr %12, align 8, !dbg !1810
    #dbg_declare(ptr %13, !1813, !DIExpression(), !1814)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1815
  %63 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1815
  %64 = sext i32 %63 to i64, !dbg !1815
  %65 = mul i64 %64, 8, !dbg !1816
  %66 = call noalias ptr @malloc(i64 noundef %65) #11, !dbg !1817
  store ptr %66, ptr %13, align 8, !dbg !1814
  %67 = call noundef i64 @_ZNSt13__atomic_baseIlEaSEl(ptr noundef nonnull align 8 dereferenceable(8) @_ZL10g_checksum, i64 noundef 0) #11, !dbg !1818
    #dbg_declare(ptr %14, !1819, !DIExpression(), !1821)
  store i32 0, ptr %14, align 4, !dbg !1821
  br label %68, !dbg !1822

68:                                               ; preds = %88, %53
  %69 = load i32, ptr %14, align 4, !dbg !1823
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1825
  %70 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1825
  %71 = icmp slt i32 %69, %70, !dbg !1826
  br i1 %71, label %72, label %91, !dbg !1827

72:                                               ; preds = %68
  %73 = load i32, ptr %14, align 4, !dbg !1828
  %74 = load ptr, ptr %12, align 8, !dbg !1830
  %75 = load i32, ptr %14, align 4, !dbg !1831
  %76 = sext i32 %75 to i64, !dbg !1830
  %77 = getelementptr inbounds %struct.PhaseA_Args, ptr %74, i64 %76, !dbg !1830
  %78 = getelementptr inbounds nuw %struct.PhaseA_Args, ptr %77, i32 0, i32 0, !dbg !1832
  call void @__log_store(ptr %78), !dbg !1833
  store i32 %73, ptr %78, align 8, !dbg !1833
  %79 = load ptr, ptr %13, align 8, !dbg !1834
  %80 = load i32, ptr %14, align 4, !dbg !1835
  %81 = sext i32 %80 to i64, !dbg !1834
  %82 = getelementptr inbounds i64, ptr %79, i64 %81, !dbg !1834
  %83 = load ptr, ptr %12, align 8, !dbg !1836
  %84 = load i32, ptr %14, align 4, !dbg !1837
  %85 = sext i32 %84 to i64, !dbg !1836
  %86 = getelementptr inbounds %struct.PhaseA_Args, ptr %83, i64 %85, !dbg !1836
  %87 = call i32 @pthread_create(ptr noundef %82, ptr noundef null, ptr noundef @_ZL13phaseA_workerPv, ptr noundef %86) #11, !dbg !1838
  br label %88, !dbg !1839

88:                                               ; preds = %72
  %89 = load i32, ptr %14, align 4, !dbg !1840
  %90 = add nsw i32 %89, 1, !dbg !1840
  store i32 %90, ptr %14, align 4, !dbg !1840
  br label %68, !dbg !1841, !llvm.loop !1842

91:                                               ; preds = %68
    #dbg_declare(ptr %15, !1845, !DIExpression(), !1847)
  store i32 0, ptr %15, align 4, !dbg !1847
  br label %92, !dbg !1848

92:                                               ; preds = %103, %91
  %93 = load i32, ptr %15, align 4, !dbg !1849
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1851
  %94 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1851
  %95 = icmp slt i32 %93, %94, !dbg !1852
  br i1 %95, label %96, label %106, !dbg !1853

96:                                               ; preds = %92
  %97 = load ptr, ptr %13, align 8, !dbg !1854
  %98 = load i32, ptr %15, align 4, !dbg !1855
  %99 = sext i32 %98 to i64, !dbg !1854
  %100 = getelementptr inbounds i64, ptr %97, i64 %99, !dbg !1854
  call void @__log_load(ptr %100), !dbg !1854
  %101 = load i64, ptr %100, align 8, !dbg !1854
  %102 = call i32 @pthread_join(i64 noundef %101, ptr noundef null) #10, !dbg !1856
  br label %103, !dbg !1856

103:                                              ; preds = %96
  %104 = load i32, ptr %15, align 4, !dbg !1857
  %105 = add nsw i32 %104, 1, !dbg !1857
  store i32 %105, ptr %15, align 4, !dbg !1857
  br label %92, !dbg !1858, !llvm.loop !1859

106:                                              ; preds = %92
    #dbg_declare(ptr %16, !1861, !DIExpression(), !1863)
  store i32 0, ptr %16, align 4, !dbg !1863
  br label %107, !dbg !1864

107:                                              ; preds = %128, %106
  %108 = load i32, ptr %16, align 4, !dbg !1865
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1867
  %109 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1867
  %110 = icmp slt i32 %108, %109, !dbg !1868
  br i1 %110, label %111, label %131, !dbg !1869

111:                                              ; preds = %107
  %112 = load ptr, ptr %12, align 8, !dbg !1870
  %113 = load i32, ptr %16, align 4, !dbg !1872
  %114 = sext i32 %113 to i64, !dbg !1870
  %115 = getelementptr inbounds %struct.PhaseA_Args, ptr %112, i64 %114, !dbg !1870
  %116 = getelementptr inbounds nuw %struct.PhaseA_Args, ptr %115, i32 0, i32 2, !dbg !1873
  call void @__log_load(ptr %116), !dbg !1873
  %117 = load i64, ptr %116, align 8, !dbg !1873
  %118 = load i64, ptr %10, align 8, !dbg !1874
  %119 = add nsw i64 %118, %117, !dbg !1874
  store i64 %119, ptr %10, align 8, !dbg !1874
  %120 = load ptr, ptr %12, align 8, !dbg !1875
  %121 = load i32, ptr %16, align 4, !dbg !1876
  %122 = sext i32 %121 to i64, !dbg !1875
  %123 = getelementptr inbounds %struct.PhaseA_Args, ptr %120, i64 %122, !dbg !1875
  %124 = getelementptr inbounds nuw %struct.PhaseA_Args, ptr %123, i32 0, i32 1, !dbg !1877
  call void @__log_load(ptr %124), !dbg !1877
  %125 = load i64, ptr %124, align 8, !dbg !1877
  %126 = load i64, ptr %11, align 8, !dbg !1878
  %127 = add nsw i64 %126, %125, !dbg !1878
  store i64 %127, ptr %11, align 8, !dbg !1878
  br label %128, !dbg !1879

128:                                              ; preds = %111
  %129 = load i32, ptr %16, align 4, !dbg !1880
  %130 = add nsw i32 %129, 1, !dbg !1880
  store i32 %130, ptr %16, align 4, !dbg !1880
  br label %107, !dbg !1881, !llvm.loop !1882

131:                                              ; preds = %107
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !1884
  %132 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !1884
  %133 = mul nsw i32 128, %132, !dbg !1885
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1886
  %134 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1886
  %135 = call i32 (ptr, ...) @printf(ptr noundef @.str.5, i32 noundef %133, i32 noundef %134) #10, !dbg !1887
  %136 = load i64, ptr %11, align 8, !dbg !1888
  %137 = load i64, ptr %11, align 8, !dbg !1889
  %138 = sitofp i64 %137 to double, !dbg !1889
  %139 = fmul double 1.000000e+02, %138, !dbg !1890
  %140 = load i64, ptr %10, align 8, !dbg !1891
  %141 = load i64, ptr %11, align 8, !dbg !1892
  %142 = add nsw i64 %140, %141, !dbg !1893
  %143 = sitofp i64 %142 to double, !dbg !1894
  %144 = fdiv double %139, %143, !dbg !1895
  %145 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, i64 noundef %136, double noundef %144) #10, !dbg !1896
  %146 = load i64, ptr %10, align 8, !dbg !1897
  %147 = load i64, ptr %10, align 8, !dbg !1898
  %148 = sitofp i64 %147 to double, !dbg !1898
  %149 = fmul double 1.000000e+02, %148, !dbg !1899
  %150 = load i64, ptr %10, align 8, !dbg !1900
  %151 = load i64, ptr %11, align 8, !dbg !1901
  %152 = add nsw i64 %150, %151, !dbg !1902
  %153 = sitofp i64 %152 to double, !dbg !1903
  %154 = fdiv double %149, %153, !dbg !1904
  %155 = call i32 (ptr, ...) @printf(ptr noundef @.str.7, i64 noundef %146, double noundef %154) #10, !dbg !1905
  %156 = load ptr, ptr %12, align 8, !dbg !1906
  call void @free(ptr noundef %156) #11, !dbg !1907
  %157 = load ptr, ptr %13, align 8, !dbg !1908
  call void @free(ptr noundef %157) #11, !dbg !1909
  call void @_ZL11run_phase_Bv() #10, !dbg !1910
    #dbg_declare(ptr %17, !1911, !DIExpression(), !1912)
  store i64 0, ptr %17, align 8, !dbg !1912
    #dbg_declare(ptr %18, !1913, !DIExpression(), !1914)
  store i64 0, ptr %18, align 8, !dbg !1914
    #dbg_declare(ptr %19, !1915, !DIExpression(), !1917)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1918
  %158 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1918
  %159 = sdiv i32 %158, 2, !dbg !1919
  %160 = icmp sgt i32 %159, 0, !dbg !1920
  br i1 %160, label %161, label %164, !dbg !1918

161:                                              ; preds = %131
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1921
  %162 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1921
  %163 = sdiv i32 %162, 2, !dbg !1922
  br label %165, !dbg !1918

164:                                              ; preds = %131
  br label %165, !dbg !1918

165:                                              ; preds = %164, %161
  %166 = phi i32 [ %163, %161 ], [ 1, %164 ], !dbg !1918
  store i32 %166, ptr %19, align 4, !dbg !1917
    #dbg_declare(ptr %20, !1923, !DIExpression(), !1924)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1925
  %167 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1925
  %168 = load i32, ptr %19, align 4, !dbg !1926
  %169 = sub nsw i32 %167, %168, !dbg !1927
  store i32 %169, ptr %20, align 4, !dbg !1924
    #dbg_declare(ptr %21, !1928, !DIExpression(), !1929)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !1930
  %170 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !1930
  %171 = mul nsw i32 2000, %170, !dbg !1931
  store i32 %171, ptr %21, align 4, !dbg !1929
  %172 = load i32, ptr %19, align 4, !dbg !1932
  %173 = load i32, ptr %21, align 4, !dbg !1933
  %174 = mul nsw i32 %172, %173, !dbg !1934
  %175 = mul nsw i32 %174, 4, !dbg !1935
  %176 = sext i32 %175 to i64, !dbg !1936
  %177 = load i32, ptr %20, align 4, !dbg !1937
  %178 = load i32, ptr %21, align 4, !dbg !1938
  %179 = mul nsw i32 %177, %178, !dbg !1939
  %180 = mul nsw i32 %179, 5, !dbg !1940
  %181 = sext i32 %180 to i64, !dbg !1941
  %182 = add nsw i64 %176, %181, !dbg !1942
  store i64 %182, ptr %17, align 8, !dbg !1943
  %183 = load i32, ptr %20, align 4, !dbg !1944
  %184 = load i32, ptr %21, align 4, !dbg !1945
  %185 = mul nsw i32 %183, %184, !dbg !1946
  %186 = mul nsw i32 %185, 4096, !dbg !1947
  %187 = mul nsw i32 %186, 2, !dbg !1948
  %188 = sext i32 %187 to i64, !dbg !1949
  store i64 %188, ptr %18, align 8, !dbg !1950
  call void @_ZL11run_phase_Cv() #10, !dbg !1951
    #dbg_declare(ptr %22, !1952, !DIExpression(), !1953)
  store i64 0, ptr %22, align 8, !dbg !1953
    #dbg_declare(ptr %23, !1954, !DIExpression(), !1955)
  store i64 0, ptr %23, align 8, !dbg !1955
    #dbg_declare(ptr %24, !1956, !DIExpression(), !1958)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !1959
  %189 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !1959
  %190 = mul nsw i32 200, %189, !dbg !1960
  store i32 %190, ptr %24, align 4, !dbg !1958
    #dbg_declare(ptr %25, !1961, !DIExpression(), !1962)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !1963
  %191 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !1963
  %192 = mul nsw i32 2000, %191, !dbg !1964
  store i32 %192, ptr %25, align 4, !dbg !1962
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1965
  %193 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1965
  %194 = sext i32 %193 to i64, !dbg !1965
  %195 = load i32, ptr %24, align 4, !dbg !1966
  %196 = mul nsw i32 %195, 4, !dbg !1967
  %197 = load i32, ptr %25, align 4, !dbg !1968
  %198 = mul nsw i32 %197, 3, !dbg !1969
  %199 = add nsw i32 %196, %198, !dbg !1970
  %200 = sext i32 %199 to i64, !dbg !1971
  %201 = mul nsw i64 %194, %200, !dbg !1972
  store i64 %201, ptr %22, align 8, !dbg !1973
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1974
  %202 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1974
  %203 = sext i32 %202 to i64, !dbg !1974
  %204 = load i32, ptr %25, align 4, !dbg !1975
  %205 = sext i32 %204 to i64, !dbg !1975
  %206 = mul nsw i64 %203, %205, !dbg !1976
  %207 = mul nsw i64 %206, 2, !dbg !1977
  store i64 %207, ptr %23, align 8, !dbg !1978
  call void @_ZL11run_phase_Dv() #10, !dbg !1979
    #dbg_declare(ptr %26, !1980, !DIExpression(), !1981)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !1982
  %208 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !1982
  %209 = sext i32 %208 to i64, !dbg !1982
  %210 = mul nsw i64 %209, 10000000, !dbg !1983
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !1984
  %211 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !1984
  %212 = sext i32 %211 to i64, !dbg !1984
  %213 = mul nsw i64 %210, %212, !dbg !1985
  %214 = mul nsw i64 %213, 2, !dbg !1986
  store i64 %214, ptr %26, align 8, !dbg !1981
    #dbg_declare(ptr %27, !1987, !DIExpression(), !1988)
  store i64 0, ptr %27, align 8, !dbg !1988
  %215 = load i64, ptr %10, align 8, !dbg !1989
  %216 = load i64, ptr %11, align 8, !dbg !1990
  %217 = load i64, ptr %17, align 8, !dbg !1991
  %218 = load i64, ptr %18, align 8, !dbg !1992
  %219 = load i64, ptr %22, align 8, !dbg !1993
  %220 = load i64, ptr %23, align 8, !dbg !1994
  %221 = load i64, ptr %26, align 8, !dbg !1995
  %222 = load i64, ptr %27, align 8, !dbg !1996
  call void @_ZL13print_summaryllllllll(i64 noundef %215, i64 noundef %216, i64 noundef %217, i64 noundef %218, i64 noundef %219, i64 noundef %220, i64 noundef %221, i64 noundef %222) #10, !dbg !1997
  ret i32 0, !dbg !1998
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local noundef nonnull align 4 dereferenceable(4) ptr @_ZSt3maxIiERKT_S2_S2_(ptr noundef nonnull align 4 dereferenceable(4) %0, ptr noundef nonnull align 4 dereferenceable(4) %1) #1 comdat !dbg !1999 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !2004, !DIExpression(), !2006)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !2007, !DIExpression(), !2008)
  %6 = load ptr, ptr %4, align 8, !dbg !2009
  call void @__log_load(ptr %6), !dbg !2009
  %7 = load i32, ptr %6, align 4, !dbg !2009
  %8 = load ptr, ptr %5, align 8, !dbg !2011
  call void @__log_load(ptr %8), !dbg !2011
  %9 = load i32, ptr %8, align 4, !dbg !2011
  %10 = icmp slt i32 %7, %9, !dbg !2012
  br i1 %10, label %11, label %13, !dbg !2012

11:                                               ; preds = %2
  %12 = load ptr, ptr %5, align 8, !dbg !2013
  store ptr %12, ptr %3, align 8, !dbg !2014
  br label %15, !dbg !2014

13:                                               ; preds = %2
  %14 = load ptr, ptr %4, align 8, !dbg !2015
  store ptr %14, ptr %3, align 8, !dbg !2016
  br label %15, !dbg !2016

15:                                               ; preds = %13, %11
  %16 = load ptr, ptr %3, align 8, !dbg !2017
  ret ptr %16, !dbg !2017
}

; Function Attrs: nounwind willreturn memory(read)
declare i32 @atoi(ptr noundef) #2

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #3

declare i32 @printf(ptr noundef, ...) #3

; Function Attrs: nounwind
declare noalias ptr @calloc(i64 noundef, i64 noundef) #4

; Function Attrs: nounwind
declare noalias ptr @malloc(i64 noundef) #4

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local noundef i64 @_ZNSt13__atomic_baseIlEaSEl(ptr noundef nonnull align 8 dereferenceable(8) %0, i64 noundef %1) #1 comdat align 2 !dbg !2018 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i64, align 8
  store ptr %0, ptr %8, align 8
    #dbg_declare(ptr %8, !2019, !DIExpression(), !2021)
  store i64 %1, ptr %9, align 8
    #dbg_declare(ptr %9, !2022, !DIExpression(), !2023)
  %10 = load ptr, ptr %8, align 8
  %11 = load i64, ptr %9, align 8, !dbg !2024
  store ptr %10, ptr %3, align 8
    #dbg_declare(ptr %3, !2025, !DIExpression(), !2027)
  store i64 %11, ptr %4, align 8
    #dbg_declare(ptr %4, !2029, !DIExpression(), !2030)
  store i32 5, ptr %5, align 4
    #dbg_declare(ptr %5, !2031, !DIExpression(), !2032)
  %12 = load ptr, ptr %3, align 8
    #dbg_declare(ptr %6, !2033, !DIExpression(), !2034)
  %13 = load i32, ptr %5, align 4, !dbg !2035
  %14 = call noundef i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 noundef %13, i32 noundef 65535) #11, !dbg !2036
  store i32 %14, ptr %6, align 4, !dbg !2034
  %15 = load i32, ptr %6, align 4, !dbg !2037
  %16 = icmp ne i32 %15, 2, !dbg !2037
  %17 = xor i1 %16, true, !dbg !2037
  br i1 %17, label %18, label %19, !dbg !2037

18:                                               ; preds = %2
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 473, ptr noundef @__PRETTY_FUNCTION__._ZNSt13__atomic_baseIlE5storeElSt12memory_order, ptr noundef @.str.15) #12, !dbg !2037
  unreachable, !dbg !2037

19:                                               ; preds = %2
  %20 = load i32, ptr %6, align 4, !dbg !2040
  %21 = icmp ne i32 %20, 4, !dbg !2040
  %22 = xor i1 %21, true, !dbg !2040
  br i1 %22, label %23, label %24, !dbg !2040

23:                                               ; preds = %19
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 474, ptr noundef @__PRETTY_FUNCTION__._ZNSt13__atomic_baseIlE5storeElSt12memory_order, ptr noundef @.str.14) #12, !dbg !2040
  unreachable, !dbg !2040

24:                                               ; preds = %19
  %25 = load i32, ptr %6, align 4, !dbg !2043
  %26 = icmp ne i32 %25, 1, !dbg !2043
  %27 = xor i1 %26, true, !dbg !2043
  br i1 %27, label %28, label %29, !dbg !2043

28:                                               ; preds = %24
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 475, ptr noundef @__PRETTY_FUNCTION__._ZNSt13__atomic_baseIlE5storeElSt12memory_order, ptr noundef @.str.16) #12, !dbg !2043
  unreachable, !dbg !2043

29:                                               ; preds = %24
  %30 = load i32, ptr %5, align 4, !dbg !2046
  %31 = load i64, ptr %4, align 8, !dbg !2047
  store i64 %31, ptr %7, align 8, !dbg !2048
  switch i32 %30, label %32 [
    i32 3, label %34
    i32 5, label %36
  ], !dbg !2048

32:                                               ; preds = %29
  %33 = load i64, ptr %7, align 8, !dbg !2048
  call void @__log_store(ptr %12), !dbg !2048
  store atomic i64 %33, ptr %12 monotonic, align 8, !dbg !2048
  br label %38, !dbg !2048

34:                                               ; preds = %29
  %35 = load i64, ptr %7, align 8, !dbg !2048
  call void @__log_store(ptr %12), !dbg !2048
  store atomic i64 %35, ptr %12 release, align 8, !dbg !2048
  br label %38, !dbg !2048

36:                                               ; preds = %29
  %37 = load i64, ptr %7, align 8, !dbg !2048
  call void @__log_store(ptr %12), !dbg !2048
  store atomic i64 %37, ptr %12 seq_cst, align 8, !dbg !2048
  br label %38, !dbg !2048

38:                                               ; preds = %36, %34, %32
  %39 = load i64, ptr %9, align 8, !dbg !2049
  ret i64 %39, !dbg !2050
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #4

; Function Attrs: mustprogress noinline optnone uwtable
define internal noundef ptr @_ZL13phaseA_workerPv(ptr noundef %0) #5 !dbg !2051 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca ptr, align 8
  %13 = alloca i32, align 4
  %14 = alloca float, align 4
  %15 = alloca i32, align 4
  store ptr %0, ptr %7, align 8
    #dbg_declare(ptr %7, !2054, !DIExpression(), !2055)
    #dbg_declare(ptr %8, !2056, !DIExpression(), !2057)
  %16 = load ptr, ptr %7, align 8, !dbg !2058
  store ptr %16, ptr %8, align 8, !dbg !2057
    #dbg_declare(ptr %9, !2059, !DIExpression(), !2060)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2061
  %17 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2061
  %18 = mul nsw i32 128, %17, !dbg !2062
  store i32 %18, ptr %9, align 4, !dbg !2060
    #dbg_declare(ptr %10, !2063, !DIExpression(), !2064)
  %19 = load i32, ptr %9, align 4, !dbg !2065
  %20 = load i32, ptr %9, align 4, !dbg !2066
  %21 = mul nsw i32 %19, %20, !dbg !2067
  %22 = sext i32 %21 to i64, !dbg !2065
  %23 = call noalias ptr @calloc(i64 noundef %22, i64 noundef 4) #11, !dbg !2068
  store ptr %23, ptr %10, align 8, !dbg !2064
    #dbg_declare(ptr %11, !2069, !DIExpression(), !2070)
  %24 = load i32, ptr %9, align 4, !dbg !2071
  %25 = load i32, ptr %9, align 4, !dbg !2072
  %26 = mul nsw i32 %24, %25, !dbg !2073
  %27 = sext i32 %26 to i64, !dbg !2071
  %28 = call noalias ptr @calloc(i64 noundef %27, i64 noundef 4) #11, !dbg !2074
  store ptr %28, ptr %11, align 8, !dbg !2070
    #dbg_declare(ptr %12, !2075, !DIExpression(), !2076)
  %29 = load i32, ptr %9, align 4, !dbg !2077
  %30 = load i32, ptr %9, align 4, !dbg !2078
  %31 = mul nsw i32 %29, %30, !dbg !2079
  %32 = sext i32 %31 to i64, !dbg !2077
  %33 = call noalias ptr @calloc(i64 noundef %32, i64 noundef 4) #11, !dbg !2080
  store ptr %33, ptr %12, align 8, !dbg !2076
    #dbg_declare(ptr %13, !2081, !DIExpression(), !2083)
  store i32 0, ptr %13, align 4, !dbg !2083
  br label %34, !dbg !2084

34:                                               ; preds = %57, %1
  %35 = load i32, ptr %13, align 4, !dbg !2085
  %36 = load i32, ptr %9, align 4, !dbg !2087
  %37 = load i32, ptr %9, align 4, !dbg !2088
  %38 = mul nsw i32 %36, %37, !dbg !2089
  %39 = icmp slt i32 %35, %38, !dbg !2090
  br i1 %39, label %40, label %60, !dbg !2091

40:                                               ; preds = %34
  %41 = load i32, ptr %13, align 4, !dbg !2092
  %42 = srem i32 %41, 17, !dbg !2094
  %43 = sitofp i32 %42 to float, !dbg !2095
  %44 = fmul float %43, 0x3F847AE140000000, !dbg !2096
  %45 = load ptr, ptr %10, align 8, !dbg !2097
  %46 = load i32, ptr %13, align 4, !dbg !2098
  %47 = sext i32 %46 to i64, !dbg !2097
  %48 = getelementptr inbounds float, ptr %45, i64 %47, !dbg !2097
  call void @__log_store(ptr %48), !dbg !2099
  store float %44, ptr %48, align 4, !dbg !2099
  %49 = load i32, ptr %13, align 4, !dbg !2100
  %50 = srem i32 %49, 13, !dbg !2101
  %51 = sitofp i32 %50 to float, !dbg !2102
  %52 = fmul float %51, 0x3F847AE140000000, !dbg !2103
  %53 = load ptr, ptr %11, align 8, !dbg !2104
  %54 = load i32, ptr %13, align 4, !dbg !2105
  %55 = sext i32 %54 to i64, !dbg !2104
  %56 = getelementptr inbounds float, ptr %53, i64 %55, !dbg !2104
  call void @__log_store(ptr %56), !dbg !2106
  store float %52, ptr %56, align 4, !dbg !2106
  br label %57, !dbg !2107

57:                                               ; preds = %40
  %58 = load i32, ptr %13, align 4, !dbg !2108
  %59 = add nsw i32 %58, 1, !dbg !2108
  store i32 %59, ptr %13, align 4, !dbg !2108
  br label %34, !dbg !2109, !llvm.loop !2110

60:                                               ; preds = %34
  %61 = load ptr, ptr %10, align 8, !dbg !2112
  %62 = load ptr, ptr %11, align 8, !dbg !2113
  %63 = load ptr, ptr %12, align 8, !dbg !2114
  %64 = load i32, ptr %9, align 4, !dbg !2115
  call void @_ZL6matmulPKfS0_Pfi(ptr noundef %61, ptr noundef %62, ptr noundef %63, i32 noundef %64) #10, !dbg !2116
    #dbg_declare(ptr %14, !2117, !DIExpression(), !2118)
  store float 0.000000e+00, ptr %14, align 4, !dbg !2118
    #dbg_declare(ptr %15, !2119, !DIExpression(), !2121)
  store i32 0, ptr %15, align 4, !dbg !2121
  br label %65, !dbg !2122

65:                                               ; preds = %79, %60
  %66 = load i32, ptr %15, align 4, !dbg !2123
  %67 = load i32, ptr %9, align 4, !dbg !2125
  %68 = load i32, ptr %9, align 4, !dbg !2126
  %69 = mul nsw i32 %67, %68, !dbg !2127
  %70 = icmp slt i32 %66, %69, !dbg !2128
  br i1 %70, label %71, label %82, !dbg !2129

71:                                               ; preds = %65
  %72 = load ptr, ptr %12, align 8, !dbg !2130
  %73 = load i32, ptr %15, align 4, !dbg !2131
  %74 = sext i32 %73 to i64, !dbg !2130
  %75 = getelementptr inbounds float, ptr %72, i64 %74, !dbg !2130
  call void @__log_load(ptr %75), !dbg !2130
  %76 = load float, ptr %75, align 4, !dbg !2130
  %77 = load float, ptr %14, align 4, !dbg !2132
  %78 = fadd float %77, %76, !dbg !2132
  store float %78, ptr %14, align 4, !dbg !2132
  br label %79, !dbg !2133

79:                                               ; preds = %71
  %80 = load i32, ptr %15, align 4, !dbg !2134
  %81 = add nsw i32 %80, 1, !dbg !2134
  store i32 %81, ptr %15, align 4, !dbg !2134
  br label %65, !dbg !2135, !llvm.loop !2136

82:                                               ; preds = %65
  %83 = load float, ptr %14, align 4, !dbg !2138
  %84 = fmul float %83, 1.000000e+03, !dbg !2139
  %85 = fptosi float %84 to i64, !dbg !2140
  store ptr @_ZL10g_checksum, ptr %2, align 8
    #dbg_declare(ptr %2, !2141, !DIExpression(), !2143)
  store i64 %85, ptr %3, align 8
    #dbg_declare(ptr %3, !2145, !DIExpression(), !2146)
  store i32 0, ptr %4, align 4
    #dbg_declare(ptr %4, !2147, !DIExpression(), !2148)
  %86 = load ptr, ptr %2, align 8
  %87 = load i32, ptr %4, align 4, !dbg !2149
  %88 = load i64, ptr %3, align 8, !dbg !2150
  store i64 %88, ptr %5, align 8, !dbg !2151
  switch i32 %87, label %89 [
    i32 1, label %92
    i32 2, label %92
    i32 3, label %95
    i32 4, label %98
    i32 5, label %101
  ], !dbg !2151

89:                                               ; preds = %82
  %90 = load i64, ptr %5, align 8, !dbg !2151
  %91 = atomicrmw add ptr %86, i64 %90 monotonic, align 8, !dbg !2151
  store i64 %91, ptr %6, align 8, !dbg !2151
  br label %104, !dbg !2151

92:                                               ; preds = %82, %82
  %93 = load i64, ptr %5, align 8, !dbg !2151
  %94 = atomicrmw add ptr %86, i64 %93 acquire, align 8, !dbg !2151
  store i64 %94, ptr %6, align 8, !dbg !2151
  br label %104, !dbg !2151

95:                                               ; preds = %82
  %96 = load i64, ptr %5, align 8, !dbg !2151
  %97 = atomicrmw add ptr %86, i64 %96 release, align 8, !dbg !2151
  store i64 %97, ptr %6, align 8, !dbg !2151
  br label %104, !dbg !2151

98:                                               ; preds = %82
  %99 = load i64, ptr %5, align 8, !dbg !2151
  %100 = atomicrmw add ptr %86, i64 %99 acq_rel, align 8, !dbg !2151
  store i64 %100, ptr %6, align 8, !dbg !2151
  br label %104, !dbg !2151

101:                                              ; preds = %82
  %102 = load i64, ptr %5, align 8, !dbg !2151
  %103 = atomicrmw add ptr %86, i64 %102 seq_cst, align 8, !dbg !2151
  store i64 %103, ptr %6, align 8, !dbg !2151
  br label %104, !dbg !2151

104:                                              ; preds = %101, %98, %95, %92, %89
  %105 = load i64, ptr %6, align 8, !dbg !2151
  %106 = load i32, ptr %9, align 4, !dbg !2152
  %107 = sext i32 %106 to i64, !dbg !2152
  %108 = load i32, ptr %9, align 4, !dbg !2153
  %109 = sext i32 %108 to i64, !dbg !2153
  %110 = mul nsw i64 %107, %109, !dbg !2154
  %111 = load i32, ptr %9, align 4, !dbg !2155
  %112 = sext i32 %111 to i64, !dbg !2155
  %113 = mul nsw i64 %110, %112, !dbg !2156
  %114 = mul nsw i64 %113, 3, !dbg !2157
  %115 = load i32, ptr %9, align 4, !dbg !2158
  %116 = sext i32 %115 to i64, !dbg !2158
  %117 = load i32, ptr %9, align 4, !dbg !2159
  %118 = sext i32 %117 to i64, !dbg !2159
  %119 = mul nsw i64 %116, %118, !dbg !2160
  %120 = mul nsw i64 %119, 2, !dbg !2161
  %121 = add nsw i64 %114, %120, !dbg !2162
  %122 = load ptr, ptr %8, align 8, !dbg !2163
  %123 = getelementptr inbounds nuw %struct.PhaseA_Args, ptr %122, i32 0, i32 1, !dbg !2164
  call void @__log_store(ptr %123), !dbg !2165
  store i64 %121, ptr %123, align 8, !dbg !2165
  %124 = load ptr, ptr %8, align 8, !dbg !2166
  %125 = getelementptr inbounds nuw %struct.PhaseA_Args, ptr %124, i32 0, i32 2, !dbg !2167
  call void @__log_store(ptr %125), !dbg !2168
  store i64 1, ptr %125, align 8, !dbg !2168
  %126 = load ptr, ptr %10, align 8, !dbg !2169
  call void @free(ptr noundef %126) #11, !dbg !2170
  %127 = load ptr, ptr %11, align 8, !dbg !2171
  call void @free(ptr noundef %127) #11, !dbg !2172
  %128 = load ptr, ptr %12, align 8, !dbg !2173
  call void @free(ptr noundef %128) #11, !dbg !2174
  ret ptr null, !dbg !2175
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare void @free(ptr noundef) #4

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL11run_phase_Bv() #5 !dbg !2176 {
  %1 = alloca ptr, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca ptr, align 8
  %13 = alloca double, align 8
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca double, align 8
  %19 = alloca i64, align 8
  %20 = alloca i64, align 8
  %21 = alloca i32, align 4
  %22 = alloca i32, align 4
  %23 = alloca i64, align 8
    #dbg_declare(ptr %6, !2177, !DIExpression(), !2178)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2179
  %24 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2179
  %25 = sdiv i32 %24, 2, !dbg !2180
  %26 = icmp sgt i32 %25, 0, !dbg !2181
  br i1 %26, label %27, label %30, !dbg !2179

27:                                               ; preds = %0
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2182
  %28 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2182
  %29 = sdiv i32 %28, 2, !dbg !2183
  br label %31, !dbg !2179

30:                                               ; preds = %0
  br label %31, !dbg !2179

31:                                               ; preds = %30, %27
  %32 = phi i32 [ %29, %27 ], [ 1, %30 ], !dbg !2179
  store i32 %32, ptr %6, align 4, !dbg !2178
    #dbg_declare(ptr %7, !2184, !DIExpression(), !2185)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2186
  %33 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2186
  %34 = load i32, ptr %6, align 4, !dbg !2187
  %35 = sub nsw i32 %33, %34, !dbg !2188
  store i32 %35, ptr %7, align 4, !dbg !2185
    #dbg_declare(ptr %8, !2189, !DIExpression(), !2190)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2191
  %36 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2191
  %37 = mul nsw i32 2000, %36, !dbg !2192
  store i32 %37, ptr %8, align 4, !dbg !2190
  %38 = load i32, ptr %6, align 4, !dbg !2193
  %39 = load i32, ptr %7, align 4, !dbg !2194
  %40 = load i32, ptr %8, align 4, !dbg !2195
  %41 = call i32 (ptr, ...) @printf(ptr noundef @.str.9, i32 noundef %38, i32 noundef %39, i32 noundef %40) #10, !dbg !2196
  %42 = call noalias ptr @calloc(i64 noundef 1, i64 noundef 1048632) #11, !dbg !2197
  call void @__log_store(ptr @_ZL7g_queue), !dbg !2198
  store ptr %42, ptr @_ZL7g_queue, align 8, !dbg !2198
  call void @__log_load(ptr @_ZL7g_queue), !dbg !2199
  %43 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !2199
  %44 = getelementptr inbounds nuw %struct.RingQueue, ptr %43, i32 0, i32 3, !dbg !2200
  %45 = call i32 @pthread_mutex_init(ptr noundef %44, ptr noundef null) #11, !dbg !2201
  %46 = call noundef i64 @_ZNSt13__atomic_baseIlEaSEl(ptr noundef nonnull align 8 dereferenceable(8) @_ZL10g_checksum, i64 noundef 0) #11, !dbg !2202
    #dbg_declare(ptr %9, !2203, !DIExpression(), !2204)
  %47 = load i32, ptr %6, align 4, !dbg !2205
  %48 = sext i32 %47 to i64, !dbg !2205
  %49 = call noalias ptr @calloc(i64 noundef %48, i64 noundef 16) #11, !dbg !2206
  store ptr %49, ptr %9, align 8, !dbg !2204
    #dbg_declare(ptr %10, !2207, !DIExpression(), !2208)
  %50 = load i32, ptr %7, align 4, !dbg !2209
  %51 = sext i32 %50 to i64, !dbg !2209
  %52 = call noalias ptr @calloc(i64 noundef %51, i64 noundef 32) #11, !dbg !2210
  store ptr %52, ptr %10, align 8, !dbg !2208
    #dbg_declare(ptr %11, !2211, !DIExpression(), !2212)
  %53 = load i32, ptr %6, align 4, !dbg !2213
  %54 = sext i32 %53 to i64, !dbg !2213
  %55 = mul i64 %54, 8, !dbg !2214
  %56 = call noalias ptr @malloc(i64 noundef %55) #11, !dbg !2215
  store ptr %56, ptr %11, align 8, !dbg !2212
    #dbg_declare(ptr %12, !2216, !DIExpression(), !2217)
  %57 = load i32, ptr %7, align 4, !dbg !2218
  %58 = sext i32 %57 to i64, !dbg !2218
  %59 = mul i64 %58, 8, !dbg !2219
  %60 = call noalias ptr @malloc(i64 noundef %59) #11, !dbg !2220
  store ptr %60, ptr %12, align 8, !dbg !2217
    #dbg_declare(ptr %13, !2221, !DIExpression(), !2222)
  %61 = call noundef double @_ZL6now_msv() #10, !dbg !2223
  store double %61, ptr %13, align 8, !dbg !2222
    #dbg_declare(ptr %14, !2224, !DIExpression(), !2226)
  store i32 0, ptr %14, align 4, !dbg !2226
  br label %62, !dbg !2227

62:                                               ; preds = %82, %31
  %63 = load i32, ptr %14, align 4, !dbg !2228
  %64 = load i32, ptr %7, align 4, !dbg !2230
  %65 = icmp slt i32 %63, %64, !dbg !2231
  br i1 %65, label %66, label %85, !dbg !2232

66:                                               ; preds = %62
  %67 = load i32, ptr %14, align 4, !dbg !2233
  %68 = load ptr, ptr %10, align 8, !dbg !2235
  %69 = load i32, ptr %14, align 4, !dbg !2236
  %70 = sext i32 %69 to i64, !dbg !2235
  %71 = getelementptr inbounds %struct.PhaseB_ConsumerArgs, ptr %68, i64 %70, !dbg !2235
  %72 = getelementptr inbounds nuw %struct.PhaseB_ConsumerArgs, ptr %71, i32 0, i32 0, !dbg !2237
  call void @__log_store(ptr %72), !dbg !2238
  store i32 %67, ptr %72, align 8, !dbg !2238
  %73 = load ptr, ptr %12, align 8, !dbg !2239
  %74 = load i32, ptr %14, align 4, !dbg !2240
  %75 = sext i32 %74 to i64, !dbg !2239
  %76 = getelementptr inbounds i64, ptr %73, i64 %75, !dbg !2239
  %77 = load ptr, ptr %10, align 8, !dbg !2241
  %78 = load i32, ptr %14, align 4, !dbg !2242
  %79 = sext i32 %78 to i64, !dbg !2241
  %80 = getelementptr inbounds %struct.PhaseB_ConsumerArgs, ptr %77, i64 %79, !dbg !2241
  %81 = call i32 @pthread_create(ptr noundef %76, ptr noundef null, ptr noundef @_ZL15phaseB_consumerPv, ptr noundef %80) #11, !dbg !2243
  br label %82, !dbg !2244

82:                                               ; preds = %66
  %83 = load i32, ptr %14, align 4, !dbg !2245
  %84 = add nsw i32 %83, 1, !dbg !2245
  store i32 %84, ptr %14, align 4, !dbg !2245
  br label %62, !dbg !2246, !llvm.loop !2247

85:                                               ; preds = %62
    #dbg_declare(ptr %15, !2249, !DIExpression(), !2251)
  store i32 0, ptr %15, align 4, !dbg !2251
  br label %86, !dbg !2252

86:                                               ; preds = %112, %85
  %87 = load i32, ptr %15, align 4, !dbg !2253
  %88 = load i32, ptr %6, align 4, !dbg !2255
  %89 = icmp slt i32 %87, %88, !dbg !2256
  br i1 %89, label %90, label %115, !dbg !2257

90:                                               ; preds = %86
  %91 = load i32, ptr %15, align 4, !dbg !2258
  %92 = load ptr, ptr %9, align 8, !dbg !2260
  %93 = load i32, ptr %15, align 4, !dbg !2261
  %94 = sext i32 %93 to i64, !dbg !2260
  %95 = getelementptr inbounds %struct.PhaseB_ProducerArgs, ptr %92, i64 %94, !dbg !2260
  %96 = getelementptr inbounds nuw %struct.PhaseB_ProducerArgs, ptr %95, i32 0, i32 0, !dbg !2262
  call void @__log_store(ptr %96), !dbg !2263
  store i32 %91, ptr %96, align 8, !dbg !2263
  %97 = load i32, ptr %8, align 4, !dbg !2264
  %98 = load ptr, ptr %9, align 8, !dbg !2265
  %99 = load i32, ptr %15, align 4, !dbg !2266
  %100 = sext i32 %99 to i64, !dbg !2265
  %101 = getelementptr inbounds %struct.PhaseB_ProducerArgs, ptr %98, i64 %100, !dbg !2265
  %102 = getelementptr inbounds nuw %struct.PhaseB_ProducerArgs, ptr %101, i32 0, i32 1, !dbg !2267
  call void @__log_store(ptr %102), !dbg !2268
  store i32 %97, ptr %102, align 4, !dbg !2268
  %103 = load ptr, ptr %11, align 8, !dbg !2269
  %104 = load i32, ptr %15, align 4, !dbg !2270
  %105 = sext i32 %104 to i64, !dbg !2269
  %106 = getelementptr inbounds i64, ptr %103, i64 %105, !dbg !2269
  %107 = load ptr, ptr %9, align 8, !dbg !2271
  %108 = load i32, ptr %15, align 4, !dbg !2272
  %109 = sext i32 %108 to i64, !dbg !2271
  %110 = getelementptr inbounds %struct.PhaseB_ProducerArgs, ptr %107, i64 %109, !dbg !2271
  %111 = call i32 @pthread_create(ptr noundef %106, ptr noundef null, ptr noundef @_ZL15phaseB_producerPv, ptr noundef %110) #11, !dbg !2273
  br label %112, !dbg !2274

112:                                              ; preds = %90
  %113 = load i32, ptr %15, align 4, !dbg !2275
  %114 = add nsw i32 %113, 1, !dbg !2275
  store i32 %114, ptr %15, align 4, !dbg !2275
  br label %86, !dbg !2276, !llvm.loop !2277

115:                                              ; preds = %86
    #dbg_declare(ptr %16, !2279, !DIExpression(), !2281)
  store i32 0, ptr %16, align 4, !dbg !2281
  br label %116, !dbg !2282

116:                                              ; preds = %127, %115
  %117 = load i32, ptr %16, align 4, !dbg !2283
  %118 = load i32, ptr %6, align 4, !dbg !2285
  %119 = icmp slt i32 %117, %118, !dbg !2286
  br i1 %119, label %120, label %130, !dbg !2287

120:                                              ; preds = %116
  %121 = load ptr, ptr %11, align 8, !dbg !2288
  %122 = load i32, ptr %16, align 4, !dbg !2289
  %123 = sext i32 %122 to i64, !dbg !2288
  %124 = getelementptr inbounds i64, ptr %121, i64 %123, !dbg !2288
  call void @__log_load(ptr %124), !dbg !2288
  %125 = load i64, ptr %124, align 8, !dbg !2288
  %126 = call i32 @pthread_join(i64 noundef %125, ptr noundef null) #10, !dbg !2290
  br label %127, !dbg !2290

127:                                              ; preds = %120
  %128 = load i32, ptr %16, align 4, !dbg !2291
  %129 = add nsw i32 %128, 1, !dbg !2291
  store i32 %129, ptr %16, align 4, !dbg !2291
  br label %116, !dbg !2292, !llvm.loop !2293

130:                                              ; preds = %116
  call void @__log_load(ptr @_ZL7g_queue), !dbg !2295
  %131 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !2295
  %132 = getelementptr inbounds nuw %struct.RingQueue, ptr %131, i32 0, i32 4, !dbg !2296
  store ptr %132, ptr %1, align 8
    #dbg_declare(ptr %1, !2297, !DIExpression(), !2300)
  store i32 1, ptr %2, align 4
    #dbg_declare(ptr %2, !2302, !DIExpression(), !2303)
  store i32 3, ptr %3, align 4
    #dbg_declare(ptr %3, !2304, !DIExpression(), !2305)
  %133 = load ptr, ptr %1, align 8
    #dbg_declare(ptr %4, !2306, !DIExpression(), !2307)
  %134 = load i32, ptr %3, align 4, !dbg !2308
  %135 = call noundef i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 noundef %134, i32 noundef 65535) #11, !dbg !2309
  store i32 %135, ptr %4, align 4, !dbg !2307
  %136 = load i32, ptr %4, align 4, !dbg !2310
  %137 = icmp ne i32 %136, 2, !dbg !2310
  %138 = xor i1 %137, true, !dbg !2310
  br i1 %138, label %139, label %140, !dbg !2310

139:                                              ; preds = %130
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 473, ptr noundef @__PRETTY_FUNCTION__._ZNSt13__atomic_baseIiE5storeEiSt12memory_order, ptr noundef @.str.15) #12, !dbg !2310
  unreachable, !dbg !2310

140:                                              ; preds = %130
  %141 = load i32, ptr %4, align 4, !dbg !2313
  %142 = icmp ne i32 %141, 4, !dbg !2313
  %143 = xor i1 %142, true, !dbg !2313
  br i1 %143, label %144, label %145, !dbg !2313

144:                                              ; preds = %140
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 474, ptr noundef @__PRETTY_FUNCTION__._ZNSt13__atomic_baseIiE5storeEiSt12memory_order, ptr noundef @.str.14) #12, !dbg !2313
  unreachable, !dbg !2313

145:                                              ; preds = %140
  %146 = load i32, ptr %4, align 4, !dbg !2316
  %147 = icmp ne i32 %146, 1, !dbg !2316
  %148 = xor i1 %147, true, !dbg !2316
  br i1 %148, label %149, label %150, !dbg !2316

149:                                              ; preds = %145
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 475, ptr noundef @__PRETTY_FUNCTION__._ZNSt13__atomic_baseIiE5storeEiSt12memory_order, ptr noundef @.str.16) #12, !dbg !2316
  unreachable, !dbg !2316

150:                                              ; preds = %145
  %151 = load i32, ptr %3, align 4, !dbg !2319
  %152 = load i32, ptr %2, align 4, !dbg !2320
  store i32 %152, ptr %5, align 4, !dbg !2321
  switch i32 %151, label %153 [
    i32 3, label %155
    i32 5, label %157
  ], !dbg !2321

153:                                              ; preds = %150
  %154 = load i32, ptr %5, align 4, !dbg !2321
  call void @__log_store(ptr %133), !dbg !2321
  store atomic i32 %154, ptr %133 monotonic, align 4, !dbg !2321
  br label %159, !dbg !2321

155:                                              ; preds = %150
  %156 = load i32, ptr %5, align 4, !dbg !2321
  call void @__log_store(ptr %133), !dbg !2321
  store atomic i32 %156, ptr %133 release, align 4, !dbg !2321
  br label %159, !dbg !2321

157:                                              ; preds = %150
  %158 = load i32, ptr %5, align 4, !dbg !2321
  call void @__log_store(ptr %133), !dbg !2321
  store atomic i32 %158, ptr %133 seq_cst, align 4, !dbg !2321
  br label %159, !dbg !2321

159:                                              ; preds = %157, %155, %153
    #dbg_declare(ptr %17, !2322, !DIExpression(), !2324)
  store i32 0, ptr %17, align 4, !dbg !2324
  br label %160, !dbg !2325

160:                                              ; preds = %171, %159
  %161 = load i32, ptr %17, align 4, !dbg !2326
  %162 = load i32, ptr %7, align 4, !dbg !2328
  %163 = icmp slt i32 %161, %162, !dbg !2329
  br i1 %163, label %164, label %174, !dbg !2330

164:                                              ; preds = %160
  %165 = load ptr, ptr %12, align 8, !dbg !2331
  %166 = load i32, ptr %17, align 4, !dbg !2332
  %167 = sext i32 %166 to i64, !dbg !2331
  %168 = getelementptr inbounds i64, ptr %165, i64 %167, !dbg !2331
  call void @__log_load(ptr %168), !dbg !2331
  %169 = load i64, ptr %168, align 8, !dbg !2331
  %170 = call i32 @pthread_join(i64 noundef %169, ptr noundef null) #10, !dbg !2333
  br label %171, !dbg !2333

171:                                              ; preds = %164
  %172 = load i32, ptr %17, align 4, !dbg !2334
  %173 = add nsw i32 %172, 1, !dbg !2334
  store i32 %173, ptr %17, align 4, !dbg !2334
  br label %160, !dbg !2335, !llvm.loop !2336

174:                                              ; preds = %160
    #dbg_declare(ptr %18, !2338, !DIExpression(), !2339)
  %175 = call noundef double @_ZL6now_msv() #10, !dbg !2340
  %176 = load double, ptr %13, align 8, !dbg !2341
  %177 = fsub double %175, %176, !dbg !2342
  store double %177, ptr %18, align 8, !dbg !2339
    #dbg_declare(ptr %19, !2343, !DIExpression(), !2344)
  store i64 0, ptr %19, align 8, !dbg !2344
    #dbg_declare(ptr %20, !2345, !DIExpression(), !2346)
  store i64 0, ptr %20, align 8, !dbg !2346
    #dbg_declare(ptr %21, !2347, !DIExpression(), !2349)
  store i32 0, ptr %21, align 4, !dbg !2349
  br label %178, !dbg !2350

178:                                              ; preds = %191, %174
  %179 = load i32, ptr %21, align 4, !dbg !2351
  %180 = load i32, ptr %6, align 4, !dbg !2353
  %181 = icmp slt i32 %179, %180, !dbg !2354
  br i1 %181, label %182, label %194, !dbg !2355

182:                                              ; preds = %178
  %183 = load ptr, ptr %9, align 8, !dbg !2356
  %184 = load i32, ptr %21, align 4, !dbg !2357
  %185 = sext i32 %184 to i64, !dbg !2356
  %186 = getelementptr inbounds %struct.PhaseB_ProducerArgs, ptr %183, i64 %185, !dbg !2356
  %187 = getelementptr inbounds nuw %struct.PhaseB_ProducerArgs, ptr %186, i32 0, i32 2, !dbg !2358
  call void @__log_load(ptr %187), !dbg !2358
  %188 = load i64, ptr %187, align 8, !dbg !2358
  %189 = load i64, ptr %20, align 8, !dbg !2359
  %190 = add nsw i64 %189, %188, !dbg !2359
  store i64 %190, ptr %20, align 8, !dbg !2359
  br label %191, !dbg !2360

191:                                              ; preds = %182
  %192 = load i32, ptr %21, align 4, !dbg !2361
  %193 = add nsw i32 %192, 1, !dbg !2361
  store i32 %193, ptr %21, align 4, !dbg !2361
  br label %178, !dbg !2362, !llvm.loop !2363

194:                                              ; preds = %178
    #dbg_declare(ptr %22, !2365, !DIExpression(), !2367)
  store i32 0, ptr %22, align 4, !dbg !2367
  br label %195, !dbg !2368

195:                                              ; preds = %216, %194
  %196 = load i32, ptr %22, align 4, !dbg !2369
  %197 = load i32, ptr %7, align 4, !dbg !2371
  %198 = icmp slt i32 %196, %197, !dbg !2372
  br i1 %198, label %199, label %219, !dbg !2373

199:                                              ; preds = %195
  %200 = load ptr, ptr %10, align 8, !dbg !2374
  %201 = load i32, ptr %22, align 4, !dbg !2376
  %202 = sext i32 %201 to i64, !dbg !2374
  %203 = getelementptr inbounds %struct.PhaseB_ConsumerArgs, ptr %200, i64 %202, !dbg !2374
  %204 = getelementptr inbounds nuw %struct.PhaseB_ConsumerArgs, ptr %203, i32 0, i32 2, !dbg !2377
  call void @__log_load(ptr %204), !dbg !2377
  %205 = load i64, ptr %204, align 8, !dbg !2377
  %206 = load i64, ptr %19, align 8, !dbg !2378
  %207 = add nsw i64 %206, %205, !dbg !2378
  store i64 %207, ptr %19, align 8, !dbg !2378
  %208 = load ptr, ptr %10, align 8, !dbg !2379
  %209 = load i32, ptr %22, align 4, !dbg !2380
  %210 = sext i32 %209 to i64, !dbg !2379
  %211 = getelementptr inbounds %struct.PhaseB_ConsumerArgs, ptr %208, i64 %210, !dbg !2379
  %212 = getelementptr inbounds nuw %struct.PhaseB_ConsumerArgs, ptr %211, i32 0, i32 3, !dbg !2381
  call void @__log_load(ptr %212), !dbg !2381
  %213 = load i64, ptr %212, align 8, !dbg !2381
  %214 = load i64, ptr %20, align 8, !dbg !2382
  %215 = add nsw i64 %214, %213, !dbg !2382
  store i64 %215, ptr %20, align 8, !dbg !2382
  br label %216, !dbg !2383

216:                                              ; preds = %199
  %217 = load i32, ptr %22, align 4, !dbg !2384
  %218 = add nsw i32 %217, 1, !dbg !2384
  store i32 %218, ptr %22, align 4, !dbg !2384
  br label %195, !dbg !2385, !llvm.loop !2386

219:                                              ; preds = %195
    #dbg_declare(ptr %23, !2388, !DIExpression(), !2389)
  %220 = load i64, ptr %19, align 8, !dbg !2390
  %221 = load i64, ptr %20, align 8, !dbg !2391
  %222 = add nsw i64 %220, %221, !dbg !2392
  store i64 %222, ptr %23, align 8, !dbg !2389
  %223 = load double, ptr %18, align 8, !dbg !2393
  %224 = call i32 (ptr, ...) @printf(ptr noundef @.str.10, double noundef %223) #10, !dbg !2394
  %225 = load i64, ptr %19, align 8, !dbg !2395
  %226 = load i64, ptr %19, align 8, !dbg !2396
  %227 = sitofp i64 %226 to double, !dbg !2396
  %228 = fmul double 1.000000e+02, %227, !dbg !2397
  %229 = load i64, ptr %23, align 8, !dbg !2398
  %230 = sitofp i64 %229 to double, !dbg !2398
  %231 = fdiv double %228, %230, !dbg !2399
  %232 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, i64 noundef %225, double noundef %231) #10, !dbg !2400
  %233 = load i64, ptr %20, align 8, !dbg !2401
  %234 = load i64, ptr %20, align 8, !dbg !2402
  %235 = sitofp i64 %234 to double, !dbg !2402
  %236 = fmul double 1.000000e+02, %235, !dbg !2403
  %237 = load i64, ptr %23, align 8, !dbg !2404
  %238 = sitofp i64 %237 to double, !dbg !2404
  %239 = fdiv double %236, %238, !dbg !2405
  %240 = call i32 (ptr, ...) @printf(ptr noundef @.str.7, i64 noundef %233, double noundef %239) #10, !dbg !2406
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2407
  %241 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2407
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2408
  %242 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2408
  %243 = load double, ptr %18, align 8, !dbg !2409
  %244 = load i64, ptr %20, align 8, !dbg !2410
  %245 = load i64, ptr %19, align 8, !dbg !2411
  %246 = call i32 (ptr, ...) @printf(ptr noundef @.str.11, i32 noundef %241, i32 noundef %242, double noundef %243, i64 noundef %244, i64 noundef %245) #10, !dbg !2412
  call void @__log_load(ptr @_ZL7g_queue), !dbg !2413
  %247 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !2413
  %248 = getelementptr inbounds nuw %struct.RingQueue, ptr %247, i32 0, i32 3, !dbg !2414
  %249 = call i32 @pthread_mutex_destroy(ptr noundef %248) #11, !dbg !2415
  call void @__log_load(ptr @_ZL7g_queue), !dbg !2416
  %250 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !2416
  call void @free(ptr noundef %250) #11, !dbg !2417
  %251 = load ptr, ptr %9, align 8, !dbg !2418
  call void @free(ptr noundef %251) #11, !dbg !2419
  %252 = load ptr, ptr %10, align 8, !dbg !2420
  call void @free(ptr noundef %252) #11, !dbg !2421
  %253 = load ptr, ptr %11, align 8, !dbg !2422
  call void @free(ptr noundef %253) #11, !dbg !2423
  %254 = load ptr, ptr %12, align 8, !dbg !2424
  call void @free(ptr noundef %254) #11, !dbg !2425
  ret void, !dbg !2426
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL11run_phase_Cv() #5 !dbg !2427 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca double, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca i32, align 4
  %12 = alloca i64, align 8
    #dbg_declare(ptr %1, !2428, !DIExpression(), !2429)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2430
  %13 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2430
  %14 = mul nsw i32 200, %13, !dbg !2431
  store i32 %14, ptr %1, align 4, !dbg !2429
    #dbg_declare(ptr %2, !2432, !DIExpression(), !2433)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2434
  %15 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2434
  %16 = mul nsw i32 2000, %15, !dbg !2435
  store i32 %16, ptr %2, align 4, !dbg !2433
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2436
  %17 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2436
  %18 = load i32, ptr %1, align 4, !dbg !2437
  %19 = load i32, ptr %2, align 4, !dbg !2438
  %20 = call i32 (ptr, ...) @printf(ptr noundef @.str.17, i32 noundef %17, i32 noundef %18, i32 noundef %19) #10, !dbg !2439
  call void @__log_store(ptr @_ZL6g_list), !dbg !2440
  store ptr null, ptr @_ZL6g_list, align 8, !dbg !2440
  %21 = call i32 @pthread_rwlock_init(ptr noundef getelementptr inbounds nuw (%struct.SharedList, ptr @_ZL6g_list, i32 0, i32 1), ptr noundef null) #11, !dbg !2441
  %22 = call noundef i64 @_ZNSt13__atomic_baseIlEaSEl(ptr noundef nonnull align 8 dereferenceable(8) @_ZL10g_checksum, i64 noundef 0) #11, !dbg !2442
    #dbg_declare(ptr %3, !2443, !DIExpression(), !2444)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2445
  %23 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2445
  %24 = sext i32 %23 to i64, !dbg !2445
  %25 = call noalias ptr @calloc(i64 noundef %24, i64 noundef 32) #11, !dbg !2446
  store ptr %25, ptr %3, align 8, !dbg !2444
    #dbg_declare(ptr %4, !2447, !DIExpression(), !2448)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2449
  %26 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2449
  %27 = sext i32 %26 to i64, !dbg !2449
  %28 = mul i64 %27, 8, !dbg !2450
  %29 = call noalias ptr @malloc(i64 noundef %28) #11, !dbg !2451
  store ptr %29, ptr %4, align 8, !dbg !2448
    #dbg_declare(ptr %5, !2452, !DIExpression(), !2453)
  %30 = call noundef double @_ZL6now_msv() #10, !dbg !2454
  store double %30, ptr %5, align 8, !dbg !2453
    #dbg_declare(ptr %6, !2455, !DIExpression(), !2457)
  store i32 0, ptr %6, align 4, !dbg !2457
  br label %31, !dbg !2458

31:                                               ; preds = %63, %0
  %32 = load i32, ptr %6, align 4, !dbg !2459
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2461
  %33 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2461
  %34 = icmp slt i32 %32, %33, !dbg !2462
  br i1 %34, label %35, label %66, !dbg !2463

35:                                               ; preds = %31
  %36 = load i32, ptr %6, align 4, !dbg !2464
  %37 = load ptr, ptr %3, align 8, !dbg !2466
  %38 = load i32, ptr %6, align 4, !dbg !2467
  %39 = sext i32 %38 to i64, !dbg !2466
  %40 = getelementptr inbounds %struct.PhaseC_Args, ptr %37, i64 %39, !dbg !2466
  %41 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %40, i32 0, i32 0, !dbg !2468
  call void @__log_store(ptr %41), !dbg !2469
  store i32 %36, ptr %41, align 8, !dbg !2469
  %42 = load i32, ptr %1, align 4, !dbg !2470
  %43 = load ptr, ptr %3, align 8, !dbg !2471
  %44 = load i32, ptr %6, align 4, !dbg !2472
  %45 = sext i32 %44 to i64, !dbg !2471
  %46 = getelementptr inbounds %struct.PhaseC_Args, ptr %43, i64 %45, !dbg !2471
  %47 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %46, i32 0, i32 1, !dbg !2473
  call void @__log_store(ptr %47), !dbg !2474
  store i32 %42, ptr %47, align 4, !dbg !2474
  %48 = load i32, ptr %2, align 4, !dbg !2475
  %49 = load ptr, ptr %3, align 8, !dbg !2476
  %50 = load i32, ptr %6, align 4, !dbg !2477
  %51 = sext i32 %50 to i64, !dbg !2476
  %52 = getelementptr inbounds %struct.PhaseC_Args, ptr %49, i64 %51, !dbg !2476
  %53 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %52, i32 0, i32 2, !dbg !2478
  call void @__log_store(ptr %53), !dbg !2479
  store i32 %48, ptr %53, align 8, !dbg !2479
  %54 = load ptr, ptr %4, align 8, !dbg !2480
  %55 = load i32, ptr %6, align 4, !dbg !2481
  %56 = sext i32 %55 to i64, !dbg !2480
  %57 = getelementptr inbounds i64, ptr %54, i64 %56, !dbg !2480
  %58 = load ptr, ptr %3, align 8, !dbg !2482
  %59 = load i32, ptr %6, align 4, !dbg !2483
  %60 = sext i32 %59 to i64, !dbg !2482
  %61 = getelementptr inbounds %struct.PhaseC_Args, ptr %58, i64 %60, !dbg !2482
  %62 = call i32 @pthread_create(ptr noundef %57, ptr noundef null, ptr noundef @_ZL13phaseC_workerPv, ptr noundef %61) #11, !dbg !2484
  br label %63, !dbg !2485

63:                                               ; preds = %35
  %64 = load i32, ptr %6, align 4, !dbg !2486
  %65 = add nsw i32 %64, 1, !dbg !2486
  store i32 %65, ptr %6, align 4, !dbg !2486
  br label %31, !dbg !2487, !llvm.loop !2488

66:                                               ; preds = %31
    #dbg_declare(ptr %7, !2490, !DIExpression(), !2492)
  store i32 0, ptr %7, align 4, !dbg !2492
  br label %67, !dbg !2493

67:                                               ; preds = %78, %66
  %68 = load i32, ptr %7, align 4, !dbg !2494
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2496
  %69 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2496
  %70 = icmp slt i32 %68, %69, !dbg !2497
  br i1 %70, label %71, label %81, !dbg !2498

71:                                               ; preds = %67
  %72 = load ptr, ptr %4, align 8, !dbg !2499
  %73 = load i32, ptr %7, align 4, !dbg !2500
  %74 = sext i32 %73 to i64, !dbg !2499
  %75 = getelementptr inbounds i64, ptr %72, i64 %74, !dbg !2499
  call void @__log_load(ptr %75), !dbg !2499
  %76 = load i64, ptr %75, align 8, !dbg !2499
  %77 = call i32 @pthread_join(i64 noundef %76, ptr noundef null) #10, !dbg !2501
  br label %78, !dbg !2501

78:                                               ; preds = %71
  %79 = load i32, ptr %7, align 4, !dbg !2502
  %80 = add nsw i32 %79, 1, !dbg !2502
  store i32 %80, ptr %7, align 4, !dbg !2502
  br label %67, !dbg !2503, !llvm.loop !2504

81:                                               ; preds = %67
    #dbg_declare(ptr %8, !2506, !DIExpression(), !2507)
  %82 = call noundef double @_ZL6now_msv() #10, !dbg !2508
  %83 = load double, ptr %5, align 8, !dbg !2509
  %84 = fsub double %82, %83, !dbg !2510
  store double %84, ptr %8, align 8, !dbg !2507
    #dbg_declare(ptr %9, !2511, !DIExpression(), !2512)
  store i64 0, ptr %9, align 8, !dbg !2512
    #dbg_declare(ptr %10, !2513, !DIExpression(), !2514)
  store i64 0, ptr %10, align 8, !dbg !2514
    #dbg_declare(ptr %11, !2515, !DIExpression(), !2517)
  store i32 0, ptr %11, align 4, !dbg !2517
  br label %85, !dbg !2518

85:                                               ; preds = %106, %81
  %86 = load i32, ptr %11, align 4, !dbg !2519
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2521
  %87 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2521
  %88 = icmp slt i32 %86, %87, !dbg !2522
  br i1 %88, label %89, label %109, !dbg !2523

89:                                               ; preds = %85
  %90 = load ptr, ptr %3, align 8, !dbg !2524
  %91 = load i32, ptr %11, align 4, !dbg !2526
  %92 = sext i32 %91 to i64, !dbg !2524
  %93 = getelementptr inbounds %struct.PhaseC_Args, ptr %90, i64 %92, !dbg !2524
  %94 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %93, i32 0, i32 4, !dbg !2527
  call void @__log_load(ptr %94), !dbg !2527
  %95 = load i64, ptr %94, align 8, !dbg !2527
  %96 = load i64, ptr %9, align 8, !dbg !2528
  %97 = add nsw i64 %96, %95, !dbg !2528
  store i64 %97, ptr %9, align 8, !dbg !2528
  %98 = load ptr, ptr %3, align 8, !dbg !2529
  %99 = load i32, ptr %11, align 4, !dbg !2530
  %100 = sext i32 %99 to i64, !dbg !2529
  %101 = getelementptr inbounds %struct.PhaseC_Args, ptr %98, i64 %100, !dbg !2529
  %102 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %101, i32 0, i32 3, !dbg !2531
  call void @__log_load(ptr %102), !dbg !2531
  %103 = load i64, ptr %102, align 8, !dbg !2531
  %104 = load i64, ptr %10, align 8, !dbg !2532
  %105 = add nsw i64 %104, %103, !dbg !2532
  store i64 %105, ptr %10, align 8, !dbg !2532
  br label %106, !dbg !2533

106:                                              ; preds = %89
  %107 = load i32, ptr %11, align 4, !dbg !2534
  %108 = add nsw i32 %107, 1, !dbg !2534
  store i32 %108, ptr %11, align 4, !dbg !2534
  br label %85, !dbg !2535, !llvm.loop !2536

109:                                              ; preds = %85
    #dbg_declare(ptr %12, !2538, !DIExpression(), !2539)
  %110 = load i64, ptr %9, align 8, !dbg !2540
  %111 = load i64, ptr %10, align 8, !dbg !2541
  %112 = add nsw i64 %110, %111, !dbg !2542
  store i64 %112, ptr %12, align 8, !dbg !2539
  %113 = load double, ptr %8, align 8, !dbg !2543
  %114 = call i32 (ptr, ...) @printf(ptr noundef @.str.10, double noundef %113) #10, !dbg !2544
  %115 = load i64, ptr %9, align 8, !dbg !2545
  %116 = load i64, ptr %9, align 8, !dbg !2546
  %117 = sitofp i64 %116 to double, !dbg !2546
  %118 = fmul double 1.000000e+02, %117, !dbg !2547
  %119 = load i64, ptr %12, align 8, !dbg !2548
  %120 = sitofp i64 %119 to double, !dbg !2548
  %121 = fdiv double %118, %120, !dbg !2549
  %122 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, i64 noundef %115, double noundef %121) #10, !dbg !2550
  %123 = load i64, ptr %10, align 8, !dbg !2551
  %124 = load i64, ptr %10, align 8, !dbg !2552
  %125 = sitofp i64 %124 to double, !dbg !2552
  %126 = fmul double 1.000000e+02, %125, !dbg !2553
  %127 = load i64, ptr %12, align 8, !dbg !2554
  %128 = sitofp i64 %127 to double, !dbg !2554
  %129 = fdiv double %126, %128, !dbg !2555
  %130 = call i32 (ptr, ...) @printf(ptr noundef @.str.7, i64 noundef %123, double noundef %129) #10, !dbg !2556
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2557
  %131 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2557
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2558
  %132 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2558
  %133 = load double, ptr %8, align 8, !dbg !2559
  %134 = load i64, ptr %10, align 8, !dbg !2560
  %135 = load i64, ptr %9, align 8, !dbg !2561
  %136 = call i32 (ptr, ...) @printf(ptr noundef @.str.18, i32 noundef %131, i32 noundef %132, double noundef %133, i64 noundef %134, i64 noundef %135) #10, !dbg !2562
  call void @_ZL12list_destroyP10SharedList(ptr noundef @_ZL6g_list) #10, !dbg !2563
  %137 = call i32 @pthread_rwlock_destroy(ptr noundef getelementptr inbounds nuw (%struct.SharedList, ptr @_ZL6g_list, i32 0, i32 1)) #11, !dbg !2564
  %138 = load ptr, ptr %3, align 8, !dbg !2565
  call void @free(ptr noundef %138) #11, !dbg !2566
  %139 = load ptr, ptr %4, align 8, !dbg !2567
  call void @free(ptr noundef %139) #11, !dbg !2568
  ret void, !dbg !2569
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL11run_phase_Dv() #5 !dbg !2570 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca double, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca double, align 8
  %12 = alloca i64, align 8
  %13 = alloca i64, align 8
    #dbg_declare(ptr %1, !2571, !DIExpression(), !2572)
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2573
  %14 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2573
  %15 = mul nsw i32 10000000, %14, !dbg !2574
  store i32 %15, ptr %1, align 4, !dbg !2572
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2575
  %16 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2575
  %17 = load i32, ptr %1, align 4, !dbg !2576
  %18 = call i32 (ptr, ...) @printf(ptr noundef @.str.19, i32 noundef %16, i32 noundef %17) #10, !dbg !2577
    #dbg_declare(ptr %2, !2578, !DIExpression(), !2579)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2580
  %19 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2580
  %20 = sext i32 %19 to i64, !dbg !2580
  %21 = call noalias ptr @calloc(i64 noundef %20, i64 noundef 24) #11, !dbg !2581
  store ptr %21, ptr %2, align 8, !dbg !2579
    #dbg_declare(ptr %3, !2582, !DIExpression(), !2583)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2584
  %22 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2584
  %23 = sext i32 %22 to i64, !dbg !2584
  %24 = mul i64 %23, 8, !dbg !2585
  %25 = call noalias ptr @malloc(i64 noundef %24) #11, !dbg !2586
  store ptr %25, ptr %3, align 8, !dbg !2583
  %26 = call ptr @memset(ptr noundef @_ZL8g_packed, i32 noundef 0, i64 noundef 64) #11, !dbg !2587
  %27 = call ptr @memset(ptr noundef @_ZL8g_padded, i32 noundef 0, i64 noundef 1024) #11, !dbg !2588
    #dbg_declare(ptr %4, !2589, !DIExpression(), !2591)
  store i32 0, ptr %4, align 4, !dbg !2591
  br label %28, !dbg !2592

28:                                               ; preds = %45, %0
  %29 = load i32, ptr %4, align 4, !dbg !2593
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2595
  %30 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2595
  %31 = icmp slt i32 %29, %30, !dbg !2596
  br i1 %31, label %32, label %48, !dbg !2597

32:                                               ; preds = %28
  %33 = load i32, ptr %4, align 4, !dbg !2598
  %34 = load ptr, ptr %2, align 8, !dbg !2600
  %35 = load i32, ptr %4, align 4, !dbg !2601
  %36 = sext i32 %35 to i64, !dbg !2600
  %37 = getelementptr inbounds %struct.PhaseD_Args, ptr %34, i64 %36, !dbg !2600
  %38 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %37, i32 0, i32 0, !dbg !2602
  call void @__log_store(ptr %38), !dbg !2603
  store i32 %33, ptr %38, align 8, !dbg !2603
  %39 = load i32, ptr %1, align 4, !dbg !2604
  %40 = load ptr, ptr %2, align 8, !dbg !2605
  %41 = load i32, ptr %4, align 4, !dbg !2606
  %42 = sext i32 %41 to i64, !dbg !2605
  %43 = getelementptr inbounds %struct.PhaseD_Args, ptr %40, i64 %42, !dbg !2605
  %44 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %43, i32 0, i32 1, !dbg !2607
  call void @__log_store(ptr %44), !dbg !2608
  store i32 %39, ptr %44, align 4, !dbg !2608
  br label %45, !dbg !2609

45:                                               ; preds = %32
  %46 = load i32, ptr %4, align 4, !dbg !2610
  %47 = add nsw i32 %46, 1, !dbg !2610
  store i32 %47, ptr %4, align 4, !dbg !2610
  br label %28, !dbg !2611, !llvm.loop !2612

48:                                               ; preds = %28
    #dbg_declare(ptr %5, !2614, !DIExpression(), !2615)
  %49 = call noundef double @_ZL6now_msv() #10, !dbg !2616
  store double %49, ptr %5, align 8, !dbg !2615
    #dbg_declare(ptr %6, !2617, !DIExpression(), !2619)
  store i32 0, ptr %6, align 4, !dbg !2619
  br label %50, !dbg !2620

50:                                               ; preds = %64, %48
  %51 = load i32, ptr %6, align 4, !dbg !2621
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2623
  %52 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2623
  %53 = icmp slt i32 %51, %52, !dbg !2624
  br i1 %53, label %54, label %67, !dbg !2625

54:                                               ; preds = %50
  %55 = load ptr, ptr %3, align 8, !dbg !2626
  %56 = load i32, ptr %6, align 4, !dbg !2627
  %57 = sext i32 %56 to i64, !dbg !2626
  %58 = getelementptr inbounds i64, ptr %55, i64 %57, !dbg !2626
  %59 = load ptr, ptr %2, align 8, !dbg !2628
  %60 = load i32, ptr %6, align 4, !dbg !2629
  %61 = sext i32 %60 to i64, !dbg !2628
  %62 = getelementptr inbounds %struct.PhaseD_Args, ptr %59, i64 %61, !dbg !2628
  %63 = call i32 @pthread_create(ptr noundef %58, ptr noundef null, ptr noundef @_ZL13phaseD_packedPv, ptr noundef %62) #11, !dbg !2630
  br label %64, !dbg !2630

64:                                               ; preds = %54
  %65 = load i32, ptr %6, align 4, !dbg !2631
  %66 = add nsw i32 %65, 1, !dbg !2631
  store i32 %66, ptr %6, align 4, !dbg !2631
  br label %50, !dbg !2632, !llvm.loop !2633

67:                                               ; preds = %50
    #dbg_declare(ptr %7, !2635, !DIExpression(), !2637)
  store i32 0, ptr %7, align 4, !dbg !2637
  br label %68, !dbg !2638

68:                                               ; preds = %79, %67
  %69 = load i32, ptr %7, align 4, !dbg !2639
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2641
  %70 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2641
  %71 = icmp slt i32 %69, %70, !dbg !2642
  br i1 %71, label %72, label %82, !dbg !2643

72:                                               ; preds = %68
  %73 = load ptr, ptr %3, align 8, !dbg !2644
  %74 = load i32, ptr %7, align 4, !dbg !2645
  %75 = sext i32 %74 to i64, !dbg !2644
  %76 = getelementptr inbounds i64, ptr %73, i64 %75, !dbg !2644
  call void @__log_load(ptr %76), !dbg !2644
  %77 = load i64, ptr %76, align 8, !dbg !2644
  %78 = call i32 @pthread_join(i64 noundef %77, ptr noundef null) #10, !dbg !2646
  br label %79, !dbg !2646

79:                                               ; preds = %72
  %80 = load i32, ptr %7, align 4, !dbg !2647
  %81 = add nsw i32 %80, 1, !dbg !2647
  store i32 %81, ptr %7, align 4, !dbg !2647
  br label %68, !dbg !2648, !llvm.loop !2649

82:                                               ; preds = %68
    #dbg_declare(ptr %8, !2651, !DIExpression(), !2652)
  %83 = call noundef double @_ZL6now_msv() #10, !dbg !2653
  %84 = load double, ptr %5, align 8, !dbg !2654
  %85 = fsub double %83, %84, !dbg !2655
  store double %85, ptr %8, align 8, !dbg !2652
  %86 = call noundef double @_ZL6now_msv() #10, !dbg !2656
  store double %86, ptr %5, align 8, !dbg !2657
    #dbg_declare(ptr %9, !2658, !DIExpression(), !2660)
  store i32 0, ptr %9, align 4, !dbg !2660
  br label %87, !dbg !2661

87:                                               ; preds = %101, %82
  %88 = load i32, ptr %9, align 4, !dbg !2662
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2664
  %89 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2664
  %90 = icmp slt i32 %88, %89, !dbg !2665
  br i1 %90, label %91, label %104, !dbg !2666

91:                                               ; preds = %87
  %92 = load ptr, ptr %3, align 8, !dbg !2667
  %93 = load i32, ptr %9, align 4, !dbg !2668
  %94 = sext i32 %93 to i64, !dbg !2667
  %95 = getelementptr inbounds i64, ptr %92, i64 %94, !dbg !2667
  %96 = load ptr, ptr %2, align 8, !dbg !2669
  %97 = load i32, ptr %9, align 4, !dbg !2670
  %98 = sext i32 %97 to i64, !dbg !2669
  %99 = getelementptr inbounds %struct.PhaseD_Args, ptr %96, i64 %98, !dbg !2669
  %100 = call i32 @pthread_create(ptr noundef %95, ptr noundef null, ptr noundef @_ZL13phaseD_paddedPv, ptr noundef %99) #11, !dbg !2671
  br label %101, !dbg !2671

101:                                              ; preds = %91
  %102 = load i32, ptr %9, align 4, !dbg !2672
  %103 = add nsw i32 %102, 1, !dbg !2672
  store i32 %103, ptr %9, align 4, !dbg !2672
  br label %87, !dbg !2673, !llvm.loop !2674

104:                                              ; preds = %87
    #dbg_declare(ptr %10, !2676, !DIExpression(), !2678)
  store i32 0, ptr %10, align 4, !dbg !2678
  br label %105, !dbg !2679

105:                                              ; preds = %116, %104
  %106 = load i32, ptr %10, align 4, !dbg !2680
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2682
  %107 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2682
  %108 = icmp slt i32 %106, %107, !dbg !2683
  br i1 %108, label %109, label %119, !dbg !2684

109:                                              ; preds = %105
  %110 = load ptr, ptr %3, align 8, !dbg !2685
  %111 = load i32, ptr %10, align 4, !dbg !2686
  %112 = sext i32 %111 to i64, !dbg !2685
  %113 = getelementptr inbounds i64, ptr %110, i64 %112, !dbg !2685
  call void @__log_load(ptr %113), !dbg !2685
  %114 = load i64, ptr %113, align 8, !dbg !2685
  %115 = call i32 @pthread_join(i64 noundef %114, ptr noundef null) #10, !dbg !2687
  br label %116, !dbg !2687

116:                                              ; preds = %109
  %117 = load i32, ptr %10, align 4, !dbg !2688
  %118 = add nsw i32 %117, 1, !dbg !2688
  store i32 %118, ptr %10, align 4, !dbg !2688
  br label %105, !dbg !2689, !llvm.loop !2690

119:                                              ; preds = %105
    #dbg_declare(ptr %11, !2692, !DIExpression(), !2693)
  %120 = call noundef double @_ZL6now_msv() #10, !dbg !2694
  %121 = load double, ptr %5, align 8, !dbg !2695
  %122 = fsub double %120, %121, !dbg !2696
  store double %122, ptr %11, align 8, !dbg !2693
  %123 = load double, ptr %8, align 8, !dbg !2697
  %124 = call i32 (ptr, ...) @printf(ptr noundef @.str.20, double noundef %123) #10, !dbg !2698
  %125 = load double, ptr %11, align 8, !dbg !2699
  %126 = call i32 (ptr, ...) @printf(ptr noundef @.str.21, double noundef %125) #10, !dbg !2700
  %127 = load double, ptr %8, align 8, !dbg !2701
  %128 = load double, ptr %11, align 8, !dbg !2702
  %129 = fdiv double %127, %128, !dbg !2703
  %130 = call i32 (ptr, ...) @printf(ptr noundef @.str.22, double noundef %129) #10, !dbg !2704
  %131 = call i32 (ptr, ...) @printf(ptr noundef @.str.23) #10, !dbg !2705
  %132 = call i32 (ptr, ...) @printf(ptr noundef @.str.24) #10, !dbg !2706
    #dbg_declare(ptr %12, !2707, !DIExpression(), !2708)
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2709
  %133 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2709
  %134 = sext i32 %133 to i64, !dbg !2709
  %135 = load i32, ptr %1, align 4, !dbg !2710
  %136 = sext i32 %135 to i64, !dbg !2710
  %137 = mul nsw i64 %134, %136, !dbg !2711
  %138 = mul nsw i64 %137, 2, !dbg !2712
  store i64 %138, ptr %12, align 8, !dbg !2708
    #dbg_declare(ptr %13, !2713, !DIExpression(), !2714)
  store i64 0, ptr %13, align 8, !dbg !2714
  call void @__log_load(ptr @_ZL10G_NTHREADS), !dbg !2715
  %139 = load i32, ptr @_ZL10G_NTHREADS, align 4, !dbg !2715
  call void @__log_load(ptr @_ZL7G_SCALE), !dbg !2716
  %140 = load i32, ptr @_ZL7G_SCALE, align 4, !dbg !2716
  %141 = load double, ptr %8, align 8, !dbg !2717
  %142 = load double, ptr %11, align 8, !dbg !2718
  %143 = load i64, ptr %12, align 8, !dbg !2719
  %144 = load i64, ptr %13, align 8, !dbg !2720
  %145 = call i32 (ptr, ...) @printf(ptr noundef @.str.25, i32 noundef %139, i32 noundef %140, double noundef %141, double noundef %142, i64 noundef %143, i64 noundef %144) #10, !dbg !2721
  %146 = load ptr, ptr %2, align 8, !dbg !2722
  call void @free(ptr noundef %146) #11, !dbg !2723
  %147 = load ptr, ptr %3, align 8, !dbg !2724
  call void @free(ptr noundef %147) #11, !dbg !2725
  ret void, !dbg !2726
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal void @_ZL13print_summaryllllllll(i64 noundef %0, i64 noundef %1, i64 noundef %2, i64 noundef %3, i64 noundef %4, i64 noundef %5, i64 noundef %6, i64 noundef %7) #5 !dbg !2727 {
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca i64, align 8
  %13 = alloca i64, align 8
  %14 = alloca i64, align 8
  %15 = alloca i64, align 8
  %16 = alloca i64, align 8
  %17 = alloca i64, align 8
  %18 = alloca i64, align 8
  %19 = alloca i64, align 8
  %20 = alloca %class.anon, align 1
  store i64 %0, ptr %9, align 8
    #dbg_declare(ptr %9, !2730, !DIExpression(), !2731)
  store i64 %1, ptr %10, align 8
    #dbg_declare(ptr %10, !2732, !DIExpression(), !2733)
  store i64 %2, ptr %11, align 8
    #dbg_declare(ptr %11, !2734, !DIExpression(), !2735)
  store i64 %3, ptr %12, align 8
    #dbg_declare(ptr %12, !2736, !DIExpression(), !2737)
  store i64 %4, ptr %13, align 8
    #dbg_declare(ptr %13, !2738, !DIExpression(), !2739)
  store i64 %5, ptr %14, align 8
    #dbg_declare(ptr %14, !2740, !DIExpression(), !2741)
  store i64 %6, ptr %15, align 8
    #dbg_declare(ptr %15, !2742, !DIExpression(), !2743)
  store i64 %7, ptr %16, align 8
    #dbg_declare(ptr %16, !2744, !DIExpression(), !2745)
    #dbg_declare(ptr %17, !2746, !DIExpression(), !2747)
  %21 = load i64, ptr %9, align 8, !dbg !2748
  %22 = load i64, ptr %11, align 8, !dbg !2749
  %23 = add nsw i64 %21, %22, !dbg !2750
  %24 = load i64, ptr %13, align 8, !dbg !2751
  %25 = add nsw i64 %23, %24, !dbg !2752
  %26 = load i64, ptr %15, align 8, !dbg !2753
  %27 = add nsw i64 %25, %26, !dbg !2754
  store i64 %27, ptr %17, align 8, !dbg !2747
    #dbg_declare(ptr %18, !2755, !DIExpression(), !2756)
  %28 = load i64, ptr %10, align 8, !dbg !2757
  %29 = load i64, ptr %12, align 8, !dbg !2758
  %30 = add nsw i64 %28, %29, !dbg !2759
  %31 = load i64, ptr %14, align 8, !dbg !2760
  %32 = add nsw i64 %30, %31, !dbg !2761
  %33 = load i64, ptr %16, align 8, !dbg !2762
  %34 = add nsw i64 %32, %33, !dbg !2763
  store i64 %34, ptr %18, align 8, !dbg !2756
    #dbg_declare(ptr %19, !2764, !DIExpression(), !2765)
  %35 = load i64, ptr %17, align 8, !dbg !2766
  %36 = load i64, ptr %18, align 8, !dbg !2767
  %37 = add nsw i64 %35, %36, !dbg !2768
  store i64 %37, ptr %19, align 8, !dbg !2765
  %38 = call i32 (ptr, ...) @printf(ptr noundef @.str.26) #10, !dbg !2769
  %39 = call i32 (ptr, ...) @printf(ptr noundef @.str.27) #10, !dbg !2770
  %40 = call i32 (ptr, ...) @printf(ptr noundef @.str.28) #10, !dbg !2771
  %41 = call i32 (ptr, ...) @printf(ptr noundef @.str.29) #10, !dbg !2772
  %42 = call i32 (ptr, ...) @printf(ptr noundef @.str.28) #10, !dbg !2773
    #dbg_declare(ptr %20, !2774, !DIExpression(), !2782)
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %20, ptr align 1 @__const._ZL13print_summaryllllllll.pct, i64 1, i1 false), !dbg !2782
  %43 = load i64, ptr %9, align 8, !dbg !2783
  %44 = load i64, ptr %10, align 8, !dbg !2784
  %45 = load i64, ptr %9, align 8, !dbg !2785
  %46 = load i64, ptr %10, align 8, !dbg !2786
  %47 = call noundef double @"_ZZL13print_summaryllllllllENK3$_0clEll"(ptr noundef nonnull align 1 dereferenceable(1) %20, i64 noundef %45, i64 noundef %46) #10, !dbg !2787
  %48 = call i32 (ptr, ...) @printf(ptr noundef @.str.30, i64 noundef %43, i64 noundef %44, double noundef %47) #10, !dbg !2788
  %49 = load i64, ptr %11, align 8, !dbg !2789
  %50 = load i64, ptr %12, align 8, !dbg !2790
  %51 = load i64, ptr %11, align 8, !dbg !2791
  %52 = load i64, ptr %12, align 8, !dbg !2792
  %53 = call noundef double @"_ZZL13print_summaryllllllllENK3$_0clEll"(ptr noundef nonnull align 1 dereferenceable(1) %20, i64 noundef %51, i64 noundef %52) #10, !dbg !2793
  %54 = call i32 (ptr, ...) @printf(ptr noundef @.str.31, i64 noundef %49, i64 noundef %50, double noundef %53) #10, !dbg !2794
  %55 = load i64, ptr %13, align 8, !dbg !2795
  %56 = load i64, ptr %14, align 8, !dbg !2796
  %57 = load i64, ptr %13, align 8, !dbg !2797
  %58 = load i64, ptr %14, align 8, !dbg !2798
  %59 = call noundef double @"_ZZL13print_summaryllllllllENK3$_0clEll"(ptr noundef nonnull align 1 dereferenceable(1) %20, i64 noundef %57, i64 noundef %58) #10, !dbg !2799
  %60 = call i32 (ptr, ...) @printf(ptr noundef @.str.32, i64 noundef %55, i64 noundef %56, double noundef %59) #10, !dbg !2800
  %61 = load i64, ptr %15, align 8, !dbg !2801
  %62 = load i64, ptr %16, align 8, !dbg !2802
  %63 = load i64, ptr %15, align 8, !dbg !2803
  %64 = load i64, ptr %16, align 8, !dbg !2804
  %65 = call noundef double @"_ZZL13print_summaryllllllllENK3$_0clEll"(ptr noundef nonnull align 1 dereferenceable(1) %20, i64 noundef %63, i64 noundef %64) #10, !dbg !2805
  %66 = call i32 (ptr, ...) @printf(ptr noundef @.str.33, i64 noundef %61, i64 noundef %62, double noundef %65) #10, !dbg !2806
  %67 = call i32 (ptr, ...) @printf(ptr noundef @.str.28) #10, !dbg !2807
  %68 = load i64, ptr %17, align 8, !dbg !2808
  %69 = load i64, ptr %18, align 8, !dbg !2809
  %70 = load i64, ptr %17, align 8, !dbg !2810
  %71 = load i64, ptr %18, align 8, !dbg !2811
  %72 = call noundef double @"_ZZL13print_summaryllllllllENK3$_0clEll"(ptr noundef nonnull align 1 dereferenceable(1) %20, i64 noundef %70, i64 noundef %71) #10, !dbg !2812
  %73 = call i32 (ptr, ...) @printf(ptr noundef @.str.34, i64 noundef %68, i64 noundef %69, double noundef %72) #10, !dbg !2813
  %74 = call i32 (ptr, ...) @printf(ptr noundef @.str.28) #10, !dbg !2814
  %75 = call i32 (ptr, ...) @printf(ptr noundef @.str.35) #10, !dbg !2815
  %76 = load i64, ptr %18, align 8, !dbg !2816
  %77 = sitofp i64 %76 to double, !dbg !2816
  %78 = fmul double 1.000000e+02, %77, !dbg !2817
  %79 = load i64, ptr %19, align 8, !dbg !2818
  %80 = icmp sgt i64 %79, 0, !dbg !2819
  br i1 %80, label %81, label %83, !dbg !2818

81:                                               ; preds = %8
  %82 = load i64, ptr %19, align 8, !dbg !2820
  br label %84, !dbg !2818

83:                                               ; preds = %8
  br label %84, !dbg !2818

84:                                               ; preds = %83, %81
  %85 = phi i64 [ %82, %81 ], [ 1, %83 ], !dbg !2818
  %86 = sitofp i64 %85 to double, !dbg !2821
  %87 = fdiv double %78, %86, !dbg !2822
  %88 = call i32 (ptr, ...) @printf(ptr noundef @.str.36, double noundef %87) #10, !dbg !2823
  %89 = call i32 (ptr, ...) @printf(ptr noundef @.str.37) #10, !dbg !2824
  %90 = call i32 (ptr, ...) @printf(ptr noundef @.str.38) #10, !dbg !2825
  %91 = call i32 (ptr, ...) @printf(ptr noundef @.str.39) #10, !dbg !2826
  %92 = call i32 (ptr, ...) @printf(ptr noundef @.str.40) #10, !dbg !2827
  %93 = call i32 (ptr, ...) @printf(ptr noundef @.str.41) #10, !dbg !2828
  %94 = call i32 (ptr, ...) @printf(ptr noundef @.str.42) #10, !dbg !2829
  %95 = call i32 (ptr, ...) @printf(ptr noundef @.str.43) #10, !dbg !2830
  %96 = call i32 (ptr, ...) @printf(ptr noundef @.str.44) #10, !dbg !2831
  ret void, !dbg !2832
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal void @_ZL6matmulPKfS0_Pfi(ptr noundef %0, ptr noundef %1, ptr noundef %2, i32 noundef %3) #1 !dbg !2833 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca float, align 4
  %12 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
    #dbg_declare(ptr %5, !2838, !DIExpression(), !2839)
  store ptr %1, ptr %6, align 8
    #dbg_declare(ptr %6, !2840, !DIExpression(), !2841)
  store ptr %2, ptr %7, align 8
    #dbg_declare(ptr %7, !2842, !DIExpression(), !2843)
  store i32 %3, ptr %8, align 4
    #dbg_declare(ptr %8, !2844, !DIExpression(), !2845)
    #dbg_declare(ptr %9, !2846, !DIExpression(), !2848)
  store i32 0, ptr %9, align 4, !dbg !2848
  br label %13, !dbg !2849

13:                                               ; preds = %65, %4
  %14 = load i32, ptr %9, align 4, !dbg !2850
  %15 = load i32, ptr %8, align 4, !dbg !2852
  %16 = icmp slt i32 %14, %15, !dbg !2853
  br i1 %16, label %17, label %68, !dbg !2854

17:                                               ; preds = %13
    #dbg_declare(ptr %10, !2855, !DIExpression(), !2858)
  store i32 0, ptr %10, align 4, !dbg !2858
  br label %18, !dbg !2859

18:                                               ; preds = %61, %17
  %19 = load i32, ptr %10, align 4, !dbg !2860
  %20 = load i32, ptr %8, align 4, !dbg !2862
  %21 = icmp slt i32 %19, %20, !dbg !2863
  br i1 %21, label %22, label %64, !dbg !2864

22:                                               ; preds = %18
    #dbg_declare(ptr %11, !2865, !DIExpression(), !2867)
  %23 = load ptr, ptr %5, align 8, !dbg !2868
  %24 = load i32, ptr %9, align 4, !dbg !2869
  %25 = load i32, ptr %8, align 4, !dbg !2870
  %26 = mul nsw i32 %24, %25, !dbg !2871
  %27 = load i32, ptr %10, align 4, !dbg !2872
  %28 = add nsw i32 %26, %27, !dbg !2873
  %29 = sext i32 %28 to i64, !dbg !2868
  %30 = getelementptr inbounds float, ptr %23, i64 %29, !dbg !2868
  call void @__log_load(ptr %30), !dbg !2868
  %31 = load float, ptr %30, align 4, !dbg !2868
  store float %31, ptr %11, align 4, !dbg !2867
    #dbg_declare(ptr %12, !2874, !DIExpression(), !2876)
  store i32 0, ptr %12, align 4, !dbg !2876
  br label %32, !dbg !2877

32:                                               ; preds = %57, %22
  %33 = load i32, ptr %12, align 4, !dbg !2878
  %34 = load i32, ptr %8, align 4, !dbg !2880
  %35 = icmp slt i32 %33, %34, !dbg !2881
  br i1 %35, label %36, label %60, !dbg !2882

36:                                               ; preds = %32
  %37 = load float, ptr %11, align 4, !dbg !2883
  %38 = load ptr, ptr %6, align 8, !dbg !2885
  %39 = load i32, ptr %10, align 4, !dbg !2886
  %40 = load i32, ptr %8, align 4, !dbg !2887
  %41 = mul nsw i32 %39, %40, !dbg !2888
  %42 = load i32, ptr %12, align 4, !dbg !2889
  %43 = add nsw i32 %41, %42, !dbg !2890
  %44 = sext i32 %43 to i64, !dbg !2885
  %45 = getelementptr inbounds float, ptr %38, i64 %44, !dbg !2885
  call void @__log_load(ptr %45), !dbg !2885
  %46 = load float, ptr %45, align 4, !dbg !2885
  %47 = load ptr, ptr %7, align 8, !dbg !2891
  %48 = load i32, ptr %9, align 4, !dbg !2892
  %49 = load i32, ptr %8, align 4, !dbg !2893
  %50 = mul nsw i32 %48, %49, !dbg !2894
  %51 = load i32, ptr %12, align 4, !dbg !2895
  %52 = add nsw i32 %50, %51, !dbg !2896
  %53 = sext i32 %52 to i64, !dbg !2891
  %54 = getelementptr inbounds float, ptr %47, i64 %53, !dbg !2891
  call void @__log_load(ptr %54), !dbg !2897
  %55 = load float, ptr %54, align 4, !dbg !2897
  %56 = call float @llvm.fmuladd.f32(float %37, float %46, float %55), !dbg !2897
  call void @__log_store(ptr %54), !dbg !2897
  store float %56, ptr %54, align 4, !dbg !2897
  br label %57, !dbg !2898

57:                                               ; preds = %36
  %58 = load i32, ptr %12, align 4, !dbg !2899
  %59 = add nsw i32 %58, 1, !dbg !2899
  store i32 %59, ptr %12, align 4, !dbg !2899
  br label %32, !dbg !2900, !llvm.loop !2901

60:                                               ; preds = %32
  br label %61, !dbg !2903

61:                                               ; preds = %60
  %62 = load i32, ptr %10, align 4, !dbg !2904
  %63 = add nsw i32 %62, 1, !dbg !2904
  store i32 %63, ptr %10, align 4, !dbg !2904
  br label %18, !dbg !2905, !llvm.loop !2906

64:                                               ; preds = %18
  br label %65, !dbg !2908

65:                                               ; preds = %64
  %66 = load i32, ptr %9, align 4, !dbg !2909
  %67 = add nsw i32 %66, 1, !dbg !2909
  store i32 %67, ptr %9, align 4, !dbg !2909
  br label %13, !dbg !2910, !llvm.loop !2911

68:                                               ; preds = %13
  ret void, !dbg !2913
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #6

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #4

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef double @_ZL6now_msv() #1 !dbg !2914 {
  %1 = alloca %struct.timespec, align 8
    #dbg_declare(ptr %1, !2917, !DIExpression(), !2918)
  %2 = call i32 @clock_gettime(i32 noundef 1, ptr noundef %1) #11, !dbg !2919
  %3 = getelementptr inbounds nuw %struct.timespec, ptr %1, i32 0, i32 0, !dbg !2920
  %4 = load i64, ptr %3, align 8, !dbg !2920
  %5 = sitofp i64 %4 to double, !dbg !2921
  %6 = getelementptr inbounds nuw %struct.timespec, ptr %1, i32 0, i32 1, !dbg !2922
  %7 = load i64, ptr %6, align 8, !dbg !2922
  %8 = sitofp i64 %7 to double, !dbg !2923
  %9 = fdiv double %8, 1.000000e+06, !dbg !2924
  %10 = call double @llvm.fmuladd.f64(double %5, double 1.000000e+03, double %9), !dbg !2925
  ret double %10, !dbg !2926
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal noundef ptr @_ZL15phaseB_consumerPv(ptr noundef %0) #5 !dbg !2927 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca ptr, align 8
  %12 = alloca ptr, align 8
  %13 = alloca ptr, align 8
  %14 = alloca %struct.WorkItem, align 4
  %15 = alloca i64, align 8
  %16 = alloca i64, align 8
  %17 = alloca i64, align 8
  %18 = alloca i32, align 4
  %19 = alloca i64, align 8
  %20 = alloca i32, align 4
  store ptr %0, ptr %11, align 8
    #dbg_declare(ptr %11, !2928, !DIExpression(), !2929)
    #dbg_declare(ptr %12, !2930, !DIExpression(), !2931)
  %21 = load ptr, ptr %11, align 8, !dbg !2932
  store ptr %21, ptr %12, align 8, !dbg !2931
    #dbg_declare(ptr %13, !2933, !DIExpression(), !2934)
  %22 = call noalias ptr @malloc(i64 noundef 16384) #11, !dbg !2935
  store ptr %22, ptr %13, align 8, !dbg !2934
    #dbg_declare(ptr %14, !2936, !DIExpression(), !2937)
    #dbg_declare(ptr %15, !2938, !DIExpression(), !2939)
  store i64 0, ptr %15, align 8, !dbg !2939
    #dbg_declare(ptr %16, !2940, !DIExpression(), !2941)
  store i64 0, ptr %16, align 8, !dbg !2941
    #dbg_declare(ptr %17, !2942, !DIExpression(), !2943)
  store i64 0, ptr %17, align 8, !dbg !2943
  br label %23, !dbg !2944

23:                                               ; preds = %132, %1
  call void @__log_load(ptr @_ZL7g_queue), !dbg !2945
  %24 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !2945
  %25 = call noundef i32 @_ZL5q_popP9RingQueueP8WorkItem(ptr noundef %24, ptr noundef %14) #10, !dbg !2948
  %26 = icmp ne i32 %25, 0, !dbg !2948
  br i1 %26, label %27, label %93, !dbg !2948

27:                                               ; preds = %23
    #dbg_declare(ptr %18, !2949, !DIExpression(), !2952)
  store i32 0, ptr %18, align 4, !dbg !2952
  br label %28, !dbg !2953

28:                                               ; preds = %46, %27
  %29 = load i32, ptr %18, align 4, !dbg !2954
  %30 = icmp slt i32 %29, 4096, !dbg !2956
  br i1 %30, label %31, label %49, !dbg !2957

31:                                               ; preds = %28
  %32 = getelementptr inbounds nuw %struct.WorkItem, ptr %14, i32 0, i32 2, !dbg !2958
  %33 = load i32, ptr %18, align 4, !dbg !2959
  %34 = and i32 %33, 55, !dbg !2960
  %35 = sext i32 %34 to i64, !dbg !2961
  %36 = getelementptr inbounds [56 x i8], ptr %32, i64 0, i64 %35, !dbg !2961
  call void @__log_load(ptr %36), !dbg !2961
  %37 = load i8, ptr %36, align 1, !dbg !2961
  %38 = sext i8 %37 to i32, !dbg !2961
  %39 = load i32, ptr %18, align 4, !dbg !2962
  %40 = and i32 %39, 255, !dbg !2963
  %41 = xor i32 %38, %40, !dbg !2964
  %42 = load ptr, ptr %13, align 8, !dbg !2965
  %43 = load i32, ptr %18, align 4, !dbg !2966
  %44 = sext i32 %43 to i64, !dbg !2965
  %45 = getelementptr inbounds i32, ptr %42, i64 %44, !dbg !2965
  call void @__log_store(ptr %45), !dbg !2967
  store i32 %41, ptr %45, align 4, !dbg !2967
  br label %46, !dbg !2965

46:                                               ; preds = %31
  %47 = load i32, ptr %18, align 4, !dbg !2968
  %48 = add nsw i32 %47, 1, !dbg !2968
  store i32 %48, ptr %18, align 4, !dbg !2968
  br label %28, !dbg !2969, !llvm.loop !2970

49:                                               ; preds = %28
    #dbg_declare(ptr %19, !2972, !DIExpression(), !2973)
  store i64 0, ptr %19, align 8, !dbg !2973
    #dbg_declare(ptr %20, !2974, !DIExpression(), !2976)
  store i32 0, ptr %20, align 4, !dbg !2976
  br label %50, !dbg !2977

50:                                               ; preds = %62, %49
  %51 = load i32, ptr %20, align 4, !dbg !2978
  %52 = icmp slt i32 %51, 4096, !dbg !2980
  br i1 %52, label %53, label %65, !dbg !2981

53:                                               ; preds = %50
  %54 = load ptr, ptr %13, align 8, !dbg !2982
  %55 = load i32, ptr %20, align 4, !dbg !2983
  %56 = sext i32 %55 to i64, !dbg !2982
  %57 = getelementptr inbounds i32, ptr %54, i64 %56, !dbg !2982
  call void @__log_load(ptr %57), !dbg !2982
  %58 = load i32, ptr %57, align 4, !dbg !2982
  %59 = sext i32 %58 to i64, !dbg !2982
  %60 = load i64, ptr %19, align 8, !dbg !2984
  %61 = add nsw i64 %60, %59, !dbg !2984
  store i64 %61, ptr %19, align 8, !dbg !2984
  br label %62, !dbg !2985

62:                                               ; preds = %53
  %63 = load i32, ptr %20, align 4, !dbg !2986
  %64 = add nsw i32 %63, 1, !dbg !2986
  store i32 %64, ptr %20, align 4, !dbg !2986
  br label %50, !dbg !2987, !llvm.loop !2988

65:                                               ; preds = %50
  %66 = load i64, ptr %19, align 8, !dbg !2990
  store ptr @_ZL10g_checksum, ptr %6, align 8
    #dbg_declare(ptr %6, !2141, !DIExpression(), !2991)
  store i64 %66, ptr %7, align 8
    #dbg_declare(ptr %7, !2145, !DIExpression(), !2993)
  store i32 0, ptr %8, align 4
    #dbg_declare(ptr %8, !2147, !DIExpression(), !2994)
  %67 = load ptr, ptr %6, align 8
  %68 = load i32, ptr %8, align 4, !dbg !2995
  %69 = load i64, ptr %7, align 8, !dbg !2996
  store i64 %69, ptr %9, align 8, !dbg !2997
  switch i32 %68, label %70 [
    i32 1, label %73
    i32 2, label %73
    i32 3, label %76
    i32 4, label %79
    i32 5, label %82
  ], !dbg !2997

70:                                               ; preds = %65
  %71 = load i64, ptr %9, align 8, !dbg !2997
  %72 = atomicrmw add ptr %67, i64 %71 monotonic, align 8, !dbg !2997
  store i64 %72, ptr %10, align 8, !dbg !2997
  br label %85, !dbg !2997

73:                                               ; preds = %65, %65
  %74 = load i64, ptr %9, align 8, !dbg !2997
  %75 = atomicrmw add ptr %67, i64 %74 acquire, align 8, !dbg !2997
  store i64 %75, ptr %10, align 8, !dbg !2997
  br label %85, !dbg !2997

76:                                               ; preds = %65
  %77 = load i64, ptr %9, align 8, !dbg !2997
  %78 = atomicrmw add ptr %67, i64 %77 release, align 8, !dbg !2997
  store i64 %78, ptr %10, align 8, !dbg !2997
  br label %85, !dbg !2997

79:                                               ; preds = %65
  %80 = load i64, ptr %9, align 8, !dbg !2997
  %81 = atomicrmw add ptr %67, i64 %80 acq_rel, align 8, !dbg !2997
  store i64 %81, ptr %10, align 8, !dbg !2997
  br label %85, !dbg !2997

82:                                               ; preds = %65
  %83 = load i64, ptr %9, align 8, !dbg !2997
  %84 = atomicrmw add ptr %67, i64 %83 seq_cst, align 8, !dbg !2997
  store i64 %84, ptr %10, align 8, !dbg !2997
  br label %85, !dbg !2997

85:                                               ; preds = %82, %79, %76, %73, %70
  %86 = load i64, ptr %10, align 8, !dbg !2997
  %87 = load i64, ptr %15, align 8, !dbg !2998
  %88 = add nsw i64 %87, 1, !dbg !2998
  store i64 %88, ptr %15, align 8, !dbg !2998
  %89 = load i64, ptr %16, align 8, !dbg !2999
  %90 = add nsw i64 %89, 8192, !dbg !2999
  store i64 %90, ptr %16, align 8, !dbg !2999
  %91 = load i64, ptr %17, align 8, !dbg !3000
  %92 = add nsw i64 %91, 5, !dbg !3000
  store i64 %92, ptr %17, align 8, !dbg !3000
  br label %132, !dbg !3001

93:                                               ; preds = %23
  call void @__log_load(ptr @_ZL7g_queue), !dbg !3002
  %94 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !3002
  %95 = getelementptr inbounds nuw %struct.RingQueue, ptr %94, i32 0, i32 4, !dbg !3005
  store ptr %95, ptr %2, align 8
    #dbg_declare(ptr %2, !3006, !DIExpression(), !3009)
  store i32 2, ptr %3, align 4
    #dbg_declare(ptr %3, !3011, !DIExpression(), !3012)
  %96 = load ptr, ptr %2, align 8
    #dbg_declare(ptr %4, !3013, !DIExpression(), !3014)
  %97 = load i32, ptr %3, align 4, !dbg !3015
  %98 = call noundef i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 noundef %97, i32 noundef 65535) #11, !dbg !3016
  store i32 %98, ptr %4, align 4, !dbg !3014
  %99 = load i32, ptr %4, align 4, !dbg !3017
  %100 = icmp ne i32 %99, 3, !dbg !3017
  %101 = xor i1 %100, true, !dbg !3017
  br i1 %101, label %102, label %103, !dbg !3017

102:                                              ; preds = %93
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 498, ptr noundef @__PRETTY_FUNCTION__._ZNKSt13__atomic_baseIiE4loadESt12memory_order, ptr noundef @.str.13) #12, !dbg !3017
  unreachable, !dbg !3017

103:                                              ; preds = %93
  %104 = load i32, ptr %4, align 4, !dbg !3020
  %105 = icmp ne i32 %104, 4, !dbg !3020
  %106 = xor i1 %105, true, !dbg !3020
  br i1 %106, label %107, label %108, !dbg !3020

107:                                              ; preds = %103
  call void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef @.str.12, i32 noundef 499, ptr noundef @__PRETTY_FUNCTION__._ZNKSt13__atomic_baseIiE4loadESt12memory_order, ptr noundef @.str.14) #12, !dbg !3020
  unreachable, !dbg !3020

108:                                              ; preds = %103
  %109 = load i32, ptr %3, align 4, !dbg !3023
  switch i32 %109, label %110 [
    i32 1, label %112
    i32 2, label %112
    i32 5, label %114
  ], !dbg !3024

110:                                              ; preds = %108
  call void @__log_load(ptr %96), !dbg !3024
  %111 = load atomic i32, ptr %96 monotonic, align 4, !dbg !3024
  store i32 %111, ptr %5, align 4, !dbg !3024
  br label %116, !dbg !3024

112:                                              ; preds = %108, %108
  call void @__log_load(ptr %96), !dbg !3024
  %113 = load atomic i32, ptr %96 acquire, align 4, !dbg !3024
  store i32 %113, ptr %5, align 4, !dbg !3024
  br label %116, !dbg !3024

114:                                              ; preds = %108
  call void @__log_load(ptr %96), !dbg !3024
  %115 = load atomic i32, ptr %96 seq_cst, align 4, !dbg !3024
  store i32 %115, ptr %5, align 4, !dbg !3024
  br label %116, !dbg !3024

116:                                              ; preds = %114, %112, %110
  %117 = load i32, ptr %5, align 4, !dbg !3024
  %118 = icmp ne i32 %117, 0, !dbg !3002
  br i1 %118, label %119, label %130, !dbg !3002

119:                                              ; preds = %116
  br label %120, !dbg !3025

120:                                              ; preds = %124, %119
  call void @__log_load(ptr @_ZL7g_queue), !dbg !3027
  %121 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !3027
  %122 = call noundef i32 @_ZL5q_popP9RingQueueP8WorkItem(ptr noundef %121, ptr noundef %14) #10, !dbg !3028
  %123 = icmp ne i32 %122, 0, !dbg !3028
  br i1 %123, label %124, label %129, !dbg !3025

124:                                              ; preds = %120
  %125 = load i64, ptr %15, align 8, !dbg !3029
  %126 = add nsw i64 %125, 1, !dbg !3029
  store i64 %126, ptr %15, align 8, !dbg !3029
  %127 = load i64, ptr %17, align 8, !dbg !3031
  %128 = add nsw i64 %127, 5, !dbg !3031
  store i64 %128, ptr %17, align 8, !dbg !3031
  br label %120, !dbg !3025, !llvm.loop !3032

129:                                              ; preds = %120
  br label %133, !dbg !3034

130:                                              ; preds = %116
  %131 = call i32 @sched_yield() #11, !dbg !3035
  br label %132

132:                                              ; preds = %130, %85
  br label %23, !dbg !2944, !llvm.loop !3036

133:                                              ; preds = %129
  %134 = load i64, ptr %15, align 8, !dbg !3038
  %135 = load ptr, ptr %12, align 8, !dbg !3039
  %136 = getelementptr inbounds nuw %struct.PhaseB_ConsumerArgs, ptr %135, i32 0, i32 1, !dbg !3040
  call void @__log_store(ptr %136), !dbg !3041
  store i64 %134, ptr %136, align 8, !dbg !3041
  %137 = load i64, ptr %16, align 8, !dbg !3042
  %138 = load ptr, ptr %12, align 8, !dbg !3043
  %139 = getelementptr inbounds nuw %struct.PhaseB_ConsumerArgs, ptr %138, i32 0, i32 2, !dbg !3044
  call void @__log_store(ptr %139), !dbg !3045
  store i64 %137, ptr %139, align 8, !dbg !3045
  %140 = load i64, ptr %17, align 8, !dbg !3046
  %141 = load ptr, ptr %12, align 8, !dbg !3047
  %142 = getelementptr inbounds nuw %struct.PhaseB_ConsumerArgs, ptr %141, i32 0, i32 3, !dbg !3048
  call void @__log_store(ptr %142), !dbg !3049
  store i64 %140, ptr %142, align 8, !dbg !3049
  %143 = load ptr, ptr %13, align 8, !dbg !3050
  call void @free(ptr noundef %143) #11, !dbg !3051
  ret ptr null, !dbg !3052
}

; Function Attrs: mustprogress noinline optnone uwtable
define internal noundef ptr @_ZL15phaseB_producerPv(ptr noundef %0) #5 !dbg !3053 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca %struct.WorkItem, align 4
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !3054, !DIExpression(), !3055)
    #dbg_declare(ptr %3, !3056, !DIExpression(), !3057)
  %7 = load ptr, ptr %2, align 8, !dbg !3058
  store ptr %7, ptr %3, align 8, !dbg !3057
    #dbg_declare(ptr %4, !3059, !DIExpression(), !3060)
  %8 = load ptr, ptr %3, align 8, !dbg !3061
  %9 = getelementptr inbounds nuw %struct.PhaseB_ProducerArgs, ptr %8, i32 0, i32 0, !dbg !3062
  call void @__log_load(ptr %9), !dbg !3062
  %10 = load i32, ptr %9, align 8, !dbg !3062
  %11 = getelementptr inbounds nuw %struct.WorkItem, ptr %4, i32 0, i32 0, !dbg !3063
  call void @__log_store(ptr %11), !dbg !3064
  store i32 %10, ptr %11, align 4, !dbg !3064
    #dbg_declare(ptr %5, !3065, !DIExpression(), !3066)
  store i64 0, ptr %5, align 8, !dbg !3066
    #dbg_declare(ptr %6, !3067, !DIExpression(), !3069)
  store i32 0, ptr %6, align 4, !dbg !3069
  br label %12, !dbg !3070

12:                                               ; preds = %38, %1
  %13 = load i32, ptr %6, align 4, !dbg !3071
  %14 = load ptr, ptr %3, align 8, !dbg !3073
  %15 = getelementptr inbounds nuw %struct.PhaseB_ProducerArgs, ptr %14, i32 0, i32 1, !dbg !3074
  call void @__log_load(ptr %15), !dbg !3074
  %16 = load i32, ptr %15, align 4, !dbg !3074
  %17 = icmp slt i32 %13, %16, !dbg !3075
  br i1 %17, label %18, label %41, !dbg !3076

18:                                               ; preds = %12
  %19 = load i32, ptr %6, align 4, !dbg !3077
  %20 = getelementptr inbounds nuw %struct.WorkItem, ptr %4, i32 0, i32 1, !dbg !3079
  call void @__log_store(ptr %20), !dbg !3080
  store i32 %19, ptr %20, align 4, !dbg !3080
  %21 = getelementptr inbounds nuw %struct.WorkItem, ptr %4, i32 0, i32 2, !dbg !3081
  %22 = getelementptr inbounds [56 x i8], ptr %21, i64 0, i64 0, !dbg !3082
  %23 = load i32, ptr %6, align 4, !dbg !3083
  %24 = and i32 %23, 255, !dbg !3084
  %25 = trunc i32 %24 to i8, !dbg !3085
  %26 = sext i8 %25 to i32, !dbg !3086
  %27 = call ptr @memset(ptr noundef %22, i32 noundef %26, i64 noundef 56) #11, !dbg !3087
  br label %28, !dbg !3088

28:                                               ; preds = %33, %18
  call void @__log_load(ptr @_ZL7g_queue), !dbg !3089
  %29 = load ptr, ptr @_ZL7g_queue, align 8, !dbg !3089
  %30 = call noundef i32 @_ZL6q_pushP9RingQueuePK8WorkItem(ptr noundef %29, ptr noundef %4) #10, !dbg !3090
  %31 = icmp ne i32 %30, 0, !dbg !3090
  %32 = xor i1 %31, true, !dbg !3091
  br i1 %32, label %33, label %35, !dbg !3088

33:                                               ; preds = %28
  %34 = call i32 @sched_yield() #11, !dbg !3092
  br label %28, !dbg !3088, !llvm.loop !3093

35:                                               ; preds = %28
  %36 = load i64, ptr %5, align 8, !dbg !3095
  %37 = add nsw i64 %36, 4, !dbg !3095
  store i64 %37, ptr %5, align 8, !dbg !3095
  br label %38, !dbg !3096

38:                                               ; preds = %35
  %39 = load i32, ptr %6, align 4, !dbg !3097
  %40 = add nsw i32 %39, 1, !dbg !3097
  store i32 %40, ptr %6, align 4, !dbg !3097
  br label %12, !dbg !3098, !llvm.loop !3099

41:                                               ; preds = %12
  %42 = load i64, ptr %5, align 8, !dbg !3101
  %43 = load ptr, ptr %3, align 8, !dbg !3102
  %44 = getelementptr inbounds nuw %struct.PhaseB_ProducerArgs, ptr %43, i32 0, i32 2, !dbg !3103
  call void @__log_store(ptr %44), !dbg !3104
  store i64 %42, ptr %44, align 8, !dbg !3104
  ret ptr null, !dbg !3105
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(ptr noundef) #4

; Function Attrs: nounwind
declare i32 @clock_gettime(i32 noundef, ptr noundef) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #6

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef i32 @_ZL5q_popP9RingQueueP8WorkItem(ptr noundef %0, ptr noundef %1) #1 !dbg !3106 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !3110, !DIExpression(), !3111)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !3112, !DIExpression(), !3113)
  %6 = load ptr, ptr %4, align 8, !dbg !3114
  %7 = getelementptr inbounds nuw %struct.RingQueue, ptr %6, i32 0, i32 3, !dbg !3115
  %8 = call i32 @pthread_mutex_lock(ptr noundef %7) #11, !dbg !3116
  call void @__log_lock(ptr %7), !dbg !3117
  %9 = load ptr, ptr %4, align 8, !dbg !3117
  %10 = getelementptr inbounds nuw %struct.RingQueue, ptr %9, i32 0, i32 1, !dbg !3119
  call void @__log_load(ptr %10), !dbg !3119
  %11 = load volatile i32, ptr %10, align 8, !dbg !3119
  %12 = load ptr, ptr %4, align 8, !dbg !3120
  %13 = getelementptr inbounds nuw %struct.RingQueue, ptr %12, i32 0, i32 2, !dbg !3121
  call void @__log_load(ptr %13), !dbg !3121
  %14 = load volatile i32, ptr %13, align 4, !dbg !3121
  %15 = icmp eq i32 %11, %14, !dbg !3122
  br i1 %15, label %16, label %20, !dbg !3122

16:                                               ; preds = %2
  %17 = load ptr, ptr %4, align 8, !dbg !3123
  %18 = getelementptr inbounds nuw %struct.RingQueue, ptr %17, i32 0, i32 3, !dbg !3125
  call void @__log_unlock(ptr %18), !dbg !3126
  %19 = call i32 @pthread_mutex_unlock(ptr noundef %18) #11, !dbg !3126
  store i32 0, ptr %3, align 4, !dbg !3127
  br label %39, !dbg !3127

20:                                               ; preds = %2
  %21 = load ptr, ptr %4, align 8, !dbg !3128
  %22 = getelementptr inbounds nuw %struct.RingQueue, ptr %21, i32 0, i32 0, !dbg !3129
  %23 = load ptr, ptr %4, align 8, !dbg !3130
  %24 = getelementptr inbounds nuw %struct.RingQueue, ptr %23, i32 0, i32 1, !dbg !3131
  call void @__log_load(ptr %24), !dbg !3131
  %25 = load volatile i32, ptr %24, align 8, !dbg !3131
  %26 = sext i32 %25 to i64, !dbg !3128
  %27 = getelementptr inbounds [16384 x %struct.WorkItem], ptr %22, i64 0, i64 %26, !dbg !3128
  %28 = load ptr, ptr %5, align 8, !dbg !3132
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %28, ptr align 8 %27, i64 64, i1 false), !dbg !3133
  %29 = load ptr, ptr %4, align 8, !dbg !3134
  %30 = getelementptr inbounds nuw %struct.RingQueue, ptr %29, i32 0, i32 1, !dbg !3135
  call void @__log_load(ptr %30), !dbg !3135
  %31 = load volatile i32, ptr %30, align 8, !dbg !3135
  %32 = add nsw i32 %31, 1, !dbg !3136
  %33 = and i32 %32, 16383, !dbg !3137
  %34 = load ptr, ptr %4, align 8, !dbg !3138
  %35 = getelementptr inbounds nuw %struct.RingQueue, ptr %34, i32 0, i32 1, !dbg !3139
  call void @__log_store(ptr %35), !dbg !3140
  store volatile i32 %33, ptr %35, align 8, !dbg !3140
  %36 = load ptr, ptr %4, align 8, !dbg !3141
  %37 = getelementptr inbounds nuw %struct.RingQueue, ptr %36, i32 0, i32 3, !dbg !3142
  call void @__log_unlock(ptr %37), !dbg !3143
  %38 = call i32 @pthread_mutex_unlock(ptr noundef %37) #11, !dbg !3143
  store i32 1, ptr %3, align 4, !dbg !3144
  br label %39, !dbg !3144

39:                                               ; preds = %20, %16
  %40 = load i32, ptr %3, align 4, !dbg !3145
  ret i32 %40, !dbg !3145
}

; Function Attrs: nounwind
declare i32 @sched_yield() #4

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #4

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #4

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #7

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local noundef i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 noundef %0, i32 noundef %1) #1 comdat !dbg !3146 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
    #dbg_declare(ptr %3, !3149, !DIExpression(), !3150)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !3151, !DIExpression(), !3152)
  %5 = load i32, ptr %3, align 4, !dbg !3153
  %6 = load i32, ptr %4, align 4, !dbg !3154
  %7 = and i32 %5, %6, !dbg !3155
  ret i32 %7, !dbg !3156
}

; Function Attrs: cold noreturn nounwind
declare void @_ZSt21__glibcxx_assert_failPKciS0_S0_(ptr noundef, i32 noundef, ptr noundef, ptr noundef) #8

; Function Attrs: nounwind
declare ptr @memset(ptr noundef, i32 noundef, i64 noundef) #4

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef i32 @_ZL6q_pushP9RingQueuePK8WorkItem(ptr noundef %0, ptr noundef %1) #1 !dbg !3157 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !3162, !DIExpression(), !3163)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !3164, !DIExpression(), !3165)
  %7 = load ptr, ptr %4, align 8, !dbg !3166
  %8 = getelementptr inbounds nuw %struct.RingQueue, ptr %7, i32 0, i32 3, !dbg !3167
  %9 = call i32 @pthread_mutex_lock(ptr noundef %8) #11, !dbg !3168
    #dbg_declare(ptr %6, !3169, !DIExpression(), !3170)
  call void @__log_lock(ptr %8), !dbg !3171
  %10 = load ptr, ptr %4, align 8, !dbg !3171
  %11 = getelementptr inbounds nuw %struct.RingQueue, ptr %10, i32 0, i32 2, !dbg !3172
  call void @__log_load(ptr %11), !dbg !3172
  %12 = load volatile i32, ptr %11, align 4, !dbg !3172
  %13 = add nsw i32 %12, 1, !dbg !3173
  %14 = and i32 %13, 16383, !dbg !3174
  store i32 %14, ptr %6, align 4, !dbg !3170
  %15 = load i32, ptr %6, align 4, !dbg !3175
  %16 = load ptr, ptr %4, align 8, !dbg !3177
  %17 = getelementptr inbounds nuw %struct.RingQueue, ptr %16, i32 0, i32 1, !dbg !3178
  call void @__log_load(ptr %17), !dbg !3178
  %18 = load volatile i32, ptr %17, align 8, !dbg !3178
  %19 = icmp eq i32 %15, %18, !dbg !3179
  br i1 %19, label %20, label %24, !dbg !3179

20:                                               ; preds = %2
  %21 = load ptr, ptr %4, align 8, !dbg !3180
  %22 = getelementptr inbounds nuw %struct.RingQueue, ptr %21, i32 0, i32 3, !dbg !3182
  call void @__log_unlock(ptr %22), !dbg !3183
  %23 = call i32 @pthread_mutex_unlock(ptr noundef %22) #11, !dbg !3183
  store i32 0, ptr %3, align 4, !dbg !3184
  br label %39, !dbg !3184

24:                                               ; preds = %2
  %25 = load ptr, ptr %5, align 8, !dbg !3185
  %26 = load ptr, ptr %4, align 8, !dbg !3186
  %27 = getelementptr inbounds nuw %struct.RingQueue, ptr %26, i32 0, i32 0, !dbg !3187
  %28 = load ptr, ptr %4, align 8, !dbg !3188
  %29 = getelementptr inbounds nuw %struct.RingQueue, ptr %28, i32 0, i32 2, !dbg !3189
  call void @__log_load(ptr %29), !dbg !3189
  %30 = load volatile i32, ptr %29, align 4, !dbg !3189
  %31 = sext i32 %30 to i64, !dbg !3186
  %32 = getelementptr inbounds [16384 x %struct.WorkItem], ptr %27, i64 0, i64 %31, !dbg !3186
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %32, ptr align 4 %25, i64 64, i1 false), !dbg !3190
  %33 = load i32, ptr %6, align 4, !dbg !3191
  %34 = load ptr, ptr %4, align 8, !dbg !3192
  %35 = getelementptr inbounds nuw %struct.RingQueue, ptr %34, i32 0, i32 2, !dbg !3193
  call void @__log_store(ptr %35), !dbg !3194
  store volatile i32 %33, ptr %35, align 4, !dbg !3194
  %36 = load ptr, ptr %4, align 8, !dbg !3195
  %37 = getelementptr inbounds nuw %struct.RingQueue, ptr %36, i32 0, i32 3, !dbg !3196
  call void @__log_unlock(ptr %37), !dbg !3197
  %38 = call i32 @pthread_mutex_unlock(ptr noundef %37) #11, !dbg !3197
  store i32 1, ptr %3, align 4, !dbg !3198
  br label %39, !dbg !3198

39:                                               ; preds = %24, %20
  %40 = load i32, ptr %3, align 4, !dbg !3199
  ret i32 %40, !dbg !3199
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_init(ptr noundef, ptr noundef) #4

; Function Attrs: mustprogress noinline optnone uwtable
define internal noundef ptr @_ZL13phaseC_workerPv(ptr noundef %0) #5 !dbg !3200 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i64, align 8
  %17 = alloca i32, align 4
  store ptr %0, ptr %7, align 8
    #dbg_declare(ptr %7, !3201, !DIExpression(), !3202)
    #dbg_declare(ptr %8, !3203, !DIExpression(), !3204)
  %18 = load ptr, ptr %7, align 8, !dbg !3205
  store ptr %18, ptr %8, align 8, !dbg !3204
    #dbg_declare(ptr %9, !3206, !DIExpression(), !3207)
  %19 = load ptr, ptr %8, align 8, !dbg !3208
  %20 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %19, i32 0, i32 2, !dbg !3209
  call void @__log_load(ptr %20), !dbg !3209
  %21 = load i32, ptr %20, align 8, !dbg !3209
  %22 = sext i32 %21 to i64, !dbg !3208
  %23 = mul i64 %22, 4, !dbg !3210
  %24 = call noalias ptr @malloc(i64 noundef %23) #11, !dbg !3211
  store ptr %24, ptr %9, align 8, !dbg !3207
    #dbg_declare(ptr %10, !3212, !DIExpression(), !3213)
  store i64 0, ptr %10, align 8, !dbg !3213
    #dbg_declare(ptr %11, !3214, !DIExpression(), !3215)
  store i64 0, ptr %11, align 8, !dbg !3215
    #dbg_declare(ptr %12, !3216, !DIExpression(), !3218)
  store i32 0, ptr %12, align 4, !dbg !3218
  br label %25, !dbg !3219

25:                                               ; preds = %45, %1
  %26 = load i32, ptr %12, align 4, !dbg !3220
  %27 = load ptr, ptr %8, align 8, !dbg !3222
  %28 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %27, i32 0, i32 1, !dbg !3223
  call void @__log_load(ptr %28), !dbg !3223
  %29 = load i32, ptr %28, align 4, !dbg !3223
  %30 = icmp slt i32 %26, %29, !dbg !3224
  br i1 %30, label %31, label %48, !dbg !3225

31:                                               ; preds = %25
    #dbg_declare(ptr %13, !3226, !DIExpression(), !3228)
  %32 = load ptr, ptr %8, align 8, !dbg !3229
  %33 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %32, i32 0, i32 0, !dbg !3230
  call void @__log_load(ptr %33), !dbg !3230
  %34 = load i32, ptr %33, align 8, !dbg !3230
  %35 = mul nsw i32 %34, 10000, !dbg !3231
  %36 = load i32, ptr %12, align 4, !dbg !3232
  %37 = add nsw i32 %35, %36, !dbg !3233
  %38 = and i32 %37, 2147483647, !dbg !3234
  store i32 %38, ptr %13, align 4, !dbg !3228
  %39 = load i32, ptr %13, align 4, !dbg !3235
  %40 = load ptr, ptr %8, align 8, !dbg !3236
  %41 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %40, i32 0, i32 0, !dbg !3237
  call void @__log_load(ptr %41), !dbg !3237
  %42 = load i32, ptr %41, align 8, !dbg !3237
  call void @_ZL11list_insertP10SharedListii(ptr noundef @_ZL6g_list, i32 noundef %39, i32 noundef %42) #10, !dbg !3238
  %43 = load i64, ptr %10, align 8, !dbg !3239
  %44 = add nsw i64 %43, 4, !dbg !3239
  store i64 %44, ptr %10, align 8, !dbg !3239
  br label %45, !dbg !3240

45:                                               ; preds = %31
  %46 = load i32, ptr %12, align 4, !dbg !3241
  %47 = add nsw i32 %46, 1, !dbg !3241
  store i32 %47, ptr %12, align 4, !dbg !3241
  br label %25, !dbg !3242, !llvm.loop !3243

48:                                               ; preds = %25
    #dbg_declare(ptr %14, !3245, !DIExpression(), !3247)
  store i32 0, ptr %14, align 4, !dbg !3247
  br label %49, !dbg !3248

49:                                               ; preds = %77, %48
  %50 = load i32, ptr %14, align 4, !dbg !3249
  %51 = load ptr, ptr %8, align 8, !dbg !3251
  %52 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %51, i32 0, i32 2, !dbg !3252
  call void @__log_load(ptr %52), !dbg !3252
  %53 = load i32, ptr %52, align 8, !dbg !3252
  %54 = icmp slt i32 %50, %53, !dbg !3253
  br i1 %54, label %55, label %80, !dbg !3254

55:                                               ; preds = %49
    #dbg_declare(ptr %15, !3255, !DIExpression(), !3257)
  %56 = load ptr, ptr %8, align 8, !dbg !3258
  %57 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %56, i32 0, i32 0, !dbg !3259
  call void @__log_load(ptr %57), !dbg !3259
  %58 = load i32, ptr %57, align 8, !dbg !3259
  %59 = mul nsw i32 %58, 10000, !dbg !3260
  %60 = load i32, ptr %14, align 4, !dbg !3261
  %61 = load ptr, ptr %8, align 8, !dbg !3262
  %62 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %61, i32 0, i32 1, !dbg !3263
  call void @__log_load(ptr %62), !dbg !3263
  %63 = load i32, ptr %62, align 4, !dbg !3263
  %64 = srem i32 %60, %63, !dbg !3264
  %65 = add nsw i32 %59, %64, !dbg !3265
  %66 = and i32 %65, 2147483647, !dbg !3266
  store i32 %66, ptr %15, align 4, !dbg !3257
  %67 = load i32, ptr %15, align 4, !dbg !3267
  %68 = call noundef i32 @_ZL11list_lookupP10SharedListi(ptr noundef @_ZL6g_list, i32 noundef %67) #10, !dbg !3268
  %69 = load ptr, ptr %9, align 8, !dbg !3269
  %70 = load i32, ptr %14, align 4, !dbg !3270
  %71 = sext i32 %70 to i64, !dbg !3269
  %72 = getelementptr inbounds i32, ptr %69, i64 %71, !dbg !3269
  call void @__log_store(ptr %72), !dbg !3271
  store i32 %68, ptr %72, align 4, !dbg !3271
  %73 = load i64, ptr %10, align 8, !dbg !3272
  %74 = add nsw i64 %73, 3, !dbg !3272
  store i64 %74, ptr %10, align 8, !dbg !3272
  %75 = load i64, ptr %11, align 8, !dbg !3273
  %76 = add nsw i64 %75, 1, !dbg !3273
  store i64 %76, ptr %11, align 8, !dbg !3273
  br label %77, !dbg !3274

77:                                               ; preds = %55
  %78 = load i32, ptr %14, align 4, !dbg !3275
  %79 = add nsw i32 %78, 1, !dbg !3275
  store i32 %79, ptr %14, align 4, !dbg !3275
  br label %49, !dbg !3276, !llvm.loop !3277

80:                                               ; preds = %49
    #dbg_declare(ptr %16, !3279, !DIExpression(), !3280)
  store i64 0, ptr %16, align 8, !dbg !3280
    #dbg_declare(ptr %17, !3281, !DIExpression(), !3283)
  store i32 0, ptr %17, align 4, !dbg !3283
  br label %81, !dbg !3284

81:                                               ; preds = %96, %80
  %82 = load i32, ptr %17, align 4, !dbg !3285
  %83 = load ptr, ptr %8, align 8, !dbg !3287
  %84 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %83, i32 0, i32 2, !dbg !3288
  call void @__log_load(ptr %84), !dbg !3288
  %85 = load i32, ptr %84, align 8, !dbg !3288
  %86 = icmp slt i32 %82, %85, !dbg !3289
  br i1 %86, label %87, label %99, !dbg !3290

87:                                               ; preds = %81
  %88 = load ptr, ptr %9, align 8, !dbg !3291
  %89 = load i32, ptr %17, align 4, !dbg !3292
  %90 = sext i32 %89 to i64, !dbg !3291
  %91 = getelementptr inbounds i32, ptr %88, i64 %90, !dbg !3291
  call void @__log_load(ptr %91), !dbg !3291
  %92 = load i32, ptr %91, align 4, !dbg !3291
  %93 = sext i32 %92 to i64, !dbg !3291
  %94 = load i64, ptr %16, align 8, !dbg !3293
  %95 = add nsw i64 %94, %93, !dbg !3293
  store i64 %95, ptr %16, align 8, !dbg !3293
  br label %96, !dbg !3294

96:                                               ; preds = %87
  %97 = load i32, ptr %17, align 4, !dbg !3295
  %98 = add nsw i32 %97, 1, !dbg !3295
  store i32 %98, ptr %17, align 4, !dbg !3295
  br label %81, !dbg !3296, !llvm.loop !3297

99:                                               ; preds = %81
  %100 = load i64, ptr %16, align 8, !dbg !3299
  store ptr @_ZL10g_checksum, ptr %2, align 8
    #dbg_declare(ptr %2, !2141, !DIExpression(), !3300)
  store i64 %100, ptr %3, align 8
    #dbg_declare(ptr %3, !2145, !DIExpression(), !3302)
  store i32 0, ptr %4, align 4
    #dbg_declare(ptr %4, !2147, !DIExpression(), !3303)
  %101 = load ptr, ptr %2, align 8
  %102 = load i32, ptr %4, align 4, !dbg !3304
  %103 = load i64, ptr %3, align 8, !dbg !3305
  store i64 %103, ptr %5, align 8, !dbg !3306
  switch i32 %102, label %104 [
    i32 1, label %107
    i32 2, label %107
    i32 3, label %110
    i32 4, label %113
    i32 5, label %116
  ], !dbg !3306

104:                                              ; preds = %99
  %105 = load i64, ptr %5, align 8, !dbg !3306
  %106 = atomicrmw add ptr %101, i64 %105 monotonic, align 8, !dbg !3306
  store i64 %106, ptr %6, align 8, !dbg !3306
  br label %119, !dbg !3306

107:                                              ; preds = %99, %99
  %108 = load i64, ptr %5, align 8, !dbg !3306
  %109 = atomicrmw add ptr %101, i64 %108 acquire, align 8, !dbg !3306
  store i64 %109, ptr %6, align 8, !dbg !3306
  br label %119, !dbg !3306

110:                                              ; preds = %99
  %111 = load i64, ptr %5, align 8, !dbg !3306
  %112 = atomicrmw add ptr %101, i64 %111 release, align 8, !dbg !3306
  store i64 %112, ptr %6, align 8, !dbg !3306
  br label %119, !dbg !3306

113:                                              ; preds = %99
  %114 = load i64, ptr %5, align 8, !dbg !3306
  %115 = atomicrmw add ptr %101, i64 %114 acq_rel, align 8, !dbg !3306
  store i64 %115, ptr %6, align 8, !dbg !3306
  br label %119, !dbg !3306

116:                                              ; preds = %99
  %117 = load i64, ptr %5, align 8, !dbg !3306
  %118 = atomicrmw add ptr %101, i64 %117 seq_cst, align 8, !dbg !3306
  store i64 %118, ptr %6, align 8, !dbg !3306
  br label %119, !dbg !3306

119:                                              ; preds = %116, %113, %110, %107, %104
  %120 = load i64, ptr %6, align 8, !dbg !3306
  %121 = load ptr, ptr %8, align 8, !dbg !3307
  %122 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %121, i32 0, i32 2, !dbg !3308
  call void @__log_load(ptr %122), !dbg !3308
  %123 = load i32, ptr %122, align 8, !dbg !3308
  %124 = sext i32 %123 to i64, !dbg !3307
  %125 = load i64, ptr %11, align 8, !dbg !3309
  %126 = add nsw i64 %125, %124, !dbg !3309
  store i64 %126, ptr %11, align 8, !dbg !3309
  %127 = load i64, ptr %10, align 8, !dbg !3310
  %128 = load ptr, ptr %8, align 8, !dbg !3311
  %129 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %128, i32 0, i32 3, !dbg !3312
  call void @__log_store(ptr %129), !dbg !3313
  store i64 %127, ptr %129, align 8, !dbg !3313
  %130 = load i64, ptr %11, align 8, !dbg !3314
  %131 = load ptr, ptr %8, align 8, !dbg !3315
  %132 = getelementptr inbounds nuw %struct.PhaseC_Args, ptr %131, i32 0, i32 4, !dbg !3316
  call void @__log_store(ptr %132), !dbg !3317
  store i64 %130, ptr %132, align 8, !dbg !3317
  %133 = load ptr, ptr %9, align 8, !dbg !3318
  call void @free(ptr noundef %133) #11, !dbg !3319
  ret ptr null, !dbg !3320
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal void @_ZL12list_destroyP10SharedList(ptr noundef %0) #1 !dbg !3321 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !3325, !DIExpression(), !3326)
    #dbg_declare(ptr %3, !3327, !DIExpression(), !3328)
  %5 = load ptr, ptr %2, align 8, !dbg !3329
  %6 = getelementptr inbounds nuw %struct.SharedList, ptr %5, i32 0, i32 0, !dbg !3330
  call void @__log_load(ptr %6), !dbg !3330
  %7 = load ptr, ptr %6, align 8, !dbg !3330
  store ptr %7, ptr %3, align 8, !dbg !3328
  br label %8, !dbg !3331

8:                                                ; preds = %11, %1
  %9 = load ptr, ptr %3, align 8, !dbg !3332
  %10 = icmp ne ptr %9, null, !dbg !3332
  br i1 %10, label %11, label %17, !dbg !3331

11:                                               ; preds = %8
    #dbg_declare(ptr %4, !3333, !DIExpression(), !3335)
  %12 = load ptr, ptr %3, align 8, !dbg !3336
  %13 = getelementptr inbounds nuw %struct.ListNode, ptr %12, i32 0, i32 2, !dbg !3337
  call void @__log_load(ptr %13), !dbg !3337
  %14 = load ptr, ptr %13, align 8, !dbg !3337
  store ptr %14, ptr %4, align 8, !dbg !3335
  %15 = load ptr, ptr %3, align 8, !dbg !3338
  call void @free(ptr noundef %15) #11, !dbg !3339
  %16 = load ptr, ptr %4, align 8, !dbg !3340
  store ptr %16, ptr %3, align 8, !dbg !3341
  br label %8, !dbg !3331, !llvm.loop !3342

17:                                               ; preds = %8
  %18 = load ptr, ptr %2, align 8, !dbg !3344
  %19 = getelementptr inbounds nuw %struct.SharedList, ptr %18, i32 0, i32 0, !dbg !3345
  call void @__log_store(ptr %19), !dbg !3346
  store ptr null, ptr %19, align 8, !dbg !3346
  ret void, !dbg !3347
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_destroy(ptr noundef) #4

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal void @_ZL11list_insertP10SharedListii(ptr noundef %0, i32 noundef %1, i32 noundef %2) #1 !dbg !3348 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !3351, !DIExpression(), !3352)
  store i32 %1, ptr %5, align 4
    #dbg_declare(ptr %5, !3353, !DIExpression(), !3354)
  store i32 %2, ptr %6, align 4
    #dbg_declare(ptr %6, !3355, !DIExpression(), !3356)
    #dbg_declare(ptr %7, !3357, !DIExpression(), !3358)
  %9 = call noalias ptr @malloc(i64 noundef 16) #11, !dbg !3359
  store ptr %9, ptr %7, align 8, !dbg !3358
  %10 = load i32, ptr %5, align 4, !dbg !3360
  %11 = load ptr, ptr %7, align 8, !dbg !3361
  %12 = getelementptr inbounds nuw %struct.ListNode, ptr %11, i32 0, i32 0, !dbg !3362
  call void @__log_store(ptr %12), !dbg !3363
  store i32 %10, ptr %12, align 8, !dbg !3363
  %13 = load i32, ptr %6, align 4, !dbg !3364
  %14 = load ptr, ptr %7, align 8, !dbg !3365
  %15 = getelementptr inbounds nuw %struct.ListNode, ptr %14, i32 0, i32 1, !dbg !3366
  call void @__log_store(ptr %15), !dbg !3367
  store i32 %13, ptr %15, align 4, !dbg !3367
  %16 = load ptr, ptr %4, align 8, !dbg !3368
  %17 = getelementptr inbounds nuw %struct.SharedList, ptr %16, i32 0, i32 1, !dbg !3369
  %18 = call i32 @pthread_rwlock_wrlock(ptr noundef %17) #11, !dbg !3370
    #dbg_declare(ptr %8, !3371, !DIExpression(), !3373)
  %19 = load ptr, ptr %4, align 8, !dbg !3374
  %20 = getelementptr inbounds nuw %struct.SharedList, ptr %19, i32 0, i32 0, !dbg !3375
  store ptr %20, ptr %8, align 8, !dbg !3373
  br label %21, !dbg !3376

21:                                               ; preds = %34, %3
  %22 = load ptr, ptr %8, align 8, !dbg !3377
  call void @__log_load(ptr %22), !dbg !3378
  %23 = load ptr, ptr %22, align 8, !dbg !3378
  %24 = icmp ne ptr %23, null, !dbg !3378
  br i1 %24, label %25, label %32, !dbg !3379

25:                                               ; preds = %21
  %26 = load ptr, ptr %8, align 8, !dbg !3380
  call void @__log_load(ptr %26), !dbg !3381
  %27 = load ptr, ptr %26, align 8, !dbg !3381
  %28 = getelementptr inbounds nuw %struct.ListNode, ptr %27, i32 0, i32 0, !dbg !3382
  call void @__log_load(ptr %28), !dbg !3382
  %29 = load i32, ptr %28, align 8, !dbg !3382
  %30 = load i32, ptr %5, align 4, !dbg !3383
  %31 = icmp slt i32 %29, %30, !dbg !3384
  br label %32

32:                                               ; preds = %25, %21
  %33 = phi i1 [ false, %21 ], [ %31, %25 ], !dbg !3385
  br i1 %33, label %34, label %38, !dbg !3376

34:                                               ; preds = %32
  %35 = load ptr, ptr %8, align 8, !dbg !3386
  call void @__log_load(ptr %35), !dbg !3387
  %36 = load ptr, ptr %35, align 8, !dbg !3387
  %37 = getelementptr inbounds nuw %struct.ListNode, ptr %36, i32 0, i32 2, !dbg !3388
  store ptr %37, ptr %8, align 8, !dbg !3389
  br label %21, !dbg !3376, !llvm.loop !3390

38:                                               ; preds = %32
  %39 = load ptr, ptr %8, align 8, !dbg !3391
  call void @__log_load(ptr %39), !dbg !3392
  %40 = load ptr, ptr %39, align 8, !dbg !3392
  %41 = load ptr, ptr %7, align 8, !dbg !3393
  %42 = getelementptr inbounds nuw %struct.ListNode, ptr %41, i32 0, i32 2, !dbg !3394
  call void @__log_store(ptr %42), !dbg !3395
  store ptr %40, ptr %42, align 8, !dbg !3395
  %43 = load ptr, ptr %7, align 8, !dbg !3396
  %44 = load ptr, ptr %8, align 8, !dbg !3397
  call void @__log_store(ptr %44), !dbg !3398
  store ptr %43, ptr %44, align 8, !dbg !3398
  %45 = load ptr, ptr %4, align 8, !dbg !3399
  %46 = getelementptr inbounds nuw %struct.SharedList, ptr %45, i32 0, i32 1, !dbg !3400
  %47 = call i32 @pthread_rwlock_unlock(ptr noundef %46) #11, !dbg !3401
  ret void, !dbg !3402
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef i32 @_ZL11list_lookupP10SharedListi(ptr noundef %0, i32 noundef %1) #1 !dbg !3403 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !3406, !DIExpression(), !3407)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !3408, !DIExpression(), !3409)
  %7 = load ptr, ptr %3, align 8, !dbg !3410
  %8 = getelementptr inbounds nuw %struct.SharedList, ptr %7, i32 0, i32 1, !dbg !3411
  %9 = call i32 @pthread_rwlock_rdlock(ptr noundef %8) #11, !dbg !3412
    #dbg_declare(ptr %5, !3413, !DIExpression(), !3414)
  %10 = load ptr, ptr %3, align 8, !dbg !3415
  %11 = getelementptr inbounds nuw %struct.SharedList, ptr %10, i32 0, i32 0, !dbg !3416
  call void @__log_load(ptr %11), !dbg !3416
  %12 = load ptr, ptr %11, align 8, !dbg !3416
  store ptr %12, ptr %5, align 8, !dbg !3414
  br label %13, !dbg !3417

13:                                               ; preds = %24, %2
  %14 = load ptr, ptr %5, align 8, !dbg !3418
  %15 = icmp ne ptr %14, null, !dbg !3418
  br i1 %15, label %16, label %22, !dbg !3419

16:                                               ; preds = %13
  %17 = load ptr, ptr %5, align 8, !dbg !3420
  %18 = getelementptr inbounds nuw %struct.ListNode, ptr %17, i32 0, i32 0, !dbg !3421
  call void @__log_load(ptr %18), !dbg !3421
  %19 = load i32, ptr %18, align 8, !dbg !3421
  %20 = load i32, ptr %4, align 4, !dbg !3422
  %21 = icmp slt i32 %19, %20, !dbg !3423
  br label %22

22:                                               ; preds = %16, %13
  %23 = phi i1 [ false, %13 ], [ %21, %16 ], !dbg !3424
  br i1 %23, label %24, label %28, !dbg !3417

24:                                               ; preds = %22
  %25 = load ptr, ptr %5, align 8, !dbg !3425
  %26 = getelementptr inbounds nuw %struct.ListNode, ptr %25, i32 0, i32 2, !dbg !3426
  call void @__log_load(ptr %26), !dbg !3426
  %27 = load ptr, ptr %26, align 8, !dbg !3426
  store ptr %27, ptr %5, align 8, !dbg !3427
  br label %13, !dbg !3417, !llvm.loop !3428

28:                                               ; preds = %22
    #dbg_declare(ptr %6, !3429, !DIExpression(), !3430)
  %29 = load ptr, ptr %5, align 8, !dbg !3431
  %30 = icmp ne ptr %29, null, !dbg !3431
  br i1 %30, label %31, label %41, !dbg !3432

31:                                               ; preds = %28
  %32 = load ptr, ptr %5, align 8, !dbg !3433
  %33 = getelementptr inbounds nuw %struct.ListNode, ptr %32, i32 0, i32 0, !dbg !3434
  call void @__log_load(ptr %33), !dbg !3434
  %34 = load i32, ptr %33, align 8, !dbg !3434
  %35 = load i32, ptr %4, align 4, !dbg !3435
  %36 = icmp eq i32 %34, %35, !dbg !3436
  br i1 %36, label %37, label %41, !dbg !3437

37:                                               ; preds = %31
  %38 = load ptr, ptr %5, align 8, !dbg !3438
  %39 = getelementptr inbounds nuw %struct.ListNode, ptr %38, i32 0, i32 1, !dbg !3439
  call void @__log_load(ptr %39), !dbg !3439
  %40 = load i32, ptr %39, align 4, !dbg !3439
  br label %42, !dbg !3437

41:                                               ; preds = %31, %28
  br label %42, !dbg !3437

42:                                               ; preds = %41, %37
  %43 = phi i32 [ %40, %37 ], [ -1, %41 ], !dbg !3437
  store i32 %43, ptr %6, align 4, !dbg !3430
  %44 = load ptr, ptr %3, align 8, !dbg !3440
  %45 = getelementptr inbounds nuw %struct.SharedList, ptr %44, i32 0, i32 1, !dbg !3441
  %46 = call i32 @pthread_rwlock_unlock(ptr noundef %45) #11, !dbg !3442
  %47 = load i32, ptr %6, align 4, !dbg !3443
  ret i32 %47, !dbg !3444
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_wrlock(ptr noundef) #4

; Function Attrs: nounwind
declare i32 @pthread_rwlock_unlock(ptr noundef) #4

; Function Attrs: nounwind
declare i32 @pthread_rwlock_rdlock(ptr noundef) #4

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef ptr @_ZL13phaseD_packedPv(ptr noundef %0) #1 !dbg !3445 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !3446, !DIExpression(), !3447)
    #dbg_declare(ptr %3, !3448, !DIExpression(), !3449)
  %6 = load ptr, ptr %2, align 8, !dbg !3450
  store ptr %6, ptr %3, align 8, !dbg !3449
    #dbg_declare(ptr %4, !3451, !DIExpression(), !3452)
  %7 = call noundef double @_ZL6now_msv() #10, !dbg !3453
  store double %7, ptr %4, align 8, !dbg !3452
    #dbg_declare(ptr %5, !3454, !DIExpression(), !3456)
  store i32 0, ptr %5, align 4, !dbg !3456
  br label %8, !dbg !3457

8:                                                ; preds = %22, %1
  %9 = load i32, ptr %5, align 4, !dbg !3458
  %10 = load ptr, ptr %3, align 8, !dbg !3460
  %11 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %10, i32 0, i32 1, !dbg !3461
  call void @__log_load(ptr %11), !dbg !3461
  %12 = load i32, ptr %11, align 4, !dbg !3461
  %13 = icmp slt i32 %9, %12, !dbg !3462
  br i1 %13, label %14, label %25, !dbg !3463

14:                                               ; preds = %8
  %15 = load ptr, ptr %3, align 8, !dbg !3464
  %16 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %15, i32 0, i32 0, !dbg !3465
  call void @__log_load(ptr %16), !dbg !3465
  %17 = load i32, ptr %16, align 8, !dbg !3465
  %18 = sext i32 %17 to i64, !dbg !3466
  %19 = getelementptr inbounds [16 x i32], ptr @_ZL8g_packed, i64 0, i64 %18, !dbg !3466
  call void @__log_load(ptr %19), !dbg !3467
  %20 = load i32, ptr %19, align 4, !dbg !3467
  %21 = add nsw i32 %20, 1, !dbg !3467
  call void @__log_store(ptr %19), !dbg !3467
  store i32 %21, ptr %19, align 4, !dbg !3467
  br label %22, !dbg !3466

22:                                               ; preds = %14
  %23 = load i32, ptr %5, align 4, !dbg !3468
  %24 = add nsw i32 %23, 1, !dbg !3468
  store i32 %24, ptr %5, align 4, !dbg !3468
  br label %8, !dbg !3469, !llvm.loop !3470

25:                                               ; preds = %8
  %26 = call noundef double @_ZL6now_msv() #10, !dbg !3472
  %27 = load double, ptr %4, align 8, !dbg !3473
  %28 = fsub double %26, %27, !dbg !3474
  %29 = load ptr, ptr %3, align 8, !dbg !3475
  %30 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %29, i32 0, i32 2, !dbg !3476
  call void @__log_store(ptr %30), !dbg !3477
  store double %28, ptr %30, align 8, !dbg !3477
  ret ptr null, !dbg !3478
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef ptr @_ZL13phaseD_paddedPv(ptr noundef %0) #1 !dbg !3479 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !3480, !DIExpression(), !3481)
    #dbg_declare(ptr %3, !3482, !DIExpression(), !3483)
  %6 = load ptr, ptr %2, align 8, !dbg !3484
  store ptr %6, ptr %3, align 8, !dbg !3483
    #dbg_declare(ptr %4, !3485, !DIExpression(), !3486)
  %7 = call noundef double @_ZL6now_msv() #10, !dbg !3487
  store double %7, ptr %4, align 8, !dbg !3486
    #dbg_declare(ptr %5, !3488, !DIExpression(), !3490)
  store i32 0, ptr %5, align 4, !dbg !3490
  br label %8, !dbg !3491

8:                                                ; preds = %23, %1
  %9 = load i32, ptr %5, align 4, !dbg !3492
  %10 = load ptr, ptr %3, align 8, !dbg !3494
  %11 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %10, i32 0, i32 1, !dbg !3495
  call void @__log_load(ptr %11), !dbg !3495
  %12 = load i32, ptr %11, align 4, !dbg !3495
  %13 = icmp slt i32 %9, %12, !dbg !3496
  br i1 %13, label %14, label %26, !dbg !3497

14:                                               ; preds = %8
  %15 = load ptr, ptr %3, align 8, !dbg !3498
  %16 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %15, i32 0, i32 0, !dbg !3499
  call void @__log_load(ptr %16), !dbg !3499
  %17 = load i32, ptr %16, align 8, !dbg !3499
  %18 = sext i32 %17 to i64, !dbg !3500
  %19 = getelementptr inbounds [16 x %struct.PaddedCounter], ptr @_ZL8g_padded, i64 0, i64 %18, !dbg !3500
  %20 = getelementptr inbounds nuw %struct.PaddedCounter, ptr %19, i32 0, i32 0, !dbg !3501
  call void @__log_load(ptr %20), !dbg !3502
  %21 = load i32, ptr %20, align 64, !dbg !3502
  %22 = add nsw i32 %21, 1, !dbg !3502
  call void @__log_store(ptr %20), !dbg !3502
  store i32 %22, ptr %20, align 64, !dbg !3502
  br label %23, !dbg !3500

23:                                               ; preds = %14
  %24 = load i32, ptr %5, align 4, !dbg !3503
  %25 = add nsw i32 %24, 1, !dbg !3503
  store i32 %25, ptr %5, align 4, !dbg !3503
  br label %8, !dbg !3504, !llvm.loop !3505

26:                                               ; preds = %8
  %27 = call noundef double @_ZL6now_msv() #10, !dbg !3507
  %28 = load double, ptr %4, align 8, !dbg !3508
  %29 = fsub double %27, %28, !dbg !3509
  %30 = load ptr, ptr %3, align 8, !dbg !3510
  %31 = getelementptr inbounds nuw %struct.PhaseD_Args, ptr %30, i32 0, i32 3, !dbg !3511
  call void @__log_store(ptr %31), !dbg !3512
  store double %29, ptr %31, align 8, !dbg !3512
  ret ptr null, !dbg !3513
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal noundef double @"_ZZL13print_summaryllllllllENK3$_0clEll"(ptr noundef nonnull align 1 dereferenceable(1) %0, i64 noundef %1, i64 noundef %2) #1 align 2 !dbg !3514 {
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !3515, !DIExpression(), !3517)
  store i64 %1, ptr %5, align 8
    #dbg_declare(ptr %5, !3518, !DIExpression(), !3519)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !3520, !DIExpression(), !3521)
  %7 = load ptr, ptr %4, align 8
  %8 = load i64, ptr %5, align 8, !dbg !3522
  %9 = load i64, ptr %6, align 8, !dbg !3523
  %10 = add nsw i64 %8, %9, !dbg !3524
  %11 = icmp sgt i64 %10, 0, !dbg !3525
  br i1 %11, label %12, label %21, !dbg !3526

12:                                               ; preds = %3
  %13 = load i64, ptr %5, align 8, !dbg !3527
  %14 = sitofp i64 %13 to double, !dbg !3527
  %15 = fmul double 1.000000e+02, %14, !dbg !3528
  %16 = load i64, ptr %5, align 8, !dbg !3529
  %17 = load i64, ptr %6, align 8, !dbg !3530
  %18 = add nsw i64 %16, %17, !dbg !3531
  %19 = sitofp i64 %18 to double, !dbg !3532
  %20 = fdiv double %15, %19, !dbg !3533
  br label %22, !dbg !3526

21:                                               ; preds = %3
  br label %22, !dbg !3526

22:                                               ; preds = %21, %12
  %23 = phi double [ %20, %12 ], [ 0.000000e+00, %21 ], !dbg !3526
  ret double %23, !dbg !3534
}

declare void @__log_load(ptr)

declare void @__log_store(ptr)

declare void @__log_lock(ptr)

declare void @__log_unlock(ptr)

attributes #0 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #8 = { cold noreturn nounwind "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { nobuiltin nounwind willreturn memory(read) "no-builtins" }
attributes #10 = { nobuiltin "no-builtins" }
attributes #11 = { nobuiltin nounwind "no-builtins" }
attributes #12 = { cold nobuiltin noreturn nounwind "no-builtins" }

!llvm.dbg.cu = !{!2}
!llvm.linker.options = !{}
!llvm.module.flags = !{!1756, !1757, !1758, !1759, !1760, !1761, !1762}
!llvm.ident = !{!1763}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "G_NTHREADS", linkageName: "_ZL10G_NTHREADS", scope: !2, file: !3, line: 93, type: !16, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 20.1.8 (0ubuntu4)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !118, globals: !531, imports: !782, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "src/benchmark_load.cpp", directory: "/home/rahulm/work/cs636/CS636_course_project_IITK/fasttrack/testing_temp_dir", checksumkind: CSK_MD5, checksum: "ed4d084740fc77f680f3628a2bf8a737")
!4 = !{!5, !13, !96, !103, !112}
!5 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "_Lock_policy", scope: !7, file: !6, line: 54, baseType: !8, size: 32, elements: !9, identifier: "_ZTSN9__gnu_cxx12_Lock_policyE")
!6 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/ext/concurrence.h", directory: "", checksumkind: CSK_MD5, checksum: "7eb73f693c5d4467e38c45c9b994f1b6")
!7 = !DINamespace(name: "__gnu_cxx", scope: null)
!8 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!9 = !{!10, !11, !12}
!10 = !DIEnumerator(name: "_S_single", value: 0, isUnsigned: true)
!11 = !DIEnumerator(name: "_S_mutex", value: 1, isUnsigned: true)
!12 = !DIEnumerator(name: "_S_atomic", value: 2, isUnsigned: true)
!13 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "errc", scope: !15, file: !14, line: 40, baseType: !16, size: 32, flags: DIFlagEnumClass, elements: !17, identifier: "_ZTSSt4errc")
!14 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/x86_64-linux-gnu/c++/15/bits/error_constants.h", directory: "", checksumkind: CSK_MD5, checksum: "0e08b5197d6ac4d506ce66236887d70d")
!15 = !DINamespace(name: "std", scope: null)
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{!18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95}
!18 = !DIEnumerator(name: "address_family_not_supported", value: 97)
!19 = !DIEnumerator(name: "address_in_use", value: 98)
!20 = !DIEnumerator(name: "address_not_available", value: 99)
!21 = !DIEnumerator(name: "already_connected", value: 106)
!22 = !DIEnumerator(name: "argument_list_too_long", value: 7)
!23 = !DIEnumerator(name: "argument_out_of_domain", value: 33)
!24 = !DIEnumerator(name: "bad_address", value: 14)
!25 = !DIEnumerator(name: "bad_file_descriptor", value: 9)
!26 = !DIEnumerator(name: "bad_message", value: 74)
!27 = !DIEnumerator(name: "broken_pipe", value: 32)
!28 = !DIEnumerator(name: "connection_aborted", value: 103)
!29 = !DIEnumerator(name: "connection_already_in_progress", value: 114)
!30 = !DIEnumerator(name: "connection_refused", value: 111)
!31 = !DIEnumerator(name: "connection_reset", value: 104)
!32 = !DIEnumerator(name: "cross_device_link", value: 18)
!33 = !DIEnumerator(name: "destination_address_required", value: 89)
!34 = !DIEnumerator(name: "device_or_resource_busy", value: 16)
!35 = !DIEnumerator(name: "directory_not_empty", value: 39)
!36 = !DIEnumerator(name: "executable_format_error", value: 8)
!37 = !DIEnumerator(name: "file_exists", value: 17)
!38 = !DIEnumerator(name: "file_too_large", value: 27)
!39 = !DIEnumerator(name: "filename_too_long", value: 36)
!40 = !DIEnumerator(name: "function_not_supported", value: 38)
!41 = !DIEnumerator(name: "host_unreachable", value: 113)
!42 = !DIEnumerator(name: "identifier_removed", value: 43)
!43 = !DIEnumerator(name: "illegal_byte_sequence", value: 84)
!44 = !DIEnumerator(name: "inappropriate_io_control_operation", value: 25)
!45 = !DIEnumerator(name: "interrupted", value: 4)
!46 = !DIEnumerator(name: "invalid_argument", value: 22)
!47 = !DIEnumerator(name: "invalid_seek", value: 29)
!48 = !DIEnumerator(name: "io_error", value: 5)
!49 = !DIEnumerator(name: "is_a_directory", value: 21)
!50 = !DIEnumerator(name: "message_size", value: 90)
!51 = !DIEnumerator(name: "network_down", value: 100)
!52 = !DIEnumerator(name: "network_reset", value: 102)
!53 = !DIEnumerator(name: "network_unreachable", value: 101)
!54 = !DIEnumerator(name: "no_buffer_space", value: 105)
!55 = !DIEnumerator(name: "no_child_process", value: 10)
!56 = !DIEnumerator(name: "no_link", value: 67)
!57 = !DIEnumerator(name: "no_lock_available", value: 37)
!58 = !DIEnumerator(name: "no_message_available", value: 61)
!59 = !DIEnumerator(name: "no_message", value: 42)
!60 = !DIEnumerator(name: "no_protocol_option", value: 92)
!61 = !DIEnumerator(name: "no_space_on_device", value: 28)
!62 = !DIEnumerator(name: "no_stream_resources", value: 63)
!63 = !DIEnumerator(name: "no_such_device_or_address", value: 6)
!64 = !DIEnumerator(name: "no_such_device", value: 19)
!65 = !DIEnumerator(name: "no_such_file_or_directory", value: 2)
!66 = !DIEnumerator(name: "no_such_process", value: 3)
!67 = !DIEnumerator(name: "not_a_directory", value: 20)
!68 = !DIEnumerator(name: "not_a_socket", value: 88)
!69 = !DIEnumerator(name: "not_a_stream", value: 60)
!70 = !DIEnumerator(name: "not_connected", value: 107)
!71 = !DIEnumerator(name: "not_enough_memory", value: 12)
!72 = !DIEnumerator(name: "not_supported", value: 95)
!73 = !DIEnumerator(name: "operation_canceled", value: 125)
!74 = !DIEnumerator(name: "operation_in_progress", value: 115)
!75 = !DIEnumerator(name: "operation_not_permitted", value: 1)
!76 = !DIEnumerator(name: "operation_not_supported", value: 95)
!77 = !DIEnumerator(name: "operation_would_block", value: 11)
!78 = !DIEnumerator(name: "owner_dead", value: 130)
!79 = !DIEnumerator(name: "permission_denied", value: 13)
!80 = !DIEnumerator(name: "protocol_error", value: 71)
!81 = !DIEnumerator(name: "protocol_not_supported", value: 93)
!82 = !DIEnumerator(name: "read_only_file_system", value: 30)
!83 = !DIEnumerator(name: "resource_deadlock_would_occur", value: 35)
!84 = !DIEnumerator(name: "resource_unavailable_try_again", value: 11)
!85 = !DIEnumerator(name: "result_out_of_range", value: 34)
!86 = !DIEnumerator(name: "state_not_recoverable", value: 131)
!87 = !DIEnumerator(name: "stream_timeout", value: 62)
!88 = !DIEnumerator(name: "text_file_busy", value: 26)
!89 = !DIEnumerator(name: "timed_out", value: 110)
!90 = !DIEnumerator(name: "too_many_files_open_in_system", value: 23)
!91 = !DIEnumerator(name: "too_many_files_open", value: 24)
!92 = !DIEnumerator(name: "too_many_links", value: 31)
!93 = !DIEnumerator(name: "too_many_symbolic_link_levels", value: 40)
!94 = !DIEnumerator(name: "value_too_large", value: 75)
!95 = !DIEnumerator(name: "wrong_protocol_type", value: 91)
!96 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "chars_format", scope: !15, file: !97, line: 625, baseType: !16, size: 32, flags: DIFlagEnumClass, elements: !98, identifier: "_ZTSSt12chars_format")
!97 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/charconv", directory: "", checksumkind: CSK_MD5, checksum: "b992fa2a4889a430ba299555276bcf81")
!98 = !{!99, !100, !101, !102}
!99 = !DIEnumerator(name: "scientific", value: 1)
!100 = !DIEnumerator(name: "fixed", value: 2)
!101 = !DIEnumerator(name: "hex", value: 4)
!102 = !DIEnumerator(name: "general", value: 3)
!103 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", scope: !15, file: !104, line: 65, baseType: !16, size: 32, flags: DIFlagEnumClass, elements: !105, identifier: "_ZTSSt12memory_order")
!104 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/atomic_base.h", directory: "", checksumkind: CSK_MD5, checksum: "a65f3932e944795c8e78b00d2e7f11a0")
!105 = !{!106, !107, !108, !109, !110, !111}
!106 = !DIEnumerator(name: "relaxed", value: 0)
!107 = !DIEnumerator(name: "consume", value: 1)
!108 = !DIEnumerator(name: "acquire", value: 2)
!109 = !DIEnumerator(name: "release", value: 3)
!110 = !DIEnumerator(name: "acq_rel", value: 4)
!111 = !DIEnumerator(name: "seq_cst", value: 5)
!112 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "__memory_order_modifier", scope: !15, file: !104, line: 94, baseType: !8, size: 32, elements: !113, identifier: "_ZTSSt23__memory_order_modifier")
!113 = !{!114, !115, !116, !117}
!114 = !DIEnumerator(name: "__memory_order_mask", value: 65535, isUnsigned: true)
!115 = !DIEnumerator(name: "__memory_order_modifier_mask", value: 4294901760, isUnsigned: true)
!116 = !DIEnumerator(name: "__memory_order_hle_acquire", value: 65536, isUnsigned: true)
!117 = !DIEnumerator(name: "__memory_order_hle_release", value: 131072, isUnsigned: true)
!118 = !{!119, !126, !124, !130, !131, !16, !132, !340, !346, !353, !257, !103, !143, !354, !362, !368, !376, !502, !185, !181}
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PhaseA_Args", file: !3, line: 105, size: 192, flags: DIFlagTypePassByValue, elements: !121, identifier: "_ZTS11PhaseA_Args")
!121 = !{!122, !123, !125}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "thread_id", scope: !120, file: !3, line: 106, baseType: !16, size: 32)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "private_accesses", scope: !120, file: !3, line: 107, baseType: !124, size: 64, offset: 64)
!124 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "shared_accesses", scope: !120, file: !3, line: 108, baseType: !124, size: 64, offset: 128)
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !128, line: 27, baseType: !129)
!128 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8e06fe5d0f3f3d4ee6a7a8929dd2b809")
!129 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!130 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 64)
!131 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!132 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!133 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "RingQueue", file: !3, line: 199, size: 8389056, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !134, identifier: "_ZTS9RingQueue")
!134 = !{!135, !148, !150, !151, !180}
!135 = !DIDerivedType(tag: DW_TAG_member, name: "slots", scope: !133, file: !3, line: 200, baseType: !136, size: 8388608)
!136 = !DICompositeType(tag: DW_TAG_array_type, baseType: !137, size: 8388608, elements: !146)
!137 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "WorkItem", file: !3, line: 193, size: 512, flags: DIFlagTypePassByValue, elements: !138, identifier: "_ZTS8WorkItem")
!138 = !{!139, !140, !141}
!139 = !DIDerivedType(tag: DW_TAG_member, name: "producer_id", scope: !137, file: !3, line: 194, baseType: !16, size: 32)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !137, file: !3, line: 195, baseType: !16, size: 32, offset: 32)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "payload", scope: !137, file: !3, line: 196, baseType: !142, size: 448, offset: 64)
!142 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 448, elements: !144)
!143 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!144 = !{!145}
!145 = !DISubrange(count: 56)
!146 = !{!147}
!147 = !DISubrange(count: 16384)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !133, file: !3, line: 201, baseType: !149, size: 32, offset: 8388608)
!149 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !16)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !133, file: !3, line: 202, baseType: !149, size: 32, offset: 8388640)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !133, file: !3, line: 203, baseType: !152, size: 320, offset: 8388672)
!152 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !128, line: 72, baseType: !153)
!153 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !128, line: 67, size: 320, flags: DIFlagTypePassByValue, elements: !154, identifier: "_ZTS15pthread_mutex_t")
!154 = !{!155, !175, !179}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !153, file: !128, line: 69, baseType: !156, size: 320)
!156 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !157, line: 22, size: 320, flags: DIFlagTypePassByValue, elements: !158, identifier: "_ZTS17__pthread_mutex_s")
!157 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "dd3989155840df74989f662ad537bbcc")
!158 = !{!159, !160, !161, !162, !163, !164, !166, !167}
!159 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !156, file: !157, line: 24, baseType: !16, size: 32)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !156, file: !157, line: 25, baseType: !8, size: 32, offset: 32)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !156, file: !157, line: 26, baseType: !16, size: 32, offset: 64)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !156, file: !157, line: 28, baseType: !8, size: 32, offset: 96)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !156, file: !157, line: 32, baseType: !16, size: 32, offset: 128)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !156, file: !157, line: 34, baseType: !165, size: 16, offset: 160)
!165 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !156, file: !157, line: 35, baseType: !165, size: 16, offset: 176)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !156, file: !157, line: 36, baseType: !168, size: 128, offset: 192)
!168 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !169, line: 55, baseType: !170)
!169 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4de73b5923ab08445dd348713aeb0a37")
!170 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !169, line: 51, size: 128, flags: DIFlagTypePassByValue, elements: !171, identifier: "_ZTS23__pthread_internal_list")
!171 = !{!172, !174}
!172 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !170, file: !169, line: 53, baseType: !173, size: 64)
!173 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !170, size: 64)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !170, file: !169, line: 54, baseType: !173, size: 64, offset: 64)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !153, file: !128, line: 70, baseType: !176, size: 320)
!176 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 320, elements: !177)
!177 = !{!178}
!178 = !DISubrange(count: 40)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !153, file: !128, line: 71, baseType: !124, size: 64)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "done_producing", scope: !133, file: !3, line: 204, baseType: !181, size: 32, offset: 8388992)
!181 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "atomic<int>", scope: !15, file: !182, line: 832, size: 32, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !183, templateParams: !338, identifier: "_ZTSSt6atomicIiE")
!182 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/atomic", directory: "", checksumkind: CSK_MD5, checksum: "0629d22f554a52275f62402292b23e12")
!183 = !{!184, !313, !315, !319, !320, !325, !329, !334}
!184 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !181, baseType: !185, extraData: i32 0)
!185 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__atomic_base<int>", scope: !15, file: !104, line: 338, size: 32, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !186, templateParams: !311, identifier: "_ZTSSt13__atomic_baseIiE")
!186 = !{!187, !189, !191, !195, !196, !201, !205, !210, !213, !217, !222, !225, !228, !231, !234, !235, !236, !239, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !258, !261, !264, !267, !270, !273, !276, !279, !283, !286, !289, !292, !293, !294, !295, !296, !299, !300, !301, !302, !303, !304, !305, !306, !307, !308, !309, !310}
!187 = !DIDerivedType(tag: DW_TAG_variable, name: "_S_alignment", scope: !185, file: !104, line: 346, baseType: !188, flags: DIFlagPrivate | DIFlagStaticMember, extraData: i32 4)
!188 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !16)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "_M_i", scope: !185, file: !104, line: 349, baseType: !190, size: 32, align: 32, flags: DIFlagPrivate)
!190 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_type", scope: !185, file: !104, line: 344, baseType: !16, flags: DIFlagPrivate)
!191 = !DISubprogram(name: "__atomic_base", scope: !185, file: !104, line: 352, type: !192, scopeLine: 352, flags: DIFlagPrototyped, spFlags: 0)
!192 = !DISubroutineType(types: !193)
!193 = !{null, !194}
!194 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!195 = !DISubprogram(name: "~__atomic_base", scope: !185, file: !104, line: 353, type: !192, scopeLine: 353, flags: DIFlagPrototyped, spFlags: 0)
!196 = !DISubprogram(name: "__atomic_base", scope: !185, file: !104, line: 354, type: !197, scopeLine: 354, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!197 = !DISubroutineType(types: !198)
!198 = !{null, !194, !199}
!199 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !200, size: 64)
!200 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !185)
!201 = !DISubprogram(name: "operator=", linkageName: "_ZNSt13__atomic_baseIiEaSERKS0_", scope: !185, file: !104, line: 355, type: !202, scopeLine: 355, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!202 = !DISubroutineType(types: !203)
!203 = !{!204, !194, !199}
!204 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !185, size: 64)
!205 = !DISubprogram(name: "operator=", linkageName: "_ZNVSt13__atomic_baseIiEaSERKS0_", scope: !185, file: !104, line: 356, type: !206, scopeLine: 356, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!206 = !DISubroutineType(types: !207)
!207 = !{!204, !208, !199}
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !209, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!209 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !185)
!210 = !DISubprogram(name: "__atomic_base", scope: !185, file: !104, line: 358, type: !211, scopeLine: 358, flags: DIFlagPrototyped, spFlags: 0)
!211 = !DISubroutineType(types: !212)
!212 = !{null, !194, !190}
!213 = !DISubprogram(name: "operator int", linkageName: "_ZNKSt13__atomic_baseIiEcviEv", scope: !185, file: !104, line: 360, type: !214, scopeLine: 360, flags: DIFlagPrototyped, spFlags: 0)
!214 = !DISubroutineType(types: !215)
!215 = !{!190, !216}
!216 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !200, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!217 = !DISubprogram(name: "operator int", linkageName: "_ZNVKSt13__atomic_baseIiEcviEv", scope: !185, file: !104, line: 363, type: !218, scopeLine: 363, flags: DIFlagPrototyped, spFlags: 0)
!218 = !DISubroutineType(types: !219)
!219 = !{!190, !220}
!220 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !221, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!221 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !209)
!222 = !DISubprogram(name: "operator=", linkageName: "_ZNSt13__atomic_baseIiEaSEi", scope: !185, file: !104, line: 367, type: !223, scopeLine: 367, flags: DIFlagPrototyped, spFlags: 0)
!223 = !DISubroutineType(types: !224)
!224 = !{!190, !194, !190}
!225 = !DISubprogram(name: "operator=", linkageName: "_ZNVSt13__atomic_baseIiEaSEi", scope: !185, file: !104, line: 374, type: !226, scopeLine: 374, flags: DIFlagPrototyped, spFlags: 0)
!226 = !DISubroutineType(types: !227)
!227 = !{!190, !208, !190}
!228 = !DISubprogram(name: "operator++", linkageName: "_ZNSt13__atomic_baseIiEppEi", scope: !185, file: !104, line: 381, type: !229, scopeLine: 381, flags: DIFlagPrototyped, spFlags: 0)
!229 = !DISubroutineType(types: !230)
!230 = !{!190, !194, !16}
!231 = !DISubprogram(name: "operator++", linkageName: "_ZNVSt13__atomic_baseIiEppEi", scope: !185, file: !104, line: 385, type: !232, scopeLine: 385, flags: DIFlagPrototyped, spFlags: 0)
!232 = !DISubroutineType(types: !233)
!233 = !{!190, !208, !16}
!234 = !DISubprogram(name: "operator--", linkageName: "_ZNSt13__atomic_baseIiEmmEi", scope: !185, file: !104, line: 389, type: !229, scopeLine: 389, flags: DIFlagPrototyped, spFlags: 0)
!235 = !DISubprogram(name: "operator--", linkageName: "_ZNVSt13__atomic_baseIiEmmEi", scope: !185, file: !104, line: 393, type: !232, scopeLine: 393, flags: DIFlagPrototyped, spFlags: 0)
!236 = !DISubprogram(name: "operator++", linkageName: "_ZNSt13__atomic_baseIiEppEv", scope: !185, file: !104, line: 397, type: !237, scopeLine: 397, flags: DIFlagPrototyped, spFlags: 0)
!237 = !DISubroutineType(types: !238)
!238 = !{!190, !194}
!239 = !DISubprogram(name: "operator++", linkageName: "_ZNVSt13__atomic_baseIiEppEv", scope: !185, file: !104, line: 401, type: !240, scopeLine: 401, flags: DIFlagPrototyped, spFlags: 0)
!240 = !DISubroutineType(types: !241)
!241 = !{!190, !208}
!242 = !DISubprogram(name: "operator--", linkageName: "_ZNSt13__atomic_baseIiEmmEv", scope: !185, file: !104, line: 405, type: !237, scopeLine: 405, flags: DIFlagPrototyped, spFlags: 0)
!243 = !DISubprogram(name: "operator--", linkageName: "_ZNVSt13__atomic_baseIiEmmEv", scope: !185, file: !104, line: 409, type: !240, scopeLine: 409, flags: DIFlagPrototyped, spFlags: 0)
!244 = !DISubprogram(name: "operator+=", linkageName: "_ZNSt13__atomic_baseIiEpLEi", scope: !185, file: !104, line: 413, type: !223, scopeLine: 413, flags: DIFlagPrototyped, spFlags: 0)
!245 = !DISubprogram(name: "operator+=", linkageName: "_ZNVSt13__atomic_baseIiEpLEi", scope: !185, file: !104, line: 417, type: !226, scopeLine: 417, flags: DIFlagPrototyped, spFlags: 0)
!246 = !DISubprogram(name: "operator-=", linkageName: "_ZNSt13__atomic_baseIiEmIEi", scope: !185, file: !104, line: 421, type: !223, scopeLine: 421, flags: DIFlagPrototyped, spFlags: 0)
!247 = !DISubprogram(name: "operator-=", linkageName: "_ZNVSt13__atomic_baseIiEmIEi", scope: !185, file: !104, line: 425, type: !226, scopeLine: 425, flags: DIFlagPrototyped, spFlags: 0)
!248 = !DISubprogram(name: "operator&=", linkageName: "_ZNSt13__atomic_baseIiEaNEi", scope: !185, file: !104, line: 429, type: !223, scopeLine: 429, flags: DIFlagPrototyped, spFlags: 0)
!249 = !DISubprogram(name: "operator&=", linkageName: "_ZNVSt13__atomic_baseIiEaNEi", scope: !185, file: !104, line: 433, type: !226, scopeLine: 433, flags: DIFlagPrototyped, spFlags: 0)
!250 = !DISubprogram(name: "operator|=", linkageName: "_ZNSt13__atomic_baseIiEoREi", scope: !185, file: !104, line: 437, type: !223, scopeLine: 437, flags: DIFlagPrototyped, spFlags: 0)
!251 = !DISubprogram(name: "operator|=", linkageName: "_ZNVSt13__atomic_baseIiEoREi", scope: !185, file: !104, line: 441, type: !226, scopeLine: 441, flags: DIFlagPrototyped, spFlags: 0)
!252 = !DISubprogram(name: "operator^=", linkageName: "_ZNSt13__atomic_baseIiEeOEi", scope: !185, file: !104, line: 445, type: !223, scopeLine: 445, flags: DIFlagPrototyped, spFlags: 0)
!253 = !DISubprogram(name: "operator^=", linkageName: "_ZNVSt13__atomic_baseIiEeOEi", scope: !185, file: !104, line: 449, type: !226, scopeLine: 449, flags: DIFlagPrototyped, spFlags: 0)
!254 = !DISubprogram(name: "is_lock_free", linkageName: "_ZNKSt13__atomic_baseIiE12is_lock_freeEv", scope: !185, file: !104, line: 453, type: !255, scopeLine: 453, flags: DIFlagPrototyped, spFlags: 0)
!255 = !DISubroutineType(types: !256)
!256 = !{!257, !216}
!257 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!258 = !DISubprogram(name: "is_lock_free", linkageName: "_ZNVKSt13__atomic_baseIiE12is_lock_freeEv", scope: !185, file: !104, line: 461, type: !259, scopeLine: 461, flags: DIFlagPrototyped, spFlags: 0)
!259 = !DISubroutineType(types: !260)
!260 = !{!257, !220}
!261 = !DISubprogram(name: "store", linkageName: "_ZNSt13__atomic_baseIiE5storeEiSt12memory_order", scope: !185, file: !104, line: 469, type: !262, scopeLine: 469, flags: DIFlagPrototyped, spFlags: 0)
!262 = !DISubroutineType(types: !263)
!263 = !{null, !194, !190, !103}
!264 = !DISubprogram(name: "store", linkageName: "_ZNVSt13__atomic_baseIiE5storeEiSt12memory_order", scope: !185, file: !104, line: 481, type: !265, scopeLine: 481, flags: DIFlagPrototyped, spFlags: 0)
!265 = !DISubroutineType(types: !266)
!266 = !{null, !208, !190, !103}
!267 = !DISubprogram(name: "load", linkageName: "_ZNKSt13__atomic_baseIiE4loadESt12memory_order", scope: !185, file: !104, line: 494, type: !268, scopeLine: 494, flags: DIFlagPrototyped, spFlags: 0)
!268 = !DISubroutineType(types: !269)
!269 = !{!190, !216, !103}
!270 = !DISubprogram(name: "load", linkageName: "_ZNVKSt13__atomic_baseIiE4loadESt12memory_order", scope: !185, file: !104, line: 505, type: !271, scopeLine: 505, flags: DIFlagPrototyped, spFlags: 0)
!271 = !DISubroutineType(types: !272)
!272 = !{!190, !220, !103}
!273 = !DISubprogram(name: "exchange", linkageName: "_ZNSt13__atomic_baseIiE8exchangeEiSt12memory_order", scope: !185, file: !104, line: 516, type: !274, scopeLine: 516, flags: DIFlagPrototyped, spFlags: 0)
!274 = !DISubroutineType(types: !275)
!275 = !{!190, !194, !190, !103}
!276 = !DISubprogram(name: "exchange", linkageName: "_ZNVSt13__atomic_baseIiE8exchangeEiSt12memory_order", scope: !185, file: !104, line: 524, type: !277, scopeLine: 524, flags: DIFlagPrototyped, spFlags: 0)
!277 = !DISubroutineType(types: !278)
!278 = !{!190, !208, !190, !103}
!279 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNSt13__atomic_baseIiE21compare_exchange_weakERiiSt12memory_orderS2_", scope: !185, file: !104, line: 531, type: !280, scopeLine: 531, flags: DIFlagPrototyped, spFlags: 0)
!280 = !DISubroutineType(types: !281)
!281 = !{!257, !194, !282, !190, !103, !103}
!282 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !190, size: 64)
!283 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNVSt13__atomic_baseIiE21compare_exchange_weakERiiSt12memory_orderS2_", scope: !185, file: !104, line: 541, type: !284, scopeLine: 541, flags: DIFlagPrototyped, spFlags: 0)
!284 = !DISubroutineType(types: !285)
!285 = !{!257, !208, !282, !190, !103, !103}
!286 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNSt13__atomic_baseIiE21compare_exchange_weakERiiSt12memory_order", scope: !185, file: !104, line: 552, type: !287, scopeLine: 552, flags: DIFlagPrototyped, spFlags: 0)
!287 = !DISubroutineType(types: !288)
!288 = !{!257, !194, !282, !190, !103}
!289 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNVSt13__atomic_baseIiE21compare_exchange_weakERiiSt12memory_order", scope: !185, file: !104, line: 560, type: !290, scopeLine: 560, flags: DIFlagPrototyped, spFlags: 0)
!290 = !DISubroutineType(types: !291)
!291 = !{!257, !208, !282, !190, !103}
!292 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_", scope: !185, file: !104, line: 568, type: !280, scopeLine: 568, flags: DIFlagPrototyped, spFlags: 0)
!293 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNVSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_", scope: !185, file: !104, line: 578, type: !284, scopeLine: 578, flags: DIFlagPrototyped, spFlags: 0)
!294 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_order", scope: !185, file: !104, line: 589, type: !287, scopeLine: 589, flags: DIFlagPrototyped, spFlags: 0)
!295 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNVSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_order", scope: !185, file: !104, line: 597, type: !290, scopeLine: 597, flags: DIFlagPrototyped, spFlags: 0)
!296 = !DISubprogram(name: "wait", linkageName: "_ZNKSt13__atomic_baseIiE4waitEiSt12memory_order", scope: !185, file: !104, line: 606, type: !297, scopeLine: 606, flags: DIFlagPrototyped, spFlags: 0)
!297 = !DISubroutineType(types: !298)
!298 = !{null, !216, !190, !103}
!299 = !DISubprogram(name: "notify_one", linkageName: "_ZNSt13__atomic_baseIiE10notify_oneEv", scope: !185, file: !104, line: 616, type: !192, scopeLine: 616, flags: DIFlagPrototyped, spFlags: 0)
!300 = !DISubprogram(name: "notify_all", linkageName: "_ZNSt13__atomic_baseIiE10notify_allEv", scope: !185, file: !104, line: 622, type: !192, scopeLine: 622, flags: DIFlagPrototyped, spFlags: 0)
!301 = !DISubprogram(name: "fetch_add", linkageName: "_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order", scope: !185, file: !104, line: 629, type: !274, scopeLine: 629, flags: DIFlagPrototyped, spFlags: 0)
!302 = !DISubprogram(name: "fetch_add", linkageName: "_ZNVSt13__atomic_baseIiE9fetch_addEiSt12memory_order", scope: !185, file: !104, line: 634, type: !277, scopeLine: 634, flags: DIFlagPrototyped, spFlags: 0)
!303 = !DISubprogram(name: "fetch_sub", linkageName: "_ZNSt13__atomic_baseIiE9fetch_subEiSt12memory_order", scope: !185, file: !104, line: 639, type: !274, scopeLine: 639, flags: DIFlagPrototyped, spFlags: 0)
!304 = !DISubprogram(name: "fetch_sub", linkageName: "_ZNVSt13__atomic_baseIiE9fetch_subEiSt12memory_order", scope: !185, file: !104, line: 644, type: !277, scopeLine: 644, flags: DIFlagPrototyped, spFlags: 0)
!305 = !DISubprogram(name: "fetch_and", linkageName: "_ZNSt13__atomic_baseIiE9fetch_andEiSt12memory_order", scope: !185, file: !104, line: 649, type: !274, scopeLine: 649, flags: DIFlagPrototyped, spFlags: 0)
!306 = !DISubprogram(name: "fetch_and", linkageName: "_ZNVSt13__atomic_baseIiE9fetch_andEiSt12memory_order", scope: !185, file: !104, line: 654, type: !277, scopeLine: 654, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DISubprogram(name: "fetch_or", linkageName: "_ZNSt13__atomic_baseIiE8fetch_orEiSt12memory_order", scope: !185, file: !104, line: 659, type: !274, scopeLine: 659, flags: DIFlagPrototyped, spFlags: 0)
!308 = !DISubprogram(name: "fetch_or", linkageName: "_ZNVSt13__atomic_baseIiE8fetch_orEiSt12memory_order", scope: !185, file: !104, line: 664, type: !277, scopeLine: 664, flags: DIFlagPrototyped, spFlags: 0)
!309 = !DISubprogram(name: "fetch_xor", linkageName: "_ZNSt13__atomic_baseIiE9fetch_xorEiSt12memory_order", scope: !185, file: !104, line: 669, type: !274, scopeLine: 669, flags: DIFlagPrototyped, spFlags: 0)
!310 = !DISubprogram(name: "fetch_xor", linkageName: "_ZNVSt13__atomic_baseIiE9fetch_xorEiSt12memory_order", scope: !185, file: !104, line: 674, type: !277, scopeLine: 674, flags: DIFlagPrototyped, spFlags: 0)
!311 = !{!312}
!312 = !DITemplateTypeParameter(name: "_ITp", type: !16)
!313 = !DIDerivedType(tag: DW_TAG_variable, name: "is_always_lock_free", scope: !181, file: !182, line: 849, baseType: !314, flags: DIFlagStaticMember, extraData: i1 true)
!314 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !257)
!315 = !DISubprogram(name: "atomic", scope: !181, file: !182, line: 837, type: !316, scopeLine: 837, flags: DIFlagPrototyped, spFlags: 0)
!316 = !DISubroutineType(types: !317)
!317 = !{null, !318}
!318 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !181, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!319 = !DISubprogram(name: "~atomic", scope: !181, file: !182, line: 838, type: !316, scopeLine: 838, flags: DIFlagPrototyped, spFlags: 0)
!320 = !DISubprogram(name: "atomic", scope: !181, file: !182, line: 839, type: !321, scopeLine: 839, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!321 = !DISubroutineType(types: !322)
!322 = !{null, !318, !323}
!323 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !324, size: 64)
!324 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !181)
!325 = !DISubprogram(name: "operator=", linkageName: "_ZNSt6atomicIiEaSERKS0_", scope: !181, file: !182, line: 840, type: !326, scopeLine: 840, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!326 = !DISubroutineType(types: !327)
!327 = !{!328, !318, !323}
!328 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !181, size: 64)
!329 = !DISubprogram(name: "operator=", linkageName: "_ZNVSt6atomicIiEaSERKS0_", scope: !181, file: !182, line: 841, type: !330, scopeLine: 841, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!330 = !DISubroutineType(types: !331)
!331 = !{!328, !332, !323}
!332 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !333, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!333 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !181)
!334 = !DISubprogram(name: "atomic", scope: !181, file: !182, line: 843, type: !335, scopeLine: 843, flags: DIFlagPrototyped, spFlags: 0)
!335 = !DISubroutineType(types: !336)
!336 = !{null, !318, !337}
!337 = !DIDerivedType(tag: DW_TAG_typedef, name: "__integral_type", scope: !181, file: !182, line: 834, baseType: !16)
!338 = !{!339}
!339 = !DITemplateTypeParameter(name: "_Tp", type: !16)
!340 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !341, size: 64)
!341 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PhaseB_ProducerArgs", file: !3, line: 228, size: 128, flags: DIFlagTypePassByValue, elements: !342, identifier: "_ZTS19PhaseB_ProducerArgs")
!342 = !{!343, !344, !345}
!343 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !341, file: !3, line: 228, baseType: !16, size: 32)
!344 = !DIDerivedType(tag: DW_TAG_member, name: "items_to_produce", scope: !341, file: !3, line: 228, baseType: !16, size: 32, offset: 32)
!345 = !DIDerivedType(tag: DW_TAG_member, name: "shared_acc", scope: !341, file: !3, line: 228, baseType: !124, size: 64, offset: 64)
!346 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !347, size: 64)
!347 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PhaseB_ConsumerArgs", file: !3, line: 229, size: 256, flags: DIFlagTypePassByValue, elements: !348, identifier: "_ZTS19PhaseB_ConsumerArgs")
!348 = !{!349, !350, !351, !352}
!349 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !347, file: !3, line: 229, baseType: !16, size: 32)
!350 = !DIDerivedType(tag: DW_TAG_member, name: "items_consumed", scope: !347, file: !3, line: 229, baseType: !124, size: 64, offset: 64)
!351 = !DIDerivedType(tag: DW_TAG_member, name: "private_acc", scope: !347, file: !3, line: 229, baseType: !124, size: 64, offset: 128)
!352 = !DIDerivedType(tag: DW_TAG_member, name: "shared_acc", scope: !347, file: !3, line: 229, baseType: !124, size: 64, offset: 192)
!353 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!354 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !355, size: 64)
!355 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PhaseC_Args", file: !3, line: 378, size: 256, flags: DIFlagTypePassByValue, elements: !356, identifier: "_ZTS11PhaseC_Args")
!356 = !{!357, !358, !359, !360, !361}
!357 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !355, file: !3, line: 379, baseType: !16, size: 32)
!358 = !DIDerivedType(tag: DW_TAG_member, name: "n_inserts", scope: !355, file: !3, line: 380, baseType: !16, size: 32, offset: 32)
!359 = !DIDerivedType(tag: DW_TAG_member, name: "n_lookups", scope: !355, file: !3, line: 381, baseType: !16, size: 32, offset: 64)
!360 = !DIDerivedType(tag: DW_TAG_member, name: "shared_acc", scope: !355, file: !3, line: 382, baseType: !124, size: 64, offset: 128)
!361 = !DIDerivedType(tag: DW_TAG_member, name: "private_acc", scope: !355, file: !3, line: 383, baseType: !124, size: 64, offset: 192)
!362 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !363, size: 64)
!363 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ListNode", file: !3, line: 338, size: 128, flags: DIFlagTypePassByValue, elements: !364, identifier: "_ZTS8ListNode")
!364 = !{!365, !366, !367}
!365 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !363, file: !3, line: 339, baseType: !16, size: 32)
!366 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !363, file: !3, line: 340, baseType: !16, size: 32, offset: 32)
!367 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !363, file: !3, line: 341, baseType: !362, size: 64, offset: 64)
!368 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !369, size: 64)
!369 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PhaseD_Args", file: !3, line: 481, size: 192, flags: DIFlagTypePassByValue, elements: !370, identifier: "_ZTS11PhaseD_Args")
!370 = !{!371, !372, !373, !375}
!371 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !369, file: !3, line: 482, baseType: !16, size: 32)
!372 = !DIDerivedType(tag: DW_TAG_member, name: "iters", scope: !369, file: !3, line: 483, baseType: !16, size: 32, offset: 32)
!373 = !DIDerivedType(tag: DW_TAG_member, name: "time_packed_ms", scope: !369, file: !3, line: 484, baseType: !374, size: 64, offset: 64)
!374 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!375 = !DIDerivedType(tag: DW_TAG_member, name: "time_padded_ms", scope: !369, file: !3, line: 485, baseType: !374, size: 64, offset: 128)
!376 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__atomic_base<long>", scope: !15, file: !104, line: 338, size: 64, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !377, templateParams: !500, identifier: "_ZTSSt13__atomic_baseIlE")
!377 = !{!378, !379, !381, !385, !386, !391, !395, !400, !403, !407, !412, !415, !418, !421, !424, !425, !426, !429, !432, !433, !434, !435, !436, !437, !438, !439, !440, !441, !442, !443, !444, !447, !450, !453, !456, !459, !462, !465, !468, !472, !475, !478, !481, !482, !483, !484, !485, !488, !489, !490, !491, !492, !493, !494, !495, !496, !497, !498, !499}
!378 = !DIDerivedType(tag: DW_TAG_variable, name: "_S_alignment", scope: !376, file: !104, line: 346, baseType: !188, flags: DIFlagPrivate | DIFlagStaticMember, extraData: i32 8)
!379 = !DIDerivedType(tag: DW_TAG_member, name: "_M_i", scope: !376, file: !104, line: 349, baseType: !380, size: 64, align: 64, flags: DIFlagPrivate)
!380 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_type", scope: !376, file: !104, line: 344, baseType: !124, flags: DIFlagPrivate)
!381 = !DISubprogram(name: "__atomic_base", scope: !376, file: !104, line: 352, type: !382, scopeLine: 352, flags: DIFlagPrototyped, spFlags: 0)
!382 = !DISubroutineType(types: !383)
!383 = !{null, !384}
!384 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !376, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!385 = !DISubprogram(name: "~__atomic_base", scope: !376, file: !104, line: 353, type: !382, scopeLine: 353, flags: DIFlagPrototyped, spFlags: 0)
!386 = !DISubprogram(name: "__atomic_base", scope: !376, file: !104, line: 354, type: !387, scopeLine: 354, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!387 = !DISubroutineType(types: !388)
!388 = !{null, !384, !389}
!389 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !390, size: 64)
!390 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !376)
!391 = !DISubprogram(name: "operator=", linkageName: "_ZNSt13__atomic_baseIlEaSERKS0_", scope: !376, file: !104, line: 355, type: !392, scopeLine: 355, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!392 = !DISubroutineType(types: !393)
!393 = !{!394, !384, !389}
!394 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !376, size: 64)
!395 = !DISubprogram(name: "operator=", linkageName: "_ZNVSt13__atomic_baseIlEaSERKS0_", scope: !376, file: !104, line: 356, type: !396, scopeLine: 356, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!396 = !DISubroutineType(types: !397)
!397 = !{!394, !398, !389}
!398 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !399, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!399 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !376)
!400 = !DISubprogram(name: "__atomic_base", scope: !376, file: !104, line: 358, type: !401, scopeLine: 358, flags: DIFlagPrototyped, spFlags: 0)
!401 = !DISubroutineType(types: !402)
!402 = !{null, !384, !380}
!403 = !DISubprogram(name: "operator long", linkageName: "_ZNKSt13__atomic_baseIlEcvlEv", scope: !376, file: !104, line: 360, type: !404, scopeLine: 360, flags: DIFlagPrototyped, spFlags: 0)
!404 = !DISubroutineType(types: !405)
!405 = !{!380, !406}
!406 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !390, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!407 = !DISubprogram(name: "operator long", linkageName: "_ZNVKSt13__atomic_baseIlEcvlEv", scope: !376, file: !104, line: 363, type: !408, scopeLine: 363, flags: DIFlagPrototyped, spFlags: 0)
!408 = !DISubroutineType(types: !409)
!409 = !{!380, !410}
!410 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !411, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!411 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !399)
!412 = !DISubprogram(name: "operator=", linkageName: "_ZNSt13__atomic_baseIlEaSEl", scope: !376, file: !104, line: 367, type: !413, scopeLine: 367, flags: DIFlagPrototyped, spFlags: 0)
!413 = !DISubroutineType(types: !414)
!414 = !{!380, !384, !380}
!415 = !DISubprogram(name: "operator=", linkageName: "_ZNVSt13__atomic_baseIlEaSEl", scope: !376, file: !104, line: 374, type: !416, scopeLine: 374, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DISubroutineType(types: !417)
!417 = !{!380, !398, !380}
!418 = !DISubprogram(name: "operator++", linkageName: "_ZNSt13__atomic_baseIlEppEi", scope: !376, file: !104, line: 381, type: !419, scopeLine: 381, flags: DIFlagPrototyped, spFlags: 0)
!419 = !DISubroutineType(types: !420)
!420 = !{!380, !384, !16}
!421 = !DISubprogram(name: "operator++", linkageName: "_ZNVSt13__atomic_baseIlEppEi", scope: !376, file: !104, line: 385, type: !422, scopeLine: 385, flags: DIFlagPrototyped, spFlags: 0)
!422 = !DISubroutineType(types: !423)
!423 = !{!380, !398, !16}
!424 = !DISubprogram(name: "operator--", linkageName: "_ZNSt13__atomic_baseIlEmmEi", scope: !376, file: !104, line: 389, type: !419, scopeLine: 389, flags: DIFlagPrototyped, spFlags: 0)
!425 = !DISubprogram(name: "operator--", linkageName: "_ZNVSt13__atomic_baseIlEmmEi", scope: !376, file: !104, line: 393, type: !422, scopeLine: 393, flags: DIFlagPrototyped, spFlags: 0)
!426 = !DISubprogram(name: "operator++", linkageName: "_ZNSt13__atomic_baseIlEppEv", scope: !376, file: !104, line: 397, type: !427, scopeLine: 397, flags: DIFlagPrototyped, spFlags: 0)
!427 = !DISubroutineType(types: !428)
!428 = !{!380, !384}
!429 = !DISubprogram(name: "operator++", linkageName: "_ZNVSt13__atomic_baseIlEppEv", scope: !376, file: !104, line: 401, type: !430, scopeLine: 401, flags: DIFlagPrototyped, spFlags: 0)
!430 = !DISubroutineType(types: !431)
!431 = !{!380, !398}
!432 = !DISubprogram(name: "operator--", linkageName: "_ZNSt13__atomic_baseIlEmmEv", scope: !376, file: !104, line: 405, type: !427, scopeLine: 405, flags: DIFlagPrototyped, spFlags: 0)
!433 = !DISubprogram(name: "operator--", linkageName: "_ZNVSt13__atomic_baseIlEmmEv", scope: !376, file: !104, line: 409, type: !430, scopeLine: 409, flags: DIFlagPrototyped, spFlags: 0)
!434 = !DISubprogram(name: "operator+=", linkageName: "_ZNSt13__atomic_baseIlEpLEl", scope: !376, file: !104, line: 413, type: !413, scopeLine: 413, flags: DIFlagPrototyped, spFlags: 0)
!435 = !DISubprogram(name: "operator+=", linkageName: "_ZNVSt13__atomic_baseIlEpLEl", scope: !376, file: !104, line: 417, type: !416, scopeLine: 417, flags: DIFlagPrototyped, spFlags: 0)
!436 = !DISubprogram(name: "operator-=", linkageName: "_ZNSt13__atomic_baseIlEmIEl", scope: !376, file: !104, line: 421, type: !413, scopeLine: 421, flags: DIFlagPrototyped, spFlags: 0)
!437 = !DISubprogram(name: "operator-=", linkageName: "_ZNVSt13__atomic_baseIlEmIEl", scope: !376, file: !104, line: 425, type: !416, scopeLine: 425, flags: DIFlagPrototyped, spFlags: 0)
!438 = !DISubprogram(name: "operator&=", linkageName: "_ZNSt13__atomic_baseIlEaNEl", scope: !376, file: !104, line: 429, type: !413, scopeLine: 429, flags: DIFlagPrototyped, spFlags: 0)
!439 = !DISubprogram(name: "operator&=", linkageName: "_ZNVSt13__atomic_baseIlEaNEl", scope: !376, file: !104, line: 433, type: !416, scopeLine: 433, flags: DIFlagPrototyped, spFlags: 0)
!440 = !DISubprogram(name: "operator|=", linkageName: "_ZNSt13__atomic_baseIlEoREl", scope: !376, file: !104, line: 437, type: !413, scopeLine: 437, flags: DIFlagPrototyped, spFlags: 0)
!441 = !DISubprogram(name: "operator|=", linkageName: "_ZNVSt13__atomic_baseIlEoREl", scope: !376, file: !104, line: 441, type: !416, scopeLine: 441, flags: DIFlagPrototyped, spFlags: 0)
!442 = !DISubprogram(name: "operator^=", linkageName: "_ZNSt13__atomic_baseIlEeOEl", scope: !376, file: !104, line: 445, type: !413, scopeLine: 445, flags: DIFlagPrototyped, spFlags: 0)
!443 = !DISubprogram(name: "operator^=", linkageName: "_ZNVSt13__atomic_baseIlEeOEl", scope: !376, file: !104, line: 449, type: !416, scopeLine: 449, flags: DIFlagPrototyped, spFlags: 0)
!444 = !DISubprogram(name: "is_lock_free", linkageName: "_ZNKSt13__atomic_baseIlE12is_lock_freeEv", scope: !376, file: !104, line: 453, type: !445, scopeLine: 453, flags: DIFlagPrototyped, spFlags: 0)
!445 = !DISubroutineType(types: !446)
!446 = !{!257, !406}
!447 = !DISubprogram(name: "is_lock_free", linkageName: "_ZNVKSt13__atomic_baseIlE12is_lock_freeEv", scope: !376, file: !104, line: 461, type: !448, scopeLine: 461, flags: DIFlagPrototyped, spFlags: 0)
!448 = !DISubroutineType(types: !449)
!449 = !{!257, !410}
!450 = !DISubprogram(name: "store", linkageName: "_ZNSt13__atomic_baseIlE5storeElSt12memory_order", scope: !376, file: !104, line: 469, type: !451, scopeLine: 469, flags: DIFlagPrototyped, spFlags: 0)
!451 = !DISubroutineType(types: !452)
!452 = !{null, !384, !380, !103}
!453 = !DISubprogram(name: "store", linkageName: "_ZNVSt13__atomic_baseIlE5storeElSt12memory_order", scope: !376, file: !104, line: 481, type: !454, scopeLine: 481, flags: DIFlagPrototyped, spFlags: 0)
!454 = !DISubroutineType(types: !455)
!455 = !{null, !398, !380, !103}
!456 = !DISubprogram(name: "load", linkageName: "_ZNKSt13__atomic_baseIlE4loadESt12memory_order", scope: !376, file: !104, line: 494, type: !457, scopeLine: 494, flags: DIFlagPrototyped, spFlags: 0)
!457 = !DISubroutineType(types: !458)
!458 = !{!380, !406, !103}
!459 = !DISubprogram(name: "load", linkageName: "_ZNVKSt13__atomic_baseIlE4loadESt12memory_order", scope: !376, file: !104, line: 505, type: !460, scopeLine: 505, flags: DIFlagPrototyped, spFlags: 0)
!460 = !DISubroutineType(types: !461)
!461 = !{!380, !410, !103}
!462 = !DISubprogram(name: "exchange", linkageName: "_ZNSt13__atomic_baseIlE8exchangeElSt12memory_order", scope: !376, file: !104, line: 516, type: !463, scopeLine: 516, flags: DIFlagPrototyped, spFlags: 0)
!463 = !DISubroutineType(types: !464)
!464 = !{!380, !384, !380, !103}
!465 = !DISubprogram(name: "exchange", linkageName: "_ZNVSt13__atomic_baseIlE8exchangeElSt12memory_order", scope: !376, file: !104, line: 524, type: !466, scopeLine: 524, flags: DIFlagPrototyped, spFlags: 0)
!466 = !DISubroutineType(types: !467)
!467 = !{!380, !398, !380, !103}
!468 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNSt13__atomic_baseIlE21compare_exchange_weakERllSt12memory_orderS2_", scope: !376, file: !104, line: 531, type: !469, scopeLine: 531, flags: DIFlagPrototyped, spFlags: 0)
!469 = !DISubroutineType(types: !470)
!470 = !{!257, !384, !471, !380, !103, !103}
!471 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !380, size: 64)
!472 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNVSt13__atomic_baseIlE21compare_exchange_weakERllSt12memory_orderS2_", scope: !376, file: !104, line: 541, type: !473, scopeLine: 541, flags: DIFlagPrototyped, spFlags: 0)
!473 = !DISubroutineType(types: !474)
!474 = !{!257, !398, !471, !380, !103, !103}
!475 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNSt13__atomic_baseIlE21compare_exchange_weakERllSt12memory_order", scope: !376, file: !104, line: 552, type: !476, scopeLine: 552, flags: DIFlagPrototyped, spFlags: 0)
!476 = !DISubroutineType(types: !477)
!477 = !{!257, !384, !471, !380, !103}
!478 = !DISubprogram(name: "compare_exchange_weak", linkageName: "_ZNVSt13__atomic_baseIlE21compare_exchange_weakERllSt12memory_order", scope: !376, file: !104, line: 560, type: !479, scopeLine: 560, flags: DIFlagPrototyped, spFlags: 0)
!479 = !DISubroutineType(types: !480)
!480 = !{!257, !398, !471, !380, !103}
!481 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNSt13__atomic_baseIlE23compare_exchange_strongERllSt12memory_orderS2_", scope: !376, file: !104, line: 568, type: !469, scopeLine: 568, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNVSt13__atomic_baseIlE23compare_exchange_strongERllSt12memory_orderS2_", scope: !376, file: !104, line: 578, type: !473, scopeLine: 578, flags: DIFlagPrototyped, spFlags: 0)
!483 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNSt13__atomic_baseIlE23compare_exchange_strongERllSt12memory_order", scope: !376, file: !104, line: 589, type: !476, scopeLine: 589, flags: DIFlagPrototyped, spFlags: 0)
!484 = !DISubprogram(name: "compare_exchange_strong", linkageName: "_ZNVSt13__atomic_baseIlE23compare_exchange_strongERllSt12memory_order", scope: !376, file: !104, line: 597, type: !479, scopeLine: 597, flags: DIFlagPrototyped, spFlags: 0)
!485 = !DISubprogram(name: "wait", linkageName: "_ZNKSt13__atomic_baseIlE4waitElSt12memory_order", scope: !376, file: !104, line: 606, type: !486, scopeLine: 606, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DISubroutineType(types: !487)
!487 = !{null, !406, !380, !103}
!488 = !DISubprogram(name: "notify_one", linkageName: "_ZNSt13__atomic_baseIlE10notify_oneEv", scope: !376, file: !104, line: 616, type: !382, scopeLine: 616, flags: DIFlagPrototyped, spFlags: 0)
!489 = !DISubprogram(name: "notify_all", linkageName: "_ZNSt13__atomic_baseIlE10notify_allEv", scope: !376, file: !104, line: 622, type: !382, scopeLine: 622, flags: DIFlagPrototyped, spFlags: 0)
!490 = !DISubprogram(name: "fetch_add", linkageName: "_ZNSt13__atomic_baseIlE9fetch_addElSt12memory_order", scope: !376, file: !104, line: 629, type: !463, scopeLine: 629, flags: DIFlagPrototyped, spFlags: 0)
!491 = !DISubprogram(name: "fetch_add", linkageName: "_ZNVSt13__atomic_baseIlE9fetch_addElSt12memory_order", scope: !376, file: !104, line: 634, type: !466, scopeLine: 634, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DISubprogram(name: "fetch_sub", linkageName: "_ZNSt13__atomic_baseIlE9fetch_subElSt12memory_order", scope: !376, file: !104, line: 639, type: !463, scopeLine: 639, flags: DIFlagPrototyped, spFlags: 0)
!493 = !DISubprogram(name: "fetch_sub", linkageName: "_ZNVSt13__atomic_baseIlE9fetch_subElSt12memory_order", scope: !376, file: !104, line: 644, type: !466, scopeLine: 644, flags: DIFlagPrototyped, spFlags: 0)
!494 = !DISubprogram(name: "fetch_and", linkageName: "_ZNSt13__atomic_baseIlE9fetch_andElSt12memory_order", scope: !376, file: !104, line: 649, type: !463, scopeLine: 649, flags: DIFlagPrototyped, spFlags: 0)
!495 = !DISubprogram(name: "fetch_and", linkageName: "_ZNVSt13__atomic_baseIlE9fetch_andElSt12memory_order", scope: !376, file: !104, line: 654, type: !466, scopeLine: 654, flags: DIFlagPrototyped, spFlags: 0)
!496 = !DISubprogram(name: "fetch_or", linkageName: "_ZNSt13__atomic_baseIlE8fetch_orElSt12memory_order", scope: !376, file: !104, line: 659, type: !463, scopeLine: 659, flags: DIFlagPrototyped, spFlags: 0)
!497 = !DISubprogram(name: "fetch_or", linkageName: "_ZNVSt13__atomic_baseIlE8fetch_orElSt12memory_order", scope: !376, file: !104, line: 664, type: !466, scopeLine: 664, flags: DIFlagPrototyped, spFlags: 0)
!498 = !DISubprogram(name: "fetch_xor", linkageName: "_ZNSt13__atomic_baseIlE9fetch_xorElSt12memory_order", scope: !376, file: !104, line: 669, type: !463, scopeLine: 669, flags: DIFlagPrototyped, spFlags: 0)
!499 = !DISubprogram(name: "fetch_xor", linkageName: "_ZNVSt13__atomic_baseIlE9fetch_xorElSt12memory_order", scope: !376, file: !104, line: 674, type: !466, scopeLine: 674, flags: DIFlagPrototyped, spFlags: 0)
!500 = !{!501}
!501 = !DITemplateTypeParameter(name: "_ITp", type: !124)
!502 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "atomic<long>", scope: !15, file: !182, line: 878, size: 64, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !503, templateParams: !529, identifier: "_ZTSSt6atomicIlE")
!503 = !{!504, !505, !506, !510, !511, !516, !520, !525}
!504 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !502, baseType: !376, extraData: i32 0)
!505 = !DIDerivedType(tag: DW_TAG_variable, name: "is_always_lock_free", scope: !502, file: !182, line: 895, baseType: !314, flags: DIFlagStaticMember, extraData: i1 true)
!506 = !DISubprogram(name: "atomic", scope: !502, file: !182, line: 883, type: !507, scopeLine: 883, flags: DIFlagPrototyped, spFlags: 0)
!507 = !DISubroutineType(types: !508)
!508 = !{null, !509}
!509 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !502, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!510 = !DISubprogram(name: "~atomic", scope: !502, file: !182, line: 884, type: !507, scopeLine: 884, flags: DIFlagPrototyped, spFlags: 0)
!511 = !DISubprogram(name: "atomic", scope: !502, file: !182, line: 885, type: !512, scopeLine: 885, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!512 = !DISubroutineType(types: !513)
!513 = !{null, !509, !514}
!514 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !515, size: 64)
!515 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !502)
!516 = !DISubprogram(name: "operator=", linkageName: "_ZNSt6atomicIlEaSERKS0_", scope: !502, file: !182, line: 886, type: !517, scopeLine: 886, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!517 = !DISubroutineType(types: !518)
!518 = !{!519, !509, !514}
!519 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !502, size: 64)
!520 = !DISubprogram(name: "operator=", linkageName: "_ZNVSt6atomicIlEaSERKS0_", scope: !502, file: !182, line: 887, type: !521, scopeLine: 887, flags: DIFlagPrototyped, spFlags: DISPFlagDeleted)
!521 = !DISubroutineType(types: !522)
!522 = !{!519, !523, !514}
!523 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !524, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!524 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !502)
!525 = !DISubprogram(name: "atomic", scope: !502, file: !182, line: 889, type: !526, scopeLine: 889, flags: DIFlagPrototyped, spFlags: 0)
!526 = !DISubroutineType(types: !527)
!527 = !{null, !509, !528}
!528 = !DIDerivedType(tag: DW_TAG_typedef, name: "__integral_type", scope: !502, file: !182, line: 880, baseType: !124)
!529 = !{!530}
!530 = !DITemplateTypeParameter(name: "_Tp", type: !124)
!531 = !{!532, !538, !543, !548, !553, !558, !563, !568, !0, !570, !572, !574, !577, !582, !584, !589, !594, !596, !598, !603, !608, !613, !615, !617, !622, !624, !626, !628, !633, !635, !667, !672, !674, !676, !678, !683, !685, !690, !696, !706, !711, !716, !721, !726, !731, !733, !735, !737, !739, !744, !746, !748, !753, !758, !763, !768, !773, !775, !780}
!532 = !DIGlobalVariableExpression(var: !533, expr: !DIExpression())
!533 = distinct !DIGlobalVariable(scope: null, file: !3, line: 604, type: !534, isLocal: true, isDefinition: true)
!534 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 128, elements: !536)
!535 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !143)
!536 = !{!537}
!537 = !DISubrange(count: 16)
!538 = !DIGlobalVariableExpression(var: !539, expr: !DIExpression())
!539 = distinct !DIGlobalVariable(scope: null, file: !3, line: 606, type: !540, isLocal: true, isDefinition: true)
!540 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 1128, elements: !541)
!541 = !{!542}
!542 = !DISubrange(count: 141)
!543 = !DIGlobalVariableExpression(var: !544, expr: !DIExpression())
!544 = distinct !DIGlobalVariable(scope: null, file: !3, line: 607, type: !545, isLocal: true, isDefinition: true)
!545 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 440, elements: !546)
!546 = !{!547}
!547 = !DISubrange(count: 55)
!548 = !DIGlobalVariableExpression(var: !549, expr: !DIExpression())
!549 = distinct !DIGlobalVariable(scope: null, file: !3, line: 608, type: !550, isLocal: true, isDefinition: true)
!550 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 424, elements: !551)
!551 = !{!552}
!552 = !DISubrange(count: 53)
!553 = !DIGlobalVariableExpression(var: !554, expr: !DIExpression())
!554 = distinct !DIGlobalVariable(scope: null, file: !3, line: 609, type: !555, isLocal: true, isDefinition: true)
!555 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 1120, elements: !556)
!556 = !{!557}
!557 = !DISubrange(count: 140)
!558 = !DIGlobalVariableExpression(var: !559, expr: !DIExpression())
!559 = distinct !DIGlobalVariable(scope: null, file: !3, line: 626, type: !560, isLocal: true, isDefinition: true)
!560 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 552, elements: !561)
!561 = !{!562}
!562 = !DISubrange(count: 69)
!563 = !DIGlobalVariableExpression(var: !564, expr: !DIExpression())
!564 = distinct !DIGlobalVariable(scope: null, file: !3, line: 628, type: !565, isLocal: true, isDefinition: true)
!565 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 288, elements: !566)
!566 = !{!567}
!567 = !DISubrange(count: 36)
!568 = !DIGlobalVariableExpression(var: !569, expr: !DIExpression())
!569 = distinct !DIGlobalVariable(scope: null, file: !3, line: 629, type: !565, isLocal: true, isDefinition: true)
!570 = !DIGlobalVariableExpression(var: !571, expr: !DIExpression())
!571 = distinct !DIGlobalVariable(name: "G_SCALE", linkageName: "_ZL7G_SCALE", scope: !2, file: !3, line: 94, type: !16, isLocal: true, isDefinition: true)
!572 = !DIGlobalVariableExpression(var: !573, expr: !DIExpression())
!573 = distinct !DIGlobalVariable(name: "g_checksum", linkageName: "_ZL10g_checksum", scope: !2, file: !3, line: 97, type: !502, isLocal: true, isDefinition: true)
!574 = !DIGlobalVariableExpression(var: !575, expr: !DIExpression(DW_OP_constu, 0, DW_OP_stack_value))
!575 = distinct !DIGlobalVariable(name: "memory_order_relaxed", scope: !15, file: !104, line: 75, type: !576, isLocal: true, isDefinition: true)
!576 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !103)
!577 = !DIGlobalVariableExpression(var: !578, expr: !DIExpression())
!578 = distinct !DIGlobalVariable(scope: null, file: !3, line: 288, type: !579, isLocal: true, isDefinition: true)
!579 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 672, elements: !580)
!580 = !{!581}
!581 = !DISubrange(count: 84)
!582 = !DIGlobalVariableExpression(var: !583, expr: !DIExpression(DW_OP_constu, 3, DW_OP_stack_value))
!583 = distinct !DIGlobalVariable(name: "memory_order_release", scope: !15, file: !104, line: 78, type: !576, isLocal: true, isDefinition: true)
!584 = !DIGlobalVariableExpression(var: !585, expr: !DIExpression())
!585 = distinct !DIGlobalVariable(scope: null, file: !3, line: 322, type: !586, isLocal: true, isDefinition: true)
!586 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 216, elements: !587)
!587 = !{!588}
!588 = !DISubrange(count: 27)
!589 = !DIGlobalVariableExpression(var: !590, expr: !DIExpression())
!590 = distinct !DIGlobalVariable(scope: null, file: !3, line: 325, type: !591, isLocal: true, isDefinition: true)
!591 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 232, elements: !592)
!592 = !{!593}
!593 = !DISubrange(count: 29)
!594 = !DIGlobalVariableExpression(var: !595, expr: !DIExpression())
!595 = distinct !DIGlobalVariable(name: "g_queue", linkageName: "_ZL7g_queue", scope: !2, file: !3, line: 207, type: !132, isLocal: true, isDefinition: true)
!596 = !DIGlobalVariableExpression(var: !597, expr: !DIExpression(DW_OP_constu, 2, DW_OP_stack_value))
!597 = distinct !DIGlobalVariable(name: "memory_order_acquire", scope: !15, file: !104, line: 77, type: !576, isLocal: true, isDefinition: true)
!598 = !DIGlobalVariableExpression(var: !599, expr: !DIExpression())
!599 = distinct !DIGlobalVariable(scope: null, file: !104, line: 498, type: !600, isLocal: true, isDefinition: true)
!600 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 632, elements: !601)
!601 = !{!602}
!602 = !DISubrange(count: 79)
!603 = !DIGlobalVariableExpression(var: !604, expr: !DIExpression())
!604 = distinct !DIGlobalVariable(scope: null, file: !104, line: 498, type: !605, isLocal: true, isDefinition: true)
!605 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 592, elements: !606)
!606 = !{!607}
!607 = !DISubrange(count: 74)
!608 = !DIGlobalVariableExpression(var: !609, expr: !DIExpression())
!609 = distinct !DIGlobalVariable(scope: null, file: !104, line: 498, type: !610, isLocal: true, isDefinition: true)
!610 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 224, elements: !611)
!611 = !{!612}
!612 = !DISubrange(count: 28)
!613 = !DIGlobalVariableExpression(var: !614, expr: !DIExpression(DW_OP_constu, 4, DW_OP_stack_value))
!614 = distinct !DIGlobalVariable(name: "memory_order_acq_rel", scope: !15, file: !104, line: 79, type: !576, isLocal: true, isDefinition: true)
!615 = !DIGlobalVariableExpression(var: !616, expr: !DIExpression())
!616 = distinct !DIGlobalVariable(scope: null, file: !104, line: 499, type: !610, isLocal: true, isDefinition: true)
!617 = !DIGlobalVariableExpression(var: !618, expr: !DIExpression())
!618 = distinct !DIGlobalVariable(scope: null, file: !104, line: 473, type: !619, isLocal: true, isDefinition: true)
!619 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 600, elements: !620)
!620 = !{!621}
!621 = !DISubrange(count: 75)
!622 = !DIGlobalVariableExpression(var: !623, expr: !DIExpression())
!623 = distinct !DIGlobalVariable(scope: null, file: !104, line: 473, type: !610, isLocal: true, isDefinition: true)
!624 = !DIGlobalVariableExpression(var: !625, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!625 = distinct !DIGlobalVariable(name: "memory_order_consume", scope: !15, file: !104, line: 76, type: !576, isLocal: true, isDefinition: true)
!626 = !DIGlobalVariableExpression(var: !627, expr: !DIExpression())
!627 = distinct !DIGlobalVariable(scope: null, file: !104, line: 475, type: !610, isLocal: true, isDefinition: true)
!628 = !DIGlobalVariableExpression(var: !629, expr: !DIExpression())
!629 = distinct !DIGlobalVariable(scope: null, file: !3, line: 423, type: !630, isLocal: true, isDefinition: true)
!630 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 616, elements: !631)
!631 = !{!632}
!632 = !DISubrange(count: 77)
!633 = !DIGlobalVariableExpression(var: !634, expr: !DIExpression())
!634 = distinct !DIGlobalVariable(scope: null, file: !3, line: 452, type: !591, isLocal: true, isDefinition: true)
!635 = !DIGlobalVariableExpression(var: !636, expr: !DIExpression())
!636 = distinct !DIGlobalVariable(name: "g_list", linkageName: "_ZL6g_list", scope: !2, file: !3, line: 349, type: !637, isLocal: true, isDefinition: true)
!637 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "SharedList", file: !3, line: 344, size: 512, flags: DIFlagTypePassByValue, elements: !638, identifier: "_ZTS10SharedList")
!638 = !{!639, !640}
!639 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !637, file: !3, line: 345, baseType: !362, size: 64)
!640 = !DIDerivedType(tag: DW_TAG_member, name: "rw", scope: !637, file: !3, line: 346, baseType: !641, size: 448, offset: 64)
!641 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !128, line: 91, baseType: !642)
!642 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !128, line: 86, size: 448, flags: DIFlagTypePassByValue, elements: !643, identifier: "_ZTS16pthread_rwlock_t")
!643 = !{!644, !665, !666}
!644 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !642, file: !128, line: 88, baseType: !645, size: 448)
!645 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_rwlock_arch_t", file: !646, line: 23, size: 448, flags: DIFlagTypePassByValue, elements: !647, identifier: "_ZTS23__pthread_rwlock_arch_t")
!646 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_rwlock.h", directory: "", checksumkind: CSK_MD5, checksum: "c50817c3f5d727714047e4ed2c0cc1a3")
!647 = !{!648, !649, !650, !651, !652, !653, !654, !655, !656, !658, !663, !664}
!648 = !DIDerivedType(tag: DW_TAG_member, name: "__readers", scope: !645, file: !646, line: 25, baseType: !8, size: 32)
!649 = !DIDerivedType(tag: DW_TAG_member, name: "__writers", scope: !645, file: !646, line: 26, baseType: !8, size: 32, offset: 32)
!650 = !DIDerivedType(tag: DW_TAG_member, name: "__wrphase_futex", scope: !645, file: !646, line: 27, baseType: !8, size: 32, offset: 64)
!651 = !DIDerivedType(tag: DW_TAG_member, name: "__writers_futex", scope: !645, file: !646, line: 28, baseType: !8, size: 32, offset: 96)
!652 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !645, file: !646, line: 29, baseType: !8, size: 32, offset: 128)
!653 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !645, file: !646, line: 30, baseType: !8, size: 32, offset: 160)
!654 = !DIDerivedType(tag: DW_TAG_member, name: "__cur_writer", scope: !645, file: !646, line: 32, baseType: !16, size: 32, offset: 192)
!655 = !DIDerivedType(tag: DW_TAG_member, name: "__shared", scope: !645, file: !646, line: 33, baseType: !16, size: 32, offset: 224)
!656 = !DIDerivedType(tag: DW_TAG_member, name: "__rwelision", scope: !645, file: !646, line: 34, baseType: !657, size: 8, offset: 256)
!657 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!658 = !DIDerivedType(tag: DW_TAG_member, name: "__pad1", scope: !645, file: !646, line: 39, baseType: !659, size: 56, offset: 264)
!659 = !DICompositeType(tag: DW_TAG_array_type, baseType: !660, size: 56, elements: !661)
!660 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!661 = !{!662}
!662 = !DISubrange(count: 7)
!663 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !645, file: !646, line: 42, baseType: !129, size: 64, offset: 320)
!664 = !DIDerivedType(tag: DW_TAG_member, name: "__flags", scope: !645, file: !646, line: 45, baseType: !8, size: 32, offset: 384)
!665 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !642, file: !128, line: 89, baseType: !142, size: 448)
!666 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !642, file: !128, line: 90, baseType: !124, size: 64)
!667 = !DIGlobalVariableExpression(var: !668, expr: !DIExpression())
!668 = distinct !DIGlobalVariable(scope: null, file: !3, line: 506, type: !669, isLocal: true, isDefinition: true)
!669 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 584, elements: !670)
!670 = !{!671}
!671 = !DISubrange(count: 73)
!672 = !DIGlobalVariableExpression(var: !673, expr: !DIExpression())
!673 = distinct !DIGlobalVariable(scope: null, file: !3, line: 544, type: !586, isLocal: true, isDefinition: true)
!674 = !DIGlobalVariableExpression(var: !675, expr: !DIExpression())
!675 = distinct !DIGlobalVariable(scope: null, file: !3, line: 545, type: !586, isLocal: true, isDefinition: true)
!676 = !DIGlobalVariableExpression(var: !677, expr: !DIExpression())
!677 = distinct !DIGlobalVariable(scope: null, file: !3, line: 546, type: !610, isLocal: true, isDefinition: true)
!678 = !DIGlobalVariableExpression(var: !679, expr: !DIExpression())
!679 = distinct !DIGlobalVariable(scope: null, file: !3, line: 547, type: !680, isLocal: true, isDefinition: true)
!680 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 512, elements: !681)
!681 = !{!682}
!682 = !DISubrange(count: 64)
!683 = !DIGlobalVariableExpression(var: !684, expr: !DIExpression())
!684 = distinct !DIGlobalVariable(scope: null, file: !3, line: 548, type: !560, isLocal: true, isDefinition: true)
!685 = !DIGlobalVariableExpression(var: !686, expr: !DIExpression())
!686 = distinct !DIGlobalVariable(scope: null, file: !3, line: 553, type: !687, isLocal: true, isDefinition: true)
!687 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 272, elements: !688)
!688 = !{!689}
!689 = !DISubrange(count: 34)
!690 = !DIGlobalVariableExpression(var: !691, expr: !DIExpression())
!691 = distinct !DIGlobalVariable(name: "g_packed", linkageName: "_ZL8g_packed", scope: !2, file: !3, line: 478, type: !692, isLocal: true, isDefinition: true)
!692 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PackedCounters", file: !3, line: 468, size: 512, flags: DIFlagTypePassByValue, elements: !693, identifier: "_ZTS14PackedCounters")
!693 = !{!694}
!694 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !692, file: !3, line: 469, baseType: !695, size: 512)
!695 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 512, elements: !536)
!696 = !DIGlobalVariableExpression(var: !697, expr: !DIExpression())
!697 = distinct !DIGlobalVariable(name: "g_padded", linkageName: "_ZL8g_padded", scope: !2, file: !3, line: 479, type: !698, isLocal: true, isDefinition: true)
!698 = !DICompositeType(tag: DW_TAG_array_type, baseType: !699, size: 8192, align: 512, elements: !536)
!699 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "PaddedCounter", file: !3, line: 473, size: 512, align: 512, flags: DIFlagTypePassByValue, elements: !700, identifier: "_ZTS13PaddedCounter")
!700 = !{!701, !702}
!701 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !699, file: !3, line: 474, baseType: !16, size: 32)
!702 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !699, file: !3, line: 475, baseType: !703, size: 480, offset: 32)
!703 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 480, elements: !704)
!704 = !{!705}
!705 = !DISubrange(count: 60)
!706 = !DIGlobalVariableExpression(var: !707, expr: !DIExpression())
!707 = distinct !DIGlobalVariable(scope: null, file: !3, line: 572, type: !708, isLocal: true, isDefinition: true)
!708 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 1464, elements: !709)
!709 = !{!710}
!710 = !DISubrange(count: 183)
!711 = !DIGlobalVariableExpression(var: !712, expr: !DIExpression())
!712 = distinct !DIGlobalVariable(scope: null, file: !3, line: 573, type: !713, isLocal: true, isDefinition: true)
!713 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 528, elements: !714)
!714 = !{!715}
!715 = !DISubrange(count: 66)
!716 = !DIGlobalVariableExpression(var: !717, expr: !DIExpression())
!717 = distinct !DIGlobalVariable(scope: null, file: !3, line: 574, type: !718, isLocal: true, isDefinition: true)
!718 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 1456, elements: !719)
!719 = !{!720}
!720 = !DISubrange(count: 182)
!721 = !DIGlobalVariableExpression(var: !722, expr: !DIExpression())
!722 = distinct !DIGlobalVariable(scope: null, file: !3, line: 575, type: !723, isLocal: true, isDefinition: true)
!723 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 576, elements: !724)
!724 = !{!725}
!725 = !DISubrange(count: 72)
!726 = !DIGlobalVariableExpression(var: !727, expr: !DIExpression())
!727 = distinct !DIGlobalVariable(scope: null, file: !3, line: 580, type: !728, isLocal: true, isDefinition: true)
!728 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 408, elements: !729)
!729 = !{!730}
!730 = !DISubrange(count: 51)
!731 = !DIGlobalVariableExpression(var: !732, expr: !DIExpression())
!732 = distinct !DIGlobalVariable(scope: null, file: !3, line: 581, type: !728, isLocal: true, isDefinition: true)
!733 = !DIGlobalVariableExpression(var: !734, expr: !DIExpression())
!734 = distinct !DIGlobalVariable(scope: null, file: !3, line: 582, type: !728, isLocal: true, isDefinition: true)
!735 = !DIGlobalVariableExpression(var: !736, expr: !DIExpression())
!736 = distinct !DIGlobalVariable(scope: null, file: !3, line: 583, type: !728, isLocal: true, isDefinition: true)
!737 = !DIGlobalVariableExpression(var: !738, expr: !DIExpression())
!738 = distinct !DIGlobalVariable(scope: null, file: !3, line: 585, type: !728, isLocal: true, isDefinition: true)
!739 = !DIGlobalVariableExpression(var: !740, expr: !DIExpression())
!740 = distinct !DIGlobalVariable(scope: null, file: !3, line: 587, type: !741, isLocal: true, isDefinition: true)
!741 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 536, elements: !742)
!742 = !{!743}
!743 = !DISubrange(count: 67)
!744 = !DIGlobalVariableExpression(var: !745, expr: !DIExpression())
!745 = distinct !DIGlobalVariable(scope: null, file: !3, line: 588, type: !741, isLocal: true, isDefinition: true)
!746 = !DIGlobalVariableExpression(var: !747, expr: !DIExpression())
!747 = distinct !DIGlobalVariable(scope: null, file: !3, line: 590, type: !718, isLocal: true, isDefinition: true)
!748 = !DIGlobalVariableExpression(var: !749, expr: !DIExpression())
!749 = distinct !DIGlobalVariable(scope: null, file: !3, line: 591, type: !750, isLocal: true, isDefinition: true)
!750 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 16, elements: !751)
!751 = !{!752}
!752 = !DISubrange(count: 2)
!753 = !DIGlobalVariableExpression(var: !754, expr: !DIExpression())
!754 = distinct !DIGlobalVariable(scope: null, file: !3, line: 592, type: !755, isLocal: true, isDefinition: true)
!755 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 136, elements: !756)
!756 = !{!757}
!757 = !DISubrange(count: 17)
!758 = !DIGlobalVariableExpression(var: !759, expr: !DIExpression())
!759 = distinct !DIGlobalVariable(scope: null, file: !3, line: 593, type: !760, isLocal: true, isDefinition: true)
!760 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 464, elements: !761)
!761 = !{!762}
!762 = !DISubrange(count: 58)
!763 = !DIGlobalVariableExpression(var: !764, expr: !DIExpression())
!764 = distinct !DIGlobalVariable(scope: null, file: !3, line: 594, type: !765, isLocal: true, isDefinition: true)
!765 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 488, elements: !766)
!766 = !{!767}
!767 = !DISubrange(count: 61)
!768 = !DIGlobalVariableExpression(var: !769, expr: !DIExpression())
!769 = distinct !DIGlobalVariable(scope: null, file: !3, line: 595, type: !770, isLocal: true, isDefinition: true)
!770 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 544, elements: !771)
!771 = !{!772}
!772 = !DISubrange(count: 68)
!773 = !DIGlobalVariableExpression(var: !774, expr: !DIExpression())
!774 = distinct !DIGlobalVariable(scope: null, file: !3, line: 596, type: !770, isLocal: true, isDefinition: true)
!775 = !DIGlobalVariableExpression(var: !776, expr: !DIExpression())
!776 = distinct !DIGlobalVariable(scope: null, file: !3, line: 597, type: !777, isLocal: true, isDefinition: true)
!777 = !DICompositeType(tag: DW_TAG_array_type, baseType: !535, size: 560, elements: !778)
!778 = !{!779}
!779 = !DISubrange(count: 70)
!780 = !DIGlobalVariableExpression(var: !781, expr: !DIExpression())
!781 = distinct !DIGlobalVariable(scope: null, file: !104, line: 473, type: !630, isLocal: true, isDefinition: true)
!782 = !{!783, !789, !793, !799, !803, !810, !815, !817, !822, !826, !830, !840, !842, !846, !850, !854, !859, !863, !867, !871, !875, !883, !887, !891, !893, !897, !901, !905, !911, !915, !919, !921, !929, !933, !940, !942, !946, !950, !954, !958, !963, !967, !972, !973, !974, !975, !977, !978, !979, !980, !981, !982, !983, !985, !986, !987, !988, !989, !990, !991, !992, !996, !997, !998, !999, !1000, !1001, !1002, !1003, !1004, !1005, !1006, !1007, !1008, !1009, !1010, !1011, !1012, !1013, !1014, !1015, !1016, !1017, !1018, !1019, !1020, !1026, !1029, !1032, !1035, !1038, !1040, !1042, !1044, !1048, !1051, !1054, !1057, !1060, !1062, !1066, !1070, !1073, !1076, !1078, !1080, !1082, !1084, !1087, !1090, !1093, !1096, !1099, !1101, !1106, !1110, !1125, !1130, !1134, !1139, !1144, !1150, !1156, !1160, !1162, !1167, !1174, !1179, !1184, !1201, !1204, !1209, !1218, !1223, !1227, !1231, !1235, !1239, !1241, !1243, !1247, !1253, !1257, !1263, !1269, !1271, !1275, !1279, !1283, !1287, !1298, !1300, !1304, !1308, !1312, !1314, !1318, !1322, !1326, !1328, !1330, !1334, !1338, !1342, !1346, !1350, !1352, !1358, !1360, !1366, !1370, !1374, !1378, !1382, !1386, !1390, !1392, !1394, !1398, !1402, !1406, !1408, !1412, !1416, !1418, !1420, !1424, !1428, !1432, !1436, !1437, !1438, !1439, !1440, !1441, !1442, !1443, !1444, !1445, !1446, !1450, !1454, !1459, !1463, !1467, !1472, !1476, !1478, !1480, !1482, !1484, !1486, !1488, !1490, !1492, !1494, !1496, !1498, !1500, !1502, !1506, !1510, !1516, !1521, !1525, !1527, !1529, !1531, !1533, !1540, !1544, !1548, !1552, !1556, !1560, !1565, !1569, !1571, !1575, !1581, !1585, !1590, !1592, !1594, !1598, !1602, !1604, !1606, !1608, !1610, !1614, !1616, !1618, !1622, !1626, !1630, !1634, !1638, !1642, !1644, !1648, !1652, !1656, !1660, !1662, !1664, !1668, !1672, !1673, !1674, !1675, !1676, !1677, !1685, !1691, !1694, !1695, !1697, !1699, !1701, !1703, !1707, !1709, !1711, !1713, !1715, !1717, !1719, !1721, !1723, !1727, !1731, !1733, !1737, !1741, !1743, !1746}
!783 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !784, file: !788, line: 58)
!784 = !DISubprogram(name: "abs", scope: !785, file: !785, line: 980, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!785 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "2ebb4e08912aad41774217f29ad02c9e")
!786 = !DISubroutineType(types: !787)
!787 = !{!16, !16}
!788 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/std_abs.h", directory: "", checksumkind: CSK_MD5, checksum: "b04fe3ed420747a2e528c0e678ab45db")
!789 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !790, file: !792, line: 137)
!790 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !785, line: 63, baseType: !791)
!791 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !785, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!792 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstdlib", directory: "", checksumkind: CSK_MD5, checksum: "745c77d592b579358a91081122d152be")
!793 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !794, file: !792, line: 138)
!794 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !785, line: 71, baseType: !795)
!795 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !785, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !796, identifier: "_ZTS6ldiv_t")
!796 = !{!797, !798}
!797 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !795, file: !785, line: 69, baseType: !124, size: 64)
!798 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !795, file: !785, line: 70, baseType: !124, size: 64, offset: 64)
!799 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !800, file: !792, line: 140)
!800 = !DISubprogram(name: "abort", scope: !785, file: !785, line: 730, type: !801, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!801 = !DISubroutineType(types: !802)
!802 = !{null}
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !804, file: !792, line: 142)
!804 = !DISubprogram(name: "aligned_alloc", scope: !785, file: !785, line: 724, type: !805, flags: DIFlagPrototyped, spFlags: 0)
!805 = !DISubroutineType(types: !806)
!806 = !{!807, !808, !808}
!807 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!808 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !809, line: 18, baseType: !129)
!809 = !DIFile(filename: "/usr/lib/llvm-20/lib/clang/20/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!810 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !811, file: !792, line: 144)
!811 = !DISubprogram(name: "atexit", scope: !785, file: !785, line: 734, type: !812, flags: DIFlagPrototyped, spFlags: 0)
!812 = !DISubroutineType(types: !813)
!813 = !{!16, !814}
!814 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !801, size: 64)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !816, file: !792, line: 147)
!816 = !DISubprogram(name: "at_quick_exit", scope: !785, file: !785, line: 739, type: !812, flags: DIFlagPrototyped, spFlags: 0)
!817 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !818, file: !792, line: 150)
!818 = !DISubprogram(name: "atof", scope: !785, file: !785, line: 102, type: !819, flags: DIFlagPrototyped, spFlags: 0)
!819 = !DISubroutineType(types: !820)
!820 = !{!374, !821}
!821 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !535, size: 64)
!822 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !823, file: !792, line: 151)
!823 = !DISubprogram(name: "atoi", scope: !785, file: !785, line: 105, type: !824, flags: DIFlagPrototyped, spFlags: 0)
!824 = !DISubroutineType(types: !825)
!825 = !{!16, !821}
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !827, file: !792, line: 152)
!827 = !DISubprogram(name: "atol", scope: !785, file: !785, line: 108, type: !828, flags: DIFlagPrototyped, spFlags: 0)
!828 = !DISubroutineType(types: !829)
!829 = !{!124, !821}
!830 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !831, file: !792, line: 153)
!831 = !DISubprogram(name: "bsearch", scope: !785, file: !785, line: 960, type: !832, flags: DIFlagPrototyped, spFlags: 0)
!832 = !DISubroutineType(types: !833)
!833 = !{!807, !834, !834, !808, !808, !836}
!834 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !835, size: 64)
!835 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!836 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !785, line: 948, baseType: !837)
!837 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !838, size: 64)
!838 = !DISubroutineType(types: !839)
!839 = !{!16, !834, !834}
!840 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !841, file: !792, line: 154)
!841 = !DISubprogram(name: "calloc", scope: !785, file: !785, line: 675, type: !805, flags: DIFlagPrototyped, spFlags: 0)
!842 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !843, file: !792, line: 155)
!843 = !DISubprogram(name: "div", scope: !785, file: !785, line: 998, type: !844, flags: DIFlagPrototyped, spFlags: 0)
!844 = !DISubroutineType(types: !845)
!845 = !{!790, !16, !16}
!846 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !847, file: !792, line: 156)
!847 = !DISubprogram(name: "exit", scope: !785, file: !785, line: 756, type: !848, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!848 = !DISubroutineType(types: !849)
!849 = !{null, !16}
!850 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !851, file: !792, line: 157)
!851 = !DISubprogram(name: "free", scope: !785, file: !785, line: 687, type: !852, flags: DIFlagPrototyped, spFlags: 0)
!852 = !DISubroutineType(types: !853)
!853 = !{null, !807}
!854 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !855, file: !792, line: 158)
!855 = !DISubprogram(name: "getenv", scope: !785, file: !785, line: 773, type: !856, flags: DIFlagPrototyped, spFlags: 0)
!856 = !DISubroutineType(types: !857)
!857 = !{!858, !821}
!858 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!859 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !860, file: !792, line: 159)
!860 = !DISubprogram(name: "labs", scope: !785, file: !785, line: 981, type: !861, flags: DIFlagPrototyped, spFlags: 0)
!861 = !DISubroutineType(types: !862)
!862 = !{!124, !124}
!863 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !864, file: !792, line: 160)
!864 = !DISubprogram(name: "ldiv", scope: !785, file: !785, line: 1000, type: !865, flags: DIFlagPrototyped, spFlags: 0)
!865 = !DISubroutineType(types: !866)
!866 = !{!794, !124, !124}
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !868, file: !792, line: 161)
!868 = !DISubprogram(name: "malloc", scope: !785, file: !785, line: 672, type: !869, flags: DIFlagPrototyped, spFlags: 0)
!869 = !DISubroutineType(types: !870)
!870 = !{!807, !808}
!871 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !872, file: !792, line: 163)
!872 = !DISubprogram(name: "mblen", scope: !785, file: !785, line: 1068, type: !873, flags: DIFlagPrototyped, spFlags: 0)
!873 = !DISubroutineType(types: !874)
!874 = !{!16, !821, !808}
!875 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !876, file: !792, line: 164)
!876 = !DISubprogram(name: "mbstowcs", scope: !785, file: !785, line: 1079, type: !877, flags: DIFlagPrototyped, spFlags: 0)
!877 = !DISubroutineType(types: !878)
!878 = !{!808, !879, !882, !808}
!879 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !880)
!880 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !881, size: 64)
!881 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!882 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !821)
!883 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !884, file: !792, line: 165)
!884 = !DISubprogram(name: "mbtowc", scope: !785, file: !785, line: 1071, type: !885, flags: DIFlagPrototyped, spFlags: 0)
!885 = !DISubroutineType(types: !886)
!886 = !{!16, !879, !882, !808}
!887 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !888, file: !792, line: 167)
!888 = !DISubprogram(name: "qsort", scope: !785, file: !785, line: 970, type: !889, flags: DIFlagPrototyped, spFlags: 0)
!889 = !DISubroutineType(types: !890)
!890 = !{null, !807, !808, !808, !836}
!891 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !892, file: !792, line: 170)
!892 = !DISubprogram(name: "quick_exit", scope: !785, file: !785, line: 762, type: !848, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!893 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !894, file: !792, line: 173)
!894 = !DISubprogram(name: "rand", scope: !785, file: !785, line: 573, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!895 = !DISubroutineType(types: !896)
!896 = !{!16}
!897 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !898, file: !792, line: 174)
!898 = !DISubprogram(name: "realloc", scope: !785, file: !785, line: 683, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!899 = !DISubroutineType(types: !900)
!900 = !{!807, !807, !808}
!901 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !902, file: !792, line: 175)
!902 = !DISubprogram(name: "srand", scope: !785, file: !785, line: 575, type: !903, flags: DIFlagPrototyped, spFlags: 0)
!903 = !DISubroutineType(types: !904)
!904 = !{null, !8}
!905 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !906, file: !792, line: 176)
!906 = !DISubprogram(name: "strtod", scope: !785, file: !785, line: 118, type: !907, flags: DIFlagPrototyped, spFlags: 0)
!907 = !DISubroutineType(types: !908)
!908 = !{!374, !882, !909}
!909 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !910)
!910 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !858, size: 64)
!911 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !912, file: !792, line: 177)
!912 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !785, file: !785, line: 215, type: !913, flags: DIFlagPrototyped, spFlags: 0)
!913 = !DISubroutineType(types: !914)
!914 = !{!124, !882, !909, !16}
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !916, file: !792, line: 178)
!916 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !785, file: !785, line: 219, type: !917, flags: DIFlagPrototyped, spFlags: 0)
!917 = !DISubroutineType(types: !918)
!918 = !{!129, !882, !909, !16}
!919 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !920, file: !792, line: 179)
!920 = !DISubprogram(name: "system", scope: !785, file: !785, line: 923, type: !824, flags: DIFlagPrototyped, spFlags: 0)
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !922, file: !792, line: 181)
!922 = !DISubprogram(name: "wcstombs", scope: !785, file: !785, line: 1083, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!923 = !DISubroutineType(types: !924)
!924 = !{!808, !925, !926, !808}
!925 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !858)
!926 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !927)
!927 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !928, size: 64)
!928 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !881)
!929 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !930, file: !792, line: 182)
!930 = !DISubprogram(name: "wctomb", scope: !785, file: !785, line: 1075, type: !931, flags: DIFlagPrototyped, spFlags: 0)
!931 = !DISubroutineType(types: !932)
!932 = !{!16, !858, !881}
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !934, file: !792, line: 210)
!934 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !785, line: 81, baseType: !935)
!935 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !785, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !936, identifier: "_ZTS7lldiv_t")
!936 = !{!937, !939}
!937 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !935, file: !785, line: 79, baseType: !938, size: 64)
!938 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!939 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !935, file: !785, line: 80, baseType: !938, size: 64, offset: 64)
!940 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !941, file: !792, line: 216)
!941 = !DISubprogram(name: "_Exit", scope: !785, file: !785, line: 768, type: !848, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!942 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !943, file: !792, line: 222)
!943 = !DISubprogram(name: "llabs", scope: !785, file: !785, line: 984, type: !944, flags: DIFlagPrototyped, spFlags: 0)
!944 = !DISubroutineType(types: !945)
!945 = !{!938, !938}
!946 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !947, file: !792, line: 228)
!947 = !DISubprogram(name: "lldiv", scope: !785, file: !785, line: 1004, type: !948, flags: DIFlagPrototyped, spFlags: 0)
!948 = !DISubroutineType(types: !949)
!949 = !{!934, !938, !938}
!950 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !951, file: !792, line: 240)
!951 = !DISubprogram(name: "atoll", scope: !785, file: !785, line: 113, type: !952, flags: DIFlagPrototyped, spFlags: 0)
!952 = !DISubroutineType(types: !953)
!953 = !{!938, !821}
!954 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !955, file: !792, line: 241)
!955 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !785, file: !785, line: 238, type: !956, flags: DIFlagPrototyped, spFlags: 0)
!956 = !DISubroutineType(types: !957)
!957 = !{!938, !882, !909, !16}
!958 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !959, file: !792, line: 242)
!959 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !785, file: !785, line: 243, type: !960, flags: DIFlagPrototyped, spFlags: 0)
!960 = !DISubroutineType(types: !961)
!961 = !{!962, !882, !909, !16}
!962 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!963 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !964, file: !792, line: 244)
!964 = !DISubprogram(name: "strtof", scope: !785, file: !785, line: 124, type: !965, flags: DIFlagPrototyped, spFlags: 0)
!965 = !DISubroutineType(types: !966)
!966 = !{!131, !882, !909}
!967 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !968, file: !792, line: 245)
!968 = !DISubprogram(name: "strtold", scope: !785, file: !785, line: 127, type: !969, flags: DIFlagPrototyped, spFlags: 0)
!969 = !DISubroutineType(types: !970)
!970 = !{!971, !882, !909}
!971 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!972 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !934, file: !792, line: 253)
!973 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !941, file: !792, line: 255)
!974 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !943, file: !792, line: 257)
!975 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !976, file: !792, line: 258)
!976 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !7, file: !792, line: 225, type: !948, flags: DIFlagPrototyped, spFlags: 0)
!977 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !947, file: !792, line: 259)
!978 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !951, file: !792, line: 261)
!979 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !964, file: !792, line: 262)
!980 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !955, file: !792, line: 263)
!981 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !959, file: !792, line: 264)
!982 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !968, file: !792, line: 265)
!983 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !800, file: !984, line: 38)
!984 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "6b5a21b1805b4429608f31a862826533")
!985 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !811, file: !984, line: 39)
!986 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !847, file: !984, line: 40)
!987 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !816, file: !984, line: 43)
!988 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !892, file: !984, line: 46)
!989 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !941, file: !984, line: 49)
!990 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !790, file: !984, line: 54)
!991 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !794, file: !984, line: 55)
!992 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !993, file: !984, line: 57)
!993 = !DISubprogram(name: "abs", linkageName: "_ZSt3abse", scope: !15, file: !788, line: 85, type: !994, flags: DIFlagPrototyped, spFlags: 0)
!994 = !DISubroutineType(types: !995)
!995 = !{!971, !971}
!996 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !818, file: !984, line: 58)
!997 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !823, file: !984, line: 59)
!998 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !827, file: !984, line: 60)
!999 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !831, file: !984, line: 61)
!1000 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !841, file: !984, line: 62)
!1001 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !976, file: !984, line: 63)
!1002 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !851, file: !984, line: 64)
!1003 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !855, file: !984, line: 65)
!1004 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !860, file: !984, line: 66)
!1005 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !864, file: !984, line: 67)
!1006 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !868, file: !984, line: 68)
!1007 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !872, file: !984, line: 70)
!1008 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !876, file: !984, line: 71)
!1009 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !884, file: !984, line: 72)
!1010 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !888, file: !984, line: 74)
!1011 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !894, file: !984, line: 75)
!1012 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !898, file: !984, line: 76)
!1013 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !902, file: !984, line: 77)
!1014 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !906, file: !984, line: 78)
!1015 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !912, file: !984, line: 79)
!1016 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !916, file: !984, line: 80)
!1017 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !920, file: !984, line: 81)
!1018 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !922, file: !984, line: 83)
!1019 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !930, file: !984, line: 84)
!1020 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1021, file: !1025, line: 53)
!1021 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !1022, line: 24, baseType: !1023)
!1022 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "d8f6972fff852003b8782e6edd3802e7")
!1023 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !1024, line: 37, baseType: !657)
!1024 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!1025 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstdint", directory: "", checksumkind: CSK_MD5, checksum: "7536ee1dcc999c08a41c991ca26edbcf")
!1026 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1027, file: !1025, line: 54)
!1027 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !1022, line: 25, baseType: !1028)
!1028 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !1024, line: 39, baseType: !165)
!1029 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1030, file: !1025, line: 55)
!1030 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !1022, line: 26, baseType: !1031)
!1031 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !1024, line: 41, baseType: !16)
!1032 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1033, file: !1025, line: 56)
!1033 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !1022, line: 27, baseType: !1034)
!1034 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !1024, line: 44, baseType: !124)
!1035 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1036, file: !1025, line: 58)
!1036 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !1037, line: 47, baseType: !657)
!1037 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a010b332c1b55b6d664dc31f0502baaf")
!1038 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1039, file: !1025, line: 59)
!1039 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !1037, line: 49, baseType: !124)
!1040 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1041, file: !1025, line: 60)
!1041 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !1037, line: 50, baseType: !124)
!1042 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1043, file: !1025, line: 61)
!1043 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !1037, line: 51, baseType: !124)
!1044 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1045, file: !1025, line: 63)
!1045 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !1046, line: 25, baseType: !1047)
!1046 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-least.h", directory: "", checksumkind: CSK_MD5, checksum: "b93fda0210cd6f4c5a0fd5c186961bbe")
!1047 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least8_t", file: !1024, line: 52, baseType: !1023)
!1048 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1049, file: !1025, line: 64)
!1049 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !1046, line: 26, baseType: !1050)
!1050 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least16_t", file: !1024, line: 54, baseType: !1028)
!1051 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1052, file: !1025, line: 65)
!1052 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !1046, line: 27, baseType: !1053)
!1053 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least32_t", file: !1024, line: 56, baseType: !1031)
!1054 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1055, file: !1025, line: 66)
!1055 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !1046, line: 28, baseType: !1056)
!1056 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least64_t", file: !1024, line: 58, baseType: !1034)
!1057 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1058, file: !1025, line: 68)
!1058 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !1037, line: 90, baseType: !1059)
!1059 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !1024, line: 72, baseType: !124)
!1060 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1061, file: !1025, line: 69)
!1061 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !1037, line: 76, baseType: !124)
!1062 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1063, file: !1025, line: 71)
!1063 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !1064, line: 24, baseType: !1065)
!1064 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "006a4d9ce94ea5734db820ef3fdd4790")
!1065 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !1024, line: 38, baseType: !660)
!1066 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1067, file: !1025, line: 72)
!1067 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !1064, line: 25, baseType: !1068)
!1068 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !1024, line: 40, baseType: !1069)
!1069 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!1070 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1071, file: !1025, line: 73)
!1071 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !1064, line: 26, baseType: !1072)
!1072 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !1024, line: 42, baseType: !8)
!1073 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1074, file: !1025, line: 74)
!1074 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !1064, line: 27, baseType: !1075)
!1075 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !1024, line: 45, baseType: !129)
!1076 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1077, file: !1025, line: 76)
!1077 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !1037, line: 60, baseType: !660)
!1078 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1079, file: !1025, line: 77)
!1079 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !1037, line: 62, baseType: !129)
!1080 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1081, file: !1025, line: 78)
!1081 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !1037, line: 63, baseType: !129)
!1082 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1083, file: !1025, line: 79)
!1083 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !1037, line: 64, baseType: !129)
!1084 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1085, file: !1025, line: 81)
!1085 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !1046, line: 31, baseType: !1086)
!1086 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least8_t", file: !1024, line: 53, baseType: !1065)
!1087 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1088, file: !1025, line: 82)
!1088 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !1046, line: 32, baseType: !1089)
!1089 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least16_t", file: !1024, line: 55, baseType: !1068)
!1090 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1091, file: !1025, line: 83)
!1091 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !1046, line: 33, baseType: !1092)
!1092 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least32_t", file: !1024, line: 57, baseType: !1072)
!1093 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1094, file: !1025, line: 84)
!1094 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !1046, line: 34, baseType: !1095)
!1095 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least64_t", file: !1024, line: 59, baseType: !1075)
!1096 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1097, file: !1025, line: 86)
!1097 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !1037, line: 91, baseType: !1098)
!1098 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !1024, line: 73, baseType: !129)
!1099 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1100, file: !1025, line: 87)
!1100 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !1037, line: 79, baseType: !129)
!1101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1102, file: !1105, line: 62)
!1102 = !DIDerivedType(tag: DW_TAG_typedef, name: "clock_t", file: !1103, line: 7, baseType: !1104)
!1103 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/clock_t.h", directory: "", checksumkind: CSK_MD5, checksum: "1aade99fd778d1551600c7ca1410b9f1")
!1104 = !DIDerivedType(tag: DW_TAG_typedef, name: "__clock_t", file: !1024, line: 156, baseType: !124)
!1105 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/ctime", directory: "", checksumkind: CSK_MD5, checksum: "c71b95f8ba83f42a234bc5f0c3066ba9")
!1106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1107, file: !1105, line: 63)
!1107 = !DIDerivedType(tag: DW_TAG_typedef, name: "time_t", file: !1108, line: 10, baseType: !1109)
!1108 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/time_t.h", directory: "", checksumkind: CSK_MD5, checksum: "34d0816fa9aad5db7f457b5364ebec5f")
!1109 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !1024, line: 160, baseType: !124)
!1110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1111, file: !1105, line: 64)
!1111 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tm", file: !1112, line: 7, size: 448, flags: DIFlagTypePassByValue, elements: !1113, identifier: "_ZTS2tm")
!1112 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_tm.h", directory: "", checksumkind: CSK_MD5, checksum: "9e5545b565ef031c4cd0faf90b69386f")
!1113 = !{!1114, !1115, !1116, !1117, !1118, !1119, !1120, !1121, !1122, !1123, !1124}
!1114 = !DIDerivedType(tag: DW_TAG_member, name: "tm_sec", scope: !1111, file: !1112, line: 9, baseType: !16, size: 32)
!1115 = !DIDerivedType(tag: DW_TAG_member, name: "tm_min", scope: !1111, file: !1112, line: 10, baseType: !16, size: 32, offset: 32)
!1116 = !DIDerivedType(tag: DW_TAG_member, name: "tm_hour", scope: !1111, file: !1112, line: 11, baseType: !16, size: 32, offset: 64)
!1117 = !DIDerivedType(tag: DW_TAG_member, name: "tm_mday", scope: !1111, file: !1112, line: 12, baseType: !16, size: 32, offset: 96)
!1118 = !DIDerivedType(tag: DW_TAG_member, name: "tm_mon", scope: !1111, file: !1112, line: 13, baseType: !16, size: 32, offset: 128)
!1119 = !DIDerivedType(tag: DW_TAG_member, name: "tm_year", scope: !1111, file: !1112, line: 14, baseType: !16, size: 32, offset: 160)
!1120 = !DIDerivedType(tag: DW_TAG_member, name: "tm_wday", scope: !1111, file: !1112, line: 15, baseType: !16, size: 32, offset: 192)
!1121 = !DIDerivedType(tag: DW_TAG_member, name: "tm_yday", scope: !1111, file: !1112, line: 16, baseType: !16, size: 32, offset: 224)
!1122 = !DIDerivedType(tag: DW_TAG_member, name: "tm_isdst", scope: !1111, file: !1112, line: 17, baseType: !16, size: 32, offset: 256)
!1123 = !DIDerivedType(tag: DW_TAG_member, name: "tm_gmtoff", scope: !1111, file: !1112, line: 20, baseType: !124, size: 64, offset: 320)
!1124 = !DIDerivedType(tag: DW_TAG_member, name: "tm_zone", scope: !1111, file: !1112, line: 21, baseType: !821, size: 64, offset: 384)
!1125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1126, file: !1105, line: 66)
!1126 = !DISubprogram(name: "clock", scope: !1127, file: !1127, line: 72, type: !1128, flags: DIFlagPrototyped, spFlags: 0)
!1127 = !DIFile(filename: "/usr/include/time.h", directory: "", checksumkind: CSK_MD5, checksum: "3ef5cd00638ddc7c5c68875f9c70f463")
!1128 = !DISubroutineType(types: !1129)
!1129 = !{!1102}
!1130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1131, file: !1105, line: 67)
!1131 = !DISubprogram(name: "difftime", scope: !1127, file: !1127, line: 79, type: !1132, flags: DIFlagPrototyped, spFlags: 0)
!1132 = !DISubroutineType(types: !1133)
!1133 = !{!374, !1107, !1107}
!1134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1135, file: !1105, line: 68)
!1135 = !DISubprogram(name: "mktime", scope: !1127, file: !1127, line: 82, type: !1136, flags: DIFlagPrototyped, spFlags: 0)
!1136 = !DISubroutineType(types: !1137)
!1137 = !{!1107, !1138}
!1138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1111, size: 64)
!1139 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1140, file: !1105, line: 69)
!1140 = !DISubprogram(name: "time", scope: !1127, file: !1127, line: 76, type: !1141, flags: DIFlagPrototyped, spFlags: 0)
!1141 = !DISubroutineType(types: !1142)
!1142 = !{!1107, !1143}
!1143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1107, size: 64)
!1144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1145, file: !1105, line: 70)
!1145 = !DISubprogram(name: "asctime", scope: !1127, file: !1127, line: 179, type: !1146, flags: DIFlagPrototyped, spFlags: 0)
!1146 = !DISubroutineType(types: !1147)
!1147 = !{!858, !1148}
!1148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1149, size: 64)
!1149 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1111)
!1150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1151, file: !1105, line: 71)
!1151 = !DISubprogram(name: "ctime", scope: !1127, file: !1127, line: 183, type: !1152, flags: DIFlagPrototyped, spFlags: 0)
!1152 = !DISubroutineType(types: !1153)
!1153 = !{!858, !1154}
!1154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1155, size: 64)
!1155 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1107)
!1156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1157, file: !1105, line: 72)
!1157 = !DISubprogram(name: "gmtime", scope: !1127, file: !1127, line: 132, type: !1158, flags: DIFlagPrototyped, spFlags: 0)
!1158 = !DISubroutineType(types: !1159)
!1159 = !{!1138, !1154}
!1160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1161, file: !1105, line: 73)
!1161 = !DISubprogram(name: "localtime", scope: !1127, file: !1127, line: 136, type: !1158, flags: DIFlagPrototyped, spFlags: 0)
!1162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1163, file: !1105, line: 74)
!1163 = !DISubprogram(name: "strftime", scope: !1127, file: !1127, line: 99, type: !1164, flags: DIFlagPrototyped, spFlags: 0)
!1164 = !DISubroutineType(types: !1165)
!1165 = !{!808, !925, !808, !882, !1166}
!1166 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1148)
!1167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1168, file: !1105, line: 81)
!1168 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !1169, line: 11, size: 128, flags: DIFlagTypePassByValue, elements: !1170, identifier: "_ZTS8timespec")
!1169 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "9378e9ebbd658baccf881d3300eb1828")
!1170 = !{!1171, !1172}
!1171 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !1168, file: !1169, line: 16, baseType: !1109, size: 64)
!1172 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !1168, file: !1169, line: 21, baseType: !1173, size: 64, offset: 64)
!1173 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !1024, line: 197, baseType: !124)
!1174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1175, file: !1105, line: 82)
!1175 = !DISubprogram(name: "timespec_get", scope: !1127, file: !1127, line: 383, type: !1176, flags: DIFlagPrototyped, spFlags: 0)
!1176 = !DISubroutineType(types: !1177)
!1177 = !{!16, !1178, !16}
!1178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1168, size: 64)
!1179 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1180, entity: !1181, file: !1183, line: 1450)
!1180 = !DINamespace(name: "chrono", scope: !15)
!1181 = !DINamespace(name: "chrono_literals", scope: !1182, exportSymbols: true)
!1182 = !DINamespace(name: "literals", scope: !15, exportSymbols: true)
!1183 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/chrono.h", directory: "", checksumkind: CSK_MD5, checksum: "8a303c55e1a9a90d751641a38581e2bc")
!1184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1185, file: !1200, line: 66)
!1185 = !DIDerivedType(tag: DW_TAG_typedef, name: "mbstate_t", file: !1186, line: 6, baseType: !1187)
!1186 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/mbstate_t.h", directory: "", checksumkind: CSK_MD5, checksum: "ba8742313715e20e434cf6ccb2db98e3")
!1187 = !DIDerivedType(tag: DW_TAG_typedef, name: "__mbstate_t", file: !1188, line: 21, baseType: !1189)
!1188 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__mbstate_t.h", directory: "", checksumkind: CSK_MD5, checksum: "82911a3e689448e3691ded3e0b471a55")
!1189 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !1188, line: 13, size: 64, flags: DIFlagTypePassByValue, elements: !1190, identifier: "_ZTS11__mbstate_t")
!1190 = !{!1191, !1192}
!1191 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !1189, file: !1188, line: 15, baseType: !16, size: 32)
!1192 = !DIDerivedType(tag: DW_TAG_member, name: "__value", scope: !1189, file: !1188, line: 20, baseType: !1193, size: 32, offset: 32)
!1193 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !1189, file: !1188, line: 16, size: 32, flags: DIFlagTypePassByValue, elements: !1194, identifier: "_ZTSN11__mbstate_tUt_E")
!1194 = !{!1195, !1196}
!1195 = !DIDerivedType(tag: DW_TAG_member, name: "__wch", scope: !1193, file: !1188, line: 18, baseType: !8, size: 32)
!1196 = !DIDerivedType(tag: DW_TAG_member, name: "__wchb", scope: !1193, file: !1188, line: 19, baseType: !1197, size: 32)
!1197 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 32, elements: !1198)
!1198 = !{!1199}
!1199 = !DISubrange(count: 4)
!1200 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cwchar", directory: "", checksumkind: CSK_MD5, checksum: "3d8d855628d5525fe2ca47230fcfcd55")
!1201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1202, file: !1200, line: 143)
!1202 = !DIDerivedType(tag: DW_TAG_typedef, name: "wint_t", file: !1203, line: 20, baseType: !8)
!1203 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/wint_t.h", directory: "", checksumkind: CSK_MD5, checksum: "aa31b53ef28dc23152ceb41e2763ded3")
!1204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1205, file: !1200, line: 145)
!1205 = !DISubprogram(name: "btowc", scope: !1206, file: !1206, line: 309, type: !1207, flags: DIFlagPrototyped, spFlags: 0)
!1206 = !DIFile(filename: "/usr/include/wchar.h", directory: "", checksumkind: CSK_MD5, checksum: "081f28500fe92a321b35cfbaba3b7a77")
!1207 = !DISubroutineType(types: !1208)
!1208 = !{!1202, !16}
!1209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1210, file: !1200, line: 146)
!1210 = !DISubprogram(name: "fgetwc", scope: !1206, file: !1206, line: 935, type: !1211, flags: DIFlagPrototyped, spFlags: 0)
!1211 = !DISubroutineType(types: !1212)
!1212 = !{!1202, !1213}
!1213 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1214, size: 64)
!1214 = !DIDerivedType(tag: DW_TAG_typedef, name: "__FILE", file: !1215, line: 5, baseType: !1216)
!1215 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "72a8fe90981f484acae7c6f3dfc5c2b7")
!1216 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !1217, line: 51, size: 1728, flags: DIFlagFwdDecl, identifier: "_ZTS8_IO_FILE")
!1217 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "d20afd864d3b94b5c811d3345d9317bb")
!1218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1219, file: !1200, line: 147)
!1219 = !DISubprogram(name: "fgetws", scope: !1206, file: !1206, line: 964, type: !1220, flags: DIFlagPrototyped, spFlags: 0)
!1220 = !DISubroutineType(types: !1221)
!1221 = !{!880, !879, !16, !1222}
!1222 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1213)
!1223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1224, file: !1200, line: 148)
!1224 = !DISubprogram(name: "fputwc", scope: !1206, file: !1206, line: 949, type: !1225, flags: DIFlagPrototyped, spFlags: 0)
!1225 = !DISubroutineType(types: !1226)
!1226 = !{!1202, !881, !1213}
!1227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1228, file: !1200, line: 149)
!1228 = !DISubprogram(name: "fputws", scope: !1206, file: !1206, line: 971, type: !1229, flags: DIFlagPrototyped, spFlags: 0)
!1229 = !DISubroutineType(types: !1230)
!1230 = !{!16, !926, !1222}
!1231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1232, file: !1200, line: 150)
!1232 = !DISubprogram(name: "fwide", scope: !1206, file: !1206, line: 725, type: !1233, flags: DIFlagPrototyped, spFlags: 0)
!1233 = !DISubroutineType(types: !1234)
!1234 = !{!16, !1213, !16}
!1235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1236, file: !1200, line: 151)
!1236 = !DISubprogram(name: "fwprintf", scope: !1206, file: !1206, line: 732, type: !1237, flags: DIFlagPrototyped, spFlags: 0)
!1237 = !DISubroutineType(types: !1238)
!1238 = !{!16, !1222, !926, null}
!1239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1240, file: !1200, line: 152)
!1240 = !DISubprogram(name: "fwscanf", linkageName: "__isoc23_fwscanf", scope: !1206, file: !1206, line: 795, type: !1237, flags: DIFlagPrototyped, spFlags: 0)
!1241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1242, file: !1200, line: 153)
!1242 = !DISubprogram(name: "getwc", scope: !1206, file: !1206, line: 936, type: !1211, flags: DIFlagPrototyped, spFlags: 0)
!1243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1244, file: !1200, line: 154)
!1244 = !DISubprogram(name: "getwchar", scope: !1206, file: !1206, line: 942, type: !1245, flags: DIFlagPrototyped, spFlags: 0)
!1245 = !DISubroutineType(types: !1246)
!1246 = !{!1202}
!1247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1248, file: !1200, line: 155)
!1248 = !DISubprogram(name: "mbrlen", scope: !1206, file: !1206, line: 332, type: !1249, flags: DIFlagPrototyped, spFlags: 0)
!1249 = !DISubroutineType(types: !1250)
!1250 = !{!808, !882, !808, !1251}
!1251 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1252)
!1252 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1185, size: 64)
!1253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1254, file: !1200, line: 156)
!1254 = !DISubprogram(name: "mbrtowc", scope: !1206, file: !1206, line: 321, type: !1255, flags: DIFlagPrototyped, spFlags: 0)
!1255 = !DISubroutineType(types: !1256)
!1256 = !{!808, !879, !882, !808, !1251}
!1257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1258, file: !1200, line: 157)
!1258 = !DISubprogram(name: "mbsinit", scope: !1206, file: !1206, line: 317, type: !1259, flags: DIFlagPrototyped, spFlags: 0)
!1259 = !DISubroutineType(types: !1260)
!1260 = !{!16, !1261}
!1261 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1262, size: 64)
!1262 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1185)
!1263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1264, file: !1200, line: 158)
!1264 = !DISubprogram(name: "mbsrtowcs", scope: !1206, file: !1206, line: 362, type: !1265, flags: DIFlagPrototyped, spFlags: 0)
!1265 = !DISubroutineType(types: !1266)
!1266 = !{!808, !879, !1267, !808, !1251}
!1267 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1268)
!1268 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !821, size: 64)
!1269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1270, file: !1200, line: 159)
!1270 = !DISubprogram(name: "putwc", scope: !1206, file: !1206, line: 950, type: !1225, flags: DIFlagPrototyped, spFlags: 0)
!1271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1272, file: !1200, line: 160)
!1272 = !DISubprogram(name: "putwchar", scope: !1206, file: !1206, line: 956, type: !1273, flags: DIFlagPrototyped, spFlags: 0)
!1273 = !DISubroutineType(types: !1274)
!1274 = !{!1202, !881}
!1275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1276, file: !1200, line: 162)
!1276 = !DISubprogram(name: "swprintf", scope: !1206, file: !1206, line: 742, type: !1277, flags: DIFlagPrototyped, spFlags: 0)
!1277 = !DISubroutineType(types: !1278)
!1278 = !{!16, !879, !808, !926, null}
!1279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1280, file: !1200, line: 164)
!1280 = !DISubprogram(name: "swscanf", linkageName: "__isoc23_swscanf", scope: !1206, file: !1206, line: 802, type: !1281, flags: DIFlagPrototyped, spFlags: 0)
!1281 = !DISubroutineType(types: !1282)
!1282 = !{!16, !926, !926, null}
!1283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1284, file: !1200, line: 165)
!1284 = !DISubprogram(name: "ungetwc", scope: !1206, file: !1206, line: 979, type: !1285, flags: DIFlagPrototyped, spFlags: 0)
!1285 = !DISubroutineType(types: !1286)
!1286 = !{!1202, !1202, !1213}
!1287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1288, file: !1200, line: 166)
!1288 = !DISubprogram(name: "vfwprintf", scope: !1206, file: !1206, line: 750, type: !1289, flags: DIFlagPrototyped, spFlags: 0)
!1289 = !DISubroutineType(types: !1290)
!1290 = !{!16, !1222, !926, !1291}
!1291 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1292, size: 64)
!1292 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__va_list_tag", size: 192, flags: DIFlagTypePassByValue, elements: !1293, identifier: "_ZTS13__va_list_tag")
!1293 = !{!1294, !1295, !1296, !1297}
!1294 = !DIDerivedType(tag: DW_TAG_member, name: "gp_offset", scope: !1292, file: !3, baseType: !8, size: 32)
!1295 = !DIDerivedType(tag: DW_TAG_member, name: "fp_offset", scope: !1292, file: !3, baseType: !8, size: 32, offset: 32)
!1296 = !DIDerivedType(tag: DW_TAG_member, name: "overflow_arg_area", scope: !1292, file: !3, baseType: !807, size: 64, offset: 64)
!1297 = !DIDerivedType(tag: DW_TAG_member, name: "reg_save_area", scope: !1292, file: !3, baseType: !807, size: 64, offset: 128)
!1298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1299, file: !1200, line: 168)
!1299 = !DISubprogram(name: "vfwscanf", linkageName: "__isoc23_vfwscanf", scope: !1206, file: !1206, line: 875, type: !1289, flags: DIFlagPrototyped, spFlags: 0)
!1300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1301, file: !1200, line: 171)
!1301 = !DISubprogram(name: "vswprintf", scope: !1206, file: !1206, line: 763, type: !1302, flags: DIFlagPrototyped, spFlags: 0)
!1302 = !DISubroutineType(types: !1303)
!1303 = !{!16, !879, !808, !926, !1291}
!1304 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1305, file: !1200, line: 174)
!1305 = !DISubprogram(name: "vswscanf", linkageName: "__isoc23_vswscanf", scope: !1206, file: !1206, line: 882, type: !1306, flags: DIFlagPrototyped, spFlags: 0)
!1306 = !DISubroutineType(types: !1307)
!1307 = !{!16, !926, !926, !1291}
!1308 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1309, file: !1200, line: 176)
!1309 = !DISubprogram(name: "vwprintf", scope: !1206, file: !1206, line: 758, type: !1310, flags: DIFlagPrototyped, spFlags: 0)
!1310 = !DISubroutineType(types: !1311)
!1311 = !{!16, !926, !1291}
!1312 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1313, file: !1200, line: 178)
!1313 = !DISubprogram(name: "vwscanf", linkageName: "__isoc23_vwscanf", scope: !1206, file: !1206, line: 879, type: !1310, flags: DIFlagPrototyped, spFlags: 0)
!1314 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1315, file: !1200, line: 180)
!1315 = !DISubprogram(name: "wcrtomb", scope: !1206, file: !1206, line: 326, type: !1316, flags: DIFlagPrototyped, spFlags: 0)
!1316 = !DISubroutineType(types: !1317)
!1317 = !{!808, !925, !881, !1251}
!1318 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1319, file: !1200, line: 181)
!1319 = !DISubprogram(name: "wcscat", scope: !1206, file: !1206, line: 121, type: !1320, flags: DIFlagPrototyped, spFlags: 0)
!1320 = !DISubroutineType(types: !1321)
!1321 = !{!880, !879, !926}
!1322 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1323, file: !1200, line: 182)
!1323 = !DISubprogram(name: "wcscmp", scope: !1206, file: !1206, line: 130, type: !1324, flags: DIFlagPrototyped, spFlags: 0)
!1324 = !DISubroutineType(types: !1325)
!1325 = !{!16, !927, !927}
!1326 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1327, file: !1200, line: 183)
!1327 = !DISubprogram(name: "wcscoll", scope: !1206, file: !1206, line: 155, type: !1324, flags: DIFlagPrototyped, spFlags: 0)
!1328 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1329, file: !1200, line: 184)
!1329 = !DISubprogram(name: "wcscpy", scope: !1206, file: !1206, line: 98, type: !1320, flags: DIFlagPrototyped, spFlags: 0)
!1330 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1331, file: !1200, line: 185)
!1331 = !DISubprogram(name: "wcscspn", scope: !1206, file: !1206, line: 212, type: !1332, flags: DIFlagPrototyped, spFlags: 0)
!1332 = !DISubroutineType(types: !1333)
!1333 = !{!808, !927, !927}
!1334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1335, file: !1200, line: 186)
!1335 = !DISubprogram(name: "wcsftime", scope: !1206, file: !1206, line: 1043, type: !1336, flags: DIFlagPrototyped, spFlags: 0)
!1336 = !DISubroutineType(types: !1337)
!1337 = !{!808, !879, !808, !926, !1166}
!1338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1339, file: !1200, line: 187)
!1339 = !DISubprogram(name: "wcslen", scope: !1206, file: !1206, line: 247, type: !1340, flags: DIFlagPrototyped, spFlags: 0)
!1340 = !DISubroutineType(types: !1341)
!1341 = !{!808, !927}
!1342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1343, file: !1200, line: 188)
!1343 = !DISubprogram(name: "wcsncat", scope: !1206, file: !1206, line: 125, type: !1344, flags: DIFlagPrototyped, spFlags: 0)
!1344 = !DISubroutineType(types: !1345)
!1345 = !{!880, !879, !926, !808}
!1346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1347, file: !1200, line: 189)
!1347 = !DISubprogram(name: "wcsncmp", scope: !1206, file: !1206, line: 133, type: !1348, flags: DIFlagPrototyped, spFlags: 0)
!1348 = !DISubroutineType(types: !1349)
!1349 = !{!16, !927, !927, !808}
!1350 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1351, file: !1200, line: 190)
!1351 = !DISubprogram(name: "wcsncpy", scope: !1206, file: !1206, line: 103, type: !1344, flags: DIFlagPrototyped, spFlags: 0)
!1352 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1353, file: !1200, line: 191)
!1353 = !DISubprogram(name: "wcsrtombs", scope: !1206, file: !1206, line: 368, type: !1354, flags: DIFlagPrototyped, spFlags: 0)
!1354 = !DISubroutineType(types: !1355)
!1355 = !{!808, !925, !1356, !808, !1251}
!1356 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1357)
!1357 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !927, size: 64)
!1358 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1359, file: !1200, line: 192)
!1359 = !DISubprogram(name: "wcsspn", scope: !1206, file: !1206, line: 216, type: !1332, flags: DIFlagPrototyped, spFlags: 0)
!1360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1361, file: !1200, line: 193)
!1361 = !DISubprogram(name: "wcstod", scope: !1206, file: !1206, line: 402, type: !1362, flags: DIFlagPrototyped, spFlags: 0)
!1362 = !DISubroutineType(types: !1363)
!1363 = !{!374, !926, !1364}
!1364 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1365)
!1365 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !880, size: 64)
!1366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1367, file: !1200, line: 195)
!1367 = !DISubprogram(name: "wcstof", scope: !1206, file: !1206, line: 407, type: !1368, flags: DIFlagPrototyped, spFlags: 0)
!1368 = !DISubroutineType(types: !1369)
!1369 = !{!131, !926, !1364}
!1370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1371, file: !1200, line: 197)
!1371 = !DISubprogram(name: "wcstok", scope: !1206, file: !1206, line: 242, type: !1372, flags: DIFlagPrototyped, spFlags: 0)
!1372 = !DISubroutineType(types: !1373)
!1373 = !{!880, !879, !926, !1364}
!1374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1375, file: !1200, line: 198)
!1375 = !DISubprogram(name: "wcstol", linkageName: "__isoc23_wcstol", scope: !1206, file: !1206, line: 500, type: !1376, flags: DIFlagPrototyped, spFlags: 0)
!1376 = !DISubroutineType(types: !1377)
!1377 = !{!124, !926, !1364, !16}
!1378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1379, file: !1200, line: 199)
!1379 = !DISubprogram(name: "wcstoul", linkageName: "__isoc23_wcstoul", scope: !1206, file: !1206, line: 503, type: !1380, flags: DIFlagPrototyped, spFlags: 0)
!1380 = !DISubroutineType(types: !1381)
!1381 = !{!129, !926, !1364, !16}
!1382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1383, file: !1200, line: 200)
!1383 = !DISubprogram(name: "wcsxfrm", scope: !1206, file: !1206, line: 159, type: !1384, flags: DIFlagPrototyped, spFlags: 0)
!1384 = !DISubroutineType(types: !1385)
!1385 = !{!808, !879, !926, !808}
!1386 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1387, file: !1200, line: 201)
!1387 = !DISubprogram(name: "wctob", scope: !1206, file: !1206, line: 313, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1388 = !DISubroutineType(types: !1389)
!1389 = !{!16, !1202}
!1390 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1391, file: !1200, line: 202)
!1391 = !DISubprogram(name: "wmemcmp", scope: !1206, file: !1206, line: 283, type: !1348, flags: DIFlagPrototyped, spFlags: 0)
!1392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1393, file: !1200, line: 203)
!1393 = !DISubprogram(name: "wmemcpy", scope: !1206, file: !1206, line: 287, type: !1344, flags: DIFlagPrototyped, spFlags: 0)
!1394 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1395, file: !1200, line: 204)
!1395 = !DISubprogram(name: "wmemmove", scope: !1206, file: !1206, line: 292, type: !1396, flags: DIFlagPrototyped, spFlags: 0)
!1396 = !DISubroutineType(types: !1397)
!1397 = !{!880, !880, !927, !808}
!1398 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1399, file: !1200, line: 205)
!1399 = !DISubprogram(name: "wmemset", scope: !1206, file: !1206, line: 296, type: !1400, flags: DIFlagPrototyped, spFlags: 0)
!1400 = !DISubroutineType(types: !1401)
!1401 = !{!880, !880, !881, !808}
!1402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1403, file: !1200, line: 206)
!1403 = !DISubprogram(name: "wprintf", scope: !1206, file: !1206, line: 739, type: !1404, flags: DIFlagPrototyped, spFlags: 0)
!1404 = !DISubroutineType(types: !1405)
!1405 = !{!16, !926, null}
!1406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1407, file: !1200, line: 207)
!1407 = !DISubprogram(name: "wscanf", linkageName: "__isoc23_wscanf", scope: !1206, file: !1206, line: 799, type: !1404, flags: DIFlagPrototyped, spFlags: 0)
!1408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1409, file: !1200, line: 208)
!1409 = !DISubprogram(name: "wcschr", scope: !1206, file: !1206, line: 189, type: !1410, flags: DIFlagPrototyped, spFlags: 0)
!1410 = !DISubroutineType(types: !1411)
!1411 = !{!880, !927, !881}
!1412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1413, file: !1200, line: 209)
!1413 = !DISubprogram(name: "wcspbrk", scope: !1206, file: !1206, line: 226, type: !1414, flags: DIFlagPrototyped, spFlags: 0)
!1414 = !DISubroutineType(types: !1415)
!1415 = !{!880, !927, !927}
!1416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1417, file: !1200, line: 210)
!1417 = !DISubprogram(name: "wcsrchr", scope: !1206, file: !1206, line: 199, type: !1410, flags: DIFlagPrototyped, spFlags: 0)
!1418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1419, file: !1200, line: 211)
!1419 = !DISubprogram(name: "wcsstr", scope: !1206, file: !1206, line: 237, type: !1414, flags: DIFlagPrototyped, spFlags: 0)
!1420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1421, file: !1200, line: 212)
!1421 = !DISubprogram(name: "wmemchr", scope: !1206, file: !1206, line: 278, type: !1422, flags: DIFlagPrototyped, spFlags: 0)
!1422 = !DISubroutineType(types: !1423)
!1423 = !{!880, !927, !881, !808}
!1424 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1425, file: !1200, line: 253)
!1425 = !DISubprogram(name: "wcstold", scope: !1206, file: !1206, line: 409, type: !1426, flags: DIFlagPrototyped, spFlags: 0)
!1426 = !DISubroutineType(types: !1427)
!1427 = !{!971, !926, !1364}
!1428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1429, file: !1200, line: 262)
!1429 = !DISubprogram(name: "wcstoll", linkageName: "__isoc23_wcstoll", scope: !1206, file: !1206, line: 508, type: !1430, flags: DIFlagPrototyped, spFlags: 0)
!1430 = !DISubroutineType(types: !1431)
!1431 = !{!938, !926, !1364, !16}
!1432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1433, file: !1200, line: 263)
!1433 = !DISubprogram(name: "wcstoull", linkageName: "__isoc23_wcstoull", scope: !1206, file: !1206, line: 513, type: !1434, flags: DIFlagPrototyped, spFlags: 0)
!1434 = !DISubroutineType(types: !1435)
!1435 = !{!962, !926, !1364, !16}
!1436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1425, file: !1200, line: 269)
!1437 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1429, file: !1200, line: 270)
!1438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1433, file: !1200, line: 271)
!1439 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1367, file: !1200, line: 285)
!1440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1299, file: !1200, line: 288)
!1441 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1305, file: !1200, line: 291)
!1442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1313, file: !1200, line: 294)
!1443 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1425, file: !1200, line: 298)
!1444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1429, file: !1200, line: 299)
!1445 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1433, file: !1200, line: 300)
!1446 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1447, file: !1448, line: 66)
!1447 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "exception_ptr", scope: !1449, file: !1448, line: 97, size: 64, flags: DIFlagFwdDecl | DIFlagNonTrivial, identifier: "_ZTSNSt15__exception_ptr13exception_ptrE")
!1448 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/exception_ptr.h", directory: "", checksumkind: CSK_MD5, checksum: "7735536dd8c1fa8df641d3ac8e8fdf0c")
!1449 = !DINamespace(name: "__exception_ptr", scope: !15)
!1450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !1449, entity: !1451, file: !1448, line: 85)
!1451 = !DISubprogram(name: "rethrow_exception", linkageName: "_ZSt17rethrow_exceptionNSt15__exception_ptr13exception_ptrE", scope: !15, file: !1448, line: 81, type: !1452, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!1452 = !DISubroutineType(types: !1453)
!1453 = !{null, !1447}
!1454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1455, file: !1448, line: 242)
!1455 = !DISubprogram(name: "swap", linkageName: "_ZNSt15__exception_ptr4swapERNS_13exception_ptrES1_", scope: !1449, file: !1448, line: 229, type: !1456, flags: DIFlagPrototyped, spFlags: 0)
!1456 = !DISubroutineType(types: !1457)
!1457 = !{null, !1458, !1458}
!1458 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !1447, size: 64)
!1459 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1460, file: !1462, line: 55)
!1460 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lconv", file: !1461, line: 51, size: 768, flags: DIFlagFwdDecl, identifier: "_ZTS5lconv")
!1461 = !DIFile(filename: "/usr/include/locale.h", directory: "", checksumkind: CSK_MD5, checksum: "7af9c3da15ff187b79915381b9fc078f")
!1462 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/clocale", directory: "", checksumkind: CSK_MD5, checksum: "a5b91f8c38eddd257a048cb2d3085834")
!1463 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1464, file: !1462, line: 56)
!1464 = !DISubprogram(name: "setlocale", scope: !1461, file: !1461, line: 122, type: !1465, flags: DIFlagPrototyped, spFlags: 0)
!1465 = !DISubroutineType(types: !1466)
!1466 = !{!858, !16, !821}
!1467 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1468, file: !1462, line: 57)
!1468 = !DISubprogram(name: "localeconv", scope: !1461, file: !1461, line: 125, type: !1469, flags: DIFlagPrototyped, spFlags: 0)
!1469 = !DISubroutineType(types: !1470)
!1470 = !{!1471}
!1471 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1460, size: 64)
!1472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1473, file: !1475, line: 66)
!1473 = !DISubprogram(name: "isalnum", scope: !1474, file: !1474, line: 108, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1474 = !DIFile(filename: "/usr/include/ctype.h", directory: "", checksumkind: CSK_MD5, checksum: "e2a213f68dd01c4f2fee17aedf029392")
!1475 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cctype", directory: "", checksumkind: CSK_MD5, checksum: "d3476aa227d01a785da2598d95849f62")
!1476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1477, file: !1475, line: 67)
!1477 = !DISubprogram(name: "isalpha", scope: !1474, file: !1474, line: 109, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1479, file: !1475, line: 68)
!1479 = !DISubprogram(name: "iscntrl", scope: !1474, file: !1474, line: 110, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1481, file: !1475, line: 69)
!1481 = !DISubprogram(name: "isdigit", scope: !1474, file: !1474, line: 111, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1483, file: !1475, line: 70)
!1483 = !DISubprogram(name: "isgraph", scope: !1474, file: !1474, line: 113, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1485, file: !1475, line: 71)
!1485 = !DISubprogram(name: "islower", scope: !1474, file: !1474, line: 112, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1487, file: !1475, line: 72)
!1487 = !DISubprogram(name: "isprint", scope: !1474, file: !1474, line: 114, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1489, file: !1475, line: 73)
!1489 = !DISubprogram(name: "ispunct", scope: !1474, file: !1474, line: 115, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1491, file: !1475, line: 74)
!1491 = !DISubprogram(name: "isspace", scope: !1474, file: !1474, line: 116, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1492 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1493, file: !1475, line: 75)
!1493 = !DISubprogram(name: "isupper", scope: !1474, file: !1474, line: 117, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1495, file: !1475, line: 76)
!1495 = !DISubprogram(name: "isxdigit", scope: !1474, file: !1474, line: 118, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1496 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1497, file: !1475, line: 77)
!1497 = !DISubprogram(name: "tolower", scope: !1474, file: !1474, line: 122, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1498 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1499, file: !1475, line: 78)
!1499 = !DISubprogram(name: "toupper", scope: !1474, file: !1474, line: 125, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1501, file: !1475, line: 89)
!1501 = !DISubprogram(name: "isblank", scope: !1474, file: !1474, line: 130, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1502 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1503, entity: !1504, file: !1505, line: 58)
!1503 = !DINamespace(name: "__gnu_debug", scope: null)
!1504 = !DINamespace(name: "__debug", scope: !15)
!1505 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/debug/debug.h", directory: "", checksumkind: CSK_MD5, checksum: "80ffd9396e36ed0eb5124a5fe3264bd2")
!1506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1507, file: !1509, line: 100)
!1507 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !1508, line: 7, baseType: !1216)
!1508 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!1509 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstdio", directory: "", checksumkind: CSK_MD5, checksum: "140e9118c682fc556b5a634d4d0e0a02")
!1510 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1511, file: !1509, line: 101)
!1511 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !1512, line: 85, baseType: !1513)
!1512 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "2b86e735d437d54be7e36ccbb6a06d84")
!1513 = !DIDerivedType(tag: DW_TAG_typedef, name: "__fpos_t", file: !1514, line: 14, baseType: !1515)
!1514 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__fpos_t.h", directory: "", checksumkind: CSK_MD5, checksum: "32de8bdaf3551a6c0a9394f9af4389ce")
!1515 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_G_fpos_t", file: !1514, line: 10, size: 128, flags: DIFlagFwdDecl, identifier: "_ZTS9_G_fpos_t")
!1516 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1517, file: !1509, line: 103)
!1517 = !DISubprogram(name: "clearerr", scope: !1512, file: !1512, line: 850, type: !1518, flags: DIFlagPrototyped, spFlags: 0)
!1518 = !DISubroutineType(types: !1519)
!1519 = !{null, !1520}
!1520 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1507, size: 64)
!1521 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1522, file: !1509, line: 104)
!1522 = !DISubprogram(name: "fclose", scope: !1512, file: !1512, line: 187, type: !1523, flags: DIFlagPrototyped, spFlags: 0)
!1523 = !DISubroutineType(types: !1524)
!1524 = !{!16, !1520}
!1525 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1526, file: !1509, line: 105)
!1526 = !DISubprogram(name: "feof", scope: !1512, file: !1512, line: 852, type: !1523, flags: DIFlagPrototyped, spFlags: 0)
!1527 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1528, file: !1509, line: 106)
!1528 = !DISubprogram(name: "ferror", scope: !1512, file: !1512, line: 854, type: !1523, flags: DIFlagPrototyped, spFlags: 0)
!1529 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1530, file: !1509, line: 107)
!1530 = !DISubprogram(name: "fflush", scope: !1512, file: !1512, line: 239, type: !1523, flags: DIFlagPrototyped, spFlags: 0)
!1531 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1532, file: !1509, line: 108)
!1532 = !DISubprogram(name: "fgetc", scope: !1512, file: !1512, line: 578, type: !1523, flags: DIFlagPrototyped, spFlags: 0)
!1533 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1534, file: !1509, line: 109)
!1534 = !DISubprogram(name: "fgetpos", scope: !1512, file: !1512, line: 819, type: !1535, flags: DIFlagPrototyped, spFlags: 0)
!1535 = !DISubroutineType(types: !1536)
!1536 = !{!16, !1537, !1538}
!1537 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1520)
!1538 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1539)
!1539 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1511, size: 64)
!1540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1541, file: !1509, line: 110)
!1541 = !DISubprogram(name: "fgets", scope: !1512, file: !1512, line: 654, type: !1542, flags: DIFlagPrototyped, spFlags: 0)
!1542 = !DISubroutineType(types: !1543)
!1543 = !{!858, !925, !16, !1537}
!1544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1545, file: !1509, line: 111)
!1545 = !DISubprogram(name: "fopen", scope: !1512, file: !1512, line: 267, type: !1546, flags: DIFlagPrototyped, spFlags: 0)
!1546 = !DISubroutineType(types: !1547)
!1547 = !{!1520, !882, !882}
!1548 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1549, file: !1509, line: 112)
!1549 = !DISubprogram(name: "fprintf", scope: !1512, file: !1512, line: 360, type: !1550, flags: DIFlagPrototyped, spFlags: 0)
!1550 = !DISubroutineType(types: !1551)
!1551 = !{!16, !1537, !882, null}
!1552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1553, file: !1509, line: 113)
!1553 = !DISubprogram(name: "fputc", scope: !1512, file: !1512, line: 611, type: !1554, flags: DIFlagPrototyped, spFlags: 0)
!1554 = !DISubroutineType(types: !1555)
!1555 = !{!16, !16, !1520}
!1556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1557, file: !1509, line: 114)
!1557 = !DISubprogram(name: "fputs", scope: !1512, file: !1512, line: 707, type: !1558, flags: DIFlagPrototyped, spFlags: 0)
!1558 = !DISubroutineType(types: !1559)
!1559 = !{!16, !882, !1537}
!1560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1561, file: !1509, line: 115)
!1561 = !DISubprogram(name: "fread", scope: !1512, file: !1512, line: 728, type: !1562, flags: DIFlagPrototyped, spFlags: 0)
!1562 = !DISubroutineType(types: !1563)
!1563 = !{!808, !1564, !808, !808, !1537}
!1564 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !807)
!1565 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1566, file: !1509, line: 116)
!1566 = !DISubprogram(name: "freopen", scope: !1512, file: !1512, line: 274, type: !1567, flags: DIFlagPrototyped, spFlags: 0)
!1567 = !DISubroutineType(types: !1568)
!1568 = !{!1520, !882, !882, !1537}
!1569 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1570, file: !1509, line: 117)
!1570 = !DISubprogram(name: "fscanf", linkageName: "__isoc23_fscanf", scope: !1512, file: !1512, line: 445, type: !1550, flags: DIFlagPrototyped, spFlags: 0)
!1571 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1572, file: !1509, line: 118)
!1572 = !DISubprogram(name: "fseek", scope: !1512, file: !1512, line: 769, type: !1573, flags: DIFlagPrototyped, spFlags: 0)
!1573 = !DISubroutineType(types: !1574)
!1574 = !{!16, !1520, !124, !16}
!1575 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1576, file: !1509, line: 119)
!1576 = !DISubprogram(name: "fsetpos", scope: !1512, file: !1512, line: 825, type: !1577, flags: DIFlagPrototyped, spFlags: 0)
!1577 = !DISubroutineType(types: !1578)
!1578 = !{!16, !1520, !1579}
!1579 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1580, size: 64)
!1580 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1511)
!1581 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1582, file: !1509, line: 120)
!1582 = !DISubprogram(name: "ftell", scope: !1512, file: !1512, line: 775, type: !1583, flags: DIFlagPrototyped, spFlags: 0)
!1583 = !DISubroutineType(types: !1584)
!1584 = !{!124, !1520}
!1585 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1586, file: !1509, line: 121)
!1586 = !DISubprogram(name: "fwrite", scope: !1512, file: !1512, line: 735, type: !1587, flags: DIFlagPrototyped, spFlags: 0)
!1587 = !DISubroutineType(types: !1588)
!1588 = !{!808, !1589, !808, !808, !1537}
!1589 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !834)
!1590 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1591, file: !1509, line: 122)
!1591 = !DISubprogram(name: "getc", scope: !1512, file: !1512, line: 579, type: !1523, flags: DIFlagPrototyped, spFlags: 0)
!1592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1593, file: !1509, line: 123)
!1593 = !DISubprogram(name: "getchar", scope: !1512, file: !1512, line: 585, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1594 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1595, file: !1509, line: 128)
!1595 = !DISubprogram(name: "perror", scope: !1512, file: !1512, line: 868, type: !1596, flags: DIFlagPrototyped, spFlags: 0)
!1596 = !DISubroutineType(types: !1597)
!1597 = !{null, !821}
!1598 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1599, file: !1509, line: 129)
!1599 = !DISubprogram(name: "printf", scope: !1512, file: !1512, line: 366, type: !1600, flags: DIFlagPrototyped, spFlags: 0)
!1600 = !DISubroutineType(types: !1601)
!1601 = !{!16, !882, null}
!1602 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1603, file: !1509, line: 130)
!1603 = !DISubprogram(name: "putc", scope: !1512, file: !1512, line: 612, type: !1554, flags: DIFlagPrototyped, spFlags: 0)
!1604 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1605, file: !1509, line: 131)
!1605 = !DISubprogram(name: "putchar", scope: !1512, file: !1512, line: 618, type: !786, flags: DIFlagPrototyped, spFlags: 0)
!1606 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1607, file: !1509, line: 132)
!1607 = !DISubprogram(name: "puts", scope: !1512, file: !1512, line: 714, type: !824, flags: DIFlagPrototyped, spFlags: 0)
!1608 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1609, file: !1509, line: 133)
!1609 = !DISubprogram(name: "remove", scope: !1512, file: !1512, line: 158, type: !824, flags: DIFlagPrototyped, spFlags: 0)
!1610 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1611, file: !1509, line: 134)
!1611 = !DISubprogram(name: "rename", scope: !1512, file: !1512, line: 160, type: !1612, flags: DIFlagPrototyped, spFlags: 0)
!1612 = !DISubroutineType(types: !1613)
!1613 = !{!16, !821, !821}
!1614 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1615, file: !1509, line: 135)
!1615 = !DISubprogram(name: "rewind", scope: !1512, file: !1512, line: 780, type: !1518, flags: DIFlagPrototyped, spFlags: 0)
!1616 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1617, file: !1509, line: 136)
!1617 = !DISubprogram(name: "scanf", linkageName: "__isoc23_scanf", scope: !1512, file: !1512, line: 448, type: !1600, flags: DIFlagPrototyped, spFlags: 0)
!1618 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1619, file: !1509, line: 137)
!1619 = !DISubprogram(name: "setbuf", scope: !1512, file: !1512, line: 337, type: !1620, flags: DIFlagPrototyped, spFlags: 0)
!1620 = !DISubroutineType(types: !1621)
!1621 = !{null, !1537, !925}
!1622 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1623, file: !1509, line: 138)
!1623 = !DISubprogram(name: "setvbuf", scope: !1512, file: !1512, line: 342, type: !1624, flags: DIFlagPrototyped, spFlags: 0)
!1624 = !DISubroutineType(types: !1625)
!1625 = !{!16, !1537, !925, !16, !808}
!1626 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1627, file: !1509, line: 139)
!1627 = !DISubprogram(name: "sprintf", scope: !1512, file: !1512, line: 368, type: !1628, flags: DIFlagPrototyped, spFlags: 0)
!1628 = !DISubroutineType(types: !1629)
!1629 = !{!16, !925, !882, null}
!1630 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1631, file: !1509, line: 140)
!1631 = !DISubprogram(name: "sscanf", linkageName: "__isoc23_sscanf", scope: !1512, file: !1512, line: 450, type: !1632, flags: DIFlagPrototyped, spFlags: 0)
!1632 = !DISubroutineType(types: !1633)
!1633 = !{!16, !882, !882, null}
!1634 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1635, file: !1509, line: 141)
!1635 = !DISubprogram(name: "tmpfile", scope: !1512, file: !1512, line: 197, type: !1636, flags: DIFlagPrototyped, spFlags: 0)
!1636 = !DISubroutineType(types: !1637)
!1637 = !{!1520}
!1638 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1639, file: !1509, line: 143)
!1639 = !DISubprogram(name: "tmpnam", scope: !1512, file: !1512, line: 214, type: !1640, flags: DIFlagPrototyped, spFlags: 0)
!1640 = !DISubroutineType(types: !1641)
!1641 = !{!858, !858}
!1642 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1643, file: !1509, line: 145)
!1643 = !DISubprogram(name: "ungetc", scope: !1512, file: !1512, line: 721, type: !1554, flags: DIFlagPrototyped, spFlags: 0)
!1644 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1645, file: !1509, line: 146)
!1645 = !DISubprogram(name: "vfprintf", scope: !1512, file: !1512, line: 375, type: !1646, flags: DIFlagPrototyped, spFlags: 0)
!1646 = !DISubroutineType(types: !1647)
!1647 = !{!16, !1537, !882, !1291}
!1648 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1649, file: !1509, line: 147)
!1649 = !DISubprogram(name: "vprintf", scope: !1512, file: !1512, line: 381, type: !1650, flags: DIFlagPrototyped, spFlags: 0)
!1650 = !DISubroutineType(types: !1651)
!1651 = !{!16, !882, !1291}
!1652 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1653, file: !1509, line: 148)
!1653 = !DISubprogram(name: "vsprintf", scope: !1512, file: !1512, line: 383, type: !1654, flags: DIFlagPrototyped, spFlags: 0)
!1654 = !DISubroutineType(types: !1655)
!1655 = !{!16, !925, !882, !1291}
!1656 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1657, file: !1509, line: 177)
!1657 = !DISubprogram(name: "snprintf", scope: !1512, file: !1512, line: 388, type: !1658, flags: DIFlagPrototyped, spFlags: 0)
!1658 = !DISubroutineType(types: !1659)
!1659 = !{!16, !925, !808, !882, null}
!1660 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1661, file: !1509, line: 178)
!1661 = !DISubprogram(name: "vfscanf", linkageName: "__isoc23_vfscanf", scope: !1512, file: !1512, line: 514, type: !1646, flags: DIFlagPrototyped, spFlags: 0)
!1662 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1663, file: !1509, line: 179)
!1663 = !DISubprogram(name: "vscanf", linkageName: "__isoc23_vscanf", scope: !1512, file: !1512, line: 519, type: !1650, flags: DIFlagPrototyped, spFlags: 0)
!1664 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1665, file: !1509, line: 180)
!1665 = !DISubprogram(name: "vsnprintf", scope: !1512, file: !1512, line: 392, type: !1666, flags: DIFlagPrototyped, spFlags: 0)
!1666 = !DISubroutineType(types: !1667)
!1667 = !{!16, !925, !808, !882, !1291}
!1668 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !7, entity: !1669, file: !1509, line: 181)
!1669 = !DISubprogram(name: "vsscanf", linkageName: "__isoc23_vsscanf", scope: !1512, file: !1512, line: 522, type: !1670, flags: DIFlagPrototyped, spFlags: 0)
!1670 = !DISubroutineType(types: !1671)
!1671 = !{!16, !882, !882, !1291}
!1672 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1657, file: !1509, line: 187)
!1673 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1661, file: !1509, line: 188)
!1674 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1663, file: !1509, line: 189)
!1675 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1665, file: !1509, line: 190)
!1676 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1669, file: !1509, line: 191)
!1677 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1678, file: !1684, line: 66)
!1678 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !1679, line: 24, baseType: !1680)
!1679 = !DIFile(filename: "/usr/lib/llvm-20/lib/clang/20/include/__stddef_max_align_t.h", directory: "", checksumkind: CSK_MD5, checksum: "3c0a2f19d136d39aa835c737c7105def")
!1680 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !1679, line: 19, size: 256, flags: DIFlagTypePassByValue, elements: !1681, identifier: "_ZTS11max_align_t")
!1681 = !{!1682, !1683}
!1682 = !DIDerivedType(tag: DW_TAG_member, name: "__clang_max_align_nonce1", scope: !1680, file: !1679, line: 20, baseType: !938, size: 64, align: 64)
!1683 = !DIDerivedType(tag: DW_TAG_member, name: "__clang_max_align_nonce2", scope: !1680, file: !1679, line: 22, baseType: !971, size: 128, align: 128, offset: 128)
!1684 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstddef", directory: "", checksumkind: CSK_MD5, checksum: "706d8a8b8e4539901a932f881126a58d")
!1685 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1686, file: !1690, line: 84)
!1686 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctrans_t", file: !1687, line: 48, baseType: !1688)
!1687 = !DIFile(filename: "/usr/include/wctype.h", directory: "", checksumkind: CSK_MD5, checksum: "eb899898ca6787a1d4533309ff3c8b00")
!1688 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1689, size: 64)
!1689 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1031)
!1690 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cwctype", directory: "", checksumkind: CSK_MD5, checksum: "32894772a679990eb913e19195b497d2")
!1691 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1692, file: !1690, line: 85)
!1692 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctype_t", file: !1693, line: 38, baseType: !129)
!1693 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/wctype-wchar.h", directory: "", checksumkind: CSK_MD5, checksum: "29dda66c031fd8630d4cbcc1f5185c52")
!1694 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1202, file: !1690, line: 86)
!1695 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1696, file: !1690, line: 88)
!1696 = !DISubprogram(name: "iswalnum", scope: !1693, file: !1693, line: 95, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1697 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1698, file: !1690, line: 89)
!1698 = !DISubprogram(name: "iswalpha", scope: !1693, file: !1693, line: 101, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1699 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1700, file: !1690, line: 91)
!1700 = !DISubprogram(name: "iswblank", scope: !1693, file: !1693, line: 146, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1701 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1702, file: !1690, line: 93)
!1702 = !DISubprogram(name: "iswcntrl", scope: !1693, file: !1693, line: 104, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1703 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1704, file: !1690, line: 94)
!1704 = !DISubprogram(name: "iswctype", scope: !1693, file: !1693, line: 159, type: !1705, flags: DIFlagPrototyped, spFlags: 0)
!1705 = !DISubroutineType(types: !1706)
!1706 = !{!16, !1202, !1692}
!1707 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1708, file: !1690, line: 95)
!1708 = !DISubprogram(name: "iswdigit", scope: !1693, file: !1693, line: 108, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1709 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1710, file: !1690, line: 96)
!1710 = !DISubprogram(name: "iswgraph", scope: !1693, file: !1693, line: 112, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1711 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1712, file: !1690, line: 97)
!1712 = !DISubprogram(name: "iswlower", scope: !1693, file: !1693, line: 117, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1713 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1714, file: !1690, line: 98)
!1714 = !DISubprogram(name: "iswprint", scope: !1693, file: !1693, line: 120, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1715 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1716, file: !1690, line: 99)
!1716 = !DISubprogram(name: "iswpunct", scope: !1693, file: !1693, line: 125, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1717 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1718, file: !1690, line: 100)
!1718 = !DISubprogram(name: "iswspace", scope: !1693, file: !1693, line: 130, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1719 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1720, file: !1690, line: 101)
!1720 = !DISubprogram(name: "iswupper", scope: !1693, file: !1693, line: 135, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1721 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1722, file: !1690, line: 102)
!1722 = !DISubprogram(name: "iswxdigit", scope: !1693, file: !1693, line: 140, type: !1388, flags: DIFlagPrototyped, spFlags: 0)
!1723 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1724, file: !1690, line: 103)
!1724 = !DISubprogram(name: "towctrans", scope: !1687, file: !1687, line: 55, type: !1725, flags: DIFlagPrototyped, spFlags: 0)
!1725 = !DISubroutineType(types: !1726)
!1726 = !{!1202, !1202, !1686}
!1727 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1728, file: !1690, line: 104)
!1728 = !DISubprogram(name: "towlower", scope: !1693, file: !1693, line: 166, type: !1729, flags: DIFlagPrototyped, spFlags: 0)
!1729 = !DISubroutineType(types: !1730)
!1730 = !{!1202, !1202}
!1731 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1732, file: !1690, line: 105)
!1732 = !DISubprogram(name: "towupper", scope: !1693, file: !1693, line: 169, type: !1729, flags: DIFlagPrototyped, spFlags: 0)
!1733 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1734, file: !1690, line: 106)
!1734 = !DISubprogram(name: "wctrans", scope: !1687, file: !1687, line: 52, type: !1735, flags: DIFlagPrototyped, spFlags: 0)
!1735 = !DISubroutineType(types: !1736)
!1736 = !{!1686, !821}
!1737 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1738, file: !1690, line: 107)
!1738 = !DISubprogram(name: "wctype", scope: !1693, file: !1693, line: 155, type: !1739, flags: DIFlagPrototyped, spFlags: 0)
!1739 = !DISubroutineType(types: !1740)
!1740 = !{!1692, !821}
!1741 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !5, file: !1742, line: 97)
!1742 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/shared_ptr_base.h", directory: "", checksumkind: CSK_MD5, checksum: "b9d5bd7f1c59e9ec96882129c5cb5d1b")
!1743 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !1744, file: !1742, line: 98)
!1744 = !DIGlobalVariable(name: "__default_lock_policy", linkageName: "_ZN9__gnu_cxx21__default_lock_policyE", scope: !7, file: !6, line: 58, type: !1745, isLocal: false, isDefinition: false)
!1745 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!1746 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !1747, entity: !1748, file: !1755, line: 1927)
!1747 = !DINamespace(name: "__format", scope: !15)
!1748 = !DISubprogram(name: "to_chars", linkageName: "_ZSt8to_charsPcS_eSt12chars_formati", scope: !15, file: !97, line: 800, type: !1749, flags: DIFlagPrototyped, spFlags: 0)
!1749 = !DISubroutineType(types: !1750)
!1750 = !{!1751, !858, !858, !971, !96, !16}
!1751 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "to_chars_result", scope: !15, file: !97, line: 62, size: 128, flags: DIFlagTypePassByValue, elements: !1752, identifier: "_ZTSSt15to_chars_result")
!1752 = !{!1753, !1754}
!1753 = !DIDerivedType(tag: DW_TAG_member, name: "ptr", scope: !1751, file: !97, line: 64, baseType: !858, size: 64)
!1754 = !DIDerivedType(tag: DW_TAG_member, name: "ec", scope: !1751, file: !97, line: 65, baseType: !13, size: 32, offset: 64)
!1755 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/format", directory: "", checksumkind: CSK_MD5, checksum: "e3ce6ca5d4a7e5215163adf9d3010c65")
!1756 = !{i32 7, !"Dwarf Version", i32 5}
!1757 = !{i32 2, !"Debug Info Version", i32 3}
!1758 = !{i32 1, !"wchar_size", i32 4}
!1759 = !{i32 8, !"PIC Level", i32 2}
!1760 = !{i32 7, !"PIE Level", i32 2}
!1761 = !{i32 7, !"uwtable", i32 2}
!1762 = !{i32 7, !"frame-pointer", i32 2}
!1763 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!1764 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 601, type: !1765, scopeLine: 601, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!1765 = !DISubroutineType(types: !1766)
!1766 = !{!16, !16, !910}
!1767 = !{}
!1768 = !DILocalVariable(name: "argc", arg: 1, scope: !1764, file: !3, line: 601, type: !16)
!1769 = !DILocation(line: 601, column: 14, scope: !1764)
!1770 = !DILocalVariable(name: "argv", arg: 2, scope: !1764, file: !3, line: 601, type: !910)
!1771 = !DILocation(line: 601, column: 27, scope: !1764)
!1772 = !DILocation(line: 602, column: 9, scope: !1773)
!1773 = distinct !DILexicalBlock(scope: !1764, file: !3, line: 602, column: 9)
!1774 = !DILocation(line: 602, column: 14, scope: !1773)
!1775 = !DILocation(line: 602, column: 41, scope: !1773)
!1776 = !DILocation(line: 602, column: 49, scope: !1773)
!1777 = !DILocation(line: 602, column: 44, scope: !1773)
!1778 = !DILocation(line: 602, column: 32, scope: !1773)
!1779 = !DILocation(line: 602, column: 30, scope: !1773)
!1780 = !DILocation(line: 602, column: 19, scope: !1773)
!1781 = !DILocation(line: 603, column: 9, scope: !1782)
!1782 = distinct !DILexicalBlock(scope: !1764, file: !3, line: 603, column: 9)
!1783 = !DILocation(line: 603, column: 14, scope: !1782)
!1784 = !DILocation(line: 603, column: 41, scope: !1782)
!1785 = !DILocation(line: 603, column: 49, scope: !1782)
!1786 = !DILocation(line: 603, column: 44, scope: !1782)
!1787 = !DILocation(line: 603, column: 32, scope: !1782)
!1788 = !DILocation(line: 603, column: 30, scope: !1782)
!1789 = !DILocation(line: 603, column: 19, scope: !1782)
!1790 = !DILocation(line: 604, column: 9, scope: !1791)
!1791 = distinct !DILexicalBlock(scope: !1764, file: !3, line: 604, column: 9)
!1792 = !DILocation(line: 604, column: 20, scope: !1791)
!1793 = !DILocation(line: 604, column: 36, scope: !1794)
!1794 = distinct !DILexicalBlock(scope: !1791, file: !3, line: 604, column: 26)
!1795 = !DILocation(line: 604, column: 28, scope: !1794)
!1796 = !DILocation(line: 604, column: 76, scope: !1794)
!1797 = !DILocation(line: 604, column: 82, scope: !1794)
!1798 = !DILocation(line: 606, column: 5, scope: !1764)
!1799 = !DILocation(line: 607, column: 5, scope: !1764)
!1800 = !DILocation(line: 608, column: 69, scope: !1764)
!1801 = !DILocation(line: 608, column: 81, scope: !1764)
!1802 = !DILocation(line: 608, column: 5, scope: !1764)
!1803 = !DILocation(line: 609, column: 5, scope: !1764)
!1804 = !DILocalVariable(name: "A_sh", scope: !1764, file: !3, line: 612, type: !124)
!1805 = !DILocation(line: 612, column: 10, scope: !1764)
!1806 = !DILocalVariable(name: "A_pr", scope: !1764, file: !3, line: 612, type: !124)
!1807 = !DILocation(line: 612, column: 20, scope: !1764)
!1808 = !DILocalVariable(name: "args", scope: !1809, file: !3, line: 614, type: !119)
!1809 = distinct !DILexicalBlock(scope: !1764, file: !3, line: 613, column: 5)
!1810 = !DILocation(line: 614, column: 22, scope: !1809)
!1811 = !DILocation(line: 614, column: 51, scope: !1809)
!1812 = !DILocation(line: 614, column: 44, scope: !1809)
!1813 = !DILocalVariable(name: "threads", scope: !1809, file: !3, line: 615, type: !126)
!1814 = !DILocation(line: 615, column: 20, scope: !1809)
!1815 = !DILocation(line: 615, column: 50, scope: !1809)
!1816 = !DILocation(line: 615, column: 61, scope: !1809)
!1817 = !DILocation(line: 615, column: 43, scope: !1809)
!1818 = !DILocation(line: 616, column: 20, scope: !1809)
!1819 = !DILocalVariable(name: "i", scope: !1820, file: !3, line: 617, type: !16)
!1820 = distinct !DILexicalBlock(scope: !1809, file: !3, line: 617, column: 9)
!1821 = !DILocation(line: 617, column: 18, scope: !1820)
!1822 = !DILocation(line: 617, column: 14, scope: !1820)
!1823 = !DILocation(line: 617, column: 25, scope: !1824)
!1824 = distinct !DILexicalBlock(scope: !1820, file: !3, line: 617, column: 9)
!1825 = !DILocation(line: 617, column: 29, scope: !1824)
!1826 = !DILocation(line: 617, column: 27, scope: !1824)
!1827 = !DILocation(line: 617, column: 9, scope: !1820)
!1828 = !DILocation(line: 618, column: 33, scope: !1829)
!1829 = distinct !DILexicalBlock(scope: !1824, file: !3, line: 617, column: 46)
!1830 = !DILocation(line: 618, column: 13, scope: !1829)
!1831 = !DILocation(line: 618, column: 18, scope: !1829)
!1832 = !DILocation(line: 618, column: 21, scope: !1829)
!1833 = !DILocation(line: 618, column: 31, scope: !1829)
!1834 = !DILocation(line: 619, column: 29, scope: !1829)
!1835 = !DILocation(line: 619, column: 37, scope: !1829)
!1836 = !DILocation(line: 619, column: 66, scope: !1829)
!1837 = !DILocation(line: 619, column: 71, scope: !1829)
!1838 = !DILocation(line: 619, column: 13, scope: !1829)
!1839 = !DILocation(line: 620, column: 9, scope: !1829)
!1840 = !DILocation(line: 617, column: 42, scope: !1824)
!1841 = !DILocation(line: 617, column: 9, scope: !1824)
!1842 = distinct !{!1842, !1827, !1843, !1844}
!1843 = !DILocation(line: 620, column: 9, scope: !1820)
!1844 = !{!"llvm.loop.mustprogress"}
!1845 = !DILocalVariable(name: "i", scope: !1846, file: !3, line: 621, type: !16)
!1846 = distinct !DILexicalBlock(scope: !1809, file: !3, line: 621, column: 9)
!1847 = !DILocation(line: 621, column: 18, scope: !1846)
!1848 = !DILocation(line: 621, column: 14, scope: !1846)
!1849 = !DILocation(line: 621, column: 25, scope: !1850)
!1850 = distinct !DILexicalBlock(scope: !1846, file: !3, line: 621, column: 9)
!1851 = !DILocation(line: 621, column: 29, scope: !1850)
!1852 = !DILocation(line: 621, column: 27, scope: !1850)
!1853 = !DILocation(line: 621, column: 9, scope: !1846)
!1854 = !DILocation(line: 621, column: 59, scope: !1850)
!1855 = !DILocation(line: 621, column: 67, scope: !1850)
!1856 = !DILocation(line: 621, column: 46, scope: !1850)
!1857 = !DILocation(line: 621, column: 42, scope: !1850)
!1858 = !DILocation(line: 621, column: 9, scope: !1850)
!1859 = distinct !{!1859, !1853, !1860, !1844}
!1860 = !DILocation(line: 621, column: 78, scope: !1846)
!1861 = !DILocalVariable(name: "i", scope: !1862, file: !3, line: 622, type: !16)
!1862 = distinct !DILexicalBlock(scope: !1809, file: !3, line: 622, column: 9)
!1863 = !DILocation(line: 622, column: 18, scope: !1862)
!1864 = !DILocation(line: 622, column: 14, scope: !1862)
!1865 = !DILocation(line: 622, column: 25, scope: !1866)
!1866 = distinct !DILexicalBlock(scope: !1862, file: !3, line: 622, column: 9)
!1867 = !DILocation(line: 622, column: 29, scope: !1866)
!1868 = !DILocation(line: 622, column: 27, scope: !1866)
!1869 = !DILocation(line: 622, column: 9, scope: !1862)
!1870 = !DILocation(line: 623, column: 21, scope: !1871)
!1871 = distinct !DILexicalBlock(scope: !1866, file: !3, line: 622, column: 46)
!1872 = !DILocation(line: 623, column: 26, scope: !1871)
!1873 = !DILocation(line: 623, column: 29, scope: !1871)
!1874 = !DILocation(line: 623, column: 18, scope: !1871)
!1875 = !DILocation(line: 624, column: 21, scope: !1871)
!1876 = !DILocation(line: 624, column: 26, scope: !1871)
!1877 = !DILocation(line: 624, column: 29, scope: !1871)
!1878 = !DILocation(line: 624, column: 18, scope: !1871)
!1879 = !DILocation(line: 625, column: 9, scope: !1871)
!1880 = !DILocation(line: 622, column: 42, scope: !1866)
!1881 = !DILocation(line: 622, column: 9, scope: !1866)
!1882 = distinct !{!1882, !1869, !1883, !1844}
!1883 = !DILocation(line: 625, column: 9, scope: !1862)
!1884 = !DILocation(line: 627, column: 22, scope: !1809)
!1885 = !DILocation(line: 627, column: 21, scope: !1809)
!1886 = !DILocation(line: 627, column: 31, scope: !1809)
!1887 = !DILocation(line: 626, column: 9, scope: !1809)
!1888 = !DILocation(line: 628, column: 56, scope: !1809)
!1889 = !DILocation(line: 628, column: 68, scope: !1809)
!1890 = !DILocation(line: 628, column: 67, scope: !1809)
!1891 = !DILocation(line: 628, column: 74, scope: !1809)
!1892 = !DILocation(line: 628, column: 79, scope: !1809)
!1893 = !DILocation(line: 628, column: 78, scope: !1809)
!1894 = !DILocation(line: 628, column: 73, scope: !1809)
!1895 = !DILocation(line: 628, column: 72, scope: !1809)
!1896 = !DILocation(line: 628, column: 9, scope: !1809)
!1897 = !DILocation(line: 629, column: 56, scope: !1809)
!1898 = !DILocation(line: 629, column: 68, scope: !1809)
!1899 = !DILocation(line: 629, column: 67, scope: !1809)
!1900 = !DILocation(line: 629, column: 74, scope: !1809)
!1901 = !DILocation(line: 629, column: 79, scope: !1809)
!1902 = !DILocation(line: 629, column: 78, scope: !1809)
!1903 = !DILocation(line: 629, column: 73, scope: !1809)
!1904 = !DILocation(line: 629, column: 72, scope: !1809)
!1905 = !DILocation(line: 629, column: 9, scope: !1809)
!1906 = !DILocation(line: 630, column: 14, scope: !1809)
!1907 = !DILocation(line: 630, column: 9, scope: !1809)
!1908 = !DILocation(line: 630, column: 26, scope: !1809)
!1909 = !DILocation(line: 630, column: 21, scope: !1809)
!1910 = !DILocation(line: 634, column: 5, scope: !1764)
!1911 = !DILocalVariable(name: "B_sh", scope: !1764, file: !3, line: 636, type: !124)
!1912 = !DILocation(line: 636, column: 10, scope: !1764)
!1913 = !DILocalVariable(name: "B_pr", scope: !1764, file: !3, line: 636, type: !124)
!1914 = !DILocation(line: 636, column: 20, scope: !1764)
!1915 = !DILocalVariable(name: "n_prod", scope: !1916, file: !3, line: 639, type: !16)
!1916 = distinct !DILexicalBlock(scope: !1764, file: !3, line: 638, column: 5)
!1917 = !DILocation(line: 639, column: 13, scope: !1916)
!1918 = !DILocation(line: 639, column: 22, scope: !1916)
!1919 = !DILocation(line: 639, column: 33, scope: !1916)
!1920 = !DILocation(line: 639, column: 37, scope: !1916)
!1921 = !DILocation(line: 639, column: 43, scope: !1916)
!1922 = !DILocation(line: 639, column: 54, scope: !1916)
!1923 = !DILocalVariable(name: "n_cons", scope: !1916, file: !3, line: 640, type: !16)
!1924 = !DILocation(line: 640, column: 13, scope: !1916)
!1925 = !DILocation(line: 640, column: 22, scope: !1916)
!1926 = !DILocation(line: 640, column: 35, scope: !1916)
!1927 = !DILocation(line: 640, column: 33, scope: !1916)
!1928 = !DILocalVariable(name: "ipp", scope: !1916, file: !3, line: 641, type: !16)
!1929 = !DILocation(line: 641, column: 13, scope: !1916)
!1930 = !DILocation(line: 641, column: 29, scope: !1916)
!1931 = !DILocation(line: 641, column: 27, scope: !1916)
!1932 = !DILocation(line: 642, column: 23, scope: !1916)
!1933 = !DILocation(line: 642, column: 32, scope: !1916)
!1934 = !DILocation(line: 642, column: 30, scope: !1916)
!1935 = !DILocation(line: 642, column: 36, scope: !1916)
!1936 = !DILocation(line: 642, column: 22, scope: !1916)
!1937 = !DILocation(line: 642, column: 50, scope: !1916)
!1938 = !DILocation(line: 642, column: 59, scope: !1916)
!1939 = !DILocation(line: 642, column: 57, scope: !1916)
!1940 = !DILocation(line: 642, column: 63, scope: !1916)
!1941 = !DILocation(line: 642, column: 49, scope: !1916)
!1942 = !DILocation(line: 642, column: 41, scope: !1916)
!1943 = !DILocation(line: 642, column: 14, scope: !1916)
!1944 = !DILocation(line: 643, column: 23, scope: !1916)
!1945 = !DILocation(line: 643, column: 32, scope: !1916)
!1946 = !DILocation(line: 643, column: 30, scope: !1916)
!1947 = !DILocation(line: 643, column: 36, scope: !1916)
!1948 = !DILocation(line: 643, column: 48, scope: !1916)
!1949 = !DILocation(line: 643, column: 22, scope: !1916)
!1950 = !DILocation(line: 643, column: 14, scope: !1916)
!1951 = !DILocation(line: 647, column: 5, scope: !1764)
!1952 = !DILocalVariable(name: "C_sh", scope: !1764, file: !3, line: 648, type: !124)
!1953 = !DILocation(line: 648, column: 10, scope: !1764)
!1954 = !DILocalVariable(name: "C_pr", scope: !1764, file: !3, line: 648, type: !124)
!1955 = !DILocation(line: 648, column: 20, scope: !1764)
!1956 = !DILocalVariable(name: "ins", scope: !1957, file: !3, line: 650, type: !16)
!1957 = distinct !DILexicalBlock(scope: !1764, file: !3, line: 649, column: 5)
!1958 = !DILocation(line: 650, column: 13, scope: !1957)
!1959 = !DILocation(line: 650, column: 25, scope: !1957)
!1960 = !DILocation(line: 650, column: 23, scope: !1957)
!1961 = !DILocalVariable(name: "lkp", scope: !1957, file: !3, line: 650, type: !16)
!1962 = !DILocation(line: 650, column: 34, scope: !1957)
!1963 = !DILocation(line: 650, column: 47, scope: !1957)
!1964 = !DILocation(line: 650, column: 45, scope: !1957)
!1965 = !DILocation(line: 651, column: 22, scope: !1957)
!1966 = !DILocation(line: 651, column: 36, scope: !1957)
!1967 = !DILocation(line: 651, column: 40, scope: !1957)
!1968 = !DILocation(line: 651, column: 46, scope: !1957)
!1969 = !DILocation(line: 651, column: 50, scope: !1957)
!1970 = !DILocation(line: 651, column: 44, scope: !1957)
!1971 = !DILocation(line: 651, column: 35, scope: !1957)
!1972 = !DILocation(line: 651, column: 33, scope: !1957)
!1973 = !DILocation(line: 651, column: 14, scope: !1957)
!1974 = !DILocation(line: 652, column: 22, scope: !1957)
!1975 = !DILocation(line: 652, column: 35, scope: !1957)
!1976 = !DILocation(line: 652, column: 33, scope: !1957)
!1977 = !DILocation(line: 652, column: 39, scope: !1957)
!1978 = !DILocation(line: 652, column: 14, scope: !1957)
!1979 = !DILocation(line: 656, column: 5, scope: !1764)
!1980 = !DILocalVariable(name: "D_sh", scope: !1764, file: !3, line: 657, type: !124)
!1981 = !DILocation(line: 657, column: 10, scope: !1764)
!1982 = !DILocation(line: 657, column: 23, scope: !1764)
!1983 = !DILocation(line: 657, column: 34, scope: !1764)
!1984 = !DILocation(line: 657, column: 49, scope: !1764)
!1985 = !DILocation(line: 657, column: 47, scope: !1764)
!1986 = !DILocation(line: 657, column: 57, scope: !1764)
!1987 = !DILocalVariable(name: "D_pr", scope: !1764, file: !3, line: 658, type: !124)
!1988 = !DILocation(line: 658, column: 10, scope: !1764)
!1989 = !DILocation(line: 660, column: 19, scope: !1764)
!1990 = !DILocation(line: 660, column: 25, scope: !1764)
!1991 = !DILocation(line: 660, column: 31, scope: !1764)
!1992 = !DILocation(line: 660, column: 37, scope: !1764)
!1993 = !DILocation(line: 660, column: 43, scope: !1764)
!1994 = !DILocation(line: 660, column: 49, scope: !1764)
!1995 = !DILocation(line: 660, column: 55, scope: !1764)
!1996 = !DILocation(line: 660, column: 61, scope: !1764)
!1997 = !DILocation(line: 660, column: 5, scope: !1764)
!1998 = !DILocation(line: 661, column: 5, scope: !1764)
!1999 = distinct !DISubprogram(name: "max<int>", linkageName: "_ZSt3maxIiERKT_S2_S2_", scope: !15, file: !2000, line: 258, type: !2001, scopeLine: 259, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, templateParams: !338, retainedNodes: !1767)
!2000 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/stl_algobase.h", directory: "", checksumkind: CSK_MD5, checksum: "3c7b64acc2cfe4efdb8e6f4dd577e0b5")
!2001 = !DISubroutineType(types: !2002)
!2002 = !{!2003, !2003, !2003}
!2003 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !188, size: 64)
!2004 = !DILocalVariable(name: "__a", arg: 1, scope: !1999, file: !2005, line: 414, type: !2003)
!2005 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/algorithmfwd.h", directory: "", checksumkind: CSK_MD5, checksum: "5bf7a6fc5e70783cfa8d69bf57bbad03")
!2006 = !DILocation(line: 414, column: 19, scope: !1999)
!2007 = !DILocalVariable(name: "__b", arg: 2, scope: !1999, file: !2005, line: 414, type: !2003)
!2008 = !DILocation(line: 414, column: 31, scope: !1999)
!2009 = !DILocation(line: 263, column: 11, scope: !2010)
!2010 = distinct !DILexicalBlock(scope: !1999, file: !2000, line: 263, column: 11)
!2011 = !DILocation(line: 263, column: 17, scope: !2010)
!2012 = !DILocation(line: 263, column: 15, scope: !2010)
!2013 = !DILocation(line: 264, column: 9, scope: !2010)
!2014 = !DILocation(line: 264, column: 2, scope: !2010)
!2015 = !DILocation(line: 265, column: 14, scope: !1999)
!2016 = !DILocation(line: 265, column: 7, scope: !1999)
!2017 = !DILocation(line: 266, column: 5, scope: !1999)
!2018 = distinct !DISubprogram(name: "operator=", linkageName: "_ZNSt13__atomic_baseIlEaSEl", scope: !376, file: !104, line: 367, type: !413, scopeLine: 368, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, declaration: !412, retainedNodes: !1767)
!2019 = !DILocalVariable(name: "this", arg: 1, scope: !2018, type: !2020, flags: DIFlagArtificial | DIFlagObjectPointer)
!2020 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !376, size: 64)
!2021 = !DILocation(line: 0, scope: !2018)
!2022 = !DILocalVariable(name: "__i", arg: 2, scope: !2018, file: !104, line: 367, type: !380)
!2023 = !DILocation(line: 367, column: 28, scope: !2018)
!2024 = !DILocation(line: 369, column: 8, scope: !2018)
!2025 = !DILocalVariable(name: "this", arg: 1, scope: !2026, type: !2020, flags: DIFlagArtificial | DIFlagObjectPointer)
!2026 = distinct !DISubprogram(name: "store", linkageName: "_ZNSt13__atomic_baseIlE5storeElSt12memory_order", scope: !376, file: !104, line: 469, type: !451, scopeLine: 470, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, declaration: !450, retainedNodes: !1767)
!2027 = !DILocation(line: 0, scope: !2026, inlinedAt: !2028)
!2028 = distinct !DILocation(line: 369, column: 2, scope: !2018)
!2029 = !DILocalVariable(name: "__i", arg: 2, scope: !2026, file: !104, line: 469, type: !380)
!2030 = !DILocation(line: 469, column: 24, scope: !2026, inlinedAt: !2028)
!2031 = !DILocalVariable(name: "__m", arg: 3, scope: !2026, file: !104, line: 469, type: !103)
!2032 = !DILocation(line: 469, column: 42, scope: !2026, inlinedAt: !2028)
!2033 = !DILocalVariable(name: "__b", scope: !2026, file: !104, line: 471, type: !103)
!2034 = !DILocation(line: 471, column: 15, scope: !2026, inlinedAt: !2028)
!2035 = !DILocation(line: 472, column: 6, scope: !2026, inlinedAt: !2028)
!2036 = !DILocation(line: 472, column: 10, scope: !2026, inlinedAt: !2028)
!2037 = !DILocation(line: 473, column: 2, scope: !2038, inlinedAt: !2028)
!2038 = distinct !DILexicalBlock(scope: !2039, file: !104, line: 473, column: 2)
!2039 = distinct !DILexicalBlock(scope: !2026, file: !104, line: 473, column: 2)
!2040 = !DILocation(line: 474, column: 2, scope: !2041, inlinedAt: !2028)
!2041 = distinct !DILexicalBlock(scope: !2042, file: !104, line: 474, column: 2)
!2042 = distinct !DILexicalBlock(scope: !2026, file: !104, line: 474, column: 2)
!2043 = !DILocation(line: 475, column: 2, scope: !2044, inlinedAt: !2028)
!2044 = distinct !DILexicalBlock(scope: !2045, file: !104, line: 475, column: 2)
!2045 = distinct !DILexicalBlock(scope: !2026, file: !104, line: 475, column: 2)
!2046 = !DILocation(line: 477, column: 35, scope: !2026, inlinedAt: !2028)
!2047 = !DILocation(line: 477, column: 26, scope: !2026, inlinedAt: !2028)
!2048 = !DILocation(line: 477, column: 2, scope: !2026, inlinedAt: !2028)
!2049 = !DILocation(line: 370, column: 9, scope: !2018)
!2050 = !DILocation(line: 370, column: 2, scope: !2018)
!2051 = distinct !DISubprogram(name: "phaseA_worker", linkageName: "_ZL13phaseA_workerPv", scope: !3, file: !3, line: 123, type: !2052, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2052 = !DISubroutineType(types: !2053)
!2053 = !{!807, !807}
!2054 = !DILocalVariable(name: "arg", arg: 1, scope: !2051, file: !3, line: 123, type: !807)
!2055 = !DILocation(line: 123, column: 34, scope: !2051)
!2056 = !DILocalVariable(name: "a", scope: !2051, file: !3, line: 124, type: !119)
!2057 = !DILocation(line: 124, column: 18, scope: !2051)
!2058 = !DILocation(line: 124, column: 37, scope: !2051)
!2059 = !DILocalVariable(name: "n", scope: !2051, file: !3, line: 125, type: !188)
!2060 = !DILocation(line: 125, column: 15, scope: !2051)
!2061 = !DILocation(line: 125, column: 27, scope: !2051)
!2062 = !DILocation(line: 125, column: 25, scope: !2051)
!2063 = !DILocalVariable(name: "A", scope: !2051, file: !3, line: 128, type: !130)
!2064 = !DILocation(line: 128, column: 12, scope: !2051)
!2065 = !DILocation(line: 128, column: 32, scope: !2051)
!2066 = !DILocation(line: 128, column: 34, scope: !2051)
!2067 = !DILocation(line: 128, column: 33, scope: !2051)
!2068 = !DILocation(line: 128, column: 25, scope: !2051)
!2069 = !DILocalVariable(name: "B", scope: !2051, file: !3, line: 129, type: !130)
!2070 = !DILocation(line: 129, column: 12, scope: !2051)
!2071 = !DILocation(line: 129, column: 32, scope: !2051)
!2072 = !DILocation(line: 129, column: 34, scope: !2051)
!2073 = !DILocation(line: 129, column: 33, scope: !2051)
!2074 = !DILocation(line: 129, column: 25, scope: !2051)
!2075 = !DILocalVariable(name: "C", scope: !2051, file: !3, line: 130, type: !130)
!2076 = !DILocation(line: 130, column: 12, scope: !2051)
!2077 = !DILocation(line: 130, column: 32, scope: !2051)
!2078 = !DILocation(line: 130, column: 34, scope: !2051)
!2079 = !DILocation(line: 130, column: 33, scope: !2051)
!2080 = !DILocation(line: 130, column: 25, scope: !2051)
!2081 = !DILocalVariable(name: "i", scope: !2082, file: !3, line: 133, type: !16)
!2082 = distinct !DILexicalBlock(scope: !2051, file: !3, line: 133, column: 5)
!2083 = !DILocation(line: 133, column: 14, scope: !2082)
!2084 = !DILocation(line: 133, column: 10, scope: !2082)
!2085 = !DILocation(line: 133, column: 21, scope: !2086)
!2086 = distinct !DILexicalBlock(scope: !2082, file: !3, line: 133, column: 5)
!2087 = !DILocation(line: 133, column: 25, scope: !2086)
!2088 = !DILocation(line: 133, column: 27, scope: !2086)
!2089 = !DILocation(line: 133, column: 26, scope: !2086)
!2090 = !DILocation(line: 133, column: 23, scope: !2086)
!2091 = !DILocation(line: 133, column: 5, scope: !2082)
!2092 = !DILocation(line: 134, column: 24, scope: !2093)
!2093 = distinct !DILexicalBlock(scope: !2086, file: !3, line: 133, column: 35)
!2094 = !DILocation(line: 134, column: 26, scope: !2093)
!2095 = !DILocation(line: 134, column: 23, scope: !2093)
!2096 = !DILocation(line: 134, column: 32, scope: !2093)
!2097 = !DILocation(line: 134, column: 9, scope: !2093)
!2098 = !DILocation(line: 134, column: 11, scope: !2093)
!2099 = !DILocation(line: 134, column: 14, scope: !2093)
!2100 = !DILocation(line: 135, column: 24, scope: !2093)
!2101 = !DILocation(line: 135, column: 26, scope: !2093)
!2102 = !DILocation(line: 135, column: 23, scope: !2093)
!2103 = !DILocation(line: 135, column: 32, scope: !2093)
!2104 = !DILocation(line: 135, column: 9, scope: !2093)
!2105 = !DILocation(line: 135, column: 11, scope: !2093)
!2106 = !DILocation(line: 135, column: 14, scope: !2093)
!2107 = !DILocation(line: 136, column: 5, scope: !2093)
!2108 = !DILocation(line: 133, column: 31, scope: !2086)
!2109 = !DILocation(line: 133, column: 5, scope: !2086)
!2110 = distinct !{!2110, !2091, !2111, !1844}
!2111 = !DILocation(line: 136, column: 5, scope: !2082)
!2112 = !DILocation(line: 139, column: 12, scope: !2051)
!2113 = !DILocation(line: 139, column: 15, scope: !2051)
!2114 = !DILocation(line: 139, column: 18, scope: !2051)
!2115 = !DILocation(line: 139, column: 21, scope: !2051)
!2116 = !DILocation(line: 139, column: 5, scope: !2051)
!2117 = !DILocalVariable(name: "local_sum", scope: !2051, file: !3, line: 142, type: !131)
!2118 = !DILocation(line: 142, column: 11, scope: !2051)
!2119 = !DILocalVariable(name: "i", scope: !2120, file: !3, line: 143, type: !16)
!2120 = distinct !DILexicalBlock(scope: !2051, file: !3, line: 143, column: 5)
!2121 = !DILocation(line: 143, column: 14, scope: !2120)
!2122 = !DILocation(line: 143, column: 10, scope: !2120)
!2123 = !DILocation(line: 143, column: 21, scope: !2124)
!2124 = distinct !DILexicalBlock(scope: !2120, file: !3, line: 143, column: 5)
!2125 = !DILocation(line: 143, column: 25, scope: !2124)
!2126 = !DILocation(line: 143, column: 27, scope: !2124)
!2127 = !DILocation(line: 143, column: 26, scope: !2124)
!2128 = !DILocation(line: 143, column: 23, scope: !2124)
!2129 = !DILocation(line: 143, column: 5, scope: !2120)
!2130 = !DILocation(line: 143, column: 48, scope: !2124)
!2131 = !DILocation(line: 143, column: 50, scope: !2124)
!2132 = !DILocation(line: 143, column: 45, scope: !2124)
!2133 = !DILocation(line: 143, column: 35, scope: !2124)
!2134 = !DILocation(line: 143, column: 31, scope: !2124)
!2135 = !DILocation(line: 143, column: 5, scope: !2124)
!2136 = distinct !{!2136, !2129, !2137, !1844}
!2137 = !DILocation(line: 143, column: 51, scope: !2120)
!2138 = !DILocation(line: 144, column: 33, scope: !2051)
!2139 = !DILocation(line: 144, column: 43, scope: !2051)
!2140 = !DILocation(line: 144, column: 32, scope: !2051)
!2141 = !DILocalVariable(name: "this", arg: 1, scope: !2142, type: !2020, flags: DIFlagArtificial | DIFlagObjectPointer)
!2142 = distinct !DISubprogram(name: "fetch_add", linkageName: "_ZNSt13__atomic_baseIlE9fetch_addElSt12memory_order", scope: !376, file: !104, line: 629, type: !463, scopeLine: 631, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, declaration: !490, retainedNodes: !1767)
!2143 = !DILocation(line: 0, scope: !2142, inlinedAt: !2144)
!2144 = distinct !DILocation(line: 144, column: 16, scope: !2051)
!2145 = !DILocalVariable(name: "__i", arg: 2, scope: !2142, file: !104, line: 629, type: !380)
!2146 = !DILocation(line: 629, column: 28, scope: !2142, inlinedAt: !2144)
!2147 = !DILocalVariable(name: "__m", arg: 3, scope: !2142, file: !104, line: 630, type: !103)
!2148 = !DILocation(line: 630, column: 16, scope: !2142, inlinedAt: !2144)
!2149 = !DILocation(line: 631, column: 51, scope: !2142, inlinedAt: !2144)
!2150 = !DILocation(line: 631, column: 42, scope: !2142, inlinedAt: !2144)
!2151 = !DILocation(line: 631, column: 16, scope: !2142, inlinedAt: !2144)
!2152 = !DILocation(line: 146, column: 33, scope: !2051)
!2153 = !DILocation(line: 146, column: 35, scope: !2051)
!2154 = !DILocation(line: 146, column: 34, scope: !2051)
!2155 = !DILocation(line: 146, column: 37, scope: !2051)
!2156 = !DILocation(line: 146, column: 36, scope: !2051)
!2157 = !DILocation(line: 146, column: 39, scope: !2051)
!2158 = !DILocation(line: 146, column: 51, scope: !2051)
!2159 = !DILocation(line: 146, column: 53, scope: !2051)
!2160 = !DILocation(line: 146, column: 52, scope: !2051)
!2161 = !DILocation(line: 146, column: 54, scope: !2051)
!2162 = !DILocation(line: 146, column: 43, scope: !2051)
!2163 = !DILocation(line: 146, column: 5, scope: !2051)
!2164 = !DILocation(line: 146, column: 8, scope: !2051)
!2165 = !DILocation(line: 146, column: 25, scope: !2051)
!2166 = !DILocation(line: 147, column: 5, scope: !2051)
!2167 = !DILocation(line: 147, column: 8, scope: !2051)
!2168 = !DILocation(line: 147, column: 25, scope: !2051)
!2169 = !DILocation(line: 149, column: 10, scope: !2051)
!2170 = !DILocation(line: 149, column: 5, scope: !2051)
!2171 = !DILocation(line: 149, column: 19, scope: !2051)
!2172 = !DILocation(line: 149, column: 14, scope: !2051)
!2173 = !DILocation(line: 149, column: 28, scope: !2051)
!2174 = !DILocation(line: 149, column: 23, scope: !2051)
!2175 = !DILocation(line: 150, column: 5, scope: !2051)
!2176 = distinct !DISubprogram(name: "run_phase_B", linkageName: "_ZL11run_phase_Bv", scope: !3, file: !3, line: 283, type: !801, scopeLine: 283, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2177 = !DILocalVariable(name: "n_prod", scope: !2176, file: !3, line: 284, type: !188)
!2178 = !DILocation(line: 284, column: 15, scope: !2176)
!2179 = !DILocation(line: 284, column: 24, scope: !2176)
!2180 = !DILocation(line: 284, column: 35, scope: !2176)
!2181 = !DILocation(line: 284, column: 39, scope: !2176)
!2182 = !DILocation(line: 284, column: 45, scope: !2176)
!2183 = !DILocation(line: 284, column: 56, scope: !2176)
!2184 = !DILocalVariable(name: "n_cons", scope: !2176, file: !3, line: 285, type: !188)
!2185 = !DILocation(line: 285, column: 15, scope: !2176)
!2186 = !DILocation(line: 285, column: 24, scope: !2176)
!2187 = !DILocation(line: 285, column: 37, scope: !2176)
!2188 = !DILocation(line: 285, column: 35, scope: !2176)
!2189 = !DILocalVariable(name: "items_per_producer", scope: !2176, file: !3, line: 286, type: !188)
!2190 = !DILocation(line: 286, column: 15, scope: !2176)
!2191 = !DILocation(line: 286, column: 43, scope: !2176)
!2192 = !DILocation(line: 286, column: 41, scope: !2176)
!2193 = !DILocation(line: 289, column: 12, scope: !2176)
!2194 = !DILocation(line: 289, column: 20, scope: !2176)
!2195 = !DILocation(line: 289, column: 28, scope: !2176)
!2196 = !DILocation(line: 288, column: 5, scope: !2176)
!2197 = !DILocation(line: 291, column: 28, scope: !2176)
!2198 = !DILocation(line: 291, column: 13, scope: !2176)
!2199 = !DILocation(line: 292, column: 25, scope: !2176)
!2200 = !DILocation(line: 292, column: 34, scope: !2176)
!2201 = !DILocation(line: 292, column: 5, scope: !2176)
!2202 = !DILocation(line: 293, column: 16, scope: !2176)
!2203 = !DILocalVariable(name: "pargs", scope: !2176, file: !3, line: 295, type: !340)
!2204 = !DILocation(line: 295, column: 26, scope: !2176)
!2205 = !DILocation(line: 295, column: 64, scope: !2176)
!2206 = !DILocation(line: 295, column: 57, scope: !2176)
!2207 = !DILocalVariable(name: "cargs", scope: !2176, file: !3, line: 296, type: !346)
!2208 = !DILocation(line: 296, column: 26, scope: !2176)
!2209 = !DILocation(line: 296, column: 64, scope: !2176)
!2210 = !DILocation(line: 296, column: 57, scope: !2176)
!2211 = !DILocalVariable(name: "prod_t", scope: !2176, file: !3, line: 297, type: !126)
!2212 = !DILocation(line: 297, column: 16, scope: !2176)
!2213 = !DILocation(line: 297, column: 45, scope: !2176)
!2214 = !DILocation(line: 297, column: 52, scope: !2176)
!2215 = !DILocation(line: 297, column: 38, scope: !2176)
!2216 = !DILocalVariable(name: "cons_t", scope: !2176, file: !3, line: 298, type: !126)
!2217 = !DILocation(line: 298, column: 16, scope: !2176)
!2218 = !DILocation(line: 298, column: 45, scope: !2176)
!2219 = !DILocation(line: 298, column: 52, scope: !2176)
!2220 = !DILocation(line: 298, column: 38, scope: !2176)
!2221 = !DILocalVariable(name: "t0", scope: !2176, file: !3, line: 300, type: !374)
!2222 = !DILocation(line: 300, column: 12, scope: !2176)
!2223 = !DILocation(line: 300, column: 17, scope: !2176)
!2224 = !DILocalVariable(name: "i", scope: !2225, file: !3, line: 301, type: !16)
!2225 = distinct !DILexicalBlock(scope: !2176, file: !3, line: 301, column: 5)
!2226 = !DILocation(line: 301, column: 14, scope: !2225)
!2227 = !DILocation(line: 301, column: 10, scope: !2225)
!2228 = !DILocation(line: 301, column: 21, scope: !2229)
!2229 = distinct !DILexicalBlock(scope: !2225, file: !3, line: 301, column: 5)
!2230 = !DILocation(line: 301, column: 25, scope: !2229)
!2231 = !DILocation(line: 301, column: 23, scope: !2229)
!2232 = !DILocation(line: 301, column: 5, scope: !2225)
!2233 = !DILocation(line: 302, column: 23, scope: !2234)
!2234 = distinct !DILexicalBlock(scope: !2229, file: !3, line: 301, column: 38)
!2235 = !DILocation(line: 302, column: 9, scope: !2234)
!2236 = !DILocation(line: 302, column: 15, scope: !2234)
!2237 = !DILocation(line: 302, column: 18, scope: !2234)
!2238 = !DILocation(line: 302, column: 21, scope: !2234)
!2239 = !DILocation(line: 303, column: 25, scope: !2234)
!2240 = !DILocation(line: 303, column: 32, scope: !2234)
!2241 = !DILocation(line: 303, column: 63, scope: !2234)
!2242 = !DILocation(line: 303, column: 69, scope: !2234)
!2243 = !DILocation(line: 303, column: 9, scope: !2234)
!2244 = !DILocation(line: 304, column: 5, scope: !2234)
!2245 = !DILocation(line: 301, column: 34, scope: !2229)
!2246 = !DILocation(line: 301, column: 5, scope: !2229)
!2247 = distinct !{!2247, !2232, !2248, !1844}
!2248 = !DILocation(line: 304, column: 5, scope: !2225)
!2249 = !DILocalVariable(name: "i", scope: !2250, file: !3, line: 305, type: !16)
!2250 = distinct !DILexicalBlock(scope: !2176, file: !3, line: 305, column: 5)
!2251 = !DILocation(line: 305, column: 14, scope: !2250)
!2252 = !DILocation(line: 305, column: 10, scope: !2250)
!2253 = !DILocation(line: 305, column: 21, scope: !2254)
!2254 = distinct !DILexicalBlock(scope: !2250, file: !3, line: 305, column: 5)
!2255 = !DILocation(line: 305, column: 25, scope: !2254)
!2256 = !DILocation(line: 305, column: 23, scope: !2254)
!2257 = !DILocation(line: 305, column: 5, scope: !2250)
!2258 = !DILocation(line: 306, column: 23, scope: !2259)
!2259 = distinct !DILexicalBlock(scope: !2254, file: !3, line: 305, column: 38)
!2260 = !DILocation(line: 306, column: 9, scope: !2259)
!2261 = !DILocation(line: 306, column: 15, scope: !2259)
!2262 = !DILocation(line: 306, column: 18, scope: !2259)
!2263 = !DILocation(line: 306, column: 21, scope: !2259)
!2264 = !DILocation(line: 307, column: 37, scope: !2259)
!2265 = !DILocation(line: 307, column: 9, scope: !2259)
!2266 = !DILocation(line: 307, column: 15, scope: !2259)
!2267 = !DILocation(line: 307, column: 18, scope: !2259)
!2268 = !DILocation(line: 307, column: 35, scope: !2259)
!2269 = !DILocation(line: 308, column: 25, scope: !2259)
!2270 = !DILocation(line: 308, column: 32, scope: !2259)
!2271 = !DILocation(line: 308, column: 63, scope: !2259)
!2272 = !DILocation(line: 308, column: 69, scope: !2259)
!2273 = !DILocation(line: 308, column: 9, scope: !2259)
!2274 = !DILocation(line: 309, column: 5, scope: !2259)
!2275 = !DILocation(line: 305, column: 34, scope: !2254)
!2276 = !DILocation(line: 305, column: 5, scope: !2254)
!2277 = distinct !{!2277, !2257, !2278, !1844}
!2278 = !DILocation(line: 309, column: 5, scope: !2250)
!2279 = !DILocalVariable(name: "i", scope: !2280, file: !3, line: 310, type: !16)
!2280 = distinct !DILexicalBlock(scope: !2176, file: !3, line: 310, column: 5)
!2281 = !DILocation(line: 310, column: 14, scope: !2280)
!2282 = !DILocation(line: 310, column: 10, scope: !2280)
!2283 = !DILocation(line: 310, column: 21, scope: !2284)
!2284 = distinct !DILexicalBlock(scope: !2280, file: !3, line: 310, column: 5)
!2285 = !DILocation(line: 310, column: 25, scope: !2284)
!2286 = !DILocation(line: 310, column: 23, scope: !2284)
!2287 = !DILocation(line: 310, column: 5, scope: !2280)
!2288 = !DILocation(line: 310, column: 51, scope: !2284)
!2289 = !DILocation(line: 310, column: 58, scope: !2284)
!2290 = !DILocation(line: 310, column: 38, scope: !2284)
!2291 = !DILocation(line: 310, column: 34, scope: !2284)
!2292 = !DILocation(line: 310, column: 5, scope: !2284)
!2293 = distinct !{!2293, !2287, !2294, !1844}
!2294 = !DILocation(line: 310, column: 69, scope: !2280)
!2295 = !DILocation(line: 311, column: 5, scope: !2176)
!2296 = !DILocation(line: 311, column: 14, scope: !2176)
!2297 = !DILocalVariable(name: "this", arg: 1, scope: !2298, type: !2299, flags: DIFlagArtificial | DIFlagObjectPointer)
!2298 = distinct !DISubprogram(name: "store", linkageName: "_ZNSt13__atomic_baseIiE5storeEiSt12memory_order", scope: !185, file: !104, line: 469, type: !262, scopeLine: 470, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, declaration: !261, retainedNodes: !1767)
!2299 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 64)
!2300 = !DILocation(line: 0, scope: !2298, inlinedAt: !2301)
!2301 = distinct !DILocation(line: 311, column: 29, scope: !2176)
!2302 = !DILocalVariable(name: "__i", arg: 2, scope: !2298, file: !104, line: 469, type: !190)
!2303 = !DILocation(line: 469, column: 24, scope: !2298, inlinedAt: !2301)
!2304 = !DILocalVariable(name: "__m", arg: 3, scope: !2298, file: !104, line: 469, type: !103)
!2305 = !DILocation(line: 469, column: 42, scope: !2298, inlinedAt: !2301)
!2306 = !DILocalVariable(name: "__b", scope: !2298, file: !104, line: 471, type: !103)
!2307 = !DILocation(line: 471, column: 15, scope: !2298, inlinedAt: !2301)
!2308 = !DILocation(line: 472, column: 6, scope: !2298, inlinedAt: !2301)
!2309 = !DILocation(line: 472, column: 10, scope: !2298, inlinedAt: !2301)
!2310 = !DILocation(line: 473, column: 2, scope: !2311, inlinedAt: !2301)
!2311 = distinct !DILexicalBlock(scope: !2312, file: !104, line: 473, column: 2)
!2312 = distinct !DILexicalBlock(scope: !2298, file: !104, line: 473, column: 2)
!2313 = !DILocation(line: 474, column: 2, scope: !2314, inlinedAt: !2301)
!2314 = distinct !DILexicalBlock(scope: !2315, file: !104, line: 474, column: 2)
!2315 = distinct !DILexicalBlock(scope: !2298, file: !104, line: 474, column: 2)
!2316 = !DILocation(line: 475, column: 2, scope: !2317, inlinedAt: !2301)
!2317 = distinct !DILexicalBlock(scope: !2318, file: !104, line: 475, column: 2)
!2318 = distinct !DILexicalBlock(scope: !2298, file: !104, line: 475, column: 2)
!2319 = !DILocation(line: 477, column: 35, scope: !2298, inlinedAt: !2301)
!2320 = !DILocation(line: 477, column: 26, scope: !2298, inlinedAt: !2301)
!2321 = !DILocation(line: 477, column: 2, scope: !2298, inlinedAt: !2301)
!2322 = !DILocalVariable(name: "i", scope: !2323, file: !3, line: 312, type: !16)
!2323 = distinct !DILexicalBlock(scope: !2176, file: !3, line: 312, column: 5)
!2324 = !DILocation(line: 312, column: 14, scope: !2323)
!2325 = !DILocation(line: 312, column: 10, scope: !2323)
!2326 = !DILocation(line: 312, column: 21, scope: !2327)
!2327 = distinct !DILexicalBlock(scope: !2323, file: !3, line: 312, column: 5)
!2328 = !DILocation(line: 312, column: 25, scope: !2327)
!2329 = !DILocation(line: 312, column: 23, scope: !2327)
!2330 = !DILocation(line: 312, column: 5, scope: !2323)
!2331 = !DILocation(line: 312, column: 51, scope: !2327)
!2332 = !DILocation(line: 312, column: 58, scope: !2327)
!2333 = !DILocation(line: 312, column: 38, scope: !2327)
!2334 = !DILocation(line: 312, column: 34, scope: !2327)
!2335 = !DILocation(line: 312, column: 5, scope: !2327)
!2336 = distinct !{!2336, !2330, !2337, !1844}
!2337 = !DILocation(line: 312, column: 69, scope: !2323)
!2338 = !DILocalVariable(name: "elapsed", scope: !2176, file: !3, line: 313, type: !374)
!2339 = !DILocation(line: 313, column: 12, scope: !2176)
!2340 = !DILocation(line: 313, column: 22, scope: !2176)
!2341 = !DILocation(line: 313, column: 33, scope: !2176)
!2342 = !DILocation(line: 313, column: 31, scope: !2176)
!2343 = !DILocalVariable(name: "total_private", scope: !2176, file: !3, line: 315, type: !124)
!2344 = !DILocation(line: 315, column: 10, scope: !2176)
!2345 = !DILocalVariable(name: "total_shared", scope: !2176, file: !3, line: 315, type: !124)
!2346 = !DILocation(line: 315, column: 29, scope: !2176)
!2347 = !DILocalVariable(name: "i", scope: !2348, file: !3, line: 316, type: !16)
!2348 = distinct !DILexicalBlock(scope: !2176, file: !3, line: 316, column: 5)
!2349 = !DILocation(line: 316, column: 14, scope: !2348)
!2350 = !DILocation(line: 316, column: 10, scope: !2348)
!2351 = !DILocation(line: 316, column: 21, scope: !2352)
!2352 = distinct !DILexicalBlock(scope: !2348, file: !3, line: 316, column: 5)
!2353 = !DILocation(line: 316, column: 25, scope: !2352)
!2354 = !DILocation(line: 316, column: 23, scope: !2352)
!2355 = !DILocation(line: 316, column: 5, scope: !2348)
!2356 = !DILocation(line: 316, column: 55, scope: !2352)
!2357 = !DILocation(line: 316, column: 61, scope: !2352)
!2358 = !DILocation(line: 316, column: 64, scope: !2352)
!2359 = !DILocation(line: 316, column: 52, scope: !2352)
!2360 = !DILocation(line: 316, column: 38, scope: !2352)
!2361 = !DILocation(line: 316, column: 34, scope: !2352)
!2362 = !DILocation(line: 316, column: 5, scope: !2352)
!2363 = distinct !{!2363, !2355, !2364, !1844}
!2364 = !DILocation(line: 316, column: 64, scope: !2348)
!2365 = !DILocalVariable(name: "i", scope: !2366, file: !3, line: 317, type: !16)
!2366 = distinct !DILexicalBlock(scope: !2176, file: !3, line: 317, column: 5)
!2367 = !DILocation(line: 317, column: 14, scope: !2366)
!2368 = !DILocation(line: 317, column: 10, scope: !2366)
!2369 = !DILocation(line: 317, column: 21, scope: !2370)
!2370 = distinct !DILexicalBlock(scope: !2366, file: !3, line: 317, column: 5)
!2371 = !DILocation(line: 317, column: 25, scope: !2370)
!2372 = !DILocation(line: 317, column: 23, scope: !2370)
!2373 = !DILocation(line: 317, column: 5, scope: !2366)
!2374 = !DILocation(line: 318, column: 26, scope: !2375)
!2375 = distinct !DILexicalBlock(scope: !2370, file: !3, line: 317, column: 38)
!2376 = !DILocation(line: 318, column: 32, scope: !2375)
!2377 = !DILocation(line: 318, column: 35, scope: !2375)
!2378 = !DILocation(line: 318, column: 23, scope: !2375)
!2379 = !DILocation(line: 319, column: 26, scope: !2375)
!2380 = !DILocation(line: 319, column: 32, scope: !2375)
!2381 = !DILocation(line: 319, column: 35, scope: !2375)
!2382 = !DILocation(line: 319, column: 23, scope: !2375)
!2383 = !DILocation(line: 320, column: 5, scope: !2375)
!2384 = !DILocation(line: 317, column: 34, scope: !2370)
!2385 = !DILocation(line: 317, column: 5, scope: !2370)
!2386 = distinct !{!2386, !2373, !2387, !1844}
!2387 = !DILocation(line: 320, column: 5, scope: !2366)
!2388 = !DILocalVariable(name: "total", scope: !2176, file: !3, line: 321, type: !124)
!2389 = !DILocation(line: 321, column: 10, scope: !2176)
!2390 = !DILocation(line: 321, column: 18, scope: !2176)
!2391 = !DILocation(line: 321, column: 34, scope: !2176)
!2392 = !DILocation(line: 321, column: 32, scope: !2176)
!2393 = !DILocation(line: 322, column: 44, scope: !2176)
!2394 = !DILocation(line: 322, column: 5, scope: !2176)
!2395 = !DILocation(line: 323, column: 52, scope: !2176)
!2396 = !DILocation(line: 323, column: 73, scope: !2176)
!2397 = !DILocation(line: 323, column: 72, scope: !2176)
!2398 = !DILocation(line: 323, column: 87, scope: !2176)
!2399 = !DILocation(line: 323, column: 86, scope: !2176)
!2400 = !DILocation(line: 323, column: 5, scope: !2176)
!2401 = !DILocation(line: 324, column: 52, scope: !2176)
!2402 = !DILocation(line: 324, column: 73, scope: !2176)
!2403 = !DILocation(line: 324, column: 72, scope: !2176)
!2404 = !DILocation(line: 324, column: 86, scope: !2176)
!2405 = !DILocation(line: 324, column: 85, scope: !2176)
!2406 = !DILocation(line: 324, column: 5, scope: !2176)
!2407 = !DILocation(line: 326, column: 12, scope: !2176)
!2408 = !DILocation(line: 326, column: 24, scope: !2176)
!2409 = !DILocation(line: 326, column: 33, scope: !2176)
!2410 = !DILocation(line: 326, column: 42, scope: !2176)
!2411 = !DILocation(line: 326, column: 56, scope: !2176)
!2412 = !DILocation(line: 325, column: 5, scope: !2176)
!2413 = !DILocation(line: 328, column: 28, scope: !2176)
!2414 = !DILocation(line: 328, column: 37, scope: !2176)
!2415 = !DILocation(line: 328, column: 5, scope: !2176)
!2416 = !DILocation(line: 329, column: 10, scope: !2176)
!2417 = !DILocation(line: 329, column: 5, scope: !2176)
!2418 = !DILocation(line: 329, column: 25, scope: !2176)
!2419 = !DILocation(line: 329, column: 20, scope: !2176)
!2420 = !DILocation(line: 329, column: 38, scope: !2176)
!2421 = !DILocation(line: 329, column: 33, scope: !2176)
!2422 = !DILocation(line: 329, column: 51, scope: !2176)
!2423 = !DILocation(line: 329, column: 46, scope: !2176)
!2424 = !DILocation(line: 329, column: 65, scope: !2176)
!2425 = !DILocation(line: 329, column: 60, scope: !2176)
!2426 = !DILocation(line: 330, column: 1, scope: !2176)
!2427 = distinct !DISubprogram(name: "run_phase_C", linkageName: "_ZL11run_phase_Cv", scope: !3, file: !3, line: 419, type: !801, scopeLine: 419, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2428 = !DILocalVariable(name: "n_inserts", scope: !2427, file: !3, line: 420, type: !188)
!2429 = !DILocation(line: 420, column: 15, scope: !2427)
!2430 = !DILocation(line: 420, column: 34, scope: !2427)
!2431 = !DILocation(line: 420, column: 32, scope: !2427)
!2432 = !DILocalVariable(name: "n_lookups", scope: !2427, file: !3, line: 421, type: !188)
!2433 = !DILocation(line: 421, column: 15, scope: !2427)
!2434 = !DILocation(line: 421, column: 34, scope: !2427)
!2435 = !DILocation(line: 421, column: 32, scope: !2427)
!2436 = !DILocation(line: 424, column: 12, scope: !2427)
!2437 = !DILocation(line: 424, column: 24, scope: !2427)
!2438 = !DILocation(line: 424, column: 35, scope: !2427)
!2439 = !DILocation(line: 423, column: 5, scope: !2427)
!2440 = !DILocation(line: 426, column: 17, scope: !2427)
!2441 = !DILocation(line: 427, column: 5, scope: !2427)
!2442 = !DILocation(line: 428, column: 16, scope: !2427)
!2443 = !DILocalVariable(name: "args", scope: !2427, file: !3, line: 430, type: !354)
!2444 = !DILocation(line: 430, column: 18, scope: !2427)
!2445 = !DILocation(line: 430, column: 47, scope: !2427)
!2446 = !DILocation(line: 430, column: 40, scope: !2427)
!2447 = !DILocalVariable(name: "threads", scope: !2427, file: !3, line: 431, type: !126)
!2448 = !DILocation(line: 431, column: 16, scope: !2427)
!2449 = !DILocation(line: 431, column: 46, scope: !2427)
!2450 = !DILocation(line: 431, column: 57, scope: !2427)
!2451 = !DILocation(line: 431, column: 39, scope: !2427)
!2452 = !DILocalVariable(name: "t0", scope: !2427, file: !3, line: 433, type: !374)
!2453 = !DILocation(line: 433, column: 12, scope: !2427)
!2454 = !DILocation(line: 433, column: 17, scope: !2427)
!2455 = !DILocalVariable(name: "i", scope: !2456, file: !3, line: 434, type: !16)
!2456 = distinct !DILexicalBlock(scope: !2427, file: !3, line: 434, column: 5)
!2457 = !DILocation(line: 434, column: 14, scope: !2456)
!2458 = !DILocation(line: 434, column: 10, scope: !2456)
!2459 = !DILocation(line: 434, column: 21, scope: !2460)
!2460 = distinct !DILexicalBlock(scope: !2456, file: !3, line: 434, column: 5)
!2461 = !DILocation(line: 434, column: 25, scope: !2460)
!2462 = !DILocation(line: 434, column: 23, scope: !2460)
!2463 = !DILocation(line: 434, column: 5, scope: !2456)
!2464 = !DILocation(line: 435, column: 22, scope: !2465)
!2465 = distinct !DILexicalBlock(scope: !2460, file: !3, line: 434, column: 42)
!2466 = !DILocation(line: 435, column: 9, scope: !2465)
!2467 = !DILocation(line: 435, column: 14, scope: !2465)
!2468 = !DILocation(line: 435, column: 17, scope: !2465)
!2469 = !DILocation(line: 435, column: 20, scope: !2465)
!2470 = !DILocation(line: 436, column: 29, scope: !2465)
!2471 = !DILocation(line: 436, column: 9, scope: !2465)
!2472 = !DILocation(line: 436, column: 14, scope: !2465)
!2473 = !DILocation(line: 436, column: 17, scope: !2465)
!2474 = !DILocation(line: 436, column: 27, scope: !2465)
!2475 = !DILocation(line: 437, column: 29, scope: !2465)
!2476 = !DILocation(line: 437, column: 9, scope: !2465)
!2477 = !DILocation(line: 437, column: 14, scope: !2465)
!2478 = !DILocation(line: 437, column: 17, scope: !2465)
!2479 = !DILocation(line: 437, column: 27, scope: !2465)
!2480 = !DILocation(line: 438, column: 25, scope: !2465)
!2481 = !DILocation(line: 438, column: 33, scope: !2465)
!2482 = !DILocation(line: 438, column: 62, scope: !2465)
!2483 = !DILocation(line: 438, column: 67, scope: !2465)
!2484 = !DILocation(line: 438, column: 9, scope: !2465)
!2485 = !DILocation(line: 439, column: 5, scope: !2465)
!2486 = !DILocation(line: 434, column: 38, scope: !2460)
!2487 = !DILocation(line: 434, column: 5, scope: !2460)
!2488 = distinct !{!2488, !2463, !2489, !1844}
!2489 = !DILocation(line: 439, column: 5, scope: !2456)
!2490 = !DILocalVariable(name: "i", scope: !2491, file: !3, line: 440, type: !16)
!2491 = distinct !DILexicalBlock(scope: !2427, file: !3, line: 440, column: 5)
!2492 = !DILocation(line: 440, column: 14, scope: !2491)
!2493 = !DILocation(line: 440, column: 10, scope: !2491)
!2494 = !DILocation(line: 440, column: 21, scope: !2495)
!2495 = distinct !DILexicalBlock(scope: !2491, file: !3, line: 440, column: 5)
!2496 = !DILocation(line: 440, column: 25, scope: !2495)
!2497 = !DILocation(line: 440, column: 23, scope: !2495)
!2498 = !DILocation(line: 440, column: 5, scope: !2491)
!2499 = !DILocation(line: 440, column: 55, scope: !2495)
!2500 = !DILocation(line: 440, column: 63, scope: !2495)
!2501 = !DILocation(line: 440, column: 42, scope: !2495)
!2502 = !DILocation(line: 440, column: 38, scope: !2495)
!2503 = !DILocation(line: 440, column: 5, scope: !2495)
!2504 = distinct !{!2504, !2498, !2505, !1844}
!2505 = !DILocation(line: 440, column: 74, scope: !2491)
!2506 = !DILocalVariable(name: "elapsed", scope: !2427, file: !3, line: 441, type: !374)
!2507 = !DILocation(line: 441, column: 12, scope: !2427)
!2508 = !DILocation(line: 441, column: 22, scope: !2427)
!2509 = !DILocation(line: 441, column: 33, scope: !2427)
!2510 = !DILocation(line: 441, column: 31, scope: !2427)
!2511 = !DILocalVariable(name: "total_private", scope: !2427, file: !3, line: 443, type: !124)
!2512 = !DILocation(line: 443, column: 10, scope: !2427)
!2513 = !DILocalVariable(name: "total_shared", scope: !2427, file: !3, line: 443, type: !124)
!2514 = !DILocation(line: 443, column: 29, scope: !2427)
!2515 = !DILocalVariable(name: "i", scope: !2516, file: !3, line: 444, type: !16)
!2516 = distinct !DILexicalBlock(scope: !2427, file: !3, line: 444, column: 5)
!2517 = !DILocation(line: 444, column: 14, scope: !2516)
!2518 = !DILocation(line: 444, column: 10, scope: !2516)
!2519 = !DILocation(line: 444, column: 21, scope: !2520)
!2520 = distinct !DILexicalBlock(scope: !2516, file: !3, line: 444, column: 5)
!2521 = !DILocation(line: 444, column: 25, scope: !2520)
!2522 = !DILocation(line: 444, column: 23, scope: !2520)
!2523 = !DILocation(line: 444, column: 5, scope: !2516)
!2524 = !DILocation(line: 445, column: 26, scope: !2525)
!2525 = distinct !DILexicalBlock(scope: !2520, file: !3, line: 444, column: 42)
!2526 = !DILocation(line: 445, column: 31, scope: !2525)
!2527 = !DILocation(line: 445, column: 34, scope: !2525)
!2528 = !DILocation(line: 445, column: 23, scope: !2525)
!2529 = !DILocation(line: 446, column: 26, scope: !2525)
!2530 = !DILocation(line: 446, column: 31, scope: !2525)
!2531 = !DILocation(line: 446, column: 34, scope: !2525)
!2532 = !DILocation(line: 446, column: 23, scope: !2525)
!2533 = !DILocation(line: 447, column: 5, scope: !2525)
!2534 = !DILocation(line: 444, column: 38, scope: !2520)
!2535 = !DILocation(line: 444, column: 5, scope: !2520)
!2536 = distinct !{!2536, !2523, !2537, !1844}
!2537 = !DILocation(line: 447, column: 5, scope: !2516)
!2538 = !DILocalVariable(name: "total", scope: !2427, file: !3, line: 448, type: !124)
!2539 = !DILocation(line: 448, column: 10, scope: !2427)
!2540 = !DILocation(line: 448, column: 18, scope: !2427)
!2541 = !DILocation(line: 448, column: 34, scope: !2427)
!2542 = !DILocation(line: 448, column: 32, scope: !2427)
!2543 = !DILocation(line: 449, column: 44, scope: !2427)
!2544 = !DILocation(line: 449, column: 5, scope: !2427)
!2545 = !DILocation(line: 450, column: 52, scope: !2427)
!2546 = !DILocation(line: 450, column: 73, scope: !2427)
!2547 = !DILocation(line: 450, column: 72, scope: !2427)
!2548 = !DILocation(line: 450, column: 87, scope: !2427)
!2549 = !DILocation(line: 450, column: 86, scope: !2427)
!2550 = !DILocation(line: 450, column: 5, scope: !2427)
!2551 = !DILocation(line: 451, column: 52, scope: !2427)
!2552 = !DILocation(line: 451, column: 73, scope: !2427)
!2553 = !DILocation(line: 451, column: 72, scope: !2427)
!2554 = !DILocation(line: 451, column: 86, scope: !2427)
!2555 = !DILocation(line: 451, column: 85, scope: !2427)
!2556 = !DILocation(line: 451, column: 5, scope: !2427)
!2557 = !DILocation(line: 453, column: 12, scope: !2427)
!2558 = !DILocation(line: 453, column: 24, scope: !2427)
!2559 = !DILocation(line: 453, column: 33, scope: !2427)
!2560 = !DILocation(line: 453, column: 42, scope: !2427)
!2561 = !DILocation(line: 453, column: 56, scope: !2427)
!2562 = !DILocation(line: 452, column: 5, scope: !2427)
!2563 = !DILocation(line: 455, column: 5, scope: !2427)
!2564 = !DILocation(line: 456, column: 5, scope: !2427)
!2565 = !DILocation(line: 457, column: 10, scope: !2427)
!2566 = !DILocation(line: 457, column: 5, scope: !2427)
!2567 = !DILocation(line: 457, column: 22, scope: !2427)
!2568 = !DILocation(line: 457, column: 17, scope: !2427)
!2569 = !DILocation(line: 458, column: 1, scope: !2427)
!2570 = distinct !DISubprogram(name: "run_phase_D", linkageName: "_ZL11run_phase_Dv", scope: !3, file: !3, line: 504, type: !801, scopeLine: 504, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2571 = !DILocalVariable(name: "iters_d", scope: !2570, file: !3, line: 505, type: !16)
!2572 = !DILocation(line: 505, column: 9, scope: !2570)
!2573 = !DILocation(line: 505, column: 30, scope: !2570)
!2574 = !DILocation(line: 505, column: 28, scope: !2570)
!2575 = !DILocation(line: 507, column: 12, scope: !2570)
!2576 = !DILocation(line: 507, column: 24, scope: !2570)
!2577 = !DILocation(line: 506, column: 5, scope: !2570)
!2578 = !DILocalVariable(name: "args", scope: !2570, file: !3, line: 509, type: !368)
!2579 = !DILocation(line: 509, column: 18, scope: !2570)
!2580 = !DILocation(line: 509, column: 47, scope: !2570)
!2581 = !DILocation(line: 509, column: 40, scope: !2570)
!2582 = !DILocalVariable(name: "threads", scope: !2570, file: !3, line: 510, type: !126)
!2583 = !DILocation(line: 510, column: 16, scope: !2570)
!2584 = !DILocation(line: 510, column: 46, scope: !2570)
!2585 = !DILocation(line: 510, column: 57, scope: !2570)
!2586 = !DILocation(line: 510, column: 39, scope: !2570)
!2587 = !DILocation(line: 512, column: 5, scope: !2570)
!2588 = !DILocation(line: 513, column: 5, scope: !2570)
!2589 = !DILocalVariable(name: "i", scope: !2590, file: !3, line: 515, type: !16)
!2590 = distinct !DILexicalBlock(scope: !2570, file: !3, line: 515, column: 5)
!2591 = !DILocation(line: 515, column: 14, scope: !2590)
!2592 = !DILocation(line: 515, column: 10, scope: !2590)
!2593 = !DILocation(line: 515, column: 21, scope: !2594)
!2594 = distinct !DILexicalBlock(scope: !2590, file: !3, line: 515, column: 5)
!2595 = !DILocation(line: 515, column: 25, scope: !2594)
!2596 = !DILocation(line: 515, column: 23, scope: !2594)
!2597 = !DILocation(line: 515, column: 5, scope: !2590)
!2598 = !DILocation(line: 516, column: 22, scope: !2599)
!2599 = distinct !DILexicalBlock(scope: !2594, file: !3, line: 515, column: 42)
!2600 = !DILocation(line: 516, column: 9, scope: !2599)
!2601 = !DILocation(line: 516, column: 14, scope: !2599)
!2602 = !DILocation(line: 516, column: 17, scope: !2599)
!2603 = !DILocation(line: 516, column: 20, scope: !2599)
!2604 = !DILocation(line: 517, column: 25, scope: !2599)
!2605 = !DILocation(line: 517, column: 9, scope: !2599)
!2606 = !DILocation(line: 517, column: 14, scope: !2599)
!2607 = !DILocation(line: 517, column: 17, scope: !2599)
!2608 = !DILocation(line: 517, column: 23, scope: !2599)
!2609 = !DILocation(line: 518, column: 5, scope: !2599)
!2610 = !DILocation(line: 515, column: 38, scope: !2594)
!2611 = !DILocation(line: 515, column: 5, scope: !2594)
!2612 = distinct !{!2612, !2597, !2613, !1844}
!2613 = !DILocation(line: 518, column: 5, scope: !2590)
!2614 = !DILocalVariable(name: "t0", scope: !2570, file: !3, line: 521, type: !374)
!2615 = !DILocation(line: 521, column: 12, scope: !2570)
!2616 = !DILocation(line: 521, column: 17, scope: !2570)
!2617 = !DILocalVariable(name: "i", scope: !2618, file: !3, line: 522, type: !16)
!2618 = distinct !DILexicalBlock(scope: !2570, file: !3, line: 522, column: 5)
!2619 = !DILocation(line: 522, column: 14, scope: !2618)
!2620 = !DILocation(line: 522, column: 10, scope: !2618)
!2621 = !DILocation(line: 522, column: 21, scope: !2622)
!2622 = distinct !DILexicalBlock(scope: !2618, file: !3, line: 522, column: 5)
!2623 = !DILocation(line: 522, column: 25, scope: !2622)
!2624 = !DILocation(line: 522, column: 23, scope: !2622)
!2625 = !DILocation(line: 522, column: 5, scope: !2618)
!2626 = !DILocation(line: 523, column: 25, scope: !2622)
!2627 = !DILocation(line: 523, column: 33, scope: !2622)
!2628 = !DILocation(line: 523, column: 62, scope: !2622)
!2629 = !DILocation(line: 523, column: 67, scope: !2622)
!2630 = !DILocation(line: 523, column: 9, scope: !2622)
!2631 = !DILocation(line: 522, column: 38, scope: !2622)
!2632 = !DILocation(line: 522, column: 5, scope: !2622)
!2633 = distinct !{!2633, !2625, !2634, !1844}
!2634 = !DILocation(line: 523, column: 69, scope: !2618)
!2635 = !DILocalVariable(name: "i", scope: !2636, file: !3, line: 524, type: !16)
!2636 = distinct !DILexicalBlock(scope: !2570, file: !3, line: 524, column: 5)
!2637 = !DILocation(line: 524, column: 14, scope: !2636)
!2638 = !DILocation(line: 524, column: 10, scope: !2636)
!2639 = !DILocation(line: 524, column: 21, scope: !2640)
!2640 = distinct !DILexicalBlock(scope: !2636, file: !3, line: 524, column: 5)
!2641 = !DILocation(line: 524, column: 25, scope: !2640)
!2642 = !DILocation(line: 524, column: 23, scope: !2640)
!2643 = !DILocation(line: 524, column: 5, scope: !2636)
!2644 = !DILocation(line: 524, column: 55, scope: !2640)
!2645 = !DILocation(line: 524, column: 63, scope: !2640)
!2646 = !DILocation(line: 524, column: 42, scope: !2640)
!2647 = !DILocation(line: 524, column: 38, scope: !2640)
!2648 = !DILocation(line: 524, column: 5, scope: !2640)
!2649 = distinct !{!2649, !2643, !2650, !1844}
!2650 = !DILocation(line: 524, column: 74, scope: !2636)
!2651 = !DILocalVariable(name: "packed_wall", scope: !2570, file: !3, line: 525, type: !374)
!2652 = !DILocation(line: 525, column: 12, scope: !2570)
!2653 = !DILocation(line: 525, column: 26, scope: !2570)
!2654 = !DILocation(line: 525, column: 37, scope: !2570)
!2655 = !DILocation(line: 525, column: 35, scope: !2570)
!2656 = !DILocation(line: 528, column: 10, scope: !2570)
!2657 = !DILocation(line: 528, column: 8, scope: !2570)
!2658 = !DILocalVariable(name: "i", scope: !2659, file: !3, line: 529, type: !16)
!2659 = distinct !DILexicalBlock(scope: !2570, file: !3, line: 529, column: 5)
!2660 = !DILocation(line: 529, column: 14, scope: !2659)
!2661 = !DILocation(line: 529, column: 10, scope: !2659)
!2662 = !DILocation(line: 529, column: 21, scope: !2663)
!2663 = distinct !DILexicalBlock(scope: !2659, file: !3, line: 529, column: 5)
!2664 = !DILocation(line: 529, column: 25, scope: !2663)
!2665 = !DILocation(line: 529, column: 23, scope: !2663)
!2666 = !DILocation(line: 529, column: 5, scope: !2659)
!2667 = !DILocation(line: 530, column: 25, scope: !2663)
!2668 = !DILocation(line: 530, column: 33, scope: !2663)
!2669 = !DILocation(line: 530, column: 62, scope: !2663)
!2670 = !DILocation(line: 530, column: 67, scope: !2663)
!2671 = !DILocation(line: 530, column: 9, scope: !2663)
!2672 = !DILocation(line: 529, column: 38, scope: !2663)
!2673 = !DILocation(line: 529, column: 5, scope: !2663)
!2674 = distinct !{!2674, !2666, !2675, !1844}
!2675 = !DILocation(line: 530, column: 69, scope: !2659)
!2676 = !DILocalVariable(name: "i", scope: !2677, file: !3, line: 531, type: !16)
!2677 = distinct !DILexicalBlock(scope: !2570, file: !3, line: 531, column: 5)
!2678 = !DILocation(line: 531, column: 14, scope: !2677)
!2679 = !DILocation(line: 531, column: 10, scope: !2677)
!2680 = !DILocation(line: 531, column: 21, scope: !2681)
!2681 = distinct !DILexicalBlock(scope: !2677, file: !3, line: 531, column: 5)
!2682 = !DILocation(line: 531, column: 25, scope: !2681)
!2683 = !DILocation(line: 531, column: 23, scope: !2681)
!2684 = !DILocation(line: 531, column: 5, scope: !2677)
!2685 = !DILocation(line: 531, column: 55, scope: !2681)
!2686 = !DILocation(line: 531, column: 63, scope: !2681)
!2687 = !DILocation(line: 531, column: 42, scope: !2681)
!2688 = !DILocation(line: 531, column: 38, scope: !2681)
!2689 = !DILocation(line: 531, column: 5, scope: !2681)
!2690 = distinct !{!2690, !2684, !2691, !1844}
!2691 = !DILocation(line: 531, column: 74, scope: !2677)
!2692 = !DILocalVariable(name: "padded_wall", scope: !2570, file: !3, line: 532, type: !374)
!2693 = !DILocation(line: 532, column: 12, scope: !2570)
!2694 = !DILocation(line: 532, column: 26, scope: !2570)
!2695 = !DILocation(line: 532, column: 37, scope: !2570)
!2696 = !DILocation(line: 532, column: 35, scope: !2570)
!2697 = !DILocation(line: 544, column: 44, scope: !2570)
!2698 = !DILocation(line: 544, column: 5, scope: !2570)
!2699 = !DILocation(line: 545, column: 44, scope: !2570)
!2700 = !DILocation(line: 545, column: 5, scope: !2570)
!2701 = !DILocation(line: 546, column: 44, scope: !2570)
!2702 = !DILocation(line: 546, column: 58, scope: !2570)
!2703 = !DILocation(line: 546, column: 56, scope: !2570)
!2704 = !DILocation(line: 546, column: 5, scope: !2570)
!2705 = !DILocation(line: 547, column: 5, scope: !2570)
!2706 = !DILocation(line: 548, column: 5, scope: !2570)
!2707 = !DILocalVariable(name: "shared", scope: !2570, file: !3, line: 551, type: !124)
!2708 = !DILocation(line: 551, column: 10, scope: !2570)
!2709 = !DILocation(line: 551, column: 25, scope: !2570)
!2710 = !DILocation(line: 551, column: 38, scope: !2570)
!2711 = !DILocation(line: 551, column: 36, scope: !2570)
!2712 = !DILocation(line: 551, column: 46, scope: !2570)
!2713 = !DILocalVariable(name: "priv", scope: !2570, file: !3, line: 552, type: !124)
!2714 = !DILocation(line: 552, column: 10, scope: !2570)
!2715 = !DILocation(line: 554, column: 12, scope: !2570)
!2716 = !DILocation(line: 554, column: 24, scope: !2570)
!2717 = !DILocation(line: 554, column: 33, scope: !2570)
!2718 = !DILocation(line: 554, column: 46, scope: !2570)
!2719 = !DILocation(line: 554, column: 59, scope: !2570)
!2720 = !DILocation(line: 554, column: 67, scope: !2570)
!2721 = !DILocation(line: 553, column: 5, scope: !2570)
!2722 = !DILocation(line: 556, column: 10, scope: !2570)
!2723 = !DILocation(line: 556, column: 5, scope: !2570)
!2724 = !DILocation(line: 556, column: 22, scope: !2570)
!2725 = !DILocation(line: 556, column: 17, scope: !2570)
!2726 = !DILocation(line: 557, column: 1, scope: !2570)
!2727 = distinct !DISubprogram(name: "print_summary", linkageName: "_ZL13print_summaryllllllll", scope: !3, file: !3, line: 562, type: !2728, scopeLine: 567, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2728 = !DISubroutineType(types: !2729)
!2729 = !{null, !124, !124, !124, !124, !124, !124, !124, !124}
!2730 = !DILocalVariable(name: "A_sh", arg: 1, scope: !2727, file: !3, line: 563, type: !124)
!2731 = !DILocation(line: 563, column: 10, scope: !2727)
!2732 = !DILocalVariable(name: "A_pr", arg: 2, scope: !2727, file: !3, line: 563, type: !124)
!2733 = !DILocation(line: 563, column: 21, scope: !2727)
!2734 = !DILocalVariable(name: "B_sh", arg: 3, scope: !2727, file: !3, line: 564, type: !124)
!2735 = !DILocation(line: 564, column: 10, scope: !2727)
!2736 = !DILocalVariable(name: "B_pr", arg: 4, scope: !2727, file: !3, line: 564, type: !124)
!2737 = !DILocation(line: 564, column: 21, scope: !2727)
!2738 = !DILocalVariable(name: "C_sh", arg: 5, scope: !2727, file: !3, line: 565, type: !124)
!2739 = !DILocation(line: 565, column: 10, scope: !2727)
!2740 = !DILocalVariable(name: "C_pr", arg: 6, scope: !2727, file: !3, line: 565, type: !124)
!2741 = !DILocation(line: 565, column: 21, scope: !2727)
!2742 = !DILocalVariable(name: "D_sh", arg: 7, scope: !2727, file: !3, line: 566, type: !124)
!2743 = !DILocation(line: 566, column: 10, scope: !2727)
!2744 = !DILocalVariable(name: "D_pr", arg: 8, scope: !2727, file: !3, line: 566, type: !124)
!2745 = !DILocation(line: 566, column: 21, scope: !2727)
!2746 = !DILocalVariable(name: "total_sh", scope: !2727, file: !3, line: 568, type: !124)
!2747 = !DILocation(line: 568, column: 10, scope: !2727)
!2748 = !DILocation(line: 568, column: 21, scope: !2727)
!2749 = !DILocation(line: 568, column: 28, scope: !2727)
!2750 = !DILocation(line: 568, column: 26, scope: !2727)
!2751 = !DILocation(line: 568, column: 35, scope: !2727)
!2752 = !DILocation(line: 568, column: 33, scope: !2727)
!2753 = !DILocation(line: 568, column: 42, scope: !2727)
!2754 = !DILocation(line: 568, column: 40, scope: !2727)
!2755 = !DILocalVariable(name: "total_pr", scope: !2727, file: !3, line: 569, type: !124)
!2756 = !DILocation(line: 569, column: 10, scope: !2727)
!2757 = !DILocation(line: 569, column: 21, scope: !2727)
!2758 = !DILocation(line: 569, column: 28, scope: !2727)
!2759 = !DILocation(line: 569, column: 26, scope: !2727)
!2760 = !DILocation(line: 569, column: 35, scope: !2727)
!2761 = !DILocation(line: 569, column: 33, scope: !2727)
!2762 = !DILocation(line: 569, column: 42, scope: !2727)
!2763 = !DILocation(line: 569, column: 40, scope: !2727)
!2764 = !DILocalVariable(name: "total", scope: !2727, file: !3, line: 570, type: !124)
!2765 = !DILocation(line: 570, column: 10, scope: !2727)
!2766 = !DILocation(line: 570, column: 21, scope: !2727)
!2767 = !DILocation(line: 570, column: 32, scope: !2727)
!2768 = !DILocation(line: 570, column: 30, scope: !2727)
!2769 = !DILocation(line: 572, column: 5, scope: !2727)
!2770 = !DILocation(line: 573, column: 5, scope: !2727)
!2771 = !DILocation(line: 574, column: 5, scope: !2727)
!2772 = !DILocation(line: 575, column: 5, scope: !2727)
!2773 = !DILocation(line: 576, column: 5, scope: !2727)
!2774 = !DILocalVariable(name: "pct", scope: !2727, file: !3, line: 577, type: !2775)
!2775 = distinct !DICompositeType(tag: DW_TAG_class_type, scope: !2727, file: !3, line: 577, size: 8, flags: DIFlagTypePassByValue, elements: !2776)
!2776 = !{!2777}
!2777 = !DISubprogram(name: "operator()", scope: !2775, file: !3, line: 577, type: !2778, scopeLine: 577, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!2778 = !DISubroutineType(types: !2779)
!2779 = !{!374, !2780, !124, !124}
!2780 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !2781, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!2781 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !2775)
!2782 = !DILocation(line: 577, column: 10, scope: !2727)
!2783 = !DILocation(line: 580, column: 67, scope: !2727)
!2784 = !DILocation(line: 580, column: 73, scope: !2727)
!2785 = !DILocation(line: 580, column: 83, scope: !2727)
!2786 = !DILocation(line: 580, column: 88, scope: !2727)
!2787 = !DILocation(line: 580, column: 79, scope: !2727)
!2788 = !DILocation(line: 580, column: 5, scope: !2727)
!2789 = !DILocation(line: 581, column: 67, scope: !2727)
!2790 = !DILocation(line: 581, column: 73, scope: !2727)
!2791 = !DILocation(line: 581, column: 83, scope: !2727)
!2792 = !DILocation(line: 581, column: 88, scope: !2727)
!2793 = !DILocation(line: 581, column: 79, scope: !2727)
!2794 = !DILocation(line: 581, column: 5, scope: !2727)
!2795 = !DILocation(line: 582, column: 67, scope: !2727)
!2796 = !DILocation(line: 582, column: 73, scope: !2727)
!2797 = !DILocation(line: 582, column: 83, scope: !2727)
!2798 = !DILocation(line: 582, column: 88, scope: !2727)
!2799 = !DILocation(line: 582, column: 79, scope: !2727)
!2800 = !DILocation(line: 582, column: 5, scope: !2727)
!2801 = !DILocation(line: 583, column: 67, scope: !2727)
!2802 = !DILocation(line: 583, column: 73, scope: !2727)
!2803 = !DILocation(line: 583, column: 83, scope: !2727)
!2804 = !DILocation(line: 583, column: 88, scope: !2727)
!2805 = !DILocation(line: 583, column: 79, scope: !2727)
!2806 = !DILocation(line: 583, column: 5, scope: !2727)
!2807 = !DILocation(line: 584, column: 5, scope: !2727)
!2808 = !DILocation(line: 585, column: 67, scope: !2727)
!2809 = !DILocation(line: 585, column: 77, scope: !2727)
!2810 = !DILocation(line: 585, column: 91, scope: !2727)
!2811 = !DILocation(line: 585, column: 100, scope: !2727)
!2812 = !DILocation(line: 585, column: 87, scope: !2727)
!2813 = !DILocation(line: 585, column: 5, scope: !2727)
!2814 = !DILocation(line: 586, column: 5, scope: !2727)
!2815 = !DILocation(line: 587, column: 5, scope: !2727)
!2816 = !DILocation(line: 589, column: 20, scope: !2727)
!2817 = !DILocation(line: 589, column: 18, scope: !2727)
!2818 = !DILocation(line: 589, column: 32, scope: !2727)
!2819 = !DILocation(line: 589, column: 38, scope: !2727)
!2820 = !DILocation(line: 589, column: 44, scope: !2727)
!2821 = !DILocation(line: 589, column: 31, scope: !2727)
!2822 = !DILocation(line: 589, column: 29, scope: !2727)
!2823 = !DILocation(line: 588, column: 5, scope: !2727)
!2824 = !DILocation(line: 590, column: 5, scope: !2727)
!2825 = !DILocation(line: 591, column: 5, scope: !2727)
!2826 = !DILocation(line: 592, column: 5, scope: !2727)
!2827 = !DILocation(line: 593, column: 5, scope: !2727)
!2828 = !DILocation(line: 594, column: 5, scope: !2727)
!2829 = !DILocation(line: 595, column: 5, scope: !2727)
!2830 = !DILocation(line: 596, column: 5, scope: !2727)
!2831 = !DILocation(line: 597, column: 5, scope: !2727)
!2832 = !DILocation(line: 598, column: 1, scope: !2727)
!2833 = distinct !DISubprogram(name: "matmul", linkageName: "_ZL6matmulPKfS0_Pfi", scope: !3, file: !3, line: 111, type: !2834, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2834 = !DISubroutineType(types: !2835)
!2835 = !{null, !2836, !2836, !130, !16}
!2836 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !2837, size: 64)
!2837 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !131)
!2838 = !DILocalVariable(name: "A", arg: 1, scope: !2833, file: !3, line: 111, type: !2836)
!2839 = !DILocation(line: 111, column: 33, scope: !2833)
!2840 = !DILocalVariable(name: "B", arg: 2, scope: !2833, file: !3, line: 111, type: !2836)
!2841 = !DILocation(line: 111, column: 49, scope: !2833)
!2842 = !DILocalVariable(name: "C", arg: 3, scope: !2833, file: !3, line: 111, type: !130)
!2843 = !DILocation(line: 111, column: 59, scope: !2833)
!2844 = !DILocalVariable(name: "n", arg: 4, scope: !2833, file: !3, line: 111, type: !16)
!2845 = !DILocation(line: 111, column: 66, scope: !2833)
!2846 = !DILocalVariable(name: "i", scope: !2847, file: !3, line: 113, type: !16)
!2847 = distinct !DILexicalBlock(scope: !2833, file: !3, line: 113, column: 5)
!2848 = !DILocation(line: 113, column: 14, scope: !2847)
!2849 = !DILocation(line: 113, column: 10, scope: !2847)
!2850 = !DILocation(line: 113, column: 21, scope: !2851)
!2851 = distinct !DILexicalBlock(scope: !2847, file: !3, line: 113, column: 5)
!2852 = !DILocation(line: 113, column: 25, scope: !2851)
!2853 = !DILocation(line: 113, column: 23, scope: !2851)
!2854 = !DILocation(line: 113, column: 5, scope: !2847)
!2855 = !DILocalVariable(name: "k", scope: !2856, file: !3, line: 114, type: !16)
!2856 = distinct !DILexicalBlock(scope: !2857, file: !3, line: 114, column: 9)
!2857 = distinct !DILexicalBlock(scope: !2851, file: !3, line: 113, column: 33)
!2858 = !DILocation(line: 114, column: 18, scope: !2856)
!2859 = !DILocation(line: 114, column: 14, scope: !2856)
!2860 = !DILocation(line: 114, column: 25, scope: !2861)
!2861 = distinct !DILexicalBlock(scope: !2856, file: !3, line: 114, column: 9)
!2862 = !DILocation(line: 114, column: 29, scope: !2861)
!2863 = !DILocation(line: 114, column: 27, scope: !2861)
!2864 = !DILocation(line: 114, column: 9, scope: !2856)
!2865 = !DILocalVariable(name: "aik", scope: !2866, file: !3, line: 115, type: !131)
!2866 = distinct !DILexicalBlock(scope: !2861, file: !3, line: 114, column: 37)
!2867 = !DILocation(line: 115, column: 19, scope: !2866)
!2868 = !DILocation(line: 115, column: 25, scope: !2866)
!2869 = !DILocation(line: 115, column: 27, scope: !2866)
!2870 = !DILocation(line: 115, column: 29, scope: !2866)
!2871 = !DILocation(line: 115, column: 28, scope: !2866)
!2872 = !DILocation(line: 115, column: 31, scope: !2866)
!2873 = !DILocation(line: 115, column: 30, scope: !2866)
!2874 = !DILocalVariable(name: "j", scope: !2875, file: !3, line: 116, type: !16)
!2875 = distinct !DILexicalBlock(scope: !2866, file: !3, line: 116, column: 13)
!2876 = !DILocation(line: 116, column: 22, scope: !2875)
!2877 = !DILocation(line: 116, column: 18, scope: !2875)
!2878 = !DILocation(line: 116, column: 29, scope: !2879)
!2879 = distinct !DILexicalBlock(scope: !2875, file: !3, line: 116, column: 13)
!2880 = !DILocation(line: 116, column: 33, scope: !2879)
!2881 = !DILocation(line: 116, column: 31, scope: !2879)
!2882 = !DILocation(line: 116, column: 13, scope: !2875)
!2883 = !DILocation(line: 117, column: 29, scope: !2884)
!2884 = distinct !DILexicalBlock(scope: !2879, file: !3, line: 116, column: 41)
!2885 = !DILocation(line: 117, column: 35, scope: !2884)
!2886 = !DILocation(line: 117, column: 37, scope: !2884)
!2887 = !DILocation(line: 117, column: 39, scope: !2884)
!2888 = !DILocation(line: 117, column: 38, scope: !2884)
!2889 = !DILocation(line: 117, column: 41, scope: !2884)
!2890 = !DILocation(line: 117, column: 40, scope: !2884)
!2891 = !DILocation(line: 117, column: 17, scope: !2884)
!2892 = !DILocation(line: 117, column: 19, scope: !2884)
!2893 = !DILocation(line: 117, column: 21, scope: !2884)
!2894 = !DILocation(line: 117, column: 20, scope: !2884)
!2895 = !DILocation(line: 117, column: 23, scope: !2884)
!2896 = !DILocation(line: 117, column: 22, scope: !2884)
!2897 = !DILocation(line: 117, column: 26, scope: !2884)
!2898 = !DILocation(line: 118, column: 13, scope: !2884)
!2899 = !DILocation(line: 116, column: 37, scope: !2879)
!2900 = !DILocation(line: 116, column: 13, scope: !2879)
!2901 = distinct !{!2901, !2882, !2902, !1844}
!2902 = !DILocation(line: 118, column: 13, scope: !2875)
!2903 = !DILocation(line: 119, column: 9, scope: !2866)
!2904 = !DILocation(line: 114, column: 33, scope: !2861)
!2905 = !DILocation(line: 114, column: 9, scope: !2861)
!2906 = distinct !{!2906, !2864, !2907, !1844}
!2907 = !DILocation(line: 119, column: 9, scope: !2856)
!2908 = !DILocation(line: 120, column: 5, scope: !2857)
!2909 = !DILocation(line: 113, column: 29, scope: !2851)
!2910 = !DILocation(line: 113, column: 5, scope: !2851)
!2911 = distinct !{!2911, !2854, !2912, !1844}
!2912 = !DILocation(line: 120, column: 5, scope: !2847)
!2913 = !DILocation(line: 121, column: 1, scope: !2833)
!2914 = distinct !DISubprogram(name: "now_ms", linkageName: "_ZL6now_msv", scope: !3, file: !3, line: 86, type: !2915, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2915 = !DISubroutineType(types: !2916)
!2916 = !{!374}
!2917 = !DILocalVariable(name: "ts", scope: !2914, file: !3, line: 87, type: !1168)
!2918 = !DILocation(line: 87, column: 21, scope: !2914)
!2919 = !DILocation(line: 88, column: 5, scope: !2914)
!2920 = !DILocation(line: 89, column: 15, scope: !2914)
!2921 = !DILocation(line: 89, column: 12, scope: !2914)
!2922 = !DILocation(line: 89, column: 36, scope: !2914)
!2923 = !DILocation(line: 89, column: 33, scope: !2914)
!2924 = !DILocation(line: 89, column: 44, scope: !2914)
!2925 = !DILocation(line: 89, column: 31, scope: !2914)
!2926 = !DILocation(line: 89, column: 5, scope: !2914)
!2927 = distinct !DISubprogram(name: "phaseB_consumer", linkageName: "_ZL15phaseB_consumerPv", scope: !3, file: !3, line: 246, type: !2052, scopeLine: 246, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!2928 = !DILocalVariable(name: "arg", arg: 1, scope: !2927, file: !3, line: 246, type: !807)
!2929 = !DILocation(line: 246, column: 36, scope: !2927)
!2930 = !DILocalVariable(name: "a", scope: !2927, file: !3, line: 247, type: !346)
!2931 = !DILocation(line: 247, column: 26, scope: !2927)
!2932 = !DILocation(line: 247, column: 53, scope: !2927)
!2933 = !DILocalVariable(name: "scratch", scope: !2927, file: !3, line: 249, type: !353)
!2934 = !DILocation(line: 249, column: 10, scope: !2927)
!2935 = !DILocation(line: 249, column: 27, scope: !2927)
!2936 = !DILocalVariable(name: "item", scope: !2927, file: !3, line: 250, type: !137)
!2937 = !DILocation(line: 250, column: 14, scope: !2927)
!2938 = !DILocalVariable(name: "items", scope: !2927, file: !3, line: 251, type: !124)
!2939 = !DILocation(line: 251, column: 10, scope: !2927)
!2940 = !DILocalVariable(name: "private_acc", scope: !2927, file: !3, line: 251, type: !124)
!2941 = !DILocation(line: 251, column: 21, scope: !2927)
!2942 = !DILocalVariable(name: "shared_acc", scope: !2927, file: !3, line: 251, type: !124)
!2943 = !DILocation(line: 251, column: 38, scope: !2927)
!2944 = !DILocation(line: 252, column: 5, scope: !2927)
!2945 = !DILocation(line: 253, column: 19, scope: !2946)
!2946 = distinct !DILexicalBlock(scope: !2947, file: !3, line: 253, column: 13)
!2947 = distinct !DILexicalBlock(scope: !2927, file: !3, line: 252, column: 18)
!2948 = !DILocation(line: 253, column: 13, scope: !2946)
!2949 = !DILocalVariable(name: "i", scope: !2950, file: !3, line: 255, type: !16)
!2950 = distinct !DILexicalBlock(scope: !2951, file: !3, line: 255, column: 13)
!2951 = distinct !DILexicalBlock(scope: !2946, file: !3, line: 253, column: 36)
!2952 = !DILocation(line: 255, column: 22, scope: !2950)
!2953 = !DILocation(line: 255, column: 18, scope: !2950)
!2954 = !DILocation(line: 255, column: 29, scope: !2955)
!2955 = distinct !DILexicalBlock(scope: !2950, file: !3, line: 255, column: 13)
!2956 = !DILocation(line: 255, column: 31, scope: !2955)
!2957 = !DILocation(line: 255, column: 13, scope: !2950)
!2958 = !DILocation(line: 256, column: 41, scope: !2955)
!2959 = !DILocation(line: 256, column: 49, scope: !2955)
!2960 = !DILocation(line: 256, column: 51, scope: !2955)
!2961 = !DILocation(line: 256, column: 36, scope: !2955)
!2962 = !DILocation(line: 256, column: 71, scope: !2955)
!2963 = !DILocation(line: 256, column: 73, scope: !2955)
!2964 = !DILocation(line: 256, column: 68, scope: !2955)
!2965 = !DILocation(line: 256, column: 17, scope: !2955)
!2966 = !DILocation(line: 256, column: 25, scope: !2955)
!2967 = !DILocation(line: 256, column: 28, scope: !2955)
!2968 = !DILocation(line: 255, column: 45, scope: !2955)
!2969 = !DILocation(line: 255, column: 13, scope: !2955)
!2970 = distinct !{!2970, !2957, !2971, !1844}
!2971 = !DILocation(line: 256, column: 80, scope: !2950)
!2972 = !DILocalVariable(name: "s", scope: !2951, file: !3, line: 258, type: !124)
!2973 = !DILocation(line: 258, column: 18, scope: !2951)
!2974 = !DILocalVariable(name: "i", scope: !2975, file: !3, line: 259, type: !16)
!2975 = distinct !DILexicalBlock(scope: !2951, file: !3, line: 259, column: 13)
!2976 = !DILocation(line: 259, column: 22, scope: !2975)
!2977 = !DILocation(line: 259, column: 18, scope: !2975)
!2978 = !DILocation(line: 259, column: 29, scope: !2979)
!2979 = distinct !DILexicalBlock(scope: !2975, file: !3, line: 259, column: 13)
!2980 = !DILocation(line: 259, column: 31, scope: !2979)
!2981 = !DILocation(line: 259, column: 13, scope: !2975)
!2982 = !DILocation(line: 259, column: 54, scope: !2979)
!2983 = !DILocation(line: 259, column: 62, scope: !2979)
!2984 = !DILocation(line: 259, column: 51, scope: !2979)
!2985 = !DILocation(line: 259, column: 49, scope: !2979)
!2986 = !DILocation(line: 259, column: 45, scope: !2979)
!2987 = !DILocation(line: 259, column: 13, scope: !2979)
!2988 = distinct !{!2988, !2981, !2989, !1844}
!2989 = !DILocation(line: 259, column: 63, scope: !2975)
!2990 = !DILocation(line: 260, column: 34, scope: !2951)
!2991 = !DILocation(line: 0, scope: !2142, inlinedAt: !2992)
!2992 = distinct !DILocation(line: 260, column: 24, scope: !2951)
!2993 = !DILocation(line: 629, column: 28, scope: !2142, inlinedAt: !2992)
!2994 = !DILocation(line: 630, column: 16, scope: !2142, inlinedAt: !2992)
!2995 = !DILocation(line: 631, column: 51, scope: !2142, inlinedAt: !2992)
!2996 = !DILocation(line: 631, column: 42, scope: !2142, inlinedAt: !2992)
!2997 = !DILocation(line: 631, column: 16, scope: !2142, inlinedAt: !2992)
!2998 = !DILocation(line: 261, column: 18, scope: !2951)
!2999 = !DILocation(line: 262, column: 25, scope: !2951)
!3000 = !DILocation(line: 263, column: 25, scope: !2951)
!3001 = !DILocation(line: 264, column: 9, scope: !2951)
!3002 = !DILocation(line: 265, column: 17, scope: !3003)
!3003 = distinct !DILexicalBlock(scope: !3004, file: !3, line: 265, column: 17)
!3004 = distinct !DILexicalBlock(scope: !2946, file: !3, line: 264, column: 16)
!3005 = !DILocation(line: 265, column: 26, scope: !3003)
!3006 = !DILocalVariable(name: "this", arg: 1, scope: !3007, type: !3008, flags: DIFlagArtificial | DIFlagObjectPointer)
!3007 = distinct !DISubprogram(name: "load", linkageName: "_ZNKSt13__atomic_baseIiE4loadESt12memory_order", scope: !185, file: !104, line: 494, type: !268, scopeLine: 495, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, declaration: !267, retainedNodes: !1767)
!3008 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !200, size: 64)
!3009 = !DILocation(line: 0, scope: !3007, inlinedAt: !3010)
!3010 = distinct !DILocation(line: 265, column: 41, scope: !3003)
!3011 = !DILocalVariable(name: "__m", arg: 2, scope: !3007, file: !104, line: 494, type: !103)
!3012 = !DILocation(line: 494, column: 25, scope: !3007, inlinedAt: !3010)
!3013 = !DILocalVariable(name: "__b", scope: !3007, file: !104, line: 496, type: !103)
!3014 = !DILocation(line: 496, column: 15, scope: !3007, inlinedAt: !3010)
!3015 = !DILocation(line: 497, column: 6, scope: !3007, inlinedAt: !3010)
!3016 = !DILocation(line: 497, column: 10, scope: !3007, inlinedAt: !3010)
!3017 = !DILocation(line: 498, column: 2, scope: !3018, inlinedAt: !3010)
!3018 = distinct !DILexicalBlock(scope: !3019, file: !104, line: 498, column: 2)
!3019 = distinct !DILexicalBlock(scope: !3007, file: !104, line: 498, column: 2)
!3020 = !DILocation(line: 499, column: 2, scope: !3021, inlinedAt: !3010)
!3021 = distinct !DILexicalBlock(scope: !3022, file: !104, line: 499, column: 2)
!3022 = distinct !DILexicalBlock(scope: !3007, file: !104, line: 499, column: 2)
!3023 = !DILocation(line: 501, column: 36, scope: !3007, inlinedAt: !3010)
!3024 = !DILocation(line: 501, column: 9, scope: !3007, inlinedAt: !3010)
!3025 = !DILocation(line: 267, column: 17, scope: !3026)
!3026 = distinct !DILexicalBlock(scope: !3003, file: !3, line: 265, column: 74)
!3027 = !DILocation(line: 267, column: 30, scope: !3026)
!3028 = !DILocation(line: 267, column: 24, scope: !3026)
!3029 = !DILocation(line: 268, column: 26, scope: !3030)
!3030 = distinct !DILexicalBlock(scope: !3026, file: !3, line: 267, column: 47)
!3031 = !DILocation(line: 269, column: 32, scope: !3030)
!3032 = distinct !{!3032, !3025, !3033, !1844}
!3033 = !DILocation(line: 270, column: 17, scope: !3026)
!3034 = !DILocation(line: 271, column: 17, scope: !3026)
!3035 = !DILocation(line: 273, column: 13, scope: !3004)
!3036 = distinct !{!3036, !2944, !3037, !1844}
!3037 = !DILocation(line: 275, column: 5, scope: !2927)
!3038 = !DILocation(line: 276, column: 25, scope: !2927)
!3039 = !DILocation(line: 276, column: 5, scope: !2927)
!3040 = !DILocation(line: 276, column: 8, scope: !2927)
!3041 = !DILocation(line: 276, column: 23, scope: !2927)
!3042 = !DILocation(line: 277, column: 25, scope: !2927)
!3043 = !DILocation(line: 277, column: 5, scope: !2927)
!3044 = !DILocation(line: 277, column: 8, scope: !2927)
!3045 = !DILocation(line: 277, column: 23, scope: !2927)
!3046 = !DILocation(line: 278, column: 25, scope: !2927)
!3047 = !DILocation(line: 278, column: 5, scope: !2927)
!3048 = !DILocation(line: 278, column: 8, scope: !2927)
!3049 = !DILocation(line: 278, column: 23, scope: !2927)
!3050 = !DILocation(line: 279, column: 10, scope: !2927)
!3051 = !DILocation(line: 279, column: 5, scope: !2927)
!3052 = !DILocation(line: 280, column: 5, scope: !2927)
!3053 = distinct !DISubprogram(name: "phaseB_producer", linkageName: "_ZL15phaseB_producerPv", scope: !3, file: !3, line: 231, type: !2052, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3054 = !DILocalVariable(name: "arg", arg: 1, scope: !3053, file: !3, line: 231, type: !807)
!3055 = !DILocation(line: 231, column: 36, scope: !3053)
!3056 = !DILocalVariable(name: "a", scope: !3053, file: !3, line: 232, type: !340)
!3057 = !DILocation(line: 232, column: 26, scope: !3053)
!3058 = !DILocation(line: 232, column: 53, scope: !3053)
!3059 = !DILocalVariable(name: "item", scope: !3053, file: !3, line: 233, type: !137)
!3060 = !DILocation(line: 233, column: 14, scope: !3053)
!3061 = !DILocation(line: 234, column: 24, scope: !3053)
!3062 = !DILocation(line: 234, column: 27, scope: !3053)
!3063 = !DILocation(line: 234, column: 10, scope: !3053)
!3064 = !DILocation(line: 234, column: 22, scope: !3053)
!3065 = !DILocalVariable(name: "shared", scope: !3053, file: !3, line: 235, type: !124)
!3066 = !DILocation(line: 235, column: 10, scope: !3053)
!3067 = !DILocalVariable(name: "i", scope: !3068, file: !3, line: 236, type: !16)
!3068 = distinct !DILexicalBlock(scope: !3053, file: !3, line: 236, column: 5)
!3069 = !DILocation(line: 236, column: 14, scope: !3068)
!3070 = !DILocation(line: 236, column: 10, scope: !3068)
!3071 = !DILocation(line: 236, column: 21, scope: !3072)
!3072 = distinct !DILexicalBlock(scope: !3068, file: !3, line: 236, column: 5)
!3073 = !DILocation(line: 236, column: 25, scope: !3072)
!3074 = !DILocation(line: 236, column: 28, scope: !3072)
!3075 = !DILocation(line: 236, column: 23, scope: !3072)
!3076 = !DILocation(line: 236, column: 5, scope: !3068)
!3077 = !DILocation(line: 237, column: 20, scope: !3078)
!3078 = distinct !DILexicalBlock(scope: !3072, file: !3, line: 236, column: 51)
!3079 = !DILocation(line: 237, column: 14, scope: !3078)
!3080 = !DILocation(line: 237, column: 18, scope: !3078)
!3081 = !DILocation(line: 238, column: 21, scope: !3078)
!3082 = !DILocation(line: 238, column: 16, scope: !3078)
!3083 = !DILocation(line: 238, column: 37, scope: !3078)
!3084 = !DILocation(line: 238, column: 39, scope: !3078)
!3085 = !DILocation(line: 238, column: 36, scope: !3078)
!3086 = !DILocation(line: 238, column: 30, scope: !3078)
!3087 = !DILocation(line: 238, column: 9, scope: !3078)
!3088 = !DILocation(line: 239, column: 9, scope: !3078)
!3089 = !DILocation(line: 239, column: 24, scope: !3078)
!3090 = !DILocation(line: 239, column: 17, scope: !3078)
!3091 = !DILocation(line: 239, column: 16, scope: !3078)
!3092 = !DILocation(line: 239, column: 41, scope: !3078)
!3093 = distinct !{!3093, !3088, !3094, !1844}
!3094 = !DILocation(line: 239, column: 53, scope: !3078)
!3095 = !DILocation(line: 240, column: 16, scope: !3078)
!3096 = !DILocation(line: 241, column: 5, scope: !3078)
!3097 = !DILocation(line: 236, column: 47, scope: !3072)
!3098 = !DILocation(line: 236, column: 5, scope: !3072)
!3099 = distinct !{!3099, !3076, !3100, !1844}
!3100 = !DILocation(line: 241, column: 5, scope: !3068)
!3101 = !DILocation(line: 242, column: 21, scope: !3053)
!3102 = !DILocation(line: 242, column: 5, scope: !3053)
!3103 = !DILocation(line: 242, column: 8, scope: !3053)
!3104 = !DILocation(line: 242, column: 19, scope: !3053)
!3105 = !DILocation(line: 243, column: 5, scope: !3053)
!3106 = distinct !DISubprogram(name: "q_pop", linkageName: "_ZL5q_popP9RingQueueP8WorkItem", scope: !3, file: !3, line: 219, type: !3107, scopeLine: 219, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3107 = !DISubroutineType(types: !3108)
!3108 = !{!16, !132, !3109}
!3109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !137, size: 64)
!3110 = !DILocalVariable(name: "q", arg: 1, scope: !3106, file: !3, line: 219, type: !132)
!3111 = !DILocation(line: 219, column: 29, scope: !3106)
!3112 = !DILocalVariable(name: "out", arg: 2, scope: !3106, file: !3, line: 219, type: !3109)
!3113 = !DILocation(line: 219, column: 42, scope: !3106)
!3114 = !DILocation(line: 220, column: 25, scope: !3106)
!3115 = !DILocation(line: 220, column: 28, scope: !3106)
!3116 = !DILocation(line: 220, column: 5, scope: !3106)
!3117 = !DILocation(line: 221, column: 9, scope: !3118)
!3118 = distinct !DILexicalBlock(scope: !3106, file: !3, line: 221, column: 9)
!3119 = !DILocation(line: 221, column: 12, scope: !3118)
!3120 = !DILocation(line: 221, column: 20, scope: !3118)
!3121 = !DILocation(line: 221, column: 23, scope: !3118)
!3122 = !DILocation(line: 221, column: 17, scope: !3118)
!3123 = !DILocation(line: 221, column: 53, scope: !3124)
!3124 = distinct !DILexicalBlock(scope: !3118, file: !3, line: 221, column: 29)
!3125 = !DILocation(line: 221, column: 56, scope: !3124)
!3126 = !DILocation(line: 221, column: 31, scope: !3124)
!3127 = !DILocation(line: 221, column: 63, scope: !3124)
!3128 = !DILocation(line: 222, column: 12, scope: !3106)
!3129 = !DILocation(line: 222, column: 15, scope: !3106)
!3130 = !DILocation(line: 222, column: 21, scope: !3106)
!3131 = !DILocation(line: 222, column: 24, scope: !3106)
!3132 = !DILocation(line: 222, column: 6, scope: !3106)
!3133 = !DILocation(line: 222, column: 10, scope: !3106)
!3134 = !DILocation(line: 223, column: 16, scope: !3106)
!3135 = !DILocation(line: 223, column: 19, scope: !3106)
!3136 = !DILocation(line: 223, column: 24, scope: !3106)
!3137 = !DILocation(line: 223, column: 29, scope: !3106)
!3138 = !DILocation(line: 223, column: 5, scope: !3106)
!3139 = !DILocation(line: 223, column: 8, scope: !3106)
!3140 = !DILocation(line: 223, column: 13, scope: !3106)
!3141 = !DILocation(line: 224, column: 27, scope: !3106)
!3142 = !DILocation(line: 224, column: 30, scope: !3106)
!3143 = !DILocation(line: 224, column: 5, scope: !3106)
!3144 = !DILocation(line: 225, column: 5, scope: !3106)
!3145 = !DILocation(line: 226, column: 1, scope: !3106)
!3146 = distinct !DISubprogram(name: "operator&", linkageName: "_ZStanSt12memory_orderSt23__memory_order_modifier", scope: !15, file: !104, line: 110, type: !3147, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3147 = !DISubroutineType(types: !3148)
!3148 = !{!103, !103, !112}
!3149 = !DILocalVariable(name: "__m", arg: 1, scope: !3146, file: !104, line: 110, type: !103)
!3150 = !DILocation(line: 110, column: 26, scope: !3146)
!3151 = !DILocalVariable(name: "__mod", arg: 2, scope: !3146, file: !104, line: 110, type: !112)
!3152 = !DILocation(line: 110, column: 55, scope: !3146)
!3153 = !DILocation(line: 112, column: 29, scope: !3146)
!3154 = !DILocation(line: 112, column: 40, scope: !3146)
!3155 = !DILocation(line: 112, column: 34, scope: !3146)
!3156 = !DILocation(line: 112, column: 5, scope: !3146)
!3157 = distinct !DISubprogram(name: "q_push", linkageName: "_ZL6q_pushP9RingQueuePK8WorkItem", scope: !3, file: !3, line: 209, type: !3158, scopeLine: 209, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3158 = !DISubroutineType(types: !3159)
!3159 = !{!16, !132, !3160}
!3160 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3161, size: 64)
!3161 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !137)
!3162 = !DILocalVariable(name: "q", arg: 1, scope: !3157, file: !3, line: 209, type: !132)
!3163 = !DILocation(line: 209, column: 30, scope: !3157)
!3164 = !DILocalVariable(name: "item", arg: 2, scope: !3157, file: !3, line: 209, type: !3160)
!3165 = !DILocation(line: 209, column: 49, scope: !3157)
!3166 = !DILocation(line: 210, column: 25, scope: !3157)
!3167 = !DILocation(line: 210, column: 28, scope: !3157)
!3168 = !DILocation(line: 210, column: 5, scope: !3157)
!3169 = !DILocalVariable(name: "next", scope: !3157, file: !3, line: 211, type: !16)
!3170 = !DILocation(line: 211, column: 9, scope: !3157)
!3171 = !DILocation(line: 211, column: 17, scope: !3157)
!3172 = !DILocation(line: 211, column: 20, scope: !3157)
!3173 = !DILocation(line: 211, column: 25, scope: !3157)
!3174 = !DILocation(line: 211, column: 30, scope: !3157)
!3175 = !DILocation(line: 212, column: 9, scope: !3176)
!3176 = distinct !DILexicalBlock(scope: !3157, file: !3, line: 212, column: 9)
!3177 = !DILocation(line: 212, column: 17, scope: !3176)
!3178 = !DILocation(line: 212, column: 20, scope: !3176)
!3179 = !DILocation(line: 212, column: 14, scope: !3176)
!3180 = !DILocation(line: 212, column: 50, scope: !3181)
!3181 = distinct !DILexicalBlock(scope: !3176, file: !3, line: 212, column: 26)
!3182 = !DILocation(line: 212, column: 53, scope: !3181)
!3183 = !DILocation(line: 212, column: 28, scope: !3181)
!3184 = !DILocation(line: 212, column: 60, scope: !3181)
!3185 = !DILocation(line: 213, column: 26, scope: !3157)
!3186 = !DILocation(line: 213, column: 5, scope: !3157)
!3187 = !DILocation(line: 213, column: 8, scope: !3157)
!3188 = !DILocation(line: 213, column: 14, scope: !3157)
!3189 = !DILocation(line: 213, column: 17, scope: !3157)
!3190 = !DILocation(line: 213, column: 23, scope: !3157)
!3191 = !DILocation(line: 214, column: 15, scope: !3157)
!3192 = !DILocation(line: 214, column: 5, scope: !3157)
!3193 = !DILocation(line: 214, column: 8, scope: !3157)
!3194 = !DILocation(line: 214, column: 13, scope: !3157)
!3195 = !DILocation(line: 215, column: 27, scope: !3157)
!3196 = !DILocation(line: 215, column: 30, scope: !3157)
!3197 = !DILocation(line: 215, column: 5, scope: !3157)
!3198 = !DILocation(line: 216, column: 5, scope: !3157)
!3199 = !DILocation(line: 217, column: 1, scope: !3157)
!3200 = distinct !DISubprogram(name: "phaseC_worker", linkageName: "_ZL13phaseC_workerPv", scope: !3, file: !3, line: 386, type: !2052, scopeLine: 386, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3201 = !DILocalVariable(name: "arg", arg: 1, scope: !3200, file: !3, line: 386, type: !807)
!3202 = !DILocation(line: 386, column: 34, scope: !3200)
!3203 = !DILocalVariable(name: "a", scope: !3200, file: !3, line: 387, type: !354)
!3204 = !DILocation(line: 387, column: 18, scope: !3200)
!3205 = !DILocation(line: 387, column: 37, scope: !3200)
!3206 = !DILocalVariable(name: "results", scope: !3200, file: !3, line: 389, type: !353)
!3207 = !DILocation(line: 389, column: 10, scope: !3200)
!3208 = !DILocation(line: 389, column: 34, scope: !3200)
!3209 = !DILocation(line: 389, column: 37, scope: !3200)
!3210 = !DILocation(line: 389, column: 47, scope: !3200)
!3211 = !DILocation(line: 389, column: 27, scope: !3200)
!3212 = !DILocalVariable(name: "shared", scope: !3200, file: !3, line: 390, type: !124)
!3213 = !DILocation(line: 390, column: 10, scope: !3200)
!3214 = !DILocalVariable(name: "priv", scope: !3200, file: !3, line: 390, type: !124)
!3215 = !DILocation(line: 390, column: 22, scope: !3200)
!3216 = !DILocalVariable(name: "i", scope: !3217, file: !3, line: 393, type: !16)
!3217 = distinct !DILexicalBlock(scope: !3200, file: !3, line: 393, column: 5)
!3218 = !DILocation(line: 393, column: 14, scope: !3217)
!3219 = !DILocation(line: 393, column: 10, scope: !3217)
!3220 = !DILocation(line: 393, column: 21, scope: !3221)
!3221 = distinct !DILexicalBlock(scope: !3217, file: !3, line: 393, column: 5)
!3222 = !DILocation(line: 393, column: 25, scope: !3221)
!3223 = !DILocation(line: 393, column: 28, scope: !3221)
!3224 = !DILocation(line: 393, column: 23, scope: !3221)
!3225 = !DILocation(line: 393, column: 5, scope: !3217)
!3226 = !DILocalVariable(name: "key", scope: !3227, file: !3, line: 394, type: !16)
!3227 = distinct !DILexicalBlock(scope: !3221, file: !3, line: 393, column: 44)
!3228 = !DILocation(line: 394, column: 13, scope: !3227)
!3229 = !DILocation(line: 394, column: 20, scope: !3227)
!3230 = !DILocation(line: 394, column: 23, scope: !3227)
!3231 = !DILocation(line: 394, column: 26, scope: !3227)
!3232 = !DILocation(line: 394, column: 36, scope: !3227)
!3233 = !DILocation(line: 394, column: 34, scope: !3227)
!3234 = !DILocation(line: 394, column: 39, scope: !3227)
!3235 = !DILocation(line: 395, column: 30, scope: !3227)
!3236 = !DILocation(line: 395, column: 35, scope: !3227)
!3237 = !DILocation(line: 395, column: 38, scope: !3227)
!3238 = !DILocation(line: 395, column: 9, scope: !3227)
!3239 = !DILocation(line: 396, column: 16, scope: !3227)
!3240 = !DILocation(line: 397, column: 5, scope: !3227)
!3241 = !DILocation(line: 393, column: 40, scope: !3221)
!3242 = !DILocation(line: 393, column: 5, scope: !3221)
!3243 = distinct !{!3243, !3225, !3244, !1844}
!3244 = !DILocation(line: 397, column: 5, scope: !3217)
!3245 = !DILocalVariable(name: "i", scope: !3246, file: !3, line: 400, type: !16)
!3246 = distinct !DILexicalBlock(scope: !3200, file: !3, line: 400, column: 5)
!3247 = !DILocation(line: 400, column: 14, scope: !3246)
!3248 = !DILocation(line: 400, column: 10, scope: !3246)
!3249 = !DILocation(line: 400, column: 21, scope: !3250)
!3250 = distinct !DILexicalBlock(scope: !3246, file: !3, line: 400, column: 5)
!3251 = !DILocation(line: 400, column: 25, scope: !3250)
!3252 = !DILocation(line: 400, column: 28, scope: !3250)
!3253 = !DILocation(line: 400, column: 23, scope: !3250)
!3254 = !DILocation(line: 400, column: 5, scope: !3246)
!3255 = !DILocalVariable(name: "key", scope: !3256, file: !3, line: 401, type: !16)
!3256 = distinct !DILexicalBlock(scope: !3250, file: !3, line: 400, column: 44)
!3257 = !DILocation(line: 401, column: 13, scope: !3256)
!3258 = !DILocation(line: 401, column: 20, scope: !3256)
!3259 = !DILocation(line: 401, column: 23, scope: !3256)
!3260 = !DILocation(line: 401, column: 26, scope: !3256)
!3261 = !DILocation(line: 401, column: 37, scope: !3256)
!3262 = !DILocation(line: 401, column: 41, scope: !3256)
!3263 = !DILocation(line: 401, column: 44, scope: !3256)
!3264 = !DILocation(line: 401, column: 39, scope: !3256)
!3265 = !DILocation(line: 401, column: 34, scope: !3256)
!3266 = !DILocation(line: 401, column: 56, scope: !3256)
!3267 = !DILocation(line: 402, column: 43, scope: !3256)
!3268 = !DILocation(line: 402, column: 22, scope: !3256)
!3269 = !DILocation(line: 402, column: 9, scope: !3256)
!3270 = !DILocation(line: 402, column: 17, scope: !3256)
!3271 = !DILocation(line: 402, column: 20, scope: !3256)
!3272 = !DILocation(line: 403, column: 16, scope: !3256)
!3273 = !DILocation(line: 404, column: 16, scope: !3256)
!3274 = !DILocation(line: 405, column: 5, scope: !3256)
!3275 = !DILocation(line: 400, column: 40, scope: !3250)
!3276 = !DILocation(line: 400, column: 5, scope: !3250)
!3277 = distinct !{!3277, !3254, !3278, !1844}
!3278 = !DILocation(line: 405, column: 5, scope: !3246)
!3279 = !DILocalVariable(name: "sum", scope: !3200, file: !3, line: 408, type: !124)
!3280 = !DILocation(line: 408, column: 10, scope: !3200)
!3281 = !DILocalVariable(name: "i", scope: !3282, file: !3, line: 409, type: !16)
!3282 = distinct !DILexicalBlock(scope: !3200, file: !3, line: 409, column: 5)
!3283 = !DILocation(line: 409, column: 14, scope: !3282)
!3284 = !DILocation(line: 409, column: 10, scope: !3282)
!3285 = !DILocation(line: 409, column: 21, scope: !3286)
!3286 = distinct !DILexicalBlock(scope: !3282, file: !3, line: 409, column: 5)
!3287 = !DILocation(line: 409, column: 25, scope: !3286)
!3288 = !DILocation(line: 409, column: 28, scope: !3286)
!3289 = !DILocation(line: 409, column: 23, scope: !3286)
!3290 = !DILocation(line: 409, column: 5, scope: !3282)
!3291 = !DILocation(line: 409, column: 51, scope: !3286)
!3292 = !DILocation(line: 409, column: 59, scope: !3286)
!3293 = !DILocation(line: 409, column: 48, scope: !3286)
!3294 = !DILocation(line: 409, column: 44, scope: !3286)
!3295 = !DILocation(line: 409, column: 40, scope: !3286)
!3296 = !DILocation(line: 409, column: 5, scope: !3286)
!3297 = distinct !{!3297, !3290, !3298, !1844}
!3298 = !DILocation(line: 409, column: 60, scope: !3282)
!3299 = !DILocation(line: 410, column: 26, scope: !3200)
!3300 = !DILocation(line: 0, scope: !2142, inlinedAt: !3301)
!3301 = distinct !DILocation(line: 410, column: 16, scope: !3200)
!3302 = !DILocation(line: 629, column: 28, scope: !2142, inlinedAt: !3301)
!3303 = !DILocation(line: 630, column: 16, scope: !2142, inlinedAt: !3301)
!3304 = !DILocation(line: 631, column: 51, scope: !2142, inlinedAt: !3301)
!3305 = !DILocation(line: 631, column: 42, scope: !2142, inlinedAt: !3301)
!3306 = !DILocation(line: 631, column: 16, scope: !2142, inlinedAt: !3301)
!3307 = !DILocation(line: 411, column: 13, scope: !3200)
!3308 = !DILocation(line: 411, column: 16, scope: !3200)
!3309 = !DILocation(line: 411, column: 10, scope: !3200)
!3310 = !DILocation(line: 413, column: 22, scope: !3200)
!3311 = !DILocation(line: 413, column: 5, scope: !3200)
!3312 = !DILocation(line: 413, column: 8, scope: !3200)
!3313 = !DILocation(line: 413, column: 20, scope: !3200)
!3314 = !DILocation(line: 414, column: 22, scope: !3200)
!3315 = !DILocation(line: 414, column: 5, scope: !3200)
!3316 = !DILocation(line: 414, column: 8, scope: !3200)
!3317 = !DILocation(line: 414, column: 20, scope: !3200)
!3318 = !DILocation(line: 415, column: 10, scope: !3200)
!3319 = !DILocation(line: 415, column: 5, scope: !3200)
!3320 = !DILocation(line: 416, column: 5, scope: !3200)
!3321 = distinct !DISubprogram(name: "list_destroy", linkageName: "_ZL12list_destroyP10SharedList", scope: !3, file: !3, line: 372, type: !3322, scopeLine: 372, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3322 = !DISubroutineType(types: !3323)
!3323 = !{null, !3324}
!3324 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !637, size: 64)
!3325 = !DILocalVariable(name: "L", arg: 1, scope: !3321, file: !3, line: 372, type: !3324)
!3326 = !DILocation(line: 372, column: 38, scope: !3321)
!3327 = !DILocalVariable(name: "cur", scope: !3321, file: !3, line: 373, type: !362)
!3328 = !DILocation(line: 373, column: 15, scope: !3321)
!3329 = !DILocation(line: 373, column: 21, scope: !3321)
!3330 = !DILocation(line: 373, column: 24, scope: !3321)
!3331 = !DILocation(line: 374, column: 5, scope: !3321)
!3332 = !DILocation(line: 374, column: 12, scope: !3321)
!3333 = !DILocalVariable(name: "next", scope: !3334, file: !3, line: 374, type: !362)
!3334 = distinct !DILexicalBlock(scope: !3321, file: !3, line: 374, column: 17)
!3335 = !DILocation(line: 374, column: 29, scope: !3334)
!3336 = !DILocation(line: 374, column: 36, scope: !3334)
!3337 = !DILocation(line: 374, column: 41, scope: !3334)
!3338 = !DILocation(line: 374, column: 52, scope: !3334)
!3339 = !DILocation(line: 374, column: 47, scope: !3334)
!3340 = !DILocation(line: 374, column: 64, scope: !3334)
!3341 = !DILocation(line: 374, column: 62, scope: !3334)
!3342 = distinct !{!3342, !3331, !3343, !1844}
!3343 = !DILocation(line: 374, column: 70, scope: !3321)
!3344 = !DILocation(line: 375, column: 5, scope: !3321)
!3345 = !DILocation(line: 375, column: 8, scope: !3321)
!3346 = !DILocation(line: 375, column: 13, scope: !3321)
!3347 = !DILocation(line: 376, column: 1, scope: !3321)
!3348 = distinct !DISubprogram(name: "list_insert", linkageName: "_ZL11list_insertP10SharedListii", scope: !3, file: !3, line: 351, type: !3349, scopeLine: 351, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3349 = !DISubroutineType(types: !3350)
!3350 = !{null, !3324, !16, !16}
!3351 = !DILocalVariable(name: "L", arg: 1, scope: !3348, file: !3, line: 351, type: !3324)
!3352 = !DILocation(line: 351, column: 37, scope: !3348)
!3353 = !DILocalVariable(name: "key", arg: 2, scope: !3348, file: !3, line: 351, type: !16)
!3354 = !DILocation(line: 351, column: 44, scope: !3348)
!3355 = !DILocalVariable(name: "val", arg: 3, scope: !3348, file: !3, line: 351, type: !16)
!3356 = !DILocation(line: 351, column: 53, scope: !3348)
!3357 = !DILocalVariable(name: "node", scope: !3348, file: !3, line: 352, type: !362)
!3358 = !DILocation(line: 352, column: 15, scope: !3348)
!3359 = !DILocation(line: 352, column: 34, scope: !3348)
!3360 = !DILocation(line: 353, column: 17, scope: !3348)
!3361 = !DILocation(line: 353, column: 5, scope: !3348)
!3362 = !DILocation(line: 353, column: 11, scope: !3348)
!3363 = !DILocation(line: 353, column: 15, scope: !3348)
!3364 = !DILocation(line: 353, column: 36, scope: !3348)
!3365 = !DILocation(line: 353, column: 22, scope: !3348)
!3366 = !DILocation(line: 353, column: 28, scope: !3348)
!3367 = !DILocation(line: 353, column: 34, scope: !3348)
!3368 = !DILocation(line: 354, column: 28, scope: !3348)
!3369 = !DILocation(line: 354, column: 31, scope: !3348)
!3370 = !DILocation(line: 354, column: 5, scope: !3348)
!3371 = !DILocalVariable(name: "pp", scope: !3348, file: !3, line: 356, type: !3372)
!3372 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !362, size: 64)
!3373 = !DILocation(line: 356, column: 16, scope: !3348)
!3374 = !DILocation(line: 356, column: 22, scope: !3348)
!3375 = !DILocation(line: 356, column: 25, scope: !3348)
!3376 = !DILocation(line: 357, column: 5, scope: !3348)
!3377 = !DILocation(line: 357, column: 13, scope: !3348)
!3378 = !DILocation(line: 357, column: 12, scope: !3348)
!3379 = !DILocation(line: 357, column: 16, scope: !3348)
!3380 = !DILocation(line: 357, column: 21, scope: !3348)
!3381 = !DILocation(line: 357, column: 20, scope: !3348)
!3382 = !DILocation(line: 357, column: 26, scope: !3348)
!3383 = !DILocation(line: 357, column: 32, scope: !3348)
!3384 = !DILocation(line: 357, column: 30, scope: !3348)
!3385 = !DILocation(line: 0, scope: !3348)
!3386 = !DILocation(line: 357, column: 45, scope: !3348)
!3387 = !DILocation(line: 357, column: 44, scope: !3348)
!3388 = !DILocation(line: 357, column: 50, scope: !3348)
!3389 = !DILocation(line: 357, column: 40, scope: !3348)
!3390 = distinct !{!3390, !3376, !3388, !1844}
!3391 = !DILocation(line: 358, column: 19, scope: !3348)
!3392 = !DILocation(line: 358, column: 18, scope: !3348)
!3393 = !DILocation(line: 358, column: 5, scope: !3348)
!3394 = !DILocation(line: 358, column: 11, scope: !3348)
!3395 = !DILocation(line: 358, column: 16, scope: !3348)
!3396 = !DILocation(line: 359, column: 11, scope: !3348)
!3397 = !DILocation(line: 359, column: 6, scope: !3348)
!3398 = !DILocation(line: 359, column: 9, scope: !3348)
!3399 = !DILocation(line: 360, column: 28, scope: !3348)
!3400 = !DILocation(line: 360, column: 31, scope: !3348)
!3401 = !DILocation(line: 360, column: 5, scope: !3348)
!3402 = !DILocation(line: 361, column: 1, scope: !3348)
!3403 = distinct !DISubprogram(name: "list_lookup", linkageName: "_ZL11list_lookupP10SharedListi", scope: !3, file: !3, line: 363, type: !3404, scopeLine: 363, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3404 = !DISubroutineType(types: !3405)
!3405 = !{!16, !3324, !16}
!3406 = !DILocalVariable(name: "L", arg: 1, scope: !3403, file: !3, line: 363, type: !3324)
!3407 = !DILocation(line: 363, column: 36, scope: !3403)
!3408 = !DILocalVariable(name: "key", arg: 2, scope: !3403, file: !3, line: 363, type: !16)
!3409 = !DILocation(line: 363, column: 43, scope: !3403)
!3410 = !DILocation(line: 364, column: 28, scope: !3403)
!3411 = !DILocation(line: 364, column: 31, scope: !3403)
!3412 = !DILocation(line: 364, column: 5, scope: !3403)
!3413 = !DILocalVariable(name: "cur", scope: !3403, file: !3, line: 365, type: !362)
!3414 = !DILocation(line: 365, column: 15, scope: !3403)
!3415 = !DILocation(line: 365, column: 21, scope: !3403)
!3416 = !DILocation(line: 365, column: 24, scope: !3403)
!3417 = !DILocation(line: 366, column: 5, scope: !3403)
!3418 = !DILocation(line: 366, column: 12, scope: !3403)
!3419 = !DILocation(line: 366, column: 16, scope: !3403)
!3420 = !DILocation(line: 366, column: 19, scope: !3403)
!3421 = !DILocation(line: 366, column: 24, scope: !3403)
!3422 = !DILocation(line: 366, column: 30, scope: !3403)
!3423 = !DILocation(line: 366, column: 28, scope: !3403)
!3424 = !DILocation(line: 0, scope: !3403)
!3425 = !DILocation(line: 366, column: 41, scope: !3403)
!3426 = !DILocation(line: 366, column: 46, scope: !3403)
!3427 = !DILocation(line: 366, column: 39, scope: !3403)
!3428 = distinct !{!3428, !3417, !3426, !1844}
!3429 = !DILocalVariable(name: "found", scope: !3403, file: !3, line: 367, type: !16)
!3430 = !DILocation(line: 367, column: 9, scope: !3403)
!3431 = !DILocation(line: 367, column: 18, scope: !3403)
!3432 = !DILocation(line: 367, column: 22, scope: !3403)
!3433 = !DILocation(line: 367, column: 25, scope: !3403)
!3434 = !DILocation(line: 367, column: 30, scope: !3403)
!3435 = !DILocation(line: 367, column: 37, scope: !3403)
!3436 = !DILocation(line: 367, column: 34, scope: !3403)
!3437 = !DILocation(line: 367, column: 17, scope: !3403)
!3438 = !DILocation(line: 367, column: 44, scope: !3403)
!3439 = !DILocation(line: 367, column: 49, scope: !3403)
!3440 = !DILocation(line: 368, column: 28, scope: !3403)
!3441 = !DILocation(line: 368, column: 31, scope: !3403)
!3442 = !DILocation(line: 368, column: 5, scope: !3403)
!3443 = !DILocation(line: 369, column: 12, scope: !3403)
!3444 = !DILocation(line: 369, column: 5, scope: !3403)
!3445 = distinct !DISubprogram(name: "phaseD_packed", linkageName: "_ZL13phaseD_packedPv", scope: !3, file: !3, line: 488, type: !2052, scopeLine: 488, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3446 = !DILocalVariable(name: "arg", arg: 1, scope: !3445, file: !3, line: 488, type: !807)
!3447 = !DILocation(line: 488, column: 34, scope: !3445)
!3448 = !DILocalVariable(name: "a", scope: !3445, file: !3, line: 489, type: !368)
!3449 = !DILocation(line: 489, column: 18, scope: !3445)
!3450 = !DILocation(line: 489, column: 37, scope: !3445)
!3451 = !DILocalVariable(name: "t0", scope: !3445, file: !3, line: 490, type: !374)
!3452 = !DILocation(line: 490, column: 12, scope: !3445)
!3453 = !DILocation(line: 490, column: 17, scope: !3445)
!3454 = !DILocalVariable(name: "i", scope: !3455, file: !3, line: 491, type: !16)
!3455 = distinct !DILexicalBlock(scope: !3445, file: !3, line: 491, column: 5)
!3456 = !DILocation(line: 491, column: 14, scope: !3455)
!3457 = !DILocation(line: 491, column: 10, scope: !3455)
!3458 = !DILocation(line: 491, column: 21, scope: !3459)
!3459 = distinct !DILexicalBlock(scope: !3455, file: !3, line: 491, column: 5)
!3460 = !DILocation(line: 491, column: 25, scope: !3459)
!3461 = !DILocation(line: 491, column: 28, scope: !3459)
!3462 = !DILocation(line: 491, column: 23, scope: !3459)
!3463 = !DILocation(line: 491, column: 5, scope: !3455)
!3464 = !DILocation(line: 491, column: 53, scope: !3459)
!3465 = !DILocation(line: 491, column: 56, scope: !3459)
!3466 = !DILocation(line: 491, column: 40, scope: !3459)
!3467 = !DILocation(line: 491, column: 59, scope: !3459)
!3468 = !DILocation(line: 491, column: 36, scope: !3459)
!3469 = !DILocation(line: 491, column: 5, scope: !3459)
!3470 = distinct !{!3470, !3463, !3471, !1844}
!3471 = !DILocation(line: 491, column: 59, scope: !3455)
!3472 = !DILocation(line: 492, column: 25, scope: !3445)
!3473 = !DILocation(line: 492, column: 36, scope: !3445)
!3474 = !DILocation(line: 492, column: 34, scope: !3445)
!3475 = !DILocation(line: 492, column: 5, scope: !3445)
!3476 = !DILocation(line: 492, column: 8, scope: !3445)
!3477 = !DILocation(line: 492, column: 23, scope: !3445)
!3478 = !DILocation(line: 493, column: 5, scope: !3445)
!3479 = distinct !DISubprogram(name: "phaseD_padded", linkageName: "_ZL13phaseD_paddedPv", scope: !3, file: !3, line: 496, type: !2052, scopeLine: 496, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !1767)
!3480 = !DILocalVariable(name: "arg", arg: 1, scope: !3479, file: !3, line: 496, type: !807)
!3481 = !DILocation(line: 496, column: 34, scope: !3479)
!3482 = !DILocalVariable(name: "a", scope: !3479, file: !3, line: 497, type: !368)
!3483 = !DILocation(line: 497, column: 18, scope: !3479)
!3484 = !DILocation(line: 497, column: 37, scope: !3479)
!3485 = !DILocalVariable(name: "t0", scope: !3479, file: !3, line: 498, type: !374)
!3486 = !DILocation(line: 498, column: 12, scope: !3479)
!3487 = !DILocation(line: 498, column: 17, scope: !3479)
!3488 = !DILocalVariable(name: "i", scope: !3489, file: !3, line: 499, type: !16)
!3489 = distinct !DILexicalBlock(scope: !3479, file: !3, line: 499, column: 5)
!3490 = !DILocation(line: 499, column: 14, scope: !3489)
!3491 = !DILocation(line: 499, column: 10, scope: !3489)
!3492 = !DILocation(line: 499, column: 21, scope: !3493)
!3493 = distinct !DILexicalBlock(scope: !3489, file: !3, line: 499, column: 5)
!3494 = !DILocation(line: 499, column: 25, scope: !3493)
!3495 = !DILocation(line: 499, column: 28, scope: !3493)
!3496 = !DILocation(line: 499, column: 23, scope: !3493)
!3497 = !DILocation(line: 499, column: 5, scope: !3489)
!3498 = !DILocation(line: 499, column: 49, scope: !3493)
!3499 = !DILocation(line: 499, column: 52, scope: !3493)
!3500 = !DILocation(line: 499, column: 40, scope: !3493)
!3501 = !DILocation(line: 499, column: 56, scope: !3493)
!3502 = !DILocation(line: 499, column: 59, scope: !3493)
!3503 = !DILocation(line: 499, column: 36, scope: !3493)
!3504 = !DILocation(line: 499, column: 5, scope: !3493)
!3505 = distinct !{!3505, !3497, !3506, !1844}
!3506 = !DILocation(line: 499, column: 59, scope: !3489)
!3507 = !DILocation(line: 500, column: 25, scope: !3479)
!3508 = !DILocation(line: 500, column: 36, scope: !3479)
!3509 = !DILocation(line: 500, column: 34, scope: !3479)
!3510 = !DILocation(line: 500, column: 5, scope: !3479)
!3511 = !DILocation(line: 500, column: 8, scope: !3479)
!3512 = !DILocation(line: 500, column: 23, scope: !3479)
!3513 = !DILocation(line: 501, column: 5, scope: !3479)
!3514 = distinct !DISubprogram(name: "operator()", linkageName: "_ZZL13print_summaryllllllllENK3$_0clEll", scope: !2775, file: !3, line: 577, type: !2778, scopeLine: 577, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, declaration: !2777, retainedNodes: !1767)
!3515 = !DILocalVariable(name: "this", arg: 1, scope: !3514, type: !3516, flags: DIFlagArtificial | DIFlagObjectPointer)
!3516 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !2781, size: 64)
!3517 = !DILocation(line: 0, scope: !3514)
!3518 = !DILocalVariable(name: "s", arg: 2, scope: !3514, file: !3, line: 577, type: !124)
!3519 = !DILocation(line: 577, column: 24, scope: !3514)
!3520 = !DILocalVariable(name: "p", arg: 3, scope: !3514, file: !3, line: 577, type: !124)
!3521 = !DILocation(line: 577, column: 32, scope: !3514)
!3522 = !DILocation(line: 578, column: 17, scope: !3514)
!3523 = !DILocation(line: 578, column: 19, scope: !3514)
!3524 = !DILocation(line: 578, column: 18, scope: !3514)
!3525 = !DILocation(line: 578, column: 22, scope: !3514)
!3526 = !DILocation(line: 578, column: 16, scope: !3514)
!3527 = !DILocation(line: 578, column: 34, scope: !3514)
!3528 = !DILocation(line: 578, column: 33, scope: !3514)
!3529 = !DILocation(line: 578, column: 37, scope: !3514)
!3530 = !DILocation(line: 578, column: 39, scope: !3514)
!3531 = !DILocation(line: 578, column: 38, scope: !3514)
!3532 = !DILocation(line: 578, column: 36, scope: !3514)
!3533 = !DILocation(line: 578, column: 35, scope: !3514)
!3534 = !DILocation(line: 578, column: 9, scope: !3514)
