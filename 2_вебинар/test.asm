section .data
string: db '567', '0'

section .text
global _start
_start:
	mov rdx, string
	mov al, [string]

	mov rax, 60
	xor rdi, rdi
	syscall
