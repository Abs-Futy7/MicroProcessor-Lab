extern printf
extern scanf

SECTION .data
a: dq 0
fact: dq 1
counter: dq 1
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

    mov qword [fact], 1
    mov qword [counter], 1

factorial_loop_start:
    mov rax, [counter]
    mov rbx, [a]
    cmp rax, rbx
    jg loop_end
    mov rcx, [fact]
    imul rcx, rax
    mov [fact], rcx
    inc rax
    mov [counter], rax
    jmp factorial_loop_start

loop_end:
    mov rax, [fact]
    mov rdi, out
    mov rsi, rax
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret
