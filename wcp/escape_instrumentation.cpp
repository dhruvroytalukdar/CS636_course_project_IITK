// Adds a flow-sensitive thread-escape analysis (adapted from Falcon's
// FlowSensitiveEA, LLVM Dev Meeting 2020) so that loads/stores to provably
// thread-local memory are NOT instrumented — reducing runtime overhead while
// keeping the analysis sound (if unsure -  instrument).
#include "llvm/IR/Instructions.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/DebugLoc.h"
#include <llvm/IR/PassManager.h>
#include <llvm/ADT/StringRef.h>
#include <llvm/IR/GlobalValue.h>
#include <llvm/IR/GlobalVariable.h>
#include<map>


using namespace llvm;
#define RUNTIME 1
//3 = my ft.
//2 - dhruv_Ft
//1 wcp



//llvm manages inter procedural using call graph 
//and intra procedural using CFG,(basic blocks)
// The hardest conceptual leap to make here is this: There are no edges across functions.
// This new analysis is strictly Intra-Procedural. It treats every single function as an isolated universe
// . It does not track data across function boundaries at all.
//
// We track which heap/stack allocations are provably confined to a single
// thread ("thread-local"). Loads and stores to thread-local memory are safe
// to skip. Everything else gets instrumented.
//
// Escape lattice (monotone — only moves up):
//   ThreadLocal  ⊑  ThreadEscaped
//
// An allocation escapes to another thread when:
//   (a) Its address is passed as the `arg` to pthread_create.
//   (b) Its address is stored into a ThreadEscaped object (transitive escape).
//   (c) Its address is passed as a non-nocapture arg to an unknown call.
//   (d) Its address is stored into a global or returned from the function.
//
// KEY insight from Falcon: storing a tracked pointer INTO a still-local object
// should NOT mark the pointer as escaped — we record a points-to edge instead
// and only propagate escape transitively if the container later escapes.
// This handles unescaped object graphs (linked lists, etc.) that naive
// CaptureTracking conservatively over-escapes.
//===----------------------------------------------------------------------===//



namespace {

//Per-allocation state data struct
struct AllocInfo {
    Value *Base = nullptr; //a instruction or value from where it originated
    bool  Escaped = false;          // true   instrument all accesses
                                    // false  skip instrumentation
    // Points-to graph: byte-offset - set of tracked pointer values stored here.
    // Only pointer-typed fields matter for escape propagation.
    DenseMap<int64_t, SmallPtrSet<Value *, 4>> PointsTo;
    // For a given allocation (object), at some byte offset, which pointer values are stored there
    

    //merge two allocations. if any one shared then shared.
    ////now this case was little tricky for me as i realised a allocation can be shared in two different 
    ///basic blocks or two paths and one of the path can modify the state of the allocation so if these two 
    ///paths merge later than update has to be made. 
    ///but wont this introduce memory overhead since 100 paths will each have copies of allocations at the point
    ///the paths diverged ? i dont know.
    void merge(const AllocInfo &O) {
        if (O.Escaped) Escaped = true;
        for (auto &[Off, Vals] : O.PointsTo)
            for (Value *V : Vals)
                PointsTo[Off].insert(V);
    }
};

// Block-level state (propagated forward through the CFG)
struct BlockState {
    DenseMap<Value *, AllocInfo> Allocs;   // base alloc  info
    DenseMap<Value *, Value *>   Aliases;  // derived ptr  base alloc

    // Follow alias chain to find the base allocation for V.
    Value *baseOf(Value *V) const {
        if (Allocs.count(V))          return V;
        auto It = Aliases.find(V);
        if (It != Aliases.end())      return It->second;
        return nullptr;
    }

    AllocInfo *infoFor(Value *V) {
        if (Value *B = baseOf(V)) {
            auto It = Allocs.find(B);
            if (It != Allocs.end()) return &It->second;
        }
        return nullptr;
    }

    // Merge at a CFG join point.
    // Union allocations (conservative), intersect aliases (only keep those
    // present on all incoming paths — cf. Falcon's merge strategy).
    void merge(const BlockState &O) {
        for (auto &[Base, Info] : O.Allocs) {

            ///this is the case discussed earlier if allocation exist then merge or update it.
            ///really a fancy way of checking if contains, if yes then calling merge
            auto [It, Ins] = Allocs.try_emplace(Base, Info);
            //if already exists
            if (!Ins) It->second.merge(Info);
        }
        // remainder tracked allocation means, we are confident these things have not yet
        // escaped and are local, anything outside it, instrument it.
        //
        // PROVE A POINTER MUST BE THREAD LOCAL.
        // take intersection of the aliases. 
        // a alias get created inside a BB, it gets out of scope unless it is passed through a phinode.
        // so its ok to take intersection we are not missing anything.
        // if we take union then a alias might be later joined using phi, in one path it points to a local var
        // and in another to a global, if we include it in tracked then we dont instrument the global.
        SmallVector<Value *, 8> Drop;
        for (auto &[Alias, Base] : Aliases)
            if (!O.Aliases.count(Alias)) Drop.push_back(Alias);
        for (Value *A : Drop) Aliases.erase(A);
        for (auto &[Alias, Base] : O.Aliases)
            Aliases.try_emplace(Alias, Base);
    }

    // Simple equality check (used to detect fixed-point convergence).
    bool sameSize(const BlockState &O) const {
        return Allocs.size() == O.Allocs.size() &&
               Aliases.size() == O.Aliases.size();
    }
};

// ThreadEscapeAnalysis — intra-procedural, flow-sensitive
// attention on "intra-procedural"
// consider functions as black boxes, conservative === sound.
class ThreadEscapeAnalysis {
private:
    Function      &F;
    const DataLayout &DL;

    DenseMap<BasicBlock *, BlockState> OutStates;
    DenseSet<BasicBlock *>             Visited;

    // Final consolidated answer: base Value* -  escaped???
    DenseMap<Value *, bool> FinalEscaped;

public:
    ThreadEscapeAnalysis(Function &F, const DataLayout &DL) : F(F), DL(DL) {}
    

    ////ONE IMPORTANT THING IS THAT THE REASON THIS ANALYSIS IN INTRA PROCEDURAL IS 
    ///BECAUSE THE PREDECESSORS AND SUCCESSORS ONLY RETURN BB IN THE SAME FUNCTION NOT 
    ///OUTSIDE
    void run() {
        //process all basic blocks for a function. 


        // RPO traversal — processes dominators before dominated blocks.
        // a post order DFS traversal then reverse it
        // start from top of the tree.
        SmallVector<BasicBlock *, 32> RPO;
        for (BasicBlock *BB : ReversePostOrderTraversal<Function *>(&F))
            RPO.push_back(BB);

        SmallPtrSet<BasicBlock *, 32> InWorklist(RPO.begin(), RPO.end());
        SmallVector<BasicBlock *, 32> Worklist(RPO.begin(), RPO.end());
        //a simple proof why this will converge can be threadlocal subsets threadescape 
        //threadescape only changes from false -> true, points to only grow, monotonic - finite - converges
        //
        while (!Worklist.empty()) {
            BasicBlock *BB = Worklist.front();
            Worklist.erase(Worklist.begin());
            InWorklist.erase(BB);

            // Merge predecessor out-states.
            // Back-edges (predecessor not yet visited) are skipped — optimistic
            // merge (Falcon's back-edge strategy): assume the back-edge brings
            // no new escapes; re-evaluate once it's processed.
            BlockState In;
            bool First = true;
            //merge and skip back edge predecessor that has not been processed yet/
            for (BasicBlock *Pred : predecessors(BB)) {
                if (!Visited.count(Pred)) continue; // back-edge — skip
                auto It = OutStates.find(Pred);
                if (It == OutStates.end()) continue;
                if (First) { In = It->second;First = false;
                                //block state  
                }
                else         In.merge(It->second);
            }
            //update out
            BlockState Out = In;
            for (Instruction &I : *BB)
                //update the basic block i.e alias, state, allocs and points to
                handleInst(I, Out);



            auto [It, Ins] = OutStates.try_emplace(BB, Out);
            bool Changed = Ins || !It->second.sameSize(Out);
            //same size check may seem wrong here but all the maps, vectors only expand and not shrink in handlInst so 
            //the check is correct to see if the state changed, if changed then update 
            if (Changed) {
                It->second = Out;
                //update its successors
                for (BasicBlock *Succ : successors(BB)) {
                    if (!InWorklist.count(Succ)) {
                        Worklist.push_back(Succ);
                        InWorklist.insert(Succ);
                    }
                }
            }
            Visited.insert(BB);
        }
// Walk all block out-states and record the worst escape state seen for
    // each allocation across all program points.

        consolidate();
    }

    // Returns true if the access through Ptr might be shared  =  must instrument.
    // Returns false only when the underlying allocation is provably thread-local.
    bool mustInstrument(Value *Ptr) const {
        // Strip casts to find the underlying object.
        Value *Base = Ptr->stripPointerCasts();
        auto It = FinalEscaped.find(Base);
        if (It != FinalEscaped.end())
            return It->second; // false local skip
        // Not in our tracked set (e.g., global, function arg, unknown) 
        // conservatively instrument.
        return true;
    }

private:
    // Instruction handlers  -  model how each instruction affects the state
    //

    void handleInst(Instruction &I, BlockState &S) {
        if (auto *AI = dyn_cast<AllocaInst>(&I)) {
            // Stack alloc - start as thread-local.
            AllocInfo Info; Info.Base = AI; Info.Escaped = false;

            //////---------------////////
            S.Allocs[AI] = std::move(Info);
            ///////--------------//////////

        } else if (auto *CI = dyn_cast<CallInst>(&I)) {
            handleCall(CI, S);

        } else if (auto *SI = dyn_cast<StoreInst>(&I)) {
            handleStore(SI, S);

        } else if (auto *LI = dyn_cast<LoadInst>(&I)) {
            handleLoad(LI, S);

        } else if (auto *GEP = dyn_cast<GetElementPtrInst>(&I)) {
            // GEP derives a pointer from a tracked base - record alias.
            // baseOf returns nullptr on not found
            // // derived ptr  base alloc
            if (Value *B = S.baseOf(GEP->getPointerOperand()))
                S.Aliases[GEP] = B;

        } else if (auto *Cast = dyn_cast<CastInst>(&I)) {
            if (Cast->getType()->isPointerTy()) {
                // pointer =  pointer cast: propagate alias as before
                if (Value *B = S.baseOf(Cast->getOperand(0)))
                    S.Aliases[Cast] = B;
            }
            else if (isa<PtrToIntInst>(Cast)) {
                 // pointer =  integer: the pointer bits are now in an integer register.
                 // We cannot track integers through the analysis, so conservatively
                 // escape the source allocation immediately. 
                 if (Value *B = S.baseOf(Cast->getOperand(0)))
                     escapeBase(B, S);
             }
        }

        // else if (auto *Cast = dyn_cast<CastInst>(&I)) {
        //     // bitcast / addrspacecast → propagate alias.
        //     if (Cast->getType()->isPointerTy())
        //         if (Value *B = S.baseOf(Cast->getOperand(0)))
        //             S.Aliases[Cast] = B;

        // }
        else if (auto *RI = dyn_cast<ReturnInst>(&I)) {
            // Returning a tracked pointer is conservative thread-escape.
            // This is because the analysis in intra procedural. we have to be conservative when
            // handling outgoing information, since we cant track them. 
            if (Value *Ret = RI->getReturnValue())
                if (Ret->getType()->isPointerTy())
                    if (Value *B = S.baseOf(Ret))
                        escapeBase(B, S);
        }
    }

    void handleCall(CallInst *CI, BlockState &S) {
        //THREE types of functions. 
        //1. indirect calls. - escape all arguments
        //2. pthread calls.
        //3. malloc calls - create allocation



        Function *Callee = CI->getCalledFunction();
        if (!Callee || !Callee->hasName()) {
            // Indirect call — escape all pointer args that we track.
            // indirect calls are black box, should also add a isDeclaration flag check but it is handled later
            // anyways.
            escapePointerArgs(CI, S);
            return;
        }

        StringRef Name = Callee->getName();

        //malloc-family: new thread-local heap allocation 
        static const StringRef MallocNames[] = {
            "malloc", "calloc", "realloc", "valloc",
            "_Znwm", "_Znam", "_Znwj", "_Znaj"
        };
        for (StringRef MN : MallocNames) {
            if (Name == MN) {
            // in C++, pointers to a derived class are automatically type-cast
            // (implicitly converted) to pointers of an accessible base class.
                AllocInfo Info; Info.Base = CI; Info.Escaped = false;
                // use of move semantics instead of copying. 
                // in short std::move is just a cast. It doesn't actually move any data.
                // It simply tells the compiler: "Treat this lvalue (Info) as if it were a 
                // temporary rvalue." This "tricks" the compiler into choosing the Move Constructor
                // instead of the Copy Constructor.
                // READ MORE LATER.------------------------------------------------------
                S.Allocs[CI] = std::move(Info);
                return;
            }
        }

        //pthread_create(tid, attr, start_fn, arg)
        // The arg (operand 3) is handed to the new thread — it escapes.
        // We also propagate transitively: everything reachable from arg
        // in the points-to graph must also be marked escaped.
        if (Name == "pthread_create") {
            if (CI->arg_size() >= 4) {
                Value *Arg = CI->getArgOperand(3);
                if (Value *B = S.baseOf(Arg))
                    escapeBase(B, S);
                // Even if Arg itself isn't tracked, its type might be a
                // struct with tracked pointer fields — transitive escape
                // handles this via the points-to graph.
            }
            return;
        }

        if (Name == "pthread_join"         ||
            Name == "pthread_mutex_lock"   ||
            Name == "pthread_mutex_unlock" ||
            Name == "pthread_mutex_trylock") {
            return;
        }
        

        //handle black boxes
        //Unknown call: conservatively escape all non-nocapture ptr args
        escapePointerArgs(CI, S);
    }

    void handleStore(StoreInst *SI, BlockState &S) {
        Value *Val  = SI->getValueOperand();
        Value *Dest = SI->getPointerOperand();

        if (!Val->getType()->isPointerTy()) return; // only care about ptr stores , now some 
                                                    // clever one can first cast the pointer 
                                                    // into a int and then store it and later
                                                    // cast it back to a pointer, this is obviosuly an escape
                                                    // but this case is handled by PtrToIntInst case

        Value *DestBase = S.baseOf(Dest);
        Value *ValBase  = S.baseOf(Val);

        if (!ValBase) return; // Val not a tracked allocation ->  nothing to do

        if (!DestBase) {
            // Storing tracked ptr into opaque/global memory ->  escapes.
            escapeBase(ValBase, S);
            return;
        }

        AllocInfo *DestInfo = S.infoFor(Dest);
        if (!DestInfo || DestInfo->Escaped) {
            // Destination is thread-escaped -> the stored pointer escapes too.
            escapeBase(ValBase, S);
            return;
        }

        // Destination is thread-local -> record a points-to edge.
        // KEY: this is the "unescaped object graph" handling from Falcon.
        // We do NOT escape ValBase here; we only do so if DestBase later escapes.
        std::optional<int64_t> Off = constantGEPOffset(Dest, DestBase);
        if (Off) {
            S.Allocs[DestBase].PointsTo[*Off].insert(Val);
        } else {
            // Unknown offset -> can't track precisely -> conservatively escape.
            escapeBase(ValBase, S);
        }
    }

    void handleLoad(LoadInst *LI, BlockState &S) {
        if (!LI->getType()->isPointerTy()) return;

        Value *Src     = LI->getPointerOperand();
        Value *SrcBase = S.baseOf(Src);
        if (!SrcBase) return;

        // If we have a recorded points-to edge at this offset, the result
        // is an alias of the stored value's base (cf. Falcon's load handling).
        std::optional<int64_t> Off = constantGEPOffset(Src, SrcBase);
        if (Off) {
            auto It = S.Allocs[SrcBase].PointsTo.find(*Off);
            if (It != S.Allocs[SrcBase].PointsTo.end() &&
                It->second.size() == 1) {
                Value *Target = *It->second.begin();
                if (Value *TB = S.baseOf(Target)) {
                    S.Aliases[LI] = TB;
                    return;
                }
            }
        }
        // Unknown load result — don't add a spurious alias.
    }

    // Escape `Base` (and everything transitively reachable from it via
    // the points-to graph).  Guards against cycles with the Escaped flag.
    // this is the heart of escape propogation. remember how pointsto graphy was created.
    void escapeBase(Value *Base, BlockState &S) {
        auto It = S.Allocs.find(Base);
        if (It == S.Allocs.end()) return;
        if (It->second.Escaped)   return; // already escaped — avoid re-visiting

        It->second.Escaped = true;

        // Transitively escape all tracked pointers stored inside Base.
        SmallVector<Value *, 8> Nested;
        for (auto &[Off, Vals] : It->second.PointsTo)
            for (Value *V : Vals)
                Nested.push_back(V);
        for (Value *V : Nested)
            if (Value *NB = S.baseOf(V))
                escapeBase(NB, S);
    }

    // Escape all pointer-typed, non-nocapture arguments of a call.
    void escapePointerArgs(CallInst *CI, BlockState &S) {
        for (unsigned i = 0, e = CI->arg_size(); i < e; ++i) {
            Value *Arg = CI->getArgOperand(i);
            if (!Arg->getType()->isPointerTy()) continue;
            if (CI->paramHasAttr(i, Attribute::NoCapture)) continue;
            if (Value *B = S.baseOf(Arg))
                escapeBase(B, S);
        }
    }

    // Try to extract a constant byte offset from `Ptr` relative to `Base`.
    std::optional<int64_t> constantGEPOffset(Value *Ptr, Value *Base) {
        if (Ptr == Base) return 0;
        if (auto *GEP = dyn_cast<GetElementPtrInst>(Ptr)) {
            APInt Off(DL.getPointerSizeInBits(), 0);
            if (GEP->accumulateConstantOffset(DL, Off))
                return Off.getSExtValue();
        }
        return std::nullopt;
    }

    // Walk all block out-states and record the worst escape state seen for
    // each allocation across all program points.
    void consolidate() {
        for (auto &[BB, State] : OutStates)
            for (auto &[Base, Info] : State.Allocs) {
                auto [It, Ins] = FinalEscaped.try_emplace(Base, Info.Escaped);
                if (!Ins && Info.Escaped) It->second = true;
            }
    }
};

//===----------------------------------------------------------------------===//
// Section 2 — The pass
//===----------------------------------------------------------------------===//

struct RaceDetectPass : public PassInfoMixin<RaceDetectPass> {
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
        LLVMContext &Ctx = M.getContext();
        const DataLayout &DL = M.getDataLayout();

        // ---- Declare hooks (same signatures as your base pass) ----
        Type *VoidTy = Type::getVoidTy(Ctx);
        Type *PtrTy  = PointerType::getUnqual(Ctx); // opaque ptr (LLVM 15+)
#if RUNTIME == 3
        FunctionCallee LogLoad   = M.getOrInsertFunction("__log_load",    VoidTy, PtrTy);
        FunctionCallee LogStore  = M.getOrInsertFunction("__log_store",   VoidTy, PtrTy);
        FunctionCallee LogLock   = M.getOrInsertFunction("__log_lock",    VoidTy, PtrTy);
        FunctionCallee LogUnlock = M.getOrInsertFunction("__log_unlock",  VoidTy, PtrTy);
#elif RUNTIME == 2
        Type *VoidPtrTy = PointerType::get(Type::getInt8Ty(Ctx), 0);
        Type *Int64Ty   = Type::getInt64Ty(Ctx);
        Type *Int32Ty   = Type::getInt32Ty(Ctx);
        Type *Int8PtrTy = PointerType::getUnqual(Ctx);
        // ---- Runtime hooks ----
        // FunctionCallee FtRead  =
            // M.getOrInsertFunction("__wcp_read", VoidTy, VoidPtrTy, Int8PtrTy);
        // FunctionCallee FtWrite =
            // M.getOrInsertFunction("__wcp_write", VoidTy, VoidPtrTy, Int8PtrTy);
        FunctionCallee FtRead  =
            M.getOrInsertFunction("__wcp_read", VoidTy, VoidPtrTy, Int32Ty, VoidPtrTy);
        FunctionCallee FtWrite =
            M.getOrInsertFunction("__wcp_write", VoidTy, VoidPtrTy, Int32Ty, VoidPtrTy);
        FunctionCallee FtLock  =
            M.getOrInsertFunction("__wcp_lock", VoidTy, VoidPtrTy);
        FunctionCallee FtUnlock =
            M.getOrInsertFunction("__wcp_unlock", VoidTy, VoidPtrTy);
        FunctionCallee FtThreadCreate =
            M.getOrInsertFunction("__wcp_thread_create", VoidTy, Int64Ty);
        FunctionCallee FtThreadJoin =
            M.getOrInsertFunction("__wcp_thread_join", VoidTy, Int64Ty);

        // FunctionCallee FtPrepareContext = M.getOrInsertFunction(
        //     "__wcp_prepare_context",
        //     VoidPtrTy,
        //     VoidPtrTy,
        //     VoidPtrTy
        // );
        FunctionCallee FtPrepareContext = M.getOrInsertFunction(
            "__wcp_prepare_context",
            VoidPtrTy,
            VoidPtrTy,
            VoidPtrTy
        );
        std::map<std::string, Value*> StringPool;
        // ---- pthread_create wrapper ----
        FunctionCallee ThreadWrapper =
            M.getOrInsertFunction("thread_wrapper",
                                  VoidPtrTy, VoidPtrTy);

#elif RUNTIME == 1
        Type *VoidPtrTy = PointerType::get(Type::getInt8Ty(Ctx), 0);
        Type *Int64Ty   = Type::getInt64Ty(Ctx);
        Type *Int32Ty   = Type::getInt32Ty(Ctx);
        Type *Int8PtrTy = PointerType::getUnqual(Ctx);


        std::map<std::string, Value*> StringPool;
        // ---- Runtime hooks ----
        FunctionCallee FtRead  =
            M.getOrInsertFunction("__wcp_read", VoidTy, VoidPtrTy, Int32Ty, VoidPtrTy);
        FunctionCallee FtWrite =
            M.getOrInsertFunction("__wcp_write", VoidTy, VoidPtrTy, Int32Ty, VoidPtrTy);
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
#endif
        // ---- Stats ----
        unsigned long InstrLoads  = 0, SkipLoads  = 0, total_loads = 0;
        unsigned long InstrStores = 0, SkipStores = 0, total_stores = 0;
        bool Modified = false;

        for (Function &F : M.functions()) {
            if (F.isDeclaration()) continue;

            // Phase 1: run escape analysis for this function.
            ThreadEscapeAnalysis EA(F, DL);
            EA.run();

            // Phase 2: collect instructions to instrument.
            // (Collect first, then insert — avoids iterator invalidation.)
            SmallVector<LoadInst  *, 64> Loads;
            SmallVector<StoreInst *, 64> Stores;
            SmallVector<CallBase  *, 32> Locks, Unlocks;
            SmallVector<CallBase  *, 32> thread_create;
            SmallVector<CallBase  *, 32> thread_join;

            for (BasicBlock &BB : F) {
                for (Instruction &I : BB) {

                    if (auto *LI = dyn_cast<LoadInst>(&I)) {
                        total_loads++;
                        if (EA.mustInstrument(LI->getPointerOperand()))
                            Loads.push_back(LI);
                        else
                            ++SkipLoads;

                    } else if (auto *SI = dyn_cast<StoreInst>(&I)) {
                        total_stores++;
                        if (EA.mustInstrument(SI->getPointerOperand()))
                            Stores.push_back(SI);
                        else
                            ++SkipStores;

                    } else if (auto *CB = dyn_cast<CallBase>(&I)) {
                        Function *Callee = CB->getCalledFunction();
                        if (!Callee || !Callee->hasName()) continue;
                        StringRef Name = Callee->getName();

                        if (Name == "pthread_mutex_lock"){   Locks.push_back(CB);continue;}
                        else if (Name == "pthread_mutex_unlock"){ Unlocks.push_back(CB); continue;}
                        Value *Callee_val =
                        CB->getCalledOperand()->stripPointerCasts();
                        Function *CalledFunc =
                        dyn_cast<Function>(Callee_val);
                        if (!CalledFunc)
                            continue;

                        Name = CalledFunc->getName();
                        if (Name.contains("pthread_create")) {
                            thread_create.push_back(CB); 
                        }else if (Name.contains("pthread_join")) {
                            thread_join.push_back(CB); 
                        } 
                    
                    
                }
            }
        }
#if RUNTIME == 3
            // Phase 3: instrument.
            for (LoadInst *LI : Loads) {
                IRBuilder<> B(LI);              // insert BEFORE the load
                B.CreateCall(LogLoad, {LI->getPointerOperand()});
                ++InstrLoads;
                Modified = true;
            }

            for (StoreInst *SI : Stores) {
                IRBuilder<> B(SI);              // insert BEFORE the store
                B.CreateCall(LogStore, {SI->getPointerOperand()});
                ++InstrStores;
                Modified = true;
            }

            for (CallBase *CB : Locks) {
                // Hook AFTER lock returns — matches your base pass convention.
                IRBuilder<> B(CB->getNextNode());
                B.CreateCall(LogLock, {CB->getArgOperand(0)});
                Modified = true;
            }

            for (CallBase *CB : Unlocks) {
                // Hook BEFORE unlock — matches your base pass convention.
                IRBuilder<> B(CB);
                B.CreateCall(LogUnlock, {CB->getArgOperand(0)});
                Modified = true;
            }
#else 
         for (LoadInst *LI : Loads) {
     

             IRBuilder<> B(LI);              // insert BEFORE the load
                ++InstrLoads;
                        Value* Ptr = LI->getPointerOperand();

                        // Extract Name
                        Value *Base = getUnderlyingObject(Ptr);
                        std::string varName = "unknown";
                        if (Base && Base->hasName()) {
                            varName = Base->getName().str();
                        }

                        // Create or reuse global string pointer
                        if (StringPool.find(varName) == StringPool.end()) {
                            StringPool[varName] = B.CreateGlobalString(varName);
                        }
                        Value *NamePtr = StringPool[varName];

                        // Extract Line Number
                        int line_no = 0;
                        if (const DebugLoc &Loc = LI->getDebugLoc()) {
                            line_no = Loc.getLine();
                        }
                        Value *LineArg = ConstantInt::get(Int32Ty, line_no);

                        // Call Runtime
                        B.CreateCall(FtRead, {Ptr, LineArg, NamePtr});
                        // continue;
                // std::string Str;
                // raw_string_ostream RSO(Str);

                //         // 2. Create a Global String Constant in the module
                //         // This returns a Value* (Constant*) pointing to the string
                //         Value *IrStringPtr = B.CreateGlobalString(RSO.str());
                //         Value* AccessPtr = LI->getPointerOperand();
                //         // 3. Pass it to the runtime
                //         B.CreateCall(FtRead, {AccessPtr, IrStringPtr});

                Modified = true;
            }

            for (StoreInst *SI : Stores) {
                        IRBuilder<> B(SI);
                        Value* Ptr = SI->getPointerOperand();

                        // Extract Name
                        Value *Base = getUnderlyingObject(Ptr);
                        std::string varName = "unknown";
                        if (Base && Base->hasName()) {
                            varName = Base->getName().str();
                        }

                        // Create or reuse global string pointer
                        if (StringPool.find(varName) == StringPool.end()) {
                            StringPool[varName] = B.CreateGlobalString(varName);
                        }
                        Value *NamePtr = StringPool[varName];

                        // Extract Line Number
                        int line_no = 0;
                        if (const DebugLoc &Loc = SI->getDebugLoc()) {
                            line_no = Loc.getLine();
                        }
                        Value *LineArg = ConstantInt::get(Int32Ty, line_no);

                        // Call Runtime
                        B.CreateCall(FtWrite, {Ptr, LineArg, NamePtr});
                        // continue;

                    // ---------------- CALL / INVOKE ----------------
                // IRBuilder<> B(SI);              // insert BEFORE the store
                // std::string Str;
                // raw_string_ostream RSO(Str);

                //         Value* AccessPtr = SI->getPointerOperand();
                //         Value *IrStringPtr = B.CreateGlobalString(RSO.str());

                //         B.CreateCall(FtWrite, {AccessPtr, IrStringPtr});

                ++InstrStores;
                Modified = true;
            }

            for (CallBase *CB : Locks) {
                // Hook AFTER lock returns — matches your base pass convention.
                IRBuilder<> B(CB->getNextNode());
                        B.CreateCall(FtLock,
                                     {CB->getArgOperand(0)});

                Modified = true;
            }

            for (CallBase *CB : Unlocks) {
                // Hook BEFORE unlock — matches your base pass convention.
                 IRBuilder<> B(CB);
                        B.CreateCall(FtUnlock,
                                     {CB->getArgOperand(0)});

                Modified = true;
            }
            for(CallBase* CB : thread_create){
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


                IRBuilder<> PostBuilder(CB->getNextNode());

                Value *ThreadIdPtr = CB->getArgOperand(0);
                Value *ChildId = PostBuilder.CreateLoad(Int64Ty, ThreadIdPtr);

                PostBuilder.CreateCall(FtThreadCreate, {ChildId});
            }
            for(CallBase* CB : thread_join){
                // We insert AFTER the join call returns.
                        // This represents the point where Parent is guaranteed that Child has finished.
                        IRBuilder<> B(CB->getNextNode());

                        // Argument 0 of pthread_join is the 'pthread_t' of the child thread.
                        Value *ChildRawId = CB->getArgOperand(0);

                        if (ChildRawId->getType()->isPointerTy()) {
                            ChildRawId = B.CreatePtrToInt(ChildRawId, Int64Ty);
                        } else if (ChildRawId->getType() != Int64Ty) {
                            ChildRawId = B.CreateZExtOrTrunc(ChildRawId, Int64Ty);
                        }

                        // Inject call: __wcp_thread_join(child_pthread_t)
                        // Note: FtThreadJoin must be defined in your module (VoidTy, {Int8PtrTy} or similar)
                        B.CreateCall(FtThreadJoin, {ChildRawId});


            }





#endif

       

        }
            // ---- Print stats ----
        errs() << "======================================================\n";
        errs() << "======================================================\n";
        errs() << "total loads= " << total_loads
                 << "num_loads instrumented=" << InstrLoads
               << "  skipped(thread-local)=" << SkipLoads  << "\n";
        errs() << "total stores= " << total_stores 
             << "num_stores instrumented= " << InstrStores
               << "  skipped(thread-local)= " << SkipStores << "\n";

        errs() << "======================================================\n";
        errs() << "======================================================\n";
        return Modified ? PreservedAnalyses::none() : PreservedAnalyses::all();
    
    }
};
} // anonymous namespace

//===----------------------------------------------------------------------===//
// Plugin registration — unchanged from your base pass
//===----------------------------------------------------------------------===//
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
    return {
        .APIVersion  = LLVM_PLUGIN_API_VERSION,
        .PluginName  = "fast",
        .PluginVersion = "v0.1",
        .RegisterPassBuilderCallbacks = [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "shared-ptr-analysis") {
                        MPM.addPass(RaceDetectPass());
                        return true;
                    }
                    return false;
                });
        }
    };
}
