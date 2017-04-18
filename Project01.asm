TITLE Program 01

; Author:  Patrick Mullaney
; CS271-400 Program 1                Date: 1/16/17
; Description: Simple program to calculate sum, difference, product, quotient, and remainder of two numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; variable definitions
number1		DWORD	?			; first number to be entered by user
number2		DWORD	?			; second number to be entered by user
intro1		BYTE	"Hello, my name is Patrick Mullaney, welcome to numbers.",0
instru		BYTE	"Please enter two numbers and I'll show you the sum, difference, product, quotient, and remainder.", 0
prompt1		BYTE	"Please enter first number ", 0
prompt2		BYTE	"Please enter second number less than ",0; first number: ", 0
;validate	BYTE	"Please enter a valid number.", 0
sum			DWORD	?			; sum
sumNum		BYTE	"Sum: ", 0
plus		BYTE	" + ", 0
equal		BYTE	" = ", 0
difference	DWORD	?			; difference
diffNum		BYTE	"Difference: ", 0
minus		BYTE	" - ", 0
product		DWORD	?			; product
prodNum		BYTE	"Product: ", 0
times		BYTE	" * ", 0
quotient	DWORD	?			; quotient
quotNum		BYTE	"Quotient: ", 0
divided		BYTE	"/", 0
remainder	DWORD	?			; remainder
remNum		BYTE	", remainder: ", 0
goodBye		BYTE	"Goodbye!", 0
playAgain	BYTE	"Press 1 to play again or 2 to exit.", 0
play		DWORD	?
extra1		BYTE	"**EC 1: Loop until user quits.",0 
extra2		BYTE	"**EC 2: Input validation that second number is less than first.",0
.code
main PROC

; introduction
	mov edx, OFFSET extra1 ; extra credit messages
	call	WriteString
	call	CrLF
	mov edx, OFFSET extra2
	call	WriteString
	call	CrLf
	call	CrLf
	 
	mov edx, OFFSET intro1 ; introduction
	call	WriteString
	call	CrLf
	call	CrLf

	mov edx, OFFSET instru	; instructions to user
	call	WriteString
	call	CrLf
	top:
; get data (prompt user to enter two integers)
	mov		edx, OFFSET	prompt1	; prompt for number 2
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		number1, eax

	inputValid:						; prompt for number 2 with input validation
	mov		edx, OFFSET prompt2
	mov		eax, number1
	call	WriteString
	call	WriteDec
	call	CrLf
	call	ReadInt				
	mov		number2, eax
	cmp		eax, number1			; compare number2 to number1
	jl		valid					; jump to valid if number 2 is lesser
	jmp		inputValid				; if number 2 is not lesser, jump back to inputValid

	valid:							; if number 2 is valid, continue.
	; Calculate values
	mov		eax, number1	; calculate sum
	mov		ebx, number2
	add		eax, ebx
	mov		sum, eax

	mov		eax, number1	; calculate difference
	mov		ebx, number2
	sub		eax, ebx
	mov		difference, eax

	mov		eax, number1	; calculate product
	mov		ebx, number2
	mul		ebx
	mov		product, eax

	mov		eax, number1	; calculate division
	mov		ebx, number2
	div		ebx
	mov		quotient, eax

	mov		remainder, edx

	; display results
	mov		edx, OFFSET	sumNum ; report sum
	call	WriteString
	; try 2
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString

	mov		eax, sum
	call	WriteDec
	call	CrLf

	mov		edx, OFFSET diffNum ; report diff
	call	WriteString
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET	equal
	call	WriteString

	mov		eax, difference
	call	WriteDec
	call	CrLF

	mov		edx, OFFSET prodNum ; report product
	call	WriteString
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET times
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLF

	mov		edx, OFFSET quotNum ; report quotient
	call	WriteString
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET divided
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	;call	CrLF

	mov		edx, OFFSET remNum ; report remainder
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLF
	
	; EC attempt: quotient as floating point - did not get working.
	; mov		eax, number1
	;fild	number1
	;fdiv	number2
	;mov		number1, eax
	;mov		eax, number1
	;call	WriteDec
	;call	CrLf

; play again
	mov		edx, OFFSET playAgain	; prompt user to play again or quit
	call	WriteString
	call	ReadInt
	mov		play, eax
	cmp		play, 1		; If user selects 1, jump back to top
	je		top

; say goodbye
	mov		edx, OFFSET	goodBye
	call	WRITESTRING
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
