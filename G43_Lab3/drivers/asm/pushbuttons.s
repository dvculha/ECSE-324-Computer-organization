.text
.equ	PBS_BASE, 0xFF200050
.equ	PBS_mask_BASE, 0xFF200058
.equ	PBS_edgecap_BASE, 0xFF20005C
.global read_PB_data_ASM
.global PB_data_is_pressed_ASM
.global read_PB_edgecap_ASM
.global PB_edgecap_is_pressed_ASM
.global PB_clear_edgecp_ASM
.global enable_PB_INT_ASM
.global disable_PB_INT_ASM
read_PB_data_ASM:
	PUSH	{R1, LR}
	LDR 	R1, =PBS_BASE
	LDR 	R0, [R1]
	PUSH	{R1, LR}
	BX	LR

PB_data_is_pressed_ASM:
	PUSH	{R1, LR}
	MOV		R1, R0
	BL		read_PB_data_ASM
	AND		R0, R0, R1
	//CMP		R0, #0
	//BEQ		PB_data_is_pressed_ASM_DONE
	//MOV		R0, #1

PB_data_is_pressed_ASM_DONE:
	POP		{R1, LR}
	BX		LR

read_PB_edgecap_ASM:
	PUSH	{R1, LR}
	LDR 	R1, =PBS_edgecap_BASE
	LDR 	R0, [R1]
	PUSH	{R1, LR}
	BX	LR

PB_edgecap_is_pressed_ASM:
	PUSH	{R1, LR}
	MOV		R1, R0
	BL		read_PB_edgecap_ASM
	AND		R0, R0, R1
	CMP		R0, #0
	BEQ		PB_edgecap_is_pressed_ASM_DONE
	MOV		R0, #1

PB_edgecap_is_pressed_ASM_DONE:
	POP		{R1, LR}
	BX		LR

PB_clear_edgecp_ASM:
	PUSH	{R1, LR}
	MOV		R1, R0
	BL		PB_edgecap_is_pressed_ASM
	EOR		R1, R1, R1
	AND		R0, R0, R1
	LDR 	R1, =PBS_edgecap_BASE
	STR		R0, [R1]
	POP		{R1, LR}
	BX		LR

enable_PB_INT_ASM:
	PUSH	{R1-R2}
	LDR 	R1, =PBS_mask_BASE
	LDR 	R2, [R1]
	ORR		R0, R2, R0
	STR		R0, [R1]
	POP		{R1-R2}
	BX		LR
	
disable_PB_INT_ASM:
	PUSH	{R1-R2}
	LDR 	R1, =PBS_mask_BASE
	LDR 	R2, [R1]
	EOR		R0, R0, R0
	AND		R0, R2, R0
	STR		R0, [R1]
	POP		{R1-R2}
	BX		LR


	
	.end
