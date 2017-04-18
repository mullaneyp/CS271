TITLE Program Template     (template.asm)

; Author: Patrick Mullaney
; CS271 400                 Date: 1/21/17
; Description: Simple program to display Fibonacci sequence.

INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER_LIMIT = 46

.data

; (insert variable definitions here)
userName	BYTE	33 DUP(0)	;string to be entered by user
intro1		BYTE	"Fibonnaci Numbers", 0
intro2		BYTE	"Programmed by Patrick Mullaney", 0
prompt1		BYTE	"What is your name? ", 0
greet		BYTE	"Hello ", 0
instruct1	BYTE	"Enter the number of Fibonacci terms to be displayed.",0
instruct2	BYTE	"Give the number as an integer in the range of [1-46].",0
prompt2		BYTE	"How many Fibonnaci terms do you want?", 0
fiboNum		DWORD	?
space		BYTE	"     ", 0
sum			DWORD	?	; will store sum of num1 + num2
num1		DWORD	?	; will store num1 for each round
num2		DWORD	?	; will store num2 for each round
line		DWORD	?	; used to track # displayed each line
validate	BYTE	"Please enter a number between 1-46.",0
result		BYTE	"Results certified by Patrick Mullaney",0
goodBye		BYTE	"Goodbye, ", 0
period		BYTE	".",0	

.code
main PROC

; introduction
mov		edx, OFFSET intro1
call	WriteString
call	CrLf
mov		edx, OFFSET intro2
call	WriteString
call	CrLf	
mov		edx, OFFSET prompt1
call	WriteString
mov		edx, OFFSET userName
mov		ecx, 32
call	ReadString
mov		edx, OFFSET greet
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf
call	CrLf

; userInstructions
mov		edx, OFFSET instruct1
call	WriteString
call	CrLf
mov		edx, OFFSET instruct2
call	WriteString
call	CrLf
call	CrLf

; getUserData
mov		edx, OFFSET prompt2
call	WriteString

inputValid:
call	ReadInt
mov		fiboNum, eax
					
; input validation
mov		ebx, UPPER_LIMIT
cmp		eax, ebx			; compare fiboNum to limit
jbe		valid				; jump to valid if is less than or equal
mov		edx, OFFSET validate
call	WriteString			; Display error message
jmp		inputValid			; if fiboNum is greater, jump back to inputValid

valid:	
sub		fiboNum, 2 ; subtract 2 from fiboNum (first two 1's will be displayed)
mov		ecx, fiboNum ; initialize counter with fiboNum
mov		eax, 1
mov		ebx, 1
mov		num1, 1 ; start with 1
mov		num2, 1 ; start with 1
mov		line, 2 ; initialize line counter
call	WriteDec ; display num1, 1
mov		edx, OFFSET space
call	WriteString
call	WriteDec ; display num2, 1
mov		edx, OFFSET space
call	WriteString

; displayFibs
fib:
mov		eax, num1 ; mov num1 to eax
mov		ebx, num2 ; num2 to ebx
add		eax, ebx ; 
mov		sum, eax ; mov num1+num2 to sum
call	WriteDec
mov		edx, OFFSET space
call	WriteString

; determine if output should be on new line
 inc		line	; increment line counter
 cmp		line, 5 ; compare line to 5
 jne		up		; if not equal, jump
 call		Crlf	; if equal, create new line and reset to 0
 mov		line, 0

up:
; update numbers next loop
mov		eax, sum ; mov sum into eax
mov		ebx, num1 ; mov num1 from eax to ebx
mov		num2, ebx ; mov num1 value in ebx to num2
mov		num1, eax ; mov sum value in eax into num1
loop	fib

; farewell
call	CrLf
call	CrLf
mov		edx, OFFSET result
call	WriteString
call	CrLf
mov		edx, OFFSET goodBye
call	WriteString
mov		edx, OFFSET userName
call	WriteString
mov		edx, OFFSET period
call	WriteString
call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
