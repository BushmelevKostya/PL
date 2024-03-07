; hello_mmap.asm
%define O_RDONLY 0 ;open file
%define PROT_READ 0x1 ;call mmap
%define MAP_PRIVATE 0x2 ;call mmap
%define SYS_WRITE 1 ;print_string
%define SYS_OPEN 2 ;open file
%define SYS_MMAP 9 ;call mmap
%define SYS_MUNMAP 11 ; call munmap
%define SYS_CLOSE 3 ;call close
%define SYS_EXIT 60 ;exit
%define FD_STDOUT 1 ;print_string
%define SYS_STAT 5

section .data
    ; This is the file name. You are free to change it.
    fname: db 'hello.txt', 0

section .text
global _start

; use exit system call to shut down correctly
exit:
    mov  rax, SYS_EXIT
    xor  rdi, rdi
    syscall

; These functions are used to print a null terminated string
; rdi holds a string pointer
print_string:
    push rdi
    call string_length
    pop  rsi
    mov  rdx, rax 
    mov  rax, SYS_WRITE
    mov  rdi, FD_STDOUT
    syscall
    ret

string_length:
    xor  rax, rax
.loop:
    cmp  byte [rdi+rax], 0
    je   .end 
    inc  rax
    jmp .loop 
.end:
    ret

; This function is used to print a substring with given length
; rdi holds a string pointer
; rsi holds a substring length
print_substring:
    mov  rdx, rsi 
    mov  rsi, rdi
    mov  rax, SYS_WRITE
    mov  rdi, FD_STDOUT
    syscall
    ret

_start:
	;выделение памяти под переменные
	sub rsp, 16
	;выделение памяти под буфер в стеке
	sub rsp, 144
    ; Вызовите open и откройте fname в режиме read only.
    mov  rax, SYS_OPEN
    mov  rdi, fname
    mov  rsi, O_RDONLY    ; Open file read only
    mov  rdx, 0 	      ; We are not creating a file
                          ; so this argument has no meaning
    syscall
    ; rax holds the opened file descriptor now
    mov [rsp + 144 + 8], rax ;сохраняем дескриптор
  	;вызываем fstat
	mov rdi, rax
	mov rsi, rsp
	mov rax, SYS_STAT
	syscall
	; Вызовите mmap c правильными аргументами
    ; Дайте операционной системе самой выбрать, куда отобразить файл
    ; Размер области возьмите в размер страницы 
    ; Область не должна быть общей для нескольких процессов 
    ; и должна выделяться только для чтения.
	xor rdi, rdi ;NULL чтобы дать ОС самой выбрать адрес
	mov rsi, [rsp + 48] ;размер файла
	mov rdx, PROT_READ ;только для чтения
	mov r10, MAP_PRIVATE ;только для одного процесса
	mov r8, [rsp + 144 + 8];дескриптор прочитанного файла
	mov r9, 0 ;offset относительно начала файла
	mov rax, SYS_MMAP
	syscall
	; вернулся указатель на строку
    ; с помощью print_substring теперь можно вывести его содержимое
    mov [rsp + 144], rax ;сохраняем указатель на начало области памяти
	mov rdi, rax
	mov rsi, [rsp + 48]
	call print_substring
    ; теперь можно освободить память с помощью munmap
    pop rdi
    mov rsi, [rsp + 48]
	mov rax, SYS_MUNMAP
	syscall
    ; закрыть файл используя close
    pop rdi
	mov rax, SYS_CLOSE
	syscall
    ; и выйти
    add rsp, 144
    add rsp, 16
    call exit
