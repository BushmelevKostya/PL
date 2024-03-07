#1 лаба по ЯПам
nasmFlags = -g -felf64 -o
#Вызов исполняемых файлов всех тестов, очистка временных файлов
.PHONY: all
all: parse_int parse_uint print_char print_int print_string print_uint read_char read_word read_word_length read_word_too_long string_copy string_copy_too_long string_equals string_length string_not_equals clean

.PHONY: clean
clean:
	rm *.o

#сборка lib.asm
%.o: %.asm
	nasm $(nasmFlags) $@ $<

#препроцессинг и компилция тестов к каждой функции
%.o: %.asm lib.o
	nasm $(nasmFlags) $@ $<

#компоновка тестов к каждой функции
%: lib.o %.o
	ld -o $@ $?
