			.text
            .global _start

_start:
			LDR R4, =RESULT
            LDR R2, [R4, #4]	//R2 = N
            ADD R3, R4, #8		//R3 = address of first element
            LDR R0, [R3]		//R0 = 1st element
			BL	FIND_MAX		//FIND_MAX(R0 = 1st element, R2 = N, R3 = address of 1st element) 
			STR R0, [R4]
			B	END

FIND_MAX:
			PUSH {R4-R12, LR}
            
LOOP:		SUBS R2, R2, #1		//decrement counter	
			BEQ DONE			//if counter == 0
            ADD R3, R3, #4		//else R3 = address of next element
            LDR R1, [R3]		//R1 = next element
            CMP R0, R1			
            BGE LOOP			//if max >= current element loop again
            MOV R0, R1			//else max = current element
            B LOOP

DONE:		
			POP	{R4-R12, LR}
			BX	LR
     

END:		B END

RESULT:		.word	0
N:			.word	7
NUMBERS:	.word	4, 5, 1, 4, 2, 5, -6
         
