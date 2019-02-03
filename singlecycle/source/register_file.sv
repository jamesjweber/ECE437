/*
	James Weber
	weber99@purdue.edu
	
	Register File
*/

`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module register_file(input CLK, nRST, register_file_if.rf rfif);
	
	word_t [WORD_W-1:0] register; // 32 x 32-bit registers
	
	always_ff @ (posedge CLK, negedge nRST) begin
		// RESET
		if (!nRST) begin
			register <= '{default:'0}; // This fills all 32 regs with 32 bits
		end
		// WRITE
		else if (rfif.wsel != '0) begin // This makes it so we cannot write register 0;
			if (rfif.WEN) begin	// This is write enable
				register[rfif.wsel] <= rfif.wdat;
			end
		end
	end

	always_comb begin
		// READ
		rfif.rdat1 = register[rfif.rsel1];
		rfif.rdat2 = register[rfif.rsel2];
	end

endmodule
