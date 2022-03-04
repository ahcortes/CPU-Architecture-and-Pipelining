`include "Definitions.sv"

module ProgCtr (	                   
    input                        init,    // reset, init, etc. -- force PC to 0 
                                 ack,
                                 bgn, 
                                 clk,	  // PC can change on pos. edges only
                                 pgmJmp,  // jump to Target
    input[`pgmCtrW-1:0]            bLUTOut,   // jump ... "how high?"
    output logic[`pgmCtrW-1:0]   pgmCtr   // the program counter register itself
    );
	 
    // program counter can clear to 0, increment, or jump
    always_ff @(posedge clk) begin        // or just always; always_ff is a linting construct
	if(init)
	    pgmCtr <= 0;                  // for first program; want different value for 2nd or 3rd
	else if(!ack) begin
            if(pgmJmp)                    // unconditional absolute jump
	        pgmCtr <= bLUTOut;          //   how would you make it conditional and/or relative?
	    else if(!bgn)
	        pgmCtr <= pgmCtr+'b1;     // default increment (no need for ARM/MIPS +4 -- why?)
        end
        
        // Debug Monitoring		     
        $display("\nPCT - pgmCtr:%d, pgmCtr2:%d, pgmJmp:%b, ack:%b", pgmCtr, (pgmCtr-99), pgmJmp, ack);
    end
endmodule