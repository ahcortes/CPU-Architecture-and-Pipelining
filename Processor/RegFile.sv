`include "Definitions.sv"

module RegFile (
    input                       clk,
                                init,
                                regWrt,
                                memWrt,
                                memLd,
                                lutLd,
                                imdLd,
    input[`opCdeW-1:0]          opCde,
    input[`byteW-1:0]           lutOut,
                                memOut,
                                aluOut,
    input wire[`opPtrAW-1:0]    opPtrA,
    input wire[`opPtrBW-1:0]    opPtrB,
    input wire[`opPtrAW+`opPtrBW-1:0] opImd,	
    output logic[`byteW-1:0]    regA,
                                regB
    );

    logic[`byteW-1:0]           regs[2**`opPtrAW-1:0];     // W bits wide [W-1:0] and 2**4 registers
    
    // Reg read
    always_comb begin    
        // Load Registers and Imediates
        regA = regs[opPtrA];
        regB = (imdLd)? {'b0, opImd}: regs[opPtrB];
    end

    // Reg write
    // sequential (clocked) writes
    always_ff @(posedge clk) begin
        if(regWrt) begin	                                  // works just like data_memory writes
            if(lutLd)							  
                regs[opPtrA] <= lutOut;
            else if(memLd)      
                regs[opPtrA] <= memOut;
            else   	  
                regs[opPtrA] <= aluOut;
        end 

        // Debug Monitoring
        //$display("REG - regA:%d, regB:%d, imdLD:%b", regA, regB, imdLd);
    end
    
    // Debug Monitoring
    always@(regs[0], regs[1], regs[2], regs[3], regs[4], regs[5], regs[6], regs[7])
        $display("WRB - reg%d:%d", opPtrA, regs[opPtrA]);
            
endmodule