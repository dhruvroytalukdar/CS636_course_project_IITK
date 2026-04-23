#include <iostream>
#include <pthread.h>

// Shared resources
int shared_var = 0;
pthread_mutex_t my_mutex;

// The function that the new thread will execute
void* thread_worker(void* arg) {
    // 1. Unprotected Read (triggers __wcp_read)
    int local_copy = shared_var; 
    
    // 2. Lock (triggers __wcp_lock)
    pthread_mutex_lock(&my_mutex);
    
    // 3. Protected Read and Write (triggers __wcp_read and __wcp_write)
    shared_var = local_copy + 10;
    
    // 4. Unlock (triggers __wcp_unlock)
    pthread_mutex_unlock(&my_mutex);
    
    return nullptr;
}

int main() {
    pthread_t my_thread;
    pthread_mutex_init(&my_mutex, nullptr);

    // 5. Initial Write (triggers __wcp_write)
    shared_var = 5;

    // 6. Thread Create (triggers __wcp_prepare_context and __wcp_thread_create)
    pthread_create(&my_thread, nullptr, thread_worker, nullptr);

    // 7. Main Thread Lock (triggers __wcp_lock)
    pthread_mutex_lock(&my_mutex);
    
    // 8. Main Thread Protected Write (triggers __wcp_read and __wcp_write)
    shared_var += 5; 
    
    // 9. Main Thread Unlock (triggers __wcp_unlock)
    pthread_mutex_unlock(&my_mutex);

    // 10. Thread Join (triggers __wcp_thread_join)
    pthread_join(my_thread, nullptr);

    pthread_mutex_destroy(&my_mutex);
    return 0;
}