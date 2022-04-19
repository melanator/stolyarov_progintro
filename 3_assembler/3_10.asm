%include "stud_io.inc"
global _start

section .text
_start:     xor edx, edx        ;edx to save +
            xor ebx, ebx        ;ebx to save -
            xor ecx, ecx
            xor eax, eax
lp:         GETCHAR             ;macro saves char in EAX
            cmp al, -1
            je compute          ;if -1 -> EOF -> quit
            cmp al, 10          ;check EOL
            je compute
            cmp al, '-'
            je  add_minus       ;if - inc ebx
            cmp al, '+'
            je  add_plus        ;if + inc edx
            jmp lp
add_minus:  inc ebx
            jmp lp
add_plus:   inc edx
            jmp lp
compute:       
            mov eax, ebx
            mul edx               ;sum
            mov ecx, eax          ;copy result to counter
            cmp ecx, 0            ;if ecx = 0, loop run infinite
            je  quit
print_loop: PRINT '*'           ;print *      
            loop print_loop     ;and loop back
quit:       FINISH
