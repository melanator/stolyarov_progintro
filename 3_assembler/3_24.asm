%include "stud_io.inc"

global _start
section .text
_start:    

parse_number:   mov     ebx, eax            ;copy str* to ebx
                xor     eax, eax            ;clean eax for further computing
                xor     edx, edx            ;clean edx
.loop:          mov     eax, [ebx+edx]      ;copy to edx
                cmp     eax, 0x30           ;error if less of greater
                jl      .error              ;if less or greater
                cmp     eax, 0x39           ;greater
                jg      .error
                sub     eax, 0x30
                mov     dword [adder], eax
                mov     eax, dword [digit]  ;copy ecx to eax to multiply
                mul dword    [multiplier]   ; *10
                add     eax, dword [adder]  ;adding eax with ebx
                mov     [digit], eax        ;and moving to counter
                inc     edx
                loop    .loop               ;looping back
                mov     eax, [digit]        ;move digit
                mov     dword [digit], 0    ;clean digit
                ret
.error:         mov     ecx, 1


section .bss    
            digit resd 1
section .data 
            zero_flag   db 0    ;flag to check if zeroes were at beginning
            multiplier dd 10
            counter dd  0
            dividers dd 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1
            digit   dd  0
            adder   dd  0