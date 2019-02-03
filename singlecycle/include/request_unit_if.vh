/*
  James Weber
  weber99@purdue.edu

  Request Unit Interface
*/
`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic ihit, dhit, dREN, dWEN, imemREN, dmemREN, dmemWEN, halt, MemWr;

  // request unit ports
  modport ru (
    input  ihit, dhit, dREN, dWEN, halt, MemWr,
    output imemREN, dmemREN, dmemWEN
  );

  // tb ports
  modport tb (
    input  imemREN, dmemREN, dmemWEN,
    output ihit, dhit, dREN, dWEN, halt, MemWr
  );

endinterface

`endif //REQUEST_UNIT_IF_VH