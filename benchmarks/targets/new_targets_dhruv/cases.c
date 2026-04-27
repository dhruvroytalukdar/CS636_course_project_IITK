#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdbool.h>

// --- Data Structures ---

struct Node {
    struct Node* ptr;
    int val;
};

struct A {
    int f;
};

struct Protected {
    pthread_mutex_t lock;
    int data;
};

// External "black box" to simulate escaping
void escape(void* p) {
    // In a real scenario, this might store the pointer globally
    // or pass it to another thread.
    (void)p; 
}

// --- Test Cases ---

/**
 * Case 1: Trivial Scalar Replacement
 * Objective: Eliminate allocation via store-load forwarding.
 */
void test_trivial_replacement() {
    struct A *a = (struct A*)malloc(sizeof(struct A)); // Tracked allocation
    if (!a) return;

    a->f = 10;                                         // Store to unescaped memory
    int result = a->f + 5;                             // Load forwarding: result = 10 + 5
    
    printf("Case 1 Result: %d\n", result);
    free(a);                                           // Dead Store Elimination
}

/**
 * Case 2: Unescaped Object Graph
 * Objective: Prove stores into unescaped memory do not capture.
 */
void test_unescaped_graph() {
    struct Node *a = (struct Node*)malloc(sizeof(struct Node));
    struct Node *b = (struct Node*)malloc(sizeof(struct Node));
    if (!a || !b) return;

    a->ptr = b;  // Store tracked pointer into unescaped object
    b->val = 42;
    
    // The pass should track through the points-to graph
    int x = a->ptr->val; 
    
    printf("Case 2 Value: %d\n", x);
    free(b);
    free(a);
}

/**
 * Case 3: Lock Elision
 * Objective: Downgrade thread-safe operations for local objects.
 */
void test_lock_elision() {
    struct Protected *p = (struct Protected*)malloc(sizeof(struct Protected));
    if (!p) return;

    pthread_mutex_init(&p->lock, NULL);
    
    // Since 'p' never escapes the thread, these are redundant
    pthread_mutex_lock(&p->lock);   
    p->data = 100;
    pthread_mutex_unlock(&p->lock); 
    
    printf("Case 3 Data: %d\n", p->data);
    pthread_mutex_destroy(&p->lock);
    free(p);
}

/**
 * Case 4: Partial Escape
 * Objective: Optimize paths before an escape occurs using CFG sensitivity.
 */
void test_partial_escape(bool cond) {
    struct A *a = (struct A*)malloc(sizeof(struct A));
    if (!a) return;
    a->f = 5;

    if (cond) {
        escape(a); // Pointer is captured here
    } else {
        // Optimization path: 'a' is still in the tracked 'alloc' set
        int local_val = a->f; 
        printf("Case 4 Local Value: %d\n", local_val);
    }
    // No free(a) if it escaped to avoid double-free/dangling pointers
}

/**
 * Case 5: Cyclic Unescaped Graph
 * Objective: Convergence on cyclic structures using Fixed-Point Iteration.
 */
void test_cyclic_graph() {
    struct Node *a = (struct Node*)malloc(sizeof(struct Node));
    struct Node *b = (struct Node*)malloc(sizeof(struct Node));
    if (!a || !b) return;

    a->ptr = b; 
    b->ptr = a; // Cyclic dependency
    
    a->val = 1;
    b->val = 2;
    
    // Analysis should re-evaluate header merges until the state is stable
    printf("Case 5 Cyclic Vals: %d, %d\n", a->val, b->val);
    
    free(a);
    free(b);
}

int main() {
    test_trivial_replacement();
    test_unescaped_graph();
    test_lock_elision();
    test_partial_escape(false);
    test_cyclic_graph();
    return 0;
}
