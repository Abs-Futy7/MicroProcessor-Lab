extern printf
extern scanf

SECTION .data
a: dq 0

in: db "%ld", 0
out1: db "Odd", 10, 0
out2: db "Even", 10, 0

SECTION .text
global main
main:
    push rbp
    mov rax, 0
    mov rdi, in
    mov rsi, a
    xor rax, rax
    call scanf

    mov rax, [a]
    mov rbx, 2
    xor rdx, rdx
    div rbx
    cmp rdx, 0
    je even
    mov rdi, out1
    mov rsi, rax
    xor rax, rax
    call printf
    jmp end 

even:
    mov rdi, out2
    mov rsi, rax
    xor rax, rax
    call printf

end:
    mov rax, 0
    pop rbp
    ret


