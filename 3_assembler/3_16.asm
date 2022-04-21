%include "stud_io.inc"
global _start

section .text
_start:     
            xor     ecx, ecx        ;ecx to words
lp:         GETCHAR                 ;macro saves char in EAX
            cmp     al, 0x0a        ;or char == EOL
            je      print_loop
            cmp     al, -1          ;or EOF
            je      print_loop
            cmp     al, 0x20        ;if space
            je      add_word        ;ecx++
            jmp     lp              ;loop back
add_word:   inc     ecx
            jmp     lp
print_loop: cmp     ecx, 0          ;if ecx=0
            je      line_end        ;jump to line end
            PRINT   "*"             ;print star
            loop    print_loop      ;loop back
            PUTCHAR 0x0a            ;print new line
line_end:   xor     ecx, ecx        ;cleaning ecx for new lines
            cmp     al, -1          ;if eof
            jne     lp              ;NOT loop back           
quit:       FINISH                  ;quit