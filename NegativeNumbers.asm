.MODEL SMALL
.STACK 100h

.DATA
msg db 'Enter number: ','$'
size_msg db 'Enter size: ','$'
arr DB 20 dup (?)
size_arr DB 0
;counter DB 0
count DB 0
FLAG DB ?

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
	
	MOV BX,10  ; store 10 in BX to multiply
	MOV AX,WORD PTR [number]  ; multiply already stored number by 10 (lower bits of number)
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

CHECK_FREQ PROC ; NUM IN ax
	
	PUSH CX
	MOV count,0
	MOV DI, OFFSET arr
	MOV CX,0
	MOV CL,size_arr
	L2:
		CMP [DI],AL
		JNE Next
		INC count
		
		Next:
		INC DI
		LOOP L2
	
	POP CX
	RET
CHECK_FREQ ENDP

MAIN:

LEA DX,size_msg
MOV AH,09
INT 21H

MOV AH,01
INT 21H
SUB AL,48
MOV size_arr,AL

;MOV size_arr,2

CALL Leave_Line

MOV CH,0
MOV CL,size_arr
MOV SI,OFFSET arr

;MOV CX,2

input1:
	
	MOV FLAG,0   ; clear flag by moving zero
	MOV WORD PTR [number],0  ; clear number by moving zero
	MOV WORD PTR [number+2],0
	
	LEA DX,msg
	MOV AH,09
	INT 21H

	MOV AH,01
	INT 21h
	
	CMP AL,'-'
	JNE POS
	MOV FLAG,1
	JMP CONT
	
	POS:
	SUB AL,48
	MOV BYTE PTR [number],AL
	
	CONT:
	CALL INPUT
	MOV AL,BYTE PTR [number]
	MOV [SI],AL
	
	CMP FLAG,1
	JNE NEXT1
	MOV AL,[SI]
	NEG AL
	MOV [SI],AL
	
	NEXT1:
	INC SI
	CALL Leave_Line
	
loop input1
	
MOV SI,offset arr
MOV CH,0
MOV CL,size_arr

L1:

	MOV AH,0
	MOV AL,[SI]
	CALL CHECK_FREQ
	
	MOV DX,0
	
	NEG AL
	
	JNS display_neg  ; if no is pos after neg
	NEG AL
	JMP display_pos
	
	display_neg:
	PUSH AX
	
	MOV DL,'-'
	MOV AH,02
	INT 21H
	
	POP AX
	MOV DX,0
	
	display_pos:
	CALL OUTPUT
	
	MOV DL,':'
	MOV AH,02
	INT 21H
	
	MOV DL,count
	ADD DL,48
	MOV AH,02
	INT 21H
	
	INC SI
	
	CALL Leave_Line
	
loop L1

MOV AH,4CH
INT 21H

END