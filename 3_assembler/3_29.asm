%include "stud_io.inc"


%macro JUMP_TO_LABEL 1-*
    %assign n 1
    %rep %0
        cmp eax, n
        je %1
        %rotate 1
        %assign n n+1
    %endrep
%endmacro

global _start
section .text
_start: mov eax, 3
        JUMP_TO_LABEL .first, .second, .third, .fourth
        jmp .quit
        
.first: PUTCHAR 0x31
        jmp .quit
.second: PUTCHAR 0x32
        jmp .quit
.third: PUTCHAR 0x33
        jmp .quit
.fourth: PUTCHAR 0x34
        jmp .quit
        
.quit:  PUTCHAR 0x0a
        FINISH