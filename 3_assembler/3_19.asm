;TO IMPROVE: CUT LEADING ZEROS 0000020 -> 20

%include "stud_io.inc"

global _start
section .text

_start: 
        xor ecx, ecx
l:
        GETCHAR
        cmp al, -1
        je compute
        inc ecx
        jmp l
compute:
        mov eax, ecx                ;to eax for further div
        xor ecx, ecx                ;clear ecx
        mov ebx, dividers           ;copy dividers address to ebx
lp:     cmp ecx, 10                 ;if ecx = 10
        je print_loop               ;exit loop
        xor edx, edx                ;clean edx to keep value
        div dword [ebx]             ;dividing eax / dd[ecx]
        add al, 0x30                ;add 30 to get ASCII digit
        mov [digits+ecx], al        ;storing in digits[ecx]
        mov eax, edx                ;moving remaider for further division
        inc ecx                     ;ecx++
        add ebx, 4                  ;moving *ebx to next element
        jmp lp                      ;looping back
        

print_loop:
        inc ecx
        xor eax, eax
pr_lp:  cmp ecx, 1                  ;why stop at ecx=1?
        je quit
        PUTCHAR byte [digits+eax]   ;print digits[eax]
        inc eax
        loop pr_lp
quit:   FINISH
section .data
    dividers dd 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1 
section .bss
    digits resb 10  ;array for storing digits