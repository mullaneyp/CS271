TITLE Program Template     (template.asm)

; Author:  Patrick Mullaney 
; Course / Project ID  271 Program 4        Date: 2/16/17
; Description: Simple program to display composite numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER_LIMIT = 400

.data

; (insert variable definitions here)

intro1		BYTE	"Composite Numbers	Programmed by Patrick Mullaney", 0
instruct1	BYTE	"Enter the number of composite numbers you would like to see.",0
instruct2	BYTE	"I'll accept orders for up to 400 composites.",0
prompt1		BYTE	"Enter the number of composites to display [1...400]:", 0
userNum		DWORD	?
validNum	DWORD	?
invalidNum	BYTE	"Out of range.  Try again.", 0
composite	DWORD	?
count		DWORD	?
newLine		DWORD	0
space		BYTE	"   ", 0
extra		BYTE	"*EC: .", 0
validMess	BYTE	"Valid num: ", 0
result		BYTE	"Results certified by Patrick Mullaney.  Goodbye.",0

.code
main PROC

; (insert executable instructions here)
; introduction
call	introduction
; get userData will prompt for number to be input
call	getUserData

; calculate and show composites
call	showComposites
; display farewell
call	farewell

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)
; introduction - displays instructions to user.
introduction	PROC
mov		edx, OFFSET	intro1
call	WriteString
call	Crlf
mov		edx, OFFSET instruct1
call	WriteString
call	Crlf
mov		edx, OFFSET instruct2
call	WriteString
call	Crlf

ret
introduction	ENDP

; getUserData prompts user for number and performs input validation.
getUserData		PROC

; prompt user for number
unvalidated:
mov		edx, OFFSET prompt1
call	WriteString
call	ReadInt
mov		userNum, eax
; call validate to check if number within range.
call	validate
cmp		validNum, 1
jb		unvalidated

ret
getUserData	ENDP

; input validation subroutine
validate	PROC

; check if userNum is above 0
cmp		userNum, 0
ja		lowerValid
jmp		invalid

; if above 0, check not above upper limit
lowerValid:
cmp		userNum, UPPER_LIMIT
jbe		valid
jmp		invalid

; if number is out of range, prompt to enter another number.
invalid:
mov		edx, OFFSET invalidNum
call	WriteString
call	Crlf
jmp		endValid

valid:
mov		validNum, 1

endValid:
ret
validate	ENDP

; showComposites calculates and dsiplays composite numbers.
showComposites	PROC
mov		count, 1
mov		ecx, userNum  

show:
; call isComposite subroutine
call	isComposite
cmp		composite, 0	
je		notComposite	; Display if composite.
mov		eax, count
call	WriteDec
mov		edx, OFFSET space
call	WriteString
; Increment newLine, if newLine = 10, start new line.
inc		newLine
cmp		newLine, 10
jne		notComposite
call	Crlf
mov		newLine, 0

notComposite:
inc	count
loop show

ret
showComposites	ENDP
; isComposite subroutine
isComposite	PROC
mov	composite, 0	; initialize composite to 0 

mov		eax, count
cmp		eax, 2		
jbe		notComp
mov		ebx, 2
sub		edx, edx
div		ebx
cmp		edx, 0
jne		notDiv2
mov		composite, 1
jmp		comp

; If not divisible by 2, check if divisible by 3.
notDiv2:
mov		eax, count
cmp		eax, 3
jbe		notComp
mov		ebx, 3
sub		edx, edx
div		ebx
cmp		edx, 0
jne		notDiv3
mov		composite, 1
jmp		comp
;  If not divisible by 3, check if divisible by 5.
notDiv3:
mov		eax, count
cmp		eax, 5
jbe		notComp
mov		ebx, 5
sub		edx, edx
div		ebx
cmp		edx, 0
jne		notDiv5
mov		composite, 1
jmp		comp
; If not divisible by 5, check if divisible by 7.
notDiv5:
mov		eax, count
cmp		eax, 7
jbe		notComp
mov		ebx, 7
sub		edx, edx
div		ebx
cmp		edx, 0
jne		notComp
mov		composite, 1
jmp		comp

comp:
notComp:
ret
isComposite	ENDP

;  Farewell message 
farewell	PROC
call	Crlf
mov		edx, OFFSET result
call	WriteString
call	Crlf
ret
farewell	ENDP

END main


