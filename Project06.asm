TITLE Program Template     (template.asm)

; Author:  Patrick Mullaney
; CS271 Program 6A                Date: 2/28/17
; Description: Program 

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; (insert variable definitions here)
intro1		BYTE	"PROGRAM 6A:  Designing low-level I/O procedures",0	
intro2		BYTE	"Written by Patrick Mullaney.",0
instruct1	BYTE	"Please provide 10 unsigned decimal integers.",0
instruct2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
instruct3	BYTE	"After you have finished inputting the raw numbers I will display a list",0
instruct4	BYTE	"of the integers, their sum, and their average value.",0
prompt1		BYTE	"Please enter an unsigned number: ", 0
display1	BYTE	"You entered the following numbers: ",0
sumMess		BYTE	"The sum of these numbers is: ", 0
avgMess		BYTE	"The average is: ", 0
errorMess	BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
goodbye		BYTE	"Thanks for playing!",0
space		BYTE	"   ",0
stringArr	DWORD	10	DUP(?) 
sumNum		DWORD	?
avgNum		DWORD	?
stringNum	BYTE	20	DUP(?)	
numSize		DWORD	?
numArr		DWORD	10	DUP(?)
comma		BYTE	", ", 0
space1		BYTE	" ",0
loopCt		BYTE	"Loop: ", 0

getString MACRO	prompt1, stringNum, numSize
	push	ecx
	push	edx
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET stringNum
	mov		ecx, (SIZEOF stringNum)-1 
	call	ReadString
	mov		numSize, eax 
	pop		edx
	pop		ecx
endM

displayString	MACRO  numArr
	push	edx
	mov		edx, OFFSET numArr
	call	WriteString
	pop		edx
endM
.code
main PROC

; (insert executable instructions here)

	; Introduction and instructions.
	push	OFFSET instruct4
	push	OFFSET instruct3
	push	OFFSET instruct2
	push	OFFSET instruct1
	push	OFFSET intro2
	push	OFFSET intro1
	call	introduction

	; Read array of strings and convert to numeric array with readVal.
	push	OFFSET	prompt1
	push	OFFSET	numSize	
	push	OFFSET	stringNum
	push	OFFSET	numArr 
	push	OFFSET	errorMess 
	call	readVal
	call	Crlf

	; Convert numeric array to string and display with writeVal.
	push	OFFSET	comma
	push	OFFSET	display1
	push	OFFSET	numArr			
	push	OFFSET	stringNum 
	push	OFFSET	stringArr		
	push	OFFSET	numSize
	call	WriteVal
	call	Crlf

	; Calculate and display sum.
	push	OFFSET	sumNum
	push	OFFSET	sumMess
	push	OFFSET	numArr
	call	sumCal

	; Calculate and display average.
	push	OFFSET	sumNum
	push	OFFSET	avgMess
	push	OFFSET	avgNum
	call	avgCal
	call	Crlf

	; Display goodbye message.
	mov		edx, OFFSET goodbye
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

; Procedure to prompt user for 10 unsigned numbers in string form via getString.
; Procedure performs input validation to verify valid characters as well as size
; of numbers that will fit in eax.  Procedure then converts the array of strings 
; into a numeric array for calculations.
; receives: @prompt1, @numSize, @stringNum, @numArr (numeric array),
; @errorMess.
; returns: None.
; preconditions:  none 
; registers changed: eax, ebx, ecx, edx, esi, and edi.
readVal	PROC
	push	ebp
	mov		ebp, esp
	pushad

	mov		edi, [ebp+12]			; @numArr.	
	mov		ecx, 10
	outerLoop:
	push	ecx 
	push	edi   
	push	esi 
	push	ecx	

	unvalidated:					; Get string from user.
	mov		esi, [ebp+16]				
	getString	prompt1, stringNum, numSize	

	; Check size first.
	mov		ecx, [ebp+20]			; @numSize
	mov		ecx, [ecx]				; numSize
	mov		edi, 0
	push	ecx
	sizeCheck:					
		push	ecx
		dec		ecx  
		mov		eax, 1 
		cmp		ecx, 0
		je		noMult
		bitCount:					; Get byte position.
			mov		edx, 10		
			mul		edx				; Mul by 10.
			loop	bitCount
		noMult:
		mov		ebx, eax			; Move byte position to ebx.
		mov		eax, 0	
		lodsb						; Load byte.
		sub		al, 48
		mul		ebx					; Multiply by byte count.
		pop ecx
		jc	endsize					; If carry flag set, jump to end.
		add edi, eax			
		loop sizeCheck
		endsize:
		pop ecx
		jc invalid					; If number too large, CF set.

	; If size of user number is valid, check for valid characters.
	cld
	mov		esi, [ebp+16]
	scanBytes:
		lodsb	
		cmp		al, 48
		jb		invalid	
		cmp		al, 57
		ja		invalid 
		loop	scanBytes
		jmp		endValid

	invalid:
		mov		edx, [ebp+8]		; Display error message. 
		call	WriteString
		call	Crlf

		; Discard contents of invalid numbers.
		mov		ebx, [ebp+16]		; @stringNum.
		push	ecx
		mov		ecx, [ebp+20]		; @numSize.
		mov		ecx, [ecx]
		discard:
		mov		eax, 0
		mov		[ebx], eax
		inc		ebx
		loop	discard
		pop		ecx					; End discard string. 
		jmp		unvalidated
	
	endValid:
		pop		ecx
		pop		esi	
		mov		esi, [ebp+16]		; @stringNum.
		mov		ecx, [ebp+20]		; @numSize.
		mov		ecx, [ecx]			; numSize.	
		mov		edi, [ebp+16]		; @stringNum.
		cld							; Convert to numeric.
		toNum:	
		lodsb	
		sub		al, 48				; Convert byte from ASCII.
		stosb						; Store in stringNum.
		loop	toNum
		pop		edi 
		pop		ecx					; End validation of number.

	; Store number.
	push	esi
	push	ecx
	mov		ecx, [ebp+20]			; @numSize.
	mov		ecx, [ecx]				; numSize.
	mov		edx, 0
	mov		esi, [ebp+16]			; @stringNum.
	mov		eax, 0 
	cld
	store:
		push	ecx
		dec		ecx
		mov		eax, 1 
		cmp		ecx, 0
		je		noMul
		count:						; Get byte position.
		mov		edx, 10		
		mul		edx					; Mul by 10.
		loop	count
		noMul:
		mov		ebx, eax			; Move byte position to ebx.
		pop		ecx
		mov	eax, 0
		lodsb						; Load byte.
		mul		ebx					; Multiply by byte count.
		mov	ebx, eax				; Number to add.
		mov	edx, [edi]				; Move contents of edi into edx.
		add	edx, ebx				; Add next digit.
		mov [edi], edx				; Store digit string.
		loop	store
		pop		ecx
		pop		esi

	mov		[edi], edx				; Store digit string numArr.
	add		edi, 4					; Increment edi for next element.
	dec		ecx
	cmp		ecx, 0
	jnz		outerLoop				; End outerLoop.

	popad
	pop		ebp
ret 20
readVal	ENDP

; Procedure displays program introduction and instructions to user.
; receives: @intro1, @intro2, @instruct1, @instruct2, @instruct3, and @instruct4.
; returns: None.
; preconditions:  None.
; registers changed: edx.
introduction PROC
	
	push	ebp
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+8]			; @intro1.
	call	WriteString
	call	Crlf
	mov		edx, [ebp+12]			; @intro2.
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx, [ebp+16]			; @instruct1.
	call	WriteString
	call	Crlf
	mov		edx, [ebp+20]			; @instruct2
	call	WriteString
	call	Crlf
	mov		edx, [ebp+24]			; @instruct3
	call	WriteString
	call	Crlf
	mov		edx, [ebp+28]			; @instruct4
	call	WriteString
	call	Crlf
	call	Crlf

	pop		edx
	pop		ebp

ret 28
introduction ENDP

; Procedure to convert an array of 10 unsigned numbers in numeric 
; form to an array of strings for display.  Procedure copies numArr to stringArr 
; preserving numeric aspect of numArr for calculations.  After stringArr conversion,
; procedure utilizes displayString to display the array.
; receives: @comma, @display1 (string that displays message), numArr (numeric array),
; @ stringNum, @stringArr, @numSize.
; returns: None.
; preconditions:  none 
; registers changed: eax, ebx, ecx, edx, esi, and edi.
writeVal	PROC
	push	ebp	
	mov		ebp, esp
	pushad
	
	; First copy numArr into stringArr (numArr preserved for calculations).
	mov		esi, [ebp+20]			; @numArr.
	mov		edi, [ebp+12]			; @stringArr.
	cld
	mov		ecx, 10	
	rep		movsd

	; Begin conversion and display of numbers.
	mov		esi, [ebp+12]			; @stringArr.
	mov		ecx, 10 
	mov		edx, [ebp+24]			; Display message.
	call	WriteString
	call	Crlf

wOutloop:
	push ecx
	; Calculate numSize.
	mov		ecx, 0			
	mov		eax, [esi]				; Get numArr element into eax.
	getNumSize:				
	inc		ecx
	cmp		eax, 10					; Skip division for final digit.
	jb		noDiv
	mov		ebx, 10
	sub		edx, edx		
	div		ebx						; Divide by 10.
	cmp		eax, 0	
	ja		getNumSize
	noDiv:
	mov		edx, [ebp+8]			; @numSize.
	mov		[edx], ecx				; Update numSize
	pop	ecx							; End calculate numSize.

	; Convert from numeric to char.
	push	ecx
	mov		edi, [ebp+16]			; @ stringNum.
	mov		ecx, [ebp+8]			; @numSize.
	mov		ecx, [ecx]				; numSize.
	cld
	toString:				
		push	ecx 
		mov		eax, [esi]			; Load next byte from numArr (stringArr?)
		cmp		ecx, 1			
		je		wNoDiv
		calcBit:
		mov		ebx, 10
		sub		edx, edx
		div		ebx
		dec		ecx
		cmp		ecx, 1		
		ja		calcBit	
		wNoDiv:
		add		al, 48
		stosb						; Store byte.
		pop		ecx	
	
		; Update value in stringArr by subtracting bit added.
		push	ecx	
		update:			
		cmp		ecx, 1 
		je		noMult
		sub		eax, 48
		dec		ecx
		wMult:
		mov		ebx, 10
		mul		ebx		
		loop	wMult
		noMult:
		mov		ebx, eax
		mov		eax, [esi]
		sub		eax, ebx
		mov		[esi], eax
		pop		ecx
	loop	toString	
	mov		al, 0					; Null terminate string.
	stosb
	pop		ecx						; End convert from numeric to char.

	displayString stringNum			; Display stringNum.
	cmp ecx, 1
	je	endOuterLoop
	mov	edx, [ebp+28]				; @comma.
	call WriteString
	endOuterLoop:
	add		esi, 4					; Increment to next element.
	dec		ecx
	cmp		ecx, 0
	ja		wOutloop				; End outer loop.

	popad
	pop		ebp
ret 24
writeVal	ENDP

; Procedure to calculate sum of a numeric array. 
; receives: @sumNum, @sumMess (string that displays sum message), numArr (numeric array).
; returns: Calculated sum is stored in sumNum.
; preconditions:  None.
; registers changed: eax, ebx, ecx, edx, and edi. 
sumCal PROC
	push ebp
	mov ebp, esp
	pushad
	
	mov	eax, 0
	mov	edi, [ebp+8]				; @numArr.
	mov	ecx, 10				
	sum:
	mov ebx, [edi]					; Move element into ebx.
	add	eax, ebx					; Add to sum.
	add	edi, 4						; Increment for next element.
	loop sum
	mov	ebx, [ebp+16]				; @sumNum.
	mov [ebx], eax

	mov	edx, [ebp+12]				; @sumMess.
	call	WriteString
	call	WriteDec
	call	Crlf

	popad
	pop	ebp
ret 12
sumCal ENDP

; Procedure to calculate average of a numeric array. 
; receives: @sumNum, @avgMess (string that displays average message), @avgNum.
; returns: Calculated average is stored in avgNum.
; preconditions:  None. 
; registers changed: eax, ebx, and edx.
avgCal PROC
	push	ebp
	mov		ebp, esp
	pushad
	
	mov		eax, 0
	mov		eax, [ebp+16]			; @sumNum.
	mov		eax, [eax]
	mov		ebx, 10				
	sub		edx, edx
	div		ebx
	mov		ebx, [ebp+8]			; @avgNum.
	mov		[ebx], eax				; Update avg num.

	mov		edx, [ebp+12]			; @avgMess.
	call	WriteString
	call	WriteDec
	call	Crlf
	
	popad
	pop	ebp
ret 12	
avgCal ENDP

END main
