`include "Definitions.sv"

module TopLevel (
    input              init,           // init/reset, active high
                       bgn,            // start next program
                       clk,            // clock -- posedge used inside design
    output logic       ack             // done flag from DUT
    );

    wire               regWrt,
                       memWrt,         // data_memory write enable
                       imdLd,          // load imediate
                       lutLd,
                       memLd,          // mem or ALU to reg_file ?
                       geFlg,          // you may provide additional status flags, if desired
                       neFlg,          // you may provide additional status flags, if desired
                       pgmJmp;
    wire[`pgmCtrW-1:0] pgmCtr;         // program counter
    wire[`opW-1:0]     pgmOp;          // opcode operation
    wire[`opCdeW-1:0]  opCde;          // our 9-bit opcode
    wire[`opPtrAW-1:0] opPtrA;
    wire[`opPtrBW-1:0] opPtrB; 
    wire[`byteW-1:0]   regA, 
                       regB,           // OP-Code registers
                       aluOut,
                       memOut,         // data out from data_memory
                       lutOut;
    wire[`pgmCtrW-1:0] bLUTOut;
    wire[`opPtrAW+`opPtrBW-1:0] opImd; // program Imediate
    
    // Module Instances
    InstROM ir(.*);
    ProgCtr pc(.*);					  
    Ctrl    ctrl(.*);
    RegFile rf(.*);
    DataMem dm(.*);
    ALU     alu(.*);
    LUT     lut(.*);
    bLUT    blut(.*);
endmodule