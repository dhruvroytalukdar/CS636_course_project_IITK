#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Passes/PassPlugin.h>
#include <llvm/Support/raw_ostream.h>

using namespace llvm;

namespace {

struct FastTrackPass : public PassInfoMixin<FastTrackPass> {

    PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
        LLVMContext &Ctx = M.getContext();
        const DataLayout &DL = M.getDataLayout();

        Type *VoidTy    = Type::getVoidTy(Ctx);
        Type *VoidPtrTy = PointerType::get(Type::getInt8Ty(Ctx), 0);
        Type *Int64Ty   = Type::getInt64Ty(Ctx);
        Type *Int8PtrTy = PointerType::getUnqual(Ctx);

        // ---- Runtime hooks ----
        FunctionCallee FtRead  =
            M.getOrInsertFunction("__ft_read", VoidTy, VoidPtrTy, Int8PtrTy);
        FunctionCallee FtWrite =
            M.getOrInsertFunction("__ft_write", VoidTy, VoidPtrTy, Int8PtrTy);
        FunctionCallee FtLock  =
            M.getOrInsertFunction("__ft_lock", VoidTy, VoidPtrTy);
        FunctionCallee FtUnlock =
            M.getOrInsertFunction("__ft_unlock", VoidTy, VoidPtrTy);
        FunctionCallee FtThreadCreate =
            M.getOrInsertFunction("__ft_thread_create", VoidTy, Int64Ty);
        FunctionCallee FtThreadJoin =
            M.getOrInsertFunction("__ft_thread_join", VoidTy, Int64Ty);

        FunctionCallee FtPrepareContext = M.getOrInsertFunction(
            "__ft_prepare_context", 
            VoidPtrTy,
            VoidPtrTy,
            VoidPtrTy
        );

        // ---- pthread_create wrapper ----
        FunctionCallee ThreadWrapper =
            M.getOrInsertFunction("thread_wrapper",
                                  VoidPtrTy, VoidPtrTy);

        for (Function &F : M) {
            if (F.isDeclaration())
                continue;

            for (BasicBlock &BB : F) {
                for (Instruction &I : BB) {

                    // ---------------- LOAD ----------------
                    if (auto *LI = dyn_cast<LoadInst>(&I)) {
                        IRBuilder<> B(&I); // Insert before the load
    
                        // 1. Get the IR Instruction as a std::string
                        std::string Str;
                        raw_string_ostream RSO(Str);
                        I.print(RSO); // Dump instruction to stream
                        
                        // 2. Create a Global String Constant in the module
                        // This returns a Value* (Constant*) pointing to the string
                        Value *IrStringPtr = B.CreateGlobalStringPtr(RSO.str());

                        // 3. Pass it to the runtime
                        B.CreateCall(FtRead, {LI->getPointerOperand(), IrStringPtr});
                        
                        continue;
                    }

                    // ---------------- STORE ----------------
                    if (auto *SI = dyn_cast<StoreInst>(&I)) {
                        IRBuilder<> B(&I);
                        std::string Str;
                        raw_string_ostream RSO(Str);
                        I.print(RSO);
                        
                        Value *IrStringPtr = B.CreateGlobalStringPtr(RSO.str());

                        B.CreateCall(FtWrite, {SI->getPointerOperand(), IrStringPtr});
                        continue;
                    }

                    // ---------------- CALL / INVOKE ----------------
                    auto *CB = dyn_cast<CallBase>(&I);
                    if (!CB)
                        continue;

                    Value *Callee =
                        CB->getCalledOperand()->stripPointerCasts();
                    Function *CalledFunc =
                        dyn_cast<Function>(Callee);
                    if (!CalledFunc)
                        continue;

                    StringRef Name = CalledFunc->getName();

                    // ---- pthread_mutex_lock ----
                    if (Name.contains("pthread_mutex_lock")) {
                        IRBuilder<> B(CB->getNextNode());
                        B.CreateCall(FtLock,
                                     {CB->getArgOperand(0)});
                        continue;
                    }

                    // ---- pthread_mutex_unlock ----
                    if (Name.contains("pthread_mutex_unlock")) {
                        IRBuilder<> B(CB);
                        B.CreateCall(FtUnlock,
                                     {CB->getArgOperand(0)});
                        continue;
                    }

                    // ---- pthread_cond_wait ----
                    if (Name.contains("pthread_cond_wait")) {
                        Value *MutexArg = CB->getArgOperand(1);

                        IRBuilder<> PreB(CB);
                        PreB.CreateCall(FtUnlock, {MutexArg});

                        IRBuilder<> PostB(CB->getNextNode());
                        PostB.CreateCall(FtLock, {MutexArg});

                        continue;
                    }

                    // ---- pthread_join ----
                    if (Name.contains("pthread_join")) {
                        // We insert AFTER the join call returns.
                        // This represents the point where Parent is guaranteed that Child has finished.
                        IRBuilder<> B(CB->getNextNode());

                        // Argument 0 of pthread_join is the 'pthread_t' of the child thread.
                        Value *ChildRawId = CB->getArgOperand(0);

                        // Inject call: __ft_thread_join(child_pthread_t)
                        // Note: FtThreadJoin must be defined in your module (VoidTy, {Int8PtrTy} or similar)
                        B.CreateCall(FtThreadJoin, {ChildRawId});

                        continue;
                    }

                    // ---- pthread_create ----
                    if (Name.contains("pthread_create")) {

                        // -------------------------------------------------
                        // PART 1: PRE-CALL INSTRUMENTATION
                        // -------------------------------------------------
                        IRBuilder<> PreBuilder(CB);

                        // 1. Get the original function (Arg 2) and original argument (Arg 3)
                        Value *OrigFunc = CB->getArgOperand(2);
                        Value *OrigArg  = CB->getArgOperand(3);

                        // 2. Call the C++ Runtime Helper: __ft_prepare_context(func, arg)
                        // This helper will:
                        //    a) Allocate the ThreadContext (using 'new')
                        //    b) Snapshot the Parent's Vector Clock
                        //    c) Return the pointer to the context
                        Value *CtxMem = PreBuilder.CreateCall(FtPrepareContext, {OrigFunc, OrigArg});

                        // 3. SWAP ARGUMENTS
                        // Replace the function with our wrapper
                        CB->setArgOperand(2, ThreadWrapper.getCallee());
                        // Replace the argument with the context returned by our helper
                        CB->setArgOperand(3, CtxMem);


                        // -------------------------------------------------
                        // PART 2: POST-CALL INSTRUMENTATION
                        // (This part remains exactly the same as you had it)
                        // -------------------------------------------------
                        IRBuilder<> PostBuilder(CB->getNextNode());

                        Value *ThreadIdPtr = CB->getArgOperand(0);
                        // Assuming pthread_t is 64-bit on your target
                        Value *ChildId = PostBuilder.CreateLoad(Int64Ty, ThreadIdPtr);
                        
                        PostBuilder.CreateCall(FtThreadCreate, {ChildId});

                        continue;
                    }
                }
            }
        }

        return PreservedAnalyses::none();
    }
};

} // namespace

// ---- Plugin registration ----
extern "C" LLVM_ATTRIBUTE_WEAK
::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION,
        "FastTrackPass",
        LLVM_VERSION_STRING,
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name,
                   ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "fasttrack-pass") {
                        MPM.addPass(FastTrackPass());
                        return true;
                    }
                    return false;
                });
        }};
}
