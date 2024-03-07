; print_hex.asm
section .data
newline_char: db 10
codes: db '0123456789ABCDEF'
a: db 0xaa
b: db 0xbb
c: db 0xff

section .text
global _start

print_num: 
	mov  rax, rdi
    mov  rdi, 1
    mov  rdx, 1
    mov  rcx, 8
.loop:
    push rax
    sub  rcx, 4

    sar  rax, cl
    and  rax, 0xf

    lea  rsi, [codes + rax]
    mov  rax, 1

    push rcx
    syscall
    pop  rcx

    pop rax

    test rcx, rcx
    jnz .loop

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

_start:
    mov  rdi, 0xaa
	call print_num
	call print_newline
	mov  rdi, 0xbb
	call print_num
	call print_newline
	mov  rdi, 0xff
	call print_num
	call print_newline
	call exit
