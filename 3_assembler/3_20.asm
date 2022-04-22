%include "stud_io.inc"
global _start
section .text

_start:     xor     ecx, ecx            ;ecx to store value
            xor     edx, edx            ;tmp value storer
            xor     eax, eax
            mov     [digit], dword 0    ;clean digit for second digit
lp:         
            GETCHAR
            cmp     al, 0x20            ;if space
            je      write_digit
            cmp     al, -1              ;or EOF
            je      write_digit
            cmp     al, 0x0a            ;of EOL
            je      write_digit         ;go save digit
            cmp     al, 0x30            ;if '0'
            jl      error               ;less -> print
            cmp     al, 0x39            ;if '9'
            jg      error               ;greater -> print
            sub     al, 0x30            ;deduct 30 to get value
            mov     ebx, eax            ;copy al to bh to keep char value           
            mov     eax, [digit]        ;copy ecx to eax to multiply
            mul dword    [multiplier]   ; *10
            add     eax, ebx            ;adding eax with ebx
            mov     [digit], eax        ;and moving to counter
            jmp     lp                  ;looping back

write_digit:
            mov     ecx, [counter]      
            mov     eax, [digit]
            mov     [values+ecx*4], eax ;copy to digit
            inc     ecx                 ;ecx++
            cmp     ecx, 2              ;we need only 2 cycles
            je      compute             ;compute digit
            mov     [counter], ecx      ;refresh conter
            jmp     _start              ;if less 2, new cycle
            
compute:    mov     eax, [values]       ; just summing
            add     eax, [values+4]
            mov     [result], eax   
            jmp     print_res       

error:      PRINT "ERROR"
            jmp quit

print_res:  
            mov eax, [result]           ;to eax for further div
            xor ecx, ecx                ;clear ecx
            mov ebx, dividers           ;copy dividers address to ebx
lpd:        cmp ecx, 10                 ;if ecx = 10
            je print_loop               ;exit loop
            xor edx, edx                ;clean edx to keep value
            div dword [dividers+ecx*4]  ;dividing eax / dd[ecx]
            add al, 0x30                ;add 30 to get ASCII digit
            mov [digits+ecx], al        ;storing in digits[ecx]
            mov eax, edx                ;moving remaider for further division
            inc ecx                     ;ecx++
            add ebx, 4                  ;moving *ebx to next element
            jmp lpd                     ;looping back
        

print_loop:
            inc ecx
            xor eax, eax
pr_lp:      cmp ecx, 1                  ;why stop at ecx=1?
            je quit
            PUTCHAR byte [digits+eax]   ;print digits[eax]
            inc eax
            loop pr_lp
quit:       FINISH


section .bss
            values  resd 2
            digit   resd 1
            result  resd 1
            digits resb 10  ;array for storing digits
section .data 
            multiplier dd 10
            counter dd  0
            dividers dd 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1 