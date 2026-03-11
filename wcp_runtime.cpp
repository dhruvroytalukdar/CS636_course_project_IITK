#include <bits/stdc++.h>
#include <cstdio>
#include <pthread.h>
#include <mutex>

// ==========================================
// STATE CLASSES
// ==========================================

// struct ThreadState {
//     int tid;
//     std::vector<int> C; 
//     std::mutex mtx;

//     ThreadState(int id) : tid(id) {
//         if(tid >= C.size()) {
//             C.resize(tid + 1, 0);
//         }
//         C[tid] = 1;
//     }
    
//     // Helper to get clock of any thread u
//     int get_clock_of(int u) {
//         if (u >= C.size()) return 0;
//         return C[u];
//     }
// };

// struct VarState {
//     std::mutex mtx; // Per-variable lock for atomicity
// };

// struct LockState {
//     std::vector<int> L;
//     std::mutex mtx;
// };


// ==========================================
// GLOBAL STATE
// ==========================================

// Thread Registry
std::mutex print_mtx;
// static std::mutex thread_map_lock;
// static std::map<pthread_t, ThreadState*> threads;
// static int next_tid = 1;
// static int race_count = 0;

// // Shadow Memory (Maps Address -> VarState)
// static std::mutex shadow_lock;
// static std::unordered_map<void*, VarState*> shadow_vars;

// // Lock Registry (Maps Mutex Address -> LockState)
// static std::mutex lock_registry_lock;
// static std::unordered_map<void*, LockState*> shadow_locks;

// ==========================================
// INFRASTRUCTURE HELPERS
// ==========================================

// ThreadState* get_current_thread() {
//     pthread_t self = pthread_self();    
//     std::lock_guard<std::mutex> lock(thread_map_lock);
//     if (threads.find(self) == threads.end()) {
//         threads[self] = new ThreadState(next_tid++);
//     }
//     return threads[self];
// }

// VarState* get_var_state(void* addr) {
//     std::lock_guard<std::mutex> lock(shadow_lock);
//     if (shadow_vars.find(addr) == shadow_vars.end()) {
//         shadow_vars[addr] = new VarState();
//     }
//     return shadow_vars[addr];
// }

// LockState* get_lock_state(void* mutex_addr) {
//     std::lock_guard<std::mutex> lock(lock_registry_lock);
//     if (shadow_locks.find(mutex_addr) == shadow_locks.end()) {
//         shadow_locks[mutex_addr] = new LockState();
//     }
//     return shadow_locks[mutex_addr];
// }

// void report_race(const char* type, void* addr, int tid1, int tid2, char* inst_str) {
//     printf("[WCP RUNTIME] | TYPE: %s | ADDR: %p | THREADS: %d-%d \n", type, addr, tid1, tid2);
//     printf("    IR INST: %s\n", inst_str);
// }



// ------------------------------------------------------------
// Thread context passed from parent → child
// ------------------------------------------------------------
struct ThreadContext {
    void *(*original_routine)(void *);
    void *original_arg;

    // std::vector<int> parent_vc_snapshot;
};

extern "C" {

    void* __wcp_prepare_context(void* routine, void* arg) {
        
        ThreadContext* ctx = new ThreadContext();
        ctx->original_routine = (void*(*)(void*))routine;
        ctx->original_arg = arg;

        // CAPTURE PARENT'S CURRENT CLOCK
        // ThreadState* parent = get_current_thread();
        
        // std::lock_guard<std::mutex> lock(parent->mtx);
        // ctx->parent_vc_snapshot = parent->C;
        return ctx;
    }


    void* thread_wrapper(void* raw_args) {
        ThreadContext* ctx = (ThreadContext*)raw_args;

        // 1. Get Child Thread State
        // ThreadState* child = get_current_thread();

        // 2. INHERIT HISTORY (WCP Logic)
        // {
        //     std::lock_guard<std::mutex> lock(child->mtx);
            
        //     // Step A: Copy parent's snapshot into child's VC
        //     // Child.C = Parent.Snapshot
        //     child->C = ctx->parent_vc_snapshot;
            
        //     // Step B: Ensure vector is large enough for Child's TID
        //     if (child->tid >= child->C.size()) {
        //         child->C.resize(child->tid + 1, 0);
        //     }
            
        //     // Step C: Start Child's own timeline
        //     // Child.C[Child.tid] = 1 (or increment if we inherited something)
        //     child->C[child->tid] = 1;
        // }


        // 3. Run User Code
        void* result = ctx->original_routine(ctx->original_arg);

        // 4. Cleanup
        delete ctx;
        return result;
    }


    // ------------------------------------------------------------
    // THREAD CREATION (parent-side)
    // ------------------------------------------------------------

    void __wcp_thread_create(uint64_t child_id_raw) {
        // 1. Get Parent Thread State
        // ThreadState* parent = get_current_thread();

        // // 2. Increment Parent's Clock
        // {
        //     std::lock_guard<std::mutex> lock(parent->mtx);
            
        //     // Parent.C[Parent.tid]++
        //     parent->C[parent->tid]++;
        // }
        
        // printf("[WCP RUNTIME] Thread %d created new thread (Raw ID: %lu)\n", 
        //        parent->tid, (unsigned long)child_id_raw);
        printf("[WCP RUNTIME] Thread created new thread (Raw ID: %lu)\n", (unsigned long)child_id_raw);
    }

    void __wcp_thread_join(uint64_t child_raw_id) {
        // 1. IDENTIFY PARENT (Current Thread)
        // The thread calling join() is the parent.
        // ThreadState* parent = get_current_thread();

        // // 2. IDENTIFY CHILD (From Argument)
        // ThreadState* child = nullptr;
        // {
        //     std::lock_guard<std::mutex> lock(thread_map_lock);
        //     auto it = threads.find(child_raw_id);
        //     if (it != threads.end()) {
        //         child = it->second;
        //     }
        // }

        // if (!child) {
        //     std::cout << "[WCP RUNTIME] WARNING: Joined thread with raw ID " << (unsigned long)child_raw_id 
        //          << " not found in registry." << std::endl;
        //     // Child might not have been instrumented or created via our hooks
        //     return;
        // }

        // printf("[WCP RUNTIME] Thread %d (Parent) joined with Thread %d (Child)\n", 
            // parent->tid, child->tid);
        printf("[WCP RUNTIME] Thread join on %lu\n", 
            (unsigned long)child_raw_id);
    }

    // ------------------------------------------------------------
    // MEMORY EVENTS
    // ------------------------------------------------------------
    void __wcp_read(void* addr, char* inst_str) {
        std::cout<<"[WCP RUNTIME] Read Operation\n";
    }

    void __wcp_write(void* addr, char* inst_str) {
        std::cout<<"[WCP RUNTIME] Write Operation\n";
    }


    // ------------------------------------------------------------
    // LOCK EVENTS
    // ------------------------------------------------------------
    void __wcp_lock(void* mutex_addr) {
        std::cout<<"[WCP RUNTIME] Thread Lock\n";
    }

    void __wcp_unlock(void* mutex_addr) {
        std::cout<<"[WCP RUNTIME] Thread Unlock\n";
    }

}
