.text
.global _start

.equ CHAR_BASE, 0xC9000000  
.equ PIXEL_BASE, 0XC8000000 

.equ X_PIXEL_RES, 320
.equ Y_PIXEL_RES, 240

// from prev lab
.equ PB_edgecap_BASE, 0xFF20005C
.equ PB_BASE, 0xFF200050
.equ PB_mask_BASE, 0xFF200058

// data to write in write_byte 
HEX_CHAR: .word 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46 
//    .ascii "0123456789ABCDEF"

_start:

// clean screen
BL VGA_clear_charbuff_ASM
BL VGA_clear_pixelbuff_ASM 

MAIN:
    BL read_PB_data_ASM
    TST R0, #1 // 2^0 for pb0
    BNE PUSHBUTTON_0
    TST R0, #2 // 2^1 for pb1
    BNE PUSHBUTTON_1 
    TST R0, #4 // 2^2 for pb2
    BNE PUSHBUTTON_2
    TST R0, #8 // 2^3 for pb3
    BNE PUSHBUTTON_3 
    B MAIN
PUSHBUTTON_0:
    BL VGA_clear_charbuff_ASM
    BL VGA_clear_pixelbuff_ASM
    BL test_byte
    MOV R0, #0X1
    // Clear data
    LDR R2, =PB_edgecap_BASE
    LDR R1, [R2] // R1 indicates if buttons are pushed or not
    AND R0, R0, #0XF // divide R0 into 2 parts, keep the first 4 bits the input.
    AND R1, R1, R0 
    STR R1, [R2] // store the cleared value once more       
    B MAIN
PUSHBUTTON_1:
    BL VGA_clear_charbuff_ASM
    BL VGA_clear_pixelbuff_ASM
    BL test_char
    MOV R0, #0X2
    // Clear data
    LDR R2, =PB_edgecap_BASE
    LDR R1, [R2] // R1 indicates if buttons are pushed or not
    AND R0, R0, #0XF // divide R0 into 2 parts, keep the first 4 bits the input.
    AND R1, R1, R0 
    STR R1, [R2] // store the cleared value once more       
    B MAIN
PUSHBUTTON_2:
    BL VGA_clear_charbuff_ASM
    BL VGA_clear_pixelbuff_ASM
    BL test_pixel
    MOV R0, #0X4
    // Clear data
    LDR R2, =PB_edgecap_BASE
    LDR R1, [R2] // R1 indicates if buttons are pushed or not
    AND R0, R0, #0XF // divide R0 into 2 parts, keep the first 4 bits the input.
    AND R1, R1, R0 
    STR R1, [R2] // store the cleared value once more       
    B MAIN
PUSHBUTTON_3:   
    BL VGA_clear_charbuff_ASM
    BL VGA_clear_pixelbuff_ASM
    MOV R0, #0X8
    // Clear data
    LDR R2, =PB_edgecap_BASE
    LDR R1, [R2] // R1 indicates if buttons are pushed or not
    AND R0, R0, #0XF // divide R0 into 2 parts, keep the first 4 bits the input.
    AND R1, R1, R0 
    STR R1, [R2] // store the cleared value once more
    B MAIN

read_PB_data_ASM: 
    LDR R0, =PB_edgecap_BASE
    LDR R0, [R0]
    AND R0, R0, #0xf
    B DONE

VGA_clear_charbuff_ASM: 
    MOV R0, #-1 // y  as the outer loop counter 
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
    MOV R0, #-1 // y as the outer loop counter  
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

VGA_write_char_ASM: 
    CMP R0, #79 //compare current x with 79 to check that it's between 0-79
    BXGT LR
    CMP R1, #59 //compare current y with 59 to check that it's between 0-79
    BXGT LR

    PUSH {R5} // will be used to hold the address, do callee save
    PUSH {R1} // y will be shifted later by 7 bits. push on the stack for future use

    // address computation 
    // address formula: base address of character buffer + x + 128y
    LSL R1, #7 // offset y by 7 bits since 128 = 2^7
    LDR R5, =CHAR_BASE // R5 (address) = base address
    ADD R5, R5, R1 // first, add x offset
    ADD R5, R5, R0 // finally, add y offset
    STRB R2, [R5] // store char at the address
    POP {R1}
    POP {R5}
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
    
VGA_draw_point_ASM:
    CMP R0, #320 // compare current x with 320 to check that it's between 0-319
    BXGE LR
    CMP R1, #240 // compare current y with 240 to check that it's between 0-239
    BXGE LR 

    PUSH {R5}
    PUSH {R3}   

    // address computation offset y by 10 to make space for the x bits and the x bits were shifted by one bit to make space for the offset value as shown in the computer manual.
    // address formula: base address of pixel buffer + 2x + 1024y
    LDR R5, =PIXEL_BASE // base address
    LSL R3, R1, #10 // offset y by 10 bits since 1024 = 2^10
    ADD R5, R5, R3 // add the y offset
    LSL R3, R0, #1 // offset x too this time by 1 since coefficient 2 = 2^1
    STRH R2, [R3, R5] // store colour in the address
    POP {R3}
    POP {R5}
    B DONE

// simply translating the C code provided into assembly
// difficulty: implemented the outer and inner loop wrong at first, printed from top to bottom instead of left to right
test_char:
    PUSH {R0}
    PUSH {R1}
    PUSH {R2}
    MOV R1, #0 // int y = 0
    MOV R2, #0 // char c = 0
    OUTER_TEST_CHAR:
        MOV R0, #0      // int x = 0
        INNER_TEST_CHAR:
            PUSH {LR}
            BL VGA_write_char_ASM   
            POP {LR}
            ADD R2, R2, #1 // increment c
            ADD R0, R0, #1 // increment x
            CMP R0, #79 // if x less than 80, keep looping the outer loop
            BLE INNER_TEST_CHAR
        ADDS R1, R1, #1 // increment y
        CMP R1, #59 // if y less than 60, keep looping the outer loop
        BLE OUTER_TEST_CHAR 
    POP {R2}
    POP {R1}
    POP {R0} 
    B DONE

test_byte:
    PUSH {R0}
    PUSH {R1}
    PUSH {R2}
    MOV R1, #0 // int y = 0
    MOV R2, #0 // char c = 0
    OUTER_TEST_BYTE:
        MOV R0, #0 // int x = 0
        INNER_TEST_BYTE:
            PUSH {LR}
            BL VGA_write_byte_ASM
            POP {LR}
            ADD R2, R2, #1 // increment c
            ADD R0, R0, #3 // increment x by 3
            CMP R0, #79 // if x less than 80, keep looping the outer loop
            BLE INNER_TEST_BYTE
        ADDS R1, R1, #1 // increment y
        CMP R1, #59 // if y less than 60, keep looping the outer loop
        BLE OUTER_TEST_BYTE
    POP {R2}
    POP {R1}
    POP {R0} 
    B DONE

// difficulty: #320 gives offset imm error so needed to use an extra register
test_pixel:
    PUSH {R0}
    PUSH {R1}
    PUSH {R2}
    PUSH {R3}
    MOV R1, #0 // int y = 0
    MOV R2, #0 // colour c = 0
    OUTER_TEST_PIXEL:
        MOV R0, #0      //initialize X
        INNER_TEST_PIXEL:
            PUSH {LR}
            BL VGA_draw_point_ASM   
            POP {LR}
            ADD R2, R2, #1 // increment c
            ADD R0, R0, #1 // increment x
            LDR R3, =X_PIXEL_RES // #320 offset imm error
            CMP R0, R3 // if x less than 320, keep looping the outer loop
            BLT INNER_TEST_PIXEL
        ADDS R1, R1, #1 // increment y
        LDR R3, =Y_PIXEL_RES // #240
        CMP R1, R3 // if y less than 240, keep looping the outer loop
        BLT OUTER_TEST_PIXEL
    POP {R3}
    POP {R2}
    POP {R1}
    POP {R0} 
    B DONE

// Causes too many interrupts
clear_screen: 
    BL VGA_clear_charbuff_ASM
    BL VGA_clear_pixelbuff_ASM 

DONE: 
    BX LR