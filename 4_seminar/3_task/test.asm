section .data
hello db "Hello from assembly!", 0

section .text
global my_asm_function

my_asm_function:
    ; Выводим строку на стандартный вывод (stdout)
    mov rax, 0x1            ; Системный вызов для записи (write)
    mov rdi, 0x1            ; Файловый дескриптор stdout
    lea rsi, [rel hello]          ; Указатель на строку
    mov rdx, 19             ; Длина строки
    syscall

    ret
