# Lab 6 - Advanced Array Operations

This lab contains three advanced array manipulation problems implemented in x86-64 NASM assembly.

---

## Problem 1: Count Frequency of Array Elements
**File:** `47_1.asm`

### Description
Write a function `countFrequency` that takes an array of integers and returns a new array of pairs, where each pair contains a unique number and its frequency.

### Input
- First line: integer `n` (size of array)
- Second line: `n` integers (array elements)

### Output
- Pairs of numbers: `unique_number frequency`
- Printed in ascending order of unique numbers
- One pair per line

### Example
```
Input:
8
5 2 5 1 2 5 3 2

Output:
1 1
2 3
3 1
5 3
```

### Algorithm
1. Sort the array using `qsort`
2. Count consecutive duplicate elements
3. Store unique numbers and their frequencies
4. Print in ascending order

### Key Functions
- `cntFreq`: Count frequency of each unique element
- `printFreqPair`: Display unique number-frequency pairs
- `compare`: Comparison function for qsort (ascending order)

### Compilation & Execution
```bash
nasm -f win64 47_1.asm -o 47_1.obj
gcc 47_1.obj -o 47_1.exe
./47_1.exe
```

---

## Problem 2: Rotate Array to Right
**File:** `47_2.asm`

### Description
Write a function `rotateArray` that rotates an array to the right by `k` positions.

### Input
- First line: two integers `n` and `k` (array size and rotation count)
- Second line: `n` integers (array elements)

### Output
- Array after rotation by `k` positions to the right
- Elements printed with spaces

### Example
```
Input:
5 2
1 2 3 4 5

Output:
4 5 1 2 3
```

### Algorithm
1. Calculate effective rotation: `k = k % n`
2. Copy last `k` elements to temporary array
3. Shift first `(n-k)` elements to the right by `k` positions
4. Copy temporary array back to start

### Visualization
```
Original: [1, 2, 3, 4, 5]
k = 2

Step 1: temp = [4, 5]
Step 2: [1, 2, 3, _, _] → [_, _, 1, 2, 3]
Step 3: [4, 5, 1, 2, 3]
```

### Key Functions
- `rotArr`: Rotate array to right by k positions
- `printArr`: Print array elements

### Compilation & Execution
```bash
nasm -f win64 47_2.asm -o 47_2.obj
gcc 47_2.obj -o 47_2.exe
./47_2.exe
```

---

## Problem 3: Average of Elements Above Threshold
**File:** `47_3.asm`

### Description
Create a function `averageAboveThreshold` that returns the average of all elements greater than a threshold value. If no such element exists, return 0.

### Input
- First line: two integers `n` and `threshold` (array size and threshold value)
- Second line: `n` integers (array elements)

### Output
- Average of elements greater than threshold (2 decimal places)
- If no elements exceed threshold, print `0`

### Example 1
```
Input:
5 5
4 9 2 10 7

Output:
8.67

Explanation: Elements > 5 are [9, 10, 7]
Average = (9 + 10 + 7) / 3 = 26 / 3 = 8.67
```

### Example 2
```
Input:
4 10
1 2 3 4

Output:
0

Explanation: No elements greater than 10
```

### Algorithm
1. Iterate through array
2. For each element > threshold:
   - Add to sum
   - Increment count
3. If count > 0: return sum/count
4. Else: return 0.0

### Key Functions
- `avgAboveThsld`: Calculate average of elements above threshold
- Uses XMM registers for floating-point arithmetic

### Floating-Point Instructions Used
- `xorpd xmm0, xmm0`: Clear XMM register (set to 0.0)
- `cvtsi2sd xmm1, rax`: Convert integer to double
- `addsd xmm0, xmm1`: Add double values
- `divsd xmm0, xmm1`: Divide double values

### Compilation & Execution
```bash
nasm -f win64 47_3.asm -o 47_3.obj
gcc 47_3.obj -o 47_3.exe
./47_3.exe
```

---

## Key Concepts Covered

### 1. Array Manipulation
- Reading arrays dynamically
- Traversing arrays with loops
- Modifying array elements in-place

### 2. Memory Management
- Using `.bss` section for uninitialized arrays
- Temporary array allocation
- Pointer arithmetic with `lea` instruction

### 3. External Functions
- `scanf`: Reading input
- `printf`: Printing output
- `qsort`: Sorting arrays (Problem 1)

### 4. Advanced Techniques
- **Problem 1**: Frequency counting with sorted arrays
- **Problem 2**: Array rotation without extra space
- **Problem 3**: Floating-point arithmetic with XMM registers

### 5. Function Design
- Parameter passing via registers (rdi, rsi, rdx)
- Return values (rax for integers, xmm0 for doubles)
- Preserving callee-saved registers (r12-r15)

### 6. Optimization Strategies
- Using modulo for effective rotation (k % n)
- In-place array manipulation
- Efficient loop constructs with `test rcx, rcx`

---

## Register Usage Summary

### General Purpose Registers
- **RAX**: Accumulator, return values, temporary calculations
- **RBX**: Loop index, counters
- **RCX**: Loop counter (for `loop` instruction)
- **RDX**: Division remainder, temporary storage
- **RSI/RDI**: Function parameters, array pointers
- **R12-R15**: Preserved across function calls, store important values

### XMM Registers (Floating-Point)
- **XMM0**: Return value for floating-point functions
- **XMM1**: Temporary floating-point calculations
- Instructions: `xorpd`, `cvtsi2sd`, `addsd`, `divsd`, `movsd`

---

## Common Assembly Patterns

### Reading Array
```assembly
mov rcx, [n]            ; loop counter
mov rbx, arr            ; array pointer
.read_loop:
    push rcx
    push rbx
    mov rdi, in_fmt
    mov rsi, rbx
    xor eax, eax
    call scanf
    pop rbx
    pop rcx
    add rbx, 8          ; next element (8 bytes)
    loop .read_loop
```

### Array Traversal
```assembly
xor rbx, rbx            ; index = 0
.loop:
    cmp rbx, [n]        ; check bounds
    jge .done
    mov rax, [arr + rbx*8]  ; access arr[index]
    ; process element
    inc rbx             ; next element
    jmp .loop
.done:
```

### Function Prologue/Epilogue
```assembly
function:
    push rbp            ; save base pointer
    mov rbp, rsp        ; set up stack frame
    push r12            ; save callee-saved registers
    push r13
    
    ; function body
    
    pop r13             ; restore registers
    pop r12
    mov rsp, rbp        ; restore stack
    pop rbp
    ret
```

---

## Testing Tips

1. **Test with edge cases:**
   - Empty arrays (n=0)
   - Single element (n=1)
   - All same elements
   - Already sorted/unsorted

2. **Problem 1 specific:**
   - Array with all unique elements
   - Array with all same elements
   - Mixed frequencies

3. **Problem 2 specific:**
   - k = 0 (no rotation)
   - k = n (full rotation)
   - k > n (test modulo operation)

4. **Problem 3 specific:**
   - All elements above threshold
   - All elements below threshold
   - No elements equal to threshold

---

## Study Notes

### Important Instructions
- `loop`: Decrements RCX and jumps if RCX != 0
- `lea`: Load Effective Address (calculate address without dereferencing)
- `imul/div`: Signed multiplication/division
- `test reg, reg`: Efficient zero check (sets flags without modifying)
- `cvtsi2sd`: Convert Signed Integer to Scalar Double
- `addsd/subsd/mulsd/divsd`: Scalar double arithmetic

### Calling Convention (Windows x64)
- Integer params: RDI, RSI, RDX, RCX, R8, R9
- Float params: XMM0-XMM5
- Return: RAX (int), XMM0 (float)
- Callee-saved: RBX, RBP, R12-R15
- Caller-saved: RAX, RCX, RDX, RSI, RDI, R8-R11

---

**Good luck with your assembly programming! 🚀**
