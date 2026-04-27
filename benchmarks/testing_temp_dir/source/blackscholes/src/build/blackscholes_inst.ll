; ModuleID = 'build/blackscholes.ll'
source_filename = "blackscholes.m4.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutexattr_t = type { i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.OptionData_ = type { float, float, float, float, float, float, i8, float, float }

@_M4_threadsTable = dso_local global [128 x i64] zeroinitializer, align 16, !dbg !0
@_M4_normalMutexAttr = dso_local global %union.pthread_mutexattr_t zeroinitializer, align 4, !dbg !32
@_M4_numThreads = dso_local local_unnamed_addr global i32 128, align 4, !dbg !43
@data = dso_local local_unnamed_addr global ptr null, align 8, !dbg !45
@prices = dso_local local_unnamed_addr global ptr null, align 8, !dbg !47
@numOptions = dso_local global i32 0, align 4, !dbg !49
@otype = dso_local local_unnamed_addr global ptr null, align 8, !dbg !51
@sptprice = dso_local local_unnamed_addr global ptr null, align 8, !dbg !53
@strike = dso_local local_unnamed_addr global ptr null, align 8, !dbg !55
@rate = dso_local local_unnamed_addr global ptr null, align 8, !dbg !57
@volatility = dso_local local_unnamed_addr global ptr null, align 8, !dbg !59
@otime = dso_local local_unnamed_addr global ptr null, align 8, !dbg !61
@numError = dso_local local_unnamed_addr global i32 0, align 4, !dbg !63
@nThreads = dso_local local_unnamed_addr global i32 0, align 4, !dbg !65
@.str = private unnamed_addr constant [8 x i8] c"%s: %f\0A\00", align 1, !dbg !67
@myMutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !73
@myGlobal = dso_local global i32 1, align 4, !dbg !105
@.str.1 = private unnamed_addr constant [12 x i8] c"myGlobal==1\00", align 1, !dbg !108
@.str.2 = private unnamed_addr constant [20 x i8] c"blackscholes.m4.cpp\00", align 1
@__PRETTY_FUNCTION__._Z9bs_threadPv = private unnamed_addr constant [22 x i8] c"int bs_thread(void *)\00", align 1, !dbg !113
@.str.4 = private unnamed_addr constant [48 x i8] c"Usage:\0A\09%s <nthreads> <inputFile> <outputFile>\0A\00", align 1, !dbg !123
@.str.5 = private unnamed_addr constant [2 x i8] c"r\00", align 1, !dbg !128
@.str.6 = private unnamed_addr constant [32 x i8] c"ERROR: Unable to open file %s.\0A\00", align 1, !dbg !133
@.str.7 = private unnamed_addr constant [3 x i8] c"%i\00", align 1, !dbg !138
@.str.8 = private unnamed_addr constant [37 x i8] c"ERROR: Unable to read from file %s.\0A\00", align 1, !dbg !143
@.str.10 = private unnamed_addr constant [27 x i8] c"%f %f %f %f %f %f %c %f %f\00", align 1, !dbg !153
@.str.11 = private unnamed_addr constant [33 x i8] c"ERROR: Unable to close file %s.\0A\00", align 1, !dbg !158
@.str.12 = private unnamed_addr constant [20 x i8] c"Num of Options: %d\0A\00", align 1, !dbg !163
@.str.13 = private unnamed_addr constant [17 x i8] c"Num of Runs: %d\0A\00", align 1, !dbg !168
@.str.14 = private unnamed_addr constant [18 x i8] c"Size of data: %d\0A\00", align 1, !dbg !173
@.str.15 = private unnamed_addr constant [2 x i8] c"w\00", align 1, !dbg !178
@.str.16 = private unnamed_addr constant [4 x i8] c"%i\0A\00", align 1, !dbg !180
@.str.17 = private unnamed_addr constant [36 x i8] c"ERROR: Unable to write to file %s.\0A\00", align 1, !dbg !183
@.str.18 = private unnamed_addr constant [7 x i8] c"%.18f\0A\00", align 1, !dbg !188
@str = private unnamed_addr constant [23 x i8] c"PARSEC Benchmark Suite\00", align 1
@str.19 = private unnamed_addr constant [81 x i8] c"WARNING: Not enough work, reducing number of threads to match number of options.\00", align 1
@0 = private unnamed_addr constant [11 x i8] c"numOptions\00", align 1
@1 = private unnamed_addr constant [9 x i8] c"nThreads\00", align 1
@2 = private unnamed_addr constant [8 x i8] c"unknown\00", align 1
@3 = private unnamed_addr constant [9 x i8] c"myGlobal\00", align 1
@4 = private unnamed_addr constant [9 x i8] c"sptprice\00", align 1
@5 = private unnamed_addr constant [7 x i8] c"strike\00", align 1
@6 = private unnamed_addr constant [5 x i8] c"rate\00", align 1
@7 = private unnamed_addr constant [11 x i8] c"volatility\00", align 1
@8 = private unnamed_addr constant [6 x i8] c"otime\00", align 1
@9 = private unnamed_addr constant [6 x i8] c"otype\00", align 1
@10 = private unnamed_addr constant [7 x i8] c"prices\00", align 1
@11 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@12 = private unnamed_addr constant [17 x i8] c"_M4_threadsTable\00", align 1
@13 = private unnamed_addr constant [15 x i8] c"_M4_numThreads\00", align 1

; Function Attrs: mustprogress nofree nounwind willreturn memory(write) uwtable
define dso_local noundef float @_Z4CNDFf(float noundef %0) local_unnamed_addr #0 !dbg !881 {
    #dbg_value(float %0, !883, !DIExpression(), !898)
  %2 = fcmp uge float %0, 0.000000e+00, !dbg !899
  %3 = fneg float %0, !dbg !899
  %4 = select i1 %2, float %0, float %3, !dbg !899
    #dbg_value(float %4, !883, !DIExpression(), !898)
    #dbg_value(i32 poison, !884, !DIExpression(), !898)
    #dbg_value(float %4, !886, !DIExpression(), !898)
  %5 = fmul float %4, -5.000000e-01, !dbg !901
  %6 = fmul float %4, %5, !dbg !902
    #dbg_value(float %6, !903, !DIExpression(), !906)
  %7 = tail call noundef float @expf(float noundef %6) #16, !dbg !908, !tbaa !909
    #dbg_value(float %7, !888, !DIExpression(), !898)
    #dbg_value(float %7, !887, !DIExpression(), !898)
  %8 = fpext float %7 to double, !dbg !913
  %9 = fmul double %8, 0x3FD9884533D43651, !dbg !914
  %10 = fptrunc double %9 to float, !dbg !913
    #dbg_value(float %10, !887, !DIExpression(), !898)
  %11 = fpext float %4 to double, !dbg !915
  %12 = fmul double %11, 0x3FCDA6711871100E, !dbg !916
  %13 = fptrunc double %12 to float, !dbg !917
    #dbg_value(float %13, !889, !DIExpression(), !898)
  %14 = fadd float %13, 1.000000e+00, !dbg !918
    #dbg_value(float %14, !889, !DIExpression(), !898)
  %15 = fdiv float 1.000000e+00, %14, !dbg !919
    #dbg_value(float %15, !889, !DIExpression(), !898)
  %16 = fmul float %15, %15, !dbg !920
    #dbg_value(float %16, !890, !DIExpression(), !898)
  %17 = fmul float %15, %16, !dbg !921
    #dbg_value(float %17, !891, !DIExpression(), !898)
  %18 = fmul float %15, %17, !dbg !922
    #dbg_value(float %18, !892, !DIExpression(), !898)
  %19 = fmul float %15, %18, !dbg !923
    #dbg_value(float %19, !893, !DIExpression(), !898)
  %20 = fpext float %15 to double, !dbg !924
  %21 = fmul double %20, 0x3FD470BF3A92F8EC, !dbg !925
  %22 = fptrunc double %21 to float, !dbg !924
    #dbg_value(float %22, !895, !DIExpression(), !898)
  %23 = fpext float %16 to double, !dbg !926
  %24 = fmul double %23, 0xBFD6D1F0E5A8325B, !dbg !927
  %25 = fptrunc double %24 to float, !dbg !926
    #dbg_value(float %25, !896, !DIExpression(), !898)
  %26 = fpext float %17 to double, !dbg !928
  %27 = fmul double %26, 0x3FFC80EF025F5E68, !dbg !929
  %28 = fptrunc double %27 to float, !dbg !928
    #dbg_value(float %28, !897, !DIExpression(), !898)
  %29 = fadd float %25, %28, !dbg !930
    #dbg_value(float %29, !896, !DIExpression(), !898)
  %30 = fpext float %18 to double, !dbg !931
  %31 = fmul double %30, 0xBFFD23DD4EF278D0, !dbg !932
  %32 = fptrunc double %31 to float, !dbg !931
    #dbg_value(float %32, !897, !DIExpression(), !898)
  %33 = fadd float %29, %32, !dbg !933
    #dbg_value(float %33, !896, !DIExpression(), !898)
  %34 = fpext float %19 to double, !dbg !934
  %35 = fmul double %34, 0x3FF548CDD6F42943, !dbg !935
  %36 = fptrunc double %35 to float, !dbg !934
    #dbg_value(float %36, !897, !DIExpression(), !898)
  %37 = fadd float %33, %36, !dbg !936
    #dbg_value(float %37, !896, !DIExpression(), !898)
  %38 = fadd float %37, %22, !dbg !937
    #dbg_value(float %38, !895, !DIExpression(), !898)
  %39 = fmul float %38, %10, !dbg !938
    #dbg_value(float %39, !894, !DIExpression(), !898)
  %40 = fsub float 1.000000e+00, %39, !dbg !939
    #dbg_value(float %40, !894, !DIExpression(), !898)
    #dbg_value(float %40, !885, !DIExpression(), !898)
  %41 = fsub float 1.000000e+00, %40, !dbg !940
  %42 = select i1 %2, float %40, float %41, !dbg !940
    #dbg_value(float %42, !885, !DIExpression(), !898)
  ret float %42, !dbg !942
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nofree nounwind uwtable
define dso_local void @_Z9print_xmmfPc(float noundef %0, ptr noundef %1) local_unnamed_addr #2 !dbg !943 {
    #dbg_value(float %0, !947, !DIExpression(), !949)
    #dbg_value(ptr %1, !948, !DIExpression(), !949)
  %3 = fpext float %0 to double, !dbg !950
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, ptr noundef %1, double noundef %3), !dbg !951
  ret void, !dbg !952
}

; Function Attrs: nofree nounwind
declare !dbg !953 noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #3

; Function Attrs: mustprogress nofree nounwind willreturn memory(write) uwtable
define dso_local noundef float @_Z19BlkSchlsEqEuroNoDivfffffif(float noundef %0, float noundef %1, float noundef %2, float noundef %3, float noundef %4, i32 noundef %5, float %6) local_unnamed_addr #0 !dbg !957 {
    #dbg_value(float %0, !961, !DIExpression(), !988)
    #dbg_value(float %1, !962, !DIExpression(), !988)
    #dbg_value(float %2, !963, !DIExpression(), !988)
    #dbg_value(float %3, !964, !DIExpression(), !988)
    #dbg_value(float %4, !965, !DIExpression(), !988)
    #dbg_value(i32 %5, !966, !DIExpression(), !988)
    #dbg_value(float poison, !967, !DIExpression(), !988)
    #dbg_value(float %0, !969, !DIExpression(), !988)
    #dbg_value(float %1, !970, !DIExpression(), !988)
    #dbg_value(float %2, !971, !DIExpression(), !988)
    #dbg_value(float %3, !972, !DIExpression(), !988)
    #dbg_value(float %4, !973, !DIExpression(), !988)
    #dbg_value(float %4, !989, !DIExpression(), !992)
  %8 = tail call noundef float @sqrtf(float noundef %4) #16, !dbg !994, !tbaa !909
    #dbg_value(float %8, !974, !DIExpression(), !988)
  %9 = fdiv float %0, %1, !dbg !995
    #dbg_value(float %9, !996, !DIExpression(), !999)
  %10 = tail call noundef float @logf(float noundef %9) #16, !dbg !1001, !tbaa !909
    #dbg_value(float %10, !975, !DIExpression(), !988)
    #dbg_value(float %10, !976, !DIExpression(), !988)
  %11 = fmul float %3, %3, !dbg !1002
    #dbg_value(float %11, !979, !DIExpression(), !988)
  %12 = fmul float %11, 5.000000e-01, !dbg !1003
    #dbg_value(float %12, !979, !DIExpression(), !988)
  %13 = fadd float %2, %12, !dbg !1004
    #dbg_value(float %13, !977, !DIExpression(), !988)
  %14 = fmul float %4, %13, !dbg !1005
    #dbg_value(float %14, !977, !DIExpression(), !988)
  %15 = fadd float %14, %10, !dbg !1006
    #dbg_value(float %15, !977, !DIExpression(), !988)
  %16 = fmul float %3, %8, !dbg !1007
    #dbg_value(float %16, !980, !DIExpression(), !988)
  %17 = fdiv float %15, %16, !dbg !1008
    #dbg_value(float %17, !977, !DIExpression(), !988)
  %18 = fsub float %17, %16, !dbg !1009
    #dbg_value(float %18, !978, !DIExpression(), !988)
    #dbg_value(float %17, !981, !DIExpression(), !988)
    #dbg_value(float %18, !982, !DIExpression(), !988)
    #dbg_value(float %17, !883, !DIExpression(), !1010)
  %19 = fcmp uge float %17, 0.000000e+00, !dbg !1012
  %20 = fneg float %17, !dbg !1012
  %21 = select i1 %19, float %17, float %20, !dbg !1012
    #dbg_value(float %21, !883, !DIExpression(), !1010)
    #dbg_value(i32 poison, !884, !DIExpression(), !1010)
    #dbg_value(float %21, !886, !DIExpression(), !1010)
  %22 = fmul float %21, -5.000000e-01, !dbg !1013
  %23 = fmul float %21, %22, !dbg !1014
    #dbg_value(float %23, !903, !DIExpression(), !1015)
  %24 = tail call noundef float @expf(float noundef %23) #16, !dbg !1017, !tbaa !909
    #dbg_value(float %24, !888, !DIExpression(), !1010)
    #dbg_value(float %24, !887, !DIExpression(), !1010)
  %25 = fpext float %24 to double, !dbg !1018
  %26 = fmul double %25, 0x3FD9884533D43651, !dbg !1019
  %27 = fptrunc double %26 to float, !dbg !1018
    #dbg_value(float %27, !887, !DIExpression(), !1010)
  %28 = fpext float %21 to double, !dbg !1020
  %29 = fmul double %28, 0x3FCDA6711871100E, !dbg !1021
  %30 = fptrunc double %29 to float, !dbg !1022
    #dbg_value(float %30, !889, !DIExpression(), !1010)
  %31 = fadd float %30, 1.000000e+00, !dbg !1023
    #dbg_value(float %31, !889, !DIExpression(), !1010)
  %32 = fdiv float 1.000000e+00, %31, !dbg !1024
    #dbg_value(float %32, !889, !DIExpression(), !1010)
  %33 = fmul float %32, %32, !dbg !1025
    #dbg_value(float %33, !890, !DIExpression(), !1010)
  %34 = fmul float %32, %33, !dbg !1026
    #dbg_value(float %34, !891, !DIExpression(), !1010)
  %35 = fmul float %32, %34, !dbg !1027
    #dbg_value(float %35, !892, !DIExpression(), !1010)
  %36 = fmul float %32, %35, !dbg !1028
    #dbg_value(float %36, !893, !DIExpression(), !1010)
  %37 = fpext float %32 to double, !dbg !1029
  %38 = fmul double %37, 0x3FD470BF3A92F8EC, !dbg !1030
  %39 = fptrunc double %38 to float, !dbg !1029
    #dbg_value(float %39, !895, !DIExpression(), !1010)
  %40 = fpext float %33 to double, !dbg !1031
  %41 = fmul double %40, 0xBFD6D1F0E5A8325B, !dbg !1032
  %42 = fptrunc double %41 to float, !dbg !1031
    #dbg_value(float %42, !896, !DIExpression(), !1010)
  %43 = fpext float %34 to double, !dbg !1033
  %44 = fmul double %43, 0x3FFC80EF025F5E68, !dbg !1034
  %45 = fptrunc double %44 to float, !dbg !1033
    #dbg_value(float %45, !897, !DIExpression(), !1010)
  %46 = fadd float %42, %45, !dbg !1035
    #dbg_value(float %46, !896, !DIExpression(), !1010)
  %47 = fpext float %35 to double, !dbg !1036
  %48 = fmul double %47, 0xBFFD23DD4EF278D0, !dbg !1037
  %49 = fptrunc double %48 to float, !dbg !1036
    #dbg_value(float %49, !897, !DIExpression(), !1010)
  %50 = fadd float %46, %49, !dbg !1038
    #dbg_value(float %50, !896, !DIExpression(), !1010)
  %51 = fpext float %36 to double, !dbg !1039
  %52 = fmul double %51, 0x3FF548CDD6F42943, !dbg !1040
  %53 = fptrunc double %52 to float, !dbg !1039
    #dbg_value(float %53, !897, !DIExpression(), !1010)
  %54 = fadd float %50, %53, !dbg !1041
    #dbg_value(float %54, !896, !DIExpression(), !1010)
  %55 = fadd float %54, %39, !dbg !1042
    #dbg_value(float %55, !895, !DIExpression(), !1010)
  %56 = fmul float %55, %27, !dbg !1043
    #dbg_value(float %56, !894, !DIExpression(), !1010)
  %57 = fsub float 1.000000e+00, %56, !dbg !1044
    #dbg_value(float %57, !894, !DIExpression(), !1010)
    #dbg_value(float %57, !885, !DIExpression(), !1010)
  %58 = fsub float 1.000000e+00, %57, !dbg !1045
  %59 = select i1 %19, float %57, float %58, !dbg !1045
    #dbg_value(float %59, !885, !DIExpression(), !1010)
    #dbg_value(float %59, !984, !DIExpression(), !988)
    #dbg_value(float %18, !883, !DIExpression(), !1046)
  %60 = fcmp uge float %18, 0.000000e+00, !dbg !1048
  %61 = fneg float %18, !dbg !1048
  %62 = select i1 %60, float %18, float %61, !dbg !1048
    #dbg_value(float %62, !883, !DIExpression(), !1046)
    #dbg_value(i32 poison, !884, !DIExpression(), !1046)
    #dbg_value(float %62, !886, !DIExpression(), !1046)
  %63 = fmul float %62, -5.000000e-01, !dbg !1049
  %64 = fmul float %62, %63, !dbg !1050
    #dbg_value(float %64, !903, !DIExpression(), !1051)
  %65 = tail call noundef float @expf(float noundef %64) #16, !dbg !1053, !tbaa !909
    #dbg_value(float %65, !888, !DIExpression(), !1046)
    #dbg_value(float %65, !887, !DIExpression(), !1046)
  %66 = fpext float %65 to double, !dbg !1054
  %67 = fmul double %66, 0x3FD9884533D43651, !dbg !1055
  %68 = fptrunc double %67 to float, !dbg !1054
    #dbg_value(float %68, !887, !DIExpression(), !1046)
  %69 = fpext float %62 to double, !dbg !1056
  %70 = fmul double %69, 0x3FCDA6711871100E, !dbg !1057
  %71 = fptrunc double %70 to float, !dbg !1058
    #dbg_value(float %71, !889, !DIExpression(), !1046)
  %72 = fadd float %71, 1.000000e+00, !dbg !1059
    #dbg_value(float %72, !889, !DIExpression(), !1046)
  %73 = fdiv float 1.000000e+00, %72, !dbg !1060
    #dbg_value(float %73, !889, !DIExpression(), !1046)
  %74 = fmul float %73, %73, !dbg !1061
    #dbg_value(float %74, !890, !DIExpression(), !1046)
  %75 = fmul float %73, %74, !dbg !1062
    #dbg_value(float %75, !891, !DIExpression(), !1046)
  %76 = fmul float %73, %75, !dbg !1063
    #dbg_value(float %76, !892, !DIExpression(), !1046)
  %77 = fmul float %73, %76, !dbg !1064
    #dbg_value(float %77, !893, !DIExpression(), !1046)
  %78 = fpext float %73 to double, !dbg !1065
  %79 = fmul double %78, 0x3FD470BF3A92F8EC, !dbg !1066
  %80 = fptrunc double %79 to float, !dbg !1065
    #dbg_value(float %80, !895, !DIExpression(), !1046)
  %81 = fpext float %74 to double, !dbg !1067
  %82 = fmul double %81, 0xBFD6D1F0E5A8325B, !dbg !1068
  %83 = fptrunc double %82 to float, !dbg !1067
    #dbg_value(float %83, !896, !DIExpression(), !1046)
  %84 = fpext float %75 to double, !dbg !1069
  %85 = fmul double %84, 0x3FFC80EF025F5E68, !dbg !1070
  %86 = fptrunc double %85 to float, !dbg !1069
    #dbg_value(float %86, !897, !DIExpression(), !1046)
  %87 = fadd float %83, %86, !dbg !1071
    #dbg_value(float %87, !896, !DIExpression(), !1046)
  %88 = fpext float %76 to double, !dbg !1072
  %89 = fmul double %88, 0xBFFD23DD4EF278D0, !dbg !1073
  %90 = fptrunc double %89 to float, !dbg !1072
    #dbg_value(float %90, !897, !DIExpression(), !1046)
  %91 = fadd float %87, %90, !dbg !1074
    #dbg_value(float %91, !896, !DIExpression(), !1046)
  %92 = fpext float %77 to double, !dbg !1075
  %93 = fmul double %92, 0x3FF548CDD6F42943, !dbg !1076
  %94 = fptrunc double %93 to float, !dbg !1075
    #dbg_value(float %94, !897, !DIExpression(), !1046)
  %95 = fadd float %91, %94, !dbg !1077
    #dbg_value(float %95, !896, !DIExpression(), !1046)
  %96 = fadd float %95, %80, !dbg !1078
    #dbg_value(float %96, !895, !DIExpression(), !1046)
  %97 = fmul float %96, %68, !dbg !1079
    #dbg_value(float %97, !894, !DIExpression(), !1046)
  %98 = fsub float 1.000000e+00, %97, !dbg !1080
    #dbg_value(float %98, !894, !DIExpression(), !1046)
    #dbg_value(float %98, !885, !DIExpression(), !1046)
  %99 = fsub float 1.000000e+00, %98, !dbg !1081
  %100 = select i1 %60, float %98, float %99, !dbg !1081
    #dbg_value(float %100, !885, !DIExpression(), !1046)
    #dbg_value(float %100, !985, !DIExpression(), !988)
  %101 = fneg float %2, !dbg !1082
  %102 = fmul float %4, %101, !dbg !1083
    #dbg_value(float %102, !903, !DIExpression(), !1084)
  %103 = tail call noundef float @expf(float noundef %102) #16, !dbg !1086, !tbaa !909
  %104 = fmul float %1, %103, !dbg !1087
    #dbg_value(float %104, !983, !DIExpression(), !988)
  %105 = icmp eq i32 %5, 0, !dbg !1088
  br i1 %105, label %106, label %110, !dbg !1088

106:                                              ; preds = %7
  %107 = fneg float %100, !dbg !1090
  %108 = fmul float %104, %107, !dbg !1090
  %109 = tail call float @llvm.fmuladd.f32(float %0, float %59, float %108), !dbg !1090
    #dbg_value(float %109, !968, !DIExpression(), !988)
  br label %116, !dbg !1092

110:                                              ; preds = %7
  %111 = fsub float 1.000000e+00, %59, !dbg !1093
    #dbg_value(float %111, !986, !DIExpression(), !988)
  %112 = fsub float 1.000000e+00, %100, !dbg !1095
    #dbg_value(float %112, !987, !DIExpression(), !988)
  %113 = fneg float %111, !dbg !1096
  %114 = fmul float %0, %113, !dbg !1096
  %115 = tail call float @llvm.fmuladd.f32(float %104, float %112, float %114), !dbg !1096
    #dbg_value(float %115, !968, !DIExpression(), !988)
  br label %116

116:                                              ; preds = %110, %106
  %117 = phi float [ %109, %106 ], [ %115, %110 ], !dbg !1097
    #dbg_value(float %117, !968, !DIExpression(), !988)
  ret float %117, !dbg !1098
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #4

; Function Attrs: mustprogress nounwind uwtable
define dso_local noundef i32 @_Z9bs_threadPv(ptr nocapture noundef readonly %0) #5 !dbg !1099 {
    #dbg_value(ptr %0, !1103, !DIExpression(), !1122)
    #dbg_value(i32 poison, !1108, !DIExpression(), !1122)
  call void @__ft_read(ptr @numOptions, i32 314, ptr @0), !dbg !1123
  %2 = load i32, ptr @numOptions, align 4, !dbg !1123, !tbaa !909
  call void @__ft_read(ptr @nThreads, i32 314, ptr @1), !dbg !1124
  %3 = load i32, ptr @nThreads, align 4, !dbg !1124, !tbaa !909
  %4 = sdiv i32 %2, %3, !dbg !1125
    #dbg_value(!DIArgList(i32 poison, i32 poison), !1109, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_mul, DW_OP_stack_value), !1122)
    #dbg_value(!DIArgList(i32 poison, i32 poison, i32 poison), !1110, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_mul, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !1122)
    #dbg_value(i32 0, !1105, !DIExpression(), !1122)
    #dbg_value(i32 poison, !1105, !DIExpression(), !1122)
    #dbg_value(!DIArgList(i32 poison, i32 poison), !1104, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_mul, DW_OP_stack_value), !1122)
  %5 = icmp sgt i32 %4, 0, !dbg !1126
  br i1 %5, label %6, label %63, !dbg !1127

6:                                                ; preds = %1
  call void @__ft_read(ptr %0, i32 313, ptr @2), !dbg !1128
  %7 = load i32, ptr %0, align 4, !dbg !1128, !tbaa !909
    #dbg_value(i32 %7, !1108, !DIExpression(), !1122)
    #dbg_value(!DIArgList(i32 %4, i32 %4, i32 %7), !1110, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_mul, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !1122)
    #dbg_value(!DIArgList(i32 %4, i32 %7), !1104, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_mul, DW_OP_stack_value), !1122)
    #dbg_value(!DIArgList(i32 %4, i32 %7), !1109, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_mul, DW_OP_stack_value), !1122)
  %8 = mul i32 %4, %7, !dbg !1129
    #dbg_value(!DIArgList(i32 %8, i32 %4), !1110, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !1122)
    #dbg_value(i32 %8, !1109, !DIExpression(), !1122)
    #dbg_value(i32 %8, !1104, !DIExpression(), !1122)
  %9 = add nsw i32 %8, %4, !dbg !1130
    #dbg_value(i32 %9, !1110, !DIExpression(), !1122)
  %10 = add nsw i32 %9, -1
  %11 = icmp eq i32 %7, 0
  %12 = icmp eq i32 %7, 3
  %13 = sext i32 %8 to i64, !dbg !1127
  %14 = sext i32 %9 to i64, !dbg !1127
  %15 = sext i32 %10 to i64, !dbg !1131
  %16 = sext i32 %8 to i64, !dbg !1132
  br label %17, !dbg !1127

17:                                               ; preds = %39, %6
  %18 = phi i64 [ %13, %6 ], [ %61, %39 ]
    #dbg_value(i64 %18, !1104, !DIExpression(), !1122)
  %19 = icmp eq i64 %18, %15, !dbg !1131
    #dbg_value(i1 %19, !1111, !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !1133)
  %20 = icmp eq i64 %18, %16, !dbg !1132
    #dbg_value(i1 %20, !1118, !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !1133)
  %21 = and i1 %11, %19, !dbg !1134
  br i1 %21, label %22, label %25, !dbg !1134

22:                                               ; preds = %17
  %23 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @myMutex) #16, !dbg !1136
  call void @__ft_lock(ptr @myMutex), !dbg !1138
  call void @__ft_write(ptr @myGlobal, i32 328, ptr @3), !dbg !1138
  store volatile i32 0, ptr @myGlobal, align 4, !dbg !1138, !tbaa !909
  call void @__ft_unlock(ptr @myMutex), !dbg !1139
  %24 = tail call i32 @pthread_mutex_unlock(ptr noundef nonnull @myMutex) #16, !dbg !1139
  br label %25, !dbg !1140

25:                                               ; preds = %22, %17
  %26 = and i1 %12, %20, !dbg !1141
  br i1 %26, label %27, label %39, !dbg !1141

27:                                               ; preds = %25
  %28 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @myMutex) #16, !dbg !1142
  call void @__ft_lock(ptr @myMutex), !dbg !1143
  call void @__ft_read(ptr @myGlobal, i32 334, ptr @3), !dbg !1143
  %29 = load volatile i32, ptr @myGlobal, align 4, !dbg !1143, !tbaa !909
    #dbg_value(i32 %29, !1119, !DIExpression(), !1144)
  call void @__ft_unlock(ptr @myMutex), !dbg !1145
  %30 = tail call i32 @pthread_mutex_unlock(ptr noundef nonnull @myMutex) #16, !dbg !1145
  %31 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull @myMutex) #16, !dbg !1146
  call void @__ft_lock(ptr @myMutex), !dbg !1147
  %32 = icmp eq i32 %29, 1, !dbg !1147
  br i1 %32, label %33, label %37, !dbg !1147

33:                                               ; preds = %27
  call void @__ft_read(ptr @myGlobal, i32 338, ptr @3), !dbg !1149
  %34 = load volatile i32, ptr @myGlobal, align 4, !dbg !1149, !tbaa !909
  %35 = icmp eq i32 %34, 1, !dbg !1149
  br i1 %35, label %37, label %36, !dbg !1149

36:                                               ; preds = %33
  tail call void @__assert_fail(ptr noundef nonnull @.str.1, ptr noundef nonnull @.str.2, i32 noundef 338, ptr noundef nonnull @__PRETTY_FUNCTION__._Z9bs_threadPv) #17, !dbg !1149
  unreachable, !dbg !1149

37:                                               ; preds = %33, %27
  call void @__ft_unlock(ptr @myMutex), !dbg !1151
  %38 = tail call i32 @pthread_mutex_unlock(ptr noundef nonnull @myMutex) #16, !dbg !1151
  br label %39, !dbg !1152

39:                                               ; preds = %37, %25
  call void @__ft_read(ptr @sptprice, i32 345, ptr @4), !dbg !1153
  %40 = load ptr, ptr @sptprice, align 8, !dbg !1153, !tbaa !1154
  %41 = getelementptr inbounds float, ptr %40, i64 %18, !dbg !1153
  call void @__ft_read(ptr %41, i32 345, ptr @2), !dbg !1153
  %42 = load float, ptr %41, align 4, !dbg !1153, !tbaa !1157
  call void @__ft_read(ptr @strike, i32 345, ptr @5), !dbg !1159
  %43 = load ptr, ptr @strike, align 8, !dbg !1159, !tbaa !1154
  %44 = getelementptr inbounds float, ptr %43, i64 %18, !dbg !1159
  call void @__ft_read(ptr %44, i32 345, ptr @2), !dbg !1159
  %45 = load float, ptr %44, align 4, !dbg !1159, !tbaa !1157
  call void @__ft_read(ptr @rate, i32 346, ptr @6), !dbg !1160
  %46 = load ptr, ptr @rate, align 8, !dbg !1160, !tbaa !1154
  %47 = getelementptr inbounds float, ptr %46, i64 %18, !dbg !1160
  call void @__ft_read(ptr %47, i32 346, ptr @2), !dbg !1160
  %48 = load float, ptr %47, align 4, !dbg !1160, !tbaa !1157
  call void @__ft_read(ptr @volatility, i32 346, ptr @7), !dbg !1161
  %49 = load ptr, ptr @volatility, align 8, !dbg !1161, !tbaa !1154
  %50 = getelementptr inbounds float, ptr %49, i64 %18, !dbg !1161
  call void @__ft_read(ptr %50, i32 346, ptr @2), !dbg !1161
  %51 = load float, ptr %50, align 4, !dbg !1161, !tbaa !1157
  call void @__ft_read(ptr @otime, i32 346, ptr @8), !dbg !1162
  %52 = load ptr, ptr @otime, align 8, !dbg !1162, !tbaa !1154
  %53 = getelementptr inbounds float, ptr %52, i64 %18, !dbg !1162
  call void @__ft_read(ptr %53, i32 346, ptr @2), !dbg !1162
  %54 = load float, ptr %53, align 4, !dbg !1162, !tbaa !1157
  call void @__ft_read(ptr @otype, i32 347, ptr @9), !dbg !1163
  %55 = load ptr, ptr @otype, align 8, !dbg !1163, !tbaa !1164
  %56 = getelementptr inbounds i32, ptr %55, i64 %18, !dbg !1163
  call void @__ft_read(ptr %56, i32 347, ptr @2), !dbg !1163
  %57 = load i32, ptr %56, align 4, !dbg !1163, !tbaa !909
  %58 = tail call noundef float @_Z19BlkSchlsEqEuroNoDivfffffif(float noundef %42, float noundef %45, float noundef %48, float noundef %51, float noundef %54, i32 noundef %57, float poison), !dbg !1166
    #dbg_value(float %58, !1106, !DIExpression(), !1122)
  call void @__ft_read(ptr @prices, i32 348, ptr @10), !dbg !1167
  %59 = load ptr, ptr @prices, align 8, !dbg !1167, !tbaa !1154
  %60 = getelementptr inbounds float, ptr %59, i64 %18, !dbg !1167
  call void @__ft_write(ptr %60, i32 348, ptr @2), !dbg !1168
  store float %58, ptr %60, align 4, !dbg !1168, !tbaa !1157
  %61 = add nsw i64 %18, 1, !dbg !1169
    #dbg_value(i64 %61, !1104, !DIExpression(), !1122)
  %62 = icmp slt i64 %61, %14, !dbg !1126
  br i1 %62, label %17, label %63, !dbg !1127, !llvm.loop !1170

63:                                               ; preds = %39, %1
    #dbg_value(i32 1, !1105, !DIExpression(), !1122)
    #dbg_value(i32 poison, !1105, !DIExpression(), !1122)
  ret i32 0, !dbg !1174
}

; Function Attrs: nounwind
declare !dbg !1175 i32 @pthread_mutex_lock(ptr noundef) local_unnamed_addr #6

; Function Attrs: nounwind
declare !dbg !1180 i32 @pthread_mutex_unlock(ptr noundef) local_unnamed_addr #6

; Function Attrs: cold noreturn nounwind
declare !dbg !1181 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) local_unnamed_addr #7

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef i32 @main(i32 noundef %0, ptr nocapture noundef readonly %1) local_unnamed_addr #8 !dbg !1185 {
  %3 = alloca ptr, align 8, !DIAssignID !1272
    #dbg_assign(i1 undef, !1271, !DIExpression(), !1272, ptr %3, !DIExpression(), !1273)
    #dbg_value(i32 %0, !1189, !DIExpression(), !1274)
    #dbg_value(ptr %1, !1190, !DIExpression(), !1274)
  %4 = tail call i32 @pthread_mutex_init(ptr noundef nonnull @myMutex, ptr noundef null) #16, !dbg !1275
  call void @__ft_write(ptr @myGlobal, i32 373, ptr @3), !dbg !1276
  store volatile i32 1, ptr @myGlobal, align 4, !dbg !1276, !tbaa !909
  %5 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str), !dbg !1277
  %6 = tail call i32 @fflush(ptr noundef null), !dbg !1278
  %7 = icmp eq i32 %0, 4, !dbg !1279
  br i1 %7, label %11, label %8, !dbg !1279

8:                                                ; preds = %2
  call void @__ft_read(ptr %1, i32 389, ptr @2), !dbg !1281
  %9 = load ptr, ptr %1, align 8, !dbg !1281, !tbaa !1283
  %10 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.4, ptr noundef %9), !dbg !1285
  tail call void @exit(i32 noundef 1) #17, !dbg !1286
  unreachable, !dbg !1286

11:                                               ; preds = %2
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 8, !dbg !1287
  call void @__ft_read(ptr %12, i32 392, ptr @2), !dbg !1287
  %13 = load ptr, ptr %12, align 8, !dbg !1287, !tbaa !1283
    #dbg_value(ptr %13, !241, !DIExpression(), !1288)
  %14 = tail call i64 @__isoc23_strtol(ptr noundef nonnull %13, ptr noundef null, i32 noundef 10) #16, !dbg !1290
  %15 = trunc i64 %14 to i32, !dbg !1290
  call void @__ft_write(ptr @nThreads, i32 392, ptr @1), !dbg !1291
  store i32 %15, ptr @nThreads, align 4, !dbg !1291, !tbaa !909
  %16 = getelementptr inbounds nuw i8, ptr %1, i64 16, !dbg !1292
  call void @__ft_read(ptr %16, i32 393, ptr @2), !dbg !1292
  %17 = load ptr, ptr %16, align 8, !dbg !1292, !tbaa !1283
    #dbg_value(ptr %17, !1255, !DIExpression(), !1274)
  %18 = getelementptr inbounds nuw i8, ptr %1, i64 24, !dbg !1293
  call void @__ft_read(ptr %18, i32 394, ptr @2), !dbg !1293
  %19 = load ptr, ptr %18, align 8, !dbg !1293, !tbaa !1283
    #dbg_value(ptr %19, !1256, !DIExpression(), !1274)
  %20 = tail call noalias ptr @fopen(ptr noundef %17, ptr noundef nonnull @.str.5), !dbg !1294
    #dbg_value(ptr %20, !1191, !DIExpression(), !1274)
  %21 = icmp eq ptr %20, null, !dbg !1295
  br i1 %21, label %22, label %24, !dbg !1295

22:                                               ; preds = %11
  %23 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.6, ptr noundef %17), !dbg !1297
  tail call void @exit(i32 noundef 1) #17, !dbg !1299
  unreachable, !dbg !1299

24:                                               ; preds = %11
  %25 = tail call i32 (ptr, ptr, ...) @__isoc23_fscanf(ptr noundef nonnull %20, ptr noundef nonnull @.str.7, ptr noundef nonnull @numOptions), !dbg !1300
    #dbg_value(i32 %25, !1254, !DIExpression(), !1274)
  %26 = icmp eq i32 %25, 1, !dbg !1301
  br i1 %26, label %30, label %27, !dbg !1301

27:                                               ; preds = %24
  %28 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.8, ptr noundef %17), !dbg !1303
  %29 = tail call i32 @fclose(ptr noundef nonnull %20), !dbg !1305
  tail call void @exit(i32 noundef 1) #17, !dbg !1306
  unreachable, !dbg !1306

30:                                               ; preds = %24
  call void @__ft_read(ptr @nThreads, i32 408, ptr @1), !dbg !1307
  %31 = load i32, ptr @nThreads, align 4, !dbg !1307, !tbaa !909
  call void @__ft_read(ptr @numOptions, i32 408, ptr @0), !dbg !1309
  %32 = load i32, ptr @numOptions, align 4, !dbg !1309, !tbaa !909
  %33 = icmp sgt i32 %31, %32, !dbg !1310
  br i1 %33, label %34, label %37, !dbg !1310

34:                                               ; preds = %30
  %35 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.19), !dbg !1311
  call void @__ft_read(ptr @numOptions, i32 410, ptr @0), !dbg !1313
  %36 = load i32, ptr @numOptions, align 4, !dbg !1313, !tbaa !909
  call void @__ft_write(ptr @nThreads, i32 410, ptr @1), !dbg !1314
  store i32 %36, ptr @nThreads, align 4, !dbg !1314, !tbaa !909
  br label %37, !dbg !1315

37:                                               ; preds = %34, %30
  call void @__ft_read(ptr @numOptions, i32 421, ptr @0), !dbg !1316
  %38 = load i32, ptr @numOptions, align 4, !dbg !1316, !tbaa !909
  %39 = sext i32 %38 to i64, !dbg !1316
  %40 = mul nsw i64 %39, 36, !dbg !1317
  %41 = tail call noalias ptr @malloc(i64 noundef %40) #18, !dbg !1318
  call void @__ft_write(ptr @data, i32 421, ptr @11), !dbg !1319
  store ptr %41, ptr @data, align 8, !dbg !1319, !tbaa !1320
  %42 = shl nsw i64 %39, 2, !dbg !1322
  %43 = tail call noalias ptr @malloc(i64 noundef %42) #18, !dbg !1323
  call void @__ft_write(ptr @prices, i32 422, ptr @10), !dbg !1324
  store ptr %43, ptr @prices, align 8, !dbg !1324, !tbaa !1154
    #dbg_value(i32 0, !1251, !DIExpression(), !1274)
  call void @__ft_read(ptr @numOptions, i32 423, ptr @0), !dbg !1325
  %44 = load i32, ptr @numOptions, align 4, !dbg !1325, !tbaa !909
  %45 = icmp sgt i32 %44, 0, !dbg !1328
  br i1 %45, label %51, label %68, !dbg !1329

46:                                               ; preds = %51
  %47 = add nuw nsw i64 %52, 1, !dbg !1330
    #dbg_value(i64 %47, !1251, !DIExpression(), !1274)
    #dbg_value(i64 %47, !1251, !DIExpression(), !1274)
  call void @__ft_read(ptr @numOptions, i32 423, ptr @0), !dbg !1325
  %48 = load i32, ptr @numOptions, align 4, !dbg !1325, !tbaa !909
  %49 = sext i32 %48 to i64, !dbg !1328
  %50 = icmp slt i64 %47, %49, !dbg !1328
  br i1 %50, label %51, label %68, !dbg !1329, !llvm.loop !1331

51:                                               ; preds = %46, %37
  %52 = phi i64 [ %47, %46 ], [ 0, %37 ]
    #dbg_value(i64 %52, !1251, !DIExpression(), !1274)
  call void @__ft_read(ptr @data, i32 425, ptr @11), !dbg !1333
  %53 = load ptr, ptr @data, align 8, !dbg !1333, !tbaa !1320
  %54 = getelementptr inbounds nuw %struct.OptionData_, ptr %53, i64 %52, !dbg !1333
  %55 = getelementptr inbounds nuw i8, ptr %54, i64 4, !dbg !1335
  %56 = getelementptr inbounds nuw i8, ptr %54, i64 8, !dbg !1336
  %57 = getelementptr inbounds nuw i8, ptr %54, i64 12, !dbg !1337
  %58 = getelementptr inbounds nuw i8, ptr %54, i64 16, !dbg !1338
  %59 = getelementptr inbounds nuw i8, ptr %54, i64 20, !dbg !1339
  %60 = getelementptr inbounds nuw i8, ptr %54, i64 24, !dbg !1340
  %61 = getelementptr inbounds nuw i8, ptr %54, i64 28, !dbg !1341
  %62 = getelementptr inbounds nuw i8, ptr %54, i64 32, !dbg !1342
  %63 = tail call i32 (ptr, ptr, ...) @__isoc23_fscanf(ptr noundef nonnull %20, ptr noundef nonnull @.str.10, ptr noundef %54, ptr noundef nonnull %55, ptr noundef nonnull %56, ptr noundef nonnull %57, ptr noundef nonnull %58, ptr noundef nonnull %59, ptr noundef nonnull %60, ptr noundef nonnull %61, ptr noundef nonnull %62), !dbg !1343
    #dbg_value(i32 %63, !1254, !DIExpression(), !1274)
  %64 = icmp eq i32 %63, 9, !dbg !1344
    #dbg_value(i64 %52, !1251, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !1274)
  br i1 %64, label %46, label %65, !dbg !1344

65:                                               ; preds = %51
  %66 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.8, ptr noundef %17), !dbg !1346
  %67 = tail call i32 @fclose(ptr noundef nonnull %20), !dbg !1348
  tail call void @exit(i32 noundef 1) #17, !dbg !1349
  unreachable, !dbg !1349

68:                                               ; preds = %46, %37
  %69 = tail call i32 @fclose(ptr noundef nonnull %20), !dbg !1350
    #dbg_value(i32 %69, !1254, !DIExpression(), !1274)
  %70 = icmp eq i32 %69, 0, !dbg !1351
  br i1 %70, label %73, label %71, !dbg !1351

71:                                               ; preds = %68
  %72 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.11, ptr noundef %17), !dbg !1353
  tail call void @exit(i32 noundef 1) #17, !dbg !1355
  unreachable, !dbg !1355

73:                                               ; preds = %68
  %74 = tail call i32 @pthread_mutexattr_init(ptr noundef nonnull @_M4_normalMutexAttr) #16, !dbg !1356
  call void @__ft_read(ptr @nThreads, i32 442, ptr @1), !dbg !1357
  %75 = load i32, ptr @nThreads, align 4, !dbg !1357, !tbaa !909
  call void @__ft_write(ptr @_M4_numThreads, i32 442, ptr @13), !dbg !1358
  store i32 %75, ptr @_M4_numThreads, align 4, !dbg !1358, !tbaa !909
    #dbg_value(i32 0, !1257, !DIExpression(), !1359)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1024) @_M4_threadsTable, i8 -1, i64 1024, i1 false), !dbg !1360, !tbaa !1364
    #dbg_value(i64 poison, !1257, !DIExpression(), !1359)
  call void @__ft_read(ptr @numOptions, i32 451, ptr @0), !dbg !1366
  %76 = load i32, ptr @numOptions, align 4, !dbg !1366, !tbaa !909
  %77 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.12, i32 noundef %76), !dbg !1367
  %78 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.13, i32 noundef 1), !dbg !1368
  call void @__ft_read(ptr @numOptions, i32 457, ptr @0), !dbg !1369
  %79 = load i32, ptr @numOptions, align 4, !dbg !1369, !tbaa !909
  %80 = mul nsw i32 %79, 5, !dbg !1370
  %81 = sext i32 %80 to i64, !dbg !1371
  %82 = shl nsw i64 %81, 2, !dbg !1372
  %83 = add nsw i64 %82, 256, !dbg !1373
  %84 = tail call noalias ptr @malloc(i64 noundef %83) #18, !dbg !1374
    #dbg_value(ptr %84, !1252, !DIExpression(), !1274)
  %85 = ptrtoint ptr %84 to i64, !dbg !1375
  %86 = and i64 %85, -64, !dbg !1376
  %87 = add i64 %86, 256, !dbg !1376
  %88 = inttoptr i64 %87 to ptr, !dbg !1377
  call void @__ft_write(ptr @sptprice, i32 458, ptr @4), !dbg !1378
  store ptr %88, ptr @sptprice, align 8, !dbg !1378, !tbaa !1154
  %89 = sext i32 %79 to i64, !dbg !1379
  %90 = getelementptr inbounds float, ptr %88, i64 %89, !dbg !1379
  call void @__ft_write(ptr @strike, i32 459, ptr @5), !dbg !1380
  store ptr %90, ptr @strike, align 8, !dbg !1380, !tbaa !1154
  %91 = getelementptr inbounds float, ptr %90, i64 %89, !dbg !1381
  call void @__ft_write(ptr @rate, i32 460, ptr @6), !dbg !1382
  store ptr %91, ptr @rate, align 8, !dbg !1382, !tbaa !1154
  %92 = getelementptr inbounds float, ptr %91, i64 %89, !dbg !1383
  call void @__ft_write(ptr @volatility, i32 461, ptr @7), !dbg !1384
  store ptr %92, ptr @volatility, align 8, !dbg !1384, !tbaa !1154
  %93 = getelementptr inbounds float, ptr %92, i64 %89, !dbg !1385
  call void @__ft_write(ptr @otime, i32 462, ptr @8), !dbg !1386
  store ptr %93, ptr @otime, align 8, !dbg !1386, !tbaa !1154
  %94 = shl nsw i64 %89, 2, !dbg !1387
  %95 = add nsw i64 %94, 256, !dbg !1388
  %96 = tail call noalias ptr @malloc(i64 noundef %95) #18, !dbg !1389
    #dbg_value(ptr %96, !1253, !DIExpression(), !1274)
  %97 = ptrtoint ptr %96 to i64, !dbg !1390
  %98 = and i64 %97, -64, !dbg !1391
  %99 = add i64 %98, 256, !dbg !1391
  %100 = inttoptr i64 %99 to ptr, !dbg !1392
  call void @__ft_write(ptr @otype, i32 465, ptr @9), !dbg !1393
  store ptr %100, ptr @otype, align 8, !dbg !1393, !tbaa !1164
    #dbg_value(i32 0, !1250, !DIExpression(), !1274)
  call void @__ft_read(ptr @numOptions, i32 467, ptr @0), !dbg !1394
  %101 = load i32, ptr @numOptions, align 4, !dbg !1394, !tbaa !909
  %102 = icmp sgt i32 %101, 0, !dbg !1397
  br i1 %102, label %103, label %131, !dbg !1398

103:                                              ; preds = %73
  call void @__ft_read(ptr @data, i32 0, ptr @11)
  %104 = load ptr, ptr @data, align 8, !tbaa !1320
  br label %105, !dbg !1398

105:                                              ; preds = %105, %103
  %106 = phi i64 [ 0, %103 ], [ %127, %105 ]
    #dbg_value(i64 %106, !1250, !DIExpression(), !1274)
  %107 = getelementptr inbounds nuw %struct.OptionData_, ptr %104, i64 %106, i32 6, !dbg !1399
  call void @__ft_read(ptr %107, i32 468, ptr @2), !dbg !1399
  %108 = load i8, ptr %107, align 4, !dbg !1399, !tbaa !1401
  %109 = icmp eq i8 %108, 80, !dbg !1403
  %110 = zext i1 %109 to i32, !dbg !1404
  %111 = getelementptr inbounds nuw i32, ptr %100, i64 %106, !dbg !1405
  call void @__ft_write(ptr %111, i32 468, ptr @2), !dbg !1406
  store i32 %110, ptr %111, align 4, !dbg !1406, !tbaa !909
  %112 = getelementptr inbounds nuw %struct.OptionData_, ptr %104, i64 %106, !dbg !1407
  call void @__ft_read(ptr %112, i32 469, ptr @2), !dbg !1408
  %113 = load float, ptr %112, align 4, !dbg !1408, !tbaa !1409
  %114 = getelementptr inbounds nuw float, ptr %88, i64 %106, !dbg !1410
  call void @__ft_write(ptr %114, i32 469, ptr @2), !dbg !1411
  store float %113, ptr %114, align 4, !dbg !1411, !tbaa !1157
  %115 = getelementptr inbounds nuw %struct.OptionData_, ptr %104, i64 %106, i32 1, !dbg !1412
  call void @__ft_read(ptr %115, i32 470, ptr @2), !dbg !1412
  %116 = load float, ptr %115, align 4, !dbg !1412, !tbaa !1413
  %117 = getelementptr inbounds nuw float, ptr %90, i64 %106, !dbg !1414
  call void @__ft_write(ptr %117, i32 470, ptr @2), !dbg !1415
  store float %116, ptr %117, align 4, !dbg !1415, !tbaa !1157
  %118 = getelementptr inbounds nuw %struct.OptionData_, ptr %104, i64 %106, i32 2, !dbg !1416
  call void @__ft_read(ptr %118, i32 471, ptr @2), !dbg !1416
  %119 = load float, ptr %118, align 4, !dbg !1416, !tbaa !1417
  %120 = getelementptr inbounds nuw float, ptr %91, i64 %106, !dbg !1418
  call void @__ft_write(ptr %120, i32 471, ptr @2), !dbg !1419
  store float %119, ptr %120, align 4, !dbg !1419, !tbaa !1157
  %121 = getelementptr inbounds nuw %struct.OptionData_, ptr %104, i64 %106, i32 4, !dbg !1420
  call void @__ft_read(ptr %121, i32 472, ptr @2), !dbg !1420
  %122 = load float, ptr %121, align 4, !dbg !1420, !tbaa !1421
  %123 = getelementptr inbounds nuw float, ptr %92, i64 %106, !dbg !1422
  call void @__ft_write(ptr %123, i32 472, ptr @2), !dbg !1423
  store float %122, ptr %123, align 4, !dbg !1423, !tbaa !1157
  %124 = getelementptr inbounds nuw %struct.OptionData_, ptr %104, i64 %106, i32 5, !dbg !1424
  call void @__ft_read(ptr %124, i32 473, ptr @2), !dbg !1424
  %125 = load float, ptr %124, align 4, !dbg !1424, !tbaa !1425
  %126 = getelementptr inbounds nuw float, ptr %93, i64 %106, !dbg !1426
  call void @__ft_write(ptr %126, i32 473, ptr @2), !dbg !1427
  store float %125, ptr %126, align 4, !dbg !1427, !tbaa !1157
  %127 = add nuw nsw i64 %106, 1, !dbg !1428
    #dbg_value(i64 %127, !1250, !DIExpression(), !1274)
  call void @__ft_read(ptr @numOptions, i32 467, ptr @0), !dbg !1394
  %128 = load i32, ptr @numOptions, align 4, !dbg !1394, !tbaa !909
  %129 = sext i32 %128 to i64, !dbg !1397
  %130 = icmp slt i64 %127, %129, !dbg !1397
  br i1 %130, label %105, label %131, !dbg !1398, !llvm.loop !1429

131:                                              ; preds = %105, %73
  %132 = phi i32 [ %101, %73 ], [ %128, %105 ], !dbg !1394
  %133 = sext i32 %132 to i64, !dbg !1431
  %134 = mul nsw i64 %133, 40, !dbg !1432
  %135 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.14, i64 noundef %134), !dbg !1433
  call void @__ft_read(ptr @nThreads, i32 482, ptr @1), !dbg !1434
  %136 = load i32, ptr @nThreads, align 4, !dbg !1434, !tbaa !909
  %137 = zext i32 %136 to i64, !dbg !1435
  %138 = alloca i32, i64 %137, align 16, !dbg !1435
    #dbg_value(i64 %137, !1259, !DIExpression(), !1274)
    #dbg_declare(ptr %138, !1260, !DIExpression(), !1436)
    #dbg_value(i32 0, !1250, !DIExpression(), !1274)
  %139 = icmp sgt i32 %136, 0, !dbg !1437
  br i1 %139, label %140, label %163, !dbg !1438

140:                                              ; preds = %152, %131
  %141 = phi i64 [ %159, %152 ], [ 0, %131 ]
    #dbg_value(i64 %141, !1250, !DIExpression(), !1274)
  %142 = getelementptr inbounds nuw i32, ptr %138, i64 %141, !dbg !1439
  %143 = trunc nuw nsw i64 %141 to i32, !dbg !1440
  call void @__ft_write(ptr %142, i32 484, ptr @2), !dbg !1440
  store i32 %143, ptr %142, align 4, !dbg !1440, !tbaa !909
    #dbg_value(i32 0, !1264, !DIExpression(), !1441)
  br label %144, !dbg !1442

144:                                              ; preds = %149, %140
  %145 = phi i64 [ 0, %140 ], [ %150, %149 ]
    #dbg_value(i64 %145, !1264, !DIExpression(), !1441)
  %146 = getelementptr inbounds nuw [128 x i64], ptr @_M4_threadsTable, i64 0, i64 %145, !dbg !1444
  call void @__ft_read(ptr %146, i32 489, ptr @12), !dbg !1444
  %147 = load i64, ptr %146, align 8, !dbg !1444, !tbaa !1364
  %148 = icmp eq i64 %147, -1, !dbg !1448
  br i1 %148, label %152, label %149, !dbg !1448

149:                                              ; preds = %144
  %150 = add nuw nsw i64 %145, 1, !dbg !1449
    #dbg_value(i64 %150, !1264, !DIExpression(), !1441)
  %151 = icmp eq i64 %150, 128, !dbg !1450
  br i1 %151, label %152, label %144, !dbg !1442, !llvm.loop !1451

152:                                              ; preds = %149, %144
  %153 = phi i64 [ %145, %144 ], [ 128, %149 ], !dbg !1453
  %154 = and i64 %153, 4294967295, !dbg !1454
  %155 = getelementptr inbounds nuw [128 x i64], ptr @_M4_threadsTable, i64 0, i64 %154, !dbg !1454
  %156 = call ptr @__ft_prepare_context(ptr @_Z9bs_threadPv, ptr %142), !dbg !1455
  %157 = call i32 @pthread_create(ptr noundef nonnull %155, ptr noundef null, ptr noundef nonnull @thread_wrapper, ptr noundef nonnull %156) #16, !dbg !1455
  %158 = load i64, ptr %155, align 8, !dbg !1456
  call void @__ft_thread_create(i64 %158), !dbg !1456
  %159 = add nuw nsw i64 %141, 1, !dbg !1456
    #dbg_value(i64 %159, !1250, !DIExpression(), !1274)
  call void @__ft_read(ptr @nThreads, i32 483, ptr @1), !dbg !1457
  %160 = load i32, ptr @nThreads, align 4, !dbg !1457, !tbaa !909
  %161 = sext i32 %160 to i64, !dbg !1437
  %162 = icmp slt i64 %159, %161, !dbg !1437
  br i1 %162, label %140, label %163, !dbg !1438, !llvm.loop !1458

163:                                              ; preds = %152, %131
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #16, !dbg !1460
    #dbg_value(i32 0, !1269, !DIExpression(), !1273)
  br label %164, !dbg !1461

164:                                              ; preds = %169, %163
  %165 = phi i64 [ 0, %163 ], [ %171, %169 ]
    #dbg_value(i64 %165, !1269, !DIExpression(), !1273)
  %166 = getelementptr inbounds nuw [128 x i64], ptr @_M4_threadsTable, i64 0, i64 %165, !dbg !1463
  call void @__ft_read(ptr %166, i32 502, ptr @12), !dbg !1463
  %167 = load i64, ptr %166, align 8, !dbg !1463, !tbaa !1364
  %168 = icmp eq i64 %167, -1, !dbg !1467
  br i1 %168, label %173, label %169, !dbg !1467

169:                                              ; preds = %164
  %170 = call i32 @pthread_join(i64 noundef %167, ptr noundef nonnull %3), !dbg !1468
  call void @__ft_thread_join(i64 %167), !dbg !1469
  %171 = add nuw nsw i64 %165, 1, !dbg !1469
    #dbg_value(i64 %171, !1269, !DIExpression(), !1273)
  %172 = icmp eq i64 %171, 128, !dbg !1470
  br i1 %172, label %173, label %164, !dbg !1461, !llvm.loop !1471

173:                                              ; preds = %169, %164
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #16, !dbg !1473
  %174 = call noalias ptr @fopen(ptr noundef %19, ptr noundef nonnull @.str.15), !dbg !1474
    #dbg_value(ptr %174, !1191, !DIExpression(), !1274)
  %175 = icmp eq ptr %174, null, !dbg !1475
  br i1 %175, label %176, label %178, !dbg !1475

176:                                              ; preds = %173
  %177 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.6, ptr noundef %19), !dbg !1477
  call void @exit(i32 noundef 1) #17, !dbg !1479
  unreachable, !dbg !1479

178:                                              ; preds = %173
  call void @__ft_read(ptr @numOptions, i32 543, ptr @0), !dbg !1480
  %179 = load i32, ptr @numOptions, align 4, !dbg !1480, !tbaa !909
  %180 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef nonnull %174, ptr noundef nonnull @.str.16, i32 noundef %179) #16, !dbg !1481
    #dbg_value(i32 %180, !1254, !DIExpression(), !1274)
  %181 = icmp slt i32 %180, 0, !dbg !1482
  br i1 %181, label %185, label %182, !dbg !1482

182:                                              ; preds = %178
    #dbg_value(i32 0, !1250, !DIExpression(), !1274)
  call void @__ft_read(ptr @numOptions, i32 549, ptr @0), !dbg !1484
  %183 = load i32, ptr @numOptions, align 4, !dbg !1484, !tbaa !909
  %184 = icmp sgt i32 %183, 0, !dbg !1487
  br i1 %184, label %193, label %204, !dbg !1488

185:                                              ; preds = %178
  %186 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.17, ptr noundef %19), !dbg !1489
  %187 = call i32 @fclose(ptr noundef nonnull %174), !dbg !1491
  call void @exit(i32 noundef 1) #17, !dbg !1492
  unreachable, !dbg !1492

188:                                              ; preds = %193
  %189 = add nuw nsw i64 %194, 1, !dbg !1493
    #dbg_value(i64 %189, !1250, !DIExpression(), !1274)
    #dbg_value(i64 %189, !1250, !DIExpression(), !1274)
  call void @__ft_read(ptr @numOptions, i32 549, ptr @0), !dbg !1484
  %190 = load i32, ptr @numOptions, align 4, !dbg !1484, !tbaa !909
  %191 = sext i32 %190 to i64, !dbg !1487
  %192 = icmp slt i64 %189, %191, !dbg !1487
  br i1 %192, label %193, label %204, !dbg !1488, !llvm.loop !1494

193:                                              ; preds = %188, %182
  %194 = phi i64 [ %189, %188 ], [ 0, %182 ]
    #dbg_value(i64 %194, !1250, !DIExpression(), !1274)
  call void @__ft_read(ptr @prices, i32 550, ptr @10), !dbg !1496
  %195 = load ptr, ptr @prices, align 8, !dbg !1496, !tbaa !1154
  %196 = getelementptr inbounds nuw float, ptr %195, i64 %194, !dbg !1496
  call void @__ft_read(ptr %196, i32 550, ptr @2), !dbg !1496
  %197 = load float, ptr %196, align 4, !dbg !1496, !tbaa !1157
  %198 = fpext float %197 to double, !dbg !1496
  %199 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef nonnull %174, ptr noundef nonnull @.str.18, double noundef %198) #16, !dbg !1498
    #dbg_value(i32 %199, !1254, !DIExpression(), !1274)
  %200 = icmp slt i32 %199, 0, !dbg !1499
    #dbg_value(i64 %194, !1250, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !1274)
  br i1 %200, label %201, label %188, !dbg !1499

201:                                              ; preds = %193
  %202 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.17, ptr noundef %19), !dbg !1501
  %203 = call i32 @fclose(ptr noundef nonnull %174), !dbg !1503
  call void @exit(i32 noundef 1) #17, !dbg !1504
  unreachable, !dbg !1504

204:                                              ; preds = %188, %182
  %205 = call i32 @fclose(ptr noundef nonnull %174), !dbg !1505
    #dbg_value(i32 %205, !1254, !DIExpression(), !1274)
  %206 = icmp eq i32 %205, 0, !dbg !1506
  br i1 %206, label %209, label %207, !dbg !1506

207:                                              ; preds = %204
  %208 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.11, ptr noundef %19), !dbg !1508
  call void @exit(i32 noundef 1) #17, !dbg !1510
  unreachable, !dbg !1510

209:                                              ; preds = %204
  call void @__ft_read(ptr @data, i32 566, ptr @11), !dbg !1511
  %210 = load ptr, ptr @data, align 8, !dbg !1511, !tbaa !1320
  call void @free(ptr noundef %210) #16, !dbg !1512
  call void @__ft_read(ptr @prices, i32 567, ptr @10), !dbg !1513
  %211 = load ptr, ptr @prices, align 8, !dbg !1513, !tbaa !1154
  call void @free(ptr noundef %211) #16, !dbg !1514
  ret i32 0, !dbg !1515
}

; Function Attrs: nounwind
declare !dbg !1516 i32 @pthread_mutex_init(ptr noundef, ptr noundef) local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare !dbg !1521 noundef i32 @fflush(ptr nocapture noundef) local_unnamed_addr #3

; Function Attrs: nofree noreturn nounwind
declare !dbg !264 void @exit(i32 noundef) local_unnamed_addr #9

; Function Attrs: nofree nounwind
declare !dbg !1524 noalias noundef ptr @fopen(ptr nocapture noundef readonly, ptr nocapture noundef readonly) local_unnamed_addr #3

declare !dbg !1527 i32 @__isoc23_fscanf(ptr noundef, ptr noundef, ...) local_unnamed_addr #10

; Function Attrs: nofree nounwind
declare !dbg !1531 noundef i32 @fclose(ptr nocapture noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare !dbg !284 noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #11

; Function Attrs: nounwind
declare !dbg !1532 i32 @pthread_mutexattr_init(ptr noundef) local_unnamed_addr #6

; Function Attrs: nounwind
declare !dbg !1536 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #6

declare !dbg !1547 i32 @pthread_join(i64 noundef, ptr noundef) local_unnamed_addr #10

; Function Attrs: nofree nounwind
declare !dbg !1551 noundef i32 @fprintf(ptr nocapture noundef, ptr nocapture noundef readonly, ...) local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare !dbg !268 void @free(ptr allocptr nocapture noundef) local_unnamed_addr #12

; Function Attrs: mustprogress nofree nounwind willreturn memory(write)
declare !dbg !1552 float @expf(float noundef) local_unnamed_addr #13

; Function Attrs: mustprogress nofree nounwind willreturn memory(write)
declare !dbg !1553 float @sqrtf(float noundef) local_unnamed_addr #13

; Function Attrs: mustprogress nofree nounwind willreturn memory(write)
declare !dbg !1554 float @logf(float noundef) local_unnamed_addr #13

; Function Attrs: nounwind
declare !dbg !327 i64 @__isoc23_strtol(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr nocapture noundef readonly) local_unnamed_addr #14

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #15

declare void @__ft_read(ptr, i32, ptr)

declare void @__ft_write(ptr, i32, ptr)

declare void @__ft_lock(ptr)

declare void @__ft_unlock(ptr)

declare void @__ft_thread_create(i64)

declare void @__ft_thread_join(i64)

declare ptr @__ft_prepare_context(ptr, ptr)

declare ptr @thread_wrapper(ptr)

attributes #0 = { mustprogress nofree nounwind willreturn memory(write) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { mustprogress nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { cold noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { mustprogress norecurse uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { nofree noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #13 = { mustprogress nofree nounwind willreturn memory(write) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #14 = { nofree nounwind }
attributes #15 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #16 = { nounwind }
attributes #17 = { cold noreturn nounwind }
attributes #18 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!873, !874, !875, !876, !877, !878, !879}
!llvm.ident = !{!880}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_M4_threadsTable", scope: !2, file: !3, line: 99, type: !869, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 20.1.8 (0ubuntu4)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !31, imports: !193, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "blackscholes.m4.cpp", directory: "/home/rahulm/work/cs636/CS636_course_project_IITK/benchmarks/testing_temp_dir/source/blackscholes/src", checksumkind: CSK_MD5, checksum: "23c00d706d83daaacd6e6d9255d66ba0")
!4 = !{!5, !7, !8, !23, !24, !25, !28, !6, !29}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "OptionData", file: !3, line: 135, baseType: !10)
!10 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OptionData_", file: !3, line: 124, size: 288, flags: DIFlagTypePassByValue, elements: !11, identifier: "_ZTS11OptionData_")
!11 = !{!12, !14, !15, !16, !17, !18, !19, !21, !22}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "s", scope: !10, file: !3, line: 125, baseType: !13, size: 32)
!13 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "strike", scope: !10, file: !3, line: 126, baseType: !13, size: 32, offset: 32)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "r", scope: !10, file: !3, line: 127, baseType: !13, size: 32, offset: 64)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "divq", scope: !10, file: !3, line: 128, baseType: !13, size: 32, offset: 96)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "v", scope: !10, file: !3, line: 129, baseType: !13, size: 32, offset: 128)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !10, file: !3, line: 130, baseType: !13, size: 32, offset: 160)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "OptionType", scope: !10, file: !3, line: 132, baseType: !20, size: 8, offset: 192)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "divs", scope: !10, file: !3, line: 133, baseType: !13, size: 32, offset: 224)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "DGrefval", scope: !10, file: !3, line: 134, baseType: !13, size: 32, offset: 256)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!24 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DISubroutineType(types: !27)
!27 = !{!28, !28}
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!31 = !{!0, !32, !43, !45, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !73, !105, !108, !113, !118, !123, !128, !133, !138, !143, !148, !153, !158, !163, !168, !173, !178, !180, !183, !188}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "_M4_normalMutexAttr", scope: !2, file: !3, line: 100, type: !34, isLocal: false, isDefinition: true)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !35, line: 36, baseType: !36)
!35 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8e06fe5d0f3f3d4ee6a7a8929dd2b809")
!36 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !35, line: 32, size: 32, flags: DIFlagTypePassByValue, elements: !37, identifier: "_ZTS19pthread_mutexattr_t")
!37 = !{!38, !42}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !36, file: !35, line: 34, baseType: !39, size: 32)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 32, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 4)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !36, file: !35, line: 35, baseType: !6, size: 32)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "_M4_numThreads", scope: !2, file: !3, line: 101, type: !6, isLocal: false, isDefinition: true)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 137, type: !8, isLocal: false, isDefinition: true)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "prices", scope: !2, file: !3, line: 138, type: !23, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "numOptions", scope: !2, file: !3, line: 139, type: !6, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "otype", scope: !2, file: !3, line: 141, type: !5, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "sptprice", scope: !2, file: !3, line: 142, type: !23, isLocal: false, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "strike", scope: !2, file: !3, line: 143, type: !23, isLocal: false, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "rate", scope: !2, file: !3, line: 144, type: !23, isLocal: false, isDefinition: true)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "volatility", scope: !2, file: !3, line: 145, type: !23, isLocal: false, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "otime", scope: !2, file: !3, line: 146, type: !23, isLocal: false, isDefinition: true)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "numError", scope: !2, file: !3, line: 147, type: !6, isLocal: false, isDefinition: true)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "nThreads", scope: !2, file: !3, line: 148, type: !6, isLocal: false, isDefinition: true)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(scope: null, file: !3, line: 218, type: !69, isLocal: true, isDefinition: true)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 64, elements: !71)
!70 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!71 = !{!72}
!72 = !DISubrange(count: 8)
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(name: "myMutex", scope: !2, file: !3, line: 302, type: !75, isLocal: false, isDefinition: true)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !35, line: 72, baseType: !76)
!76 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !35, line: 67, size: 320, flags: DIFlagTypePassByValue, elements: !77, identifier: "_ZTS15pthread_mutex_t")
!77 = !{!78, !99, !103}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !76, file: !35, line: 69, baseType: !79, size: 320)
!79 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !80, line: 22, size: 320, flags: DIFlagTypePassByValue, elements: !81, identifier: "_ZTS17__pthread_mutex_s")
!80 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "dd3989155840df74989f662ad537bbcc")
!81 = !{!82, !83, !85, !86, !87, !88, !90, !91}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !79, file: !80, line: 24, baseType: !6, size: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !79, file: !80, line: 25, baseType: !84, size: 32, offset: 32)
!84 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !79, file: !80, line: 26, baseType: !6, size: 32, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !79, file: !80, line: 28, baseType: !84, size: 32, offset: 96)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !79, file: !80, line: 32, baseType: !6, size: 32, offset: 128)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !79, file: !80, line: 34, baseType: !89, size: 16, offset: 160)
!89 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !79, file: !80, line: 35, baseType: !89, size: 16, offset: 176)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !79, file: !80, line: 36, baseType: !92, size: 128, offset: 192)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !93, line: 55, baseType: !94)
!93 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4de73b5923ab08445dd348713aeb0a37")
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !93, line: 51, size: 128, flags: DIFlagTypePassByValue, elements: !95, identifier: "_ZTS23__pthread_internal_list")
!95 = !{!96, !98}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !94, file: !93, line: 53, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !94, file: !93, line: 54, baseType: !97, size: 64, offset: 64)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !76, file: !35, line: 70, baseType: !100, size: 320)
!100 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 320, elements: !101)
!101 = !{!102}
!102 = !DISubrange(count: 40)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !76, file: !35, line: 71, baseType: !104, size: 64)
!104 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression())
!106 = distinct !DIGlobalVariable(name: "myGlobal", scope: !2, file: !3, line: 303, type: !107, isLocal: false, isDefinition: true)
!107 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !6)
!108 = !DIGlobalVariableExpression(var: !109, expr: !DIExpression())
!109 = distinct !DIGlobalVariable(scope: null, file: !3, line: 338, type: !110, isLocal: true, isDefinition: true)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 96, elements: !111)
!111 = !{!112}
!112 = !DISubrange(count: 12)
!113 = !DIGlobalVariableExpression(var: !114, expr: !DIExpression())
!114 = distinct !DIGlobalVariable(scope: null, file: !3, line: 338, type: !115, isLocal: true, isDefinition: true)
!115 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 176, elements: !116)
!116 = !{!117}
!117 = !DISubrange(count: 22)
!118 = !DIGlobalVariableExpression(var: !119, expr: !DIExpression())
!119 = distinct !DIGlobalVariable(scope: null, file: !3, line: 380, type: !120, isLocal: true, isDefinition: true)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 192, elements: !121)
!121 = !{!122}
!122 = !DISubrange(count: 24)
!123 = !DIGlobalVariableExpression(var: !124, expr: !DIExpression())
!124 = distinct !DIGlobalVariable(scope: null, file: !3, line: 389, type: !125, isLocal: true, isDefinition: true)
!125 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 384, elements: !126)
!126 = !{!127}
!127 = !DISubrange(count: 48)
!128 = !DIGlobalVariableExpression(var: !129, expr: !DIExpression())
!129 = distinct !DIGlobalVariable(scope: null, file: !3, line: 397, type: !130, isLocal: true, isDefinition: true)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 16, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 2)
!133 = !DIGlobalVariableExpression(var: !134, expr: !DIExpression())
!134 = distinct !DIGlobalVariable(scope: null, file: !3, line: 399, type: !135, isLocal: true, isDefinition: true)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 256, elements: !136)
!136 = !{!137}
!137 = !DISubrange(count: 32)
!138 = !DIGlobalVariableExpression(var: !139, expr: !DIExpression())
!139 = distinct !DIGlobalVariable(scope: null, file: !3, line: 402, type: !140, isLocal: true, isDefinition: true)
!140 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 24, elements: !141)
!141 = !{!142}
!142 = !DISubrange(count: 3)
!143 = !DIGlobalVariableExpression(var: !144, expr: !DIExpression())
!144 = distinct !DIGlobalVariable(scope: null, file: !3, line: 404, type: !145, isLocal: true, isDefinition: true)
!145 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 296, elements: !146)
!146 = !{!147}
!147 = !DISubrange(count: 37)
!148 = !DIGlobalVariableExpression(var: !149, expr: !DIExpression())
!149 = distinct !DIGlobalVariable(scope: null, file: !3, line: 409, type: !150, isLocal: true, isDefinition: true)
!150 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 656, elements: !151)
!151 = !{!152}
!152 = !DISubrange(count: 82)
!153 = !DIGlobalVariableExpression(var: !154, expr: !DIExpression())
!154 = distinct !DIGlobalVariable(scope: null, file: !3, line: 425, type: !155, isLocal: true, isDefinition: true)
!155 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 216, elements: !156)
!156 = !{!157}
!157 = !DISubrange(count: 27)
!158 = !DIGlobalVariableExpression(var: !159, expr: !DIExpression())
!159 = distinct !DIGlobalVariable(scope: null, file: !3, line: 434, type: !160, isLocal: true, isDefinition: true)
!160 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 264, elements: !161)
!161 = !{!162}
!162 = !DISubrange(count: 33)
!163 = !DIGlobalVariableExpression(var: !164, expr: !DIExpression())
!164 = distinct !DIGlobalVariable(scope: null, file: !3, line: 451, type: !165, isLocal: true, isDefinition: true)
!165 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 160, elements: !166)
!166 = !{!167}
!167 = !DISubrange(count: 20)
!168 = !DIGlobalVariableExpression(var: !169, expr: !DIExpression())
!169 = distinct !DIGlobalVariable(scope: null, file: !3, line: 452, type: !170, isLocal: true, isDefinition: true)
!170 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 136, elements: !171)
!171 = !{!172}
!172 = !DISubrange(count: 17)
!173 = !DIGlobalVariableExpression(var: !174, expr: !DIExpression())
!174 = distinct !DIGlobalVariable(scope: null, file: !3, line: 476, type: !175, isLocal: true, isDefinition: true)
!175 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 144, elements: !176)
!176 = !{!177}
!177 = !DISubrange(count: 18)
!178 = !DIGlobalVariableExpression(var: !179, expr: !DIExpression())
!179 = distinct !DIGlobalVariable(scope: null, file: !3, line: 538, type: !130, isLocal: true, isDefinition: true)
!180 = !DIGlobalVariableExpression(var: !181, expr: !DIExpression())
!181 = distinct !DIGlobalVariable(scope: null, file: !3, line: 543, type: !182, isLocal: true, isDefinition: true)
!182 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 32, elements: !40)
!183 = !DIGlobalVariableExpression(var: !184, expr: !DIExpression())
!184 = distinct !DIGlobalVariable(scope: null, file: !3, line: 545, type: !185, isLocal: true, isDefinition: true)
!185 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 288, elements: !186)
!186 = !{!187}
!187 = !DISubrange(count: 36)
!188 = !DIGlobalVariableExpression(var: !189, expr: !DIExpression())
!189 = distinct !DIGlobalVariable(scope: null, file: !3, line: 550, type: !190, isLocal: true, isDefinition: true)
!190 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 56, elements: !191)
!191 = !{!192}
!192 = !DISubrange(count: 7)
!193 = !{!194, !201, !205, !211, !215, !222, !227, !229, !236, !242, !246, !257, !259, !263, !267, !271, !275, !279, !283, !287, !291, !299, !303, !307, !309, !313, !317, !321, !326, !330, !334, !336, !344, !348, !356, !358, !362, !366, !370, !374, !378, !382, !387, !388, !389, !390, !392, !393, !394, !395, !396, !397, !398, !400, !401, !402, !403, !404, !405, !406, !407, !412, !413, !414, !415, !416, !417, !418, !419, !420, !421, !422, !423, !424, !425, !426, !427, !428, !429, !430, !431, !432, !433, !434, !435, !436, !442, !444, !446, !450, !452, !454, !456, !458, !460, !462, !464, !468, !472, !474, !476, !481, !483, !485, !487, !489, !491, !493, !497, !501, !503, !505, !507, !509, !513, !517, !519, !521, !523, !525, !527, !529, !531, !533, !535, !537, !539, !541, !543, !545, !549, !553, !557, !561, !563, !565, !567, !569, !573, !578, !580, !582, !584, !586, !588, !590, !592, !594, !596, !598, !600, !602, !605, !607, !609, !611, !613, !615, !617, !619, !621, !623, !625, !627, !629, !631, !633, !635, !637, !639, !641, !643, !645, !647, !649, !651, !653, !655, !657, !659, !661, !663, !665, !667, !671, !675, !679, !681, !683, !685, !687, !689, !691, !693, !695, !697, !701, !705, !709, !711, !713, !715, !719, !723, !727, !729, !731, !733, !735, !737, !739, !741, !743, !745, !747, !749, !751, !755, !759, !763, !765, !767, !769, !771, !775, !779, !781, !783, !785, !787, !789, !791, !795, !799, !801, !803, !805, !807, !811, !815, !819, !821, !823, !825, !827, !829, !831, !835, !839, !843, !845, !847, !849, !851, !853, !855, !857, !859, !861, !865, !867}
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !196, file: !200, line: 58)
!195 = !DINamespace(name: "std", scope: null)
!196 = !DISubprogram(name: "abs", scope: !197, file: !197, line: 980, type: !198, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!197 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "2ebb4e08912aad41774217f29ad02c9e")
!198 = !DISubroutineType(types: !199)
!199 = !{!6, !6}
!200 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/bits/std_abs.h", directory: "", checksumkind: CSK_MD5, checksum: "b04fe3ed420747a2e528c0e678ab45db")
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !202, file: !204, line: 137)
!202 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !197, line: 63, baseType: !203)
!203 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !197, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!204 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cstdlib", directory: "", checksumkind: CSK_MD5, checksum: "745c77d592b579358a91081122d152be")
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !206, file: !204, line: 138)
!206 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !197, line: 71, baseType: !207)
!207 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !197, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !208, identifier: "_ZTS6ldiv_t")
!208 = !{!209, !210}
!209 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !207, file: !197, line: 69, baseType: !104, size: 64)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !207, file: !197, line: 70, baseType: !104, size: 64, offset: 64)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !212, file: !204, line: 140)
!212 = !DISubprogram(name: "abort", scope: !197, file: !197, line: 730, type: !213, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!213 = !DISubroutineType(types: !214)
!214 = !{null}
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !216, file: !204, line: 142)
!216 = !DISubprogram(name: "aligned_alloc", scope: !197, file: !197, line: 724, type: !217, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!217 = !DISubroutineType(types: !218)
!218 = !{!28, !219, !219}
!219 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !220, line: 18, baseType: !221)
!220 = !DIFile(filename: "/usr/lib/llvm-20/lib/clang/20/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!221 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !223, file: !204, line: 144)
!223 = !DISubprogram(name: "atexit", scope: !197, file: !197, line: 734, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!224 = !DISubroutineType(types: !225)
!225 = !{!6, !226}
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !213, size: 64)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !228, file: !204, line: 147)
!228 = !DISubprogram(name: "at_quick_exit", scope: !197, file: !197, line: 739, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !230, file: !204, line: 150)
!230 = !DISubprogram(name: "atof", scope: !231, file: !231, line: 25, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!231 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "", checksumkind: CSK_MD5, checksum: "5b8ae17a9c8f951e8aefde76c3c6338d")
!232 = !DISubroutineType(types: !233)
!233 = !{!234, !235}
!234 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !237, file: !204, line: 151)
!237 = distinct !DISubprogram(name: "atoi", scope: !197, file: !197, line: 481, type: !238, scopeLine: 482, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !240)
!238 = !DISubroutineType(types: !239)
!239 = !{!6, !235}
!240 = !{!241}
!241 = !DILocalVariable(name: "__nptr", arg: 1, scope: !237, file: !197, line: 481, type: !235)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !243, file: !204, line: 152)
!243 = !DISubprogram(name: "atol", scope: !197, file: !197, line: 486, type: !244, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!244 = !DISubroutineType(types: !245)
!245 = !{!104, !235}
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !247, file: !204, line: 153)
!247 = !DISubprogram(name: "bsearch", scope: !248, file: !248, line: 20, type: !249, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!248 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "", checksumkind: CSK_MD5, checksum: "f99fcd29986159d95c3009efc7923f1a")
!249 = !DISubroutineType(types: !250)
!250 = !{!28, !251, !251, !219, !219, !253}
!251 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !252, size: 64)
!252 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!253 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !197, line: 948, baseType: !254)
!254 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !255, size: 64)
!255 = !DISubroutineType(types: !256)
!256 = !{!6, !251, !251}
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !258, file: !204, line: 154)
!258 = !DISubprogram(name: "calloc", scope: !197, file: !197, line: 675, type: !217, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !260, file: !204, line: 155)
!260 = !DISubprogram(name: "div", scope: !197, file: !197, line: 998, type: !261, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!261 = !DISubroutineType(types: !262)
!262 = !{!202, !6, !6}
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !264, file: !204, line: 156)
!264 = !DISubprogram(name: "exit", scope: !197, file: !197, line: 756, type: !265, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!265 = !DISubroutineType(types: !266)
!266 = !{null, !6}
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !268, file: !204, line: 157)
!268 = !DISubprogram(name: "free", scope: !197, file: !197, line: 687, type: !269, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!269 = !DISubroutineType(types: !270)
!270 = !{null, !28}
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !272, file: !204, line: 158)
!272 = !DISubprogram(name: "getenv", scope: !197, file: !197, line: 773, type: !273, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!273 = !DISubroutineType(types: !274)
!274 = !{!30, !235}
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !276, file: !204, line: 159)
!276 = !DISubprogram(name: "labs", scope: !197, file: !197, line: 981, type: !277, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!277 = !DISubroutineType(types: !278)
!278 = !{!104, !104}
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !280, file: !204, line: 160)
!280 = !DISubprogram(name: "ldiv", scope: !197, file: !197, line: 1000, type: !281, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!281 = !DISubroutineType(types: !282)
!282 = !{!206, !104, !104}
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !284, file: !204, line: 161)
!284 = !DISubprogram(name: "malloc", scope: !197, file: !197, line: 672, type: !285, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!285 = !DISubroutineType(types: !286)
!286 = !{!28, !219}
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !288, file: !204, line: 163)
!288 = !DISubprogram(name: "mblen", scope: !197, file: !197, line: 1068, type: !289, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!289 = !DISubroutineType(types: !290)
!290 = !{!6, !235, !219}
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !292, file: !204, line: 164)
!292 = !DISubprogram(name: "mbstowcs", scope: !197, file: !197, line: 1079, type: !293, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!293 = !DISubroutineType(types: !294)
!294 = !{!219, !295, !298, !219}
!295 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !296)
!296 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !297, size: 64)
!297 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!298 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !235)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !300, file: !204, line: 165)
!300 = !DISubprogram(name: "mbtowc", scope: !197, file: !197, line: 1071, type: !301, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!301 = !DISubroutineType(types: !302)
!302 = !{!6, !295, !298, !219}
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !304, file: !204, line: 167)
!304 = !DISubprogram(name: "qsort", scope: !197, file: !197, line: 970, type: !305, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!305 = !DISubroutineType(types: !306)
!306 = !{null, !28, !219, !219, !253}
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !308, file: !204, line: 170)
!308 = !DISubprogram(name: "quick_exit", scope: !197, file: !197, line: 762, type: !265, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !310, file: !204, line: 173)
!310 = !DISubprogram(name: "rand", scope: !197, file: !197, line: 573, type: !311, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!311 = !DISubroutineType(types: !312)
!312 = !{!6}
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !314, file: !204, line: 174)
!314 = !DISubprogram(name: "realloc", scope: !197, file: !197, line: 683, type: !315, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!315 = !DISubroutineType(types: !316)
!316 = !{!28, !28, !219}
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !318, file: !204, line: 175)
!318 = !DISubprogram(name: "srand", scope: !197, file: !197, line: 575, type: !319, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!319 = !DISubroutineType(types: !320)
!320 = !{null, !84}
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !322, file: !204, line: 176)
!322 = !DISubprogram(name: "strtod", scope: !197, file: !197, line: 118, type: !323, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!323 = !DISubroutineType(types: !324)
!324 = !{!234, !298, !325}
!325 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !29)
!326 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !327, file: !204, line: 177)
!327 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !197, file: !197, line: 215, type: !328, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!328 = !DISubroutineType(types: !329)
!329 = !{!104, !298, !325, !6}
!330 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !331, file: !204, line: 178)
!331 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !197, file: !197, line: 219, type: !332, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!332 = !DISubroutineType(types: !333)
!333 = !{!221, !298, !325, !6}
!334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !335, file: !204, line: 179)
!335 = !DISubprogram(name: "system", scope: !197, file: !197, line: 923, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !337, file: !204, line: 181)
!337 = !DISubprogram(name: "wcstombs", scope: !197, file: !197, line: 1083, type: !338, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!338 = !DISubroutineType(types: !339)
!339 = !{!219, !340, !341, !219}
!340 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !30)
!341 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !342)
!342 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !343, size: 64)
!343 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !297)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !345, file: !204, line: 182)
!345 = !DISubprogram(name: "wctomb", scope: !197, file: !197, line: 1075, type: !346, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!346 = !DISubroutineType(types: !347)
!347 = !{!6, !30, !297}
!348 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !350, file: !204, line: 210)
!349 = !DINamespace(name: "__gnu_cxx", scope: null)
!350 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !197, line: 81, baseType: !351)
!351 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !197, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !352, identifier: "_ZTS7lldiv_t")
!352 = !{!353, !355}
!353 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !351, file: !197, line: 79, baseType: !354, size: 64)
!354 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!355 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !351, file: !197, line: 80, baseType: !354, size: 64, offset: 64)
!356 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !357, file: !204, line: 216)
!357 = !DISubprogram(name: "_Exit", scope: !197, file: !197, line: 768, type: !265, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!358 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !359, file: !204, line: 222)
!359 = !DISubprogram(name: "llabs", scope: !197, file: !197, line: 984, type: !360, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!360 = !DISubroutineType(types: !361)
!361 = !{!354, !354}
!362 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !363, file: !204, line: 228)
!363 = !DISubprogram(name: "lldiv", scope: !197, file: !197, line: 1004, type: !364, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!364 = !DISubroutineType(types: !365)
!365 = !{!350, !354, !354}
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !367, file: !204, line: 240)
!367 = !DISubprogram(name: "atoll", scope: !197, file: !197, line: 493, type: !368, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!368 = !DISubroutineType(types: !369)
!369 = !{!354, !235}
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !371, file: !204, line: 241)
!371 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !197, file: !197, line: 238, type: !372, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!372 = !DISubroutineType(types: !373)
!373 = !{!354, !298, !325, !6}
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !375, file: !204, line: 242)
!375 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !197, file: !197, line: 243, type: !376, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!376 = !DISubroutineType(types: !377)
!377 = !{!24, !298, !325, !6}
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !379, file: !204, line: 244)
!379 = !DISubprogram(name: "strtof", scope: !197, file: !197, line: 124, type: !380, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!380 = !DISubroutineType(types: !381)
!381 = !{!13, !298, !325}
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !349, entity: !383, file: !204, line: 245)
!383 = !DISubprogram(name: "strtold", scope: !197, file: !197, line: 127, type: !384, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!384 = !DISubroutineType(types: !385)
!385 = !{!386, !298, !325}
!386 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!387 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !350, file: !204, line: 253)
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !357, file: !204, line: 255)
!389 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !359, file: !204, line: 257)
!390 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !391, file: !204, line: 258)
!391 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !349, file: !204, line: 225, type: !364, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !363, file: !204, line: 259)
!393 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !367, file: !204, line: 261)
!394 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !379, file: !204, line: 262)
!395 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !371, file: !204, line: 263)
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !375, file: !204, line: 264)
!397 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !383, file: !204, line: 265)
!398 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !212, file: !399, line: 38)
!399 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "6b5a21b1805b4429608f31a862826533")
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !223, file: !399, line: 39)
!401 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !264, file: !399, line: 40)
!402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !228, file: !399, line: 43)
!403 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !308, file: !399, line: 46)
!404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !357, file: !399, line: 49)
!405 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !202, file: !399, line: 54)
!406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !206, file: !399, line: 55)
!407 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !408, file: !399, line: 57)
!408 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !195, file: !200, line: 143, type: !409, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!409 = !DISubroutineType(types: !410)
!410 = !{!411, !411}
!411 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !230, file: !399, line: 58)
!413 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !237, file: !399, line: 59)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !243, file: !399, line: 60)
!415 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !247, file: !399, line: 61)
!416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !258, file: !399, line: 62)
!417 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !391, file: !399, line: 63)
!418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !268, file: !399, line: 64)
!419 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !272, file: !399, line: 65)
!420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !276, file: !399, line: 66)
!421 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !280, file: !399, line: 67)
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !284, file: !399, line: 68)
!423 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !288, file: !399, line: 70)
!424 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !292, file: !399, line: 71)
!425 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !300, file: !399, line: 72)
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !304, file: !399, line: 74)
!427 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !310, file: !399, line: 75)
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !314, file: !399, line: 76)
!429 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !318, file: !399, line: 77)
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !322, file: !399, line: 78)
!431 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !327, file: !399, line: 79)
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !331, file: !399, line: 80)
!433 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !335, file: !399, line: 81)
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !337, file: !399, line: 83)
!435 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !345, file: !399, line: 84)
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !437, file: !441, line: 96)
!437 = !DISubprogram(name: "acos", scope: !438, file: !438, line: 53, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!438 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "", checksumkind: CSK_MD5, checksum: "648aa28922bb35582fc325dd798a087b")
!439 = !DISubroutineType(types: !440)
!440 = !{!234, !234}
!441 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/cmath", directory: "", checksumkind: CSK_MD5, checksum: "8c328b3732cea7e0296e6b53109bc92f")
!442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !443, file: !441, line: 115)
!443 = !DISubprogram(name: "asin", scope: !438, file: !438, line: 55, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !445, file: !441, line: 134)
!445 = !DISubprogram(name: "atan", scope: !438, file: !438, line: 57, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!446 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !447, file: !441, line: 153)
!447 = !DISubprogram(name: "atan2", scope: !438, file: !438, line: 59, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!448 = !DISubroutineType(types: !449)
!449 = !{!234, !234, !234}
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !451, file: !441, line: 165)
!451 = !DISubprogram(name: "ceil", scope: !438, file: !438, line: 213, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!452 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !453, file: !441, line: 184)
!453 = !DISubprogram(name: "cos", scope: !438, file: !438, line: 62, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !455, file: !441, line: 203)
!455 = !DISubprogram(name: "cosh", scope: !438, file: !438, line: 93, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!456 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !457, file: !441, line: 222)
!457 = !DISubprogram(name: "exp", scope: !438, file: !438, line: 117, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!458 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !459, file: !441, line: 241)
!459 = !DISubprogram(name: "fabs", scope: !438, file: !438, line: 216, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !461, file: !441, line: 260)
!461 = !DISubprogram(name: "floor", scope: !438, file: !438, line: 219, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!462 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !463, file: !441, line: 279)
!463 = !DISubprogram(name: "fmod", scope: !438, file: !438, line: 222, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!464 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !465, file: !441, line: 291)
!465 = !DISubprogram(name: "frexp", scope: !438, file: !438, line: 120, type: !466, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!466 = !DISubroutineType(types: !467)
!467 = !{!234, !234, !5}
!468 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !469, file: !441, line: 310)
!469 = !DISubprogram(name: "ldexp", scope: !438, file: !438, line: 123, type: !470, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!470 = !DISubroutineType(types: !471)
!471 = !{!234, !234, !6}
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !473, file: !441, line: 329)
!473 = !DISubprogram(name: "log", scope: !438, file: !438, line: 126, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !475, file: !441, line: 348)
!475 = !DISubprogram(name: "log10", scope: !438, file: !438, line: 129, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !477, file: !441, line: 367)
!477 = !DISubprogram(name: "modf", scope: !438, file: !438, line: 132, type: !478, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!478 = !DISubroutineType(types: !479)
!479 = !{!234, !234, !480}
!480 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !234, size: 64)
!481 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !482, file: !441, line: 379)
!482 = !DISubprogram(name: "pow", scope: !438, file: !438, line: 177, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!483 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !484, file: !441, line: 407)
!484 = !DISubprogram(name: "sin", scope: !438, file: !438, line: 64, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!485 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !486, file: !441, line: 426)
!486 = !DISubprogram(name: "sinh", scope: !438, file: !438, line: 95, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!487 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !488, file: !441, line: 445)
!488 = !DISubprogram(name: "sqrt", scope: !438, file: !438, line: 180, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!489 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !490, file: !441, line: 464)
!490 = !DISubprogram(name: "tan", scope: !438, file: !438, line: 66, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!491 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !492, file: !441, line: 483)
!492 = !DISubprogram(name: "tanh", scope: !438, file: !438, line: 97, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!493 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !494, file: !441, line: 1827)
!494 = !DISubprogram(name: "acosf", scope: !438, file: !438, line: 53, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!495 = !DISubroutineType(types: !496)
!496 = !{!13, !13}
!497 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !498, file: !441, line: 1830)
!498 = !DISubprogram(name: "acosl", scope: !438, file: !438, line: 53, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!499 = !DISubroutineType(types: !500)
!500 = !{!386, !386}
!501 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !502, file: !441, line: 1834)
!502 = !DISubprogram(name: "asinf", scope: !438, file: !438, line: 55, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!503 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !504, file: !441, line: 1837)
!504 = !DISubprogram(name: "asinl", scope: !438, file: !438, line: 55, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!505 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !506, file: !441, line: 1841)
!506 = !DISubprogram(name: "atanf", scope: !438, file: !438, line: 57, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!507 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !508, file: !441, line: 1844)
!508 = !DISubprogram(name: "atanl", scope: !438, file: !438, line: 57, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!509 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !510, file: !441, line: 1848)
!510 = !DISubprogram(name: "atan2f", scope: !438, file: !438, line: 59, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!511 = !DISubroutineType(types: !512)
!512 = !{!13, !13, !13}
!513 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !514, file: !441, line: 1851)
!514 = !DISubprogram(name: "atan2l", scope: !438, file: !438, line: 59, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!515 = !DISubroutineType(types: !516)
!516 = !{!386, !386, !386}
!517 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !518, file: !441, line: 1855)
!518 = !DISubprogram(name: "ceilf", scope: !438, file: !438, line: 213, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!519 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !520, file: !441, line: 1858)
!520 = !DISubprogram(name: "ceill", scope: !438, file: !438, line: 213, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!521 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !522, file: !441, line: 1862)
!522 = !DISubprogram(name: "cosf", scope: !438, file: !438, line: 62, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!523 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !524, file: !441, line: 1865)
!524 = !DISubprogram(name: "cosl", scope: !438, file: !438, line: 62, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!525 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !526, file: !441, line: 1869)
!526 = !DISubprogram(name: "coshf", scope: !438, file: !438, line: 93, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!527 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !528, file: !441, line: 1872)
!528 = !DISubprogram(name: "coshl", scope: !438, file: !438, line: 93, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!529 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !530, file: !441, line: 1876)
!530 = !DISubprogram(name: "expf", scope: !438, file: !438, line: 117, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!531 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !532, file: !441, line: 1879)
!532 = !DISubprogram(name: "expl", scope: !438, file: !438, line: 117, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!533 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !534, file: !441, line: 1883)
!534 = !DISubprogram(name: "fabsf", scope: !438, file: !438, line: 216, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!535 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !536, file: !441, line: 1886)
!536 = !DISubprogram(name: "fabsl", scope: !438, file: !438, line: 216, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!537 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !538, file: !441, line: 1890)
!538 = !DISubprogram(name: "floorf", scope: !438, file: !438, line: 219, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!539 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !540, file: !441, line: 1893)
!540 = !DISubprogram(name: "floorl", scope: !438, file: !438, line: 219, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!541 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !542, file: !441, line: 1897)
!542 = !DISubprogram(name: "fmodf", scope: !438, file: !438, line: 222, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!543 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !544, file: !441, line: 1900)
!544 = !DISubprogram(name: "fmodl", scope: !438, file: !438, line: 222, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!545 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !546, file: !441, line: 1904)
!546 = !DISubprogram(name: "frexpf", scope: !438, file: !438, line: 120, type: !547, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!547 = !DISubroutineType(types: !548)
!548 = !{!13, !13, !5}
!549 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !550, file: !441, line: 1907)
!550 = !DISubprogram(name: "frexpl", scope: !438, file: !438, line: 120, type: !551, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!551 = !DISubroutineType(types: !552)
!552 = !{!386, !386, !5}
!553 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !554, file: !441, line: 1911)
!554 = !DISubprogram(name: "ldexpf", scope: !438, file: !438, line: 123, type: !555, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!555 = !DISubroutineType(types: !556)
!556 = !{!13, !13, !6}
!557 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !558, file: !441, line: 1914)
!558 = !DISubprogram(name: "ldexpl", scope: !438, file: !438, line: 123, type: !559, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!559 = !DISubroutineType(types: !560)
!560 = !{!386, !386, !6}
!561 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !562, file: !441, line: 1918)
!562 = !DISubprogram(name: "logf", scope: !438, file: !438, line: 126, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!563 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !564, file: !441, line: 1921)
!564 = !DISubprogram(name: "logl", scope: !438, file: !438, line: 126, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!565 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !566, file: !441, line: 1925)
!566 = !DISubprogram(name: "log10f", scope: !438, file: !438, line: 129, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!567 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !568, file: !441, line: 1928)
!568 = !DISubprogram(name: "log10l", scope: !438, file: !438, line: 129, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!569 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !570, file: !441, line: 1932)
!570 = !DISubprogram(name: "modff", scope: !438, file: !438, line: 132, type: !571, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!571 = !DISubroutineType(types: !572)
!572 = !{!13, !13, !23}
!573 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !574, file: !441, line: 1935)
!574 = !DISubprogram(name: "modfl", scope: !438, file: !438, line: 132, type: !575, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!575 = !DISubroutineType(types: !576)
!576 = !{!386, !386, !577}
!577 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !386, size: 64)
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !579, file: !441, line: 1939)
!579 = !DISubprogram(name: "powf", scope: !438, file: !438, line: 177, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !581, file: !441, line: 1942)
!581 = !DISubprogram(name: "powl", scope: !438, file: !438, line: 177, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !583, file: !441, line: 1946)
!583 = !DISubprogram(name: "sinf", scope: !438, file: !438, line: 64, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!584 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !585, file: !441, line: 1949)
!585 = !DISubprogram(name: "sinl", scope: !438, file: !438, line: 64, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!586 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !587, file: !441, line: 1953)
!587 = !DISubprogram(name: "sinhf", scope: !438, file: !438, line: 95, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!588 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !589, file: !441, line: 1956)
!589 = !DISubprogram(name: "sinhl", scope: !438, file: !438, line: 95, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!590 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !591, file: !441, line: 1960)
!591 = !DISubprogram(name: "sqrtf", scope: !438, file: !438, line: 180, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !593, file: !441, line: 1963)
!593 = !DISubprogram(name: "sqrtl", scope: !438, file: !438, line: 180, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!594 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !595, file: !441, line: 1967)
!595 = !DISubprogram(name: "tanf", scope: !438, file: !438, line: 66, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!596 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !597, file: !441, line: 1970)
!597 = !DISubprogram(name: "tanl", scope: !438, file: !438, line: 66, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!598 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !599, file: !441, line: 1974)
!599 = !DISubprogram(name: "tanhf", scope: !438, file: !438, line: 97, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!600 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !601, file: !441, line: 1977)
!601 = !DISubprogram(name: "tanhl", scope: !438, file: !438, line: 97, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!602 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !603, file: !441, line: 2092)
!603 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !604, line: 168, baseType: !234)
!604 = !DIFile(filename: "/usr/include/math.h", directory: "", checksumkind: CSK_MD5, checksum: "cee1a048ba70cfd541c1ab56713af6da")
!605 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !606, file: !441, line: 2093)
!606 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !604, line: 167, baseType: !13)
!607 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !608, file: !441, line: 2097)
!608 = !DISubprogram(name: "acosh", scope: !438, file: !438, line: 107, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!609 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !610, file: !441, line: 2098)
!610 = !DISubprogram(name: "acoshf", scope: !438, file: !438, line: 107, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!611 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !612, file: !441, line: 2099)
!612 = !DISubprogram(name: "acoshl", scope: !438, file: !438, line: 107, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!613 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !614, file: !441, line: 2101)
!614 = !DISubprogram(name: "asinh", scope: !438, file: !438, line: 109, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!615 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !616, file: !441, line: 2102)
!616 = !DISubprogram(name: "asinhf", scope: !438, file: !438, line: 109, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!617 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !618, file: !441, line: 2103)
!618 = !DISubprogram(name: "asinhl", scope: !438, file: !438, line: 109, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!619 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !620, file: !441, line: 2105)
!620 = !DISubprogram(name: "atanh", scope: !438, file: !438, line: 111, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!621 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !622, file: !441, line: 2106)
!622 = !DISubprogram(name: "atanhf", scope: !438, file: !438, line: 111, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!623 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !624, file: !441, line: 2107)
!624 = !DISubprogram(name: "atanhl", scope: !438, file: !438, line: 111, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!625 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !626, file: !441, line: 2109)
!626 = !DISubprogram(name: "cbrt", scope: !438, file: !438, line: 189, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!627 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !628, file: !441, line: 2110)
!628 = !DISubprogram(name: "cbrtf", scope: !438, file: !438, line: 189, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!629 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !630, file: !441, line: 2111)
!630 = !DISubprogram(name: "cbrtl", scope: !438, file: !438, line: 189, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!631 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !632, file: !441, line: 2113)
!632 = !DISubprogram(name: "copysign", scope: !438, file: !438, line: 252, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!633 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !634, file: !441, line: 2114)
!634 = !DISubprogram(name: "copysignf", scope: !438, file: !438, line: 252, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!635 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !636, file: !441, line: 2115)
!636 = !DISubprogram(name: "copysignl", scope: !438, file: !438, line: 252, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!637 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !638, file: !441, line: 2117)
!638 = !DISubprogram(name: "erf", scope: !438, file: !438, line: 285, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!639 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !640, file: !441, line: 2118)
!640 = !DISubprogram(name: "erff", scope: !438, file: !438, line: 285, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!641 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !642, file: !441, line: 2119)
!642 = !DISubprogram(name: "erfl", scope: !438, file: !438, line: 285, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!643 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !644, file: !441, line: 2121)
!644 = !DISubprogram(name: "erfc", scope: !438, file: !438, line: 286, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!645 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !646, file: !441, line: 2122)
!646 = !DISubprogram(name: "erfcf", scope: !438, file: !438, line: 286, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!647 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !648, file: !441, line: 2123)
!648 = !DISubprogram(name: "erfcl", scope: !438, file: !438, line: 286, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!649 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !650, file: !441, line: 2125)
!650 = !DISubprogram(name: "exp2", scope: !438, file: !438, line: 167, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!651 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !652, file: !441, line: 2126)
!652 = !DISubprogram(name: "exp2f", scope: !438, file: !438, line: 167, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!653 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !654, file: !441, line: 2127)
!654 = !DISubprogram(name: "exp2l", scope: !438, file: !438, line: 167, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!655 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !656, file: !441, line: 2129)
!656 = !DISubprogram(name: "expm1", scope: !438, file: !438, line: 156, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!657 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !658, file: !441, line: 2130)
!658 = !DISubprogram(name: "expm1f", scope: !438, file: !438, line: 156, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!659 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !660, file: !441, line: 2131)
!660 = !DISubprogram(name: "expm1l", scope: !438, file: !438, line: 156, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!661 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !662, file: !441, line: 2133)
!662 = !DISubprogram(name: "fdim", scope: !438, file: !438, line: 383, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!663 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !664, file: !441, line: 2134)
!664 = !DISubprogram(name: "fdimf", scope: !438, file: !438, line: 383, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!665 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !666, file: !441, line: 2135)
!666 = !DISubprogram(name: "fdiml", scope: !438, file: !438, line: 383, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!667 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !668, file: !441, line: 2137)
!668 = !DISubprogram(name: "fma", scope: !438, file: !438, line: 394, type: !669, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!669 = !DISubroutineType(types: !670)
!670 = !{!234, !234, !234, !234}
!671 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !672, file: !441, line: 2138)
!672 = !DISubprogram(name: "fmaf", scope: !438, file: !438, line: 394, type: !673, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!673 = !DISubroutineType(types: !674)
!674 = !{!13, !13, !13, !13}
!675 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !676, file: !441, line: 2139)
!676 = !DISubprogram(name: "fmal", scope: !438, file: !438, line: 394, type: !677, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!677 = !DISubroutineType(types: !678)
!678 = !{!386, !386, !386, !386}
!679 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !680, file: !441, line: 2141)
!680 = !DISubprogram(name: "fmax", scope: !438, file: !438, line: 387, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!681 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !682, file: !441, line: 2142)
!682 = !DISubprogram(name: "fmaxf", scope: !438, file: !438, line: 387, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!683 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !684, file: !441, line: 2143)
!684 = !DISubprogram(name: "fmaxl", scope: !438, file: !438, line: 387, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!685 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !686, file: !441, line: 2145)
!686 = !DISubprogram(name: "fmin", scope: !438, file: !438, line: 390, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!687 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !688, file: !441, line: 2146)
!688 = !DISubprogram(name: "fminf", scope: !438, file: !438, line: 390, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!689 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !690, file: !441, line: 2147)
!690 = !DISubprogram(name: "fminl", scope: !438, file: !438, line: 390, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!691 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !692, file: !441, line: 2149)
!692 = !DISubprogram(name: "hypot", scope: !438, file: !438, line: 184, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!693 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !694, file: !441, line: 2150)
!694 = !DISubprogram(name: "hypotf", scope: !438, file: !438, line: 184, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!695 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !696, file: !441, line: 2151)
!696 = !DISubprogram(name: "hypotl", scope: !438, file: !438, line: 184, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!697 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !698, file: !441, line: 2153)
!698 = !DISubprogram(name: "ilogb", scope: !438, file: !438, line: 337, type: !699, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!699 = !DISubroutineType(types: !700)
!700 = !{!6, !234}
!701 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !702, file: !441, line: 2154)
!702 = !DISubprogram(name: "ilogbf", scope: !438, file: !438, line: 337, type: !703, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!703 = !DISubroutineType(types: !704)
!704 = !{!6, !13}
!705 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !706, file: !441, line: 2155)
!706 = !DISubprogram(name: "ilogbl", scope: !438, file: !438, line: 337, type: !707, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!707 = !DISubroutineType(types: !708)
!708 = !{!6, !386}
!709 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !710, file: !441, line: 2157)
!710 = !DISubprogram(name: "lgamma", scope: !438, file: !438, line: 287, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!711 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !712, file: !441, line: 2158)
!712 = !DISubprogram(name: "lgammaf", scope: !438, file: !438, line: 287, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!713 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !714, file: !441, line: 2159)
!714 = !DISubprogram(name: "lgammal", scope: !438, file: !438, line: 287, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!715 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !716, file: !441, line: 2162)
!716 = !DISubprogram(name: "llrint", scope: !438, file: !438, line: 373, type: !717, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!717 = !DISubroutineType(types: !718)
!718 = !{!354, !234}
!719 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !720, file: !441, line: 2163)
!720 = !DISubprogram(name: "llrintf", scope: !438, file: !438, line: 373, type: !721, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!721 = !DISubroutineType(types: !722)
!722 = !{!354, !13}
!723 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !724, file: !441, line: 2164)
!724 = !DISubprogram(name: "llrintl", scope: !438, file: !438, line: 373, type: !725, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!725 = !DISubroutineType(types: !726)
!726 = !{!354, !386}
!727 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !728, file: !441, line: 2166)
!728 = !DISubprogram(name: "llround", scope: !438, file: !438, line: 379, type: !717, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!729 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !730, file: !441, line: 2167)
!730 = !DISubprogram(name: "llroundf", scope: !438, file: !438, line: 379, type: !721, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!731 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !732, file: !441, line: 2168)
!732 = !DISubprogram(name: "llroundl", scope: !438, file: !438, line: 379, type: !725, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!733 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !734, file: !441, line: 2171)
!734 = !DISubprogram(name: "log1p", scope: !438, file: !438, line: 159, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!735 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !736, file: !441, line: 2172)
!736 = !DISubprogram(name: "log1pf", scope: !438, file: !438, line: 159, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!737 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !738, file: !441, line: 2173)
!738 = !DISubprogram(name: "log1pl", scope: !438, file: !438, line: 159, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!739 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !740, file: !441, line: 2175)
!740 = !DISubprogram(name: "log2", scope: !438, file: !438, line: 170, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!741 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !742, file: !441, line: 2176)
!742 = !DISubprogram(name: "log2f", scope: !438, file: !438, line: 170, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!743 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !744, file: !441, line: 2177)
!744 = !DISubprogram(name: "log2l", scope: !438, file: !438, line: 170, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!745 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !746, file: !441, line: 2179)
!746 = !DISubprogram(name: "logb", scope: !438, file: !438, line: 162, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!747 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !748, file: !441, line: 2180)
!748 = !DISubprogram(name: "logbf", scope: !438, file: !438, line: 162, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!749 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !750, file: !441, line: 2181)
!750 = !DISubprogram(name: "logbl", scope: !438, file: !438, line: 162, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!751 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !752, file: !441, line: 2183)
!752 = !DISubprogram(name: "lrint", scope: !438, file: !438, line: 371, type: !753, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!753 = !DISubroutineType(types: !754)
!754 = !{!104, !234}
!755 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !756, file: !441, line: 2184)
!756 = !DISubprogram(name: "lrintf", scope: !438, file: !438, line: 371, type: !757, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!757 = !DISubroutineType(types: !758)
!758 = !{!104, !13}
!759 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !760, file: !441, line: 2185)
!760 = !DISubprogram(name: "lrintl", scope: !438, file: !438, line: 371, type: !761, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!761 = !DISubroutineType(types: !762)
!762 = !{!104, !386}
!763 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !764, file: !441, line: 2187)
!764 = !DISubprogram(name: "lround", scope: !438, file: !438, line: 377, type: !753, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!765 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !766, file: !441, line: 2188)
!766 = !DISubprogram(name: "lroundf", scope: !438, file: !438, line: 377, type: !757, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!767 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !768, file: !441, line: 2189)
!768 = !DISubprogram(name: "lroundl", scope: !438, file: !438, line: 377, type: !761, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!769 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !770, file: !441, line: 2191)
!770 = !DISubprogram(name: "nan", scope: !438, file: !438, line: 257, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!771 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !772, file: !441, line: 2192)
!772 = !DISubprogram(name: "nanf", scope: !438, file: !438, line: 257, type: !773, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!773 = !DISubroutineType(types: !774)
!774 = !{!13, !235}
!775 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !776, file: !441, line: 2193)
!776 = !DISubprogram(name: "nanl", scope: !438, file: !438, line: 257, type: !777, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!777 = !DISubroutineType(types: !778)
!778 = !{!386, !235}
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !780, file: !441, line: 2195)
!780 = !DISubprogram(name: "nearbyint", scope: !438, file: !438, line: 351, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!781 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !782, file: !441, line: 2196)
!782 = !DISubprogram(name: "nearbyintf", scope: !438, file: !438, line: 351, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!783 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !784, file: !441, line: 2197)
!784 = !DISubprogram(name: "nearbyintl", scope: !438, file: !438, line: 351, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!785 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !786, file: !441, line: 2199)
!786 = !DISubprogram(name: "nextafter", scope: !438, file: !438, line: 316, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !788, file: !441, line: 2200)
!788 = !DISubprogram(name: "nextafterf", scope: !438, file: !438, line: 316, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!789 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !790, file: !441, line: 2201)
!790 = !DISubprogram(name: "nextafterl", scope: !438, file: !438, line: 316, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !792, file: !441, line: 2203)
!792 = !DISubprogram(name: "nexttoward", scope: !438, file: !438, line: 318, type: !793, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!793 = !DISubroutineType(types: !794)
!794 = !{!234, !234, !386}
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !796, file: !441, line: 2204)
!796 = !DISubprogram(name: "nexttowardf", scope: !438, file: !438, line: 318, type: !797, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!797 = !DISubroutineType(types: !798)
!798 = !{!13, !13, !386}
!799 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !800, file: !441, line: 2205)
!800 = !DISubprogram(name: "nexttowardl", scope: !438, file: !438, line: 318, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!801 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !802, file: !441, line: 2207)
!802 = !DISubprogram(name: "remainder", scope: !438, file: !438, line: 329, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !804, file: !441, line: 2208)
!804 = !DISubprogram(name: "remainderf", scope: !438, file: !438, line: 329, type: !511, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!805 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !806, file: !441, line: 2209)
!806 = !DISubprogram(name: "remainderl", scope: !438, file: !438, line: 329, type: !515, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!807 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !808, file: !441, line: 2211)
!808 = !DISubprogram(name: "remquo", scope: !438, file: !438, line: 364, type: !809, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!809 = !DISubroutineType(types: !810)
!810 = !{!234, !234, !234, !5}
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !812, file: !441, line: 2212)
!812 = !DISubprogram(name: "remquof", scope: !438, file: !438, line: 364, type: !813, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!813 = !DISubroutineType(types: !814)
!814 = !{!13, !13, !13, !5}
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !816, file: !441, line: 2213)
!816 = !DISubprogram(name: "remquol", scope: !438, file: !438, line: 364, type: !817, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!817 = !DISubroutineType(types: !818)
!818 = !{!386, !386, !386, !5}
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !820, file: !441, line: 2215)
!820 = !DISubprogram(name: "rint", scope: !438, file: !438, line: 313, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!821 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !822, file: !441, line: 2216)
!822 = !DISubprogram(name: "rintf", scope: !438, file: !438, line: 313, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !824, file: !441, line: 2217)
!824 = !DISubprogram(name: "rintl", scope: !438, file: !438, line: 313, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!825 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !826, file: !441, line: 2219)
!826 = !DISubprogram(name: "round", scope: !438, file: !438, line: 355, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!827 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !828, file: !441, line: 2220)
!828 = !DISubprogram(name: "roundf", scope: !438, file: !438, line: 355, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!829 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !830, file: !441, line: 2221)
!830 = !DISubprogram(name: "roundl", scope: !438, file: !438, line: 355, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!831 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !832, file: !441, line: 2223)
!832 = !DISubprogram(name: "scalbln", scope: !438, file: !438, line: 347, type: !833, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!833 = !DISubroutineType(types: !834)
!834 = !{!234, !234, !104}
!835 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !836, file: !441, line: 2224)
!836 = !DISubprogram(name: "scalblnf", scope: !438, file: !438, line: 347, type: !837, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!837 = !DISubroutineType(types: !838)
!838 = !{!13, !13, !104}
!839 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !840, file: !441, line: 2225)
!840 = !DISubprogram(name: "scalblnl", scope: !438, file: !438, line: 347, type: !841, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!841 = !DISubroutineType(types: !842)
!842 = !{!386, !386, !104}
!843 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !844, file: !441, line: 2227)
!844 = !DISubprogram(name: "scalbn", scope: !438, file: !438, line: 333, type: !470, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!845 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !846, file: !441, line: 2228)
!846 = !DISubprogram(name: "scalbnf", scope: !438, file: !438, line: 333, type: !555, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!847 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !848, file: !441, line: 2229)
!848 = !DISubprogram(name: "scalbnl", scope: !438, file: !438, line: 333, type: !559, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!849 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !850, file: !441, line: 2231)
!850 = !DISubprogram(name: "tgamma", scope: !438, file: !438, line: 292, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!851 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !852, file: !441, line: 2232)
!852 = !DISubprogram(name: "tgammaf", scope: !438, file: !438, line: 292, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!853 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !854, file: !441, line: 2233)
!854 = !DISubprogram(name: "tgammal", scope: !438, file: !438, line: 292, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!855 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !856, file: !441, line: 2235)
!856 = !DISubprogram(name: "trunc", scope: !438, file: !438, line: 359, type: !439, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!857 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !858, file: !441, line: 2236)
!858 = !DISubprogram(name: "truncf", scope: !438, file: !438, line: 359, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!859 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !195, entity: !860, file: !441, line: 2237)
!860 = !DISubprogram(name: "truncl", scope: !438, file: !438, line: 359, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!861 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !862, entity: !863, file: !864, line: 58)
!862 = !DINamespace(name: "__gnu_debug", scope: null)
!863 = !DINamespace(name: "__debug", scope: !195)
!864 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/debug/debug.h", directory: "", checksumkind: CSK_MD5, checksum: "80ffd9396e36ed0eb5124a5fe3264bd2")
!865 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !408, file: !866, line: 38)
!866 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../include/c++/15/math.h", directory: "", checksumkind: CSK_MD5, checksum: "e8454f5245b3adcfe9ead86ffe0b9115")
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !2, entity: !868, file: !866, line: 54)
!868 = !DISubprogram(name: "modf", linkageName: "_ZSt4modfePe", scope: !195, file: !441, line: 375, type: !575, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!869 = !DICompositeType(tag: DW_TAG_array_type, baseType: !870, size: 8192, elements: !871)
!870 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !35, line: 27, baseType: !221)
!871 = !{!872}
!872 = !DISubrange(count: 128)
!873 = !{i32 7, !"Dwarf Version", i32 5}
!874 = !{i32 2, !"Debug Info Version", i32 3}
!875 = !{i32 1, !"wchar_size", i32 4}
!876 = !{i32 8, !"PIC Level", i32 2}
!877 = !{i32 7, !"PIE Level", i32 2}
!878 = !{i32 7, !"uwtable", i32 2}
!879 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!880 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!881 = distinct !DISubprogram(name: "CNDF", linkageName: "_Z4CNDFf", scope: !3, file: !3, line: 158, type: !495, scopeLine: 159, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !882)
!882 = !{!883, !884, !885, !886, !887, !888, !889, !890, !891, !892, !893, !894, !895, !896, !897}
!883 = !DILocalVariable(name: "InputX", arg: 1, scope: !881, file: !3, line: 158, type: !13)
!884 = !DILocalVariable(name: "sign", scope: !881, file: !3, line: 160, type: !6)
!885 = !DILocalVariable(name: "OutputX", scope: !881, file: !3, line: 162, type: !13)
!886 = !DILocalVariable(name: "xInput", scope: !881, file: !3, line: 163, type: !13)
!887 = !DILocalVariable(name: "xNPrimeofX", scope: !881, file: !3, line: 164, type: !13)
!888 = !DILocalVariable(name: "expValues", scope: !881, file: !3, line: 165, type: !13)
!889 = !DILocalVariable(name: "xK2", scope: !881, file: !3, line: 166, type: !13)
!890 = !DILocalVariable(name: "xK2_2", scope: !881, file: !3, line: 167, type: !13)
!891 = !DILocalVariable(name: "xK2_3", scope: !881, file: !3, line: 167, type: !13)
!892 = !DILocalVariable(name: "xK2_4", scope: !881, file: !3, line: 168, type: !13)
!893 = !DILocalVariable(name: "xK2_5", scope: !881, file: !3, line: 168, type: !13)
!894 = !DILocalVariable(name: "xLocal", scope: !881, file: !3, line: 169, type: !13)
!895 = !DILocalVariable(name: "xLocal_1", scope: !881, file: !3, line: 169, type: !13)
!896 = !DILocalVariable(name: "xLocal_2", scope: !881, file: !3, line: 170, type: !13)
!897 = !DILocalVariable(name: "xLocal_3", scope: !881, file: !3, line: 170, type: !13)
!898 = !DILocation(line: 0, scope: !881)
!899 = !DILocation(line: 173, column: 16, scope: !900)
!900 = distinct !DILexicalBlock(scope: !881, file: !3, line: 173, column: 9)
!901 = !DILocation(line: 182, column: 27, scope: !881)
!902 = !DILocation(line: 182, column: 36, scope: !881)
!903 = !DILocalVariable(name: "__x", arg: 1, scope: !904, file: !441, line: 226, type: !13)
!904 = distinct !DISubprogram(name: "exp", linkageName: "_ZSt3expf", scope: !195, file: !441, line: 226, type: !495, scopeLine: 227, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !905)
!905 = !{!903}
!906 = !DILocation(line: 0, scope: !904, inlinedAt: !907)
!907 = distinct !DILocation(line: 182, column: 17, scope: !881)
!908 = !DILocation(line: 227, column: 12, scope: !904, inlinedAt: !907)
!909 = !{!910, !910, i64 0}
!910 = !{!"int", !911, i64 0}
!911 = !{!"omnipotent char", !912, i64 0}
!912 = !{!"Simple C++ TBAA"}
!913 = !DILocation(line: 184, column: 18, scope: !881)
!914 = !DILocation(line: 184, column: 29, scope: !881)
!915 = !DILocation(line: 186, column: 23, scope: !881)
!916 = !DILocation(line: 186, column: 21, scope: !881)
!917 = !DILocation(line: 186, column: 11, scope: !881)
!918 = !DILocation(line: 187, column: 11, scope: !881)
!919 = !DILocation(line: 188, column: 11, scope: !881)
!920 = !DILocation(line: 189, column: 17, scope: !881)
!921 = !DILocation(line: 190, column: 19, scope: !881)
!922 = !DILocation(line: 191, column: 19, scope: !881)
!923 = !DILocation(line: 192, column: 19, scope: !881)
!924 = !DILocation(line: 194, column: 16, scope: !881)
!925 = !DILocation(line: 194, column: 20, scope: !881)
!926 = !DILocation(line: 195, column: 16, scope: !881)
!927 = !DILocation(line: 195, column: 22, scope: !881)
!928 = !DILocation(line: 196, column: 16, scope: !881)
!929 = !DILocation(line: 196, column: 22, scope: !881)
!930 = !DILocation(line: 197, column: 25, scope: !881)
!931 = !DILocation(line: 198, column: 16, scope: !881)
!932 = !DILocation(line: 198, column: 22, scope: !881)
!933 = !DILocation(line: 199, column: 25, scope: !881)
!934 = !DILocation(line: 200, column: 16, scope: !881)
!935 = !DILocation(line: 200, column: 22, scope: !881)
!936 = !DILocation(line: 201, column: 25, scope: !881)
!937 = !DILocation(line: 203, column: 25, scope: !881)
!938 = !DILocation(line: 204, column: 25, scope: !881)
!939 = !DILocation(line: 205, column: 16, scope: !881)
!940 = !DILocation(line: 209, column: 9, scope: !941)
!941 = distinct !DILexicalBlock(scope: !881, file: !3, line: 209, column: 9)
!942 = !DILocation(line: 213, column: 5, scope: !881)
!943 = distinct !DISubprogram(name: "print_xmm", linkageName: "_Z9print_xmmfPc", scope: !3, file: !3, line: 217, type: !944, scopeLine: 217, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !946)
!944 = !DISubroutineType(types: !945)
!945 = !{null, !13, !30}
!946 = !{!947, !948}
!947 = !DILocalVariable(name: "in", arg: 1, scope: !943, file: !3, line: 217, type: !13)
!948 = !DILocalVariable(name: "s", arg: 2, scope: !943, file: !3, line: 217, type: !30)
!949 = !DILocation(line: 0, scope: !943)
!950 = !DILocation(line: 218, column: 27, scope: !943)
!951 = !DILocation(line: 218, column: 5, scope: !943)
!952 = !DILocation(line: 219, column: 1, scope: !943)
!953 = !DISubprogram(name: "printf", scope: !954, file: !954, line: 366, type: !955, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!954 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "2b86e735d437d54be7e36ccbb6a06d84")
!955 = !DISubroutineType(types: !956)
!956 = !{!6, !298, null}
!957 = distinct !DISubprogram(name: "BlkSchlsEqEuroNoDiv", linkageName: "_Z19BlkSchlsEqEuroNoDivfffffif", scope: !3, file: !3, line: 225, type: !958, scopeLine: 228, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !960)
!958 = !DISubroutineType(types: !959)
!959 = !{!13, !13, !13, !13, !13, !13, !6, !13}
!960 = !{!961, !962, !963, !964, !965, !966, !967, !968, !969, !970, !971, !972, !973, !974, !975, !976, !977, !978, !979, !980, !981, !982, !983, !984, !985, !986, !987}
!961 = !DILocalVariable(name: "sptprice", arg: 1, scope: !957, file: !3, line: 225, type: !13)
!962 = !DILocalVariable(name: "strike", arg: 2, scope: !957, file: !3, line: 226, type: !13)
!963 = !DILocalVariable(name: "rate", arg: 3, scope: !957, file: !3, line: 226, type: !13)
!964 = !DILocalVariable(name: "volatility", arg: 4, scope: !957, file: !3, line: 226, type: !13)
!965 = !DILocalVariable(name: "time", arg: 5, scope: !957, file: !3, line: 227, type: !13)
!966 = !DILocalVariable(name: "otype", arg: 6, scope: !957, file: !3, line: 227, type: !6)
!967 = !DILocalVariable(name: "timet", arg: 7, scope: !957, file: !3, line: 227, type: !13)
!968 = !DILocalVariable(name: "OptionPrice", scope: !957, file: !3, line: 229, type: !13)
!969 = !DILocalVariable(name: "xStockPrice", scope: !957, file: !3, line: 232, type: !13)
!970 = !DILocalVariable(name: "xStrikePrice", scope: !957, file: !3, line: 233, type: !13)
!971 = !DILocalVariable(name: "xRiskFreeRate", scope: !957, file: !3, line: 234, type: !13)
!972 = !DILocalVariable(name: "xVolatility", scope: !957, file: !3, line: 235, type: !13)
!973 = !DILocalVariable(name: "xTime", scope: !957, file: !3, line: 236, type: !13)
!974 = !DILocalVariable(name: "xSqrtTime", scope: !957, file: !3, line: 237, type: !13)
!975 = !DILocalVariable(name: "logValues", scope: !957, file: !3, line: 239, type: !13)
!976 = !DILocalVariable(name: "xLogTerm", scope: !957, file: !3, line: 240, type: !13)
!977 = !DILocalVariable(name: "xD1", scope: !957, file: !3, line: 241, type: !13)
!978 = !DILocalVariable(name: "xD2", scope: !957, file: !3, line: 242, type: !13)
!979 = !DILocalVariable(name: "xPowerTerm", scope: !957, file: !3, line: 243, type: !13)
!980 = !DILocalVariable(name: "xDen", scope: !957, file: !3, line: 244, type: !13)
!981 = !DILocalVariable(name: "d1", scope: !957, file: !3, line: 245, type: !13)
!982 = !DILocalVariable(name: "d2", scope: !957, file: !3, line: 246, type: !13)
!983 = !DILocalVariable(name: "FutureValueX", scope: !957, file: !3, line: 247, type: !13)
!984 = !DILocalVariable(name: "NofXd1", scope: !957, file: !3, line: 248, type: !13)
!985 = !DILocalVariable(name: "NofXd2", scope: !957, file: !3, line: 249, type: !13)
!986 = !DILocalVariable(name: "NegNofXd1", scope: !957, file: !3, line: 250, type: !13)
!987 = !DILocalVariable(name: "NegNofXd2", scope: !957, file: !3, line: 251, type: !13)
!988 = !DILocation(line: 0, scope: !957)
!989 = !DILocalVariable(name: "__x", arg: 1, scope: !990, file: !441, line: 449, type: !13)
!990 = distinct !DISubprogram(name: "sqrt", linkageName: "_ZSt4sqrtf", scope: !195, file: !441, line: 449, type: !495, scopeLine: 450, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !991)
!991 = !{!989}
!992 = !DILocation(line: 0, scope: !990, inlinedAt: !993)
!993 = distinct !DILocation(line: 259, column: 17, scope: !957)
!994 = !DILocation(line: 450, column: 12, scope: !990, inlinedAt: !993)
!995 = !DILocation(line: 261, column: 31, scope: !957)
!996 = !DILocalVariable(name: "__x", arg: 1, scope: !997, file: !441, line: 333, type: !13)
!997 = distinct !DISubprogram(name: "log", linkageName: "_ZSt3logf", scope: !195, file: !441, line: 333, type: !495, scopeLine: 334, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !998)
!998 = !{!996}
!999 = !DILocation(line: 0, scope: !997, inlinedAt: !1000)
!1000 = distinct !DILocation(line: 261, column: 17, scope: !957)
!1001 = !DILocation(line: 334, column: 12, scope: !997, inlinedAt: !1000)
!1002 = !DILocation(line: 266, column: 30, scope: !957)
!1003 = !DILocation(line: 267, column: 18, scope: !957)
!1004 = !DILocation(line: 269, column: 25, scope: !957)
!1005 = !DILocation(line: 270, column: 15, scope: !957)
!1006 = !DILocation(line: 271, column: 15, scope: !957)
!1007 = !DILocation(line: 273, column: 24, scope: !957)
!1008 = !DILocation(line: 274, column: 15, scope: !957)
!1009 = !DILocation(line: 275, column: 15, scope: !957)
!1010 = !DILocation(line: 0, scope: !881, inlinedAt: !1011)
!1011 = distinct !DILocation(line: 280, column: 14, scope: !957)
!1012 = !DILocation(line: 173, column: 16, scope: !900, inlinedAt: !1011)
!1013 = !DILocation(line: 182, column: 27, scope: !881, inlinedAt: !1011)
!1014 = !DILocation(line: 182, column: 36, scope: !881, inlinedAt: !1011)
!1015 = !DILocation(line: 0, scope: !904, inlinedAt: !1016)
!1016 = distinct !DILocation(line: 182, column: 17, scope: !881, inlinedAt: !1011)
!1017 = !DILocation(line: 227, column: 12, scope: !904, inlinedAt: !1016)
!1018 = !DILocation(line: 184, column: 18, scope: !881, inlinedAt: !1011)
!1019 = !DILocation(line: 184, column: 29, scope: !881, inlinedAt: !1011)
!1020 = !DILocation(line: 186, column: 23, scope: !881, inlinedAt: !1011)
!1021 = !DILocation(line: 186, column: 21, scope: !881, inlinedAt: !1011)
!1022 = !DILocation(line: 186, column: 11, scope: !881, inlinedAt: !1011)
!1023 = !DILocation(line: 187, column: 11, scope: !881, inlinedAt: !1011)
!1024 = !DILocation(line: 188, column: 11, scope: !881, inlinedAt: !1011)
!1025 = !DILocation(line: 189, column: 17, scope: !881, inlinedAt: !1011)
!1026 = !DILocation(line: 190, column: 19, scope: !881, inlinedAt: !1011)
!1027 = !DILocation(line: 191, column: 19, scope: !881, inlinedAt: !1011)
!1028 = !DILocation(line: 192, column: 19, scope: !881, inlinedAt: !1011)
!1029 = !DILocation(line: 194, column: 16, scope: !881, inlinedAt: !1011)
!1030 = !DILocation(line: 194, column: 20, scope: !881, inlinedAt: !1011)
!1031 = !DILocation(line: 195, column: 16, scope: !881, inlinedAt: !1011)
!1032 = !DILocation(line: 195, column: 22, scope: !881, inlinedAt: !1011)
!1033 = !DILocation(line: 196, column: 16, scope: !881, inlinedAt: !1011)
!1034 = !DILocation(line: 196, column: 22, scope: !881, inlinedAt: !1011)
!1035 = !DILocation(line: 197, column: 25, scope: !881, inlinedAt: !1011)
!1036 = !DILocation(line: 198, column: 16, scope: !881, inlinedAt: !1011)
!1037 = !DILocation(line: 198, column: 22, scope: !881, inlinedAt: !1011)
!1038 = !DILocation(line: 199, column: 25, scope: !881, inlinedAt: !1011)
!1039 = !DILocation(line: 200, column: 16, scope: !881, inlinedAt: !1011)
!1040 = !DILocation(line: 200, column: 22, scope: !881, inlinedAt: !1011)
!1041 = !DILocation(line: 201, column: 25, scope: !881, inlinedAt: !1011)
!1042 = !DILocation(line: 203, column: 25, scope: !881, inlinedAt: !1011)
!1043 = !DILocation(line: 204, column: 25, scope: !881, inlinedAt: !1011)
!1044 = !DILocation(line: 205, column: 16, scope: !881, inlinedAt: !1011)
!1045 = !DILocation(line: 209, column: 9, scope: !941, inlinedAt: !1011)
!1046 = !DILocation(line: 0, scope: !881, inlinedAt: !1047)
!1047 = distinct !DILocation(line: 281, column: 14, scope: !957)
!1048 = !DILocation(line: 173, column: 16, scope: !900, inlinedAt: !1047)
!1049 = !DILocation(line: 182, column: 27, scope: !881, inlinedAt: !1047)
!1050 = !DILocation(line: 182, column: 36, scope: !881, inlinedAt: !1047)
!1051 = !DILocation(line: 0, scope: !904, inlinedAt: !1052)
!1052 = distinct !DILocation(line: 182, column: 17, scope: !881, inlinedAt: !1047)
!1053 = !DILocation(line: 227, column: 12, scope: !904, inlinedAt: !1052)
!1054 = !DILocation(line: 184, column: 18, scope: !881, inlinedAt: !1047)
!1055 = !DILocation(line: 184, column: 29, scope: !881, inlinedAt: !1047)
!1056 = !DILocation(line: 186, column: 23, scope: !881, inlinedAt: !1047)
!1057 = !DILocation(line: 186, column: 21, scope: !881, inlinedAt: !1047)
!1058 = !DILocation(line: 186, column: 11, scope: !881, inlinedAt: !1047)
!1059 = !DILocation(line: 187, column: 11, scope: !881, inlinedAt: !1047)
!1060 = !DILocation(line: 188, column: 11, scope: !881, inlinedAt: !1047)
!1061 = !DILocation(line: 189, column: 17, scope: !881, inlinedAt: !1047)
!1062 = !DILocation(line: 190, column: 19, scope: !881, inlinedAt: !1047)
!1063 = !DILocation(line: 191, column: 19, scope: !881, inlinedAt: !1047)
!1064 = !DILocation(line: 192, column: 19, scope: !881, inlinedAt: !1047)
!1065 = !DILocation(line: 194, column: 16, scope: !881, inlinedAt: !1047)
!1066 = !DILocation(line: 194, column: 20, scope: !881, inlinedAt: !1047)
!1067 = !DILocation(line: 195, column: 16, scope: !881, inlinedAt: !1047)
!1068 = !DILocation(line: 195, column: 22, scope: !881, inlinedAt: !1047)
!1069 = !DILocation(line: 196, column: 16, scope: !881, inlinedAt: !1047)
!1070 = !DILocation(line: 196, column: 22, scope: !881, inlinedAt: !1047)
!1071 = !DILocation(line: 197, column: 25, scope: !881, inlinedAt: !1047)
!1072 = !DILocation(line: 198, column: 16, scope: !881, inlinedAt: !1047)
!1073 = !DILocation(line: 198, column: 22, scope: !881, inlinedAt: !1047)
!1074 = !DILocation(line: 199, column: 25, scope: !881, inlinedAt: !1047)
!1075 = !DILocation(line: 200, column: 16, scope: !881, inlinedAt: !1047)
!1076 = !DILocation(line: 200, column: 22, scope: !881, inlinedAt: !1047)
!1077 = !DILocation(line: 201, column: 25, scope: !881, inlinedAt: !1047)
!1078 = !DILocation(line: 203, column: 25, scope: !881, inlinedAt: !1047)
!1079 = !DILocation(line: 204, column: 25, scope: !881, inlinedAt: !1047)
!1080 = !DILocation(line: 205, column: 16, scope: !881, inlinedAt: !1047)
!1081 = !DILocation(line: 209, column: 9, scope: !941, inlinedAt: !1047)
!1082 = !DILocation(line: 283, column: 36, scope: !957)
!1083 = !DILocation(line: 283, column: 43, scope: !957)
!1084 = !DILocation(line: 0, scope: !904, inlinedAt: !1085)
!1085 = distinct !DILocation(line: 283, column: 31, scope: !957)
!1086 = !DILocation(line: 227, column: 12, scope: !904, inlinedAt: !1085)
!1087 = !DILocation(line: 283, column: 27, scope: !957)
!1088 = !DILocation(line: 284, column: 15, scope: !1089)
!1089 = distinct !DILexicalBlock(scope: !957, file: !3, line: 284, column: 9)
!1090 = !DILocation(line: 285, column: 43, scope: !1091)
!1091 = distinct !DILexicalBlock(scope: !1089, file: !3, line: 284, column: 21)
!1092 = !DILocation(line: 286, column: 5, scope: !1091)
!1093 = !DILocation(line: 287, column: 21, scope: !1094)
!1094 = distinct !DILexicalBlock(scope: !1089, file: !3, line: 286, column: 12)
!1095 = !DILocation(line: 288, column: 21, scope: !1094)
!1096 = !DILocation(line: 289, column: 50, scope: !1094)
!1097 = !DILocation(line: 0, scope: !1089)
!1098 = !DILocation(line: 292, column: 5, scope: !957)
!1099 = distinct !DISubprogram(name: "bs_thread", linkageName: "_Z9bs_threadPv", scope: !3, file: !3, line: 308, type: !1100, scopeLine: 308, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1102)
!1100 = !DISubroutineType(types: !1101)
!1101 = !{!6, !28}
!1102 = !{!1103, !1104, !1105, !1106, !1107, !1108, !1109, !1110, !1111, !1118, !1119}
!1103 = !DILocalVariable(name: "tid_ptr", arg: 1, scope: !1099, file: !3, line: 308, type: !28)
!1104 = !DILocalVariable(name: "i", scope: !1099, file: !3, line: 310, type: !6)
!1105 = !DILocalVariable(name: "j", scope: !1099, file: !3, line: 310, type: !6)
!1106 = !DILocalVariable(name: "price", scope: !1099, file: !3, line: 311, type: !13)
!1107 = !DILocalVariable(name: "priceDelta", scope: !1099, file: !3, line: 312, type: !13)
!1108 = !DILocalVariable(name: "tid", scope: !1099, file: !3, line: 313, type: !6)
!1109 = !DILocalVariable(name: "start", scope: !1099, file: !3, line: 314, type: !6)
!1110 = !DILocalVariable(name: "end", scope: !1099, file: !3, line: 315, type: !6)
!1111 = !DILocalVariable(name: "finalIteration", scope: !1112, file: !3, line: 324, type: !6)
!1112 = distinct !DILexicalBlock(scope: !1113, file: !3, line: 322, column: 35)
!1113 = distinct !DILexicalBlock(scope: !1114, file: !3, line: 322, column: 9)
!1114 = distinct !DILexicalBlock(scope: !1115, file: !3, line: 322, column: 9)
!1115 = distinct !DILexicalBlock(scope: !1116, file: !3, line: 317, column: 32)
!1116 = distinct !DILexicalBlock(scope: !1117, file: !3, line: 317, column: 5)
!1117 = distinct !DILexicalBlock(scope: !1099, file: !3, line: 317, column: 5)
!1118 = !DILocalVariable(name: "firstIteration", scope: !1112, file: !3, line: 325, type: !6)
!1119 = !DILocalVariable(name: "readGlobal", scope: !1120, file: !3, line: 332, type: !6)
!1120 = distinct !DILexicalBlock(scope: !1121, file: !3, line: 331, column: 44)
!1121 = distinct !DILexicalBlock(scope: !1112, file: !3, line: 331, column: 14)
!1122 = !DILocation(line: 0, scope: !1099)
!1123 = !DILocation(line: 314, column: 24, scope: !1099)
!1124 = !DILocation(line: 314, column: 37, scope: !1099)
!1125 = !DILocation(line: 314, column: 35, scope: !1099)
!1126 = !DILocation(line: 322, column: 24, scope: !1113)
!1127 = !DILocation(line: 322, column: 9, scope: !1114)
!1128 = !DILocation(line: 313, column: 15, scope: !1099)
!1129 = !DILocation(line: 314, column: 21, scope: !1099)
!1130 = !DILocation(line: 315, column: 21, scope: !1099)
!1131 = !DILocation(line: 324, column: 34, scope: !1112)
!1132 = !DILocation(line: 325, column: 34, scope: !1112)
!1133 = !DILocation(line: 0, scope: !1112)
!1134 = !DILocation(line: 326, column: 29, scope: !1135)
!1135 = distinct !DILexicalBlock(scope: !1112, file: !3, line: 326, column: 14)
!1136 = !DILocation(line: 327, column: 13, scope: !1137)
!1137 = distinct !DILexicalBlock(scope: !1135, file: !3, line: 326, column: 44)
!1138 = !DILocation(line: 328, column: 22, scope: !1137)
!1139 = !DILocation(line: 329, column: 13, scope: !1137)
!1140 = !DILocation(line: 330, column: 11, scope: !1137)
!1141 = !DILocation(line: 331, column: 29, scope: !1121)
!1142 = !DILocation(line: 333, column: 13, scope: !1120)
!1143 = !DILocation(line: 334, column: 25, scope: !1120)
!1144 = !DILocation(line: 0, scope: !1120)
!1145 = !DILocation(line: 335, column: 13, scope: !1120)
!1146 = !DILocation(line: 336, column: 13, scope: !1120)
!1147 = !DILocation(line: 337, column: 27, scope: !1148)
!1148 = distinct !DILexicalBlock(scope: !1120, file: !3, line: 337, column: 17)
!1149 = !DILocation(line: 338, column: 16, scope: !1150)
!1150 = distinct !DILexicalBlock(scope: !1148, file: !3, line: 337, column: 32)
!1151 = !DILocation(line: 340, column: 13, scope: !1120)
!1152 = !DILocation(line: 341, column: 11, scope: !1120)
!1153 = !DILocation(line: 345, column: 42, scope: !1112)
!1154 = !{!1155, !1155, i64 0}
!1155 = !{!"p1 float", !1156, i64 0}
!1156 = !{!"any pointer", !911, i64 0}
!1157 = !{!1158, !1158, i64 0}
!1158 = !{!"float", !911, i64 0}
!1159 = !DILocation(line: 345, column: 55, scope: !1112)
!1160 = !DILocation(line: 346, column: 42, scope: !1112)
!1161 = !DILocation(line: 346, column: 51, scope: !1112)
!1162 = !DILocation(line: 346, column: 66, scope: !1112)
!1163 = !DILocation(line: 347, column: 42, scope: !1112)
!1164 = !{!1165, !1165, i64 0}
!1165 = !{!"p1 int", !1156, i64 0}
!1166 = !DILocation(line: 345, column: 21, scope: !1112)
!1167 = !DILocation(line: 348, column: 13, scope: !1112)
!1168 = !DILocation(line: 348, column: 23, scope: !1112)
!1169 = !DILocation(line: 322, column: 31, scope: !1113)
!1170 = distinct !{!1170, !1127, !1171, !1172, !1173}
!1171 = !DILocation(line: 358, column: 9, scope: !1114)
!1172 = !{!"llvm.loop.mustprogress"}
!1173 = !{!"llvm.loop.unroll.disable"}
!1174 = !DILocation(line: 361, column: 5, scope: !1099)
!1175 = !DISubprogram(name: "pthread_mutex_lock", scope: !1176, file: !1176, line: 794, type: !1177, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1176 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "6e3fd55f44fd51456665b56ba786ebd8")
!1177 = !DISubroutineType(types: !1178)
!1178 = !{!6, !1179}
!1179 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!1180 = !DISubprogram(name: "pthread_mutex_unlock", scope: !1176, file: !1176, line: 835, type: !1177, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1181 = !DISubprogram(name: "__assert_fail", scope: !1182, file: !1182, line: 69, type: !1183, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!1182 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "5d9a3ca8737f6c9cd6169410628dc4cc")
!1183 = !DISubroutineType(types: !1184)
!1184 = !{null, !235, !235, !84, !235}
!1185 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 364, type: !1186, scopeLine: 365, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1188)
!1186 = !DISubroutineType(types: !1187)
!1187 = !{!6, !6, !29}
!1188 = !{!1189, !1190, !1191, !1250, !1251, !1252, !1253, !1254, !1255, !1256, !1257, !1259, !1260, !1264, !1269, !1271}
!1189 = !DILocalVariable(name: "argc", arg: 1, scope: !1185, file: !3, line: 364, type: !6)
!1190 = !DILocalVariable(name: "argv", arg: 2, scope: !1185, file: !3, line: 364, type: !29)
!1191 = !DILocalVariable(name: "file", scope: !1185, file: !3, line: 366, type: !1192)
!1192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1193, size: 64)
!1193 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !1194, line: 7, baseType: !1195)
!1194 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!1195 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !1196, line: 51, size: 1728, flags: DIFlagTypePassByValue, elements: !1197, identifier: "_ZTS8_IO_FILE")
!1196 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "d20afd864d3b94b5c811d3345d9317bb")
!1197 = !{!1198, !1199, !1200, !1201, !1202, !1203, !1204, !1205, !1206, !1207, !1208, !1209, !1210, !1213, !1215, !1216, !1217, !1221, !1224, !1226, !1228, !1229, !1232, !1234, !1237, !1240, !1241, !1242, !1244, !1245, !1246, !1248}
!1198 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !1195, file: !1196, line: 53, baseType: !6, size: 32)
!1199 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !1195, file: !1196, line: 56, baseType: !30, size: 64, offset: 64)
!1200 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !1195, file: !1196, line: 57, baseType: !30, size: 64, offset: 128)
!1201 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !1195, file: !1196, line: 58, baseType: !30, size: 64, offset: 192)
!1202 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !1195, file: !1196, line: 59, baseType: !30, size: 64, offset: 256)
!1203 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !1195, file: !1196, line: 60, baseType: !30, size: 64, offset: 320)
!1204 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !1195, file: !1196, line: 61, baseType: !30, size: 64, offset: 384)
!1205 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !1195, file: !1196, line: 62, baseType: !30, size: 64, offset: 448)
!1206 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !1195, file: !1196, line: 63, baseType: !30, size: 64, offset: 512)
!1207 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !1195, file: !1196, line: 66, baseType: !30, size: 64, offset: 576)
!1208 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !1195, file: !1196, line: 67, baseType: !30, size: 64, offset: 640)
!1209 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !1195, file: !1196, line: 68, baseType: !30, size: 64, offset: 704)
!1210 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !1195, file: !1196, line: 70, baseType: !1211, size: 64, offset: 768)
!1211 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1212, size: 64)
!1212 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !1196, line: 38, flags: DIFlagFwdDecl | DIFlagNonTrivial, identifier: "_ZTS10_IO_marker")
!1213 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !1195, file: !1196, line: 72, baseType: !1214, size: 64, offset: 832)
!1214 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1195, size: 64)
!1215 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !1195, file: !1196, line: 74, baseType: !6, size: 32, offset: 896)
!1216 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !1195, file: !1196, line: 75, baseType: !6, size: 24, offset: 928, flags: DIFlagBitField, extraData: i64 928)
!1217 = !DIDerivedType(tag: DW_TAG_member, name: "_short_backupbuf", scope: !1195, file: !1196, line: 77, baseType: !1218, size: 8, offset: 952)
!1218 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 8, elements: !1219)
!1219 = !{!1220}
!1220 = !DISubrange(count: 1)
!1221 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !1195, file: !1196, line: 78, baseType: !1222, size: 64, offset: 960)
!1222 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !1223, line: 152, baseType: !104)
!1223 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!1224 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !1195, file: !1196, line: 81, baseType: !1225, size: 16, offset: 1024)
!1225 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!1226 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !1195, file: !1196, line: 82, baseType: !1227, size: 8, offset: 1040)
!1227 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!1228 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !1195, file: !1196, line: 83, baseType: !1218, size: 8, offset: 1048)
!1229 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !1195, file: !1196, line: 85, baseType: !1230, size: 64, offset: 1088)
!1230 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1231, size: 64)
!1231 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !1196, line: 45, baseType: null)
!1232 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !1195, file: !1196, line: 93, baseType: !1233, size: 64, offset: 1152)
!1233 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !1223, line: 153, baseType: !104)
!1234 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !1195, file: !1196, line: 95, baseType: !1235, size: 64, offset: 1216)
!1235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1236, size: 64)
!1236 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !1196, line: 39, flags: DIFlagFwdDecl | DIFlagNonTrivial, identifier: "_ZTS11_IO_codecvt")
!1237 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !1195, file: !1196, line: 96, baseType: !1238, size: 64, offset: 1280)
!1238 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1239, size: 64)
!1239 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !1196, line: 40, flags: DIFlagFwdDecl | DIFlagNonTrivial, identifier: "_ZTS13_IO_wide_data")
!1240 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !1195, file: !1196, line: 97, baseType: !1214, size: 64, offset: 1344)
!1241 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !1195, file: !1196, line: 98, baseType: !28, size: 64, offset: 1408)
!1242 = !DIDerivedType(tag: DW_TAG_member, name: "_prevchain", scope: !1195, file: !1196, line: 99, baseType: !1243, size: 64, offset: 1472)
!1243 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1214, size: 64)
!1244 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !1195, file: !1196, line: 100, baseType: !6, size: 32, offset: 1536)
!1245 = !DIDerivedType(tag: DW_TAG_member, name: "_unused3", scope: !1195, file: !1196, line: 102, baseType: !6, size: 32, offset: 1568)
!1246 = !DIDerivedType(tag: DW_TAG_member, name: "_total_written", scope: !1195, file: !1196, line: 104, baseType: !1247, size: 64, offset: 1600)
!1247 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !1223, line: 45, baseType: !221)
!1248 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !1195, file: !1196, line: 109, baseType: !1249, size: 64, offset: 1664)
!1249 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 64, elements: !71)
!1250 = !DILocalVariable(name: "i", scope: !1185, file: !3, line: 367, type: !6)
!1251 = !DILocalVariable(name: "loopnum", scope: !1185, file: !3, line: 368, type: !6)
!1252 = !DILocalVariable(name: "buffer", scope: !1185, file: !3, line: 369, type: !23)
!1253 = !DILocalVariable(name: "buffer2", scope: !1185, file: !3, line: 370, type: !5)
!1254 = !DILocalVariable(name: "rv", scope: !1185, file: !3, line: 371, type: !6)
!1255 = !DILocalVariable(name: "inputFile", scope: !1185, file: !3, line: 393, type: !30)
!1256 = !DILocalVariable(name: "outputFile", scope: !1185, file: !3, line: 394, type: !30)
!1257 = !DILocalVariable(name: "_M4_i", scope: !1258, file: !3, line: 444, type: !6)
!1258 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 443, column: 5)
!1259 = !DILocalVariable(name: "__vla_expr0", scope: !1185, type: !221, flags: DIFlagArtificial)
!1260 = !DILocalVariable(name: "tids", scope: !1185, file: !3, line: 482, type: !1261)
!1261 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, elements: !1262)
!1262 = !{!1263}
!1263 = !DISubrange(count: !1259)
!1264 = !DILocalVariable(name: "_M4_i", scope: !1265, file: !3, line: 487, type: !6)
!1265 = distinct !DILexicalBlock(scope: !1266, file: !3, line: 486, column: 5)
!1266 = distinct !DILexicalBlock(scope: !1267, file: !3, line: 483, column: 31)
!1267 = distinct !DILexicalBlock(scope: !1268, file: !3, line: 483, column: 5)
!1268 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 483, column: 5)
!1269 = !DILocalVariable(name: "_M4_i", scope: !1270, file: !3, line: 498, type: !6)
!1270 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 497, column: 5)
!1271 = !DILocalVariable(name: "_M4_ret", scope: !1270, file: !3, line: 499, type: !28)
!1272 = distinct !DIAssignID()
!1273 = !DILocation(line: 0, scope: !1270)
!1274 = !DILocation(line: 0, scope: !1185)
!1275 = !DILocation(line: 372, column: 2, scope: !1185)
!1276 = !DILocation(line: 373, column: 13, scope: !1185)
!1277 = !DILocation(line: 380, column: 9, scope: !1185)
!1278 = !DILocation(line: 381, column: 2, scope: !1185)
!1279 = !DILocation(line: 387, column: 13, scope: !1280)
!1280 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 387, column: 8)
!1281 = !DILocation(line: 389, column: 78, scope: !1282)
!1282 = distinct !DILexicalBlock(scope: !1280, file: !3, line: 388, column: 9)
!1283 = !{!1284, !1284, i64 0}
!1284 = !{!"p1 omnipotent char", !1156, i64 0}
!1285 = !DILocation(line: 389, column: 17, scope: !1282)
!1286 = !DILocation(line: 390, column: 17, scope: !1282)
!1287 = !DILocation(line: 392, column: 21, scope: !1185)
!1288 = !DILocation(line: 0, scope: !237, inlinedAt: !1289)
!1289 = distinct !DILocation(line: 392, column: 16, scope: !1185)
!1290 = !DILocation(line: 483, column: 16, scope: !237, inlinedAt: !1289)
!1291 = !DILocation(line: 392, column: 14, scope: !1185)
!1292 = !DILocation(line: 393, column: 23, scope: !1185)
!1293 = !DILocation(line: 394, column: 24, scope: !1185)
!1294 = !DILocation(line: 397, column: 12, scope: !1185)
!1295 = !DILocation(line: 398, column: 13, scope: !1296)
!1296 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 398, column: 8)
!1297 = !DILocation(line: 399, column: 7, scope: !1298)
!1298 = distinct !DILexicalBlock(scope: !1296, file: !3, line: 398, column: 22)
!1299 = !DILocation(line: 400, column: 7, scope: !1298)
!1300 = !DILocation(line: 402, column: 10, scope: !1185)
!1301 = !DILocation(line: 403, column: 11, scope: !1302)
!1302 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 403, column: 8)
!1303 = !DILocation(line: 404, column: 7, scope: !1304)
!1304 = distinct !DILexicalBlock(scope: !1302, file: !3, line: 403, column: 17)
!1305 = !DILocation(line: 405, column: 7, scope: !1304)
!1306 = !DILocation(line: 406, column: 7, scope: !1304)
!1307 = !DILocation(line: 408, column: 8, scope: !1308)
!1308 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 408, column: 8)
!1309 = !DILocation(line: 408, column: 19, scope: !1308)
!1310 = !DILocation(line: 408, column: 17, scope: !1308)
!1311 = !DILocation(line: 409, column: 7, scope: !1312)
!1312 = distinct !DILexicalBlock(scope: !1308, file: !3, line: 408, column: 31)
!1313 = !DILocation(line: 410, column: 18, scope: !1312)
!1314 = !DILocation(line: 410, column: 16, scope: !1312)
!1315 = !DILocation(line: 411, column: 5, scope: !1312)
!1316 = !DILocation(line: 421, column: 32, scope: !1185)
!1317 = !DILocation(line: 421, column: 42, scope: !1185)
!1318 = !DILocation(line: 421, column: 25, scope: !1185)
!1319 = !DILocation(line: 421, column: 10, scope: !1185)
!1320 = !{!1321, !1321, i64 0}
!1321 = !{!"p1 _ZTS11OptionData_", !1156, i64 0}
!1322 = !DILocation(line: 422, column: 40, scope: !1185)
!1323 = !DILocation(line: 422, column: 23, scope: !1185)
!1324 = !DILocation(line: 422, column: 12, scope: !1185)
!1325 = !DILocation(line: 423, column: 34, scope: !1326)
!1326 = distinct !DILexicalBlock(scope: !1327, file: !3, line: 423, column: 5)
!1327 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 423, column: 5)
!1328 = !DILocation(line: 423, column: 32, scope: !1326)
!1329 = !DILocation(line: 423, column: 5, scope: !1327)
!1330 = !DILocation(line: 423, column: 46, scope: !1326)
!1331 = distinct !{!1331, !1329, !1332, !1172, !1173}
!1332 = !DILocation(line: 431, column: 5, scope: !1327)
!1333 = !DILocation(line: 425, column: 58, scope: !1334)
!1334 = distinct !DILexicalBlock(scope: !1326, file: !3, line: 424, column: 5)
!1335 = !DILocation(line: 425, column: 90, scope: !1334)
!1336 = !DILocation(line: 425, column: 113, scope: !1334)
!1337 = !DILocation(line: 425, column: 131, scope: !1334)
!1338 = !DILocation(line: 425, column: 152, scope: !1334)
!1339 = !DILocation(line: 425, column: 170, scope: !1334)
!1340 = !DILocation(line: 425, column: 188, scope: !1334)
!1341 = !DILocation(line: 425, column: 215, scope: !1334)
!1342 = !DILocation(line: 425, column: 236, scope: !1334)
!1343 = !DILocation(line: 425, column: 14, scope: !1334)
!1344 = !DILocation(line: 426, column: 15, scope: !1345)
!1345 = distinct !DILexicalBlock(scope: !1334, file: !3, line: 426, column: 12)
!1346 = !DILocation(line: 427, column: 11, scope: !1347)
!1347 = distinct !DILexicalBlock(scope: !1345, file: !3, line: 426, column: 21)
!1348 = !DILocation(line: 428, column: 11, scope: !1347)
!1349 = !DILocation(line: 429, column: 11, scope: !1347)
!1350 = !DILocation(line: 432, column: 10, scope: !1185)
!1351 = !DILocation(line: 433, column: 11, scope: !1352)
!1352 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 433, column: 8)
!1353 = !DILocation(line: 434, column: 7, scope: !1354)
!1354 = distinct !DILexicalBlock(scope: !1352, file: !3, line: 433, column: 17)
!1355 = !DILocation(line: 435, column: 7, scope: !1354)
!1356 = !DILocation(line: 440, column: 5, scope: !1185)
!1357 = !DILocation(line: 442, column: 22, scope: !1185)
!1358 = !DILocation(line: 442, column: 20, scope: !1185)
!1359 = !DILocation(line: 0, scope: !1258)
!1360 = !DILocation(line: 446, column: 37, scope: !1361)
!1361 = distinct !DILexicalBlock(scope: !1362, file: !3, line: 445, column: 56)
!1362 = distinct !DILexicalBlock(scope: !1363, file: !3, line: 445, column: 9)
!1363 = distinct !DILexicalBlock(scope: !1258, file: !3, line: 445, column: 9)
!1364 = !{!1365, !1365, i64 0}
!1365 = !{!"long", !911, i64 0}
!1366 = !DILocation(line: 451, column: 36, scope: !1185)
!1367 = !DILocation(line: 451, column: 5, scope: !1185)
!1368 = !DILocation(line: 452, column: 5, scope: !1185)
!1369 = !DILocation(line: 457, column: 36, scope: !1185)
!1370 = !DILocation(line: 457, column: 34, scope: !1185)
!1371 = !DILocation(line: 457, column: 32, scope: !1185)
!1372 = !DILocation(line: 457, column: 47, scope: !1185)
!1373 = !DILocation(line: 457, column: 64, scope: !1185)
!1374 = !DILocation(line: 457, column: 25, scope: !1185)
!1375 = !DILocation(line: 458, column: 29, scope: !1185)
!1376 = !DILocation(line: 458, column: 63, scope: !1185)
!1377 = !DILocation(line: 458, column: 16, scope: !1185)
!1378 = !DILocation(line: 458, column: 14, scope: !1185)
!1379 = !DILocation(line: 459, column: 23, scope: !1185)
!1380 = !DILocation(line: 459, column: 12, scope: !1185)
!1381 = !DILocation(line: 460, column: 19, scope: !1185)
!1382 = !DILocation(line: 460, column: 10, scope: !1185)
!1383 = !DILocation(line: 461, column: 23, scope: !1185)
!1384 = !DILocation(line: 461, column: 16, scope: !1185)
!1385 = !DILocation(line: 462, column: 24, scope: !1185)
!1386 = !DILocation(line: 462, column: 11, scope: !1185)
!1387 = !DILocation(line: 464, column: 41, scope: !1185)
!1388 = !DILocation(line: 464, column: 58, scope: !1185)
!1389 = !DILocation(line: 464, column: 23, scope: !1185)
!1390 = !DILocation(line: 465, column: 23, scope: !1185)
!1391 = !DILocation(line: 465, column: 58, scope: !1185)
!1392 = !DILocation(line: 465, column: 13, scope: !1185)
!1393 = !DILocation(line: 465, column: 11, scope: !1185)
!1394 = !DILocation(line: 467, column: 17, scope: !1395)
!1395 = distinct !DILexicalBlock(scope: !1396, file: !3, line: 467, column: 5)
!1396 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 467, column: 5)
!1397 = !DILocation(line: 467, column: 16, scope: !1395)
!1398 = !DILocation(line: 467, column: 5, scope: !1396)
!1399 = !DILocation(line: 468, column: 34, scope: !1400)
!1400 = distinct !DILexicalBlock(scope: !1395, file: !3, line: 467, column: 34)
!1401 = !{!1402, !911, i64 24}
!1402 = !{!"_ZTS11OptionData_", !1158, i64 0, !1158, i64 4, !1158, i64 8, !1158, i64 12, !1158, i64 16, !1158, i64 20, !911, i64 24, !1158, i64 28, !1158, i64 32}
!1403 = !DILocation(line: 468, column: 45, scope: !1400)
!1404 = !DILocation(line: 468, column: 25, scope: !1400)
!1405 = !DILocation(line: 468, column: 9, scope: !1400)
!1406 = !DILocation(line: 468, column: 23, scope: !1400)
!1407 = !DILocation(line: 469, column: 25, scope: !1400)
!1408 = !DILocation(line: 469, column: 33, scope: !1400)
!1409 = !{!1402, !1158, i64 0}
!1410 = !DILocation(line: 469, column: 9, scope: !1400)
!1411 = !DILocation(line: 469, column: 23, scope: !1400)
!1412 = !DILocation(line: 470, column: 33, scope: !1400)
!1413 = !{!1402, !1158, i64 4}
!1414 = !DILocation(line: 470, column: 9, scope: !1400)
!1415 = !DILocation(line: 470, column: 23, scope: !1400)
!1416 = !DILocation(line: 471, column: 33, scope: !1400)
!1417 = !{!1402, !1158, i64 8}
!1418 = !DILocation(line: 471, column: 9, scope: !1400)
!1419 = !DILocation(line: 471, column: 23, scope: !1400)
!1420 = !DILocation(line: 472, column: 33, scope: !1400)
!1421 = !{!1402, !1158, i64 16}
!1422 = !DILocation(line: 472, column: 9, scope: !1400)
!1423 = !DILocation(line: 472, column: 23, scope: !1400)
!1424 = !DILocation(line: 473, column: 33, scope: !1400)
!1425 = !{!1402, !1158, i64 20}
!1426 = !DILocation(line: 473, column: 9, scope: !1400)
!1427 = !DILocation(line: 473, column: 23, scope: !1400)
!1428 = !DILocation(line: 467, column: 30, scope: !1395)
!1429 = distinct !{!1429, !1398, !1430, !1172, !1173}
!1430 = !DILocation(line: 474, column: 5, scope: !1396)
!1431 = !DILocation(line: 476, column: 34, scope: !1185)
!1432 = !DILocation(line: 476, column: 45, scope: !1185)
!1433 = !DILocation(line: 476, column: 5, scope: !1185)
!1434 = !DILocation(line: 482, column: 14, scope: !1185)
!1435 = !DILocation(line: 482, column: 5, scope: !1185)
!1436 = !DILocation(line: 482, column: 9, scope: !1185)
!1437 = !DILocation(line: 483, column: 15, scope: !1267)
!1438 = !DILocation(line: 483, column: 5, scope: !1268)
!1439 = !DILocation(line: 484, column: 9, scope: !1266)
!1440 = !DILocation(line: 484, column: 16, scope: !1266)
!1441 = !DILocation(line: 0, scope: !1265)
!1442 = !DILocation(line: 488, column: 9, scope: !1443)
!1443 = distinct !DILexicalBlock(scope: !1265, file: !3, line: 488, column: 9)
!1444 = !DILocation(line: 489, column: 18, scope: !1445)
!1445 = distinct !DILexicalBlock(scope: !1446, file: !3, line: 489, column: 18)
!1446 = distinct !DILexicalBlock(scope: !1447, file: !3, line: 488, column: 56)
!1447 = distinct !DILexicalBlock(scope: !1443, file: !3, line: 488, column: 9)
!1448 = !DILocation(line: 489, column: 42, scope: !1445)
!1449 = !DILocation(line: 488, column: 52, scope: !1447)
!1450 = !DILocation(line: 488, column: 32, scope: !1447)
!1451 = distinct !{!1451, !1442, !1452, !1172, !1173}
!1452 = !DILocation(line: 490, column: 9, scope: !1443)
!1453 = !DILocation(line: 488, scope: !1443)
!1454 = !DILocation(line: 491, column: 25, scope: !1265)
!1455 = !DILocation(line: 491, column: 9, scope: !1265)
!1456 = !DILocation(line: 483, column: 27, scope: !1267)
!1457 = !DILocation(line: 483, column: 16, scope: !1267)
!1458 = distinct !{!1458, !1438, !1459, !1172, !1173}
!1459 = !DILocation(line: 495, column: 5, scope: !1268)
!1460 = !DILocation(line: 499, column: 9, scope: !1270)
!1461 = !DILocation(line: 500, column: 9, scope: !1462)
!1462 = distinct !DILexicalBlock(scope: !1270, file: !3, line: 500, column: 9)
!1463 = !DILocation(line: 502, column: 18, scope: !1464)
!1464 = distinct !DILexicalBlock(scope: !1465, file: !3, line: 502, column: 18)
!1465 = distinct !DILexicalBlock(scope: !1466, file: !3, line: 500, column: 55)
!1466 = distinct !DILexicalBlock(scope: !1462, file: !3, line: 500, column: 9)
!1467 = !DILocation(line: 502, column: 42, scope: !1464)
!1468 = !DILocation(line: 503, column: 13, scope: !1465)
!1469 = !DILocation(line: 500, column: 51, scope: !1466)
!1470 = !DILocation(line: 500, column: 32, scope: !1466)
!1471 = distinct !{!1471, !1461, !1472, !1172, !1173}
!1472 = !DILocation(line: 504, column: 9, scope: !1462)
!1473 = !DILocation(line: 505, column: 5, scope: !1185)
!1474 = !DILocation(line: 538, column: 12, scope: !1185)
!1475 = !DILocation(line: 539, column: 13, scope: !1476)
!1476 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 539, column: 8)
!1477 = !DILocation(line: 540, column: 7, scope: !1478)
!1478 = distinct !DILexicalBlock(scope: !1476, file: !3, line: 539, column: 22)
!1479 = !DILocation(line: 541, column: 7, scope: !1478)
!1480 = !DILocation(line: 543, column: 32, scope: !1185)
!1481 = !DILocation(line: 543, column: 10, scope: !1185)
!1482 = !DILocation(line: 544, column: 11, scope: !1483)
!1483 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 544, column: 8)
!1484 = !DILocation(line: 549, column: 16, scope: !1485)
!1485 = distinct !DILexicalBlock(scope: !1486, file: !3, line: 549, column: 5)
!1486 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 549, column: 5)
!1487 = !DILocation(line: 549, column: 15, scope: !1485)
!1488 = !DILocation(line: 549, column: 5, scope: !1486)
!1489 = !DILocation(line: 545, column: 7, scope: !1490)
!1490 = distinct !DILexicalBlock(scope: !1483, file: !3, line: 544, column: 16)
!1491 = !DILocation(line: 546, column: 7, scope: !1490)
!1492 = !DILocation(line: 547, column: 7, scope: !1490)
!1493 = !DILocation(line: 549, column: 29, scope: !1485)
!1494 = distinct !{!1494, !1488, !1495, !1172, !1173}
!1495 = !DILocation(line: 556, column: 5, scope: !1486)
!1496 = !DILocation(line: 550, column: 37, scope: !1497)
!1497 = distinct !DILexicalBlock(scope: !1485, file: !3, line: 549, column: 33)
!1498 = !DILocation(line: 550, column: 12, scope: !1497)
!1499 = !DILocation(line: 551, column: 13, scope: !1500)
!1500 = distinct !DILexicalBlock(scope: !1497, file: !3, line: 551, column: 10)
!1501 = !DILocation(line: 552, column: 9, scope: !1502)
!1502 = distinct !DILexicalBlock(scope: !1500, file: !3, line: 551, column: 18)
!1503 = !DILocation(line: 553, column: 9, scope: !1502)
!1504 = !DILocation(line: 554, column: 9, scope: !1502)
!1505 = !DILocation(line: 557, column: 10, scope: !1185)
!1506 = !DILocation(line: 558, column: 11, scope: !1507)
!1507 = distinct !DILexicalBlock(scope: !1185, file: !3, line: 558, column: 8)
!1508 = !DILocation(line: 559, column: 7, scope: !1509)
!1509 = distinct !DILexicalBlock(scope: !1507, file: !3, line: 558, column: 17)
!1510 = !DILocation(line: 560, column: 7, scope: !1509)
!1511 = !DILocation(line: 566, column: 10, scope: !1185)
!1512 = !DILocation(line: 566, column: 5, scope: !1185)
!1513 = !DILocation(line: 567, column: 10, scope: !1185)
!1514 = !DILocation(line: 567, column: 5, scope: !1185)
!1515 = !DILocation(line: 574, column: 1, scope: !1185)
!1516 = !DISubprogram(name: "pthread_mutex_init", scope: !1176, file: !1176, line: 781, type: !1517, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1517 = !DISubroutineType(types: !1518)
!1518 = !{!6, !1179, !1519}
!1519 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1520, size: 64)
!1520 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!1521 = !DISubprogram(name: "fflush", scope: !954, file: !954, line: 239, type: !1522, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1522 = !DISubroutineType(types: !1523)
!1523 = !{!6, !1192}
!1524 = !DISubprogram(name: "fopen", scope: !954, file: !954, line: 267, type: !1525, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1525 = !DISubroutineType(types: !1526)
!1526 = !{!1192, !298, !298}
!1527 = !DISubprogram(name: "fscanf", linkageName: "__isoc23_fscanf", scope: !954, file: !954, line: 445, type: !1528, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1528 = !DISubroutineType(types: !1529)
!1529 = !{!6, !1530, !298, null}
!1530 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1192)
!1531 = !DISubprogram(name: "fclose", scope: !954, file: !954, line: 187, type: !1522, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1532 = !DISubprogram(name: "pthread_mutexattr_init", scope: !1176, file: !1176, line: 874, type: !1533, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1533 = !DISubroutineType(types: !1534)
!1534 = !{!6, !1535}
!1535 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!1536 = !DISubprogram(name: "pthread_create", scope: !1176, file: !1176, line: 202, type: !1537, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1537 = !DISubroutineType(types: !1538)
!1538 = !{!6, !1539, !1541, !25, !1546}
!1539 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1540)
!1540 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !870, size: 64)
!1541 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1542)
!1542 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1543, size: 64)
!1543 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1544)
!1544 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !35, line: 62, baseType: !1545)
!1545 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !35, line: 56, size: 448, flags: DIFlagFwdDecl, identifier: "_ZTS14pthread_attr_t")
!1546 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !28)
!1547 = !DISubprogram(name: "pthread_join", scope: !1176, file: !1176, line: 219, type: !1548, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1548 = !DISubroutineType(types: !1549)
!1549 = !{!6, !870, !1550}
!1550 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!1551 = !DISubprogram(name: "fprintf", scope: !954, file: !954, line: 360, type: !1528, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1552 = !DISubprogram(name: "__builtin_expf", scope: !441, file: !441, line: 227, type: !495, flags: DIFlagArtificial | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1553 = !DISubprogram(name: "__builtin_sqrtf", scope: !441, file: !441, line: 450, type: !495, flags: DIFlagArtificial | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1554 = !DISubprogram(name: "__builtin_logf", scope: !441, file: !441, line: 334, type: !495, flags: DIFlagArtificial | DIFlagPrototyped, spFlags: DISPFlagOptimized)
