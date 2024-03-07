;task_4.asm
section .data
    ok_msg:   db "Okay", 10, 0
    fail_msg: db "Fail", 10, 0
    input: db '567', 0
	codes: db '0123456789ABCDEF'
	nums: db '0123456789'
	newline_char: db 10
section .text

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

    ret

getsymbol:
    mov rsi, rdi
    add rsi, rcx
    inc rcx
    mov al, [rsi]
    ret

print_string:
    mov  rdx, rsi
    mov  rsi, rdi
    mov  rax, 1
    mov  rdi, 1
    syscall
    ret

exit:
    mov  rax, 60
    xor  rdi, rdi
    syscall

print_newline:
	mov rax, 1
	mov rdi, 1
	mov rsi, newline_char
	mov rdx, 1
	syscall
	ret

global _start
_start:
	mov rdi, input 
	call print_uint
	call exit

	print_uint:
        _A:
                mov rax, 0x0
                mov rdx, 0x0
                mov rcx, 0x0

                push rax
                push rdx
                call getsymbol
                
                cmp al, ' '
                jz _A

                cmp al, '+'
                jz _B

                cmp al, '-'
                jz _B

                cmp al, '0'
                jl _E

                cmp al, '9'
                ja _E

				mov r8, rax
				sub r8, '0'
				pop rdx
				pop rax
				add rax, rax
				add rax, rax
				add rax, rax
				add rax, rax
				add rax, r8
				inc rdx
				push rax
				push rdx

                jmp _C

        _B:
                call getsymbol
                cmp al, '0'
                jl _E

                cmp al, '9'
                ja _E

				mov r8, rax
				sub r8, '0'
				pop rdx
				pop rax
				add rax, rax
				add rax, rax
				add rax, rax
				add rax, rax
				add rax, r8
				inc rdx
				push rax
				push rdx

                jmp _C

        _C:
                call getsymbol
                test al, al
                jz _D

                cmp al, 10
                jz _D

                cmp al, '0'
                jl _E

                cmp al, '9'
                ja _E

				mov r8, rax
				sub r8, '0'
				pop rdx
				pop rax
				add rax, rax
				add rax, rax
				add rax, rax
				add rax, rax
				add rax, r8
				inc rdx
				push rax
				push rdx

                jmp _C

        _D:
                pop rdx
                mov rdi, rdx
                call print_num
                call print_newline

                pop rax
				mov rdi, rax
				call print_num
				call print_newline
                ret

        _E:
                pop rdx
                mov rdx, 0
                mov rdi, rdx
                call print_num
                call print_newline

                pop rax
                mov rdi, rax
                call print_num
                call print_newline
                
                ret
