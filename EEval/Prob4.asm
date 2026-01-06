; ========================================
; PROBLEM 4: Large Fibonacci with Overflow Detection
; ========================================
; Compute the N-th Fibonacci number recursively. 
; If it exceeds 32-bit unsigned integer range, print 'OVERFLOW'.
;
; Function Prototype: fibonacci_safe
;
; Input: 
;   - A single integer N (0 ≤ N ≤ 50)
;
; Output: 
;   - Nth Fibonacci number or 'OVERFLOW'
;
; Example:
;   Input: 47
;   Output: OVERFLOW
;   (Since F(47) = 2971215073 which exceeds 2^32-1 = 4294967295)
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

section .data
    inFmt db "%ld", 0       ; input format for long integer
    outFmt db "%ld", 0xA, 0 ; output format with newline
    overflowMsg db "OVERFLOW", 0xA, 0  ; overflow message

section .bss
    n resq 1                ; input number

section .text
    global main             ; program entry point

main:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; read input number
    mov rdi, inFmt          ; 1st param: input format "%ld"
    mov rsi, n              ; 2nd param: address of n
    xor eax, eax            ; eax=0 for scanf
    call scanf              ; read n from user
    
    ; call fibonacci_safe function
    mov rdi, [n]            ; 1st param: input number
    call fibonacci_safe     ; compute fibonacci with overflow check
    
    ; check for overflow (rax = -1 indicates overflow)
    cmp rax, -1             ; check if overflow occurred
    je .print_overflow      ; if yes, print overflow message
    
    ; print result
    mov rdi, outFmt         ; 1st param: output format
    mov rsi, rax            ; 2nd param: result from function
    xor eax, eax            ; eax=0
    call printf             ; print result
    jmp .done
    
.print_overflow:
    mov rdi, overflowMsg    ; 1st param: overflow message
    xor eax, eax            ; eax=0
    call printf             ; print "OVERFLOW"

.done:
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    xor eax, eax            ; return 0
    ret                     ; exit program


; ========================================
; Function: fibonacci_safe
; ========================================
; Purpose: Compute N-th Fibonacci number with overflow detection
; Parameters:
;   rdi = N (index)
; Returns:
;   rax = Fibonacci number, or -1 if overflow
; Algorithm:
;   1. Base case: F(0) = 0, F(1) = 1
;   2. Recursive: F(n) = F(n-1) + F(n-2)
;   3. Check if result exceeds 2^32-1 (4294967295)
; ========================================
fibonacci_safe:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    push rbx                ; save callee-saved register
    
    mov rax, rdi            ; rax = N
    
    ; base case: F(0) = 0
    cmp rax, 0
    je .return_zero
    
    ; base case: F(1) = 1
    cmp rax, 1
    je .return_one
    
    ; recursive case: F(n) = F(n-1) + F(n-2)
    push rdi                ; save N
    
    ; compute F(n-1)
    dec rdi                 ; rdi = N-1
    call fibonacci_safe     ; rax = F(n-1)
    cmp rax, -1             ; check for overflow
    je .overflow            ; if overflow, return -1
    
    mov rbx, rax            ; rbx = F(n-1)
    
    ; compute F(n-2)
    mov rdi, [rsp]          ; restore N
    sub rdi, 2              ; rdi = N-2
    call fibonacci_safe     ; rax = F(n-2)
    cmp rax, -1             ; check for overflow
    je .overflow            ; if overflow, return -1
    
    ; add F(n-1) + F(n-2)
    add rax, rbx            ; rax = F(n-1) + F(n-2)
    
    ; check for overflow (if result > 2^32-1 = 4294967295)
    mov rcx, 0xFFFFFFFF     ; rcx = 2^32 - 1 (max 32-bit unsigned)
    cmp rax, rcx            ; compare result with max
    ja .overflow            ; if above, overflow occurred
    
    pop rdi                 ; restore N (clean stack)
    jmp .return
    
.return_zero:
    xor eax, eax            ; return 0
    jmp .return
    
.return_one:
    mov rax, 1              ; return 1
    jmp .return
    
.overflow:
    add rsp, 8              ; clean stack (pop saved N)
    mov rax, -1             ; return -1 to indicate overflow
    
.return:
    pop rbx                 ; restore callee-saved register
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function
