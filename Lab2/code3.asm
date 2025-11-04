; Program: Sum from 1 to n
; Description: Calculates sum of numbers from 1 to n using formula n(n+1)/2
; Example: If n=5, sum = 5*6/2 = 15 (i.e., 1+2+3+4+5 = 15)

extern	printf		
extern	scanf		

SECTION .data		

a:	dq	0                       ; variable to store input number

enter:	db "Enter number: ",0      ; prompt message
out_fmt:	db "Sum from 1 to n = %ld", 10, 0	; output format
out_fmt_2:	db "%s",10,0            ; string format
in_fmt:		db "%ld",0              ; input format
SECTION .text

global main		
main:				
        push    rbp	                ; save base pointer
        
        ; print prompt message
        mov rax,0
        mov rdi,out_fmt_2           ; format string
        mov rsi,enter               ; message to print
        call printf
        
        ; read input number
        mov rax, 0
	mov rdi, in_fmt             ; input format
	mov rsi, a                  ; address to store input
	call scanf
	
	; calculate sum using formula: sum = n(n+1)/2
	mov rax,[a]                 ; load n into rax
	mov rbx, rax                ; copy n to rbx
	add rbx, 1                  ; rbx = n+1
	imul rax, rbx               ; rax = n * (n+1)
	mov rcx, 2                  ; divisor = 2
	idiv rcx                    ; rax = n(n+1)/2
		
	; print the result
	mov	rdi,out_fmt		; output format
	mov	rsi,rax                 ; sum value to print
       
	mov	rax,0		
        call    printf		

	pop	rbp		        ; restore base pointer

	mov	rax,0		        ; return 0
	ret				


extern  printf
extern  scanf

SECTION .data
a:          dq 0
in_fmt:     db "%ld", 0
out_fmt:    db "%ld", 10, 0          ; "%ld\n"




; without prompt message

SECTION .text
global main
main:
    push    rbp

    ; read input number into [a]
    xor     rax, rax                 ; rax=0 for variadic call
    mov     rdi, in_fmt
    mov     rsi, a
    call    scanf

    ; rax = n(n+1)/2
    mov     rax, [a]                 ; rax = n
    mov     r8,  rax                 ; r8  = n
    inc     r8                       ; r8  = n + 1
    imul    rax, r8                  ; rax = n*(n+1)
    cqo                              ; sign-extend rax into rdx:rax
    mov     rcx, 2
    idiv    rcx                      ; rax = rax / 2

    ; print result as just the number + newline
    xor     rdx, rdx                 ; not needed, just keeping regs clean
    xor     rax, rax                 ; rax=0 for variadic call
    mov     rdi, out_fmt
    mov     rsi, rax                 ; sum
    call    printf

    pop     rbp
    xor     rax, rax                 ; return 0
    ret
