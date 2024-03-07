nasmFlags = -g -felf64 -o

.PHONY: all
all: main clean

.PHONY: clean
clean:
	rm *.o

%.o: %.asm
	nasm $(nasmFlags) $@ $<

main.o: main.asm lib.o
	nasm $(nasmFlags) main.o main.asm

main: lib.o main.o
	ld -o main $?
