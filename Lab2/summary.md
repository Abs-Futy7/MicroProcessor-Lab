# Microprocessor Lab - Lab 2 Summary

## Task 1: Understanding the Basic Addition Program

### Code Analysis

```assembly
extern printf
extern scanf
SECTION .data
a: dq 5
b: dq 2
c: dq 0
enter: db "Enter two numbers: ",0
out_fmt: db "%ld + %ld =%ld", 10, 0
out_fmt_2: db "%s",10,0
in_fmt: db "%d",0
SECTION .text
global main
main:
push rbp
mov rax,0
mov rdi,out_fmt_2
mov rsi,enter
call printf
mov rax, 0
mov rdi, in_fmt
mov rsi, a
call scanf
mov rax, 0
mov rdi, in_fmt
mov rsi, b
call scanf
mov rax,[a]
mov rbx,[b]
add rax,rbx
mov [c],rax
mov rdi,out_fmt
mov rsi,[a]
mov rdx,[b]
mov rcx,[c]
mov rax,0
call printf
pop rbp
mov rax,0
ret
```

### What the Code Does

This assembly program performs the following operations:

1. **Prompts the user** to enter two numbers using `printf`
2. **Reads two integers** from user input using `scanf` and stores them in variables `a` and `b`
3. **Adds the two numbers** by loading them into registers `rax` and `rbx`, then using the `add` instruction
4. **Stores the result** in variable `c`
5. **Prints the result** in the format "a + b = c"

### How It Works

1. **Data Section**: Defines variables and format strings
   - `a`, `b`, `c`: 64-bit integers (quadword)
   - `enter`: Prompt message string
   - `out_fmt`, `out_fmt_2`, `in_fmt`: Format strings for printf/scanf

2. **Text Section**: Contains the executable code
   - Uses standard calling convention with `rdi`, `rsi`, `rdx`, `rcx` for function parameters
   - Manages stack with `push rbp` and `pop rbp`
   - Clears `rax` before function calls (required for variadic functions)

### Register Usage in the Code

- **RAX**: Accumulator for arithmetic operations and function call setup
- **RBX**: Stores the second operand for addition
- **RDI**: First parameter for printf/scanf (format string)
- **RSI**: Second parameter (variable address or value)
- **RDX**: Third parameter for printf
- **RCX**: Fourth parameter for printf
- **RBP**: Base pointer for stack frame management

## General-Purpose Registers Reference

| 64-bit | 32-bit | 16-bit | 8-bit (high/low) | Purpose / Usage |
|--------|--------|--------|------------------|-----------------|
| RAX | EAX | AX | AH/AL | Accumulator; arithmetic, logic, I/O |
| RBX | EBX | BX | BH/BL | Base; data storage, memory addressing |
| RCX | ECX | CX | CH/CL | Counter for loops, string operations |
| RDX | EDX | DX | DH/DL | I/O, multiplication/division |
| RSI | ESI | SI | SIL | Source index for string/data operations |
| RDI | EDI | DI | DIL | Destination index for string/data operations |
| RBP | EBP | BP | — | Base pointer for stack frames |
| RSP | ESP | SP | — | Stack pointer |
| R8–R15 | R8D–R15D | R8W–R15W | R8B–R15B | Additional general-purpose registers (64-bit only) |

## Instruction Reference

### Data Movement Instructions

| Instruction | Syntax | Purpose |
|-------------|--------|---------|
| mov dest, src | mov rax, rbx | Copies data from src to dest. Can be register, memory, or immediate. |
| push reg/mem | push rbp | Pushes value onto stack; decrements rsp by 8 (64-bit). |
| pop reg | pop rbp | Pops value from stack into register; increments rsp by 8. |

### Arithmetic Instructions

| Instruction   | Syntax            | Purpose                                                                                          | Example                          |
|---------------|-------------------|--------------------------------------------------------------------------------------------------|----------------------------------|
| add dest, src | add rax, rbx      | Adds src to dest and stores result in dest.                                                      | `add rax, rbx` ; rax = rax + rbx |
| sub dest, src | sub rax, rbx      | Subtracts src from dest.                                                                         | `sub rax, rbx` ; rax = rax - rbx |
| mul src       | mul rbx           | Unsigned multiply rax * src. Result stored in rdx:rax.                                           | `mov rax, 5`<br>`mul rbx`        |
| imul src      | imul rbx          | Signed multiply. Can store result in rax or another register.                                    | `imul rax, rbx, 3` ; rax = rbx*3 |
| div src       | div rbx           | Unsigned divide rdx:rax / src. Quotient → rax, remainder → rdx.                                 | `mov rax, 10`<br>`xor rdx, rdx`<br>`div rbx` |
| idiv src      | idiv rbx          | Signed division.                                                                                 | `mov rax, -10`<br>`xor rdx, rdx`<br>`idiv rbx` |

**Examples Explained:**
- `add rax, rbx` adds the value in `rbx` to `rax`.
- `sub rax, rbx` subtracts the value in `rbx` from `rax`.
- `mul rbx` multiplies `rax` by `rbx` (unsigned), result in `rdx:rax`.
- `imul rax, rbx, 3` multiplies `rbx` by 3 (signed), stores result in `rax`.
- `div rbx` divides `rdx:rax` by `rbx` (unsigned), quotient in `rax`, remainder in `rdx`.
- `idiv rbx` divides `rdx:rax` by `rbx` (signed), quotient in `rax`, remainder in `rdx`.

## Task 2: Calculate 2a + 3b + c

### Problem Statement
Scan three variables a, b, and c. Print the value of 2a + 3b + c.

### Implementation

```assembly
extern printf        
extern scanf        

SECTION .data        

a:  dq 0             ; Variable a
b:  dq 0             ; Variable b
c:  dq 0             ; Variable c

enter: db "Enter three numbers: ", 0      ; Message to prompt user
out_fmt: db "2a + 3b + c = %ld", 10, 0     ; Output format for printf
out_fmt_2: db "%s", 10, 0                ; Format to print strings
in_fmt: db "%d", 0                      ; Format for scanf

SECTION .text

global main        
main:
        push    rbp    
        
        ; Print prompt to user
        mov rax, 0      
        mov rdi, out_fmt_2   
        mov rsi, enter    
        call printf    

        ; Scan first number for 'a'
        mov rax, 0       
        mov rdi, in_fmt   
        mov rsi, a        
        call scanf        

        ; Scan second number for 'b'
        mov rax, 0        
        mov rdi, in_fmt   
        mov rsi, b        
        call scanf        
        
        ; Scan third number for 'c'
        mov rax, 0        
        mov rdi, in_fmt   
        mov rsi, c        
        call scanf        

        ; Perform calculation: 2a + 3b + c
        mov rax, [a]      ; Load value of 'a' into rax
        imul rax, 2       ; Multiply a by 2 (rax = a * 2)

        mov rbx, [b]      ; Load value of 'b' into rbx
        imul rbx, 3       ; Multiply b by 3 (rbx = b * 3)

        add rax, rbx      ; Add 2a and 3b, store result in rax

        mov rcx, [c]      ; Load value of 'c' into rcx
        add rax, rcx      ; Add c to the result

        ; Print the result
        mov rdi, out_fmt  
        mov rsi, rax      
        call printf       

        pop rbp           
        mov rax, 0        
        ret               
```

### Key Points
- Uses `imul` instruction for multiplication
- Performs operations step by step: 2a, then 3b, then adds them together with c
- Uses registers efficiently for intermediate calculations

## Task 3: Sum from 1 to x

### Problem Statement
Scan a variable x. Print the value of the sum of the numbers from 1 to x. Assume x is a positive integer.

### Implementation

```assembly
extern	printf		
extern	scanf		

SECTION .data		

a:	dq	0

enter:	db "Enter number: ",0
out_fmt:	db "Sum from 1 to n = %ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:		db "%ld",0

SECTION .text

global main		
main:				
        push    rbp	
        
        mov rax,0
        mov rdi,out_fmt_2
        mov rsi,enter
        call printf
        
        mov rax, 0
	mov rdi, in_fmt
	mov rsi, a
	call scanf
	
	; Calculate sum using formula: n(n+1)/2
	mov rax,[a]       ; Load n into rax
	mov rbx, rax      ; Copy n to rbx
	add rbx, 1        ; rbx = n + 1
	imul rax, rbx     ; rax = n * (n + 1)
	mov rcx, 2        ; rcx = 2
	idiv rcx          ; rax = n(n+1)/2
		
	mov	rdi,out_fmt		
	mov	rsi,rax       
       
	mov	rax,0		
        call    printf		

	pop	rbp		
	mov	rax,0		
	ret
```

### Mathematical Formula
The sum of numbers from 1 to n is calculated using the formula:
**Sum = n(n+1)/2**

### Key Points
- Uses the mathematical formula instead of a loop for efficiency
- Employs `imul` for multiplication and `idiv` for signed division
- Efficient single-pass calculation

## Summary

All three tasks demonstrate:
1. **Basic I/O operations** using printf and scanf
2. **Register management** and data movement
3. **Arithmetic operations** including addition, multiplication, and division
4. **Memory addressing** for variable storage and retrieval
5. **Function calling conventions** in x86-64 assembly

The programs showcase fundamental assembly programming concepts while solving practical mathematical problems.