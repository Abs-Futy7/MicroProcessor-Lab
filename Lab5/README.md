# Lab 5: Functions and Procedures in Assembly

This lab demonstrates the use of custom functions in NASM assembly language, including parameter passing, return values, and proper function calling conventions.

---

## Table of Contents
1. [47_1.asm - Addition Function](#program-1-addition-function)
2. [47_2.asm - Maximum Function](#program-2-maximum-function)
3. [47_3.asm - String Reversal Function](#program-3-string-reversal-function)
4. [47_4.asm - Matrix AND Operation](#program-4-matrix-and-operation)
5. [47_5.asm - Student Grade Calculator](#program-5-student-grade-calculator)
6. [Function Calling Convention](#function-calling-convention)
7. [Key Concepts](#key-concepts)

---

## Program 1: Addition Function

**File:** `47_1.asm`

### Purpose
Demonstrates basic function creation and calling by implementing a simple addition function.

### How It Works

1. **Input Phase:**
   - Prompts user to enter two numbers
   - Reads both numbers using `scanf`
   - Stores them in variables `a` and `b`

2. **Function Call:**
   ```assembly
   mov rdi, [a]        ; First parameter in RDI
   mov rsi, [b]        ; Second parameter in RSI
   call sum            ; Call the function
   mov [res], rax      ; Store return value from RAX
   ```

3. **Function Implementation:**
   ```assembly
   sum:
       push rbp
       mov rbp, rsp
       mov rax, rdi    ; Get first parameter
       add rax, rsi    ; Add second parameter
       pop rbp
       ret             ; Return result in RAX
   ```

4. **Output:**
   - Prints the sum of the two numbers

### Key Concepts
- **Parameter Passing:** Uses registers RDI and RSI for first two parameters
- **Return Value:** Result returned in RAX register
- **Stack Frame:** Proper setup and cleanup with RBP

### Example Run
```
Enter first number: 15
Enter second number: 25
Sum = 40
```

---

## Program 2: Maximum Function

**File:** `47_2.asm`

### Purpose
Demonstrates conditional logic within a function by finding the maximum of two numbers.

### How It Works

1. **Input Phase:**
   - Reads two numbers from user input
   - Stores them in variables `a` and `b`

2. **Function Call:**
   ```assembly
   mov rdi, [a]        ; First parameter
   mov rsi, [b]        ; Second parameter
   call max_two        ; Call function
   mov [max], rax      ; Store maximum value
   ```

3. **Function Implementation:**
   ```assembly
   max_two:
       push rbp
       mov rbp, rsp
       mov rax, rdi        ; Assume first is larger
       cmp rsi, rdi        ; Compare second with first
       jle done            ; If second <= first, done
       mov rax, rsi        ; Else, second is larger
   done:
       pop rbp
       ret
   ```

4. **Algorithm:**
   - Assumes first number is the maximum
   - Compares second number with first
   - If second is greater, updates the maximum
   - Returns the larger value

### Key Concepts
- **Conditional Logic:** Uses `cmp` and `jle` instructions
- **Comparison:** Demonstrates how to compare values in assembly
- **Efficient Logic:** Assumes one value and only changes if needed

### Example Run
```
Enter first number: 42
Enter second number: 37
The larger number is: 42
```

---

## Program 3: String Reversal Function

**File:** `47_3.asm`

### Purpose
Demonstrates string manipulation by reversing a string character by character.

### How It Works

1. **Input Phase:**
   - Prompts user to enter a string
   - Reads string into buffer `str`

2. **Function Call:**
   ```assembly
   mov rdi, str        ; Source string pointer
   mov rsi, rev        ; Destination buffer pointer
   call rev_str        ; Call reversal function
   ```

3. **Function Implementation (Two Phases):**

   **Phase 1: Calculate String Length**
   ```assembly
   len_loop:
       mov al, [rdi]       ; Load character
       cmp al, 0           ; Check for null terminator
       je len_done         ; If null, done
       inc rcx             ; Increment length counter
       inc rdi             ; Move to next character
       jmp len_loop
   ```

   **Phase 2: Reverse the String**
   ```assembly
   rev_loop:
       cmp rcx, 0          ; Check if all chars processed
       je rev_done
       mov al, [rdi]       ; Get char from end of source
       mov [rsi + rdx], al ; Put at beginning of destination
       dec rdi             ; Move backward in source
       inc rdx             ; Move forward in destination
       dec rcx             ; Decrement counter
       jmp rev_loop
   ```

4. **Algorithm:**
   - First, find the length of the string
   - Then, copy characters from end to beginning
   - Add null terminator to reversed string

### Key Concepts
- **String Operations:** Character-by-character processing
- **Pointers:** Moving forward and backward through memory
- **Buffer Management:** Using separate source and destination buffers
- **Register Preservation:** Saving and restoring callee-saved registers

### Example Run
```
Enter a string: hello
olleh
```

### Visual Representation
```
Original: h e l l o \0
Index:    0 1 2 3 4  5

Step 1: Find length = 5

Step 2: Reverse
Source (backward):  o l l e h
Destination:        o l l e h \0
```

---

## Program 4: Matrix AND Operation

**File:** `47_4.asm`

### Purpose
Demonstrates array/matrix operations by performing bitwise AND on two matrices.

### How It Works

1. **Data Setup:**
   ```assembly
   m1: dq 1 2 3 4      ; Matrix 1
   m2: dq 5 6 7 8      ; Matrix 2
   r: dq 3             ; Rows
   c: dq 3             ; Columns
   t_e: dq 9           ; Total elements
   ```

2. **Main Function:**
   ```assembly
   mov rdi, m1         ; First matrix
   mov rsi, m2         ; Second matrix
   mov rdx, m_result   ; Result matrix
   mov rcx, [t_e]      ; Total elements
   call m_and          ; Perform AND operation
   ```

3. **AND Function:**
   ```assembly
   m_and:
       xor rax, rax            ; Counter = 0
   loop_start:
       cmp rax, rcx            ; Check if done
       jge loop_done
       mov r8, [rdi + rax*8]   ; Load from matrix1
       and r8, [rsi + rax*8]   ; AND with matrix2
       mov [rdx + rax*8], r8   ; Store result
       inc rax                 ; Next element
       jmp loop_start
   ```

4. **Print Function:**
   - Uses nested loops (outer for rows, inner for columns)
   - Calculates array index: `index = row * columns + column`
   - Prints each element with space separator
   - Prints newline after each row

### Key Concepts
- **Array Indexing:** `[base + index*8]` for 64-bit elements
- **Bitwise Operations:** Using `and` instruction
- **Nested Loops:** For 2D matrix traversal
- **Index Calculation:** Converting 2D coordinates to 1D array index

### Bitwise AND Operation
```
Matrix 1:        Matrix 2:        Result:
1  2  3          5  6  7          1&5  2&6  3&7
4  5  6          8  9  10         4&8  5&9  6&10

Binary Example:
1 (0001) & 5 (0101) = 1 (0001)
2 (0010) & 6 (0110) = 2 (0010)
```

### Example Output
```
1 2 3 
0 4 6 
4 0 2 
```

---

## Program 5: Student Grade Calculator

**File:** `47_5.asm`

### Purpose
Demonstrates multiple input types (string and integers) and conditional grading logic.

### How It Works

1. **Input Phase:**
   - Reads student name (string)
   - Reads three test scores (integers)

2. **Calculation:**
   ```assembly
   mov rax, [score1]
   add rax, [score2]
   add rax, [score3]       ; Sum all scores
   mov rbx, 3
   cqo                     ; Sign-extend for division
   idiv rbx                ; Average = sum / 3
   mov [avg], rax
   ```

3. **Grade Assignment:**
   ```assembly
   cmp rax, 50             ; Compare average with 50
   jae pass                ; If >= 50, pass
   mov byte [grade], 'F'   ; Else, fail
   jmp print
   pass:
   mov byte [grade], 'P'   ; Pass grade
   ```

4. **Output:**
   - Prints name, average, and grade in formatted output

### Key Concepts
- **Mixed Data Types:** Handling strings and integers
- **Division:** Using `cqo` for sign extension before `idiv`
- **Conditional Logic:** Simple pass/fail threshold
- **Formatted Output:** Multiple parameters to printf
- **Byte Operations:** Using `movzx` to zero-extend byte to qword

### Grade Logic
```
Average >= 50 → Grade: P (Pass)
Average <  50 → Grade: F (Fail)
```

### Example Run
```
Enter student name: Alice
Enter score 1: 75
Enter score 2: 82
Enter score 3: 68
Student: Alice, Average: 75, Grade: P
```

---

## Function Calling Convention

### x86-64 System V ABI (Used in these programs)

**Parameter Passing (first 6 integer/pointer arguments):**
1. RDI - First parameter
2. RSI - Second parameter
3. RDX - Third parameter
4. RCX - Fourth parameter
5. R8 - Fifth parameter
6. R9 - Sixth parameter

**Return Value:**
- RAX - Return value

**Caller-Saved Registers (must be saved by caller if needed):**
- RAX, RCX, RDX, RSI, RDI, R8-R11

**Callee-Saved Registers (must be preserved by function):**
- RBX, RBP, R12-R15

**Stack Frame Setup:**
```assembly
function_name:
    push rbp        ; Save old base pointer
    mov rbp, rsp    ; Set up new stack frame
    ; ... function code ...
    pop rbp         ; Restore base pointer
    ret             ; Return to caller
```

---

## Key Concepts

### 1. **Function Structure**
Every function follows this pattern:
```assembly
function_name:
    push rbp            ; Prologue: Save base pointer
    mov rbp, rsp        ; Set up stack frame
    
    ; Function body
    
    pop rbp             ; Epilogue: Restore base pointer
    ret                 ; Return to caller
```

### 2. **Parameter Passing**
- First 6 parameters use registers (RDI, RSI, RDX, RCX, R8, R9)
- Additional parameters passed on stack
- Parameters are copied from memory to registers before function call

### 3. **Return Values**
- Integer/pointer return values in RAX
- Floating-point values in XMM0
- Large structures returned via pointer in RDI

### 4. **Register Preservation**
- Callee must preserve RBX, RBP, R12-R15
- Caller must save RAX, RCX, RDX, RSI, RDI, R8-R11 if needed after call

### 5. **Stack Management**
- Stack grows downward (toward lower addresses)
- RSP always points to top of stack
- RBP points to current function's stack frame base

### 6. **Common Instructions Used**

**Data Movement:**
- `mov dest, src` - Copy data
- `push reg` - Push onto stack
- `pop reg` - Pop from stack

**Arithmetic:**
- `add dest, src` - Addition
- `sub dest, src` - Subtraction
- `imul dest, src` - Signed multiplication
- `idiv src` - Signed division

**Comparison and Branching:**
- `cmp op1, op2` - Compare (sets flags)
- `jmp label` - Unconditional jump
- `je/jne label` - Jump if equal/not equal
- `jl/jle label` - Jump if less/less or equal
- `jg/jge label` - Jump if greater/greater or equal
- `jae label` - Jump if above or equal (unsigned)

**Logical:**
- `and dest, src` - Bitwise AND
- `or dest, src` - Bitwise OR
- `xor dest, src` - Bitwise XOR

### 7. **Memory Addressing Modes**

**Direct:**
```assembly
mov rax, [variable]     ; Load from memory address
```

**Indexed:**
```assembly
mov rax, [array + rbx*8]   ; array[rbx] for 8-byte elements
```

**Register Indirect:**
```assembly
mov rax, [rdi]          ; Load from address in RDI
```

### 8. **Data Types and Sizes**

| Directive | Size | Name |
|-----------|------|------|
| db | 1 byte | Byte |
| dw | 2 bytes | Word |
| dd | 4 bytes | Double word |
| dq | 8 bytes | Quad word |
| resb | Reserve bytes | Uninitialized |
| resw | Reserve words | Uninitialized |
| resd | Reserve dwords | Uninitialized |
| resq | Reserve qwords | Uninitialized |

### 9. **String Operations**
- Strings are null-terminated (end with byte value 0)
- Character processing uses byte operations
- String length calculated by counting until null terminator

### 10. **Common Patterns**

**Clearing a register:**
```assembly
xor rax, rax        ; More efficient than mov rax, 0
```

**Loop structure:**
```assembly
    mov rcx, 10     ; Counter
loop_start:
    ; loop body
    dec rcx
    jnz loop_start  ; Jump if not zero
```

**Conditional assignment:**
```assembly
    cmp rax, rbx
    jle skip
    mov rax, rbx    ; Execute only if rax > rbx
skip:
```

---

## Compilation and Execution

### Compile and Link:
```bash
nasm -f win64 47_1.asm -o 47_1.obj
gcc 47_1.obj -o 47_1.exe

nasm -f win64 47_2.asm -o 47_2.obj
gcc 47_2.obj -o 47_2.exe

nasm -f win64 47_3.asm -o 47_3.obj
gcc 47_3.obj -o 47_3.exe

nasm -f win64 47_4.asm -o 47_4.obj
gcc 47_4.obj -o 47_4.exe

nasm -f win64 47_5.asm -o 47_5.obj
gcc 47_5.obj -o 47_5.exe
```

### Run:
```bash
./47_1.exe
./47_2.exe
./47_3.exe
./47_4.exe
./47_5.exe
```

---

## Summary

This lab covered:
1. ✅ Creating and calling custom functions
2. ✅ Passing parameters using registers
3. ✅ Returning values from functions
4. ✅ Proper function prologue and epilogue
5. ✅ String manipulation and character processing
6. ✅ Array/matrix operations
7. ✅ Conditional logic in functions
8. ✅ Multiple data types (integers, strings, arrays)
9. ✅ Register preservation and calling conventions
10. ✅ Nested loops and 2D data structures

**Key Takeaway:** Functions in assembly require careful attention to register usage, parameter passing conventions, and stack management. Following the System V ABI ensures compatibility with C library functions like printf and scanf.
