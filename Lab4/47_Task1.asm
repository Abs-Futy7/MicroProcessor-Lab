; ------------------------------------------------------------------------------
; Program: 47_Task1.asm
; Description:
;   This program reverses the digits of a positive integer entered by the user.
;   For example: if input is 1234, output will be 4321
;   
; Algorithm:
;   1. Read a number from user
;   2. Extract digits one by one using modulo 10 operation
;   3. Build reversed number by multiplying current result by 10 and adding new digit
;   4. Repeat until original number becomes 0
;   5. Print the reversed number
;
; Mathematical Process:
;   Original number: 1234
;   Step 1: digit = 1234 % 10 = 4, reversed = 0*10 + 4 = 4,   remaining = 123
;   Step 2: digit = 123 % 10 = 3,  reversed = 4*10 + 3 = 43,  remaining = 12
;   Step 3: digit = 12 % 10 = 2,   reversed = 43*10 + 2 = 432, remaining = 1
;   Step 4: digit = 1 % 10 = 1,    reversed = 432*10 + 1 = 4321, remaining = 0
;   Result: 4321
;
; Registers Used:
;   - rax: General purpose, used for division operations
;   - rbx: Holds current working number (gets reduced each iteration)
;   - rcx: Constant value 10 (divisor for extracting digits)
;   - rdx: Remainder after division (extracted digit)
;   - rsi: Accumulates the reversed number
;   - rdi, rsi: Function parameters for printf/scanf
; ------------------------------------------------------------------------------

extern printf              ; External C library function for output
extern scanf               ; External C library function for input

SECTION .data
a: dq 0                    ; Original number entered by user (64-bit integer)
rev: dq 0                  ; Final reversed number (64-bit integer)
in_fmt: db "%ld", 0        ; Input format string for scanf (long decimal)
out_fmt: db "Reverse is : %ld", 10, 0  ; Output format with newline
msg: db "Enter the variable: ", 0       ; User prompt message
msg_fmt: db "%s", 0        ; Format string for printing messages

SECTION .text
global main                ; Make main function visible to linker
main:
    push rbp               ; Save base pointer on stack (function prologue)
    
    ; === STEP 1: Display prompt message ===
    mov rax, 0             ; Clear RAX (required for variadic functions like printf)
    mov rdi, msg_fmt       ; Load address of format string "%s" into RDI (1st parameter)
    mov rsi, msg           ; Load address of prompt message into RSI (2nd parameter)
    call printf            ; Call printf to display "Enter the variable: "

    ; === STEP 2: Read number from user ===
    mov rax, 0             ; Clear RAX for scanf
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, a             ; Load address of variable 'a' into RSI (2nd parameter)
    call scanf             ; Call scanf to read integer and store in variable 'a'

    ; === STEP 3: Initialize reversal process ===
    mov rbx, [a]           ; Load the input number into RBX (working copy)
    xor rsi, rsi           ; Clear RSI to 0 (RSI will accumulate the reversed number)
                           ; Using XOR is more efficient than MOV rsi, 0

; === STEP 4: Main digit reversal loop ===
; This loop extracts digits from right to left and builds reversed number
; Loop continues while RBX (working number) is not zero

reverse:
    ; Check if we've processed all digits
    cmp rbx, 0             ; Compare working number with 0
    je print               ; Jump to print if RBX = 0 (no more digits to process)

    ; === Extract rightmost digit using division by 10 ===
    xor rdx, rdx           ; Clear RDX register (must be 0 before division)
                           ; RDX:RAX forms 128-bit dividend for division
    mov rax, rbx           ; Move working number to RAX (dividend)
    mov rcx, 10            ; Set divisor to 10
    div rcx                ; Divide RAX by 10: quotient → RAX, remainder → RDX
                           ; After division: RAX = RBX/10, RDX = RBX%10 (last digit)

    ; === Build reversed number ===
    ; Formula: new_reversed = old_reversed * 10 + extracted_digit
    imul rsi, rsi, 10      ; Multiply current reversed number by 10 (shift left)
    add  rsi, rdx          ; Add the extracted digit (RDX) to reversed number

    ; === Prepare for next iteration ===
    mov rbx, rax           ; Update working number: remove the processed digit
                           ; RBX = RBX/10 (quotient from division)
    jmp reverse            ; Jump back to start of loop

; === STEP 5: Output the result ===
print:
    mov [rev], rsi         ; Store the final reversed number in memory variable 'rev'

    ; Print the reversed number
    mov rax, 0             ; Clear RAX for printf (variadic function requirement)
    mov rdi, out_fmt       ; Load address of output format "Reverse is : %ld\n"
    mov rsi, [rev]         ; Load the reversed number as 2nd parameter for printf
    call printf            ; Call printf to display the result

    ; === STEP 6: Program termination ===
    mov rax, 0             ; Set return value to 0 (success)
    pop rbp                ; Restore base pointer from stack
    ret                    ; Return to caller (exit program)
