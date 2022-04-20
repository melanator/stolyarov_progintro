; INFINITE * WHEN LINE IS EMPTY

%include "stud_io.inc"
global _start

section .text
_start:     
            xor     ebx, ebx        ;ebx to store longest word
            xor     edx, edx        ;edx to count letters
            xor     ecx, ecx        ;ecx to keep if string is right
lp:         GETCHAR                 ;macro saves char in EAX
            cmp     al, 0x0a        ;or char == EOL
            je      check
            cmp     al, -1          ;or EOF
            je      check        ;set registers
            cmp     al, 40
            je      open_br
            cmp     al, 41
            je      close_br
            jmp     lp
open_br:    inc     ebx
            jmp     lp
close_br:   inc     edx
            cmp     edx, ebx
            jg      set_false
            jmp     lp
set_false:  mov     ecx, 1
            jmp     lp
check:      cmp     ebx, edx
            je      print_yes
            cmp     ecx, 0
            jne     print_yes
print_no:   PRINT   "NO"
            PUTCHAR 0x0a           ;print new line
            jmp     is_end
print_yes:  PRINT   "YES"
            PUTCHAR  0x0a           ;print new line
is_end:     xor     ebx, ebx
            xor     edx, edx        ;cleaning regs
            cmp     al, -1          ;if eof
            jne     lp              ;quit, else loop back           
quit:       FINISH