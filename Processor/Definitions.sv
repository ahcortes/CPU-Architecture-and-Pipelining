// Global Widths
`define romW    500
`define opCdeW  9
`define opW     4	// opcode 
`define opPtrAW 3	// reg1
`define opPtrBW	2	// reg2
`define pgmCtrW 10
`define byteW   8
`define memW    256

// Flags
`define DNE 9'b111111111

// Data Transfer
`define LD0 0           // LD0 31  - Loads R0 with 31
`define MOV 1           // MOV 2 0 - Loads R2 with R0
`define LUT 2           // LUT 3 0- Loads R3 with LUT[R0]
`define LDR 3           // LDR 7 0 - Loads R7 with mem[R0]
`define STR 4           // STR 4 0 - Stores R4 into mem[R0]
    
// Arithmatic
`define ADD 5
`define SUB 6
`define CMP 7

// Logical 
`define AND 8
`define ORR 9
`define XOR 10
`define LSL 11
`define RXR 12

// Branching 
`define BRN 13           // BRN 0 - Jumps To bLUT[0]
`define BGE 14           // BRN 1 - Jumps To bLUT[1] if CMP >=
`define BNE 15           // BRN 2 - Jumps To bLUT[2] if CMP !=

//LD0 30    
//MOV 1 0   
//LD0 8     
//LUT 2 0   
//CMP 2 1
//BNE 1
