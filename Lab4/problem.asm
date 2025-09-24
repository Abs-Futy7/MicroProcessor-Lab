; ------------------------------------------------------------------------------
; Program: problem.asm
; Description:
;   Write an assembly language program that performs the following tasks:
;   - Declare an array to hold 20 integers
;   - Repeatedly read 20 integers from the user (one at a time)
;   - For each integer, add it to a running sum
;   - Store the integers in the array
;   - After all 20 integers have been entered, print the total sum
;   - Finally, print back all the numbers stored in the array in order
;
; Algorithm:
;   1. Initialize counter = 0, sum = 0
;   2. Loop 20 times:
;      - Read an integer from user
;      - Add it to running sum
;      - Store it in array at current position
;      - Increment counter
;   3. Print the total sum
;   4. Loop through array and print all 20 numbers
;
; Data Structures:
;   - arr: Array of 20 quadwords (64-bit integers) in BSS section
;   - cnt: Counter for array indexing (0 to 19)
;   - c: Temporary variable for input
;   - sum: Running total of all numbers
;
; Memory Layout:
;   - arr[0] at arr+0*8, arr[1] at arr+1*8, ..., arr[19] at arr+19*8
;   - Each array element is 8 bytes (64-bit quadword)
; ------------------------------------------------------------------------------

extern    printf        ; External C library function for output
extern    scanf         ; External C library function for input

SECTION .data        
cnt:    dq    0         ; Loop counter (64-bit integer, starts at 0)
c:      dq    0         ; Temporary variable to hold input integer
sum:    dq    0         ; Running sum of all entered numbers
out_fmt: db "%ld", 10, 0 ; Output format string with newline
in_fmt:  db "%ld",0     ; Input format string for scanf

SECTION .bss            ; Uninitialized data section (more memory efficient)
arr: resq 21            ; Reserve space for 21 quadwords (20 for array + 1 extra)
                        ; Each quadword is 8 bytes, so total = 21 * 8 = 168 bytes

SECTION .text

global main             ; Make main function visible to linker
main:                
    push    rbp         ; Save base pointer on stack (function prologue)

; === PHASE 1: INPUT COLLECTION LOOP ===
; This loop reads 20 integers from user, stores them in array, and calculates sum
; Loop structure: for(cnt = 0; cnt < 20; cnt++)

Loop:                   ; Main input collection loop label
    ; === Read integer from user ===
    mov rdi,in_fmt      ; Load address of input format "%ld" into RDI (1st parameter)
    mov rsi,c           ; Load address of temporary variable 'c' into RSI (2nd parameter)
    call scanf          ; Call scanf to read one integer and store in 'c'
    mov rax,[c]         ; Load the input value from 'c' into RAX for processing
   
    ; === Add to running sum ===
    add [sum],rax       ; Add current number (RAX) to running sum
                        ; sum = sum + current_number
   
    ; === Store in array at current position ===
    mov rcx,[cnt]       ; Load current counter value into RCX (array index)
    mov [arr+8*rcx],rax ; Store current number in array at position cnt
                        ; arr[cnt] = current_number
                        ; Address calculation: arr + (cnt * 8) because each element is 8 bytes
   
    ; === Increment counter and check loop condition ===
    add rcx,1           ; Increment counter: rcx = rcx + 1
    mov [cnt],rcx       ; Store updated counter back to memory: cnt = cnt + 1
   
    cmp rcx,20          ; Compare counter with 20
    jnz Loop            ; Jump back to Loop if counter ≠ 20 (continue reading)
    ; === Reset counter for output phase ===
    mov rax,0           ; Clear RAX to 0
    mov [cnt],rax       ; Reset counter to 0 for array printing phase
   
    ; === Print the total sum ===
    mov rdi,out_fmt     ; Load address of output format "%ld\n" into RDI
    mov rsi,[sum]       ; Load total sum value into RSI (2nd parameter)
    mov rax,0           ; Clear RAX for printf (variadic function requirement)
    call printf         ; Call printf to display: "sum_value\n"

; === PHASE 2: ARRAY OUTPUT LOOP ===
; This loop prints all 20 numbers stored in the array in order
; Loop structure: for(cnt = 0; cnt < 20; cnt++)

print:                  ; Array printing loop label
    ; === Get current array element ===
    mov rcx,[cnt]       ; Load current counter value into RCX (array index)
    mov rcx,[arr+8*rcx] ; Load array element at position cnt into RCX
                        ; rcx = arr[cnt]
                        ; Address calculation: arr + (cnt * 8) for 64-bit elements
   
    ; === Print current array element ===
    mov rdi,out_fmt     ; Load address of output format "%ld\n" into RDI
    mov rsi,rcx         ; Load current array element into RSI (2nd parameter)
    mov rax,0           ; Clear RAX for printf (variadic function requirement)
    call printf         ; Call printf to display current number with newline
   
    ; === Increment counter and check loop condition ===
    mov rcx,[cnt]       ; Load current counter value into RCX
    add rcx,1           ; Increment counter: rcx = rcx + 1
    mov [cnt],rcx       ; Store updated counter back to memory: cnt = cnt + 1
   
    cmp rcx,20          ; Compare counter with 20
    jnz print           ; Jump back to print if counter ≠ 20 (continue printing)

    ; === Program termination ===
    pop    rbp          ; Restore base pointer from stack
    mov    rax,0        ; Set return value to 0 (success)
    ret                 ; Return to caller (exit program)