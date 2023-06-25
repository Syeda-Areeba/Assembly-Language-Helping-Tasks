.MODEL SMALL
.STACK 100h

.DATA
;msg db 'Enter number: ','$'
arr db 1,2,3,4,5,6,7,8,9
arr_len = $-arr
num_cols DW 3
counter DW 0

.CODE

MOV AX,@DATA
MOV DS,AX

JMP MAIN

Leave_line PROC

	MOV DX,13  ; moves to the start of the current line
	MOV AH,02
	INT 21H

	MOV DX,10  ; moves to the next line
	MOV AH,02
	INT 21H
	
	RET
Leave_line ENDP

Display PROC

MOV BX,OFFSET arr
MOV CX,num_cols

D1:
	MOV counter,CX
	MOV CX,num_cols
	
	MOV SI,0
	
	D2:
		MOV DL,[BX+SI]
		ADD DL,48
		MOV AH,02
		INT 21H
		
		INC SI
		
		MOV DL,' '
		MOV AH,02
		INT 21H
	
	LOOP D2
	
	MOV CX,counter
	ADD BX,num_cols
	CALL Leave_line
	
LOOP D1

	RET
Display ENDP

MAIN:

MOV SI,0
MOV BX,OFFSET arr
MOV CX,num_cols

L1:
	MOV AL,[arr+SI]
	MOV DL,[BX]
	
	MOV [arr+SI],DL
	MOV [BX],AL
	
	ADD BX,num_cols
	INC SI	
LOOP L1

MOV AL, [arr+3+2]  ; since upper triangle id already transposed, so setting just lower triangle
MOV AH,[arr+6+1]
MOV [arr+3+2],AH
MOV [arr+6+1],AL

MOV CX,num_cols
MOV BX,OFFSET arr

L2:
	MOV SI,num_cols ; FIRST TIME 3
	DEC SI ; 2,1,0
	
	MOV AL,[BX] ; COL WISE
	MOV AH,[BX+SI] ; ROW WISE
	
	MOV [BX], AH
	MOV [BX+SI],AL
	
	ADD BX,num_cols
	
LOOP L2

CALL Display
CALL Leave_line

MOV AH,4CH
INT 21H
END