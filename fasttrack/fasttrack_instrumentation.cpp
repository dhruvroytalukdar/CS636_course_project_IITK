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
        Type *Int32Ty   = Type::getInt32Ty(Ctx);

        // ---- Runtime hooks ----
        FunctionCallee FtRead  =
            M.getOrInsertFunction("__ft_read", VoidTy, VoidPtrTy, Int32Ty);
        FunctionCallee FtWrite =
            M.getOrInsertFunction("__ft_write", VoidTy, VoidPtrTy, Int32Ty);
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

            std::vector<Instruction*> Worklist;
            for (BasicBlock &BB : F) {
                for (Instruction &I : BB) {
                    Worklist.push_back(&I);
                }
            }

            // Helper lambda to safely find the next insertion point.
            // If the call is an InvokeInst (which terminates a block), it 
            // safely jumps to the beginning of the success block.
            auto getSafeNextNode = [](CallBase *CB) -> Instruction* {
                if (auto *Invoke = dyn_cast<InvokeInst>(CB)) {
                    return &*Invoke->getNormalDest()->getFirstInsertionPt();
                }
                return CB->getNextNode();
            };

            for (Instruction *InstPtr : Worklist) {
                Instruction &I = *InstPtr;

                // ---------------- LOAD ----------------
                if (auto *LI = dyn_cast<LoadInst>(&I)) {
                    IRBuilder<> B(&I); 
                    int line_no = 0;
                    if (const DebugLoc &Loc = I.getDebugLoc()) {
                        line_no = Loc.getLine();
                    }
                    Value *LineArg = ConstantInt::get(Int32Ty, line_no);
                    B.CreateCall(FtRead, {LI->getPointerOperand(), LineArg});
                    continue;
                }

                // ---------------- STORE ----------------
                if (auto *SI = dyn_cast<StoreInst>(&I)) {
                    IRBuilder<> B(&I); 
                    int line_no = 0;
                    if (const DebugLoc &Loc = I.getDebugLoc()) {
                        line_no = Loc.getLine();
                    }
                    Value *LineArg = ConstantInt::get(Int32Ty, line_no);
                    B.CreateCall(FtWrite, {SI->getPointerOperand(), LineArg});
                    continue;
                }

                // ---------------- CALL / INVOKE ----------------
                auto *CB = dyn_cast<CallBase>(&I);
                if (!CB) continue;

                Value *Callee = CB->getCalledOperand()->stripPointerCasts();
                Function *CalledFunc = dyn_cast<Function>(Callee);
                if (!CalledFunc) continue;

                StringRef Name = CalledFunc->getName();

                // ---- pthread_mutex_lock ----
                if (Name.contains("pthread_mutex_lock")) {
                    // FIX 2: Safely get the next node
                    IRBuilder<> B(getSafeNextNode(CB));
                    B.CreateCall(FtLock, {CB->getArgOperand(0)});
                    continue;
                }

                // ---- pthread_mutex_unlock ----
                if (Name.contains("pthread_mutex_unlock")) {
                    IRBuilder<> B(CB);
                    B.CreateCall(FtUnlock, {CB->getArgOperand(0)});
                    continue;
                }

                // ---- pthread_cond_wait ----
                if (Name.contains("pthread_cond_wait")) {
                    Value *MutexArg = CB->getArgOperand(1);
                    IRBuilder<> PreB(CB);
                    PreB.CreateCall(FtUnlock, {MutexArg});

                    // FIX 2: Safely get the next node
                    IRBuilder<> PostB(getSafeNextNode(CB));
                    PostB.CreateCall(FtLock, {MutexArg});
                    continue;
                }

                // ---- pthread_join ----
                if (Name.contains("pthread_join")) {
                    IRBuilder<> B(getSafeNextNode(CB));
                    Value *ChildRawId = CB->getArgOperand(0);

                    if (ChildRawId->getType()->isPointerTy()) {
                        ChildRawId = B.CreatePtrToInt(ChildRawId, Int64Ty);
                    } else if (ChildRawId->getType() != Int64Ty) {
                        ChildRawId = B.CreateZExtOrTrunc(ChildRawId, Int64Ty);
                    }

                    B.CreateCall(FtThreadJoin, {ChildRawId});
                    continue;
                }

                // ---- pthread_create ----
                if (Name.contains("pthread_create")) {
                    IRBuilder<> PreBuilder(CB);

                    Value *OrigFunc = CB->getArgOperand(2);
                    Value *OrigArg  = CB->getArgOperand(3);

                    Value *CtxMem = PreBuilder.CreateCall(FtPrepareContext, {OrigFunc, OrigArg});

                    CB->setArgOperand(2, ThreadWrapper.getCallee());
                    CB->setArgOperand(3, CtxMem);

                    IRBuilder<> PostBuilder(getSafeNextNode(CB));
                    Value *ThreadIdPtr = CB->getArgOperand(0);
                    Value *ChildId = PostBuilder.CreateLoad(Int64Ty, ThreadIdPtr);
                    
                    PostBuilder.CreateCall(FtThreadCreate, {ChildId});
                    continue;
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
