`include "Definitions.sv"

module bLUT (
    input                    clk,
                             init,
    input[`byteW-1:0]        regB,
    output logic[`pgmCtrW-1:0] bLUTOut
    );
    
    logic[`pgmCtrW-1:0] lut[2**(`opPtrAW+`opPtrBW)] = '{32{0}};
   
    always_comb bLUTOut = lut[regB];

    always_ff @(posedge clk) begin          // or just always; always_ff is a linting construct
	if(init)
	    lut[0:19] <= {
                //Program 1      		
                53,
                11,
                99,
                57,
                
                //Program 2 and 1      		
                (103+99), 
                (93+99),
                (38+99),
                (27+99),
                (152+99),
                (107+99),
                (12+99),
                (5+99),

                //Program 3 and 1      		
                (152+99), 
                (107+99),
                (239+99),
                (172+99),
                (251+99),
                (241+99),
                (203+99),
                (209+99)
            };

    // Debug Monitoring		     
    //$display("bLUT - bLUTOut:%d", bLUTOut);
    end
endmodule