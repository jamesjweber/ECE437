/*
  James Weber
  weber99@purdue.edu

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

  // Cache <=> Memory Control logic is sequential
  always_comb begin
    // Default values
    ccif.iwait = 1;
    ccif.dwait = 1;

    // Single core CPU
      /* Set iwait and dwait depending on ramstate */
    if (ccif.ramstate == ACCESS) begin
      if      (ccif.dREN || ccif.dWEN) ccif.dwait = 0; // Read or write data
      else if (ccif.iREN)              ccif.iwait = 0; // Process instr, if no data needed
    end

    /* Try to read data, then read instruction */
    ccif.dload = ccif.ramload; // Read data
    ccif.iload = ccif.ramload; // Store instruction
  end

  // Memory Control <=> RAM logic is combinational
  always_comb begin
    ccif.ramaddr = (ccif.dREN || ccif.dWEN) ? ccif.daddr : ccif.iREN ? ccif.iaddr : '0;
    ccif.ramREN = (ccif.iREN || ccif.dREN) && !ccif.dWEN;
    ccif.ramWEN = ccif.dWEN;
    ccif.ramstore = ccif.dWEN ? ccif.dstore : '0;
  end

endmodule
