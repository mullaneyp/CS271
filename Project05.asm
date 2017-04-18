TITLE Program Template     (template.asm)

; Author:  Patrick Mullaney
; CS271 Program 5                 Date: 2/22/17
; Description: Program to display random range of numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN = 10
MAX = 200
LO = 100
HI = 999

.data

; (insert variable definitions here)
intro1		BYTE	"Sorting Random Integers	Programmed by Patrick Mullaney", 0
instruct1	BYTE	"This program generates random numbers in the range [100...999],",0
instruct2	BYTE	"displays the original list, sorts the list, and calculates the median value.",0
instruct3	BYTE	"Finally, it displays the list sorted in descending order.",0
prompt1		BYTE	"How many numbers should be generated? [10...200]: ", 0
invalidNum	BYTE	"Out of range.  Try again.", 0
titleUnsort	BYTE	"The unsorted random numbers: ",0
titleSort	BYTE	"The sorted list: ",0
median		BYTE	"The median is: ", 0
space		BYTE	"   ",0
request		DWORD	?
array		DWORD	200	DUP(?)
space1		BYTE	" ",0

.code
main PROC

; seed random
	call	Randomize

; introduction
	push	OFFSET intro1
	push	OFFSET instruct1
	push	OFFSET instruct2
	push	OFFSET instruct3
	call	introduction

; get data
	push	OFFSET request
	call	getData	

; fill array
	push	request
	push	OFFSET	array
	call	fillArray

; display unsorted list.
	push	OFFSET	array
	push	request
	push	OFFSET	titleUnsort
	call	display

; sort list.
	push	OFFSET	array
	push	request
	call	selectSort

; calculate and display median.
	mov		edx, OFFSET median
	call	WriteString
	push	OFFSET	array
	push	request
	call	dispMed
	 
; display sorted list.
	push	OFFSET	array
	push	request
	push	OFFSET	titleSort
	call	display

	exit	; exit to operating system
main ENDP
;  Introduction displays introduction/title message as well as instructions to user.
introduction PROC
	push	ebp
	push	edx
	mov		ebp, esp
	mov		edx, [ebp+24] ; intro1
	call	WriteString
	call	Crlf
	mov		edx, [ebp+20] ; intstruct1
	call	WriteString
	call	Crlf
	mov		edx, [ebp+16] ; instruct2
	call	WriteString
	call	Crlf
	mov		edx, [ebp+12] ; instruct 3
	call	WriteString
	call	Crlf
	call	Crlf

	pop		edx
	pop		ebp
ret 16
introduction ENDP

; getData prompts user for number and performs input validation.
getData		PROC
	push	ebp
	push	eax		
	push	ebx	
	push	edi			
	mov		ebp, esp
	mov		ebx, [ebp+20]	; Move @ request into ebx.

; prompt user for number
unvalidated:
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		[ebx], eax
; call validate to check if number within range.
	mov		edi, 0			
	call	validate
	cmp		edi, 1			; If request is valid, edi set to 1.
	jb		unvalidated
	call	Crlf
	pop		edi
	pop		ebx
	pop		eax
	pop		ebp
ret 4
getData	ENDP

; Validate is an input validation subroutine.
validate	PROC

	push	eax
	mov		edi, 0	; edi 0 if unvalidated, 1 if valid.

; check if request is above or equal to 10.
	cmp		eax, MIN
	jae		lowerValid
	jmp		invalid

; If above or equal to 10, check not above upper limit.
lowerValid:
	cmp		eax, MAX
	jbe		valid
	jmp		invalid

; If number is out of range, prompt to enter another number.
invalid:
	mov		edx, OFFSET invalidNum
	call	WriteString
	call	Crlf
	jmp		endValid

valid:
	mov		edi, 1		; If valid, set to 1.

endValid:
	pop		eax			
	ret
validate	ENDP

; fillArray receives @ array and request #, then fills array with random numbers.
fillArray	PROC
	push	ebp
	push	esi	
	push	ecx	
	push	eax	
	mov		ebp, esp
	mov		esi, [ebp+20]	; @ of array to esi
	mov		ecx, [ebp+24]	; initialize loop to request

fill:
	mov		eax, HI			; generate random number (from lecture 20).
	sub		eax, LO		
	inc		eax			
	call	RandomRange		
	add		eax, LO		
	mov		[esi], eax		; insert into array
	add		esi, 4
	loop	fill

	pop		eax
	pop		ecx
	pop		esi
	pop		ebp
ret 8
fillArray	ENDP
; display receives a title message, @array, and request, and displays the contents of the array.
; *Modeled after lecture 20.
display	PROC
	push	ebp
	push	esi
	push	ecx
	push	eax
	push	edx
	mov		ebp, esp
	mov		esi, [ebp+32]	; @ array
	mov		ecx, [ebp+28]	; request
	mov		eax, esi
	
	mov		edx, [ebp+24]	; Move display title into edx.
	call	WriteString
	call	Crlf
	mov		ebx, 10			; ebx used for new line count.

printNum:
	mov		eax, [esi]
	call	WriteDec
	dec		ebx
	mov		edx, OFFSET space
	call	WriteString
	add		esi, 4
	cmp		ebx, 0			; If ebx = 0, new line is started.
	ja		line
	call	Crlf
	mov		ebx, 10
	line:
	loop	printNum
	call	Crlf

	pop		edx
	pop		eax
	pop		ecx
	pop		esi

	pop		ebp
	ret		12
display	ENDP
; dispMed recieves array and request number, then calculates and displays median.
; For median calculation, if request number is even (request%2 is 0), the average of the 
; two middle numbers is calculated.  Else if request number is odd (request%2 is 1), 
; the middle number is the median.
dispMed	PROC
	push	ebp
	push	eax
	push	ebx
	push	edx

	mov		ebp, esp
	
	mov		eax, [ebp+20]	; Move request to eax.
	mov		ebx, 2
	sub		edx, edx
	div		ebx
	cmp		edx, 0			; Determine if odd or even.
	ja		odd
	mov		ebx, 4			; If even:
	dec		eax				; element is -1
	mul		ebx				; median @ = element x 4
	mov		ebx, eax		; median
	mov		eax, [ebp+24]	; @ array
	add		eax, ebx
	mov		ebx, eax		; @ array + median
	mov		eax, [eax]
	add		ebx, 4
	mov		ebx, [ebx]
	add		eax, ebx		; add two middle numbers.
	mov		ebx, 2
	sub		edx, edx
	div		ebx				; divide by 2 to get average.
	call	WriteDec
	jmp		endMed

	odd:					; If request is odd.
	mov		ebx, 4
	mul		ebx
	mov		ebx, eax
	mov		eax, [ebp+24]	; @ array
	add		eax, ebx		; @ array + median
	mov		eax, [eax]
	call	WriteDec
	
	endMed:
	call	Crlf
	call	Crlf

	pop		edx
	pop		ebx
	pop		eax
	pop		ebp
	ret 8
dispMed	ENDP
; selectSort recieves array and request number.  It then sorts the
; array from highest to lowest based on selection sort algorithm in 
; text and assignment instructions.
selectSort	PROC
	push	ebp
	push	eax
	push	ebx
	push	ecx
	push	edi
	push	esi

	mov		ebp, esp
	mov		ecx, [ebp+28]	; move request into ecx
	mov		esi, [ebp+32]	; move @array into esi	
	dec		ecx				; request - 1
outerLoop:
	mov		eax, [ebp+28]	; k = (request-loopcount)-1
	sub		eax, ecx		; i = k
	dec		eax

	mov		ebx, 4
	mul		ebx				; @k = element * 4
	mov		edi, eax		
	mov		ebx, eax
	add		ebx, 4			; j = k + 4
	push	ecx
innerLoop:
	mov		eax, [ebp+28]	; k = (request-loopcount)-1
	sub		eax, ecx
	dec		eax
	mov		ebx, 4
	mul		ebx				;  @k = k * 4 + array
	mov		ebx, eax	
	add		ebx, 4			; j = k + 1
	mov		eax, [esi+edi]	; arr[i] 
	mov		ebx, [esi+ebx]	; arr[j]
	cmp		eax, ebx		; Compare arr[i] and arr[j]
	jae		notSwap			
	; If (arr[j]>arr[i], i = j
	mov		eax, [ebp+28]	; j = (request-loopcount)-1
	sub		eax, ecx
	mov		ebx, 4
	mul		ebx				
	mov		edi, eax		; Update edi w/ new value of i

	notSwap:
	loop	innerLoop
	pop		ecx

	; exchange (array[k], array[i])
	mov		eax, [ebp+28]	; k = (request-loopcount)-1
	sub		eax, ecx
	dec		eax
	mov		ebx, 4
	mul		ebx				; @k = array + k * 4
	mov		ebx, eax
	mov		eax, [ebp+32]	
	add		eax, ebx
	push	eax				; push k

	mov		eax, edi		; Get i
	mov		ebx, eax
	mov		eax, [ebp+32]	; @array
	add		eax, ebx		; @i = @array + i
	push	eax
	call	swap
	loop	outerLoop

	pop		esi
	pop		edi
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
ret 8
selectSort	ENDP
; swap recieves @ of j and @ of k and swaps the contents of each.
swap	PROC
	push	ebp
	push	eax
	push	ebx
	mov		ebp, esp
	mov		eax, [ebp+20]		; @j
	mov		ebx, [ebp+16]		; @k
	push	edi
	mov		edx, [eax]			; mov j to edx
	mov		edi, [ebx]			; mov k to edi 
	mov		[eax], edi			; mov k to @ j
	mov		[ebx], edx			; mov j to @k

	pop		edi
	pop		ebx
	pop		eax
	pop		ebp
ret	8
swap	ENDP
END main


