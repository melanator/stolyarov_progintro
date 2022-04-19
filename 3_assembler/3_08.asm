%include "stud_io.inc"

global _start

section .text
_start:     GETCHAR             ;macro saves char in EAX
            cmp     al, '0'     ;compares EAX with '0' (ASCII = 48)
            jg      start_loop  ;if greater start loop
            jmp     quit        ;else quit
start_loop: cmp     al, '9'     ;compares with '9' (ASCII = 57)
            jnle    quit        ;if bigger, quit
            mov     ecx, eax    ;copy to ecx
            sub     ecx, 48     ;decrease 48 to get amount of loops
            cmp     ecx, 0      ;if ecx 0, infinite loop
            je      quit
            mov     al, '*'     ;copy to al for quick access
lp:         PUTCHAR al
            loop lp
quit:       FINISH