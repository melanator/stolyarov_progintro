global _start
section .text

_start:     cmp     [esp], dword 3
            jne     .fail
            push    dword [esp+8]
            call    strlen
            add     esp, 4
            push    eax                 ;save fist len
            push    ebx                 ;save first last char
            push    dword [esp+12]      ;push second* to stack
            call    strlen
            add     esp, 4
            cmp    dword [esp+4], ebx
            jne     .fail
            cmp    dword [esp+8], eax
            jne     .fail
            jmp     .success

.success    mov     eax, 1
            mov     ebx, 0
            int     0x80

.fail:      mov     eax, 1
            mov     ebx, 1
            int     0x80

strlen:     push    ebp
            mov     ebp, esp
            xor     eax, eax
            mov     ecx, [ebp+8]        ;1st arg
.lp:        cmp     byte [eax+ecx], 0
            je      .quit
            inc     eax
            mov     ebx, [eax+ecx]      ;last char of loop keeps in ebx
            jmp     .lp
.quit       pop     ebp
            ret
