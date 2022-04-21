%include "stud_io.inc"

global _start
section .text

_start: 
        GETCHAR
        cmp al, -1
        je print_count
        inc ecx
        jmp _start
print_count:
        FINISH
section .bss
    letters resb 10         ;array of bytes to store letters