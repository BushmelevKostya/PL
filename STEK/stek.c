/* bad.c */

#include <inttypes.h>
#include <malloc.h>
#include <stdio.h>

int main() {
    int64_t *array = malloc(sizeof(int64_t) * 5);
    size_t capacity = 5;

    size_t count = 0;

    for (size_t i = 0; i <= 100; i++) {
        if (count == capacity) {
            array = realloc(array, sizeof(int64_t) * capacity * 2);
            capacity = capacity * 2;
        }
        array[count++] = i * i;
    }

    for (size_t i = 0; i < 100; i++) {
        printf("%" PRId64 " ", array[i]);
    }
    return 0;
}