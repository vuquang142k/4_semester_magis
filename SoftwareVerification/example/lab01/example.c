#include <pthread.h>
#include <stdio.h>

int var1 = 3, var2 = 2;
int res1 = 0;

void* thread1(void* arg) {
    var1++;
    var2++;
}

void* thread2(void* arg) {
    res1 = var1 + var2;
}

int main() {
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread1, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("res1: %d\n", res1);

    return 0;
}