%include "stud_io.inc"

global _start
section .text
_start:         mov     eax, 0312303123
                mov     ecx, test_chars
                call    num_char
                mov     eax, test_chars
                call    write
                xor     ecx, ecx
                PRINT   0x0a
.lp:            cmp     [test_chars+ecx], byte 0
                je      quit
                mov     al, [test_chars+ecx]
                PUTCHAR al
                inc     ecx
                jmp     .lp
quit:           PUTCHAR 0x0a
                FINISH

parse_number:   mov     ebx, eax            ;copy str* to ebx
                xor     eax, eax            ;clean eax for further computing
                xor     edx, edx            ;clean edx
.loop:          mov     eax, [ebx+edx]      ;copy to edx
                cmp     eax, 0x30           ;error if less of greater
                jl      .error              ;if less or greater
                cmp     eax, 0x39           ;greater
                jg      .error
                sub     eax, 0x30
                mov     dword [adder], eax
                mov     eax, dword [digit]  ;copy ecx to eax to multiply
                mul dword    [multiplier]   ; *10
                add     eax, dword [adder]  ;adding eax with ebx
                mov     [digit], eax        ;and moving to counter
                inc     edx
                loop    .loop               ;looping back
                mov     eax, [digit]        ;move digit
                mov     dword [digit], 0    ;clean digit
                ret
.error:         mov     ecx, 1

;num_char(eax=number, ecx=char*)
num_char:       xor     ebx, ebx
.loop:          cmp     eax, 0              ;if ecx = 10
                je      .is_end             ;exit loop
.back:          xor     edx, edx            ;clean edx to keep value
                div     dword [dividers+ebx*4]    ;dividing eax / dd[ecx]
                cmp     eax, 0
                je      .avoid
                jmp     .set_flag
.after_flag:    add     al, 0x30            ;add 30 to get ASCII digit
                mov     [ecx], al           ;storing in digits[ecx]
                inc     ecx                 ;ecx++
.avoid_write:   inc     ebx
                mov     eax, edx            ;moving remaider for further division
                jmp     .loop            ;looping back
.is_end:        cmp     edx, 0
                jne     .back
                mov     [ecx], byte 0
                ret
.avoid          cmp     [zero_flag], byte 0
                je      .avoid_write
                jmp     .after_flag
.set_flag       mov     [zero_flag], byte 1
                jmp     .after_flag

;write(eax=char*)
write:          cmp     [eax], byte 0
                je     .return
                PUTCHAR [eax]
                inc     eax
                loop    write
.return:        ret

;read(ebx=char*, edx=size) ecx=size, eax=wrong letter
read:           
                xor     ecx, ecx
.loop           GETCHAR
                cmp     ecx, edx
                je      .overwrite
                cmp     al, 0x20            ;if space
                je      .end
                cmp     al, -1              ;or EOF
                je      .end
                cmp     al, 0x0a            ;of EOL
                je      .end                ;go save digit
                cmp     al, 0x30            ;if '0'
                jl      .error               ;less -> print
                cmp     al, 0x39            ;if '9'
                jg      .error               ;greater -> print
                mov     [ebx+ecx], byte al
                inc     ecx
                jmp     .loop                  ;looping back
.end:           ret     ;return from .end, counter already in ecx
.error:         ret     ;return from error, letter already in eax
.overwrite:     mov     eax, dword -1
                ret 




section .bss    
            test_chars resb 20
            pointer resd 1
section .data 
            zero_flag   db 0    ;flag to check if zeroes were at beginning
            multiplier dd 10
            counter dd  0
            dividers dd 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1
            digit   dd  0
            adder   dd  0
