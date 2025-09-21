; ------------------------------------------------------------------------------
; Program: prime.asm
; Description:
;   This program checks if a given positive integer is a prime number.
;   A prime number is a natural number greater than 1 that has no positive
;   divisors other than 1 and itself.
;
; Algorithm:
;   1. Read a number from user input
;   2. If number < 2, it's not prime
;   3. Check divisibility from 2 to (number-1):
;      - If any number divides evenly (remainder = 0), it's not prime
;      - If no divisors found, it's prime
;   4. Print the result
;
; Mathematical Logic:
;   - Numbers less than 2 are not prime by definition
;   - For n >= 2, check if n % i == 0 for i = 2, 3, ..., n-1
;   - If any remainder is 0, n is composite (not prime)
;   - If no divisors found, n is prime
;
; Registers Used:
;   - rax: Number being tested, dividend for division
;   - rbx: Current divisor being tested
;   - rcx: Loop counter (starts at 2, increments to n-1)
;   - rdx: Remainder after division
;   - rdi, rsi: Function parameters for printf/scanf
; ------------------------------------------------------------------------------

extern printf              ; External C library function for output
extern scanf               ; External C library function for input

SECTION .data
x: dq 0                    ; Number to test for primality (64-bit integer)
in_fmt: db "%ld",0         ; Input format string for scanf (long decimal)
msg: db "Enter Number : ",0 ; User prompt message
msg_fmt: db "%s",0         ; Format string for printing messages
out1: db "%ld is Prime",10,0     ; Output message for prime numbers
out2: db "%ld is Not Prime",10,0 ; Output message for non-prime numbers

SECTION .text
global main                ; Make main function visible to linker
main:
    push rbp               ; Save base pointer on stack (function prologue)

    ; === STEP 1: Display prompt message ===
    mov rax,0              ; Clear RAX (required for variadic functions like printf)
    mov rdi,msg_fmt        ; Load address of format string "%s" into RDI (1st parameter)
    mov rsi,msg            ; Load address of message "Enter Number : " into RSI (2nd parameter)
    call printf            ; Call printf to display the prompt

    ; === STEP 2: Read number from user ===
    mov rax,0              ; Clear RAX for scanf
    mov rdi,in_fmt         ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi,x              ; Load address of variable 'x' into RSI (2nd parameter)
    call scanf             ; Call scanf to read integer and store in variable 'x'

    ; === STEP 3: Check if number is less than 2 ===
    ; Numbers less than 2 (0, 1, negative) are not prime by definition
    mov rax,[x]            ; Load the input number into RAX
    cmp rax,2              ; Compare the number with 2
    jl notprime            ; Jump to notprime if number < 2

    ; === STEP 4: Initialize loop for divisibility testing ===
    ; We'll check divisors from 2 to (x-1)
    mov rcx,2              ; Initialize loop counter RCX = 2 (first potential divisor)

; === STEP 5: Main divisibility testing loop ===
; This loop checks if x is divisible by any number from 2 to (x-1)
; Loop condition: while (divisor < x)

check_loop:
    mov rbx,rcx            ; Move current divisor (RCX) to RBX for division
    mov rdx,0              ; Clear RDX register (must be 0 before division)
                           ; RDX:RAX forms 128-bit dividend for division
    mov rax,[x]            ; Reload the number 'x' into RAX (dividend)
    div rbx                ; Divide RAX by RBX: quotient → RAX, remainder → RDX
    
    ; === STEP 6: Check if division was exact (remainder = 0) ===
    cmp rdx,0              ; Compare remainder with 0
    je notprime            ; If remainder = 0, number is divisible, so not prime

    ; === STEP 7: Increment divisor and check loop condition ===
    inc rcx                ; Increment divisor: RCX = RCX + 1
    mov rax,[x]            ; Load the number 'x' into RAX for comparison
    cmp rcx,rax            ; Compare current divisor (RCX) with the number (RAX)
    jl check_loop          ; Jump back to check_loop if divisor < number

; === STEP 8: If we reach here, no divisors found - number is prime ===
prime:
    mov rdi,out1           ; Load address of prime message "%ld is Prime\n"
    mov rsi,[x]            ; Load the number as 2nd parameter for printf
    mov rax,0              ; Clear RAX for printf (variadic function requirement)
    call printf            ; Call printf to display prime message
    jmp done               ; Jump to program end

; === STEP 9: Number is not prime (divisor found or < 2) ===
notprime:
    mov rdi,out2           ; Load address of not-prime message "%ld is Not Prime\n"
    mov rsi,[x]            ; Load the number as 2nd parameter for printf
    mov rax,0              ; Clear RAX for printf (variadic function requirement)
    call printf            ; Call printf to display not-prime message

; === STEP 10: Program termination ===
done:
    pop rbp                ; Restore base pointer from stack
    mov rax,0              ; Set return value to 0 (success)
    ret                    ; Return to caller (exit program)
