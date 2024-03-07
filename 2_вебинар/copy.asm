; print_hex.asm
section .data
newline_char: db 10
codes: db '0123456789ABCDEF'

section .text
global _start

print_num: 
	mov  rax, [rsp]
    mov  rcx, 8            ; Рассматриваем 8 байт (64 бита) в rax.
.loop:
    push rax               ; Сохраняем rax на стеке.
    shr  rax, 4            ; Сдвигаем младшую тетраду вправо.
    and  al, 0xF           ; Оставляем только младшую тетраду в al.

    lea  rdi, [codes + rax] ; rdi указывает на соответствующий символ в строке codes.
    mov  rax, 1            ; Системный вызов sys_write (stdout).

    mov  rdx, 1            ; Выводим только один символ.
    syscall

    pop  rax               ; Восстанавливаем rax.

    dec  rcx               ; Уменьшаем счетчик.
    jnz  .loop             ; Повторяем цикл, пока не обработаем все 8 тетрад.

    ret

    
print_newline:
mov rax, 1
mov rdi, 1
mov rsi, newline_char
mov rdx, 1
syscall
ret

exit: 
	mov  rax, 60
    xor  rdi, rdi
    syscall

f:
	push rax
;выделение места и запись значений
	sub rsp, 8
	mov byte [rsp], 0xaa

	sub rsp, 8
	mov byte [rsp], 0xbb

	sub rsp, 8
	mov byte [rsp], 0xff
	
	call print_num
	call print_newline

	add  rsp, 8 
	call print_num
	call print_newline

	add  rsp, 8 
	call print_num
	call print_newline

;освобождение памяти
	pop rax
	pop rax
	pop rax
	pop rax
	
	ret

_start:
	call f
	call exit
