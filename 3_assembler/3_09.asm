%include "stud_io.inc"

global _start

section .text
_start:     
lp:         GETCHAR             ;macro saves char in EAX
            cmp al, -1
            je quit             ;if -1 -> EOF -> quit
            PUTCHAR al          ;else print char
            jmp lp              ;and loop back
quit:       FINISH