			.text
            .global _start

_start:
            LDR R5, =N					//R5 containts the address of N

BEGIN_LOOP:
			MOV R6, #0					//done = true
			LDR R2, [R5]				//R2 = N
            ADD R3, R5, #0				//R3 = Address of N (to be shifted later)
			ADD R4, R5, #4				//R4 = Address of First element (to be shifted later)
			B	SWAP_LOOP					//start loop
				

STORE_SWAP:
			STR R1, [R3]				//Store the swapped element
			STR R0, [R4]				//Store the swapped element
			MOV R6, #1					//Done = false and continue the loop

SWAP_LOOP:
			ADD R3, R3, #4				//Increment address of first element
			ADD R4, R4, #4				//Increment address of second element
			SUBS R2, R2, #1				//Decrememnt the counter N
			BEQ DONE					//Branch out if counter = 0
			LDR R0, [R3]				//Load first number
			LDR R1, [R4]				//Load second number
			CMP R0, R1					//Compare the two numbers
			BGT	STORE_SWAP				//If first > second -> swap and store
			B	SWAP_LOOP					//else continue

DONE:
			CMP R6, #1					//done != false?
			BEQ BEGIN_LOOP				//if true loop once more

END:
			B END

					

N:			.word	7
NUMBERS:	.word	4, 5, 3, 6
			.word	-1, -8, -9
