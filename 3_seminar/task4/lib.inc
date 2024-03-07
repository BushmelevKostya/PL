section .data

newline_char: db 10

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
        push rbx
		mov r8, rsp
        mov rax, rdi
        mov rbx, 10
        push 0x0
        .cyc:
                xor rdx, rdx
                div rbx
                add dl, '0'
                dec rsp
                mov byte [rsp], dl
                test rax, rax
                jnz .cyc

        .end:
                mov rdi, rsp
				push r8
                call print_string
				pop r8
                pop rbx ; pop null terminator address
                sub r8, rsp
                add rsp, r8
				pop rbx
                ret

; Выводит знаковое 8-байтовое число в десятичном формате
print_int:
	mov rax, rdi
	test rax, rax
	jns .end
	push rdi
	mov rdi, 45
	call print_char
	pop rdi
	neg rdi

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

; Принимает указатель на строку, пытается
; прочитать из её начала беззнаковое число.
; Возвращает в rax: число, rdx : его длину в символах
; rdx = 0 если число прочитать не удалось
parse_uint:
	xor rax, rax ; число
	xor rcx, rcx
	xor rdx, rdx ; длина
	.read_sym:
		mov cl, [rdi + rdx]
		test cl, cl
		jz .end
		cmp cl, '0'
		jl .bad_end
		cmp cl, '9'
		ja .bad_end

		sub cl, '0'
		mov r8, 10
		push rdx
		mul r8
		pop rdx
		add rax, rcx
		inc rdx
		jmp .read_sym

	.bad_end:
		ret
	.end:
		ret

; Принимает указатель на строку, пытается
; прочитать из её начала знаковое число.
; Если есть знак, пробелы между ним и числом не разрешены.
; Возвращает в rax: число, rdx : его длину в символах (включая знак, если он был)
; rdx = 0 если число прочитать не удалось
parse_int:
	xor rax, rax
	mov al, byte [rdi]
	cmp rax, '-'
	jz .minus
	jmp .plus

	.minus:
		inc rdi
		call parse_uint
		inc rdx
		neg rax
		ret

	.plus:
		call parse_uint
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

                cmp rcx, [rsp+8]
                jge .bad_end
                pop rbx
                mov byte[rbx+rcx], al
                inc rcx
                push rbx
                jmp .cycle

        .end:
                mov rax, rcx
                mov byte[rbx+rcx], 0
                mov rdx, 1
                pop rbx
                pop rdx
                jmp .restore_regs

        .bad_end:
                pop rbx
                pop rdx
                mov rax, 0
                mov rdx, 0
                jmp .restore_regs

        .restore_regs:
                mov rdi, 0
                mov rsi, 0
                mov rbx, 0
                mov rcx, 0
                ret

