.text
.global _start

.equ CHAR_BASE, 0xC9000000  
.equ PIXEL_BASE, 0XC8000000 

.equ PS2_KEYBOARD, 0xFF200100
.equ RVALID, 0x8000

// data to write in write_byte 
HEX_CHAR: .word 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46 

KB_DATA: .word 0

// R5 always used for addresses

_start:

// clear screen
BL VGA_clear_charbuff_ASM
BL VGA_clear_pixelbuff_ASM

MOV R0, #0  // int x = 0
MOV R1, #0  // int y = 0

MAIN:
    PUSH {R0} // R0 will be used for read_PS2_data_ASM subroutine, push the x coordinate on top of the stack
    LDR R0, =KB_DATA // load keyboard data to R0
    BL read_PS2_data_ASM 
    CMP R0, #0 // check data validity
    POP {R0} // pop back since read_PS2_data_ASM is over 
    BEQ MAIN // if invalid, loop again
    LDR R2, =KB_DATA 
    LDR R2, [R2]
    BL VGA_write_byte_ASM
    CMP R0, #77 // since it prints in XX XX XX so 77 78 79
    ADDLE R0, R0, #3 // add 3 if x axis isnt full bc of the XX XX XX format
    BLE MAIN
    MOV R0, #0  // set x to zero to move to the next line if x axis is full
    CMP R1, #59 // compare y axis with 59
    ADDLT R1, #1  
    BLT MAIN // if y axis is not full yet
    MOV R1, #0  //if y axis is full, reset to 0 and clear the screen
    BLGE VGA_clear_charbuff_ASM
    B MAIN

read_PS2_data_ASM:
    PUSH {R1}
    PUSH {R2}
    LDR R1, =PS2_KEYBOARD
    LDR R1, [R1] // load the keyboard data
    LDR R2, =RVALID 
    TST R1, R2 // 
    BEQ INVALID // 
    AND R1, R1, #0xFF // if valid, isolate the RVALID byte to see 
    STRB R1, [R0] // store this in R0 as per requirements
    MOV R0, #1 // return 1 to indicate successful data
    POP {R2}
    POP {R1}
    B DONE
INVALID:
    MOV R0, #0 // return 0 to indicate unsuccessful data
    POP {R2}
    POP {R1}
    B DONE

VGA_clear_charbuff_ASM: 
    MOV R0, #-1 // y as the outer loop counter, start from -1 since it increments right after
    PUSH {R5}
    OUTER_CLEAR_CHAR:
        ADDS R0, R0, #1 // increment y counter
        // address computation 
        // address formula: base address of character buffer + x + 128y
        LDR R5, =CHAR_BASE // Address = base address
        LSL R2, R0, #7  // offset y by 7
        ADD R5, R5, R2 // add y offset to address
        MOV R1, #-1 // x as inner loop counter
        INNER_CLEAR_CHAR:
            ADDS R1, R1, #1 // increment x counter
            MOV R3, R1  
            MOV R4, #0 
            STRB R4, [R3, R5]
            CMP R1, #80
            BLT INNER_CLEAR_CHAR
        CMP R0, #60
        BLT OUTER_CLEAR_CHAR
    POP {R5}
    B DONE

VGA_clear_pixelbuff_ASM:
    MOV R0, #-1 // y as the outer loop counter, start from -1 since it increments right after
    OUTER_CLEAR_PIXEL:
        ADDS R0, R0, #1 // increment y counter
        // address computation 
        // address formula: base address of character buffer + 2x + 1024y
        LDR R5, =PIXEL_BASE // Address = base address
        LSL R2, R0, #10 // offset y by 10
        ADD R5, R5, R2 // add y offset to address
        MOV R1, #-1 // x as inner loop counter
        INNER_CLEAR_PIXEL:
            ADDS R1, R1, #1 //increment y counter
            LSL R3, R1, #1 // offset x by 1
            MOV R4, #0
            STRH R4, [R3, R5]
            CMP R1, #320
            BLT INNER_CLEAR_PIXEL
        CMP R0, #240
        BLT OUTER_CLEAR_PIXEL
    B DONE

VGA_write_byte_ASM: 
    CMP R0, #79  //compare current x with 79 to check that it's between 0-79
    BXGT LR
    CMP R1, #59 //compare current y with 59 to check that it's between 0-79
    BXGT LR

    PUSH {R1}   
    PUSH {R2} 
    PUSH {R3}
    PUSH {R4}   
    PUSH {R5}  
    
    // address computation 
    // address formula: base address of character buffer + x + 128y
    LSL R1, #7  // offset y by 7 bits since 128 = 2^7
    LDR R3, =CHAR_BASE // R3 (address) = base address
    ADD R3, R3, R1 // first, add x offset
    ADD R3, R3, R0 // finally, add y offset

    LDR R5, =HEX_CHAR // R5 = 0123456789ABCDEF
    MOV R4, R2  //temp register for operations on R2
    AND R4, #0xF // split R2 into 2 parts. AND keeps only the first 4 bits of the first character and save it into R4.
    LSL R4, R4, #2
    LDR R4, [R5, R4] 
    STRB R4, [R3, #1] // R4 contents are stored in the computed character address offset by 1 so that the characters are printed next to each other
    MOV R4, R2
    AND R4, #0XF0 // Again, split R2 into 2 parts
    ASR R4, R4, #2 // To keep the first part only this time 
    LDR R4, [R5, R4]
    STRB R4, [R3] // This time R4 contents are stored in the non-offset computed character address so that the characters are printed next to each other

    POP {R5}
    POP {R4}
    POP {R3}
    POP {R2}
    POP {R1}
    B DONE

// Causes too many interrupts
clear_screen: 
	BL VGA_clear_charbuff_ASM
	BL VGA_clear_pixelbuff_ASM 

// return from subroutine
DONE: 
    BX LR