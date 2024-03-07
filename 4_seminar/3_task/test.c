#include <stdio.h>

extern void my_asm_function(); // Прототип ассемблерной функции

int main() {
    printf("Calling assembly function...\n");
    my_asm_function(); // Вызываем ассемблерную функцию
    printf("Assembly function called.\n");
    return 0;
}
