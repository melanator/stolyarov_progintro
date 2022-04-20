%include "stud_io.inc"
global _start

section .text
_start:     xor     eax, edx        ;edx to save +
            xor     ecx, ecx
lp:         GETCHAR             ;macro saves char in EAX
            cmp     al, -1
            je      print_loop  ;if -1 -> EOF -> quit
            cmp     al, 10      ;check EOL
            je      print_loop
            cmp     al, '0'     ;compares EAX with '0' (ASCII = 48)
            jg      bigger      ;if greater check if bigger than '9'
            jmp     lp          ;else quit
bigger:     cmp     al, '9'     ;compares with '9' (ASCII = 57)
            jg      lp          ;if bigger, quit
count:       
            sub     eax, 48     ;decrease 48 to get amount of loops
            add     ecx, eax    ;if ecx = 0, loop run infinite
            jmp     lp
print_loop: cmp     ecx, 0      ;if ecx = 0
            je      quit        ;quit  
            PRINT   '*'         ;print *      
            loop    print_loop  ;and loop back
quit:       FINISH
