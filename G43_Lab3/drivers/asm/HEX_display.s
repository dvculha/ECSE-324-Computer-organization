.text
.equ	HEX_BASE, 0xFF200020
.equ	HEX_BASE_END, 0xFF200024
.equ	HEX_BASE2, 0xFF200030
.global HEX_clear_ASM
.global HEX_flood_ASM
.global HEX_write_ASM

FIND_HEX:
	PUSH {R1}
	LDR	R1, =HEX_BASE

LOOP:
	LSR	R0, #1
	CMP	R0, #0
	BEQ	FOUND_HEX
	ADD R1, R1, #1
	B	LOOP

FOUND_HEX:
	MOV	R0, R1
	POP	{R1}
	BX	LR
	
HEX_clear_ASM:
	PUSH	{R1-R4}
	LDR	R1, =HEX_BASE
	MOV	R4, #6
	B	LOOP_CLEAR

INCREMENT_ADD:
	ADD		R1, R1, #1
	LDR		R2, =HEX_BASE_END
	CMP		R1, R2
	BNE		LOOP_CLEAR
	LDR		R1, =HEX_BASE2
	
LOOP_CLEAR:
	CMP		R4, #0
	BEQ		DONE_CLEAR
	SUBS	R4, R4, #1
	AND		R3, R0, #0x1
	LSR		R0, #1
	CMP		R3, #0
	BEQ		INCREMENT_ADD
	MOV		R2, #0
	STRB	R2, [R1]
	B		INCREMENT_ADD

DONE_CLEAR:
	POP		{R1-R4}
	BX		LR


HEX_flood_ASM:
	PUSH	{R1-R4}
	LDR	R1, =HEX_BASE
	MOV	R4, #8
	B	LOOP_FLOOD

INCREMENT_ADD2:
	ADD		R1, R1, #1
	LDR		R2, =HEX_BASE_END
	CMP		R1, R2
	BNE		LOOP_FLOOD
	LDR		R1, =HEX_BASE2
	

LOOP_FLOOD:
	CMP		R4, #0
	BEQ		DONE_FLOOD
	SUBS	R4, R4, #1
	AND		R3, R0, #0x1
	LSR		R0, #1
	CMP		R3, #0
	BEQ		INCREMENT_ADD2
	MOV		R2, #127
	STRB	R2, [R1]
	B		INCREMENT_ADD2

DONE_FLOOD:
	POP		{R1-R4}
	BX		LR

HEX_write_ASM:
	PUSH	{R2-R6, LR}
	MOV		R6, #0
	//BL		HEX_clear_ASM
	LDR	R5, =HEX_BASE
	MOV	R4, #6
	B	LOOP_WRITE

INCREMENT_ADD3:
	ADD		R5, R5, #1
	LDR		R2, =HEX_BASE_END
	CMP		R5, R2
	BNE		LOOP_WRITE
	LDR		R5, =HEX_BASE2
	MOV		R6, #0


LOOP_WRITE:
	//ADD		R6, R6, #4
	CMP		R4, #0
	BEQ		END
	SUBS	R4, R4, #1
	AND		R3, R0, #0x1
	LSR		R0, #1
	CMP		R3, #0
	BEQ		INCREMENT_ADD3
	MOV	R2, #0
	CMP R1, R2
	BEQ write_zero
	MOV	R2, #1
	CMP R1, R2
	BEQ write_one
	MOV	R2, #2
	CMP R1, R2
	BEQ write_two
	MOV	R2, #3
	CMP R1, R2
	BEQ write_three
	MOV	R2, #4
	CMP R1, R2
	BEQ write_four
	MOV	R2, #5
	CMP R1, R2
	BEQ write_five
	MOV	R2, #6
	CMP R1, R2
	BEQ write_six
	MOV	R2, #7
	CMP R1, R2
	BEQ write_seven
	MOV	R2, #8
	CMP R1, R2
	BEQ write_eight
	MOV	R2, #9
	CMP R1, R2
	BEQ write_nine
	MOV	R2, #10
	CMP R1, R2
	BEQ write_a
	MOV	R2, #11
	CMP R1, R2
	BEQ write_b
	MOV	R2, #12
	CMP R1, R2
	BEQ write_c
	MOV	R2, #13
	CMP R1, R2
	BEQ write_d
	MOV	R2, #14
	CMP R1, R2
	BEQ write_e
	B write_f

	

write_zero:
	MOV	R2, #63
	B	DONE

write_one:
	MOV	R2, #6
	B	DONE

write_two:
	MOV	R2, #91
	B	DONE

write_three:
	MOV	R2, #79
	B	DONE

write_four:
	MOV	R2, #102
	B	DONE

write_five:
	MOV	R2, #109
	B	DONE

write_six:
	MOV	R2, #125
	B	DONE

write_seven:
	MOV	R2, #7
	B	DONE

write_eight:
	MOV	R2, #127
	B	DONE

write_nine:
	MOV	R2, #111
	B	DONE

write_a:
	MOV	R2, #119
	B	DONE

write_b:
	MOV	R2, #124
	B	DONE

write_c:
	MOV	R2, #57
	B	DONE

write_d:
	MOV	R2, #94
	B	DONE

write_e:
	MOV	R2, #121
	B	DONE

write_f:
	MOV	R2, #113
	B	DONE

//RESET_DONE:
//	MOV	R2, #0

DONE:
//	ADD		R5, R6, R5
	STRB	R2, [R5]

//KEEP_DONE:
	B		INCREMENT_ADD3

END:
	POP	{R2-R6, LR}
	BX	LR
	
.end
