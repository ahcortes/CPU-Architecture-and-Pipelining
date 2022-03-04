`include "Definitions.sv"

module LUT (
    input                    clk,
                             init,
    input[`byteW-1:0]        regB,
    output logic[`byteW-1:0] lutOut
    );
    
    logic[`byteW-1:0] lut[2**(`opPtrAW+`opPtrBW)] = '{32{0}};
   
    always_comb lutOut = lut[regB];

    always_ff @(posedge clk) begin          // or just always; always_ff is a linting construct
	if(init)
            // LUT constants
	    lut[0:29] <= {
                'b1100000,        // tap0
                'b1001000,        // tap1
                'b1111000,        // tap2
                'b1110010,        // tap3
                'b1101010,        // tap4
                'b1101001,        // tap5
                'b1011100,        // tap6
                'b1111110,        // tap7
                'b1111011,        // tap8
                61,
                62,
                63,
                64,
                128,
                130,
                32,
                49,
                140,
                141,
                9,
                142,
                143,
                144,
                127,
                15,
                145,
                128,
                146,
                147,
                65            
            };

    // Debug Monitoring		     
    //$display("LUT - lutOut:%d", lutOut);
    end
endmodule