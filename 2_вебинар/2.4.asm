section .data

newline_char: db 10
codes: db '0123456789abcdef'
demo1: dq 0x1122334455667788
demo2: db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88

section .text
global _start

print_newline:
mov rax, 1 ; номер write
mov rdi, 1 ; дескриптор stdout
mov rsi, newline_char ; откуда брать данные
mov rdx, 1 ; сколько байт записать
syscall
ret

print_hex:
mov rax, rdi

mov rdi, 1
mov rdx, 1
mov rcx, 64 ; на сколько сдвинуть rax вправо

iterate:
push rax ; сохраним исходное значение rax
sub rcx, 4
sar rax, cl ; вычленим очередные 4 бита, сдвинув из вправо
			; регистр cl это младший байт rcx

and rax, 0xf ; вырежем все биты слева от младших четырех
lea rsi, [codes + rax] ; по этому адресу находится код символа для представления 4 бит

mov rax, 1

push rcx ; syscall разрушит rcx
syscall ; rax = 1 (31) -- код write, rdi = 1, stdout, rsi = адрес кода символа

pop rcx

pop rax ; сохраним исходное значение rax
test rcx, rcx; rcx = 0 когда выведены все четверки бит
jnz iterate

ret

_start:
mov rdi, [demo1]
call print_hex
call print_newline

mov rdi, [demo2]
call print_hex
call print_newline

mov rax, 60
xor rdi, rdi
syscall
