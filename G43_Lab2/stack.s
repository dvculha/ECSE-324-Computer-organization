			.text
            .global _start

PUSH_R0:
			STR		R0, [R4, #-4]!		
			BX		LR

PULL_R0_R2:
			LDR		R0, [R4, #8]
			LDR		R1, [R4, #4]
			LDR		R2, [R4, #0]
			ADD		R4, R4, #12
			BX		LR

_start:
            LDR R4, =STACK				//R5 containts the address of N
			MOV R0, #1
			BL	PUSH_R0
			MOV R0, #2
			BL	PUSH_R0
			BL	PULL_R0_R2

END:
			B	END
			

STACK:		.word	0
