# script to fast compile asm and run
nasm -f elf $1.asm -o $1.o && ld -m elf_i386 $1.o -o $1 