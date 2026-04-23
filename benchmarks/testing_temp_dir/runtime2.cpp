#include <bits/stdc++.h>
#include <cstdio>
#include <pthread.h>
#include <mutex>
#include <time.h>

#define SHADOW_SIZE  (1 << 20)
#define SHADOW_MASK  (SHADOW_SIZE - 1)


typedef unsigned long long Epoch;

const Epoch READ_SHARED = (Epoch)-1;
const int CLOCK_BITS = 32;
const unsigned long long CLOCK_MASK = 0xFFFFFFFF;

Epoch make_epoch(int tid, int clock) {
    // Shift TID to the high bits, mask Clock to the low bits, and combine
    return ((Epoch)tid << CLOCK_BITS) | (clock & CLOCK_MASK);
}

// Extract Thread ID from the high 32 bits
int get_tid(Epoch e) {
    return (int)(e >> CLOCK_BITS);
}

// Extract Clock Value from the low 32 bits
int get_clock(Epoch e) {
    return (int)(e & CLOCK_MASK);
}

// ==========================================
// 2. STATE CLASSES (From Figure 5)
// ==========================================

struct ThreadState {
    int tid;
    std::vector<int> C; // Vector Clock: C[u] is clock of thread u
    Epoch epoch;        
    std::recursive_mutex mtx; // Per-thread mutex for atomicity

    ThreadState(int id) : tid(id) {
        if((size_t)tid >= C.size()) {
            C.resize(tid + 1, 0);
        }
        C[tid] = 1;
        epoch = make_epoch(tid, 1);
    }
    
    // Helper to get clock of any thread u
    int get_clock_of(int u) {
        if (u >= C.size()) return 0;
        return C[u];
    }
};

struct VarState {
    std::recursive_mutex mtx; 
    
    Epoch W;      
    Epoch R;      
    
    // Use a vector instead of unordered_map for O(1) direct access
    std::vector<Epoch> Rvc; 

    VarState() : W(0), R(0) {}
};

struct LockState {
    std::vector<int> L; // Lock Vector Clock
    std::recursive_mutex mtx; // Per-lock mutex for atomicity
};

struct alignas(64) ShadowEntry {
    std::atomic<uintptr_t> key   {0};
    std::atomic<VarState*> state {nullptr};
};


// ==========================================
// 3. GLOBAL STATE
// ==========================================

// Use atomic for thread-safe primitives
static std::atomic<int> next_tid{1};
static std::atomic<int> race_count{0};

// Array for fast lookup
static ShadowEntry shadow_table[SHADOW_SIZE];

static thread_local ThreadState* tl_thread_state = nullptr;

// Thread Registry Accessors
std::recursive_mutex& get_thread_map_lock() {
    static std::recursive_mutex mtx;
    return mtx;
}
std::map<pthread_t, ThreadState*>& get_threads_map() {
    static auto* threads = new std::map<pthread_t, ThreadState*>();
    return *threads;
}

std::recursive_mutex& get_shadow_lock() {
    static std::recursive_mutex mtx;
    return mtx;
}
std::unordered_map<void*, VarState*>& get_shadow_vars() {
    static auto* shadow_vars = new std::unordered_map<void*, VarState*>();
    return *shadow_vars;
}

// Lock Registry Accessors
std::recursive_mutex& get_lock_registry_lock() {
    static std::recursive_mutex mtx;
    return mtx;
}
std::unordered_map<void*, LockState*>& get_shadow_locks() {
    static auto* shadow_locks = new std::unordered_map<void*, LockState*>();
    return *shadow_locks;
}

// ==========================================
// 4. INFRASTRUCTURE HELPERS
// ==========================================

static void vec_set_epoch(std::vector<Epoch>& v, int idx, Epoch val) {
    if (idx >= (int)v.size()) v.resize(idx + 1, 0);
    v[idx] = val;
}

ThreadState* get_current_thread() {
    if (tl_thread_state) return tl_thread_state;
    pthread_t self = pthread_self();
    std::lock_guard<std::recursive_mutex> lock(get_thread_map_lock());
    auto& threads = get_threads_map();
    if (threads.find(self) == threads.end())
        threads[self] = new ThreadState(next_tid++);
    tl_thread_state = threads[self];
    return tl_thread_state;
}

VarState* get_var_state(void* addr) {
    uintptr_t key  = ((uintptr_t)addr >> 2) + 1;
    size_t    slot = (key * 2654435761ULL) & SHADOW_MASK;

    for (;;) {
        uintptr_t cur = shadow_table[slot].key.load(std::memory_order_acquire);
        
        // Match found
        if (cur == key) {
            VarState* s;
            // Spin-wait just in case we beat the initializing thread to the pointer write
            while ((s = shadow_table[slot].state.load(std::memory_order_acquire)) == nullptr)
                ; 
            return s;
        }
        
        // Empty slot found
        if (cur == 0) {
            uintptr_t expected = 0;
            // Atomic CAS: Only ONE thread will succeed in changing expected (0) to key
            if (shadow_table[slot].key.compare_exchange_strong(
                    expected, key, std::memory_order_acq_rel)) {
                
                // We won the race! Initialize and publish the pointer.
                VarState* ns = new VarState();
                shadow_table[slot].state.store(ns, std::memory_order_release);
                return ns;
            }
            // If CAS failed, another thread stole the slot. Loop and check again.
            continue; 
        }
        
        // Collision, linear probe
        slot = (slot + 1) & SHADOW_MASK;
    }
}

LockState* get_lock_state(void* mutex_addr) {
    std::lock_guard<std::recursive_mutex> lock(get_lock_registry_lock());
    auto& shadow_locks = get_shadow_locks();
    if (shadow_locks.find(mutex_addr) == shadow_locks.end()) {
        shadow_locks[mutex_addr] = new LockState();
    }
    return shadow_locks[mutex_addr];
}

// void report_race(const char* type, void* addr, int tid1, int tid2, char* inst_str) {
//     printf("[FASTTRACK LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d \n", type, addr, tid1, tid2);
//     printf("    IR INST: %s\n", inst_str);
// }


void report_race(const char* type, void* addr, int tid1, int tid2, int line_no) {
    race_count.fetch_add(1, std::memory_order_relaxed);
    
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    uint64_t ns = (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
    
    // Print the line number cleanly!
    printf("[FASTTRACK LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d | LINE: %d | TS_NS: %llu\n",
           type, addr, tid1, tid2, line_no, (unsigned long long)ns);
}


// ------------------------------------------------------------
// Thread context passed from parent → child
// ------------------------------------------------------------
struct ThreadContext {
    void *(*original_routine)(void *);
    void *original_arg;

    std::vector<int> parent_vc_snapshot;
};

extern "C" {

    // ------------------------------------------------------------
    // Thread trampoline (child-side)
    // ------------------------------------------------------------
    void* __ft_prepare_context(void* routine, void* arg) {
        ThreadContext* ctx = new ThreadContext();
        ctx->original_routine = (void*(*)(void*))routine;
        ctx->original_arg = arg;

        // CAPTURE PARENT'S CURRENT CLOCK
        ThreadState* parent = get_current_thread();
        
        std::lock_guard<std::recursive_mutex> lock(parent->mtx);
        // Increment the parent thread before the child starts, to reflect the fork event in the parent's timeline.
        parent->C[parent->tid]++;
        parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);

        ctx->parent_vc_snapshot = parent->C;
        return ctx;
    }


    void* thread_wrapper(void* raw_args) {
        ThreadContext* ctx = (ThreadContext*)raw_args;

        // 1. Get Child Thread State
        ThreadState* child = get_current_thread();

        // 2. INHERIT HISTORY (FastTrack Logic)
        {
            std::lock_guard<std::recursive_mutex> lock(child->mtx);
            
            // Step A: Copy parent's snapshot into child's VC
            // Child.C = Parent.Snapshot
            child->C = ctx->parent_vc_snapshot;
            
            // Step B: Ensure vector is large enough for Child's TID
            if ((size_t)child->tid >= child->C.size()) {
                child->C.resize(child->tid + 1, 0);
            }
            
            // Step C: Start Child's own timeline
            // Child.C[Child.tid] = 1 (or increment if we inherited something)
            child->C[child->tid] = 1;

            // Step D: Update the invariant Epoch cache
            child->epoch = make_epoch(child->tid, child->C[child->tid]);
        }

        // printf("[FastTrack] Thread %d STARTED\n", child->tid);

        // 3. Run User Code
        void* result = ctx->original_routine(ctx->original_arg);

        // 4. Cleanup
        delete ctx;
        tl_thread_state = nullptr;
        return result;
    }



    // ------------------------------------------------------------
    // THREAD CREATION (parent-side)
    // ------------------------------------------------------------

    void __ft_thread_create(uint64_t child_id_raw) {
        // Already incrementing before thread_create.
        // 1. Get Parent Thread State
        // ThreadState* parent = get_current_thread();

        // // 2. Increment Parent's Clock
        // {
        //     std::lock_guard<std::recursive_mutex> lock(parent->mtx);
            
        //     // Parent.C[Parent.tid]++
        //     parent->C[parent->tid]++;
            
        //     // Update invariant
        //     parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
        // }
        
        // // printf("[FastTrack] Thread %d created new thread (Raw ID: %lu)\n", 
        // //        parent->tid, (unsigned long)child_id_raw);
    }

    void __ft_thread_join(uint64_t child_raw_id) {
        // 1. IDENTIFY PARENT (Current Thread)
        // The thread calling join() is the parent.
        ThreadState* parent = get_current_thread();

        // 2. IDENTIFY CHILD (From Argument)
        ThreadState* child = nullptr;

        std::map<pthread_t, ThreadState*>::iterator it;
        {
            std::lock_guard<std::recursive_mutex> lock(get_thread_map_lock());
            auto& threads = get_threads_map();
            it = threads.find((pthread_t)child_raw_id);
            if (it != threads.end()) {
                child = it->second;
            }
        }

        if (!child) 
        {
            std::cout << "[FastTrack] WARNING: Joined thread with raw ID " << (unsigned long)child_raw_id 
                 << " not found in registry. Skipping FastTrack join logic." << std::endl;
            // Child might not have been instrumented or created via our hooks
            return;
        }

        {
            // 3. FASTTRACK JOIN LOGIC
            // Rule: Parent.C = max(Parent.C, Child.C)
            std::lock_guard<std::recursive_mutex> parent_lock(parent->mtx);
            std::lock_guard<std::recursive_mutex> child_lock(child->mtx);

            size_t len = std::max(parent->C.size(), child->C.size());
            
            // Resize parent if needed
            if (parent->C.size() < len) {
                parent->C.resize(len, 0);
            }

            // Merge Child's clock into Parent's clock
            for (size_t i = 0; i < child->C.size(); i++) {
                if (child->C[i] > parent->C[i]) {
                    parent->C[i] = child->C[i];
                }
            }

            // Update Parent's epoch cache since its VC changed
            parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
        }

        {
            std::lock_guard<std::recursive_mutex> lock(get_thread_map_lock());
            get_threads_map().erase(it);
        }

        delete child;
        // printf("[FastTrack] Thread %d (Parent) joined with Thread %d (Child)\n", 
        //     parent->tid, child->tid);
    }

    // ------------------------------------------------------------
    // MEMORY EVENTS
    // ------------------------------------------------------------
    void __ft_read(void* addr, int line_no) {

        ThreadState* t = get_current_thread();
        VarState* x = get_var_state(addr);

        // Lock the variable metadata
        std::lock_guard<std::recursive_mutex> lock(x->mtx);
        std::lock_guard<std::recursive_mutex> lock2(t->mtx);

        // ---------------------------------------------------------
        // ALGORITHM START
        // ---------------------------------------------------------

        // 1. Same Epoch Check (Fast Path)
        if (x->R == t->epoch) return;

        // 2. Write-Read Race Check
        // if (x.W > t.C[TID(x.W)]) error;
        int w_tid = get_tid(x->W);
        int w_clock = get_clock(x->W);
        if (w_clock > t->get_clock_of(w_tid)) {
            report_race("W-R", addr, w_tid, t->tid, line_no);
            x->W = 0;
        }

        // 3. Update Read State
        if (x->R == READ_SHARED) {
            // Shared State
            vec_set_epoch(x->Rvc, t->tid, t->epoch);
        }
        else {
            // Exclusive State
            int r_tid = get_tid(x->R);
            int r_clock = get_clock(x->R);

            // Check if the previous read happened-before current thread
            if (r_clock <= t->get_clock_of(r_tid)) {
                // Exclusive ownership transfers to us
                x->R = t->epoch;
            } 
            else {
                Epoch old_R = x->R;
                x->Rvc.clear();
                
                // Record both the previous reader and current reader
                vec_set_epoch(x->Rvc, r_tid, old_R);
                vec_set_epoch(x->Rvc, t->tid, t->epoch);
                
                x->R = READ_SHARED;
            }
        }
    }

    void __ft_write(void* addr, int line_no) {

        ThreadState* t = get_current_thread();
        VarState* x = get_var_state(addr);

        std::lock_guard<std::recursive_mutex> lock(x->mtx);
        std::lock_guard<std::recursive_mutex> lock2(t->mtx);

        // 1. Same Epoch Check (Fast Path)
        if (x->W == t->epoch) return;

        // 2. Write-Write Race Check
        // if (x.W > t.C[TID(x.W)]) error;
        int w_tid = get_tid(x->W);
        int w_clock = get_clock(x->W);
        if (w_clock > t->get_clock_of(w_tid)) {
            report_race("W-W", addr, w_tid, t->tid, line_no);
        }

        // 3. Read-Write Race Check
        if (x->R != READ_SHARED) {
            // Shared Check (Exclusive Read case)
            // if (x.R > t.C[TID(x.R)]) error;
            if (x->R != 0) { 
                int r_tid = get_tid(x->R);
                int r_clock = get_clock(x->R);
                if (r_clock > t->get_clock_of(r_tid)) {
                    report_race("R-W", addr, r_tid, t->tid, line_no);
                }
            }
        } else {
            // Shared Check (Vector Clock case)
            // if (x.Rvc[u] > t.C[u] for any u) error; (SLOW PATH)
            for (int i = 0; i < (int)x->Rvc.size(); ++i) {
                if (x->Rvc[i] == 0) continue;
                int u_clock = get_clock(x->Rvc[i]);
                if (u_clock > t->get_clock_of(i)) {
                    report_race("R-W", addr, i, t->tid, line_no);
                }
            }
        }
        // 4. Update Write State
        // x.W = t.epoch;
        x->W = t->epoch;
        x->R = 0;
        x->Rvc.clear();
    }


    // ------------------------------------------------------------
    // LOCK EVENTS
    // ------------------------------------------------------------

    void __ft_lock(void* mutex_addr) {
        ThreadState* t = get_current_thread();
    
        LockState* m = get_lock_state(mutex_addr);
    
        std::lock_guard<std::recursive_mutex> lock(m->mtx);
        std::lock_guard<std::recursive_mutex> lock2(t->mtx);
    
        // FT vector clock merge
        if (m->L.size() > t->C.size())
            t->C.resize(m->L.size(), 0);
        for (size_t i = 0; i < m->L.size(); i++)
            if (m->L[i] > t->C[i]) t->C[i] = m->L[i];
        t->epoch = make_epoch(t->tid, t->C[t->tid]);
    }

    void __ft_unlock(void* mutex_addr) {
        ThreadState* t = get_current_thread();
        LockState* m = get_lock_state(mutex_addr);

        std::lock_guard<std::recursive_mutex> lock(m->mtx);
        std::lock_guard<std::recursive_mutex> lock2(t->mtx);

        // 1. RESIZE: If the thread knows about more threads than the lock,
        if (t->C.size() > m->L.size()) {
            m->L.resize(t->C.size(), 0);
        }

        // 2. UPDATE: Copy the Thread's clock to the Lock.
        for (size_t i = 0; i < t->C.size(); i++) {
            m->L[i] = t->C[i];
        }

        // 3. INCREMENT.
        t->C[t->tid]++;
        
        // 4. Update the cached epoch invariant
        t->epoch = make_epoch(t->tid, t->C[t->tid]);
    }

}
