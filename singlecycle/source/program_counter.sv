/*
  James Weber
  weber99@purdue.edu

  Program Counter
*/

// Interface
`include "program_counter_if.vh"

module program_counter (input logic CLK, nRST, program_counter_if.pc pcif);

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			pcif.PC <= 0;
		end else begin
			if (pcif.ihit & !pcif.dhit) begin
				pcif.PC <= pcif.nextPC;
			end
		end
	end

endmodule