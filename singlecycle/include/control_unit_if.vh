/*
  James Weber
  weber99@purdue.edu

  Control Unit Interface
*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  // control unit signals
  logic RegWr, MemWr, Halt, ALUSrc, imemREN, dmemWEN, dmemREN;
  logic [1:0] RegDst, PCSrc, ExtOp, MemToReg;
  aluop_t ALUOp;

  // cpu signals
  logic Equal;
  word_t Instr;

  // instruction signals
  opcode_t            opcode;
  regbits_t           rs, rt, rd;
  funct_t             funct;
  word_t              shamt;
  logic [IMM_W-1:0]   imm;
  logic [ADDR_W-1:0]  addr;

  // cpu ports
  modport cpu (
    input   opcode, rs, rt, rd, funct, shamt, imm, addr, 
            PCSrc, RegWr, RegDst, ExtOp, ALUSrc, 
            ALUOp, MemWr, MemToReg, Halt, 
            imemREN, dmemWEN, dmemREN,
    output  Equal, Instr
  );

  // control unit ports
  modport cu (
    input  	Equal, Instr,
    output  opcode, rs, rt, rd, funct, shamt, imm, addr, 
            PCSrc, RegWr, RegDst, ExtOp, ALUSrc, 
            ALUOp, MemWr, MemToReg, Halt, 
            imemREN, dmemWEN, dmemREN
  );

endinterface

`endif