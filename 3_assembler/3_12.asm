%include "stud_io.inc"
global _start

section .text
_start:     xor     eax, edx        ;edx to save +
            xor     ecx, ecx
lp:         GETCHAR             ;macro saves char in EAX
            cmp     al, -1
            je      quit       
            cmp     al, 10      ;check EOL
            je      print
            jmp     lp
           
print:      PRINT   'OK'
            PUTCHAR 10
            jmp     lp
quit:       FINISH