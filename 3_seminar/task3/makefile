lib.o: lib.asm
	nasm -g -felf64 -o lib.o lib.asm

main.o: main.asm lib.o
	nasm -g -felf64 -o main.o main.asm

main: lib.o main.o
	ld -o main lib.o main.o
