; ========================================
; PROBLEM 2: Second Largest and Second Smallest in Array
; ========================================
; Find the second largest and second smallest numbers from an array 
; using a single function.
;
; Function Prototype: second_min_max
;
; Input: 
;   - First line: N (2 ≤ N ≤ 100)
;   - Second line: N space-separated integers
;
; Output: 
;   - Print the second largest and second smallest separated by a space
;
; Example:
;   Input: N=6, arr=[5, 1, 9, 7, 3, 8]
;   Output: 8 3
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

section .data
    inFmt db "%ld", 0       ; input format for long integer
    outFmt db "%ld %ld", 0xA, 0  ; output format: two numbers

section .bss
    n resq 1                ; size of array
    arr resq 100            ; input array (max 100 elements)

section .text
    global main             ; program entry point

main:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; read array size n
    mov rdi, inFmt          ; 1st param: input format "%ld"
    mov rsi, n              ; 2nd param: address of n
    xor eax, eax            ; eax=0 for scanf
    call scanf              ; read n from user
    
    ; read array elements
    mov rcx, [n]            ; load n into rcx (loop counter)
    mov rbx, arr            ; rbx = address of arr[0]

.read_loop:
    push rcx                ; save loop counter
    push rbx                ; save array pointer
    mov rdi, inFmt          ; 1st param: input format
    mov rsi, rbx            ; 2nd param: current array element address
    xor eax, eax            ; eax=0
    call scanf              ; read one element
    pop rbx                 ; restore array pointer
    pop rcx                 ; restore loop counter
    add rbx, 8              ; move to next element (8 bytes for qword)
    loop .read_loop         ; decrement rcx, repeat if rcx != 0
    
    ; call second_min_max function
    mov rdi, arr            ; 1st param: array pointer
    mov rsi, [n]            ; 2nd param: array size
    call second_min_max     ; find second largest and second smallest
    
    ; print results (rax = second largest, rdx = second smallest)
    mov rdi, outFmt         ; 1st param: output format
    mov rsi, rax            ; 2nd param: second largest
    mov rdx, rdx            ; 3rd param: second smallest (already in rdx)
    xor eax, eax            ; eax=0
    call printf             ; print results

    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    xor eax, eax            ; return 0
    ret                     ; exit program


; ========================================
; Function: second_min_max
; ========================================
; Purpose: Find second largest and second smallest in array
; Parameters:
;   rdi = pointer to array
;   rsi = size of array
; Returns:
;   rax = second largest
;   rdx = second smallest
; Algorithm:
;   1. Initialize largest, second_largest, smallest, second_smallest
;   2. Scan array and update these four values appropriately
; ========================================
second_min_max:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    push rbx                ; save callee-saved registers
    push r12
    push r13
    push r14
    push r15
    
    mov r12, rdi            ; r12 = array pointer
    mov r13, rsi            ; r13 = array size
    
    ; initialize with first two elements
    mov rax, [r12]          ; first element
    mov rbx, [r12+8]        ; second element
    
    ; determine initial largest, second_largest, smallest, second_smallest
    cmp rax, rbx            ; compare first two elements
    jg .first_larger        ; if first > second
    
    ; first <= second
    mov r14, rbx            ; r14 = largest (second element)
    mov r15, rax            ; r15 = second_largest (first element)
    mov r8, rax             ; r8 = smallest (first element)
    mov r9, rbx             ; r9 = second_smallest (second element)
    jmp .scan_loop_init
    
.first_larger:
    mov r14, rax            ; r14 = largest (first element)
    mov r15, rbx            ; r15 = second_largest (second element)
    mov r8, rbx             ; r8 = smallest (second element)
    mov r9, rax             ; r9 = second_smallest (first element)
    
.scan_loop_init:
    mov rcx, 2              ; rcx = current index (start from 3rd element)
    
.scan_loop:
    cmp rcx, r13            ; check if rcx >= array size
    jge .done               ; if yes, exit loop
    
    mov rax, [r12 + rcx*8]  ; rax = current element
    
    ; update largest and second_largest
    cmp rax, r14            ; compare with largest
    jg .new_largest         ; if greater, update largest
    cmp rax, r15            ; compare with second_largest
    jg .new_second_largest  ; if greater, update second_largest
    jmp .check_smallest     ; otherwise, check smallest
    
.new_largest:
    mov r15, r14            ; old largest becomes second_largest
    mov r14, rax            ; new largest
    jmp .check_smallest
    
.new_second_largest:
    mov r15, rax            ; new second_largest
    
.check_smallest:
    ; update smallest and second_smallest
    cmp rax, r8             ; compare with smallest
    jl .new_smallest        ; if less, update smallest
    cmp rax, r9             ; compare with second_smallest
    jl .new_second_smallest ; if less, update second_smallest
    jmp .continue_loop
    
.new_smallest:
    mov r9, r8              ; old smallest becomes second_smallest
    mov r8, rax             ; new smallest
    jmp .continue_loop
    
.new_second_smallest:
    mov r9, rax             ; new second_smallest
    
.continue_loop:
    inc rcx                 ; increment index
    jmp .scan_loop          ; continue loop
    
.done:
    mov rax, r15            ; return second_largest
    mov rdx, r9             ; return second_smallest
    
    pop r15                 ; restore callee-saved registers
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function
