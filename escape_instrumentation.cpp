#include "llvm/IR/PassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstrTypes.h" 
using namespace llvm;

/*TODO : right now the analysis generates some false negatives in some non trivial cases
 * the root creation, direct string comparision may fail if pthread_create called some other way.
 * but the root creation step is sound and conservative.
 * the issue is in the pointer assignment graph or PAG. i only considered common cases like loads, stores, 
 * return instruction. but loads, stores are not the only way memory is accessed, memcpy is one way and llvm dont
 * immediately translates it to loads and stores, it uses a instrinsic llvm.memcpy 
 * the PAG ignores pointer derivations, suppose a struct pointer is passed to pthread_create if the code offsets the struct
 * to access a filed then llvm creates a new value or pointer, the analysis misses this case. 
 * how llvm computes address for struct fields and array indices  ?
 * casting a pointer also creates a new SSA register, missed case ? how llvm cast pointers ? 
 * there is also something called phi instruction. idk about that . 
 * also loads and stores not the only way to access memory again, atomic laods, stores maybe generates different instructions ??
 * not consider them, assume only loads and stores, maybe expand later. 
 *
 *
 *
 */

namespace {

struct SharedPointerAnalysisPass : public PassInfoMixin<SharedPointerAnalysisPass> {
    
    //maintain a set 'sharedset'
    SmallPtrSet<Value *, 32> SharedSet;
    SmallVector<Instruction*, 32> insturment; 
    //Dependency graph representing A -> B (A stored into B)
    DenseMap<Value *, SmallPtrSet<Value *, 8>> DependencyGraph;

    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {

        SharedSet.clear();
        DependencyGraph.clear();

        // Step 1: Put all global pointers into sharedset.
        // In LLVM IR, GlobalVariables are memory allocations, hence they are pointers.
        for (GlobalVariable &GV : M.globals()) {
            SharedSet.insert(&GV);
        }

        // Iterate over all instructions in the module
        for (Function &F : M) {
            for (BasicBlock &BB : F) {
                for (Instruction &I : BB) {
                    
                    // Step 2: Put pointers passed to pthread_create into sharedset
                    if (auto *Call = dyn_cast<CallInst>(&I)) {
                        if (Function *CalledFn = Call->getCalledFunction()) {
                            if (CalledFn->getName() == "pthread_create") {
                                // Iterate through arguments and add pointer types to sharedset
                                for (Use &Arg : Call->args()) {
                                    if (Arg->getType()->isPointerTy()) {
                                        SharedSet.insert(Arg.get());
                                    }
                                }
                            }
                        }
                    }

                    // Step 3: Create dependency graph for stores where A -> B means if A is escaped so is B.
                    //
                    if (auto *Store = dyn_cast<StoreInst>(&I)) {
                        Value *A = Store->getValueOperand();
                        // num_stores++;
                        Value *B = Store->getPointerOperand();

                        // Enforce the condition that both A and B must be pointers
                        if (A->getType()->isPointerTy() && B->getType()->isPointerTy()) {
                            DependencyGraph[B].insert(A);
                        }
                    }

                    if(auto *Load = dyn_cast<LoadInst>(&I)){
                        // num_loads++;
                        Value *A = Load->getPointerOperand();
                        if(Load->getType()->isPointerTy()){
                            DependencyGraph[A].insert(Load);
                        }
                    }
            }

          



        }
        //module pass over
        // bool changed = true;
        // while(changed){
        //     std::vector<Value*> current_shared(SharedSet.begin(), SharedSet.end());
        //     for(Value* shared_ptr : current_shared){
        //         auto nodeit = DependencyGraph.find(shared_ptr);
        //         if(nodeit != DependencyGraph.end()){
        //             for(auto dependent_val : nodeit->second){
                        
        //             }
                        
        //         }
        //     }

        // }
        }
        auto &FAM =
        MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();
        runInterproceduralEscapeAnalysis(M);
        for(auto &F : M.functions()){
            if(F.isDeclaration())continue;
            instrumentSharedAccesses(F, FAM, M);
        }
        // Output the results for verification during compilation
        printAnalysisResults();

        // This is strictly an analysis pass; it does not mutate the IR.
        return PreservedAnalyses::none();
    }
void runInterproceduralEscapeAnalysis(Module &M) {
    // DependencyGraph maps a Value to all Values that inherit its "Shared" status
    DenseMap<Value *, SmallPtrSet<Value *, 8>> DependencyGraph;
    // ========================================================================
    // TODO 3 & 5: Build the Global Pointer Assignment Graph
    // ========================================================================
    for (Function &F : M) {
        for (BasicBlock &BB : F) {
            for (Instruction &I : BB) {
                
                // 1. STORES: store V, [P]
                if (auto *Store = dyn_cast<StoreInst>(&I)) {
                    num_stores++;
                    // errs() << "num_stores" << num_stores << "\n";
                    Value *V = Store->getValueOperand();
                    Value *P = Store->getPointerOperand();
                    
                    // We only care about escaping pointers
                    if (V->getType()->isPointerTy()) {
                        // If P becomes shared, V escapes into it and becomes shared.
                        DependencyGraph[P].insert(V);
                    }
                }
                
                // 2. LOADS: V = load P
                else if (auto *Load = dyn_cast<LoadInst>(&I)) {
                    num_loads++;

                    // errs() << "num_stores" << num_stores << "\n";
                    Value *P = Load->getPointerOperand();
                    
                    if (Load->getType()->isPointerTy()) {
                        // If P is shared, the loaded pointer SSA value becomes shared.
                        DependencyGraph[P].insert(Load);
                    }
                }
                // 3. GET ELEMENT PTR (Struct/Array field access)
                else if (auto *GEP = dyn_cast<GetElementPtrInst>(&I)) {
                    Value *BasePtr = GEP->getPointerOperand();
                    DependencyGraph[BasePtr].insert(GEP); // If base escapes, derived pointer escapes
                }
                // 4. CASTS (BitCast, AddrSpaceCast)
                else if (auto *Cast = dyn_cast<CastInst>(&I)) {
                    if (Cast->getType()->isPointerTy() && Cast->getOperand(0)->getType()->isPointerTy()) {
                        DependencyGraph[Cast->getOperand(0)].insert(Cast); // If original escapes, casted escapes
                    }
                }
                
                // 3. CALLS: Inter-procedural flow (TODO 5)
                else if (auto *Call = dyn_cast<CallInst>(&I)) {
                    //get the function you are calling, currently we are only at a call instruction.
                    Function *Callee = Call->getCalledFunction();
                    bool isBlackBox = (Callee == nullptr) || Callee->isDeclaration();
                    bool isSafe = Callee && isKnownSafeLibCall(Callee->getName());

                    if (isBlackBox && !isSafe) {
                        // ====================================================================
                        // THE BLACK BOX PROTOCOL
                        // ====================================================================
                        for (unsigned i = 0; i < Call->arg_size(); ++i) {
                            Value *ActualArg = Call->getArgOperand(i);
                            
                            if (ActualArg->getType()->isPointerTy()) {
                                
                                // Check if LLVM guarantees this argument doesn't escape
                                // In modern LLVM, we check the parameter attributes on the CallBase
                                if (!Call->paramHasAttr(i, Attribute::NoCapture)) {
                                    
                                    // The pointer might escape! 
                                    // It becomes a new ROOT of shared memory.
                                SharedSet.insert(ActualArg);
                                        // If you evaluate this during the graph-building phase, 
                                        // you must ensure ActualArg gets pushed to your Worklist later!
                                }
                            }
                        }
                        
                        // Note on Return Values: If a black box returns a pointer (e.g., void* p = unknown()), 
                        // it might be returning a pointer to shared global memory. 
                        // For strict soundness, the CallInst itself should also be added to the SharedSet.
                        if (Call->getType()->isPointerTy() && !Call->hasRetAttr(Attribute::NoAlias)) {
                             SharedSet.insert(Call);
                             
                        
                    } 

                        
                    // Skip indirect calls and external declarations (unless modeling them)
                    // external declaration and library calls are black box assume escaped.
                    else if (Callee && !Callee->isDeclaration()) {
                        
                        // Map Call Site Arguments to Callee Formal Arguments
                        for (unsigned i = 0; i < Call->arg_size(); ++i) {
                            Value *ActualArg = Call->getArgOperand(i);
                            
                            if (ActualArg->getType()->isPointerTy()) {
                                Argument *FormalArg = Callee->getArg(i);
                                // If the actual argument is shared, the formal argument becomes shared
                                DependencyGraph[ActualArg].insert(FormalArg);
                            }
                        }
                        
                        //Map Callee Return Values back to the Call Site SSA variable
                        if (Call->getType()->isPointerTy()) {
                            for (BasicBlock &CBB : *Callee) {
                                if (auto *Ret = dyn_cast<ReturnInst>(CBB.getTerminator())) {
                                    if (Value *RetVal = Ret->getReturnValue()) {
                                        //If the return value inside the callee is shared, the CallInst is shared
                                        DependencyGraph[RetVal].insert(Call);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ========================================================================
    // TODO 4: Fixed-Point Worklist Algorithm
    // ========================================================================
    
    // Initialize the worklist with the roots found in Phase 1
    SmallVector<Value *, 64> Worklist(SharedSet.begin(), SharedSet.end());

    while (!Worklist.empty()) {
        // Pop a value that is confirmed to be shared
        Value *Current = Worklist.pop_back_val();

        // Find all dependent values that should inherit the shared property
        auto NodeIt = DependencyGraph.find(Current);
        if (NodeIt != DependencyGraph.end()) {
            for (Value *Dependent : NodeIt->second) {
                
                // Try to insert the dependent value into the SharedSet
                // SharedSet.insert() returns a pair; .second is true if the item was newly added
                if (SharedSet.insert(Dependent).second) {
                    
                    // If it is newly discovered as shared, add it to the worklist to propagate further
                    Worklist.push_back(Dependent);
                }
            }
        }
    }
}
}
private:
    
unsigned long num_loads;
unsigned long num_stores;
unsigned instrumented_loads;
unsigned instrumented_stores;
void instrumentSharedAccesses(Function &F, FunctionAnalysisManager &FAM, Module &M) {
    LLVMContext &Ctx = M.getContext();
        const DataLayout &DL = M.getDataLayout();

        Type *VoidTy    = Type::getVoidTy(Ctx);
        Type *VoidPtrTy = PointerType::get(Type::getInt8Ty(Ctx), 0);
        Type *Int64Ty   = Type::getInt64Ty(Ctx);
        Type *Int8PtrTy = PointerType::getUnqual(Ctx);

        // ---- Runtime hooks ----
        FunctionCallee FtRead  =
            M.getOrInsertFunction("__wcp_read", VoidTy, VoidPtrTy, Int8PtrTy);
        FunctionCallee FtWrite =
            M.getOrInsertFunction("__wcp_write", VoidTy, VoidPtrTy, Int8PtrTy);
        FunctionCallee FtLock  =
            M.getOrInsertFunction("__wcp_lock", VoidTy, VoidPtrTy);
        FunctionCallee FtUnlock =
            M.getOrInsertFunction("__wcp_unlock", VoidTy, VoidPtrTy);
        FunctionCallee FtThreadCreate =
            M.getOrInsertFunction("__wcp_thread_create", VoidTy, Int64Ty);
        FunctionCallee FtThreadJoin =
            M.getOrInsertFunction("__wcp_thread_join", VoidTy, Int64Ty);

        FunctionCallee FtPrepareContext = M.getOrInsertFunction(
            "__wcp_prepare_context", 
            VoidPtrTy,
            VoidPtrTy,
            VoidPtrTy
        );

        // ---- pthread_create wrapper ----
        FunctionCallee ThreadWrapper =
            M.getOrInsertFunction("thread_wrapper",
                                  VoidPtrTy, VoidPtrTy);
    AAResults &AA = FAM.getResult<AAManager>(F);

    // 2. Build a LocalSharedSet: Only Values valid in the context of F
    SmallVector<Value *, 16> LocalSharedPointers;
    for (Value *V : SharedSet) {
        if (isa<GlobalValue>(V)) {
            LocalSharedPointers.push_back(V);
        } else if (auto *Arg = dyn_cast<Argument>(V)) {
            if (Arg->getParent() == &F) LocalSharedPointers.push_back(V);
        } else if (auto *Inst = dyn_cast<Instruction>(V)) {
            if (Inst->getFunction() == &F) LocalSharedPointers.push_back(V);
        }
    }

    // 3. Iterate over memory accesses in the function
    for (BasicBlock &BB : F) {
        for (Instruction &I : BB) {
            
            Value *AccessPtr = nullptr;
            MemoryLocation AccessLoc;

            if (auto *Load = dyn_cast<LoadInst>(&I)) {
                AccessPtr = Load->getPointerOperand();
                AccessLoc = MemoryLocation::get(Load);
            } else if (auto *Store = dyn_cast<StoreInst>(&I)) {
                AccessPtr = Store->getPointerOperand();
                AccessLoc = MemoryLocation::get(Store);
            }else{
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

                    // ---- pthread_join ----
                    if (Name.contains("pthread_join")) {
                        // We insert AFTER the join call returns.
                        // This represents the point where Parent is guaranteed that Child has finished.
                        IRBuilder<> B(CB->getNextNode());

                        // Argument 0 of pthread_join is the 'pthread_t' of the child thread.
                        Value *ChildRawId = CB->getArgOperand(0);

                        // Inject call: __wcp_thread_join(child_pthread_t)
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

                        // 2. Call the C++ Runtime Helper: __wcp_prepare_context(func, arg)
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

                    continue;
            }

            // 4. Fast path: Is the pointer exactly in our SharedSet?
            bool isShared = SharedSet.count(AccessPtr);

            // 5. Slow path: Alias Analysis
            if (!isShared) {
                for (Value *SharedPtr : LocalSharedPointers) {
                    
                    // Construct a MemoryLocation for the shared pointer.
                    // If we don't know the exact size of the shared allocation, we use LocationSize::beforeOrAfterPointer()
                    MemoryLocation SharedLoc(SharedPtr, LocationSize::beforeOrAfterPointer());

                    AliasResult AR = AA.alias(AccessLoc, SharedLoc);

                    if (AR != AliasResult::NoAlias) {
                        isShared = true;
                        
                        // Optimization: Add to SharedSet so future identical pointers hit the Fast Path
                        SharedSet.insert(AccessPtr); 
                        LocalSharedPointers.push_back(AccessPtr);
                        break; 
                    }
                }
            }

            // 6. Instrument if it escapes or aliases with an escaping pointer
            if (isShared) {
                

                    // ---------------- LOAD ----------------
                    if (auto *LI = dyn_cast<LoadInst>(&I)) {
                        IRBuilder<> B(&I); // Insert before the load
                        instrumented_loads++;
                        // 1. Get the IR Instruction as a std::string
                        std::string Str;
                        raw_string_ostream RSO(Str);
                        I.print(RSO); // Dump instruction to stream

                        // 2. Create a Global String Constant in the module
                        // This returns a Value* (Constant*) pointing to the string
                        Value *IrStringPtr = B.CreateGlobalString(RSO.str());

                        // 3. Pass it to the runtime
                        B.CreateCall(FtRead, {LI->getPointerOperand(), IrStringPtr});

                        continue;
                    }

                    // ---------------- STORE ----------------
                    if (auto *SI = dyn_cast<StoreInst>(&I)) {
                        IRBuilder<> B(&I);
                        instrumented_stores++;
                        std::string Str;
                        raw_string_ostream RSO(Str);
                        I.print(RSO);

                        Value *IrStringPtr = B.CreateGlobalString(RSO.str());

                        B.CreateCall(FtWrite, {SI->getPointerOperand(), IrStringPtr});
                        continue;
                    }

                                    
                // if(auto *LI = dyn_cast<LoadInst>(&I)){
                //         IRBuilder<> Builder(LI); //BEFORE
                //         Builder.CreateCall(LogLoad, {LI->getPointerOperand()});
                //         instrumented_loads++;
                // }
                    
                //  else if(auto *SI = dyn_cast<StoreInst>(&I)){
                //         IRBuilder<> Builder(SI); //BEFORE
                //         Builder.CreateCall(LogStore, {SI->getPointerOperand()});
                //         instrumented_stores++;
                // }

            }
        }
    }
}
bool isKnownSafeLibCall(StringRef FuncName) {
    // Add functions that you know DO NOT capture pointers
    return FuncName == "printf" || FuncName == "puts" || 
           FuncName == "malloc" || FuncName == "calloc" || 
           FuncName == "free" || FuncName == "strlen" || 
           FuncName.starts_with("llvm.dbg") || // Ignore debug intrinsics
           FuncName.starts_with("llvm.lifetime") || // Ignore lifetime markers
           FuncName.starts_with("pthread_");                                              // 
}    
void printAnalysisResults() const {
        errs() << "========== SharedSet ==========\n";
        for (const Value *V : SharedSet) {
            errs() << " * ";
            V->printAsOperand(errs(), false);
            errs() << "\n";
        }

        errs() << "\n======= Dependency Graph =======\n";
        for (const auto &Node : DependencyGraph) {
            Value *A = Node.first;
            for (Value *B : Node.second) {
                A->printAsOperand(errs(), false);
                errs() << " -> ";
                B->printAsOperand(errs(), false);
                errs() << "\n";
            }
        }
        errs() << "================================\n";
        errs() << "\n===== Stats =====\n";
errs() << "loads = " << num_loads << "\n";
errs() << "stores = " << num_stores << "\n";
errs() << "instrumented loads = " << instrumented_loads << "\n";
errs() << "instrumented stores = " << instrumented_stores << "\n";
errs() << "=================\n";
    }
};

} // end anonymous namespace

// -----------------------------------------------------------------------------
// Plugin Registration for New Pass Manager
// -----------------------------------------------------------------------------
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION, "SharedPointerAnalysis", "v0.1",
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "shared-ptr-analysis") {
                        MPM.addPass(SharedPointerAnalysisPass());
                        return true;
                    }
                    return false;
                });
        }
    };
}
