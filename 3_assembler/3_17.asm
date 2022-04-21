%include "stud_io.inc"

global _start
section .text
_start:     GETCHAR             ;saves char in al
            cmp     al, -1      ;if first is EOF
            je      quit        ;just quit
            cmp     al, 0x20    ;if first is \n
            je      newline     ;print newline
            PUTCHAR 0x28        ;if not, first is always (
            PUTCHAR al          ;and print char

lp:                
            GETCHAR
            cmp     al, 0x20    ;if space
            je      brack
            cmp     al, 0x0a    ;if EOL
            je      newline     
            cmp     al, -1      ;if EOF
            je      newline     ;print newline
            PUTCHAR al          ;else print char
            jmp lp
            
brack:      PUTCHAR 0x29        ;print )
nextchar:   PUTCHAR 0x20        ;print space
nextchar2:  GETCHAR             ;getting next char
            cmp     al, 0x20    ;if space
            je      nextchar    ;loop back
            cmp     al, -1      ;if eof
            je      quit
            PUTCHAR 0x28        ;print (
            PUTCHAR al
            jmp     lp
            
newline:    PUTCHAR 0x29        ;print )
            PUTCHAR 0x0a        ;print newline
            cmp     al, -1      ;if eof leave
            je      quit
            jmp     nextchar2   ;find next char by without printing space
            jmp     lp          
quit:       FINISH