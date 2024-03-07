/* fork-example-1.c */

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <string.h>
#include <unistd.h>

void* create_shared_memory(size_t size) {
    return mmap(NULL,
                size,
                PROT_READ | PROT_WRITE,
                MAP_SHARED | MAP_ANONYMOUS,
                -1, 0);
}


int main() {
    int* shmem = create_shared_memory(10 * sizeof(int));

    printf("Shared memory at: %p\n" , shmem);
    int pid = fork();

    if (pid == 0) {
        int index, value;
        printf("Please enter index and value: ");
        scanf("%d %d", &index, &value);

        if (index >=0 && index <= 10) {
            shmem[index] = value;
        }

        exit(0);
    } else {
        wait(NULL);

        for(size_t i = 0; i < 10; i++) {
            printf("%d\n", shmem[i]);
        }
    }
    munmap(shmem, 10 * sizeof(int));
    return 0;
}