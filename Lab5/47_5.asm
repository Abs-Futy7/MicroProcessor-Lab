; Program: Student Grade Calculator
; Description: Calculates average of 3 scores and assigns grade (P/F based on >= 50)

extern printf
extern scanf

SECTION .data
in_str_fmt:    db "%s", 0           ; string input format
in_int_fmt:    db "%ld", 0          ; integer input format
out_fmt:       db "Student: %s, Average: %ld, Grade: %c", 10, 0

msg_name:      db "Enter student name: ", 0
msg1:          db "Enter score 1: ", 0
msg2:          db "Enter score 2: ", 0
msg3:          db "Enter score 3: ", 0

SECTION .bss
name:          resb 50               ; student name buffer
score1:        resq 1                ; first score
score2:        resq 1                ; second score
score3:        resq 1                ; third score
avg:           resq 1                ; average score
grade:         resb 1                ; grade (P or F)

SECTION .text
global main
main:
    push rbp

    ; read student name
    mov rdi, msg_name
    xor rax, rax
    call printf

    mov rdi, in_str_fmt
    mov rsi, name
    xor rax, rax
    call scanf

    ; read score 1
    mov rdi, msg1
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    mov rsi, score1
    xor rax, rax
    call scanf

    ; read score 2
    mov rdi, msg2
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    mov rsi, score2
    xor rax, rax
    call scanf

    ; read score 3
    mov rdi, msg3
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    mov rsi, score3
    xor rax, rax
    call scanf

    ; calculate average: (score1 + score2 + score3) / 3
    mov rax, [score1]
    add rax, [score2]
    add rax, [score3]               ; rax = sum of all scores
    mov rbx, 3
    cqo                             ; sign-extend rax to rdx:rax
    idiv rbx                        ; rax = sum / 3
    mov [avg], rax                  ; store average

    ; determine grade based on average
    cmp rax, 50                     ; compare average with 50
    jae pass                        ; if average >= 50, pass
    mov byte [grade], 'F'           ; else, grade = F
    jmp print

pass:
    mov byte [grade], 'P'           ; grade = P

print:
    ; print result: name, average, and grade
    mov rdi, out_fmt
    mov rsi, name                   ; student name
    mov rdx, [avg]                  ; average
    movzx rcx, byte [grade]         ; grade (zero-extend byte to qword)
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret
