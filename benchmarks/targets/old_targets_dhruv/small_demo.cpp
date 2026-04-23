#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

long shared_var = 0;

void* thread0_func(void* arg) {
    // 1. Read: SA goes to OWNED_READ
    long v = shared_var; 
    
    // 2. Write: SA goes to OWNED_WRITE
    shared_var = v + 1;  
    
    // 3. Read: SA erroneously downgrades back to OWNED_READ
    v = shared_var;      
    
    return NULL;
}

void* thread1_func(void* arg) {
    // Force Thread 1 to run after Thread 0. 
    // We use sleep instead of sync primitives to ensure no happens-before edge exists.
    usleep(100000); 

    // 4. Read: SA sees OWNED_READ from another thread. 
    // Transitions to SHARED and sets FT Write Epoch to 0.
    long v = shared_var; 
    
    // Plain FT will flag a W-R race here. 
    // SA FT will silently miss it because it wiped the Write Epoch.
    return NULL;
}

int main() {
    pthread_t t0, t1;
    
    pthread_create(&t0, NULL, thread0_func, NULL);
    pthread_create(&t1, NULL, thread1_func, NULL);
    
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    
    return 0;
}