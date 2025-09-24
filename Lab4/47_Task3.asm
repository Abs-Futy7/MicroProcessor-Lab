; ------------------------------------------------------------------------------
; Program: 47_Task3.asm
; Description:
;   This program finds and prints all divisors of a positive integer entered
;   by the user. A divisor is a number that divides the given number evenly
;   (with no remainder).
;   For example: divisors of 12 are 1, 2, 3, 4, 6, 12
;
; Algorithm:
;   1. Read a number (n) from user input
;   2. Initialize counter (cnt) to 1
;   3. Loop from cnt=1 to cnt=n:
;      - Check if n % cnt == 0 (cnt divides n evenly)
;      - If yes, print cnt (it's a divisor)
;      - Increment cnt
;   4. Exit when cnt > n
;
; Mathematical Process:
;   Input n = 12
;   cnt=1: 12%1=0 → Print 1 (divisor)
;   cnt=2: 12%2=0 → Print 2 (divisor)
;   cnt=3: 12%3=0 → Print 3 (divisor)
;   cnt=4: 12%4=0 → Print 4 (divisor)
;   cnt=5: 12%5=2 → Skip (not a divisor)
;   cnt=6: 12%6=0 → Print 6 (divisor)
;   ...and so on until cnt=12
;
; Registers Used:
;   - rax: General purpose, holds dividend and temporary values
;   - rbx: Holds divisor value (cnt) for division operations
;   - rdx: Remainder after division (used to check if divisor is valid)
;   - rdi, rsi: Function parameters for printf/scanf
; ------------------------------------------------------------------------------

extern printf              ; External C library function for output
extern scanf               ; External C library function for input

SECTION .data
n: dq 0                    ; Number for which to find divisors (64-bit integer)
cnt: dq 1                  ; Loop counter/potential divisor (starts at 1)
in_fmt: db "%ld", 0        ; Input format string for scanf (long decimal)
out_fmt: db "%ld", 10, 0   ; Output format string with newline for each divisor
msg: db "Enter a number: ",0  ; User prompt message
msg_fmt: db "%s",0         ; Format string for printing messages

SECTION .text
global main                ; Make main function visible to linker
main:
    push rbp               ; Save base pointer on stack (function prologue)

    ; === STEP 1: Display prompt message ===
    mov rdi, msg_fmt       ; Load address of format string "%s" into RDI (1st parameter)
    mov rsi, msg           ; Load address of prompt "Enter a number: " into RSI (2nd parameter)
    xor rax, rax           ; Clear RAX for printf (equivalent to mov rax, 0)
    call printf            ; Call printf to display the prompt

    ; === STEP 2: Read number from user ===
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, n             ; Load address of variable 'n' into RSI (2nd parameter)
    xor rax, rax           ; Clear RAX for scanf
    call scanf             ; Call scanf to read integer and store in variable 'n'

; === STEP 3: Main divisor-finding loop ===
; This loop tests each number from 1 to n to see if it divides n evenly
; Loop structure: for(cnt = 1; cnt <= n; cnt++)

div:
    ; === Test if current counter is a divisor ===
    mov rax, [n]           ; Load the input number 'n' into RAX (dividend)
    mov rbx, [cnt]         ; Load current counter 'cnt' into RBX (potential divisor)
    xor rdx, rdx           ; Clear RDX register (must be 0 before division)
                           ; RDX:RAX forms 128-bit dividend for division
    div rbx                ; Divide RAX by RBX: quotient → RAX, remainder → RDX
                           ; After division: RDX = n % cnt (remainder)
    
    ; === Check if division was exact (remainder = 0) ===
    cmp rdx, 0             ; Compare remainder with 0
    jne skip               ; Jump to 'skip' if remainder ≠ 0 (not a divisor)

    ; === Print the divisor ===
    ; If we reach here, remainder = 0, so cnt is a divisor of n
    mov rdi, out_fmt       ; Load address of output format "%ld\n" into RDI
    mov rsi, [cnt]         ; Load current divisor value into RSI (2nd parameter)
    xor rax, rax           ; Clear RAX for printf (variadic function requirement)
    call printf            ; Call printf to print the divisor

skip:
    ; === Increment counter for next iteration ===
    mov rax, [cnt]         ; Load current counter value into RAX
    add rax, 1             ; Increment: RAX = RAX + 1
    mov [cnt], rax         ; Store incremented value back to memory: cnt = cnt + 1

    ; === Check loop termination condition ===
    mov rax, [cnt]         ; Load updated counter value into RAX
    mov rbx, [n]           ; Load the input number 'n' into RBX
    cmp rax, rbx           ; Compare current counter with the input number
    jle div                ; Jump back to 'div' if cnt <= n (continue loop)
                           ; Loop terminates when cnt > n

    ; === STEP 4: Program termination ===
    pop rbp                ; Restore base pointer from stack
    mov rax, 0             ; Set return value to 0 (success)
    ret                    ; Return to caller (exit program)
