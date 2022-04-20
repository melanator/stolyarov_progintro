%include "stud_io.inc"
global _start

section .text
_start:     
            xor     ebx, ebx        ;ebx to (
            xor     edx, edx        ;edx to )
            xor     ecx, ecx        ;ecx to keep if string is right
lp:         GETCHAR                 ;macro saves char in EAX
            cmp     al, 0x0a        ;or char == EOL
            je      check           ;will check if string is right
            cmp     al, -1          ;or EOF
            je      check           ;will check if string is right
            cmp     al, 40          ;if (
            je      open_br         
            cmp     al, 41          ;if )
            je      close_br
            jmp     lp              ;loop back
open_br:    inc     ebx             ;ebc++
            jmp     lp              ;loop back
close_br:   inc     edx             ;edx++
            cmp     edx, ebx        ;if ) > (
            jg      set_false       ;answer will be "NO" anyway
            jmp     lp              ;loop back
set_false:  inc     ecx             ;ecx++ 
            jmp     lp              
check:      cmp     ebx, edx        ;if ebx == edx
            je      print_yes       ;print yes
            cmp     ecx, 0          ;if ecx flag == 0
            je      print_yes       ;print yes
print_no:   PRINT   "NO"            ;else print NO
            PUTCHAR 0x0a            ;print new line
            jmp     line_end        ;avoidind printing "NO"
print_yes:  PRINT   "YES"
            PUTCHAR  0x0a           ;print new line
line_end:   xor     ebx, ebx        ;cleaning ebx ecx for new lines
            xor     edx, edx        
            xor     ecx, ecx
            cmp     al, -1          ;if eof
            jne     lp              ;NOT loop back           
quit:       FINISH                  ;quit