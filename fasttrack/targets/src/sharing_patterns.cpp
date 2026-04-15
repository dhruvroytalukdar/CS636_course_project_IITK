/**
 * sharing_patterns_test.cpp
 * ─────────────────────────────────────────────────────────────────────────────
 * PURPOSE
 *   Stress-test the sharing analysis (escape analysis) in your LLVM pass for
 *   FALSE NEGATIVES — memory that IS shared between threads but was classified
 *   as thread-private and therefore NOT instrumented.
 *
 *   If your race detector fires on any TEST_RACE_* section → detector works.
 *   If it does NOT fire on a TEST_RACE_* section → false negative in analysis.
 *   TEST_SAFE_* sections should never trigger the detector.
 *
 * BUILD
 *   # Without instrumentation (baseline / reference):
 *   g++ -O1 -g -pthread sharing_patterns_test.cpp -o sharing_patterns_test
 *
 *   # With your instrumented pass (adjust flags to your setup):
 *   clang++ -O1 -g -pthread -fpass-plugin=./RaceDetector.so \
 *           sharing_patterns_test.cpp -o sharing_patterns_test_inst
 *
 * RUN
 *   ./sharing_patterns_test [test_number]
 *   No argument → runs all tests sequentially.
 *
 * CATEGORIES OF SHARING PATTERNS TESTED
 *   1.  Heap object pointer passed to pthread_create arg (classic escape)
 *   2.  Global variable (trivially shared – must always be instrumented)
 *   3.  Stack variable address escapes through pthread_create arg struct
 *   4.  Stack variable address stored into a heap-allocated struct
 *   5.  Pointer stored in a globally accessible container (vector)
 *   6.  Aliased pointer: thread receives a pointer-to-pointer, derefs twice
 *   7.  Object returned by malloc, shared via a raw pointer cast to void*
 *   8.  Shared array indexed by thread ID (distinct elements, no race)
 *   9.  Shared array with overlapping indices (racy)
 *   10. Stack array escaping via pointer arithmetic
 *   11. Thread-local storage  (__thread / thread_local) – must NOT instrument
 *   12. Purely thread-private heap object – must NOT instrument
 *   13. Read-only shared constant – safe (but must still be visible to detector)
 *   14. Pointer passed through two levels of indirection
 *   15. Stack variable escapes through a lambda / function-pointer callback
 *
 * NOTES
 *   - Races are made reliable with spin-wait loops so both threads actually
 *     conflict; in production code these patterns are racy but timing-dependent.
 *   - Every TEST_RACE_* deliberately does NOT synchronize so your detector has
 *     a real race to catch.
 *   - Every TEST_SAFE_* uses correct synchronization so the detector should
 *     report nothing.
 * ─────────────────────────────────────────────────────────────────────────────
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <vector>
#include <atomic>

/* ── helpers ──────────────────────────────────────────────────────────────── */

#define SEPARATOR "────────────────────────────────────────────────────\n"
#define PASS(msg) printf("  [PASS] " msg "\n")
#define RACE(msg) printf("  [RACE EXPECTED] " msg "\n")

static void busy_wait_ms(int ms) {
    struct timespec ts = {0, (long)ms * 1000000L};
    nanosleep(&ts, nullptr);
}

/* Tiny barrier for two threads */
struct Barrier2 {
    std::atomic<int> count{0};
    void arrive_and_wait() {
        count.fetch_add(1, std::memory_order_relaxed);
        while (count.load(std::memory_order_relaxed) < 2)
            ;
    }
};

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 1 — Heap pointer passed as pthread_create arg (plain escape)
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the heap allocation result (malloc) is passed via arg.
 * Your analysis must recognise that any malloc'd object whose pointer reaches
 * pthread_create escapes to all threads.  If it marks this object as private
 * the load/store in worker1_writer will be missed → false negative.
 */
struct SharedInt { int value; };

static void *worker1_writer(void *arg) {
    /* TEST_RACE_1: write without any lock */
    SharedInt *s = (SharedInt *)arg;
    s->value = 42;          /* <── this store MUST be instrumented */
    return nullptr;
}
static void test1_heap_escape() {
    printf(SEPARATOR "TEST 1  heap object passed as void* arg\n");
    SharedInt *shared = (SharedInt *)malloc(sizeof(SharedInt));
    shared->value = 0;
    pthread_t t;
    pthread_create(&t, nullptr, worker1_writer, shared);
    /* racy read without join – race between this read and worker write */
    busy_wait_ms(1);
    int x = shared->value;  /* <── this load MUST be instrumented */
    (void)x;
    pthread_join(t, nullptr);
    RACE("heap object passed via arg: store in thread, load in main (racy)");
    free(shared);
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 2 — Global variable (trivially shared)
 * ═══════════════════════════════════════════════════════════════════════════
 * A correct analysis must instrument accesses to globals; failing to detect
 * globals as shared is a fundamental miss.
 */
static volatile int g_global = 0;    /* 'volatile' to defeat dead-store elim */
static pthread_mutex_t g_mutex_2 = PTHREAD_MUTEX_INITIALIZER;

static void *worker2_race(void *) {
    g_global = 1;           /* TEST_RACE_2 write – no lock */
    return nullptr;
}
static void *worker2_safe(void *) {
    pthread_mutex_lock(&g_mutex_2);
    g_global = 1;
    pthread_mutex_unlock(&g_mutex_2);
    return nullptr;
}
static void test2_global() {
    printf(SEPARATOR "TEST 2  global variable access\n");
    g_global = 0;
    pthread_t t;
    /* 2a: racy */
    pthread_create(&t, nullptr, worker2_race, nullptr);
    busy_wait_ms(1);
    int x = g_global;       /* TEST_RACE_2 read – no lock */
    (void)x;
    pthread_join(t, nullptr);
    RACE("global: concurrent read/write without lock");

    /* 2b: safe */
    pthread_create(&t, nullptr, worker2_safe, nullptr);
    pthread_mutex_lock(&g_mutex_2);
    int y = g_global;
    (void)y;
    pthread_mutex_unlock(&g_mutex_2);
    pthread_join(t, nullptr);
    PASS("global: concurrent read/write WITH lock – no race");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 3 — Stack variable whose address escapes via the arg struct
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the variable 'local_val' lives on main's stack frame
 * but its address is stored in the heap-allocated 'args' struct and passed
 * to a thread.  A naive analysis that marks all stack vars as "non-escaping"
 * (because they are not the direct pthread_create arg) will miss this.
 */
struct Args3 { int *ptr; };

static void *worker3(void *arg) {
    Args3 *a = (Args3 *)arg;
    *a->ptr = 99;           /* TEST_RACE_3: write through pointer to caller's stack */
    return nullptr;
}
static void test3_stack_addr_in_struct() {
    printf(SEPARATOR "TEST 3  stack variable address stored in heap struct\n");
    int local_val = 0;      /* stack variable */
    Args3 *args = new Args3;
    args->ptr = &local_val; /* address of stack var escapes into heap struct */
    pthread_t t;
    pthread_create(&t, nullptr, worker3, args);
    busy_wait_ms(1);
    int x = local_val;      /* TEST_RACE_3: read of escaping stack var */
    (void)x;
    pthread_join(t, nullptr);
    RACE("stack var address in heap struct: concurrent r/w (racy)");
    delete args;
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 4 — Pointer to stack var stored directly in a global
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the stack variable's address flows into a global pointer.
 * Any thread reading the global can dereference it and access the stack frame.
 */
static int *g_stack_ptr = nullptr;

static void *worker4(void *) {
    if (g_stack_ptr) *g_stack_ptr = 77;  /* TEST_RACE_4 write */
    return nullptr;
}
static void test4_stack_via_global_ptr() {
    printf(SEPARATOR "TEST 4  stack variable address published through global pointer\n");
    int local = 0;
    g_stack_ptr = &local;   /* stack addr escapes into global – must be detected */
    pthread_t t;
    pthread_create(&t, nullptr, worker4, nullptr);
    busy_wait_ms(1);
    int x = local;          /* TEST_RACE_4 read */
    (void)x;
    pthread_join(t, nullptr);
    g_stack_ptr = nullptr;
    RACE("stack var through global pointer: concurrent r/w (racy)");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 5 — Pointer published into a global std::vector
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: escape through a container.  The pointer flows through
 * vector::push_back.  Analysis must handle store-to-aggregate as an escape.
 */
static std::vector<int *> g_ptrs;
static pthread_mutex_t g_vec_mutex = PTHREAD_MUTEX_INITIALIZER;

static void *worker5(void *) {
    pthread_mutex_lock(&g_vec_mutex);
    int *p = g_ptrs.empty() ? nullptr : g_ptrs[0];
    pthread_mutex_unlock(&g_vec_mutex);
    if (p) *p = 55;         /* TEST_RACE_5: write (no lock on the int itself) */
    return nullptr;
}
static void test5_escape_via_vector() {
    printf(SEPARATOR "TEST 5  pointer escapes via global std::vector\n");
    int val = 0;
    pthread_mutex_lock(&g_vec_mutex);
    g_ptrs.push_back(&val);
    pthread_mutex_unlock(&g_vec_mutex);

    pthread_t t;
    pthread_create(&t, nullptr, worker5, nullptr);
    busy_wait_ms(1);
    int x = val;            /* TEST_RACE_5: read */
    (void)x;
    pthread_join(t, nullptr);
    g_ptrs.clear();
    RACE("pointer through global vector: concurrent r/w (racy)");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 6 — Double indirection: pointer-to-pointer passed as arg
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the thread arg is `int **pp`.  The thread does `**pp`.
 * Analysis needs to follow two pointer dereferences to find the escaped object.
 */
static void *worker6(void *arg) {
    int **pp = (int **)arg;
    **pp = 66;              /* TEST_RACE_6: double deref write */
    return nullptr;
}
static void test6_double_indirection() {
    printf(SEPARATOR "TEST 6  double indirection (pointer-to-pointer)\n");
    int val = 0;
    int *p  = &val;
    int **pp = &p;          /* pp -> p -> val; val is on stack */
    pthread_t t;
    pthread_create(&t, nullptr, worker6, pp);
    busy_wait_ms(1);
    int x = val;            /* TEST_RACE_6: read */
    (void)x;
    pthread_join(t, nullptr);
    RACE("double indirection: **pp=66 vs read val (racy)");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 7 — Shared array, disjoint per-thread indices (NO RACE)
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the array IS shared (passed to threads), but each thread
 * touches a distinct element.  Some detectors / analyses can distinguish this
 * at static time (array partitioning); most cannot and will instrument all
 * accesses.  This test checks that your detector does NOT report a false
 * positive here (the race detector side, not the analysis side).
 */
struct Args7 { int *arr; int idx; };

static void *worker7(void *arg) {
    Args7 *a = (Args7 *)arg;
    a->arr[a->idx] = a->idx * 10;   /* only touches arr[idx] */
    return nullptr;
}
static void test7_disjoint_array_access() {
    printf(SEPARATOR "TEST 7  shared array, disjoint per-thread elements (safe)\n");
    const int N = 4;
    int arr[N];
    memset(arr, 0, sizeof(arr));
    pthread_t threads[N];
    Args7 args[N];
    for (int i = 0; i < N; i++) {
        args[i].arr = arr;
        args[i].idx = i;
        pthread_create(&threads[i], nullptr, worker7, &args[i]);
    }
    for (int i = 0; i < N; i++) pthread_join(threads[i], nullptr);
    PASS("disjoint array elements: each thread writes arr[i] only – no race");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 8 — Shared array with overlapping indices (RACY)
 * ═══════════════════════════════════════════════════════════════════════════
 */
struct Args8 { int *arr; };

static void *worker8a(void *arg) {
    int *arr = ((Args8 *)arg)->arr;
    for (int i = 0; i < 1000; i++) arr[0]++;  /* TEST_RACE_8 */
    return nullptr;
}
static void *worker8b(void *arg) {
    int *arr = ((Args8 *)arg)->arr;
    for (int i = 0; i < 1000; i++) arr[0]--;  /* TEST_RACE_8 */
    return nullptr;
}
static void test8_overlapping_array() {
    printf(SEPARATOR "TEST 8  shared array, overlapping index (racy)\n");
    int arr[4] = {0};
    Args8 a = {arr};
    pthread_t t1, t2;
    pthread_create(&t1, nullptr, worker8a, &a);
    pthread_create(&t2, nullptr, worker8b, &a);
    pthread_join(t1, nullptr);
    pthread_join(t2, nullptr);
    RACE("arr[0] incremented & decremented concurrently without sync");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 9 — Stack array escaping via pointer arithmetic
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the passed pointer is &arr[2] (base+offset).  Analysis
 * must recognise that GEP / pointer arithmetic on a stack alloca still refers
 * to the same alloca, which now escapes.
 */
static void *worker9(void *arg) {
    int *p = (int *)arg;
    p[-1] = 11;   /* writes arr[1] relative to &arr[2] */
    p[ 0] = 22;   /* writes arr[2] */
    p[ 1] = 33;   /* writes arr[3] */
    return nullptr;
}
static void test9_pointer_arithmetic_escape() {
    printf(SEPARATOR "TEST 9  stack array escapes via &arr[2] pointer arithmetic\n");
    int arr[6] = {0,0,0,0,0,0};
    pthread_t t;
    pthread_create(&t, nullptr, worker9, &arr[2]);  /* escape via interior pointer */
    busy_wait_ms(1);
    int x = arr[1] + arr[2] + arr[3];  /* TEST_RACE_9 reads */
    (void)x;
    pthread_join(t, nullptr);
    RACE("stack array escapes via interior pointer &arr[2]: r/w racy");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 10 — Thread-local storage (must NOT be instrumented as shared)
 * ═══════════════════════════════════════════════════════════════════════════
 * __thread / thread_local variables are per-thread by definition.  A correct
 * analysis should mark them as non-shared and skip instrumentation.
 * This test checks for FALSE POSITIVES from the analysis (over-instrumentation).
 */
static __thread int tls_counter = 0;

static void *worker10(void *) {
    /* These accesses should NOT be instrumented – they are thread-local */
    for (int i = 0; i < 100000; i++) {
        tls_counter++;
        tls_counter += 2;
    }
    return nullptr;
}
static void test10_thread_local() {
    printf(SEPARATOR "TEST 10 thread-local storage (__thread) – should NOT instrument\n");
    const int N = 4;
    pthread_t threads[N];
    for (int i = 0; i < N; i++) pthread_create(&threads[i], nullptr, worker10, nullptr);
    for (int i = 0; i < N; i++) pthread_join(threads[i], nullptr);
    PASS("TLS accesses: no sharing, no race; detector should be silent");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 11 — Purely thread-private heap object (must NOT be instrumented)
 * ═══════════════════════════════════════════════════════════════════════════
 * Each thread allocates, uses, and frees its own object.  The pointer never
 * escapes to any other thread.  Analysis should classify as private.
 * A correct analysis avoids instrumenting the inner loop, giving a measurable
 * performance benefit.
 */
static void *worker11(void *) {
    /* All allocations and accesses are strictly thread-private */
    int *private_arr = (int *)malloc(4096 * sizeof(int));
    for (int i = 0; i < 4096; i++) private_arr[i] = i * i;
    long sum = 0;
    for (int i = 0; i < 4096; i++) sum += private_arr[i];
    (void)sum;
    free(private_arr);
    return nullptr;
}
static void test11_private_heap() {
    printf(SEPARATOR "TEST 11 thread-private heap object – should NOT instrument\n");
    const int N = 4;
    pthread_t threads[N];
    for (int i = 0; i < N; i++) pthread_create(&threads[i], nullptr, worker11, nullptr);
    for (int i = 0; i < N; i++) pthread_join(threads[i], nullptr);
    PASS("private heap: each thread owns its allocation; no escape, no race");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 12 — Multi-level struct escape: field of field
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the escaped pointer points to a struct S.  A field of S
 * contains another struct T.  The thread writes to T.  Analysis must mark the
 * entire S (including nested T) as shared; field-insensitive analysis handles
 * this, but an overly field-sensitive one might miss T.
 */
struct Inner12 { int x; int y; };
struct Outer12 { Inner12 inner; int z; };

static void *worker12(void *arg) {
    Outer12 *o = (Outer12 *)arg;
    o->inner.x = 1;     /* TEST_RACE_12 nested field write */
    o->inner.y = 2;
    return nullptr;
}
static void test12_nested_struct_escape() {
    printf(SEPARATOR "TEST 12 nested struct field escape\n");
    Outer12 obj = {{0,0},0};
    pthread_t t;
    pthread_create(&t, nullptr, worker12, &obj);
    busy_wait_ms(1);
    int x = obj.inner.x;   /* TEST_RACE_12 read */
    (void)x;
    pthread_join(t, nullptr);
    RACE("nested struct: concurrent read of inner.x and write of inner.x");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 13 — Escape via memcpy of the pointer
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: the pointer to the shared object is copied via memcpy
 * (not a direct assignment).  Analysis must treat memcpy as an assignment of
 * the pointer value, propagating the escape.
 */
struct Args13 { uintptr_t ptr_bits; };

static void *worker13(void *arg) {
    Args13 *a = (Args13 *)arg;
    int *p;
    memcpy(&p, &a->ptr_bits, sizeof(p));   /* reconstruct pointer from raw bits */
    *p = 13;    /* TEST_RACE_13 */
    return nullptr;
}
static void test13_escape_via_memcpy() {
    printf(SEPARATOR "TEST 13 pointer escape via memcpy\n");
    int val = 0;
    Args13 args;
    uintptr_t addr = (uintptr_t)&val;
    memcpy(&args.ptr_bits, &addr, sizeof(addr));
    pthread_t t;
    pthread_create(&t, nullptr, worker13, &args);
    busy_wait_ms(1);
    int x = val;    /* TEST_RACE_13 read */
    (void)x;
    pthread_join(t, nullptr);
    RACE("pointer memcpy'd into struct: thread writes *p concurrently (racy)");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 14 — Read-only shared data (safe, but must still be seen as shared)
 * ═══════════════════════════════════════════════════════════════════════════
 * Multiple threads read the same object (no writes after publication).
 * This should NOT trigger a race, but the analysis must still classify the
 * object as shared (so if a write sneaks in later it IS instrumented).
 */
struct ReadOnly14 { const int values[8]; };

static void *worker14(void *arg) {
    const ReadOnly14 *ro = (const ReadOnly14 *)arg;
    long sum = 0;
    for (int i = 0; i < 8; i++) sum += ro->values[i];
    (void)sum;
    return nullptr;
}
static void test14_readonly_shared() {
    printf(SEPARATOR "TEST 14 read-only shared struct (safe – no race)\n");
    ReadOnly14 ro = {{1,2,3,4,5,6,7,8}};
    const int N = 4;
    pthread_t threads[N];
    for (int i = 0; i < N; i++) pthread_create(&threads[i], nullptr, worker14, &ro);
    for (int i = 0; i < N; i++) pthread_join(threads[i], nullptr);
    PASS("read-only shared: N threads read same const object, no write – safe");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 15 — Escape through function pointer / callback stored in a struct
 * ═══════════════════════════════════════════════════════════════════════════
 * Analysis challenge: a callback function pointer in a struct is invoked by
 * a thread.  The callback captures the address of a local variable (via the
 * same struct).  Analysis must follow the function pointer call to detect escape.
 */
struct CB15 {
    void (*fn)(void *ctx);
    void *ctx;
};

static void cb15_write(void *ctx) {
    int *p = (int *)ctx;
    *p = 15;   /* TEST_RACE_15 */
}
static void *worker15(void *arg) {
    CB15 *cb = (CB15 *)arg;
    cb->fn(cb->ctx);
    return nullptr;
}
static void test15_function_pointer_escape() {
    printf(SEPARATOR "TEST 15 escape via function pointer / callback\n");
    int local = 0;
    CB15 cb = {cb15_write, &local};
    pthread_t t;
    pthread_create(&t, nullptr, worker15, &cb);
    busy_wait_ms(1);
    int x = local;   /* TEST_RACE_15 read */
    (void)x;
    pthread_join(t, nullptr);
    RACE("function-pointer callback writes to caller's local: concurrent r/w (racy)");
}

/* ═══════════════════════════════════════════════════════════════════════════
 * MAIN
 * ═══════════════════════════════════════════════════════════════════════════ */
static void (*TESTS[])(void) = {
    test1_heap_escape,
    test2_global,
    test3_stack_addr_in_struct,
    test4_stack_via_global_ptr,
    test5_escape_via_vector,
    test6_double_indirection,
    test7_disjoint_array_access,
    test8_overlapping_array,
    test9_pointer_arithmetic_escape,
    test10_thread_local,
    test11_private_heap,
    test12_nested_struct_escape,
    test13_escape_via_memcpy,
    test14_readonly_shared,
    test15_function_pointer_escape,
};

int main(int argc, char **argv) {
    printf("\n══════════════════════════════════════════════════════\n");
    printf("  sharing_patterns_test  —  escape analysis coverage\n");
    printf("══════════════════════════════════════════════════════\n\n");

    int which = -1;
    if (argc == 2) which = atoi(argv[1]) - 1;

    int n = (int)(sizeof(TESTS)/sizeof(TESTS[0]));
    for (int i = 0; i < n; i++) {
        if (which >= 0 && i != which) continue;
        TESTS[i]();
        printf("\n");
    }
    printf("══════════════════════════════════════════════════════\n");
    printf("  Legend:\n");
    printf("  [RACE EXPECTED]  — detector MUST fire here\n");
    printf("  [PASS]           — detector must be SILENT here\n");
    printf("══════════════════════════════════════════════════════\n\n");
    return 0;
}
