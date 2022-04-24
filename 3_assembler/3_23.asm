%include "stud_io.inc"
global _start
section .text
_start:     
read_loop:  GETCHAR             
            cmp     al, -1          ;if eof
            je      print_loop_     ;print
            cmp     al, 0x0a        ;if eol
            je      save_line       ;save line to char
            push    eax             ;push to stack
            inc     ecx             ;counter++
            jmp     read_loop       ;loop back
save_line:  pop     eax             ;pop stack to eax
            mov     [chars+ebx], al ;save stacked char to chars[ebx]
            inc     ebx             ;ebx++
            loop    save_line       ;loop back
            mov     [chars+ebx], byte 0x0a ;after loop add new_line to chars[ebx]
            inc     ebx             ;ebx ++
            jmp     _start          ;jmp to read chars
print_loop_: mov     ecx, ebx       ;ebx to counter
print_loop: mov     al, [chars+edx] ;copy chars[edx] to al
            PUTCHAR al              ;print al
            inc     edx             ;edx++
            loop    print_loop      ;loop back 
            FINISH
section .bss
    chars resb 2048
