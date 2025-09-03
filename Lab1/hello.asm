; Import the printf function from the C standard library
extern printf

; SECTION .data starts the data segment for variable declarations
SECTION .data
a: dq 5          ; Declare 64-bit integer 'a' initialized to 5
b: dq 2          ; Declare 64-bit integer 'b' initialized to 2
c: dq 0          ; Declare 64-bit integer 'c' initialized to 0 (will hold sum)
fmt: db "a=%ld, b=%ld c=%ld", 10, 0 ; Format string for printf with newline

; SECTION .text starts the code segment
SECTION .text
global main      ; Make 'main' visible to linker

main:
    push rbp         ; Save base pointer (function prologue)
    mov rax,[a]      ; Load value of 'a' into rax
    mov rbx,[b]      ; Load value of 'b' into rbx
    add rax,rbx      ; Add rbx (b) to rax (a), result in rax
    mov [c],rax      ; Store result (a+b) into 'c'
    mov rdi,fmt      ; First argument to printf: address of format string
    mov rsi,[a]      ; Second argument: value of 'a'
    mov rdx,[b]      ; Third argument: value of 'b'
    mov rcx,[c]      ; Fourth argument: value of 'c'
    mov rax,0        ; Clear rax (required for variadic functions on Linux)
    call printf      ; Call printf to print the values
    pop rbp          ; Restore base pointer (function epilogue)
    mov rax,0        ; Return 0 from main
    ret              ; Return to caller
