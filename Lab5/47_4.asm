; Program: Matrix Bitwise AND Operation
; Description: Performs bitwise AND on two 3x3 matrices and prints the result

extern printf

SECTION .data
    m1: dq 1 2 3 4                  ; matrix 1 elements
    m2: dq 5 6 7 8                  ; matrix 2 elements
    
    r: dq 3                         ; number of rows
    c: dq 3                         ; number of columns
    t_e: dq 9                       ; total elements (3x3 = 9)
    
    int_out_fmt: db "%ld ", 0       ; format for printing integers
    newline_fmt: db "", 10, 0       ; newline format

SECTION .bss
    m_result: resq 9                ; result matrix storage

SECTION .text
    default rel
    global main

main:
    push rbp
    mov  rbp, rsp
    
    ; call bitwise AND function
    mov  rdi, m1                    ; first matrix
    mov  rsi, m2                    ; second matrix
    mov  rdx, m_result              ; result matrix
    mov  rcx, [t_e]                 ; total elements
    call m_and
    
    ; print the result matrix
    mov  rdi, m_result              ; result matrix
    mov  rsi, [r]                   ; rows
    mov  rdx, [c]                   ; columns
    call print_m
    
    mov  rax, 0
    leave
    ret

; Function: m_and
; Parameters: rdi = matrix1, rsi = matrix2, rdx = result, rcx = total elements
; Returns: nothing (result stored in rdx)
; Performs element-wise bitwise AND operation
m_and:
    push rbp
    mov  rbp, rsp
    xor  rax, rax                   ; counter = 0
loop_start:
    cmp  rax, rcx                   ; check if all elements processed
    jge  loop_done                  ; if yes, exit loop
    mov  r8, [rdi + rax*8]          ; load element from matrix1
    and  r8, [rsi + rax*8]          ; AND with element from matrix2
    mov  [rdx + rax*8], r8          ; store result
    inc  rax                        ; increment counter
    jmp  loop_start
loop_done:
    pop  rbp
    ret

; Function: print_m
; Parameters: rdi = matrix pointer, rsi = rows, rdx = columns
; Returns: nothing
; Prints matrix in row-column format
print_m:
    push rbp
    mov  rbp, rsp
    push r12                        ; save registers
    push r13
    push r14
    push r15
    
    mov  r12, rdi                   ; matrix pointer
    mov  r13, rsi                   ; rows
    mov  r14, rdx                   ; columns
    xor  r15, r15                   ; row counter = 0
    
outer_loop:
    cmp  r15, r13                   ; check if all rows printed
    jge  outer_done
    xor  rbx, rbx                   ; column counter = 0
    
inner_loop:
    cmp  rbx, r14                   ; check if all columns printed
    jge  inner_done
    
    ; calculate array index: row * columns + column
    mov  rax, r15
    mul  r14                        ; rax = row * columns
    add  rax, rbx                   ; rax = row*columns + column
    mov  rsi, [r12 + rax*8]         ; get matrix element
    mov  rdi, int_out_fmt           ; format string
    mov  rax, 0
    call printf
    
    inc  rbx                        ; next column
    jmp  inner_loop
    
inner_done:
    ; print newline after each row
    mov  rdi, newline_fmt
    mov  rax, 0
    call printf
    inc  r15                        ; next row
    jmp  outer_loop
    
outer_done:
    pop  r15                        ; restore registers
    pop  r14
    pop  r13
    pop  r12
    pop  rbp
    ret
