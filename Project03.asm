TITLE Program Template     (template.asm)

; Author:	Patrick Mullaney
; CS271 Project 03             Date:	02/01/2017
; Description:  Simple program to accumulate integers and calculate average.

INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER_LIMIT = -1
LOWER_LIMIT = -100

.data

; (insert variable definitions here)
userName	BYTE	33 DUP(0)	;string to be entered by user
intro1		BYTE	"Integer Accumulator", 0
intro2		BYTE	"Programmed by Patrick Mullaney.", 0
extra		BYTE	"*EC: Numbered lines.", 0
prompt1		BYTE	"What is your name? ", 0
greet		BYTE	"Hello ", 0
instruct1	BYTE	"Please enter numbers in [-100, -1].",0
instruct2	BYTE	"Enter a non-negative number when you are finished to see results.",0
prompt2		BYTE	". Enter a number: ", 0
total		SDWORD	?
count		SDWORD	?
avg			SDWORD	?
line		DWORD	?
validate	BYTE	"Please enter a number between -100 to -1.",0
result		BYTE	"Results certified by Patrick Mullaney.",0
goodBye		BYTE	"Goodbye, ", 0
period		BYTE	".",0	
zeroSum		BYTE	"No elements entered, unable to calculate results.", 0
elements	BYTE	"Number of elements: ", 0
sum			BYTE	"Sum: ", 0
average		BYTE	"Average: ", 0
.code
main PROC

; (insert executable instructions here)

; Greeting: Obtain username and greet
mov		edx, OFFSET intro1
call	WriteString
call	CrLf
mov		edx, OFFSET intro2
call	WriteString
call	Crlf	
call	Crlf
mov		edx, OFFSET extra
call	WriteString
call	Crlf
call	Crlf
mov		edx, OFFSET prompt1
call	WriteString
mov		edx, OFFSET userName
mov		ecx, 32
call	ReadString
mov		edx, OFFSET greet
call	WriteString
mov		edx, OFFSET userName
call	WriteString
mov		edx, OFFSET	period
call	WriteString
call	CrLf
call	CrLf

; Instructions to user
mov		edx, OFFSET instruct1
call	WriteString
call	CrLf
mov		edx, OFFSET instruct2
call	WriteString
call	CrLf
call	CrLf
mov		count, 0 
mov		line, 1

prompt:
; Prompt user for numbers
mov		eax, line
call	WriteDec
mov		edx, OFFSET prompt2
call	WriteString

inputValid:
call	ReadInt
cmp		eax, 0
jge		results

; input validation
mov		ebx, UPPER_LIMIT
cmp		eax, ebx				; compare user number to upper limit
jle		upperValid				; jump to upperValid if is less than or equal
call	WriteInt
mov		edx, OFFSET validate
call	WriteString				; Display upper error message	
jmp		inputValid

upperValid:
mov		ebx, LOWER_LIMIT
cmp		eax, ebx			; compare to lower limit
jge		valid				; jump to valid if above lower limit
call	WriteDec
mov		edx,OFFSET validate
call	WriteString			; error message
jmp		inputValid

valid:
inc		line
mov		ebx, total
add		eax, ebx
mov		total, eax
mov		eax, total
inc		count		; Increment count
cmp		eax, 0		; Compare to see if user has entered non-negative
jl		prompt		; Jump back to prompt while non-negative

; calculate and display results
results:
mov		eax, count
cmp		eax, 0
je		empty

mov		edx, OFFSET elements	; Display number of elements
call	WriteString
mov		eax, count
call	WriteDec
call	Crlf
mov		edx, OFFSET sum			; Display sum
call	WriteString
mov		eax, total
call	WriteInt
call	Crlf

; calculate and display average
mov		eax, total
mov		ebx, count
sub		edx, edx
cdq
idiv	ebx
mov		avg, eax

mov		edx, OFFSET average		; Display average
call	WriteString
mov		eax, avg
call	WriteInt
call	Crlf

; display exit message
mov		eax, count
cmp		eax, 0
jg		notEmpty

; If sum is empty
empty:	
mov		edx, OFFSET zerosum
call	WriteString
call	Crlf

; If sum is not empty
notEmpty:
mov		edx, OFFSET goodbye
call	WriteString
mov		edx, OFFSET userName
call	WriteString
mov		edx, OFFSET	period
call	WriteString
call	Crlf
mov		edx, OFFSET result
call	WriteString
call	Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
