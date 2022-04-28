%include "stud_io.inc"

%macro FILL_ARRAY 1
    %strlen sl %1
    %assign n 1
    %rep sl
        %substr char %1 n
        dd char,
        %assign n n+1
    %endrep
%endmacro

%define  loops 4

global _start
section .text
_start:     mov     ecx, loops
.lp:        mov     eax, [array+ebx*4]
            PUTCHAR al
            add     ebx, 1
            loop    .lp
            FINISH

section .data:
    array FILL_ARRAY '1234'