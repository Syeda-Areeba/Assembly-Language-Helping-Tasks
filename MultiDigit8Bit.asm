.MODEL SMALL
.STACK 100H

.DATA
msg DB 'Enter number: ', '$'
number DW 0

.CODE

MOV AX,@DATA
MOV DS,AX

JMP MAIN

INPUT_NUM PROC ; TAKES MULTI DIGIT INPUT AND STORE IT IN NUMBER VARIABLE
	MOV AH,01 ; take input
	INT 21H
	
	CMP AL,13 ; carriage return
	JE Exit1

	SUB AL,48
	MOV BL,AL ; store new digit in BL
	
	MOV BH,10  ; store 10 in BH to multiply
	MOV AX,number ; multiply already stored number by 10
	MUL BH ; AX = AL*BH , but ans will be in AL only becuase only 1 digit

	MOV BH,0  
	ADD AX,BX  ; add new digit to old number
	
	MOV number,AX  ; update number
	
	CALL INPUT_NUM
	
	Exit1:
		RET
INPUT_NUM ENDP

OUTPUT_NUM PROC ; DISPLAYS MULTI DIGIT NUMBER STORED IN AX
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
	
	CALL OUTPUT_NUM
	
	POP BX

	MOV DX,BX
	ADD DX,48
	MOV AH,02
	INT 21H

	RET
OUTPUT_NUM ENDP

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

CALL INPUT_NUM

MOV AX,number
MOV DX,0
CALL OUTPUT_NUM

MOV AH,4CH
INT 21H

END