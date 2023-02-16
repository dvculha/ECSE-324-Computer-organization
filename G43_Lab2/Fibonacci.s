			.text
            .global _start

_start:
			MOV	R0, #0				//Reset R0
            LDR R4, =N				//R4 containts the address of N
			lDR R1, [R4]			//Load N value in R1
			BL	FIBONACCI			//start subroutine
			B	END					//Done

FIBONACCI:
			PUSH	{R1-R12, LR}	//Push everything
			CMP	R1, #2				//compare n with 2
			BLT	NON_RECURSIVE		//if n < 2

RECUSIVE:							//if n > 1
			SUBS	R1, #1			//n--
			BL	FIBONACCI			//fib(n-1)
			MOV		R5, R0			//R5 <- fib(n-1)
			SUBS	R1, #1			//n--
			BL	FIBONACCI			//fib(n-2)
			ADD		R0, R0, R5		//R5 -< fib(n-1) + fib(n-2)
			B	DONE
			
NON_RECURSIVE:						//if n < 2
			MOV	R0, #1				//return 1

				

DONE:
			POP	{R1-R12, LR}		//POP everything back
			BX	LR

END:
			B	END
			

N:			.word	10
