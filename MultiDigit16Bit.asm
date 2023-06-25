.MODEL SMALL
.STACK 100h

.DATA
msg DB 'Enter a Number: ','$'
number DD 0
digit DB 0

.CODE

MOV AX,@DATA
MOV DS,AX

JMP MAIN

INPUT PROC
	MOV AH,01 ; take input
	INT 21H
	
	CMP AL,13 ; carriage return
	JE Exit

	SUB AL,48
	MOV digit,AL ; store new digit in BL
	
	MOV BX,10  ; store 10 in BH to multiply
	MOV AX,WORD PTR [number]  ; multiply already stored number by 10
	MUL BX ; DX:AX = AX*BX

	MOV BH,0  
	MOV BL,digit
	ADD AX,BX  ; add new digit to lower 16-bit
	
	MOV WORD PTR [number],AX	
	MOV WORD PTR [number+2],DX  ; update number
	
	CALL INPUT
	
	Exit:
		RET
INPUT ENDP

OUTPUT PROC
	MOV BX,10
	DIV BX ; quo = AX, rem = DX
	
	CMP AX,0 ; if quo is zero => stop
	
	JNE continue
		ADD DX,48  ; display last remainder which is actually first digit
		MOV AH,02
		INT 21H
		
		RET 
	continue:

	PUSH DX 

	MOV DX,0
	
	CALL OUTPUT
	
	POP BX

	MOV DX,BX
	ADD DX,48
	MOV AH,02
	INT 21H

	RET
OUTPUT ENDP

Leave_Line PROC
	MOV DX,13
	MOV AH,02
	INT 21H

	MOV DX,10
	MOV AH,02
	INT 21H
	
	RET
Leave_Line ENDP

MAIN:

LEA DX,msg
MOV AH,09
INT 21H

CALL INPUT ; INPUT IS IN NUMBER
CALL Leave_Line

;MOV AX,30
;MOV BX,10
;MUL BX 

MOV DX, WORD PTR [number+2]
MOV AX, WORD PTR [number]
CALL OUTPUT

MOV AH,4CH
INT 21H

END
