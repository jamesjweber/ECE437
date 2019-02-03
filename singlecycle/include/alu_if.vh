/*
  James Weber

  ALU interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  aluop_t ALUOP;
  word_t port_a, port_b, output_port;
  logic negative, overflow, zero;

  // ALU ports
  modport alu (
    input ALUOP, port_a, port_b, 
    output negative, overflow, zero, output_port
  );
  // ALU tb
  modport tb (
    input negative, overflow, zero, output_port,
    output ALUOP, port_a, port_b
  );
endinterface

`endif //ALU_IF_VH
