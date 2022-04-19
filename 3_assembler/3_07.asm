%include "stud_io.inc"

global _start

section .text
_start:     GETCHAR             ;macro saves char in EAX
            cmp     al, 'A'     ;compares EAX with 'A'
            jne     not_equal   ;if not jumps
            PRINT   "YES"
            jmp     quit        ;jumps to quit to avoid printing "NO"     
not_equal:  PRINT   "NO"
quit:       FINISH

