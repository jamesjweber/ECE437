/*
  James Weber
  weber99@purdue.edu

  Control Unit
  contains all the control 
  signals for the data path
*/

`include "cu_types_pkg.vh"
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

module control_unit(control_unit_if.cu cuif);
	// import types
	import cu_types_pkg::*;
	import cpu_types_pkg::*;

	// signals
	// opcode_t opcode;

	// logic
	assign cuif.opcode = opcode_t'(cuif.Instr[31:26]);

	always_comb begin
		// Default values
		cuif.PCSrc  	= 0;			 	// PCSrc = PC + 4
		cuif.RegWr  	= 1;			 	// Set WE for register file
		cuif.RegDst 	= 0; 			 	// RegDst = rd
		cuif.ExtOp 		= 1;			 	// Sign extend
		cuif.ALUSrc 	= 0;			 	// ALUSrc = Port B
		cuif.ALUOp  	= ALU_SLL; 	// ALU_SLL is the default OP
		cuif.MemWr  	= 0;			 	// Read from memory
		cuif.MemToReg = 0;			 	// Save ALU_Result to memory
		cuif.Halt 		= 0;				// CPU not halted
		cuif.imemREN 	= 1; 				// Instr Read Enable On
		cuif.dmemREN 	= 0; 				// Data Read Enable Off
		cuif.dmemWEN 	= 0;				// Data Write Enable OFF
		
		cuif.rs 			= cuif.Instr[25:21];
		cuif.rt 			= cuif.Instr[20:16];
		cuif.rd 			= cuif.Instr[15:11];
		cuif.shamt		= cuif.Instr[10:6];
		cuif.funct		= funct_t'(cuif.Instr[5:0]);
		cuif.imm			= cuif.Instr[15:0];
		cuif.addr 		= cuif.Instr[25:0];


		casez(cuif.opcode)
			// R-Type
			RTYPE : begin
				casez (cuif.funct)
					ADDU : cuif.ALUOp = ALU_ADD;
					ADD  : cuif.ALUOp = ALU_ADD;
					AND  : cuif.ALUOp = ALU_AND;
					JR   : begin
								 cuif.RegWr = 0;							// Don't write to reg file
								 cuif.PCSrc = 3; 							// PCSrc = Port A (rs)
								 end
          OR   : cuif.ALUOp = ALU_OR;
					NOR  : cuif.ALUOp = ALU_NOR;
					SLT  : cuif.ALUOp = ALU_SLT;
					SLTU : cuif.ALUOp = ALU_SLT;
					SLLV : cuif.ALUOp = ALU_SLL;
					SRLV : cuif.ALUOp = ALU_SRL;
					SUBU : cuif.ALUOp = ALU_SUB;
					SUB  : cuif.ALUOp = ALU_SUB;
					XOR  : cuif.ALUOp = ALU_XOR;
				endcase
			end

			// J-Type
			J : begin
				cuif.PCSrc 		= 2;										// PCSrc = Jump Addr
				cuif.RegWr 		= 0;										// Don't write to reg file
			end
			JAL : begin
				cuif.PCSrc 		= 2;										// PCSrc = Jump Addr
				cuif.MemToReg = 2;										// MemToReg = PC + 4 
        cuif.RegDst   = 2;                    // RegDst = $ra
			end

			// I-Type
			ADDIU : begin
				cuif.RegDst 	= 1;										// RegDst = rt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.ALUOp 		= ALU_ADD;					
			end

			ADDI : begin
				cuif.RegDst 	= 1;										// RegDst = rt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.ALUOp 		= ALU_ADD;					
			end

			ANDI : begin
				cuif.RegDst 	= 1;										// RegDst = rt
				cuif.ExtOp 		= 0;										// ExtOp = ZeroExt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.ALUOp 		= ALU_AND;					
			end

			BEQ : begin
				cuif.PCSrc 		= cuif.Equal ? 1 : 0; 	// PCSrc = Branch if Equal else PC + 4
				cuif.RegWr 		= 0;										// Don't write to reg file
				cuif.ALUOp 		= ALU_SUB;
			end
			
			BNE : begin
				cuif.PCSrc 		= !cuif.Equal ? 1 : 0; 	// PCSrc = Branch if Equal else PC + 4
				cuif.RegWr 		= 0;										// Don't write to reg file
				cuif.ALUOp 		= ALU_SUB;
			end
			
			LUI : begin
				cuif.RegDst 	= 1; 										// RegDst = rt
				cuif.ExtOp 		= 2;										// ExtOp = ZeroExt LSB
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
			end

			LW : begin
				cuif.RegDst 	= 1; 										// RegDst = rt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.MemToReg = 1;										// MemToReg = dmemload
				cuif.dmemREN 	= 1;										// Data Read Enable ON
				cuif.ALUOp 		= ALU_ADD;
			end

			ORI : begin
				cuif.RegDst 	= 1; 										// RegDst = rt
				cuif.ExtOp 		= 0;										// ExtOp = ZeroExt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.ALUOp 		= ALU_OR;
			end

			SLTI : begin
				cuif.RegDst 	= 1; 										// RegDst = rt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.ALUOp 		= ALU_SLT;
			end
			
			SLTIU : begin
				cuif.RegDst 	= 1; 										// RegDst = rt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.ALUOp 		= ALU_SLT;
			end

			SW : begin
				cuif.RegWr 		= 0;										// Don't write to reg file
				cuif.RegDst 	= 1; 										// RegDst = rt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.MemWr 		= 1;										// MemWr = write to memory
				cuif.dmemWEN 	= 1;										// Data Write Enable ON
				cuif.ALUOp 		= ALU_ADD;
			end

			XORI : begin
				cuif.RegDst 	= 1; 										// RegDst = rt
				cuif.ExtOp 		= 0;										// ExtOp = ZeroExt
				cuif.ALUSrc 	= 1;										// ALUSrc = imm32
				cuif.ALUOp 		= ALU_XOR;
			end
			
      // Halt
      HALT : begin
        cuif.Halt     = 1;                    // Halt
        cuif.RegWr    = 0;                    // Don't write to reg file
        cuif.MemWr    = 0;                    // Don't write to memory
      end

		endcase
	end

endmodule // control_unit	