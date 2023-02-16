			.text
            .global _start

_start:
            LDR R4, =N				//R4 = address of N
			LDR R2, [R4]			//R2 = N
            ADD R3, R4, #4			//R3 =  Address of 1st element
            MOV R0, #0				//reset R0 (making sure it is zero)
            
LOOP:		
            LDR R1, [R3]			//R1 = next element
			ADD R0, R1, R0			//R0 (sum) += next elment
			SUBS R2, R2, #1			//Decrement counter by one
			BEQ DONE				//Exit loop if counter == 0
            ADD R3, R3, #4			//else R3 = Address of next element
			B	LOOP				//repeat loop
            
DONE:		LDR R2, [R4]			//Reset R2 = N
			MOV R5, #0				//Reset R5 = 0
			
SHIFT_LOOP:	LSR R2, #1				//logical shift N by one to the right
			CMP R2, R5				//compare R2 (shifted N) with R5 (zero)
			BEQ EDIT_START			//if shifted N is zero branch out
			LSR	R0, #1				//else means we can shift the average
			B	SHIFT_LOOP

EDIT_START:	
     		LDR R2, [R4]			//reset R2 to N
     		ADD R3, R4, #4			//reset R3 to first element

EDIT_LOOP:
			LDR R1, [R3]			//Load next element in R1
			SUBS R1, R1, R0			//Shift R1 by R0
			STR R1, [R3]			//store result in place
			SUBS R2, R2, #1			//decrement counter
			BEQ END					//if counter == 0 branch
            ADD R3, R3, #4			//else R3 points to the next
			B	EDIT_LOOP			//repeat

END:
			B	END
			


N:			.word	8
NUMBERS:	.word	4, 5, 3, 6
			.word	1, 8, 9, 5
