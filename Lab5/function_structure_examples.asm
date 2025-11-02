; ============================================================================
; Program: Function Structure Demonstration
; Description: Comprehensive examples of function structure in NASM assembly
; ============================================================================

extern printf
extern scanf

SECTION .data
    ; Messages
    msg1: db "Enter first number: ", 0
    msg2: db "Enter second number: ", 0
    msg3: db "Enter third number: ", 0
    
    ; Output formats
    result_fmt: db "Result: %ld", 10, 0
    sum_fmt: db "Sum: %ld", 10, 0
    max_fmt: db "Maximum: %ld", 10, 0
    
    ; Input format
    in_fmt: db "%ld", 0

SECTION .bss
    num1: resq 1
    num2: resq 1
    num3: resq 1

SECTION .text
    global main

; ============================================================================
; MAIN FUNCTION
; ============================================================================
main:
    push rbp
    mov rbp, rsp
    
    ; Read three numbers
    mov rdi, msg1
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, num1
    xor rax, rax
    call scanf
    
    mov rdi, msg2
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, num2
    xor rax, rax
    call scanf
    
    mov rdi, msg3
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, num3
    xor rax, rax
    call scanf
    
    ; ========================================
    ; Example 1: Simple function (no register saving needed)
    ; ========================================
    mov rdi, [num1]
    mov rsi, [num2]
    call simple_add
    
    mov rdi, sum_fmt
    mov rsi, rax
    xor rax, rax
    call printf
    
    ; ========================================
    ; Example 2: Function with register preservation
    ; ========================================
    mov rdi, [num1]
    mov rsi, [num2]
    mov rdx, [num3]
    call complex_function
    
    mov rdi, result_fmt
    mov rsi, rax
    xor rax, rax
    call printf
    
    ; ========================================
    ; Example 3: Finding maximum of three numbers
    ; ========================================
    mov rdi, [num1]
    mov rsi, [num2]
    mov rdx, [num3]
    call find_max_three
    
    mov rdi, max_fmt
    mov rsi, rax
    xor rax, rax
    call printf
    
    ; Exit program
    mov rax, 0
    pop rbp
    ret


; ============================================================================
; EXAMPLE 1: SIMPLE FUNCTION (Basic Structure)
; Purpose: Add two numbers
; Parameters: RDI = first number, RSI = second number
; Return: RAX = sum
; ============================================================================
simple_add:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === FUNCTION BODY ===
    ; No need to save registers - only using RAX (caller-saved)
    mov rax, rdi          ; Copy first parameter to RAX
    add rax, rsi          ; Add second parameter
    
    ; === EPILOGUE ===
    pop rbp               ; Restore caller's frame pointer
    ret                   ; Return to caller


; ============================================================================
; EXAMPLE 2: FUNCTION WITH REGISTER PRESERVATION
; Purpose: Complex calculation using multiple registers
; Parameters: RDI = a, RSI = b, RDX = c
; Return: RAX = (a + b) * c
; Note: Uses RBX and R12 (callee-saved), so must preserve them
; ============================================================================
complex_function:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === SAVE CALLEE-SAVED REGISTERS ===
    push rbx              ; We will use RBX
    push r12              ; We will use R12
    
    ; === FUNCTION BODY ===
    mov rbx, rdi          ; Store 'a' in RBX
    mov r12, rsi          ; Store 'b' in R12
    
    ; Calculate (a + b) * c
    add rbx, r12          ; RBX = a + b
    mov rax, rbx          ; Move sum to RAX
    imul rax, rdx         ; RAX = (a + b) * c
    
    ; === RESTORE REGISTERS (in reverse order) ===
    pop r12               ; Restore R12
    pop rbx               ; Restore RBX
    
    ; === EPILOGUE ===
    pop rbp               ; Restore caller's frame pointer
    ret                   ; Return to caller


; ============================================================================
; EXAMPLE 3: FUNCTION WITH MULTIPLE COMPARISONS
; Purpose: Find maximum of three numbers
; Parameters: RDI = num1, RSI = num2, RDX = num3
; Return: RAX = maximum value
; Note: Uses RBX (callee-saved), so must preserve it
; ============================================================================
find_max_three:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === SAVE CALLEE-SAVED REGISTERS ===
    push rbx              ; We will use RBX
    
    ; === FUNCTION BODY ===
    ; Step 1: Find max of first two numbers
    mov rax, rdi          ; Assume first is maximum
    cmp rsi, rax          ; Compare second with current max
    jle .skip1            ; If second <= max, skip
    mov rax, rsi          ; Otherwise, second is new max
.skip1:
    
    ; Step 2: Compare result with third number
    cmp rdx, rax          ; Compare third with current max
    jle .skip2            ; If third <= max, skip
    mov rax, rdx          ; Otherwise, third is new max
.skip2:
    
    ; === RESTORE REGISTERS ===
    pop rbx               ; Restore RBX
    
    ; === EPILOGUE ===
    pop rbp               ; Restore caller's frame pointer
    ret                   ; Return to caller


; ============================================================================
; EXAMPLE 4: FUNCTION USING LEAVE INSTRUCTION
; Purpose: Multiply two numbers (demonstrates alternative epilogue)
; Parameters: RDI = first number, RSI = second number
; Return: RAX = product
; ============================================================================
multiply_numbers:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === FUNCTION BODY ===
    mov rax, rdi          ; Copy first parameter
    imul rax, rsi         ; Multiply by second parameter
    
    ; === EPILOGUE (using leave) ===
    leave                 ; Equivalent to: mov rsp, rbp; pop rbp
    ret                   ; Return to caller


; ============================================================================
; EXAMPLE 5: RECURSIVE FUNCTION
; Purpose: Calculate factorial (demonstrates function calling itself)
; Parameters: RDI = n
; Return: RAX = n!
; Note: Recursive, so careful stack management is crucial
; ============================================================================
factorial:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === SAVE CALLEE-SAVED REGISTERS ===
    push rbx              ; We will use RBX to store n
    
    ; === FUNCTION BODY ===
    ; Base case: if n <= 1, return 1
    cmp rdi, 1
    jg .recursive         ; If n > 1, do recursive case
    mov rax, 1            ; Base case: return 1
    jmp .done
    
.recursive:
    ; Recursive case: n * factorial(n-1)
    mov rbx, rdi          ; Save n in RBX
    dec rdi               ; Calculate n-1
    call factorial        ; Recursive call: factorial(n-1)
    imul rax, rbx         ; Multiply result by n
    
.done:
    ; === RESTORE REGISTERS ===
    pop rbx               ; Restore RBX
    
    ; === EPILOGUE ===
    pop rbp               ; Restore caller's frame pointer
    ret                   ; Return to caller


; ============================================================================
; EXAMPLE 6: FUNCTION WITH LOCAL VARIABLES ON STACK
; Purpose: Demonstrate stack-based local variables
; Parameters: RDI = a, RSI = b
; Return: RAX = calculated result
; ============================================================================
function_with_locals:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === ALLOCATE SPACE FOR LOCAL VARIABLES ===
    sub rsp, 32           ; Reserve 32 bytes for locals (aligned to 16)
    ; [rbp - 8]  = local1
    ; [rbp - 16] = local2
    ; [rbp - 24] = local3
    
    ; === FUNCTION BODY ===
    ; Store parameters in local variables
    mov [rbp - 8], rdi    ; local1 = a
    mov [rbp - 16], rsi   ; local2 = b
    
    ; Calculate: local3 = local1 + local2
    mov rax, [rbp - 8]
    add rax, [rbp - 16]
    mov [rbp - 24], rax
    
    ; Return local3
    mov rax, [rbp - 24]
    
    ; === CLEANUP STACK ===
    mov rsp, rbp          ; Restore stack pointer
    
    ; === EPILOGUE ===
    pop rbp               ; Restore caller's frame pointer
    ret                   ; Return to caller


; ============================================================================
; EXAMPLE 7: FUNCTION THAT DOESN'T MODIFY CALLEE-SAVED REGISTERS
; Purpose: Simple comparison (no register preservation needed)
; Parameters: RDI = a, RSI = b
; Return: RAX = 1 if a > b, else 0
; ============================================================================
is_greater:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === FUNCTION BODY ===
    ; Only uses RAX, RDI, RSI (all caller-saved or parameters)
    xor rax, rax          ; Set RAX to 0 (assume false)
    cmp rdi, rsi          ; Compare a with b
    jle .done             ; If a <= b, done (return 0)
    mov rax, 1            ; If a > b, return 1
.done:
    
    ; === EPILOGUE ===
    pop rbp               ; Restore caller's frame pointer
    ret                   ; Return to caller


; ============================================================================
; EXAMPLE 8: FUNCTION WITH ALL REGISTER PRESERVATION
; Purpose: Demonstrate saving all callee-saved registers
; Parameters: RDI = input
; Return: RAX = result
; ============================================================================
preserve_all_registers:
    ; === PROLOGUE ===
    push rbp              ; Save caller's base pointer
    mov rbp, rsp          ; Establish new stack frame
    
    ; === SAVE ALL CALLEE-SAVED REGISTERS ===
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    ; === FUNCTION BODY ===
    ; Now we can freely use RBX, R12-R15
    mov rbx, rdi
    mov r12, rbx
    mov r13, r12
    mov r14, r13
    mov r15, r14
    mov rax, r15          ; Final result
    
    ; === RESTORE ALL REGISTERS (in reverse order) ===
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    
    ; === EPILOGUE ===
    pop rbp               ; Restore caller's frame pointer
    ret                   ; Return to caller


; ============================================================================
; NOTES AND BEST PRACTICES:
; 
; 1. Always balance push/pop operations
; 2. Restore registers in reverse order of saving
; 3. Callee-saved registers MUST be preserved: RBX, RBP, R12-R15
; 4. Return value always goes in RAX
; 5. Stack must be 16-byte aligned before 'call' instruction
; 6. Use 'leave' instruction for simpler epilogue when appropriate
; 7. Local variables are accessed via [rbp - offset]
; 8. Parameters beyond 6 are passed on stack
; 9. Keep function structure consistent for readability
; 10. Comment your functions with purpose, parameters, and return value
; ============================================================================
