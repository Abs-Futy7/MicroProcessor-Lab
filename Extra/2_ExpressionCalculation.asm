;5a - 3b + 2c
extern printf
extern scanf

SECTION .data
a: dq 0
b: dq 0
c: dq 0
in: db "%ld", 0
out: db "%ld", 10, 0

SECTION .text
global main
main:
    push rbp
    mov rax, 0
    mov rdi, in
    mov rsi, a
    xor rax, rax
    call scanf

    mov rdi, in
    mov rsi, b
    xor rax, rax
    call scanf

    mov rdi, in
    mov rsi, c
    xor rax, rax
    call scanf

    mov rax, [a]
    imul rax, 5
    mov rbx, [b]
    imul rbx, 3
    sub rax, rbx
    mov rcx, [c]
    imul rcx, 2
    add rax, rcx
    mov rdi, out
    mov rsi, rax
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret