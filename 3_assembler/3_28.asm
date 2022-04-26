%include "stud_io.inc"

%macro ARRAY_FILL 3
    %assign i %1
    %assign j %2
    %rep %3 
        dd i 
        %assign i i+j
    %endrep
%endmacro

global _start
section .text:
;print elements of array to check
_start: cmp     ecx, 10
        je      .quit
        mov     al, [array+ecx*4]
        add     al, 0x30
        PUTCHAR al
        PUTCHAR 0x20
        inc     ecx
        jmp     _start
.quit:  PUTCHAR 0x0a
        FINISH
        

section .data:
array:  ARRAY_FILL 1, 1, 10