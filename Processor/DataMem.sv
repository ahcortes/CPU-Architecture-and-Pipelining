`include "Definitions.sv"

module DataMem (
    input                    clk,
                             memWrt,
    input[`byteW-1:0]        regA,
                             regB,          
    output logic[`byteW-1:0] memOut
    );

    logic[`byteW] Core[`memW];          // 8x256 two-dimensional array -- the memory itself
									 
    always_comb memOut = Core[regB];    // reads are combinational and continuous

    always_ff @ (posedge clk) begin          // writes are sequential and conditional
        if(memWrt) 
            Core[regB] <= regA;
    
    // Debug Monitoring		     
    //$display("MEM - memOut[%d]:%d, memIn[%d]:%d", regB, memOut, regB, regA);
    end
endmodule