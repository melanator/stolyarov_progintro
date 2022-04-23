%include "stud_io.inc"

global _start
section .text

_start:     
            mov     [zero_flag], byte 0          ;clean flag
            xor     ecx, ecx                ;ecx to store value
            xor     edx, edx                ;tmp value storer
            xor     eax, eax
            mov     [digit], dword 0        ;clean digit for second digit
            ; instead of looping, copy this procedure twise        
first_digit:
            GETCHAR
            cmp     al, 0x20                ;if space
            je      error                   ;
            cmp     al, -1                  ;if F
            je      quit                    ;just quit
            cmp     al, 0x0a                ;
            je      error                   ;

            cmp     al, "+"                 ;retrieving command
            je      write_1st 
            cmp     al, "-"
            je      write_1st
            cmp     al, "*"
            je      write_1st
            cmp     al, "/"
            je      write_1st

            cmp     al, 0x30                ;if '0'
            jl      error                   ;less -> print
            cmp     al, 0x39                ;if '9'
            jg      error                   ;greater -> print

            sub     al, 0x30                ;deduct 30 to get value
            mov     ebx, eax                ;copy al to bh to keep char value           
            mov     eax, [digit]            ;copy ecx to eax to multiply
            mul dword    [multiplier]       ; *10
            add     eax, ebx                ;adding eax with ebx
            mov     [digit], eax            ;and moving to counter
            jmp     first_digit


write_1st:  mov     [command], al           ;saving command
            mov     eax, [digit]
            mov     [operands], eax         ;copy to digit

            xor     ecx, ecx                ;ecx to store value
            xor     edx, edx                ;tmp value storer
            xor     eax, eax
            mov     [digit], dword 0        ;clean digit for second digit
second_digit:
            GETCHAR
            cmp     al, 0x20                ;if space
            je      error                   ;error
            cmp     al, -1                  ;if EOF
            je      write_2nd               ;save 2nd
            cmp     al, 0x0a                ;if EOL
            je      write_2nd               ;save 2nd

            cmp     al, 0x30                ;if '0'
            jl      error                   ;less -> print
            cmp     al, 0x39                ;if '9'
            jg      error                   ;greater -> print

            sub     al, 0x30                ;deduct 30 to get value
            mov     ebx, eax                ;copy al to bh to keep char value           
            mov     eax, [digit]            ;copy ecx to eax to multiply
            mul     dword [multiplier]      ; *10
            add     eax, ebx                ;adding eax with ebx
            mov     [digit], eax            ;and moving to counter
            jmp     second_digit

write_2nd:  
            mov     eax, [digit]
            mov     [operands+4], eax       ;copy to operands[1]

compute:    mov     eax, [operands]         ;first to eax
            mov     ebx, [operands+4]       ;second to ebx
            cmp     [command], byte "-"
            je      subtract
            cmp     [command], byte "+"
            je      addition
            cmp     [command], byte "*"
            je      multiply
            cmp     [command], byte "/"
            je      division

subtract:   sub     eax, ebx            
            jmp     print_res
addition:   add     eax, ebx
            jmp     print_res
multiply:   mul     ebx
            jmp     print_res
division:   div     ebx
            jmp     print_res

error:      
            cmp     al, 0x0a                ;if new line
            je      reset_error             ;clean flag
            cmp     [error_flag], byte 0    ;if error flag is not empty
            jne     _start                  ;restart
            PRINT   "ERROR"                 ;printing error
            PUTCHAR  0x0a                   ;new line
            mov     [error_flag], byte 1    ;setting to 1
            jmp _start                      ;restarting

reset_error:                                ;clean error flag if new line pressed
            mov     [error_flag], byte 0
            jmp     _start

print_res:  
            xor     ecx, ecx                ;clear ecx
            mov     ebx, dividers           ;copy dividers address to ebx
lpd:        cmp     ecx, 10                 ;if ecx = 10
            je      print_loop               ;exit loop
            xor        edx, edx             ;clean edx to keep value
            div     dword [dividers+ecx*4]  ;dividing eax / dd[ecx]
            add     al, 0x30                ;add 30 to get ASCII digit
            mov     [digits+ecx], al        ;storing in digits[ecx]
            mov     eax, edx                ;moving remaider for further division
            inc     ecx                     ;ecx++
            add     ebx, 4                  ;moving *ebx to next element
            jmp     lpd                     ;looping back

print_loop:
            inc     ecx
            xor     eax, eax
pr_lp:      cmp     ecx, 1                  ;why stop at ecx=1?
            je      new_line
            cmp     byte [digits+eax], 0x30 ;if 0
            jne     zero_flag_on            ;false: put flag on
            je      avoid_zeros             ;true:  avoid printing 0
back_:      PUTCHAR byte [digits+eax]       ;print digits[eax]
back2_:     inc eax
            loop pr_lp

zero_flag_on:
            mov     [zero_flag], byte 1     ;flag on
            jmp     back_                   ;back to print char

avoid_zeros:
            cmp     [zero_flag], byte 1     ;if flag was on
            je      back_                   ;back to print char
            jmp     back2_                  ;else do end of 
new_line:   PUTCHAR 0x0a
            jmp _start
quit:       FINISH

section .bss
            operands  resd 2
            digit   resd 1
            result  resd 1  
            command resb 1  ;reserving command
            digits resb 10  ;array for storing digits
section .data 
            error_flag  db 0    ;flag to print only one error
            zero_flag   db 0    ;flag to check if zeroes were at beginning
            multiplier  dd 10
            dividers    dd 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1 