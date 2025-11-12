; ========================================
; PROBLEM 3: Average of Elements Above Threshold
; ========================================
; Write a program that takes an array of integers and a threshold value.
; Create a function averageAboveThreshold that returns the average of all 
; elements greater than the threshold. If no such element exists, return 0.
;
; Input: 
;   - First line: two integers n and threshold (array size and threshold value)
;   - Second line: n integers (array elements)
;
; Output: 
;   - Average of elements greater than threshold (2 decimal places)
;   - If no elements exceed threshold, print 0
;
; Example 1:
;   Input: n=5, threshold=5, arr=[4, 9, 2, 10, 7]
;   Output: 8.67
;   Explanation: Elements > 5 are [9, 10, 7], average = (9+10+7)/3 = 8.67
;
; Example 2:
;   Input: n=4, threshold=10, arr=[1, 2, 3, 4]
;   Output: 0
;   Explanation: No elements greater than 10
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

section .data
    fmtIn db "%ld", 0       ; input format for single integer
    fmtInTwo db "%ld %ld", 0  ; input format for two integers
    fmtFlt db "%.2lf", 0xA, 0  ; output format: 2 decimal places
    fmtFltZero db "0", 0xA, 0  ; output string for zero
    zero dq 0.0             ; floating-point zero

section .bss
    n resq 1                ; array size
    threshold resq 1        ; threshold value
    arr resq 1000           ; input array (max 1000 elements)

section .text
    global main             ; program entry point

main:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; read n and threshold
    mov rdi, fmtInTwo       ; 1st param: format "%ld %ld"
    mov rsi, n              ; 2nd param: address of n
    mov rdx, threshold      ; 3rd param: address of threshold
    xor eax, eax            ; eax=0 for scanf
    call scanf              ; read n and threshold
    
    ; read array elements
    mov rcx, [n]            ; load n into rcx (loop counter)
    mov rbx, arr            ; rbx = address of arr[0]

.rdLoop:
    push rcx                ; save loop counter
    push rbx                ; save array pointer
    mov rdi, fmtIn          ; 1st param: input format "%ld"
    mov rsi, rbx            ; 2nd param: current element address
    xor eax, eax            ; eax=0
    call scanf              ; read one element
    pop rbx                 ; restore array pointer
    pop rcx                 ; restore loop counter
    add rbx, 8              ; move to next element (8 bytes)
    loop .rdLoop            ; decrement rcx, repeat if rcx != 0
    
    ; call averageAboveThreshold function
    mov rdi, arr            ; 1st param: array pointer
    mov rsi, [n]            ; 2nd param: array size
    mov rdx, [threshold]    ; 3rd param: threshold value
    call avgAboveThsld      ; calculate average
    
    ; print result (xmm0 contains the average as double)
    movsd xmm1, xmm0        ; move result to xmm1 for printf
    mov rdi, fmtFlt         ; 1st param: format "%.2lf\n"
    mov eax, 1              ; eax=1 (one floating-point argument)
    call printf             ; print average with 2 decimal places
    
    ; exit program
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; exit program


; ========================================
; Function: avgAboveThsld (Average Above Threshold)
; ========================================
; Purpose: Calculate average of all elements greater than threshold
; Parameters:
;   rdi = pointer to array
;   rsi = array size (n)
;   rdx = threshold value
; Returns:
;   xmm0 = average as double (or 0.0 if no elements above threshold)
; Algorithm:
;   1. Iterate through array
;   2. For each element > threshold, add to sum and increment count
;   3. If count > 0, return sum/count
;   4. Else return 0.0
; ========================================
avgAboveThsld:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; save parameters
    mov r12, rdi            ; r12 = array pointer
    mov r13, rsi            ; r13 = array size (n)
    mov r14, rdx            ; r14 = threshold value
    
    ; initialize accumulators
    xorpd xmm0, xmm0        ; xmm0 = sum (0.0 as double)
    xor r15, r15            ; r15 = count of elements > threshold (0)
    xor rbx, rbx            ; rbx = loop index (0)
    
.loop:
    cmp rbx, r13            ; check if processed all elements
    jge .end_loop           ; if yes, exit loop
    
    mov rax, [r12 + rbx*8]  ; rax = arr[index] (current element)
    
    ; check if element > threshold
    cmp rax, r14            ; compare element with threshold
    jle .skip               ; if element <= threshold, skip
    
    ; element is greater than threshold
    add r15, 1              ; increment count
    
    ; convert integer to double and add to sum
    cvtsi2sd xmm1, rax      ; xmm1 = (double)arr[index]
    addsd xmm0, xmm1        ; sum += arr[index]
    
.skip:
    inc rbx                 ; increment loop index
    jmp .loop               ; continue to next element

.end_loop:
    ; calculate average or return 0
    cmp r15, 0              ; check if count == 0
    je .no_elements         ; if no elements above threshold, return 0
    
    ; calculate average: sum / count
    cvtsi2sd xmm1, r15      ; xmm1 = (double)count
    divsd xmm0, xmm1        ; xmm0 = sum / count (average)
    jmp .done               ; exit function
    
.no_elements:
    xorpd xmm0, xmm0        ; xmm0 = 0.0 (no elements above threshold)
    
.done:
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return (result in xmm0)
