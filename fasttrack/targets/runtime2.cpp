#include <set>
#include <string>
#include <cstdint>
#include <iostream>
#include <vector>
#include <pthread.h>
#include <atomic>
#include <unordered_map>
#include <dlfcn.h>
#include <immintrin.h> 
#include <algorithm>
#include <cstring>
#include <cstdio>

//fix threads, to avoid vector resizing issues(realised
//vectors not thread safe)
const int MAX_THREADS = 200; 
const int SHARED_BITS = 8;
const int SHARED_COUNT = 1 << SHARED_BITS; 
const int SHARED_MASK = SHARED_COUNT - 1;

enum racetype { W_W, R_W, W_R };

struct spin_lck {
    std::atomic_flag flag = ATOMIC_FLAG_INIT;

    void lock() {
        while (flag.test_and_set(std::memory_order_acquire)) {
            // spin while locked
            while (flag.test_and_set(std::memory_order_relaxed)) {
                _mm_pause();   // reduce contention
            }
        }
    }

    void unlock() {
        flag.clear(std::memory_order_release);
    }
};


//locks/////////
spin_lck map_locks[SHARED_COUNT];

inline int get_lock_index(unsigned long addr) {
    return (addr >> 3) & SHARED_MASK;
}
spin_lck thread_map_lock;
spin_lck race_vector_lock;
///////////////////////////////////////
// map///////////s
using Epoch = uint32_t;
using vc_t = std::vector<int>; // Vector Clock
const Epoch empty_epoch = 0;
#define GET_TID(x) (x >> 24)
#define GET_CLK(x) (x & 0x00FFFFFF)
#define MAKE_EP(tid, clk) ((tid << 24) | (clk & 0x00FFFFFF))

struct thread_state {
    int tid;
    vc_t C; //current thread vc full
    //pthread_t hooking
    void* (*start_routine)(void*);
    void* arg;
    pthread_t real_tid;

    thread_state(int id) : tid(id), C(MAX_THREADS, 0) {
        //init clk
        if(id < MAX_THREADS) C[id] = 1;
    }
};

struct var_state {
    unsigned long addr;
    spin_lck v_lock; //per var lock
    
    Epoch writer;
    Epoch reader;   
    vc_t readers;     //full reader vc
    bool read_share;

    var_state(unsigned long address)
        : addr(address), writer(empty_epoch), reader(empty_epoch), 
          read_share(false), readers(MAX_THREADS, 0) {}
};

struct race {
    racetype t;
    int tid1;
    int tid2;
    unsigned long var_addr;
};


static pthread_once_t runtime_once = PTHREAD_ONCE_INIT;
//thread Map
std::unordered_map<int, thread_state*>& get_threads(){
    static std::unordered_map<int, thread_state*> instance;
    return instance;
}

//variable Map
std::unordered_map<unsigned long, var_state*>& get_vars(int index) {
    static std::unordered_map<unsigned long, var_state*> vars[SHARED_COUNT];
    return vars[index];
}

//lock VC Map
std::unordered_map<uint64_t, vc_t>& get_lock_vc(int index) {

    static std::unordered_map<uint64_t, vc_t> instance[SHARED_COUNT];
    return instance[index];
}

//pthread Map
std::unordered_map<pthread_t, int>& get_pthread_map() {
    static std::unordered_map<pthread_t, int> instance;
    return instance;
}
#define threads get_threads()
//#define vars get_vars()
//#define lock_vc get_lock_vc()
#define pthread_map get_pthread_map()

inline void ensure_runtime_init();
//global data strucutres///////////////////

 std::vector<race> races;
// std::unordered_map<unsigned long, var_state*> vars;
// std::unordered_map<uint64_t, vc_t> lock_vc;       
// std::unordered_map<int, thread_state*> threads;    
// std::unordered_map<pthread_t, int> pthread_map;   

//thread local storage for mapping 1,2,3,4 tid
thread_local int tls_tid = -1;
std::atomic<int> global_tid_counter = 0;


int get_tid() {
    if(tls_tid != -1)return tls_tid;
    return -1; 
}

thread_state* get_current_thread_state() {
    int tid = get_tid();
    return threads[tid]; 
}
std::set<std::string> reported_races;
void report_race(racetype type, int tid1, int tid2, unsigned long addr) {
    race_vector_lock.lock();

    int t_min = tid1;
    int t_max = tid2;
    
    if (type == W_W) {
        if (tid1 > tid2) {
            t_min = tid2;
            t_max = tid1;
        }
    }
    //unique key
    char buffer[128];
    const char* type_str = (type == W_W) ? "W-W" : (type == R_W ? "R-W" : "W-R");
    
    snprintf(buffer, sizeof(buffer), "%s:%d:%d:%lx", type_str, t_min, t_max, addr);
    std::string key(buffer);

    if (reported_races.find(key) == reported_races.end()) {
        reported_races.insert(key);
        
        races.push_back({type, tid1, tid2, addr});
        
        printf("[Race Detected] %s Thread TID1: %d, TID2: %d ADDR: %lx\n", type_str, tid1, tid2, addr);
    }

    race_vector_lock.unlock();
}

extern "C" void __log_load(void* x) {
//    std::cout << "debug:" << "got in a load at addr: " << x << std::endl;
    ensure_runtime_init();
    unsigned long addr = (unsigned long)x;
    int tid = get_tid();
    if (tid == -1) return;
    //first time load , handling ?? local shared variable detect handling ??
    thread_state* t_state = threads[tid];
    int current_clk = t_state->C[tid];
    Epoch current_epoch = MAKE_EP(tid, current_clk);

    int shard = get_lock_index(addr);
    map_locks[shard].lock();
    auto& vars = get_vars(shard);  
    var_state* var = nullptr;
    auto it = vars.find(addr);
    //first time access
    if(it == vars.end()){
        var = new var_state(addr);
        vars[addr] = var;
    }else{
        var = it->second;
        }
    
    //get the var lock 
    var->v_lock.lock();
    
    //deadlock ????
    map_locks[shard].unlock();

    //critical sec, too long ??

    //W-R race
    Epoch w_epoch = var->writer;
    if(w_epoch != empty_epoch){
        int w_tid = GET_TID(w_epoch);
        int w_clk = GET_CLK(w_epoch);
        if(w_clk > t_state->C[w_tid]){ 
        //found race
             // race_vector_lock.lock();
             // printf("W-R RACE: %d %d %lx\n", w_tid, tid, addr);
             report_race(W_R, w_tid, tid, addr);
             // races.push_back({W_R, w_tid, tid, addr});
             // race_vector_lock.unlock();
        }
    }

    //UPDATE
    Epoch r_epoch = var->reader;
   
    //already a vc or epoch ?
    if(var->read_share){
        //READ SHARED
        var->readers[tid] = current_clk;
    }else{
        //READ EXCLUSIVE
        if(r_epoch == current_epoch){
             //read same epoch case
        }else if(r_epoch == empty_epoch){
             var->reader = current_epoch;
        }else{
             int r_tid = GET_TID(r_epoch);
             int r_clk = GET_CLK(r_epoch);
             
             if(r_clk <= t_state->C[r_tid]){
                 //update
                 var->reader = current_epoch;
             }else{
                 //downgrade to shared, a vc
                 //set flag
                 var->read_share = true;
                 var->readers[r_tid] = r_clk; 
                 var->readers[tid] = current_clk; 
                 var->reader = empty_epoch; 
             }
        }
    }
    
    //
    var->v_lock.unlock();
}

extern "C" void __log_store(void* x){
    
    ensure_runtime_init();
 //   std::cout << "debug:" << "got in a store at addr: " << x << std::endl;
    unsigned long addr = (unsigned long)x;
    int tid = get_tid();
    if (tid == -1) return;

    thread_state* t_state = threads[tid];
    
    int current_clk = t_state->C[tid];
    Epoch current_epoch = MAKE_EP(tid, current_clk);

    int shard = get_lock_index(addr);
    map_locks[shard].lock();
    
    var_state* var = nullptr;
    auto& vars = get_vars(shard);
    auto it = vars.find(addr);
    if(it == vars.end()) {
       
         var = new var_state(addr);
        vars[addr] = var;
    }else{
        var = it->second;
    }
    
    var->v_lock.lock();
    map_locks[shard].unlock();


    // check w-w race
    Epoch w_epoch = var->writer;
    if(w_epoch != empty_epoch){
        int w_tid = GET_TID(w_epoch);
        
        int w_clk = GET_CLK(w_epoch);
        if(w_clk > t_state->C[w_tid]){
        // race_vector_lock.lock();
             // printf("W-W RACE: %d %d %lx\n", w_tid, tid, addr);
             
            
             report_race(W_W, w_tid, tid, addr);
             // races.push_back({W_W, w_tid, tid, addr});
             
              // race_vector_lock.unlock();
        }
    }

    //check read
    if(!var->read_share){
        Epoch r_epoch = var->reader;
        if(r_epoch != empty_epoch) {
            int r_tid = GET_TID(r_epoch);
            
            int r_clk = GET_CLK(r_epoch);
            if(r_clk > t_state->C[r_tid]){
                // race_vector_lock.lock();
                
             report_race(R_W, r_tid, tid, addr);
                // printf("R-W RACE: %d %d %lx\n", r_tid, tid, addr);
             //    races.push_back({R_W, r_tid, tid, addr});
              //   race_vector_lock.unlock();
            }
        }
    }else{
        //worse case full comparison
        for(int i = 0; i < MAX_THREADS; i++){
            if(var->readers[i] > t_state->C[i]){
                 race_vector_lock.lock();
                 races.push_back({R_W, i, tid, addr});
                 report_race(R_W, i, tid, addr);
                 race_vector_lock.unlock();
            }
        }
        //upgrade to epoch
        var->read_share = false;
        std::fill(var->readers.begin(), var->readers.end(), 0);
        var->reader = empty_epoch;
    }

    //UPDATE
    var->writer = current_epoch;

    var->v_lock.unlock();
}


extern "C" void __log_lock(void* x){
    
    ensure_runtime_init();
    // std::cout << "debug:" << "got in a lock at addr: " << x << std::endl;
    uint64_t addr = (uint64_t)x;
    int tid = get_tid();
    thread_state* t = threads[tid];

    int shard = get_lock_index(addr);
    
    map_locks[shard].lock();
    auto& lock_vc = get_lock_vc(shard);
    if(lock_vc.find(addr) == lock_vc.end()){
        lock_vc[addr] = vc_t(MAX_THREADS, 0);
    }
    vc_t& l_vc = lock_vc[addr];
        //join 
    for(int i = 0; i < MAX_THREADS; i++){
        t->C[i] = std::max(t->C[i], l_vc[i]);
    }

    map_locks[shard].unlock();
}

extern "C" void __log_unlock(void* x){
    
    ensure_runtime_init();
    // std::cout << "debug:" << "got in a unlock at addr: " << x << std::endl;
    uint64_t addr = (uint64_t)x;
    int tid = get_tid();
    thread_state* t = threads[tid];

    int shard = get_lock_index(addr);
    //same lock ? issues ??
    map_locks[shard].lock();

    //copy,  c_t change later

    auto& lock_vc = get_lock_vc(shard);
    lock_vc[addr] = t->C; 

    //increment c_t
    t->C[tid]++;

    map_locks[shard].unlock();
}


struct wrapper_arg{
    thread_state* child_state;
};

void* thread_wrapper(void* ptr){
    std::cout << "a child started" << std::endl;
    wrapper_arg* arg = (wrapper_arg*)ptr;
    thread_state* state = arg->child_state;
    
    delete arg; 

    //map real pthread_t to tid to find child in join
    thread_map_lock.lock();
    pthread_map[pthread_self()] = state->tid;
    thread_map_lock.unlock();
    
    tls_tid = state->tid;
    threads[state->tid] = state; 

    //run actual thread routine
    return state->start_routine(state->arg);
}

typedef int(*pthread_create_t)(pthread_t*, const pthread_attr_t*, void* (*)(void*), void*);
typedef int(*pthread_join_t)(pthread_t, void **);

extern "C" int pthread_create(pthread_t* thread, const pthread_attr_t* attr,
                              void* (*start_routine)(void*), void* arg){
    
    ensure_runtime_init();
    //assign tid
    int child_tid = global_tid_counter.fetch_add(1);

    //add some resizing here ,completely copy to a new larger array
    if(child_tid >= MAX_THREADS){
        fprintf(stderr, "max threads\n");
        exit(1);
    }

    //init child
    thread_state* child_state = new thread_state(child_tid);
    child_state->start_routine = start_routine;
    child_state->arg = arg;

    
    //copy vc to child
    //increment parent also ??? not done in paper, seems intuitive 
    int parent_tid = get_tid();

  //  printf("pthread_create called, parent : %d, child %d\n" , parent_tid, child_tid);


    if(parent_tid != -1){
        thread_state* parent = threads[parent_tid];
        child_state->C = parent->C; 
        //parent increment
        parent->C[parent_tid]++;
        child_state->C[child_tid]++; 
    }else{
        //main thread init if not done
        if(child_tid == 0){
             thread_state* main_t = new thread_state(0);
             threads[0] = main_t;
             tls_tid = 0;
        }
    }
    
    //store in global map
    thread_map_lock.lock();
    threads[child_tid] = child_state;
    thread_map_lock.unlock();

    wrapper_arg* w_arg = new wrapper_arg{child_state};

    static pthread_create_t real_create = (pthread_create_t)dlsym(RTLD_NEXT, "pthread_create");
    return real_create(thread, attr, thread_wrapper, w_arg);
}

extern "C" int pthread_join(pthread_t thread, void **retval){
  
    ensure_runtime_init();
    static pthread_join_t real_join = (pthread_join_t)dlsym(RTLD_NEXT, "pthread_join");
    
    int ret = real_join(thread, retval);

    int parent_tid = get_tid();
    
    thread_map_lock.lock();
    
    if(pthread_map.find(thread) == pthread_map.end()){
        thread_map_lock.unlock();
        return ret;
    }
    int child_tid = pthread_map[thread];
    thread_map_lock.unlock();
    
  //  printf("DEBUG : pthread_join called, parent : %d, child %d\n" , child_tid, parent_tid);
    
    thread_state* parent = threads[parent_tid];
    thread_state* child = threads[child_tid];

    for(int i = 0; i < MAX_THREADS; i++){
         parent->C[i] = std::max(parent->C[i], child->C[i]);
    }
    parent->C[parent_tid]++;

    return ret;
}

// __attribute__((constructor))
// void init_system(){
//     // Manually init main thread (TID 0)
//     int main_tid = global_tid_counter.fetch_add(1);
//     thread_state* main_t = new thread_state(main_tid);
//     threads[main_tid] = main_t;
//     tls_tid = main_tid;
//     pthread_map[pthread_self()] = main_tid;
// }
static void runtime_init() {
    // Assign TID 0 to main thread
    int main_tid = global_tid_counter.fetch_add(1, std::memory_order_relaxed);

    // Create main thread state
    thread_state* main_ts = new thread_state(main_tid);

    // Register thread
    get_threads()[main_tid] = main_ts;

    // Set TLS
    tls_tid = main_tid;

    // Map pthread_self → tid
    uintptr_t ptid = (uintptr_t)pthread_self();
    get_pthread_map()[ptid] = main_tid;
}

inline void ensure_runtime_init() {
    pthread_once(&runtime_once, runtime_init);
}
