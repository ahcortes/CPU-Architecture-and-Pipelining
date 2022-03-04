`include "Definitions.sv"

module ALU (
    input                    clk,           
    input[`byteW-1:0]        regA, regB,        // data inputs
    input[`opW-1:0]          pgmOp,             // ALU operation
    output logic[`byteW-1:0] aluOut,            // data output 
    output logic             geFlg,             // you may provide additional status flags, if desired
                             neFlg              // you may provide additional status flags, if desired
    );				
				    
    always_comb begin
        // Perform Op-Code Operation 
        case(pgmOp)							  
            `ADD: aluOut = regA+regB;            // add 
            `AND: aluOut = regA&regB;            // bitwise AND
            `SUB: aluOut = regA-regB;            // bitwise AND
            `ORR: aluOut = {0,{regA|regB}[`byteW-2:0]};            // bitwise exclusive OR
            `XOR: aluOut = regA^regB;            // bitwise exclusive OR
            `LSL: aluOut = regA<<regB;
            `RXR: aluOut = ^regB;                // bitwise exclusive OR
	    `CMP: begin                          // Branching Compare 
                  aluOut = regA-regB;
                  geFlg = !aluOut[`byteW-1];
                  neFlg = |aluOut;
                  end 
            default: aluOut = regB;
        endcase
    end
    
    // Debug Monitoring		     
    always@(posedge clk) begin
        //$display("ALU - aluOut:%d, geFlg:%b, neFlg:%b", aluOut, geFlg, neFlg);
    end
endmodule