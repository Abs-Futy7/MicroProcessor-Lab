; ========================================
; PROBLEM 1: Recursive Sum of Digits Until Even
; ========================================
; Compute the recursive sum of digits of an integer until the sum becomes 
; an even or a single-digit number.
;
; Function Prototype: even_digital_root
;
; Input: 
;   - A single integer N (0 ≤ N ≤ 10⁹)
;
; Output: 
;   - A single integer — the even number or the single-digit result
;
; Example:
;   Input: 9875
;   Output: 2
;   Explanation: 9+8+7+5 = 29 → 2+9 = 11 → 1+1 = 2 (even)
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

section .data
    inFmt db "%ld", 0       ; input format for long integer
    outFmt db "%ld", 0xA, 0 ; output format with newline

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
    
    ; call even_digital_root function
    mov rdi, [n]            ; 1st param: input number
    call even_digital_root  ; compute even digital root
    
    ; print result
    mov rdi, outFmt         ; 1st param: output format
    mov rsi, rax            ; 2nd param: result from function
    xor eax, eax            ; eax=0
    call printf             ; print result

    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    xor eax, eax            ; return 0
    ret                     ; exit program


; ========================================
; Function: even_digital_root
; ========================================
; Purpose: Recursively sum digits until even or single-digit
; Parameters:
;   rdi = input number
; Returns:
;   rax = even number or single-digit result
; Algorithm:
;   1. Base case: if number < 10, return it
;   2. Base case: if number is even, return it
;   3. Recursive case: sum all digits and recurse
; ========================================
even_digital_root:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    push rbx                ; save callee-saved register
    
    mov rax, rdi            ; rax = input number
    
    ; check if number < 10 (single digit)
    cmp rax, 10             ; compare with 10
    jl .done                ; if less, return it
    
    ; check if number is even
    test rax, 1             ; test lowest bit
    jz .done                ; if even (bit = 0), return it
    
    ; sum all digits
    xor rbx, rbx            ; rbx = sum of digits (0)
    mov rcx, rax            ; rcx = working copy of number
    
.sum_loop:
    cmp rcx, 0              ; check if number is 0
    je .recurse             ; if yes, recurse with sum
    
    xor rdx, rdx            ; clear rdx for division
    mov rax, rcx            ; rax = current number
    mov r8, 10              ; divisor = 10
    div r8                  ; rax = quotient, rdx = remainder (digit)
    
    add rbx, rdx            ; add digit to sum
    mov rcx, rax            ; update number (quotient)
    jmp .sum_loop           ; continue extracting digits
    
.recurse:
    mov rdi, rbx            ; 1st param: sum of digits
    call even_digital_root  ; recursive call
    jmp .return             ; return result from recursive call
    
.done:
    ; rax already contains the result
.return:
    pop rbx                 ; restore callee-saved register
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function
