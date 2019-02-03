/*
	James Weber
	weber99@purdue.edu
	
	Arithmetic Logic Unit
*/

`include "alu_if.vh"

module alu(alu_if.alu aluif);
  
  import cpu_types_pkg::*;

	always_comb begin
		aluif.output_port = 0;
		aluif.overflow = 0;
		casez (aluif.ALUOP)
            ALU_SLL : begin // Shift Left Logic Variable
              aluif.output_port = aluif.port_b << aluif.port_a[4:0];  
            end
            ALU_SRL : begin // Shift Right Logic Variable
              aluif.output_port = aluif.port_b >> aluif.port_a[4:0];  
            end 
            ALU_ADD : begin // Add
              aluif.output_port = $signed(aluif.port_a) + $signed(aluif.port_b); 
              aluif.overflow = aluif.port_a[WORD_W-1] == aluif.port_b[WORD_W-1] ? aluif.port_a[WORD_W-1] != aluif.output_port[WORD_W-1] ? 1 : 0 : 0;
            end
            ALU_SUB : begin // Subtract 
              aluif.output_port = $signed(aluif.port_a) - $signed(aluif.port_b);  
              aluif.overflow = aluif.port_a[WORD_W-1] != aluif.port_b[WORD_W-1] ? aluif.port_a[WORD_W-1] != aluif.output_port[WORD_W-1] ? 1 : 0 : 0;
            end
            ALU_AND : begin // Bitwise And
              aluif.output_port = aluif.port_a & aluif.port_b;
            end
            ALU_OR  : begin // Bitwise Or
              aluif.output_port = aluif.port_a | aluif.port_b;
            end
            ALU_XOR : begin // Bitwise Xor
              aluif.output_port = aluif.port_a ^ aluif.port_b;  
            end
            ALU_NOR : begin // Bitwise Nor
              aluif.output_port = ~(aluif.port_a | aluif.port_b);   
            end
            ALU_SLT : begin // Set On Less Than
              aluif.output_port = ($signed(aluif.port_a) < $signed(aluif.port_b)) ? 1 : 0;  
            end
            ALU_SLTU: begin // Set On Less Than Unsigned
              aluif.output_port = (aluif.port_a < aluif.port_b) ? 1 : 0;
            end
          endcase
	end

	always_comb begin
		aluif.zero = aluif.output_port == '0 ? 1 : 0;
		aluif.negative = aluif.output_port[WORD_W-1];
	end

endmodule