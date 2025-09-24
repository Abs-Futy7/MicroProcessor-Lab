# Loops and Arrays in Assembly (NASM)

## Loops

A loop is a control structure that repeats a block of code multiple times. In NASM assembly, loops are typically implemented using labels and jump instructions.

### Example: Counting Loop

```nasm
mov ecx, 5        ; Set loop counter to 5
start_loop:
    ; Loop body code here
    dec ecx        ; Decrement counter
    jnz start_loop ; Jump if not zero
```

## Arrays

An array is a collection of data items stored in contiguous memory locations. In NASM, arrays can be defined using the `db`, `dw`, or `dd` directives.

### Example: Defining and Accessing an Array

```nasm
section .data
array db 10, 20, 30, 40, 50 ; Array of 5 bytes

section .text
mov esi, 0          ; Index
mov ecx, 5          ; Number of elements

print_loop:
    mov al, [array + esi] ; Load array element
    ; Process al here
    inc esi
    loop print_loop
```

## Input for Loops and Arrays

Assembly does not have built-in input functions. Input is typically handled via system calls or by reading from memory.

### Example: Reading Array Elements (Pseudo-code)

1. Read input into memory (using OS or BIOS interrupts).
2. Store values in array locations.
3. Use a loop to process the array.

## More Examples

### Summing Array Elements

```nasm
section .data
arr db 1, 2, 3, 4, 5
len equ 5

section .bss
sum resb 1

section .text
mov ecx, len
mov esi, 0
mov al, 0

sum_loop:
    add al, [arr + esi]
    inc esi
    loop sum_loop
mov [sum], al
```

---

**Summary:**  
- Loops use labels and jump instructions.
- Arrays are defined with data directives and accessed via pointers and offsets.
- Input is handled externally and stored in arrays for processing.
- Loops and arrays are fundamental for repetitive and structured data tasks in assembly.
