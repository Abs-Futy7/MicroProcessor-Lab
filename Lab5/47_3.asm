; Program: String Reversal using Function
; Description: Reads a string and reverses it using a custom function

extern printf
extern scanf

SECTION .data
in_str_fmt:    db "%s", 0           ; string input format
out_str_fmt:   db "%s", 10, 0       ; string output format
msg:           db "Enter a string: ", 0

SECTION .bss
str:           resb 100              ; original string buffer
rev:           resb 100              ; reversed string buffer

SECTION .text
global main
main:
    push rbp

    ; print prompt
    mov rdi, msg
    xor rax, rax
    call printf

    ; read string
    mov rdi, in_str_fmt
    mov rsi, str
    xor rax, rax
    call scanf

    ; call string reversal function
    mov rdi, str                    ; source string
    mov rsi, rev                    ; destination buffer
    call rev_str

    ; print reversed string
    mov rdi, out_str_fmt
    mov rsi, rev
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret


; Function: rev_str
; Parameters: rdi = source string pointer, rsi = destination buffer pointer
; Returns: nothing (result stored in destination buffer)
rev_str:
    push rbp
    mov rbp, rsp
    push rbx                        ; save callee-saved registers
    push rcx
    push rdx
    push rax
    
    mov rbx, rdi                    ; save original pointer
    mov rcx, 0                      ; length counter

; calculate string length
len_loop:
    mov al, [rdi]                   ; load current character
    cmp al, 0                       ; check for null terminator
    je len_done                     ; if null, length calculation done
    inc rcx                         ; increment length
    inc rdi                         ; move to next character
    jmp len_loop

len_done:
    dec rdi                         ; point to last character (before null)
    mov rdx, 0                      ; destination index

; reverse the string
rev_loop:
    cmp rcx, 0                      ; check if all characters processed
    je rev_done                     ; if yes, done
    mov al, [rdi]                   ; get character from end
    mov [rsi + rdx], al             ; store at beginning of dest
    dec rdi                         ; move backwards in source
    inc rdx                         ; move forward in dest
    dec rcx                         ; decrement counter
    jmp rev_loop

rev_done:
    mov byte [rsi + rdx], 0         ; add null terminator

    pop rax                         ; restore registers
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret
