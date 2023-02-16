			.text
            .global _start

_start:
			LDR R4, =RESULT				//R4 = Address of RESULT
            LDR R2, [R4, #4]			//R2 = N
            ADD R3, R4, #8				//R3 = Address of first element
            LDR R0, [R3]				//R0 = first element (max)
            
LOOP:		SUBS R2, R2, #1				//Decrement counter by 1
			BEQ DONE					//Exit loop if counter == 0
            ADD R3, R3, #4				//R3 = Address of next element
            LDR R1, [R3]				//R1 = next element
            CMP R0, R1					//Compare current element to the next one
            BGE LOOP					//if currentElement >= nextElement repeat
            MOV R0, R1					//else max = next element
            B LOOP						//repeat
            
DONE:		STR R0, [R4]				//Store max in RESULT

STEP_MIN:
			LDR R4, =RESULT				//R4 = Address of RESULT
            LDR R2, [R4, #4]			//R2 = N
            ADD R3, R4, #8				//R3 = Address of first element
            LDR R0, [R3]				//R0 = first element (min)
            
LOOP2:		SUBS R2, R2, #1				//Decrement counter by 1
			BEQ DONE2					//Exit loop if counter == 0
            ADD R3, R3, #4				//R3 = Address of next element
            LDR R1, [R3]				//R1 = next element
            CMP R0, R1					//Compare current element to the next one
            BLE LOOP2					//if currentElement <= nextElement repeat
            MOV R0, R1					//else min = next element
            B LOOP2						//repeat
            
DONE2:		LDR R1, [R4]				//R1 = max
			SUBS R0, R1, R0   			//R0 = R1 (max) - R0 (min)
			LSR R0, #2					//Logical shift right of the answer by 2 bits 
			STR R0, [R4]				//Store final answer in RESULT

END:		B END						//Infinite loop...

RESULT:		.word	0
N:			.word	7
NUMBERS:	.word	-4, -5, -3, -6
			.word	1, 8, 9
