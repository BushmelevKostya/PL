nasm -felf64 print-rax.asm -o pr.o
ld -o pr pr.o
chmod u+x pr
./pr