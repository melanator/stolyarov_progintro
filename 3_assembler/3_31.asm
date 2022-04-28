%include "stud_io.inc"

%macro FILL_ARRAY 2
    %if %2 = 4
        %define size dd
    %endif
    %if %2 = 2
        %define size dw
    %endif
    %if %2 = 8
        %define size dq
    %endif
    %strlen sl %1
    %assign n 1
    %rep sl
        %substr char %1 n
        size char,
        %assign n n+1
    %endrep
%endmacro



global _start
section .text
_start:     mov     ecx, loops
.lp:        mov     eax, [array+ebx*8]
            PUTCHAR al
            inc     ebx
            loop    .lp
            FINISH

section .data:
    array FILL_ARRAY '1234', 8