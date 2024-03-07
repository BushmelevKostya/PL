#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

pthread_mutex_t stdout_mutex;

void bad_print(char *s)
{
    pthread_mutex_lock(&stdout_mutex);
    for (; *s != '\0'; s++)
    {
        fprintf(stdout, "%c", *s);
        fflush(stdout);
        usleep(100);
    }
    pthread_mutex_unlock(&stdout_mutex);
}

void* my_thread(void* arg)
{
    for (int i = 0; i < 10; i++)
    {
        bad_print((char *)arg);
        sleep(1);
    }
    return NULL;
}

int main()
{
    pthread_mutex_init(&stdout_mutex, NULL);
    pthread_t t1, t2;
    pthread_create(&t1, NULL, my_thread, "Hello\n");
    pthread_create(&t2, NULL, my_thread, "world\n");

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    pthread_mutex_destroy(&stdout_mutex);

    return 0;
}
