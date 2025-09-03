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
	
	mov rax,[a]
	mov rbx, rax
	add rbx, 1
	imul rax, rbx
	mov rcx, 2
	idiv rcx
		
	mov	rdi,out_fmt		
	mov	rsi,rax       
       
	mov	rax,0		
        call    printf		

	pop	rbp		

	mov	rax,0		
	ret		
