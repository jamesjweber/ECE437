/*
  James Weber
  weber99@purdue.edu

  Program Counter Interface
*/
`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

`include "cpu_types_pkg.vh"

interface program_counter_if;
  // import types
  import cpu_types_pkg::*;

  // signals
  logic ihit, dhit;
  word_t nextPC, PC;

  // program counter ports
  modport pc (
    input  ihit, dhit, nextPC,
    output PC
  );

  // tb ports
  modport tb (
    input PC,
    output ihit, dhit, nextPC
  );

endinterface

`endif //PROGRAM_COUNTER_IF_VH