section .data
message: db 'hello, world!', 10, 0
message1: db 'hello, world!', 0
codes: db '0123456789abcdef'
newline_char: db 10
input: db '-154581', 0
word_buf: times 20 db 0xca

arg1: db 'ashdb asdhabs dahb', 0  ; Замените на свои входные данные
arg2: times 20 db 66              ; Замените на свои входные данные

section .text
       
       ; Принимает код возврата и завершает текущий процесс
       exit:
           mov rax, rdi
           xor rdi, rdi
           syscall
       
       ; Принимает указатель на нуль-терминированную строку, возвращает её длину
       string_length:
           mov rax, rdi
           .counter:
           cmp byte [rdi], 0
           je .end
           inc rdi
           jmp .counter
           .end:
           sub rdi, rax
           mov rax, rdi
           ret
       
       ; Принимает указатель на нуль-терминированную строку, выводит её в stdout
       print_string:
       	push rdi
       	call string_length
       	pop rdi
       	mov rdx, rax
           mov rsi, rdi
           mov rax, 1
           mov rdi, 1
           syscall
       
           ret
       
       ; Принимает код символа и выводит его в stdout
       print_char:
       	push rdi
           mov rsi, rsp
           mov rax, 1
           mov rdi, 1
           mov rdx, 1
           syscall
           pop rdi
           ret
       
       ;Принимает цифру и возвращает ее код
       get_ascii:
       	mov rax, rdi
       	add rax, '0'
       	ret
       
       ; Переводит строку (выводит символ с кодом 0xA)
       print_newline:
       	mov rax, 1 ;вызов write
       	mov rdi, 1 ;вывод в stdout
       	mov rsi, newline_char ;адрес строки
       	mov rdx, 1 ;количество записываемых байт
       	syscall
       	ret
       
       ; Выводит беззнаковое 8-байтовое число в десятичном формате
       ; Совет: выделите место в стеке и храните там результаты деления
       ; Не забудьте перевести цифры в их ASCII коды.
       print_uint:
           mov rax, rdi
           xor r8, r8; счетчик записанных бит
           xor r9, r9; счетчик записанных символов
           mov rbx, 10
           .cycle:
           	xor rdx, rdx
       		div rbx
       
       		push rax
       		mov  rdi, rdx
       		call get_ascii
       		mov rdx, rax
       		pop rax
       		mov rcx, rsp
       		push rdx
       		inc r9
       		sub rcx, rsp
       		add r8, rcx
       		test rax, rax
       		jnz .cycle
       
           mov rax, 1
           mov rdi, 1
           mov rsi, rsp
           mov rdx, r8
           syscall
           .clearer:
           	pop rdx
           	dec r9
           	test r9, r9
           	jz .end
           	jmp .clearer
           .end:
          		ret
       
       ; Выводит знаковое 8-байтовое число в десятичном формате
       print_int:
       	mov rax, rdi
       	test rax, rax
       	jns .end
       
       	mov rbx, -1
       	mul rbx
       	push rax
       	mov rdi, 45
       	call print_char
       	pop rdi
       
       	.end:
       		call print_uint
       		ret
       
       
       ; Принимает два указателя на нуль-терминированные строки, возвращает 1 если они равны, 0 иначе
       string_equals:
           mov rax, rdi
           mov rdx, rsi
           xor rcx, rcx
           .cycle:
           	mov sil, byte [rax + rcx]
           	mov dil, byte [rdx + rcx]
           	test sil, sil
           	jz .almost_end
           	test dil, dil
           	jz .bad_end
       
       
       		inc rcx
           	cmp sil, dil
           	jz .cycle
       
           	jmp .bad_end
       
       		.almost_end:
       			test dil, dil
       			jz .good_end
       
       			jmp .bad_end
       
       		.good_end:
       			mov rax, 1
       			ret
       
       		.bad_end:
       			mov rax, 0
       			ret
       ; Читает один символ из stdin и возвращает его. Возвращает 0 если достигнут конец потока
       read_char:
       	push rcx
       	push rdx
       	push 0
           mov rax, 0
           mov rdi, 0
           mov rsi, rsp
           mov rdx, 1
           syscall
           pop rax
           pop rdx
           pop rcx
           ret
       
       
       ; Принимает: адрес начала буфера, размер буфера
       ; Читает в буфер слово из stdin, пропуская пробельные символы в начале, .
       ; Пробельные символы это пробел 0x20, табуляция 0x9 и перевод строки 0xA.
       ; Останавливается и возвращает 0 если слово слишком большое для буфера
       ; При успехе возвращает адрес буфера в rax, длину слова в rdx.
       ; При неудаче возвращает 0 в rax
       ; Эта функция должна дописывать к слову нуль-терминатор
       
       read_word:
       	push rbx
       	dec rsi ;место для нуль-терминатора
       	push rsi ;размер буфера
       	push rdi
       	test rsi, rsi
       	jz .end
       	xor rbx, rbx
       	mov [rdi], rbx
       
       	.cycle:
       		call read_char
       		test rax, rax
       		jz .end
       		cmp rax, 0x20
       		jz .space_symbol
       		cmp rax, 0x9
       		jz .space_symbol
       		cmp rax, 0xA
       		jz .space_symbol
       
       		cmp rbx, [rsp+8]
       		jge .bad_end
       		pop rdi
       		mov byte[rdi+rbx], al
       		inc rbx
       		mov byte[rdi+rbx], 0
       		push rdi
       		jmp .cycle
       
       	.space_symbol:
       		test rbx, rbx
       		jnz .end
       		jmp .cycle
       
       	.end:
       		mov rax, [rsp]
       		mov rdx, rbx
       		pop rsi
       		pop rdi
       		pop rbx
       		ret
       
       	.bad_end:
       		mov rax, 0
       		mov rdx, 0
       		pop rsi
       		pop rdi
       		pop rbx
       		ret
       
       getsymbol:
           mov rsi, rdi
           add rsi, rcx
           inc rcx
           xor rax, rax
           mov al, [rsi]
           ret
       
       ; Принимает указатель на строку, пытается
       ; прочитать из её начала беззнаковое число.
       ; Возвращает в rax: число, rdx : его длину в символах
       ; rdx = 0 если число прочитать не удалось
       parse_uint:
           _A:
       	mov rax, 0x0
       	mov rdx, 0x0
       	mov rcx, 0x0
       
       	push rax
       	push rdx
       	call getsymbol
       
       	cmp al, '+'
       	jz _C
       
       	cmp al, '-'
       	jz _C
       
       	cmp al, '0'
       	jl _E
       
       	cmp al, '9'
       	ja _E
       
       	.continue:
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
       
       	pop rax
       	mov rdi, rax
       	ret
       
       	_E:
       	pop rdx
       	mov rdx, 0
       	mov rdi, rdx
       
       	pop rax
       	mov rdi, rax
       
       	ret
       
       
       
       
       ; Принимает указатель на строку, пытается
       ; прочитать из её начала знаковое число.
       ; Если есть знак, пробелы между ним и числом не разрешены.
       ; Возвращает в rax: число, rdx : его длину в символах (включая знак, если он был)
       ; rdx = 0 если число прочитать не удалось
       parse_int:
           push rdi
           call getsymbol
       
       	cmp rax, '+'
       	jz .positive
       
       	cmp rax, '-'
       	jz .negative
       
           .end:
              pop rdi
              call parse_uint
              ret
       
           .positive:
              pop rdi
              call parse_uint
       	   inc rdx
              ret
       
           .negative:
              pop rdi
              call parse_uint
              test rdx, rdx
              jz .return
              neg rax
              inc rax
              inc rdx
       	.return:
              ret
       
       ; Принимает указатель на строку, указатель на буфер и длину буфера
       ; Копирует строку в буфер
       ; Возвращает длину строки если она умещается в буфер, иначе 0
       string_copy:
       	dec rdx
           push rdx; длина буфера
           mov rbx, rsi
           push rbx; указатель на буфер
           ;rdi - указатель на строку
       	test rdx, rdx
       	jz .bad_end
       	xor rcx, rcx
       
       	.cycle:
       		mov al, byte [rdi + rcx]
       		test rax, rax
       		jz .end
       
       		cmp rcx, [rsp+16]
       		jge .bad_end
       		pop rbx
       		mov byte[rbx+rcx], al
       		inc rcx
       		push rbx
       		jmp .cycle
       
       	.end:
       		mov rax, rcx
       		mov byte[rbx+rcx], 0
       		pop rbx
       		pop rdx
       		ret
       
       	.bad_end:
       		mov rax, 0
       		pop rdx
       		pop rsi
       		pop rdi
       		ret
       
       
print_rax:
	mov rax, rdi
	mov rdi, 1
	mov rdx, 1
	mov rcx, 64
	

	.loop:
	push rax
	sub rcx, 4
	sar rax, cl
	and rax, 0xf
	lea rsi, [codes + rax]
	mov rax, 1

	push rcx
	syscall
	pop rcx

	pop rax
	test rcx, rcx
	jnz .loop

	ret
	
global _start
_start:
    ;mov rdi, arg1      ; Загрузка адреса исходной строки
    ;mov rsi, arg2      ; Загрузка адреса целевой строки
    ;mov rdx, 20        ; Длина строки
    ;call string_copy   ; Вызов функции копирования

    ;mov rdi, arg2    ; Загрузка адреса буфера для вывода
    ;call print_string  ; Вызов функции вывода строки
	mov rdi, input
	call parse_int

	push rdx
	mov rdi, rax
	call print_rax
	call print_newline
	pop rdx
	mov rdi, rdx
	call print_rax
	call print_newline
	mov rdi, 60
	call exit
    ; Завершение программы
    ;mov rax, 60
    ;xor rdi, rdi
    ;syscall
