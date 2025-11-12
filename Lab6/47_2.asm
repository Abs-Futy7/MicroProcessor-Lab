; ========================================
; PROBLEM 2: Rotate Array to Right
; ========================================
; Write a function rotateArray that rotates an array to the right by k positions.
; For example, rotating [1, 2, 3, 4, 5] by 2 positions results in [4, 5, 1, 2, 3].
;
; Input: 
;   - First line: two integers n and k (array size and rotation count)
;   - Second line: n integers (array elements)
;
; Output: 
;   - Array after rotation by k positions to the right
;   - One element per line
;
; Example:
;   Input: n=5, k=2, arr=[1, 2, 3, 4, 5]
;   Output: 4 5 1 2 3
;
; Logic:
;   - If k > n, use k = k % n (effective rotation)
;   - Last k elements move to front
;   - First (n-k) elements shift right
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

section .data
    fmtIn db "%ld", 0       ; input format for single integer
    fmtInPrint db "%ld ", 0 ; output format with space
    fmtTwoInt db "%ld %ld", 0  ; input format for two integers
    newline db 0xA, 0       ; newline character

section .bss
    n resq 1                ; array size
    k resq 1                ; rotation count
    arr resq 1000           ; original array (max 1000 elements)
    temp resq 1000          ; temporary array for rotation

section .text
    global main             ; program entry point

main:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; read n and k (array size and rotation count)
    mov rdi, fmtTwoInt      ; 1st param: format "%ld %ld"
    mov rsi, n              ; 2nd param: address of n
    mov rdx, k              ; 3rd param: address of k
    xor eax, eax            ; eax=0 for scanf
    call scanf              ; read n and k
    
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
    
    ; call rotate function
    mov rdi, arr            ; 1st param: array pointer
    mov rsi, [n]            ; 2nd param: array size
    mov rdx, [k]            ; 3rd param: rotation count
    call rotArr             ; perform rotation
    
    ; print rotated array
    mov rdi, arr            ; 1st param: array pointer
    mov rsi, [n]            ; 2nd param: array size
    call printArr           ; display rotated array
    
    ; exit program
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; exit program


; ========================================
; Function: rotArr (Rotate Array)
; ========================================
; Purpose: Rotate array to the right by k positions
; Parameters:
;   rdi = pointer to array
;   rsi = array size (n)
;   rdx = rotation count (k)
; Algorithm:
;   1. Calculate effective rotation: k = k % n
;   2. Copy last k elements to temp
;   3. Shift first (n-k) elements to right
;   4. Copy temp back to start of array
; Example: [1,2,3,4,5] with k=2 → [4,5,1,2,3]
; ========================================
rotArr:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    push r12                ; save callee-saved registers
    push r13
    push r14
    push r15
    
    ; save parameters
    mov r12, rdi            ; r12 = array pointer
    mov r13, rsi            ; r13 = array size (n)
    mov r14, rdx            ; r14 = rotation count (k)
    
    ; calculate effective rotation: k = k % n
    mov rax, r14            ; rax = k
    xor rdx, rdx            ; clear rdx for division
    div r13                 ; rax = k/n, rdx = k%n
    mov r14, rdx            ; r14 = effective rotation (k % n)
    
    ; check if rotation needed
    cmp r14, 0              ; if k%n == 0
    je .rotDone             ; no rotation needed, exit
    
    ; Step 1: Copy last k elements to temp array
    ; temp[0..k-1] = arr[n-k..n-1]
    mov rcx, r14            ; rcx = k (counter for copying)
    mov rsi, r12            ; rsi = array pointer
    mov rdi, temp           ; rdi = temp array pointer
    mov r15, r13            ; r15 = n
    sub r15, r14            ; r15 = n - k (starting index)
    lea rsi, [r12 + r15*8]  ; rsi = &arr[n-k]
    
.copyLastK:
    test rcx, rcx           ; check if rcx == 0
    jz .copyFirstPt         ; if yes, done copying last k
    mov rax, [rsi]          ; load element from arr[n-k+i]
    mov [rdi], rax          ; store to temp[i]
    add rsi, 8              ; move to next source element
    add rdi, 8              ; move to next destination
    dec rcx                 ; decrement counter
    jmp .copyLastK          ; continue loop
    
.copyFirstPt:
    ; Step 2: Shift first (n-k) elements to the right by k positions
    ; arr[k..n-1] = arr[0..n-k-1]
    mov rcx, r13            ; rcx = n
    sub rcx, r14            ; rcx = n - k (number of elements to shift)
    mov rsi, r12            ; rsi = array start
    mov rdi, r12            ; rdi = array start
    lea rdi, [rdi + r14*8]  ; rdi = &arr[k] (destination)
    
    ; shift from back to front to avoid overwriting
    lea rsi, [rsi + rcx*8 - 8]  ; rsi = &arr[n-k-1] (last element to move)
    lea rdi, [rdi + rcx*8 - 8]  ; rdi = &arr[n-1] (destination)
    
.copyFirstLoop:
    test rcx, rcx           ; check if rcx == 0
    jz .rstrLastK           ; if yes, done shifting
    mov rax, [rsi]          ; load element from source
    mov [rdi], rax          ; store to destination
    sub rsi, 8              ; move to previous source element
    sub rdi, 8              ; move to previous destination
    dec rcx                 ; decrement counter
    jmp .copyFirstLoop      ; continue loop
    
.rstrLastK:
    ; Step 3: Copy temp back to start of array
    ; arr[0..k-1] = temp[0..k-1]
    mov rcx, r14            ; rcx = k (counter)
    mov rsi, temp           ; rsi = temp array pointer
    mov rdi, r12            ; rdi = array start
.copyTempBack:
    test rcx, rcx           ; check if rcx == 0
    jz .rotDone             ; if yes, done
    mov rax, [rsi]          ; load from temp
    mov [rdi], rax          ; store to array
    add rsi, 8              ; next temp element
    add rdi, 8              ; next array position
    dec rcx                 ; decrement counter
    jmp .copyTempBack       ; continue loop
    
.rotDone:
    pop r15                 ; restore callee-saved registers
    pop r14
    pop r13
    pop r12
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function


; ========================================
; Function: printArr (Print Array)
; ========================================
; Purpose: Print all elements of the array
; Parameters:
;   rdi = pointer to array
;   rsi = array size
; Output: Prints array elements with spaces, one per line
; ========================================
printArr:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    push r12                ; save callee-saved registers
    push r13
    
    mov r12, rdi            ; r12 = array pointer
    mov r13, rsi            ; r13 = array size
    xor rbx, rbx            ; rbx = index (0)
    
.printLoop:
    cmp rbx, r13            ; check if printed all elements
    jge .printDone          ; if yes, exit
    
    ; print current element
    mov rdi, fmtInPrint     ; 1st param: format "%ld "
    mov rsi, [r12 + rbx*8]  ; 2nd param: arr[index]
    xor eax, eax            ; eax=0
    call printf             ; print element with space
    
    inc rbx                 ; increment index
    jmp .printLoop          ; continue to next element
    
.printDone:
    pop r13                 ; restore callee-saved registers
    pop r12
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function