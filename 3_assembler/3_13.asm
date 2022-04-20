%include "stud_io.inc"
global _start

section .text
_start:     
            xor     ecx, ecx
lp:         GETCHAR                 ;macro saves char in EAX
            cmp     al, -1
            je      check_ecx      
            cmp     al, 10          ;check EOL
            je      check_ecx
            inc     ecx
            jmp     lp
check_ecx:  cmp     al, -1          ;if EOL
            je      quit            ;quit
            cmp     ecx, 0          ;if ecx is zero
            je      new_line        ;jump to print \n
print_loop: 
            PRINT   '*'
            loop    print_loop
            xor     ecx, ecx
new_line:   PUTCHAR 10              ;print \n
            jmp     lp          

quit:       FINISH