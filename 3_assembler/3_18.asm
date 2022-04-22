%include "stud_io.inc"

global _start
section .text

_start:     xor     ecx, ecx    ;ecx to store value
            xor     edx, edx    ;tmp value storer
            xor     eax, eax
lp:         
            GETCHAR
            cmp     al, 0x30    ;if '0'
            jl      print_digit ;less -> print
            cmp     al, 0x39    ;if '9'
            jg      print_digit ;greater -> print
            sub     al, 0x30    ;deduct 30 to get value
            mov     ebx, eax    ;copy al to bh to keep char value           
            mov     eax, [digit]    ;copy ecx to eax to multiply
            mul dword    [multiplier]  ; *10
            add     eax, ebx    ;adding eax with ebx
            mov     [digit], eax    ;and moving to counter
            jmp     lp          ;looping back

print_digit:
            mov     ecx, [digit]
            cmp     ecx, 0
            je      print_zero
print_loop: PRINT   "*"
            loop    print_loop
print_zero: PRINT   ""
            PUTCHAR 0x0a
            FINISH        

section .bss
            digit   resd 1
section .data 
            multiplier dw 10