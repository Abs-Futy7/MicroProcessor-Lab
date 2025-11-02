; Program: Find Maximum using Function
; Description: Reads two numbers and finds the larger one using a custom function

extern printf
extern scanf

SECTION .data
in_fmt:     db "%ld", 0                     ; input format
out_fmt:    db "The larger number is: %ld", 10, 0
msg1:       db "Enter first number: ", 0
msg2:       db "Enter second number: ", 0

SECTION .bss
a:          resq 1                          ; first number
b:          resq 1                          ; second number
max:        resq 1                          ; maximum value

SECTION .text
global main
main:
    push rbp
    
    ; print first prompt
    mov rdi, msg1
    xor rax, rax
    call printf

    ; read first number
    mov rdi, in_fmt
    mov rsi, a
    xor rax, rax
    call scanf

    ; print second prompt
    mov rdi, msg2
    xor rax, rax
    call printf

    ; read second number
    mov rdi, in_fmt
    mov rsi, b
    xor rax, rax
    call scanf

    ; call max_two function with a and b as parameters
    mov rdi, [a]                    ; first parameter
    mov rsi, [b]                    ; second parameter
    call max_two                    ; result returned in rax
    mov [max], rax                  ; store maximum value

    ; print the result
    mov rdi, out_fmt
    mov rsi, [max]
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret


; Function: max_two
; Parameters: rdi = first number, rsi = second number
; Returns: rax = larger of the two numbers
max_two:
    push rbp
    mov rbp, rsp
    mov rax, rdi                    ; assume first is larger
    cmp rsi, rdi                    ; compare second with first
    jle done                        ; if second <= first, done
    mov rax, rsi                    ; else, second is larger

done:
    pop rbp
    ret
