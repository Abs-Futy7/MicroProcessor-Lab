# Microprocessor Lab - Midterm Practice Questions

## Question Pattern Analysis

Based on your labs, the questions follow these patterns:
1. **Basic Arithmetic** - Addition, subtraction, multiplication, division
2. **Input/Output** - Reading from user, printing results
3. **Conditional Logic** - Comparisons, finding max/min
4. **Loops** - Counting loops, while loops, array traversal
5. **Functions** - Creating custom functions, parameter passing
6. **String Operations** - String reversal, length calculation
7. **Arrays** - Array operations, matrix operations
8. **Mathematical Formulas** - Sum series, factorial, GCD

---

## Section 1: Basic Arithmetic Operations

### Question 1: Subtraction Program
**Write an assembly program that:**
- Reads two numbers a and b
- Calculates difference = a - b
- Prints "a - b = difference"

**Answer:**
```assembly
extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

SECTION .data
a: dq 0                     ; first number (quadword = 8 bytes)
b: dq 0                     ; second number
diff: dq 0                  ; store difference result
enter: db "Enter two numbers: ", 0  ; prompt message (null-terminated)
out_fmt: db "%ld - %ld = %ld", 10, 0  ; output format (%ld = long decimal)
out_fmt_2: db "%s", 10, 0   ; string format with newline
in_fmt: db "%ld", 0         ; input format for long integer

SECTION .text
global main                 ; make main visible to linker
main:
    push rbp                ; save base pointer
    
    ; print prompt message
    mov rax, 0              ; rax=0 (no vector registers for printf)
    mov rdi, out_fmt_2      ; 1st param: format string pointer
    mov rsi, enter          ; 2nd param: message to print
    call printf             ; call printf function
    
    ; read first number from user
    mov rax, 0              ; rax=0 for scanf
    mov rdi, in_fmt         ; 1st param: input format "%ld"
    mov rsi, a              ; 2nd param: address to store input
    call scanf              ; read value into 'a'
    
    ; read second number from user
    mov rax, 0              ; rax=0 for scanf
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, b              ; 2nd param: address to store input
    call scanf              ; read value into 'b'
    
    ; calculate difference a - b
    mov rax, [a]            ; load value of a into rax
    mov rbx, [b]            ; load value of b into rbx
    sub rax, rbx            ; rax = rax - rbx (a - b)
    mov [diff], rax         ; store result in diff variable
    
    ; print result in format "a - b = diff"
    mov rdi, out_fmt        ; 1st param: format string
    mov rsi, [a]            ; 2nd param: value of a
    mov rdx, [b]            ; 3rd param: value of b
    mov rcx, [diff]         ; 4th param: difference value
    mov rax, 0              ; rax=0 for printf
    call printf             ; display result
    
    pop rbp                 ; restore base pointer
    mov rax, 0              ; return 0 (success)
    ret                     ; return from main
```

---

### Question 2: Expression Calculation
**Write a program to calculate: 5a - 3b + 2c**

**Answer:**
```assembly
extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

SECTION .data
a: dq 0                     ; first number variable
b: dq 0                     ; second number variable
c: dq 0                     ; third number variable
result: dq 0                ; store final result
in_fmt: db "%ld", 0         ; input format string
out_fmt: db "5a - 3b + 2c = %ld", 10, 0  ; output format
msg: db "Enter three numbers: ", 0  ; prompt message
msg_fmt: db "%s", 0         ; string format

SECTION .text
global main                 ; entry point
main:
    push rbp                ; save base pointer
    
    ; display prompt to user
    mov rdi, msg_fmt        ; 1st param: string format
    mov rsi, msg            ; 2nd param: message text
    xor rax, rax            ; rax=0 (same as mov rax, 0)
    call printf             ; print prompt
    
    ; read first number (a)
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, a              ; 2nd param: address of variable a
    xor rax, rax            ; rax=0
    call scanf              ; read into a
    
    ; read second number (b)
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, b              ; 2nd param: address of variable b
    xor rax, rax            ; rax=0
    call scanf              ; read into b
    
    ; read third number (c)
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, c              ; 2nd param: address of variable c
    xor rax, rax            ; rax=0
    call scanf              ; read into c
    
    ; calculate expression: 5a - 3b + 2c
    mov rax, [a]            ; load a into rax
    imul rax, 5             ; rax = a * 5 (multiply a by 5)
    
    mov rbx, [b]            ; load b into rbx
    imul rbx, 3             ; rbx = b * 3 (multiply b by 3)
    sub rax, rbx            ; rax = 5a - 3b
    
    mov rcx, [c]            ; load c into rcx
    imul rcx, 2             ; rcx = c * 2 (multiply c by 2)
    add rax, rcx            ; rax = 5a - 3b + 2c
    
    mov [result], rax       ; store final result
    
    ; print result
    mov rdi, out_fmt        ; 1st param: output format
    mov rsi, [result]       ; 2nd param: result value
    xor rax, rax            ; rax=0
    call printf             ; display result
    
    pop rbp                 ; restore base pointer
    mov rax, 0              ; return 0
    ret                     ; exit program
```

---

## Section 2: Conditional Logic

### Question 3: Minimum of Three Numbers
**Write a program to find the minimum of three numbers.**

**Answer:**
```assembly
extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

SECTION .data
a: dq 0                     ; first number
b: dq 0                     ; second number
c: dq 0                     ; third number
in_fmt: db "%ld", 0         ; input format for long integer
out_fmt: db "Minimum is: %ld", 10, 0  ; output format
msg: db "Enter three numbers: ", 0  ; prompt message
msg_fmt: db "%s", 0         ; string format

SECTION .text
global main                 ; program entry point
main:
    push rbp                ; save base pointer
    
    ; print prompt message
    mov rdi, msg_fmt        ; 1st param: string format
    mov rsi, msg            ; 2nd param: prompt text
    xor rax, rax            ; rax=0
    call printf             ; display prompt
    
    ; read first number
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, a              ; 2nd param: address of a
    xor rax, rax            ; rax=0
    call scanf              ; read value into a
    
    ; read second number
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, b              ; 2nd param: address of b
    xor rax, rax            ; rax=0
    call scanf              ; read value into b
    
    ; read third number
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, c              ; 2nd param: address of c
    xor rax, rax            ; rax=0
    call scanf              ; read value into c
    
    ; find minimum of three numbers
    mov rax, [a]            ; assume a is minimum, load into rax
    mov rbx, [b]            ; load b into rbx for comparison
    cmp rbx, rax            ; compare b with current min
    jge skip1               ; if b >= min, skip (keep rax as min)
    mov rax, rbx            ; else b is smaller, update min to b
skip1:
    mov rcx, [c]            ; load c into rcx
    cmp rcx, rax            ; compare c with current min
    jge skip2               ; if c >= min, skip (keep rax as min)
    mov rax, rcx            ; else c is smaller, update min to c
skip2:
    
    ; print minimum value
    mov rdi, out_fmt        ; 1st param: output format
    mov rsi, rax            ; 2nd param: minimum value
    xor rax, rax            ; rax=0
    call printf             ; display result
    
    pop rbp                 ; restore base pointer
    mov rax, 0              ; return 0
    ret                     ; exit program
```

---

### Question 4: Even or Odd Checker
**Write a program to check if a number is even or odd.**

**Answer:**
```assembly
extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

SECTION .data
n: dq 0                     ; number to check
in_fmt: db "%ld", 0         ; input format
msg: db "Enter a number: ", 0  ; prompt message
msg_fmt: db "%s", 0         ; string format
even_msg: db "%ld is Even", 10, 0  ; message for even numbers
odd_msg: db "%ld is Odd", 10, 0    ; message for odd numbers

SECTION .text
global main                 ; program entry point
main:
    push rbp                ; save base pointer
    
    ; print prompt and read number
    mov rdi, msg_fmt        ; 1st param: string format
    mov rsi, msg            ; 2nd param: prompt message
    xor rax, rax            ; rax=0
    call printf             ; display prompt
    
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, n              ; 2nd param: address of n
    xor rax, rax            ; rax=0
    call scanf              ; read number
    
    ; check if number is even or odd using modulo
    mov rax, [n]            ; load number into rax
    mov rbx, 2              ; divisor = 2
    xor rdx, rdx            ; clear rdx (will hold remainder)
    div rbx                 ; rax = n/2, rdx = n%2 (remainder)
    
    cmp rdx, 0              ; compare remainder with 0
    jne odd                 ; if remainder != 0, jump to odd
    
    ; number is even (remainder = 0)
    mov rdi, even_msg       ; 1st param: even message format
    mov rsi, [n]            ; 2nd param: the number
    xor rax, rax            ; rax=0
    call printf             ; print "n is Even"
    jmp done                ; skip odd section
    
odd:
    ; number is odd (remainder = 1)
    mov rdi, odd_msg        ; 1st param: odd message format
    mov rsi, [n]            ; 2nd param: the number
    xor rax, rax            ; rax=0
    call printf             ; print "n is Odd"
    
done:
    pop rbp                 ; restore base pointer
    mov rax, 0              ; return 0
    ret                     ; exit program
```

---

## Section 3: Loop Problems

### Question 5: Print Numbers from 1 to N
**Write a program to print all numbers from 1 to n.**

**Answer:**
```assembly
extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

SECTION .data
n: dq 0                     ; upper limit for printing
counter: dq 1               ; loop counter, starts at 1
in_fmt: db "%ld", 0         ; input format
out_fmt: db "%ld ", 0       ; output format (with space)
msg: db "Enter n: ", 0      ; prompt message
msg_fmt: db "%s", 0         ; string format
newline: db "", 10, 0       ; newline character

SECTION .text
global main                 ; program entry point
main:
    push rbp                ; save base pointer
    
    ; read upper limit n
    mov rdi, msg_fmt        ; 1st param: string format
    mov rsi, msg            ; 2nd param: prompt
    xor rax, rax            ; rax=0
    call printf             ; display prompt
    
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, n              ; 2nd param: address of n
    xor rax, rax            ; rax=0
    call scanf              ; read n
    
    mov qword [counter], 1  ; initialize counter to 1
    
loop_start:
    ; print current counter value
    mov rdi, out_fmt        ; 1st param: output format
    mov rsi, [counter]      ; 2nd param: current counter
    xor rax, rax            ; rax=0
    call printf             ; print counter value
    
    ; increment counter
    mov rax, [counter]      ; load counter into rax
    inc rax                 ; rax = rax + 1 (increment)
    mov [counter], rax      ; save incremented value
    
    ; check if counter <= n
    mov rbx, [n]            ; load n into rbx
    cmp rax, rbx            ; compare counter with n
    jle loop_start          ; if counter <= n, continue loop
    
    ; print newline after all numbers
    mov rdi, newline        ; 1st param: newline string
    xor rax, rax            ; rax=0
    call printf             ; print newline
    
    pop rbp                 ; restore base pointer
    mov rax, 0              ; return 0
    ret                     ; exit program
```

---

### Question 6: Sum of Even Numbers from 1 to N
**Write a program to calculate sum of all even numbers from 1 to n.**

**Answer:**
```assembly
extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

SECTION .data
n: dq 0                     ; upper limit
counter: dq 2               ; counter starts at 2 (first even)
sum: dq 0                   ; accumulator for sum
in_fmt: db "%ld", 0         ; input format
out_fmt: db "Sum of even numbers = %ld", 10, 0  ; output format
msg: db "Enter n: ", 0      ; prompt message
msg_fmt: db "%s", 0         ; string format

SECTION .text
global main                 ; program entry point
main:
    push rbp                ; save base pointer
    
    ; read upper limit n
    mov rdi, msg_fmt        ; 1st param: string format
    mov rsi, msg            ; 2nd param: prompt
    xor rax, rax            ; rax=0
    call printf             ; display prompt
    
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, n              ; 2nd param: address of n
    xor rax, rax            ; rax=0
    call scanf              ; read n
    
    mov qword [counter], 2  ; start with first even number (2)
    mov qword [sum], 0      ; initialize sum to 0
    
loop_start:
    mov rax, [counter]      ; load current counter
    mov rbx, [n]            ; load n
    cmp rax, rbx            ; compare counter with n
    jg loop_end             ; if counter > n, exit loop
    
    ; add current even number to sum
    mov rcx, [sum]          ; load current sum into rcx
    add rcx, rax            ; add counter to sum
    mov [sum], rcx          ; store updated sum
    
    ; increment counter by 2 (next even number)
    add rax, 2              ; rax = rax + 2 (2→4→6→8...)
    mov [counter], rax      ; save next even number
    jmp loop_start          ; repeat loop
    
loop_end:
    ; print final sum
    mov rdi, out_fmt        ; 1st param: output format
    mov rsi, [sum]          ; 2nd param: sum value
    xor rax, rax            ; rax=0
    call printf             ; display result
    
    pop rbp                 ; restore base pointer
    mov rax, 0              ; return 0
    ret                     ; exit program
```

---

### Question 7: Factorial Using Loop
**Write a program to calculate factorial of n using a loop.**

**Answer:**
```assembly
extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

SECTION .data
n: dq 0                     ; input number for factorial
fact: dq 1                  ; factorial result, initialized to 1
counter: dq 1               ; loop counter starting at 1
in_fmt: db "%ld", 0         ; input format
out_fmt: db "Factorial of %ld = %ld", 10, 0  ; output format
msg: db "Enter n: ", 0      ; prompt message
msg_fmt: db "%s", 0         ; string format

SECTION .text
global main                 ; program entry point
main:
    push rbp                ; save base pointer
    
    ; read number n
    mov rdi, msg_fmt        ; 1st param: string format
    mov rsi, msg            ; 2nd param: prompt
    xor rax, rax            ; rax=0
    call printf             ; display prompt
    
    mov rdi, in_fmt         ; 1st param: input format
    mov rsi, n              ; 2nd param: address of n
    xor rax, rax            ; rax=0
    call scanf              ; read n
    
    mov qword [fact], 1     ; initialize factorial = 1
    mov qword [counter], 1  ; initialize counter = 1
    
loop_start:
    mov rax, [counter]      ; load counter into rax
    mov rbx, [n]            ; load n into rbx
    cmp rax, rbx            ; compare counter with n
    jg loop_end             ; if counter > n, exit loop
    
    ; multiply factorial by counter
    mov rcx, [fact]         ; load current factorial
    imul rcx, rax           ; rcx = fact * counter
    mov [fact], rcx         ; store updated factorial
    
    ; increment counter
    inc rax                 ; rax = rax + 1
    mov [counter], rax      ; save incremented counter
    jmp loop_start          ; repeat loop
    
loop_end:
    ; print result: "Factorial of n = fact"
    mov rdi, out_fmt        ; 1st param: output format
    mov rsi, [n]            ; 2nd param: n value
    mov rdx, [fact]         ; 3rd param: factorial value
    xor rax, rax            ; rax=0
    call printf             ; display result
    
    pop rbp                 ; restore base pointer
    mov rax, 0              ; return 0
    ret                     ; exit program
```

---

## Section 4: Mathematical Problems

### Question 8: Power Function (a^b)
**Write a program to calculate a raised to power b.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
a: dq 0
b: dq 0
result: dq 1
counter: dq 0
in_fmt: db "%ld", 0
out_fmt: db "%ld ^ %ld = %ld", 10, 0
msg: db "Enter base and exponent: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main
main:
    push rbp
    
    ; read a and b
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, a
    xor rax, rax
    call scanf
    
    mov rdi, in_fmt
    mov rsi, b
    xor rax, rax
    call scanf
    
    mov qword [result], 1
    mov qword [counter], 0
    
loop_start:
    mov rax, [counter]
    mov rbx, [b]
    cmp rax, rbx
    jge loop_end
    
    ; result *= a
    mov rcx, [result]
    mov rdx, [a]
    imul rcx, rdx
    mov [result], rcx
    
    ; counter++
    mov rax, [counter]
    inc rax
    mov [counter], rax
    jmp loop_start
    
loop_end:
    ; print result
    mov rdi, out_fmt
    mov rsi, [a]
    mov rdx, [b]
    mov rcx, [result]
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

### Question 9: Sum of Squares (1² + 2² + 3² + ... + n²)
**Write a program to calculate sum of squares from 1 to n.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
n: dq 0
sum: dq 0
counter: dq 1
in_fmt: db "%ld", 0
out_fmt: db "Sum of squares = %ld", 10, 0
msg: db "Enter n: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main
main:
    push rbp
    
    ; read n
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf
    
    mov qword [sum], 0
    mov qword [counter], 1
    
loop_start:
    mov rax, [counter]
    mov rbx, [n]
    cmp rax, rbx
    jg loop_end
    
    ; calculate square: counter * counter
    imul rax, rax
    
    ; add to sum
    mov rcx, [sum]
    add rcx, rax
    mov [sum], rcx
    
    ; counter++
    mov rax, [counter]
    inc rax
    mov [counter], rax
    jmp loop_start
    
loop_end:
    ; print result
    mov rdi, out_fmt
    mov rsi, [sum]
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

## Section 5: Function-Based Problems

### Question 10: Subtraction Function
**Write a program with a function to subtract two numbers.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
a: dq 0
b: dq 0
result: dq 0
in_fmt: db "%ld", 0
out_fmt: db "Result: %ld", 10, 0
msg: db "Enter two numbers: ", 0
msg_fmt: db "%s", 0

SECTION .bss

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    
    ; read inputs
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, a
    xor rax, rax
    call scanf
    
    mov rdi, in_fmt
    mov rsi, b
    xor rax, rax
    call scanf
    
    ; call subtract function
    mov rdi, [a]
    mov rsi, [b]
    call subtract
    mov [result], rax
    
    ; print result
    mov rdi, out_fmt
    mov rsi, [result]
    xor rax, rax
    call printf
    
    mov rax, 0
    pop rbp
    ret

; Function: subtract
; Parameters: rdi = a, rsi = b
; Return: rax = a - b
subtract:
    push rbp
    mov rbp, rsp
    mov rax, rdi
    sub rax, rsi
    pop rbp
    ret
```

---

### Question 11: Function to Check Positive/Negative
**Write a function that returns 1 if number is positive, 0 if negative.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
n: dq 0
in_fmt: db "%ld", 0
pos_msg: db "%ld is Positive", 10, 0
neg_msg: db "%ld is Negative", 10, 0
msg: db "Enter a number: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main

main:
    push rbp
    
    ; read number
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf
    
    ; call check function
    mov rdi, [n]
    call is_positive
    
    cmp rax, 1
    je positive
    
    ; negative
    mov rdi, neg_msg
    mov rsi, [n]
    xor rax, rax
    call printf
    jmp done
    
positive:
    mov rdi, pos_msg
    mov rsi, [n]
    xor rax, rax
    call printf
    
done:
    pop rbp
    mov rax, 0
    ret

; Function: is_positive
; Parameters: rdi = number
; Return: rax = 1 if positive, 0 if negative
is_positive:
    push rbp
    mov rbp, rsp
    xor rax, rax        ; assume negative (return 0)
    cmp rdi, 0
    jl done_check       ; if n < 0, return 0
    mov rax, 1          ; else return 1
done_check:
    pop rbp
    ret
```

---

## Section 6: Array Problems

### Question 12: Sum of Array Elements
**Write a program to calculate sum of 5 array elements.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
size: dq 5
sum: dq 0
counter: dq 0
in_fmt: db "%ld", 0
out_fmt: db "Sum = %ld", 10, 0
msg: db "Enter 5 numbers: ", 0
msg_fmt: db "%s", 0

SECTION .bss
arr: resq 5

SECTION .text
global main
main:
    push rbp
    
    ; print message
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    ; read array elements
    mov qword [counter], 0
read_loop:
    mov rax, [counter]
    cmp rax, [size]
    jge read_done
    
    mov rdi, in_fmt
    lea rsi, [arr + rax*8]
    push rax
    xor rax, rax
    call scanf
    pop rax
    
    inc rax
    mov [counter], rax
    jmp read_loop
    
read_done:
    ; calculate sum
    mov qword [sum], 0
    mov qword [counter], 0
sum_loop:
    mov rax, [counter]
    cmp rax, [size]
    jge sum_done
    
    mov rbx, [arr + rax*8]
    add [sum], rbx
    
    inc rax
    mov [counter], rax
    jmp sum_loop
    
sum_done:
    ; print result
    mov rdi, out_fmt
    mov rsi, [sum]
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

### Question 13: Find Maximum in Array
**Write a program to find maximum element in array of 5 numbers.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
size: dq 5
max_val: dq 0
counter: dq 0
in_fmt: db "%ld", 0
out_fmt: db "Maximum = %ld", 10, 0
msg: db "Enter 5 numbers: ", 0
msg_fmt: db "%s", 0

SECTION .bss
arr: resq 5

SECTION .text
global main
main:
    push rbp
    
    ; print message
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    ; read array
    mov qword [counter], 0
read_loop:
    mov rax, [counter]
    cmp rax, [size]
    jge read_done
    
    mov rdi, in_fmt
    lea rsi, [arr + rax*8]
    push rax
    xor rax, rax
    call scanf
    pop rax
    
    inc rax
    mov [counter], rax
    jmp read_loop
    
read_done:
    ; find maximum
    mov rax, [arr]          ; assume first is max
    mov [max_val], rax
    mov qword [counter], 1
    
max_loop:
    mov rax, [counter]
    cmp rax, [size]
    jge max_done
    
    mov rbx, [arr + rax*8]
    cmp rbx, [max_val]
    jle skip
    mov [max_val], rbx
skip:
    inc rax
    mov [counter], rax
    jmp max_loop
    
max_done:
    ; print result
    mov rdi, out_fmt
    mov rsi, [max_val]
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

## Section 7: String Problems

### Question 14: Count Characters in String
**Write a program to count number of characters in a string.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
in_fmt: db "%s", 0
out_fmt: db "Length = %ld", 10, 0
msg: db "Enter a string: ", 0
msg_fmt: db "%s", 0

SECTION .bss
str: resb 100

SECTION .text
global main
main:
    push rbp
    
    ; read string
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, str
    xor rax, rax
    call scanf
    
    ; count characters
    mov rdi, str
    call strlen
    
    ; print result
    mov rdi, out_fmt
    mov rsi, rax
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret

; Function: strlen
; Parameters: rdi = string pointer
; Return: rax = length
strlen:
    push rbp
    mov rbp, rsp
    xor rax, rax        ; counter = 0
loop_count:
    mov bl, [rdi]
    cmp bl, 0           ; check for null terminator
    je done_count
    inc rax
    inc rdi
    jmp loop_count
done_count:
    pop rbp
    ret
```

---

## Section 8: Digit Manipulation

### Question 15: Count Digits in a Number
**Write a program to count number of digits in an integer.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
n: dq 0
count: dq 0
in_fmt: db "%ld", 0
out_fmt: db "Number of digits = %ld", 10, 0
msg: db "Enter a number: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main
main:
    push rbp
    
    ; read number
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf
    
    ; count digits
    mov rax, [n]
    mov qword [count], 0
    
    ; handle zero case
    cmp rax, 0
    jne count_loop
    mov qword [count], 1
    jmp print_result
    
count_loop:
    cmp rax, 0
    je print_result
    
    xor rdx, rdx
    mov rbx, 10
    div rbx             ; rax = rax / 10
    
    inc qword [count]
    jmp count_loop
    
print_result:
    mov rdi, out_fmt
    mov rsi, [count]
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

### Question 16: Sum of Digits
**Write a program to calculate sum of digits of a number.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
n: dq 0
sum: dq 0
in_fmt: db "%ld", 0
out_fmt: db "Sum of digits = %ld", 10, 0
msg: db "Enter a number: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main
main:
    push rbp
    
    ; read number
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf
    
    ; calculate sum of digits
    mov rax, [n]
    mov qword [sum], 0
    
sum_loop:
    cmp rax, 0
    je print_result
    
    xor rdx, rdx
    mov rbx, 10
    div rbx             ; rdx = last digit
    
    add [sum], rdx
    jmp sum_loop
    
print_result:
    mov rdi, out_fmt
    mov rsi, [sum]
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

## Section 9: Pattern-Based Problems

### Question 17: Fibonacci Series up to N terms
**Write a program to print first n Fibonacci numbers.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
n: dq 0
a: dq 0
b: dq 1
counter: dq 0
in_fmt: db "%ld", 0
out_fmt: db "%ld ", 0
msg: db "Enter n: ", 0
msg_fmt: db "%s", 0
newline: db "", 10, 0

SECTION .text
global main
main:
    push rbp
    
    ; read n
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf
    
    mov qword [a], 0
    mov qword [b], 1
    mov qword [counter], 0
    
fib_loop:
    mov rax, [counter]
    cmp rax, [n]
    jge fib_done
    
    ; print current fibonacci number
    mov rdi, out_fmt
    mov rsi, [a]
    push rax
    xor rax, rax
    call printf
    pop rax
    
    ; calculate next: c = a + b
    mov rcx, [a]
    mov rdx, [b]
    add rcx, rdx
    
    ; shift: a = b, b = c
    mov [a], rdx
    mov [b], rcx
    
    inc rax
    mov [counter], rax
    jmp fib_loop
    
fib_done:
    mov rdi, newline
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

### Question 18: Check Palindrome Number
**Write a program to check if a number is palindrome.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
n: dq 0
original: dq 0
reversed: dq 0
in_fmt: db "%ld", 0
pal_msg: db "%ld is Palindrome", 10, 0
not_pal_msg: db "%ld is Not Palindrome", 10, 0
msg: db "Enter a number: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main
main:
    push rbp
    
    ; read number
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf
    
    ; save original
    mov rax, [n]
    mov [original], rax
    
    ; reverse the number
    mov qword [reversed], 0
    
reverse_loop:
    cmp rax, 0
    je check_palindrome
    
    xor rdx, rdx
    mov rbx, 10
    div rbx             ; rdx = last digit
    
    ; reversed = reversed * 10 + digit
    mov rcx, [reversed]
    imul rcx, 10
    add rcx, rdx
    mov [reversed], rcx
    
    jmp reverse_loop
    
check_palindrome:
    mov rax, [original]
    mov rbx, [reversed]
    cmp rax, rbx
    jne not_palindrome
    
    ; is palindrome
    mov rdi, pal_msg
    mov rsi, [original]
    xor rax, rax
    call printf
    jmp done
    
not_palindrome:
    mov rdi, not_pal_msg
    mov rsi, [original]
    xor rax, rax
    call printf
    
done:
    pop rbp
    mov rax, 0
    ret
```

---

## Section 10: Advanced Problems

### Question 19: LCM of Two Numbers
**Write a program to find LCM (Least Common Multiple) of two numbers.**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
a: dq 0
b: dq 0
lcm: dq 0
temp_a: dq 0
temp_b: dq 0
in_fmt: db "%ld", 0
out_fmt: db "LCM = %ld", 10, 0
msg: db "Enter two numbers: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main
main:
    push rbp
    
    ; read numbers
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, a
    xor rax, rax
    call scanf
    
    mov rdi, in_fmt
    mov rsi, b
    xor rax, rax
    call scanf
    
    ; calculate GCD first
    mov rax, [a]
    mov rbx, [b]
    mov [temp_a], rax
    mov [temp_b], rbx
    
gcd_loop:
    cmp rbx, 0
    je gcd_done
    
    xor rdx, rdx
    div rbx
    mov rax, rbx
    mov rbx, rdx
    jmp gcd_loop
    
gcd_done:
    ; rax now contains GCD
    ; LCM = (a * b) / GCD
    mov rbx, [temp_a]
    mov rcx, [temp_b]
    imul rbx, rcx       ; a * b
    mov rcx, rax        ; gcd
    mov rax, rbx
    xor rdx, rdx
    div rcx
    mov [lcm], rax
    
    ; print result
    mov rdi, out_fmt
    mov rsi, [lcm]
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 0
    ret
```

---

### Question 20: Armstrong Number Checker
**Write a program to check if a number is an Armstrong number (sum of cubes of digits equals the number).**

**Answer:**
```assembly
extern printf
extern scanf

SECTION .data
n: dq 0
original: dq 0
sum: dq 0
in_fmt: db "%ld", 0
arm_msg: db "%ld is Armstrong Number", 10, 0
not_arm_msg: db "%ld is Not Armstrong Number", 10, 0
msg: db "Enter a number: ", 0
msg_fmt: db "%s", 0

SECTION .text
global main
main:
    push rbp
    
    ; read number
    mov rdi, msg_fmt
    mov rsi, msg
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf
    
    ; save original
    mov rax, [n]
    mov [original], rax
    mov qword [sum], 0
    
armstrong_loop:
    cmp rax, 0
    je check_armstrong
    
    xor rdx, rdx
    mov rbx, 10
    div rbx             ; rdx = digit
    
    ; calculate cube: digit * digit * digit
    push rax
    mov rax, rdx
    imul rax, rdx
    imul rax, rdx
    add [sum], rax
    pop rax
    
    jmp armstrong_loop
    
check_armstrong:
    mov rax, [original]
    mov rbx, [sum]
    cmp rax, rbx
    jne not_armstrong
    
    ; is armstrong
    mov rdi, arm_msg
    mov rsi, [original]
    xor rax, rax
    call printf
    jmp done
    
not_armstrong:
    mov rdi, not_arm_msg
    mov rsi, [original]
    xor rax, rax
    call printf
    
done:
    pop rbp
    mov rax, 0
    ret
```

---

## Compilation Commands

For all programs:
```bash
nasm -f win64 program.asm -o program.obj
gcc program.obj -o program.exe
./program.exe
```

---

## Quick Reference - Common Patterns

### Reading Input:
```assembly
mov rdi, in_fmt
mov rsi, variable
xor rax, rax
call scanf
```

### Printing Output:
```assembly
mov rdi, out_fmt
mov rsi, value
xor rax, rax
call printf
```

### Loop Structure:
```assembly
loop_start:
    ; loop body
    inc counter
    mov rax, counter
    cmp rax, limit
    jl loop_start
```

### Function Structure:
```assembly
function_name:
    push rbp
    mov rbp, rsp
    ; function body
    pop rbp
    ret
```

### Division (remainder):
```assembly
xor rdx, rdx
mov rax, dividend
mov rbx, divisor
div rbx
; rax = quotient, rdx = remainder
```

---

## Study Tips for Midterm

1. **Practice all loop types** - counting up, counting down, while-style
2. **Master function calling** - parameter passing, return values
3. **Understand conditional jumps** - je, jne, jl, jg, jle, jge
4. **Practice array operations** - indexing, traversal
5. **Review mathematical formulas** - sum series, factorial, GCD
6. **Know register usage** - RAX (return), RDI/RSI (params), RBX (saved)
7. **Practice without looking at answers** - write code from scratch
8. **Test edge cases** - zero, negative numbers, single element

---

**Good luck on your midterm! 🚀**
