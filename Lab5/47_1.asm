; Program: Addition using Function
; Description: Reads two numbers and calculates their sum using a custom function

extern printf
extern scanf

SECTION .data
in_fmt:     db "%ld", 0            ; input format
out_fmt:    db "Sum = %ld", 10, 0  ; output format
msg1:       db "Enter first number: ", 0
msg2:       db "Enter second number: ", 0
msg_fmt:    db "%s", 0


SECTION .bss
a:      dq 0                        ; first number
b:      dq 0                        ; second number
res:    dq 0                        ; result


SECTION .text
global main
main:
    push rbp                        ; save base pointer
    mov rbp, rsp                    ; set up stack frame

    ; print first prompt
    mov rdi, msg_fmt
    mov rsi, msg1
    xor rax, rax                    ; clear rax for printf
    call printf

    ; read first number
    mov rdi, in_fmt
    mov rsi, a
    xor rax, rax
    call scanf

    ; print second prompt
    mov rdi, msg_fmt
    mov rsi, msg2
    xor rax, rax
    call printf

    ; read second number
    mov rdi, in_fmt
    mov rsi, b
    xor rax, rax
    call scanf

    ; call sum function with a and b as parameters
    mov rdi, [a]                    ; first parameter
    mov rsi, [b]                    ; second parameter
    call sum                        ; result returned in rax
    mov [res], rax                  ; store result

    ; print the result
    mov rdi, out_fmt
    mov rsi, [res]
    xor rax, rax
    call printf

    mov rax, 0                      ; return 0
    pop rbp
    ret

; Function: sum
; Parameters: rdi = first number, rsi = second number
; Returns: rax = sum of the two numbers
sum:
    push rbp
    mov rbp, rsp
    mov rax, rdi                    ; move first parameter to rax
    add rax, rsi                    ; add second parameter
    pop rbp
    ret