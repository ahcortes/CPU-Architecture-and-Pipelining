`include "Definitions.sv"

module InstROM (
    input                      init,
    input[`pgmCtrW-1:0]        pgmCtr,
    output logic[`opCdeW-1:0]  opCde
    );
  
    // Load Program From External Text File
    initial begin		     
        //$readmemb("machine_code.txt",inst_rom);
    end 
   
    // declare 2-dimensional array, W bits wide, 2**A words deep
    logic[`opCdeW-1:0] inst_rom[`romW];

    // Grab OP-Code From ROM
    always_comb opCde = inst_rom[pgmCtr];

    always_ff @(posedge init)	        // or just always; always_ff is a linting construct
        // Uncomment to run Program1
        //$readmemb("Program1.txt", inst_rom);
        
        // Uncomment to run Program2
        //$readmemb("Program2&1.txt", inst_rom);
        
        // Uncomment to run Program3
        $readmemb("Program3&1.txt", inst_rom);

endmodule