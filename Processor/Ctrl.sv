`include "Definitions.sv"

module Ctrl (
    input                      clk,
                               geFlg,          // you may provide additional status flags, if desired
                               neFlg,          // you may provide additional status flags, if desired
    input[`opCdeW-1:0]         opCde,	       // machine code
    output logic               regWrt,
                               memWrt,         // write to mem (store only)
                               memLd,
                               lutLd,
                               imdLd,
                               pgmJmp,
                               ack,            // "done w/ program"
    output logic[`opW-1:0]     pgmOp,        
    output logic[`opPtrAW-1:0] opPtrA,
    output logic[`opPtrBW-1:0] opPtrB,
    output logic[`opPtrAW+`opPtrBW-1:0] opImd 
    );
    

    always_comb begin
        // Get Op-Code Operation
        pgmOp = opCde[`opCdeW-1: `opCdeW-`opW];	                   //[8:5]
 
        // Set Processor Flags
        imdLd =  pgmOp==`LD0 || pgmOp==`BRN || pgmOp==`BGE || pgmOp==`BNE;
        lutLd =  pgmOp==`LUT;
        memLd =  pgmOp==`LDR;
        memWrt = pgmOp==`STR;
        regWrt = !memWrt && pgmOp!=`CMP && pgmOp!=`BRN && pgmOp!=`BGE && pgmOp!=`BNE;
        pgmJmp = pgmOp==`BRN || (pgmOp==`BGE&&geFlg) || (pgmOp==`BNE&&neFlg);
        ack =    opCde==`DNE;    
        
        // Get Op-Code Register Pointers
	// if TLT instruction, rd = 1bit, rs = 4bits
	opPtrA =(imdLd)? 0: opCde[`opPtrAW+`opPtrBW-1: `opPtrBW]; //[4:2]
	opPtrB = opCde[`opPtrBW-1: 0];			          //[1:0]
      
        // Get Op-Code Imediate       
	opImd = opCde[`opPtrAW+`opPtrBW-1: 0];	                  //[4:0]
    end

    // Debug Monitoring		     
    always@(posedge clk) begin
        $display("CTL - opCde:%b, pgmOp:%d, opPtrA:%d, opPtrB:%d, opImd:%d", opCde, pgmOp, opPtrA, opPtrB, opImd);
    end
endmodule