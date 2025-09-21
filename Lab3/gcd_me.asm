; ------------------------------------------------------------------------------
; Program: gcd_me.asm
; Description:
;   This program calculates the Greatest Common Divisor (GCD) of two integers
;   entered by the user. It uses the Euclidean algorithm for GCD computation.
;   The program prompts the user to input two numbers, computes their GCD,
;   and prints the result.
;
; Sections:
;   .data
;     - a, b: Variables to store user input integers.
;     - in_fmt: Format string for reading integers using scanf.
;     - out_fmt: Format string for printing the GCD result.
;     - msg: Prompt message for user input.
;     - msg_fmt: Format string for printing messages.
;
;   .text
;     - main: Entry point of the program.
;         - Prints prompt message.
;         - Reads two integers from user input.
;         - Computes GCD using Euclidean algorithm (iterative).
;         - Prints the GCD result.
;
; External Functions:
;   - printf: Used for printing messages and results.
;   - scanf: Used for reading user input.
;
; Registers Used:
;   - rax: General purpose, stores current value and result.
;   - rbx: Stores second operand for GCD calculation.
;   - rdx: Stores remainder during division.
;   - rdi, rsi: Used for passing arguments to printf/scanf.
;
; Algorithm:
;   1. Prompt user for two numbers.
;   2. Read numbers into variables a and b.
;   3. Use Euclidean algorithm:
;        while b != 0:
;            temp = b
;            b = a % b
;            a = temp
;   4. Print the GCD (value in rax).
; ------------------------------------------------------------------------------
extern printf
extern scanf

SECTION .data
a: dq 0                    ; First number (64-bit integer, quadword)
b: dq 0                    ; Second number (64-bit integer, quadword)
in_fmt: db "%ld", 0        ; Input format string for scanf (long decimal)
out_fmt: db "GCD is %ld", 10, 0  ; Output format string with newline (ASCII 10)
msg: db "Enter two numbers: ", 0  ; User prompt message string
msg_fmt: db "%s", 0        ; Format string for printing string messages

SECTION .text
global main                ; Make main function visible to linker
main:
    push rbp               ; Save base pointer on stack (function prologue)

    ; === STEP 1: Print prompt message to user ===
    mov rax, 0             ; Clear RAX (required for variadic functions like printf)
    mov rdi, msg_fmt       ; Load address of format string "%s" into RDI (1st parameter)
    mov rsi, msg           ; Load address of message "Enter two numbers: " into RSI (2nd parameter)
    call printf            ; Call printf to display the prompt

    ; === STEP 2: Read first number from user ===
    mov rax, 0             ; Clear RAX again for scanf
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, a             ; Load address of variable 'a' into RSI (2nd parameter)
    call scanf             ; Call scanf to read integer and store in variable 'a'

    ; === STEP 3: Read second number from user ===
    mov rax, 0             ; Clear RAX again for scanf
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, b             ; Load address of variable 'b' into RSI (2nd parameter)
    call scanf             ; Call scanf to read integer and store in variable 'b'

    ; === STEP 4: Initialize GCD calculation ===
    ; Load values from memory into registers for computation
    mov rax, [a]           ; Load value of 'a' into RAX (will hold current dividend)
    mov rbx, [b]           ; Load value of 'b' into RBX (will hold current divisor)

; === STEP 5: GCD Calculation using Euclidean Algorithm ===
; The Euclidean algorithm works as follows:
; gcd(a, b) = gcd(b, a mod b) when b ≠ 0
; gcd(a, 0) = a
; 
; Loop structure:
; while (b != 0) {
;     temp = a % b    // find remainder
;     a = b          // old divisor becomes new dividend  
;     b = temp       // remainder becomes new divisor
; }
; return a           // when b = 0, a contains the GCD

gcd:
    cmp rbx, 0             ; Compare RBX (current divisor) with 0
    je gcd_done            ; If RBX = 0, jump to gcd_done (algorithm complete)

    ; Perform division: RAX ÷ RBX
    xor rdx, rdx           ; Clear RDX register (must be 0 before division)
                           ; RDX:RAX forms 128-bit dividend for division
    div rbx                ; Divide RAX by RBX: quotient → RAX, remainder → RDX
    
    ; Update values for next iteration of Euclidean algorithm
    mov rax, rbx           ; Move old divisor (RBX) to RAX (new dividend)
    mov rbx, rdx           ; Move remainder (RDX) to RBX (new divisor)
    jmp gcd                ; Jump back to start of loop

gcd_done:
    ; === STEP 6: Print the result ===
    ; At this point, RAX contains the GCD
    mov rdi, out_fmt       ; Load address of output format "GCD is %ld\n" into RDI
    mov rsi, rax           ; Move GCD result from RAX to RSI (2nd parameter for printf)
    mov rax, 0             ; Clear RAX for printf (variadic function requirement)
    call printf            ; Call printf to display the result

    ; === STEP 7: Function epilogue and return ===
    pop rbp                ; Restore base pointer from stack
    mov rax, 0             ; Set return value to 0 (success)
    ret                    ; Return to caller (exit program)
