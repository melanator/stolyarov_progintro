; INFINITE * WHEN LINE IS EMPTY

%include "stud_io.inc"
global _start

section .text
_start:     
            xor     ebx, ebx        ;ebx to store longest word
            xor     edx, edx        ;edx to count letters
lp:         GETCHAR                 ;macro saves char in EAX
            cmp     al, 0x20        ;if char == " "
            je      word_end
            cmp     al, 0x0a        ;or char == EOL
            je      word_end
            cmp     al, -1          ;or EOF
            je      word_end        ;set registers
            inc     edx             ;if not edx++
            jmp     lp              ;loop back to read
word_end:
            cmp     edx, ebx        ;if edx > ebx
            jg      set_count       ;update edx
            jmp     check_end       ;back to reading chars

set_count:
            mov     ebx, edx        ;ebx = edx
            jmp     check_end       ;check if EOF/EOL
            
clear:      xor     edx, edx        ;edx = 0
            jmp     lp              ;back to reading chars


check_end:  cmp     al, -1          ;if  EOF
            je      prep_loop       
            cmp     al, 0x0a        ;or EOL
            je      prep_loop       ;print stars
            jmp     clear           ;loop back
prep_loop:  mov ecx, ebx            ;set counter = ebx

print_loop: PRINT   "*"
            loop    print_loop
            PUTCHAR 0x20            ;print space
            mov     ecx, edx        ;ecx = edx
print_lp2:  PRINT   "*"
            loop    print_lp2
            PUTCHAR  0x0a           ;print new line
            xor     edx, edx
            xor     ebx, ebx
            cmp     al, -1          ;if eof
            jne     lp              ;quit, else loop back           
quit:       FINISH