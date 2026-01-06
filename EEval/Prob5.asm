; ========================================
; PROBLEM 5: Anagram Check
; ========================================
; Check whether two strings are anagrams (contain the same letters 
; in any order).
;
; Function Prototype: is_anagram
;
; Input: 
;   - Two strings separated by space (no spaces inside each string, up to 100 chars)
;
; Output: 
;   - YES if they are anagrams, NO otherwise
;
; Example:
;   Input: LISTEN SILENT
;   Output: YES
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input
extern strlen               ; external C function for string length

section .data
    inFmt db "%s %s", 0     ; input format for two strings
    yesMsg db "YES", 0xA, 0 ; output for anagram
    noMsg db "NO", 0xA, 0   ; output for not anagram

section .bss
    str1 resb 101           ; first string (max 100 chars + null)
    str2 resb 101           ; second string (max 100 chars + null)
    freq1 resq 256          ; frequency array for str1 (ASCII 0-255)
    freq2 resq 256          ; frequency array for str2 (ASCII 0-255)

section .text
    global main             ; program entry point

main:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; read two strings
    mov rdi, inFmt          ; 1st param: input format "%s %s"
    mov rsi, str1           ; 2nd param: address of str1
    mov rdx, str2           ; 3rd param: address of str2
    xor eax, eax            ; eax=0 for scanf
    call scanf              ; read two strings
    
    ; call is_anagram function
    mov rdi, str1           ; 1st param: first string
    mov rsi, str2           ; 2nd param: second string
    call is_anagram         ; check if anagrams
    
    ; print result (rax = 1 if anagram, 0 otherwise)
    cmp rax, 1              ; check result
    je .print_yes           ; if anagram, print YES
    
    ; print NO
    mov rdi, noMsg          ; 1st param: "NO"
    xor eax, eax            ; eax=0
    call printf             ; print NO
    jmp .done
    
.print_yes:
    mov rdi, yesMsg         ; 1st param: "YES"
    xor eax, eax            ; eax=0
    call printf             ; print YES

.done:
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    xor eax, eax            ; return 0
    ret                     ; exit program


; ========================================
; Function: is_anagram
; ========================================
; Purpose: Check if two strings are anagrams
; Parameters:
;   rdi = pointer to first string
;   rsi = pointer to second string
; Returns:
;   rax = 1 if anagrams, 0 otherwise
; Algorithm:
;   1. Check if lengths are equal (if not, not anagrams)
;   2. Build frequency array for each string
;   3. Compare frequency arrays
; ========================================
is_anagram:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    push rbx                ; save callee-saved registers
    push r12
    push r13
    push r14
    push r15
    
    mov r12, rdi            ; r12 = str1 pointer
    mov r13, rsi            ; r13 = str2 pointer
    
    ; get length of str1
    mov rdi, r12            ; 1st param: str1
    call strlen             ; rax = length of str1
    mov r14, rax            ; r14 = len1
    
    ; get length of str2
    mov rdi, r13            ; 1st param: str2
    call strlen             ; rax = length of str2
    mov r15, rax            ; r15 = len2
    
    ; check if lengths are equal
    cmp r14, r15            ; compare lengths
    jne .not_anagram        ; if not equal, not anagrams
    
    ; initialize frequency arrays to 0
    mov rdi, freq1          ; destination
    xor eax, eax            ; value to fill (0)
    mov rcx, 256            ; count (256 qwords)
    rep stosq               ; fill freq1 with 0
    
    mov rdi, freq2          ; destination
    xor eax, eax            ; value to fill (0)
    mov rcx, 256            ; count
    rep stosq               ; fill freq2 with 0
    
    ; build frequency array for str1
    xor rcx, rcx            ; rcx = index
.freq1_loop:
    cmp rcx, r14            ; check if all chars processed
    jge .build_freq2        ; if yes, build freq2
    
    movzx rax, byte [r12 + rcx]  ; rax = str1[i] (zero-extend)
    inc qword [freq1 + rax*8]    ; freq1[char]++
    
    inc rcx                 ; i++
    jmp .freq1_loop
    
.build_freq2:
    ; build frequency array for str2
    xor rcx, rcx            ; rcx = index
.freq2_loop:
    cmp rcx, r15            ; check if all chars processed
    jge .compare_freq       ; if yes, compare frequencies
    
    movzx rax, byte [r13 + rcx]  ; rax = str2[i]
    inc qword [freq2 + rax*8]    ; freq2[char]++
    
    inc rcx                 ; i++
    jmp .freq2_loop
    
.compare_freq:
    ; compare frequency arrays
    xor rcx, rcx            ; rcx = index (0 to 255)
.compare_loop:
    cmp rcx, 256            ; check if all ASCII values checked
    jge .is_anagram         ; if yes, they are anagrams
    
    mov rax, [freq1 + rcx*8]    ; rax = freq1[i]
    mov rbx, [freq2 + rcx*8]    ; rbx = freq2[i]
    cmp rax, rbx            ; compare frequencies
    jne .not_anagram        ; if not equal, not anagrams
    
    inc rcx                 ; i++
    jmp .compare_loop
    
.is_anagram:
    mov rax, 1              ; return 1 (true)
    jmp .return
    
.not_anagram:
    xor eax, eax            ; return 0 (false)
    
.return:
    pop r15                 ; restore callee-saved registers
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    ret                     ; return from function
