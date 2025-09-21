; ------------------------------------------------------------------------------
; Program: max.asm
; Description:
;   This program finds the maximum (largest) of three integers entered by the user.
;   It uses conditional jumps and comparisons to determine which number is largest.
;   The program prompts for three numbers, compares them sequentially, and prints
;   the maximum value.
;
; Algorithm:
;   1. Read three numbers: a, b, c
;   2. Initialize max = a
;   3. If b > max, then max = b
;   4. If c > max, then max = c
;   5. Print the maximum value
;
; Registers Used:
;   - rax: Holds current maximum value during comparison
;   - rbx: Temporary storage for second number (b)
;   - rcx: Temporary storage for third number (c)
;   - rdi, rsi: Function parameters for printf/scanf
; ------------------------------------------------------------------------------

extern printf              ; External C library function for output
extern scanf               ; External C library function for input

SECTION .data
a: dq 0                    ; First number (64-bit integer, quadword)
b: dq 0                    ; Second number (64-bit integer, quadword)  
c: dq 0                    ; Third number (64-bit integer, quadword)
in_fmt: db "%ld", 0        ; Input format string for scanf (long decimal)
msg: db "Enter 3 numbers : ", 0  ; User prompt message
msg_fmt: db "%s", 0        ; Format string for printing messages
out_fmt: db "%ld is bigger", 10, 0  ; Output format with newline (ASCII 10)

SECTION .text
global main                ; Make main function visible to linker
main:
    push rbp               ; Save base pointer on stack (function prologue)

    ; === STEP 1: Display prompt message ===
    mov rax, 0             ; Clear RAX (required for variadic functions like printf)
    mov rdi, msg_fmt       ; Load address of format string "%s" into RDI (1st parameter)
    mov rsi, msg           ; Load address of message "Enter 3 numbers : " into RSI (2nd parameter)
    call printf            ; Call printf to display the prompt

    ; === STEP 2: Read first number (a) ===
    mov rax, 0             ; Clear RAX for scanf
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, a             ; Load address of variable 'a' into RSI (2nd parameter)
    call scanf             ; Call scanf to read integer and store in variable 'a'

    ; === STEP 3: Read second number (b) ===
    mov rax, 0             ; Clear RAX for scanf
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, b             ; Load address of variable 'b' into RSI (2nd parameter)
    call scanf             ; Call scanf to read integer and store in variable 'b'

    ; === STEP 4: Read third number (c) ===
    mov rax, 0             ; Clear RAX for scanf
    mov rdi, in_fmt        ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi, c             ; Load address of variable 'c' into RSI (2nd parameter)
    call scanf             ; Call scanf to read integer and store in variable 'c'

    ; === STEP 5: Find Maximum - Initialize with first number ===
    mov rax, [a]           ; Load value of 'a' into RAX (RAX will hold current maximum)
    mov rbx, [b]           ; Load value of 'b' into RBX for comparison

    ; === STEP 6: Compare 'a' and 'b' ===
    ; Check if b > a (current max)
    cmp rbx, rax           ; Compare RBX (b) with RAX (current max)
    jle skip1              ; Jump to skip1 if RBX <= RAX (b is not greater than current max)
    mov rax, rbx           ; If we reach here, b > a, so update max = b

skip1:
    ; === STEP 7: Compare current maximum with 'c' ===
    mov rcx, [c]           ; Load value of 'c' into RCX for comparison
    cmp rcx, rax           ; Compare RCX (c) with RAX (current maximum)
    jle skip2              ; Jump to skip2 if RCX <= RAX (c is not greater than current max)
    mov rax, rcx           ; If we reach here, c > current max, so update max = c

skip2:
    ; === STEP 8: Print the maximum value ===
    ; At this point, RAX contains the maximum of the three numbers
    mov rdi, out_fmt       ; Load address of output format "%ld is bigger\n" into RDI
    mov rsi, rax           ; Move maximum value from RAX to RSI (2nd parameter for printf)
    mov rax, 0             ; Clear RAX for printf (variadic function requirement)
    call printf            ; Call printf to display the result

    ; === STEP 9: Function epilogue and return ===
    pop rbp                ; Restore base pointer from stack
    mov rax, 0             ; Set return value to 0 (success)
    ret                    ; Return to caller (exit program)



