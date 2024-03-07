section .data
test: dq -1

section .text

_start:

mov byte[test], 1
mov word[test], 1
mov dword[test], 1
mov qword[test], 1

mov rax, 60
xor rdi, rdi
syscall
