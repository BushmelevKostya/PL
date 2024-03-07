/* pipe-example.c */

#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stdint.h>
#include <semaphore.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>

void *create_shared_memory(size_t size) {
    return mmap(NULL,
                size,
                PROT_READ | PROT_WRITE,
                MAP_SHARED | MAP_ANONYMOUS,
                -1, 0);
}

int main() {
    volatile int *shared_memory = create_shared_memory(10 * sizeof(int));
    sem_t *sem_end = (sem_t *) shared_memory;
    sem_t *sem_string = sem_end + 1;
    sem_t *sem_done = sem_string + 1;
    char *str = (char *) (sem_done + 1);

    sem_init(sem_end, 1, 0);
    sem_init(sem_string, 1, 0);
    sem_init(sem_done, 1, 0);

    pid_t pid = fork();
    if (pid == 0) {
        for (;;) {
            if (fgets(str, 128, stdin) == NULL) return 0;
            if (strlen(str) <= 1) break;

            sem_post(sem_string);
            sem_wait(sem_done);
        }
        sem_post(sem_end);
        sem_post(sem_string);

        exit(0);
    }
    while(1) {
        sem_wait(sem_string);
        if(sem_trywait(sem_end) == 0) {
            printf("Parent: received end\n");
            break;
        }

        printf("Parent: received string: %s\n", str);
        sem_post(sem_done);
    }
    waitpid(pid, NULL, 0);

    sem_destroy(sem_end);
    sem_destroy(sem_done);
    sem_destroy(sem_string);
    munmap(shared_memory, 10 * sizeof(int));
    return 0;
}