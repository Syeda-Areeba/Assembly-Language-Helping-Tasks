.MODEL SMALL	
.STACK 100H

.DATA
Num DW 1010
Digit DW ?

.CODE

MOV AX,@DATA
MOV DS,AX

JMP MAIN

Leave_line PROC

	MOV DX,13
	MOV AH,02
	INT 21H
	
	MOV DX,10
	MOV AH,02
	INT 21H

	RET
Leave_line ENDP

Power PROC 

	PUSH CX
	PUSH AX
	
	CMP CX,0
	JE ZERO
	
	MOV AX,2
		
	CMP CX,1
	JE CONT
	JMP L4
	
	ZERO:
		MOV AX,1
		JMP CONT
	
	L4:
		MOV BX,2
		DEC CX ; LOOP TILL CX-1 TIMES
	
	L2:
		MUL BL 
	LOOP L2
	
	CONT:
		MOV BX,AX ; ANS IN BL
		MOV AX,Digit
		
		MUL BL
		MOV Digit,AX
		
		POP AX
		POP CX

	RET
Power ENDP

MAIN:

MOV AX,Num
MOV CX,0
MOV DX,10

L1:
	DIV DL
	MOV BH,0
	MOV BL,AH
	MOV Digit,BX  ; REMAINDER
	
	CMP Digit,0
	JE next
	
	CALL Power
	
	next:
		PUSH Digit
	
	CMP AL,0
	JE Stop	
	
	INC CX
	MOV AH,0
	JMP L1
	
Stop:
	INC CX
	MOV AX,0
	L3:
		POP DX
		ADD AX,DX
	LOOP L3
	
MOV BL,10
DIV BL

MOV BH,AH
MOV BL,AL

MOV DL,BL
ADD DL,48
MOV AH,02
INT 21H

MOV DL,BH
ADD DL,48
MOV AH,02
INT 21H

CALL Leave_line
	
MOV AH,4CH
INT 21H
END