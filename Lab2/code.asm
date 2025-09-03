extern printf        
extern scanf        

SECTION .data        

a:  dq 5           ; a = 5
b:  dq 2           ; b = 2
c:  dq 0           ; c = 0

enter: db "Enter two numbers: ", 0      ; Message to prompt user
out_fmt: db "%ld + %ld =%ld", 10, 0     ; Output format for printf (long integers)
out_fmt_2: db "%s",10,0                ; Format to print strings
in_fmt: db "%d",0                      ; Format for scanf (expecting integer input)

SECTION .text

global main        
main:
        push    rbp    
        
        mov rax, 0        ; Clear rax register
        mov rdi, out_fmt_2   ; Load address of output format string for user prompt
        mov rsi, enter    ; Load the address of the message "Enter two numbers"
        call printf       ; Print the message to the user

        mov rax, 0        ; Clear rax register
        mov rdi, in_fmt   ; Load format for scanf (expecting an integer)
        mov rsi, a        ; Pass address of variable 'a' to scanf
        call scanf        ; Get input from user and store in 'a'

        mov rax, 0        ; Clear rax register
        mov rdi, in_fmt   ; Load format for scanf (expecting an integer)
        mov rsi, b        ; Pass address of variable 'b' to scanf
        call scanf        ; Get input from user and store in 'b'

        mov rax, [a]      ; Load value of 'a' into rax
        mov rbx, [b]      ; Load value of 'b' into rbx
        add rax, rbx      ; Add values in rax and rbx, result stored in rax
        mov [c], rax      ; Store result in variable 'c'

        mov rdi, out_fmt  ; Load output format string
        mov rsi, [a]      ; Load value of 'a'
        mov rdx, [b]      ; Load value of 'b'
        mov rcx, [c]      ; Load value of 'c'
        mov rax, 0        ; Clear rax register
        call printf       ; Print the result: a + b = c

        pop rbp           ; Restore base pointer
        mov rax, 0        ; Set return value to 0
        ret               ; Return from main

