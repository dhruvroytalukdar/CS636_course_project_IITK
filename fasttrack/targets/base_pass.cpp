#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstrTypes.h" 

using namespace llvm;

namespace{
struct RaceDetectPass : public PassInfoMixin<RaceDetectPass>{
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM){
        LLVMContext &Ctx = M.getContext();
        unsigned long num_loads = 0;
        unsigned long num_stores = 0;
        //get types used later
        Type *VoidTy = Type::getVoidTy(Ctx);
        Type *PtrTy = PointerType::getUnqual(Ctx); 

        //define hooks
        //void __race_log_load(void* addr)
        FunctionCallee LogLoad = M.getOrInsertFunction("__log_load", VoidTy, PtrTy);
        
        //void __race_log_store(void* addr)
        FunctionCallee LogStore = M.getOrInsertFunction("__log_store", VoidTy, PtrTy);

        //void __race_log_lock(void* mutex)
        FunctionCallee LogLock = M.getOrInsertFunction("__log_lock", VoidTy, PtrTy);

        //void __race_log_unlock(void* mutex)
        FunctionCallee LogUnlock = M.getOrInsertFunction("__log_unlock", VoidTy, PtrTy);

        // void __race_log_thread_create(void* thread_ptr)
        // FunctionCallee LogCreate = M.getOrInsertFunction("__log_thread_create", VoidTy, PtrTy);

        // // void __race_log_thread_join(void* thread_val)
        // FunctionCallee LogJoin = M.getOrInsertFunction("__race_log_thread_join", VoidTy, PtrTy);

        bool Modified = false;

        for(auto &F : M.functions()){
            if (F.isDeclaration()) continue;

            for(auto &B : F){
                for(auto &I : make_early_inc_range(B)){
                    
                    if(auto *LI = dyn_cast<LoadInst>(&I)){
                        num_loads++;
                        IRBuilder<> Builder(LI); //BEFORE
                        Builder.CreateCall(LogLoad, {LI->getPointerOperand()});
                        Modified = true;
                    }
                    
                    else if(auto *SI = dyn_cast<StoreInst>(&I)){
                        num_stores++;
                        IRBuilder<> Builder(SI); //BEFORE
                        Builder.CreateCall(LogStore, {SI->getPointerOperand()});
                        Modified = true;
                    }

                    else if(auto *CB = dyn_cast<CallBase>(&I)){
                        Function *CalledFunc = CB->getCalledFunction();
                        

                        if(!CalledFunc || !CalledFunc->hasName())continue;

                        StringRef Name = CalledFunc->getName();

                        if(Name == "pthread_mutex_lock"){
                            errs() << "inside a lock\n";
                            
                            //AFTER
                            IRBuilder<> Builder(CB->getNextNode()); 
                            Value *MutexPtr = CB->getArgOperand(0);
                            Builder.CreateCall(LogLock, {MutexPtr});
                            Modified = true;
                        }
                        else if(Name == "pthread_mutex_unlock"){
                            errs() << "inside unlock\n";
                            IRBuilder<> Builder(CB);
                            Value *MutexPtr = CB->getArgOperand(0);
                            Builder.CreateCall(LogUnlock, {MutexPtr});
                            Modified = true;
                        }
                        // else if(Name == "pthread_create") {
                        //     IRBuilder<> Builder(CB);
                        //     Value *ThreadPtr = CB->getArgOperand(0); 
                        
                        //     Builder.CreateCall(LogCreate, {ThreadPtr});
                        //     Modified = true;
                        // }
                        // else if(Name == "pthread_join") {
                        //     IRBuilder<> Builder(CB->getNextNode());
                        //     Value *ThreadId = CB->getArgOperand(0);
                            
                        //     if (!ThreadId->getType()->isPointerTy()) {
                        //         ThreadId = Builder.CreateIntToPtr(ThreadId, PtrTy);
                        //     }
                            
                        //     Modified = true;
                        // }
                    }
                }
            }
        }
        errs() << "num_loads" << num_loads << "\n";
        errs() << "num_stores" << num_stores << "\n";
        return Modified ? PreservedAnalyses::none() : PreservedAnalyses::all();
    }
};

} 

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo(){
    return{
        .APIVersion = LLVM_PLUGIN_API_VERSION,
        .PluginName = "fast_track",
        .PluginVersion = "v0.1",
        .RegisterPassBuilderCallbacks = [](PassBuilder &PB) {
        PB.registerPipelineParsingCallback(
    [](StringRef Name, ModulePassManager &MPM,
       ArrayRef<PassBuilder::PipelineElement>) {
        if (Name == "base-pass") {
            MPM.addPass(RaceDetectPass());
            return true;
        }
        return false;
    });
        }
    };
}
