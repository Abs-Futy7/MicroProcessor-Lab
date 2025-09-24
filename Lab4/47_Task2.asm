; ------------------------------------------------------------------------------
; Program: 47_Task2.asm
; Description:
;   This program generates and displays the multiplication table for a number
;   entered by the user. It prints the table from 1 to 10.
;   For example: if input is 5, it will print:
;   5*1=5, 5*2=10, 5*3=15, ..., 5*10=50
;
; Algorithm:
;   1. Read a number (n) from user input
;   2. Initialize counter (i) to 1
;   3. Loop from i=1 to i=10:
;      - Calculate product = n * i
;      - Print "n*i=product"
;      - Increment i
;   4. Exit when i > 10
;
; Mathematical Process:
;   Input n = 5
;   i=1: 5*1=5
;   i=2: 5*2=10
;   i=3: 5*3=15
;   ...
;   i=10: 5*10=50
;
; Registers Used:
;   - rax: General purpose, holds calculated product and temporary values
;   - rbx: Holds current multiplier value (i)
;   - rcx: Fourth parameter for printf (product result)
;   - rdx: Third parameter for printf (multiplier i)
;   - rdi, rsi: First and second parameters for printf/scanf
;   - rbp, rsp: Stack frame management
; ------------------------------------------------------------------------------

extern printf              ; External C library function for output
extern scanf               ; External C library function for input

SECTION .data
n:         dq 0           ; Number for which table is generated (64-bit integer)
i:         dq 1           ; Loop counter/multiplier (starts at 1, goes to 10)
product:   dq 0           ; Result of n * i (64-bit integer)

in_fmt:    db "%ld", 0    ; Input format string for scanf (long decimal)
out_fmt:   db "%ld*%ld=%ld", 10, 0   ; Output format: "number*multiplier=product\n"   

SECTION .text
global main                ; Make main function visible to linker
main:
    push rbp               ; Save base pointer on stack (function prologue)
    mov rbp, rsp           ; Set up new stack frame (RBP points to current stack frame)
    
    ; === STEP 1: Read number from user ===
    ; No prompt message is displayed in this version
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, n             ; Load address of variable 'n' into RSI (2nd parameter)
    xor rax, rax           ; Clear RAX for scanf (equivalent to mov rax, 0)
    call scanf             ; Call scanf to read integer and store in variable 'n'

    ; === STEP 2: Initialize loop counter ===
    mov qword [i], 1       ; Initialize multiplier 'i' to 1 (using qword for 64-bit)
                           ; We start from 1 because multiplication table typically starts at 1

; === STEP 3: Main multiplication table loop ===
; This loop generates table entries from n*1 to n*10
; Loop structure: for(i = 1; i <= 10; i++)

table:
    ; === Calculate product = n * i ===
    mov rax, [n]           ; Load the base number 'n' into RAX
    mov rbx, [i]           ; Load current multiplier 'i' into RBX
    imul rax, rbx          ; Signed multiply: RAX = RAX * RBX (n * i)
    mov [product], rax     ; Store the calculated product in memory variable 'product'

    ; === Print the multiplication entry ===
    ; Format: "n*i=product\n"
    mov rdi, out_fmt       ; Load address of output format "%ld*%ld=%ld\n" (1st parameter)
    mov rsi, [n]           ; Load base number 'n' (2nd parameter - first %ld)
    mov rdx, [i]           ; Load current multiplier 'i' (3rd parameter - second %ld)
    mov rcx, [product]     ; Load calculated product (4th parameter - third %ld)
    xor rax, rax           ; Clear RAX for printf (variadic function requirement)
    call printf            ; Call printf to display "n*i=product"

    ; === Increment loop counter ===
    inc qword [i]          ; Increment multiplier: i = i + 1 (using qword for 64-bit)

    ; === Check loop termination condition ===
    mov rax, [i]           ; Load current value of 'i' into RAX
    cmp rax, 11            ; Compare i with 11
    jl table               ; Jump back to 'table' if i < 11 (continue loop)
                           ; Loop terminates when i >= 11 (after printing 1 to 10)

    ; === STEP 4: Function epilogue and program termination ===
    mov rsp, rbp           ; Restore stack pointer (cleanup stack frame)
    pop rbp                ; Restore base pointer from stack
    mov rax, 0             ; Set return value to 0 (success)
    ret                    ; Return to caller (exit program)
