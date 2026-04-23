// =============================================================================
// wcp_instrumentation.cpp
//
// LLVM Module Pass that instruments a program for WCP (Weak-Causally-Precedes)
// race detection (Kini, Mathur, Viswanathan — PLDI 2017).
//
// The pass mirrors the FastTrack instrumentation pass exactly in structure,
// but wires up the WCP runtime hooks instead.
//
// Runtime hooks declared here (defined in wcp_runtime.cpp):
//
//   void __wcp_read (void* addr, int line_no)
//   void __wcp_write(void* addr, int line_no)
//   void __wcp_lock (void* mutex_addr)
//   void __wcp_unlock(void* mutex_addr)
//   void __wcp_thread_create(uint64_t child_pthread_t)
//   void __wcp_thread_join  (uint64_t child_pthread_t)
//   void*__wcp_prepare_context(void* routine, void* arg)
//
// The pthread_create call is rewritten to go through thread_wrapper
// (same trampoline pattern used by FastTrack) so the runtime can
// initialise child thread state with a snapshot of the parent's clocks.
//
// Key difference from FastTrack:
//   __wcp_read / __wcp_write also need to know WHICH locks currently enclose
//   the access (the set L from Algorithm 1, lines 11-12).  We track the
//   lock-nesting stack per thread inside the runtime itself, so the
//   instrumentation pass does NOT need to pass extra arguments — the runtime
//   maintains its own per-thread lock set.
// =============================================================================

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Passes/PassPlugin.h>
#include <llvm/Support/raw_ostream.h>

using namespace llvm;

namespace {

struct WCPPass : public PassInfoMixin<WCPPass> {

    PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {

        LLVMContext &Ctx = M.getContext();

        Type *VoidTy    = Type::getVoidTy(Ctx);
        Type *VoidPtrTy = PointerType::get(Type::getInt8Ty(Ctx), 0);
        Type *Int64Ty   = Type::getInt64Ty(Ctx);
        Type *Int32Ty   = Type::getInt32Ty(Ctx);

        // ----------------------------------------------------------------
        // Runtime hook declarations
        // ----------------------------------------------------------------

        // void __wcp_read(void* addr, int line_no)
        FunctionCallee WcpRead =
            M.getOrInsertFunction("__wcp_read", VoidTy, VoidPtrTy, Int32Ty);

        // void __wcp_write(void* addr, int line_no)
        FunctionCallee WcpWrite =
            M.getOrInsertFunction("__wcp_write", VoidTy, VoidPtrTy, Int32Ty);

        // void __wcp_lock(void* mutex_addr)
        //   Called AFTER the real pthread_mutex_lock returns (lock is held).
        FunctionCallee WcpLock =
            M.getOrInsertFunction("__wcp_lock", VoidTy, VoidPtrTy);

        // void __wcp_unlock(void* mutex_addr)
        //   Called BEFORE the real pthread_mutex_unlock (lock is still held).
        FunctionCallee WcpUnlock =
            M.getOrInsertFunction("__wcp_unlock", VoidTy, VoidPtrTy);

        // void __wcp_thread_create(uint64_t child_pthread_t)
        //   Called AFTER pthread_create returns to record the fork edge.
        FunctionCallee WcpThreadCreate =
            M.getOrInsertFunction("__wcp_thread_create", VoidTy, Int64Ty);

        // void __wcp_thread_join(uint64_t child_pthread_t)
        //   Called AFTER pthread_join returns to merge clocks.
        FunctionCallee WcpThreadJoin =
            M.getOrInsertFunction("__wcp_thread_join", VoidTy, Int64Ty);

        // void* __wcp_prepare_context(void* routine, void* arg)
        //   Called BEFORE pthread_create to snapshot parent clocks and
        //   package them into a ThreadContext for the child.
        FunctionCallee WcpPrepareContext =
            M.getOrInsertFunction("__wcp_prepare_context",
                                  VoidPtrTy, VoidPtrTy, VoidPtrTy);

        // ----------------------------------------------------------------
        // pthread_create trampoline (defined in wcp_runtime.cpp)
        // ----------------------------------------------------------------
        FunctionCallee ThreadWrapper =
            M.getOrInsertFunction("thread_wrapper", VoidPtrTy, VoidPtrTy);

        // ----------------------------------------------------------------
        // Instrument every instruction in every non-declaration function
        // ----------------------------------------------------------------
        for (Function &F : M) {
            if (F.isDeclaration())
                continue;

            for (BasicBlock &BB : F) {
                for (Instruction &I : BB) {

                    // ============ LOAD → __wcp_read ============
                    if (auto *LI = dyn_cast<LoadInst>(&I)) {
                        IRBuilder<> B(&I);   // insert BEFORE the load

                        int line_no = 0;
                        if (const DebugLoc &Loc = I.getDebugLoc())
                            line_no = Loc.getLine();

                        Value *LineArg = ConstantInt::get(Int32Ty, line_no);
                        B.CreateCall(WcpRead, {LI->getPointerOperand(), LineArg});
                        continue;
                    }

                    // ============ STORE → __wcp_write ============
                    if (auto *SI = dyn_cast<StoreInst>(&I)) {
                        IRBuilder<> B(&I);   // insert BEFORE the store

                        int line_no = 0;
                        if (const DebugLoc &Loc = I.getDebugLoc())
                            line_no = Loc.getLine();

                        Value *LineArg = ConstantInt::get(Int32Ty, line_no);
                        B.CreateCall(WcpWrite, {SI->getPointerOperand(), LineArg});
                        continue;
                    }

                    // ============ CALL / INVOKE ============
                    auto *CB = dyn_cast<CallBase>(&I);
                    if (!CB)
                        continue;

                    Function *CalledFunc =
                        dyn_cast<Function>(CB->getCalledOperand()->stripPointerCasts());
                    if (!CalledFunc)
                        continue;

                    StringRef Name = CalledFunc->getName();

                    // ---- pthread_mutex_lock ----
                    // WCP acquire(t, ℓ):
                    //   H_t := H_t ⊔ H_ℓ
                    //   P_t := P_t ⊔ P_ℓ
                    //   foreach t' ≠ t: Acq_ℓ(t').Enqueue(C_t)
                    // We insert AFTER lock returns (lock is now held).
                    if (Name.contains("pthread_mutex_lock")) {
                        IRBuilder<> B(CB->getNextNode());
                        B.CreateCall(WcpLock, {CB->getArgOperand(0)});
                        continue;
                    }

                    // ---- pthread_mutex_unlock ----
                    // WCP release(t, ℓ, R, W):
                    //   drain Acq_ℓ(t) queue
                    //   update L^r / L^w tables
                    //   H_ℓ := H_t; P_ℓ := P_t
                    //   foreach t' ≠ t: Rel_ℓ(t').Enqueue(H_t)
                    // We insert BEFORE unlock so the lock is still held when
                    // the runtime reads the per-thread lock set.
                    if (Name.contains("pthread_mutex_unlock")) {
                        IRBuilder<> B(CB);
                        B.CreateCall(WcpUnlock, {CB->getArgOperand(0)});
                        continue;
                    }

                    // ---- pthread_cond_wait ----
                    // Treat as unlock(mutex) … lock(mutex) for WCP purposes.
                    if (Name.contains("pthread_cond_wait")) {
                        Value *MutexArg = CB->getArgOperand(1);

                        // The mutex is released when cond_wait is entered.
                        IRBuilder<> PreB(CB);
                        PreB.CreateCall(WcpUnlock, {MutexArg});

                        // The mutex is re-acquired when cond_wait returns.
                        IRBuilder<> PostB(CB->getNextNode());
                        PostB.CreateCall(WcpLock, {MutexArg});
                        continue;
                    }

                    // ---- pthread_join ----
                    // Fork/join rule: after join, parent merges child clocks.
                    // Insert AFTER join returns.
                    if (Name.contains("pthread_join")) {
                        IRBuilder<> B(CB->getNextNode());
                        Value *ChildRawId = CB->getArgOperand(0);
                        B.CreateCall(WcpThreadJoin, {ChildRawId});
                        continue;
                    }

                    // ---- pthread_create ----
                    // Two-phase instrumentation (same pattern as FastTrack):
                    //
                    // PHASE 1 (before pthread_create):
                    //   ctx = __wcp_prepare_context(orig_func, orig_arg)
                    //      → snapshots parent's H, P clocks into a ThreadContext
                    //      → increments parent's local clock (fork event)
                    //   Rewrite pthread_create args to use thread_wrapper / ctx.
                    //
                    // PHASE 2 (after pthread_create):
                    //   __wcp_thread_create(child_pthread_t)
                    //      → records the child's pthread_t in the global map
                    if (Name.contains("pthread_create")) {

                        // --- Phase 1: pre-call ---
                        IRBuilder<> PreBuilder(CB);

                        Value *OrigFunc = CB->getArgOperand(2);
                        Value *OrigArg  = CB->getArgOperand(3);

                        // Build the ThreadContext on the heap and snapshot
                        // the parent's WCP clocks.
                        Value *CtxMem = PreBuilder.CreateCall(
                            WcpPrepareContext, {OrigFunc, OrigArg});

                        // Redirect pthread_create to our trampoline.
                        CB->setArgOperand(2, ThreadWrapper.getCallee());
                        CB->setArgOperand(3, CtxMem);

                        // --- Phase 2: post-call ---
                        IRBuilder<> PostBuilder(CB->getNextNode());

                        // pthread_create stores the new thread id at Arg 0.
                        Value *ThreadIdPtr = CB->getArgOperand(0);
                        Value *ChildId     = PostBuilder.CreateLoad(Int64Ty, ThreadIdPtr);

                        PostBuilder.CreateCall(WcpThreadCreate, {ChildId});
                        continue;
                    }
                }
            }
        }

        return PreservedAnalyses::none();
    }
};

} // namespace

// ============================================================================
// Plugin registration
// ============================================================================
extern "C" LLVM_ATTRIBUTE_WEAK
::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION,
        "WCPPass",
        LLVM_VERSION_STRING,
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name,
                   ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "wcp-pass") {
                        MPM.addPass(WCPPass());
                        return true;
                    }
                    return false;
                });
        }};
}