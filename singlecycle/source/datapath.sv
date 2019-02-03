/*
  James Weber
  weber99@purdue.edu

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// Interfaces
`include "program_counter_if.vh" // program counter interface
`include "datapath_cache_if.vh"  // data path interface
`include "register_file_if.vh"   // register path interface
`include "control_unit_if.vh"    // control unit interface
`include "request_unit_if.vh"    // request unit interface
`include "alu_if.vh"             // alu interface

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  // interfaces
  program_counter_if pcif();
  register_file_if   rfif();
  request_unit_if    ruif();
  alu_if             aluif();
  control_unit_if    cuif();

  // components
  register_file      RF(CLK, nRST, rfif);
  program_counter    PC(CLK, nRST, pcif);
  request_unit       RU(CLK, nRST, ruif);
  alu                ALU(aluif);
  control_unit       CU(cuif);

  // internal signals
  word_t result, imm32, pcPlus4, jumpAddr, branch;

  // assign datmoic?
  assign dpif.datomic = 0;

  // set halt
  always_ff @(posedge CLK, negedge nRST) begin
    if(!nRST) begin
      dpif.halt <= 0;
    end else begin
      dpif.halt <= cuif.Halt;
    end
  end

  // set instruction from memory
  assign cuif.Instr = dpif.imemload;

  // register file logic
  always_comb begin
    rfif.WEN = cuif.RegWr && (dpif.ihit || dpif.dhit); 
    casez (cuif.RegDst)
      2'b00 : rfif.wsel = cuif.rd;
      2'b01 : rfif.wsel = cuif.rt;
      default : rfif.wsel = 5'd31; // Write to $ra ($r31)
    endcase
    rfif.rsel1 = cuif.rs;
    rfif.rsel2 = cuif.rt;
    rfif.wdat = result;
  end

  // port b = dmemstore
  assign dpif.dmemstore = rfif.rdat2;

  // sign extend / immediate logic
  always_comb begin
    casez(cuif.ExtOp)
      2'b00   : imm32 = {16'h0000, cuif.imm};
      2'b01   : imm32 = 32'(signed'(cuif.imm));
      default : imm32 = {cuif.imm, 16'h0000};
    endcase
  end

  // alu logic
  always_comb begin
    aluif.port_a = rfif.rdat1;
    casez (cuif.ALUSrc)
      2'b00   : aluif.port_b = rfif.rdat2;
      2'b01   : aluif.port_b = imm32;
    endcase
    aluif.ALUOP = cuif.ALUOp;
  end

  // alu result = dmemaddr
  assign dpif.dmemaddr = aluif.output_port;

  // equal logic
  assign cuif.Equal = (cuif.ALUOp == ALU_SUB) && aluif.zero;
  
  // pc logic
  always_comb begin
    pcPlus4  = pcif.PC + 4;                        // PC + 4
    jumpAddr = {pcPlus4[31:28], cuif.addr, 2'b00}; // PC + 4 [31:28], Addr << 2
    branch   = (imm32 << 2) + pcPlus4;             // imm32 << 2 + (PC + 4)

    casez (cuif.PCSrc)
      2'b11 : pcif.nextPC = rfif.rdat1;
      2'b10 : pcif.nextPC = jumpAddr;
      2'b01 : pcif.nextPC = branch;
      2'b00 : pcif.nextPC = pcPlus4;
    endcase

    pcif.ihit = dpif.ihit;
    pcif.dhit = dpif.dhit;
  end

  // pc = imemaddr
  assign dpif.imemaddr = pcif.PC;

  // result logic
  always_comb begin
    casez (cuif.MemToReg)
      2'b00   : result = aluif.output_port;
      2'b01   : result = dpif.dmemload;
      default : result = pcPlus4;
    endcase
  end

  // request unit
  always_comb begin
    ruif.ihit    = dpif.ihit;
    ruif.dhit    = dpif.dhit;
    ruif.dREN    = cuif.dmemREN;
    ruif.dWEN    = cuif.dmemWEN;
    ruif.halt    = cuif.Halt;
    ruif.MemWr   = cuif.MemWr;
  end

  // attach request/control unit signals to datapath output
  assign dpif.dmemREN  = ruif.dmemREN;
  assign dpif.dmemWEN  = ruif.dmemWEN;
  assign dpif.imemREN  = !dpif.halt;

endmodule
