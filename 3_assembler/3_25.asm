%include "stud_io.inc"

global _start
section .text
_start:
                push    dword 10            ;push seconf arg to stack
                push    digits_chars        ;push first arg to stack
                call    read                ;read
                add     esp, 8              ;cleaning arguments
                push    ecx                 ;push secong ard to stack
                push    digits_chars        ;push argv[1] to stack
                call    parse_number        ;call
                add     esp, 8              ;clean stack
                mov     [digits_values], eax ;save result to variable
                ;second digit
                push    dword 10            ;push seconf arg to stack
                push    digits_chars+10     ;push first arg to stack
                call    read                ;read
                add     esp, 8              
                push    ecx                 ;push argv[2]
                push    digits_chars+10     ;push argv[1]
                call    parse_number        ;call
                add     esp, 8              ;clean
                mov     [digits_values+4], eax
                ; sum
                add     eax, dword [digits_values]  ;summing
                push    result_chars        ;push argv[2]
                push    eax                 ;push argv[1]
                call    num_char            ;call
                add     esp, 4              ;result_chars from last function keeped
                call    write               ;call
quit:           PUTCHAR 0x0a                ;print new_line
                FINISH                      ;finish
                
;parse_number([ebp+8]=char*, [ebp+12]=size): eax=value
parse_number:   push    ebp                 ;organizing stack
                mov     ebp, esp            
                mov     ecx, [ebp+12]       ;copy argv[2] to counter
                push    0                   ;local variable for storing ebp-4
                push    0                   ;local for storing adder ebp-8
.loop:          mov     al, [ebx]           ;copy to ebx
                cmp     eax, 0x30           ;error if less of greater
                jl      .error              ;if less or greater
                cmp     eax, 0x39           ;error
                jg      .error              
                sub     eax, 0x30           ;subtract 30 to get digit
                mov     dword [ebp-8], eax  ;copy digit
                mov     eax, dword [ebp-4]  ;copy to eax to multiply
                mul dword    [multiplier]   ; *10
                add     eax, dword [ebp-8]  ;adding eax with ebx
                mov     [ebp-4], eax        ;and moving to counter
                inc     ebx                 ;ebx ++
                loop    .loop               ;looping back
                mov     eax, [ebp-4]        ;move digit
                mov     dword [ebp-4], 0    ;clean digit
.return:        add     esp, 8              ;cleaning local vars
                pop     ebx
                ret
.error:         mov     ecx, 1
                PRINT   "ERROR"
                jmp     .return

;num_char([ebp+8]=number, [ebp+12]=char*)
num_char:       push    ebp                 ;stack
                mov     ebp, esp            ;stack
                push    0                   ;zero_flag      
                xor     ebx, ebx            ;clean ebx
                mov     ecx, [ebp+12]       ;mov char* to ecx
                mov     eax, [ebp+8]        ;mov number to eax for compting
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
                jmp     .loop               ;looping back
.is_end:        cmp     edx, 0
                jne     .back
                cmp     [ebp-4], byte 1 ;if flag raised
                je      .end_zeroes         ;we need to fill zeroes end of digit
.end_zeroes:    cmp     ebx, 10             ;if ebx>9
                je      .end                ;end
                mov     [ecx], byte 0x30    ;else add 0
                inc     ecx
                inc     ebx
                jmp     .end_zeroes
.end:           mov     [ecx], byte 0
                add     esp, 4
                pop     ebp
                ret     
.avoid          cmp     [ebp-4], byte 0
                je      .avoid_write
                jmp     .after_flag
.set_flag       mov     [ebp-4], byte 1
                jmp     .after_flag

;write([ebp+8]=char*)
write:          push    ebp
                mov     ebp, esp
                mov     eax, [ebp+8]        ;copy char* to eax
.loop:          cmp     [eax], byte 0       ;if char is 0
                je     .return              ;end
                PUTCHAR [eax]               ;else print char*
                inc     eax                 ;char* ++
                loop    .loop
.return:        pop     ebp                 ;clean stack
                ret

;read(1=char*, 2=size) ecx=size, eax=wrong letter
read:           push    ebp
                mov     ebp, esp
                mov     ebx, [ebp+8]
                xor     ecx, ecx
.loop           GETCHAR
                cmp     ecx, [ebp+12]       ;cmp counter to max size
                je      .overwrite          ;if equal overwrite
                cmp     al, 0x20            ;if space
                je      .end
                cmp     al, -1              ;or EOF
                je      .end
                cmp     al, 0x0a            ;of EOL
                je      .end                ;go save digit
                cmp     al, 0x30            ;if '0'
                jl      .end               ;less -> print
                cmp     al, 0x39            ;if '9'
                jg      .end               ;greater -> print
                mov     [ebx+ecx], byte al
                inc     ecx
                jmp     .loop                  ;looping back
.overwrite:     mov     eax, dword -1
.end:           mov     esp, ebp            ;setting stack pointer back
                pop     ebp                 
                ret 


section .bss    
            digits_chars resb 20
            digits_values resd 2
            result_chars resb 10
section .data 
            zero_flag   db 0    ;flag to check if zeroes were at beginning
            multiplier dd 10
            dividers dd 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1
