section .data
%macro stringlist 3
data: db %1
db ", "
db %2
db ", "
db %3
%endmacro

stringlist "hello", "another", "world"

section .text

global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, data
	mov rdx, 21
	syscall

	xor rdi, rdi
	mov rax, 60
	syscall
