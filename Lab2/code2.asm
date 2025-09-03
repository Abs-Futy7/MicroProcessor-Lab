extern printf        
extern scanf        

SECTION .data        

a:  dq 0             ; Variable a
b:  dq 0             ; Variable b
c:  dq 0             ; Variable c
d:  dq 0             ; Variable d (not used in calculation)

enter: db "Enter three numbers: ", 0      ; Message to prompt user
out_fmt: db "2a + 3b + c = %ld", 10, 0     ; Output format for printf (long integers)
out_fmt_2: db "%s", 10, 0                ; Format to print strings
in_fmt: db "%d", 0                      ; Format for scanf (expecting integer input)

SECTION .text

global main        
main:
        push    rbp    
        
        ; Print prompt to user: "Enter three numbers:"
        mov rax, 0      
        mov rdi, out_fmt_2   ; Load address of output format string for user prompt
        mov rsi, enter    
        call printf    

        ; Scan the first number for 'a'
        mov rax, 0       
        mov rdi, in_fmt   ; Load format for scanf (expecting an integer)
        mov rsi, a        ; Pass address of variable 'a' to scanf
        call scanf        ; Get input from user and store in 'a'

        ; Scan the second number for 'b'
        mov rax, 0        ; Clear rax register
        mov rdi, in_fmt   ; Load format for scanf (expecting an integer)
        mov rsi, b        ; Pass address of variable 'b' to scanf
        call scanf        ; Get input from user and store in 'b'
        
        ; Scan the third number for 'c'
        mov rax, 0        ; Clear rax register
        mov rdi, in_fmt   ; Load format for scanf (expecting an integer)
        mov rsi, c        ; Pass address of variable 'c' to scanf (corrected variable)
        call scanf        ; Get input from user and store in 'c'

        ; Perform the calculation: 2a + 3b + c
        mov rax, [a]      ; Load value of 'a' into rax
        imul rax, 2       ; Multiply a by 2 (rax = a * 2)

        mov rbx, [b]      ; Load value of 'b' into rbx
        imul rbx, 3       ; Multiply b by 3 (rbx = b * 3)

        add rax, rbx      ; Add 2a and 3b, store result in rax

        mov rcx, [c]      ; Load value of 'c' into rcx
        add rax, rcx      ; Add c to the result

        ; Print the result: 2a + 3b + c
        mov rdi, out_fmt  ; Load output format string
        mov rsi, rax      ; Move the result to rsi (second parameter for printf)
        call printf       ; Call printf to print the result

        pop rbp           ; Restore base pointer
        mov rax, 0        ; Set return value to 0
        ret               ; Return from main

