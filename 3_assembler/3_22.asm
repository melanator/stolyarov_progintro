%include "stud_io.inc"

global _start
section .text
_start: GETCHAR
        cmp     al, -1
        je      end_loop
        push    eax
        inc     ecx
        jmp     _start
end_loop:
        pop     eax
        PUTCHAR al
        loop    end_loop
        PUTCHAR 0x0a
        FINISH