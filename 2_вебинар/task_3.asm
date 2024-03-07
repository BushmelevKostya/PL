; print_hex.asm
section .data
newline_char: db 10
codes: db '0123456789ABCDEF'

section .text
global _start

print_num:
    mov  rax, rdi
    mov  rdi, 1
    mov  rdx, 1
    mov  rcx, 64
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
	push 0xff
	push 0xbb
	push 0xaa
	mov rdi, [rsp+16]
	call print_num

	mov rdi, [rsp+8]
	call print_num

	mov rdi, [rsp]
	call print_num

	add rsp, 24
	
    ret

_start:
        call f
        call exit
