#include<pthread.h>
#include<vector>
using namespace std;

static std::vector<int *> g_ptrs;
static pthread_mutex_t g_vec_mutex = PTHREAD_MUTEX_INITIALIZER;

int* gl;
static void *worker5(void *) {
    pthread_mutex_lock(&g_vec_mutex);
    int *p = g_ptrs.empty() ? nullptr : g_ptrs[0];
    // int* p = (gl == nullptr ? nullptr : gl);
    pthread_mutex_unlock(&g_vec_mutex);
    if (p) *p = 55;         /* TEST_RACE_5: write (no lock on the int itself) */
    return nullptr;
}

static void busy_wait_ms(int ms) {
    struct timespec ts = {0, (long)ms * 1000000L};
    nanosleep(&ts, nullptr);
}
void setter(int* ptr){
    gl = ptr;   
    return;
}
static void test5_escape_via_vector() {
    int val = 0;
    pthread_mutex_lock(&g_vec_mutex);
    g_ptrs.push_back(&val);
    // setter(&val);
    pthread_mutex_unlock(&g_vec_mutex);

    pthread_t t, t1;
    pthread_create(&t, nullptr, worker5, nullptr);
    // pthread_create(&t1, nullptr, worker5, nullptr);
    busy_wait_ms(1);
    int x = val;            /* TEST_RACE_5: read */
    (void)x;
    pthread_join(t, nullptr);
    // pthread_join(t1, nullptr);
    g_ptrs.clear();
    // gl = nullptr;
}

int** global_ptr;
static void *worker_heap(void *) {
    pthread_mutex_lock(&g_vec_mutex);
    int *p = (global_ptr == null) ? nullptr : global_ptr[4];
    // int* p = (gl == nullptr ? nullptr : gl);
    pthread_mutex_unlock(&g_vec_mutex);
    if (p) *p = 55;         /* TEST_RACE_5: write (no lock on the int itself) */
    return nullptr;
}
void setter2(int* ptr){
    int x, y; 
    x = 5;
    int** t = new int*[10];
    t[5] = &x;
    t[1] = &y;
    if(*ptr == 0)t[6] = (int*)(t[5] + 5);
    t[4] = ptr;
    global_ptr = t;
}
static void heap_test(){
    int val = 0;
    pthread_mutex_lock(&g_vec_mutex);
    setter2(&val);
    pthread_mutex_unlock(&g_vec_mutex);

    pthread_t t, t1;
    pthread_create(&t, nullptr, worker_heap, nullptr);
    // pthread_create(&t1, nullptr, worker5, nullptr);
    busy_wait_ms(1);
    int x = val;            /* TEST_RACE_5: read */
    (void)x;
    pthread_join(t, nullptr);
    // pthread_join(t1, nullptr);
}
int main(){
    heap_test();
    // test5_escape_via_vector();
    return 0;
}
