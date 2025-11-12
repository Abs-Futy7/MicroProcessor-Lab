; ========================================
; PROBLEM 1: Count Frequency of Array Elements
; ========================================
; Write a function countFrequency that takes an array of integers and returns 
; a new array of pairs, where each pair contains a unique number and its frequency.
;
; Input: 
;   - First line: integer n (size of array)
;   - Second line: n integers (array elements)
;
; Output: 
;   - Pairs of numbers (unique number, frequency)
;   - Printed in ascending order of unique numbers
;   - One pair per line
;
; Example:
;   Input: n=8, arr=[5, 2, 5, 1, 2, 5, 3, 2]
;   Output: 1 1
;           2 3
;           3 1
;           5 3
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input
extern qsort                ; external C function for sorting

section .data
    inFmt db "%ld", 0       ; input format for long integer
    outFmt db "%ld %ld", 0xA, 0  ; output format: number frequency
    newline db 0xA, 0       ; newline character

section .bss
    n resq 1                ; size of array
    arr resq 1000           ; original input array (max 1000 elements)
    freq resq 1000          ; frequency array (stores count for each unique)
    sorted resq 1000        ; sorted unique numbers array

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
    
    ; call countFrequency function
    mov rdi, arr            ; 1st param: array pointer
    mov rsi, [n]            ; 2nd param: array size
    call cntFreq            ; process frequency counting
    
    ; print frequency pairs
    call printFreqPair      ; display results

    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; exit program


; ========================================
; Function: cntFreq (Count Frequency)
; ========================================
; Purpose: Count frequency of each unique element in array
; Parameters:
;   rdi = pointer to array
;   rsi = size of array
; Process:
;   1. Sort the array
;   2. Count consecutive duplicate elements
;   3. Store unique numbers and their frequencies
; Returns:
;   Arrays 'sorted' and 'freq' are populated
;   rbx = number of unique elements
; ========================================
cntFreq:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    sub rsp, 32             ; allocate 32 bytes for local variables
    
    ; save parameters to local variables
    mov [rbp-8], rdi        ; save array pointer
    mov [rbp-16], rsi       ; save array size
    
    ; sort the array using qsort (ascending order)
    mov rdi, [rbp-8]        ; 1st param: array pointer
    mov rsi, [rbp-16]       ; 2nd param: number of elements
    mov rdx, 8              ; 3rd param: size of each element (8 bytes)
    mov rcx, compare        ; 4th param: comparison function pointer
    call qsort              ; sort array in ascending order
    
    ; initialize registers for frequency counting
    mov r12, [rbp-8]        ; r12 = sorted array pointer
    mov r13, [rbp-16]       ; r13 = array size
    mov r14, freq           ; r14 = frequency array pointer
    mov r15, sorted         ; r15 = unique numbers array pointer
    xor rbx, rbx            ; rbx = unique count (0)
    xor rcx, rcx            ; rcx = current index in array (0)
    
.cntLoop:
    cmp rcx, r13            ; check if rcx >= array size
    jge .cntDone            ; if yes, exit loop
    
    mov rax, [r12 + rcx*8]  ; rax = current array element (arr[rcx])
    mov rdx, 1              ; rdx = frequency counter, start at 1
    
    ; count consecutive duplicates
    mov r8, rcx             ; r8 = index for checking next elements
    inc r8                  ; start from next element
.findCon:
    cmp r8, r13             ; check if r8 >= array size
    jge .strFreq            ; if yes, no more elements to check
    mov r9, [r12 + r8*8]    ; r9 = arr[r8]
    cmp rax, r9             ; compare current with next element
    jne .strFreq            ; if different, stop counting
    inc rdx                 ; increment frequency counter
    inc r8                  ; move to next element
    jmp .findCon            ; continue checking
    
.strFreq:
    ; store unique number and its frequency
    mov [r15 + rbx*8], rax  ; sorted[unique_count] = unique number
    mov [r14 + rbx*8], rdx  ; freq[unique_count] = frequency
    inc rbx                 ; increment unique counter
    
    ; skip all counted duplicates
    mov rcx, r8             ; move index to first uncounted element
    jmp .cntLoop            ; continue with next unique number
    
.cntDone:
    mov [rbp-24], rbx       ; save unique count
    
    ; sort unique numbers (already sorted from qsort above)
    mov rdi, r15            ; 1st param: sorted array
    mov rsi, rbx            ; 2nd param: unique count
    mov rdx, 8              ; 3rd param: element size
    mov rcx, compare        ; 4th param: comparison function
    call qsort              ; ensure ascending order
    
    mov rax, r15            ; return pointer to sorted unique numbers
    mov rdx, r14            ; return pointer to frequencies
    mov rcx, [rbp-24]       ; return unique count
    
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function


; ========================================
; Function: printFreqPair
; ========================================
; Purpose: Print each unique number with its frequency
; Parameters: None (uses global arrays 'sorted' and 'freq')
; Output: Prints "number frequency" pairs, one per line
; ========================================
printFreqPair:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; initialize registers for printing
    mov r15, sorted         ; r15 = pointer to unique numbers array
    mov r14, freq           ; r14 = pointer to frequency array
    mov r13, rbx            ; r13 = total unique count
    xor r12, r12            ; r12 = current index (0)
    
.printLoop:
    cmp r12, r13            ; check if printed all pairs
    jge .printDone          ; if yes, exit
    
    ; print "number frequency" pair
    mov rdi, outFmt         ; 1st param: output format "%ld %ld\n"
    mov rsi, [r15 + r12*8]  ; 2nd param: unique number
    mov rdx, [r14 + r12*8]  ; 3rd param: frequency
    xor eax, eax            ; eax=0
    call printf             ; print pair
    
    inc r12                 ; increment index
    jmp .printLoop          ; continue to next pair
    
.printDone:
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function


; ========================================
; Function: compare
; ========================================
; Purpose: Comparison function for qsort (ascending order)
; Parameters:
;   rdi = pointer to first element
;   rsi = pointer to second element
; Returns:
;   eax = -1 if *rdi < *rsi (first is smaller)
;   eax = 0  if *rdi == *rsi (equal)
;   eax = 1  if *rdi > *rsi (first is greater)
; ========================================
compare:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    mov rax, [rdi]          ; rax = value of first element
    mov rdx, [rsi]          ; rdx = value of second element
    
    cmp rax, rdx            ; compare first with second
    jl .less                ; if first < second, jump to less
    jg .greater             ; if first > second, jump to greater
    xor eax, eax            ; else they're equal, return 0
    jmp .done               ; exit
.less:
    mov eax, -1             ; return -1 (first is smaller)
    jmp .done               ; exit
.greater:
    mov eax, 1              ; return 1 (first is greater)
.done:
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function