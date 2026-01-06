; ========================================
; PROBLEM 6: Diamond Pattern
; ========================================
; Print a diamond pattern of stars using nested loops.
;
; Function Prototype: print_diamond
;
; Input: 
;   - A single integer N (1 ≤ N ≤ 10)
;
; Output: 
;   - A diamond pattern of height 2N - 1
;
; Example:
;   Input: 3
;   Output:
;     *      (2 spaces, 1 star)
;    ***     (1 space, 3 stars)
;   *****    (0 spaces, 5 stars)
;    ***     (1 space, 3 stars)
;     *      (2 spaces, 1 star)
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

section .data
    inFmt db "%ld", 0       ; input format for long integer
    space db " ", 0         ; space character
    star db "*", 0          ; star character
    newline db 0xA, 0       ; newline character

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
    
    ; call print_diamond function
    mov rdi, [n]            ; 1st param: input number
    call print_diamond      ; print diamond pattern

    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    xor eax, eax            ; return 0
    ret                     ; exit program


; ========================================
; Function: print_diamond
; ========================================
; Purpose: Print diamond pattern of stars
; Parameters:
;   rdi = N (size)
; Algorithm:
;   1. Upper half (including middle): i from 1 to N
;      - Print (N-i) spaces
;      - Print (2*i-1) stars
;   2. Lower half: i from N-1 down to 1
;      - Print (N-i) spaces
;      - Print (2*i-1) stars
; ========================================
print_diamond:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    push rbx                ; save callee-saved registers
    push r12
    push r13
    
    mov r12, rdi            ; r12 = N
    
    ; upper half (including middle)
    mov r13, 1              ; r13 = i (current row, starts at 1)
    
.upper_loop:
    cmp r13, r12            ; check if i > N
    jg .lower_half          ; if yes, move to lower half
    
    ; print spaces: (N - i) spaces
    mov rbx, r12            ; rbx = N
    sub rbx, r13            ; rbx = N - i
    
.space_loop_upper:
    cmp rbx, 0              ; check if no more spaces
    jle .stars_upper        ; if yes, print stars
    
    push r13                ; save i
    push rbx                ; save space count
    mov rdi, space          ; 1st param: " "
    xor eax, eax            ; eax=0
    call printf             ; print space
    pop rbx                 ; restore space count
    pop r13                 ; restore i
    
    dec rbx                 ; space_count--
    jmp .space_loop_upper
    
.stars_upper:
    ; print stars: (2*i - 1) stars
    mov rbx, r13            ; rbx = i
    shl rbx, 1              ; rbx = 2*i
    dec rbx                 ; rbx = 2*i - 1
    
.star_loop_upper:
    cmp rbx, 0              ; check if no more stars
    jle .newline_upper      ; if yes, print newline
    
    push r13                ; save i
    push rbx                ; save star count
    mov rdi, star           ; 1st param: "*"
    xor eax, eax            ; eax=0
    call printf             ; print star
    pop rbx                 ; restore star count
    pop r13                 ; restore i
    
    dec rbx                 ; star_count--
    jmp .star_loop_upper
    
.newline_upper:
    push r13                ; save i
    mov rdi, newline        ; 1st param: "\n"
    xor eax, eax            ; eax=0
    call printf             ; print newline
    pop r13                 ; restore i
    
    inc r13                 ; i++
    jmp .upper_loop
    
.lower_half:
    ; lower half: i from N-1 down to 1
    mov r13, r12            ; r13 = N
    dec r13                 ; r13 = N - 1
    
.lower_loop:
    cmp r13, 0              ; check if i < 1
    jle .done               ; if yes, exit
    
    ; print spaces: (N - i) spaces
    mov rbx, r12            ; rbx = N
    sub rbx, r13            ; rbx = N - i
    
.space_loop_lower:
    cmp rbx, 0              ; check if no more spaces
    jle .stars_lower        ; if yes, print stars
    
    push r13                ; save i
    push rbx                ; save space count
    mov rdi, space          ; 1st param: " "
    xor eax, eax            ; eax=0
    call printf             ; print space
    pop rbx                 ; restore space count
    pop r13                 ; restore i
    
    dec rbx                 ; space_count--
    jmp .space_loop_lower
    
.stars_lower:
    ; print stars: (2*i - 1) stars
    mov rbx, r13            ; rbx = i
    shl rbx, 1              ; rbx = 2*i
    dec rbx                 ; rbx = 2*i - 1
    
.star_loop_lower:
    cmp rbx, 0              ; check if no more stars
    jle .newline_lower      ; if yes, print newline
    
    push r13                ; save i
    push rbx                ; save star count
    mov rdi, star           ; 1st param: "*"
    xor eax, eax            ; eax=0
    call printf             ; print star
    pop rbx                 ; restore star count
    pop r13                 ; restore i
    
    dec rbx                 ; star_count--
    jmp .star_loop_lower
    
.newline_lower:
    push r13                ; save i
    mov rdi, newline        ; 1st param: "\n"
    xor eax, eax            ; eax=0
    call printf             ; print newline
    pop r13                 ; restore i
    
    dec r13                 ; i--
    jmp .lower_loop
    
.done:
    pop r13                 ; restore callee-saved registers
    pop r12
    pop rbx
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function
