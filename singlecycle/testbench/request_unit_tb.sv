/*
  James Weber
  weber99@purdue.edu

  request unit testbench
*/

// mapped needs this
`include "cpu_types_pkg.vh"

// Interface
`include "request_unit_if.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;
  
  // interface
  request_unit_if ruif();

  // test program
  test #(.PERIOD (PERIOD)) PROG (CLK, nRST, ruif);

  // DUT
`ifndef MAPPED
  request_unit DUT(.CLK, .nRST, .ruif);
`else
  request_unit DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\ruif.ihit (ruif.ihit),
    .\ruif.dhit (ruif.dhit),
    .\ruif.dREN (ruif.dREN),
    .\ruif.dWEN (ruif.dWEN),
    .\ruif.dmemREN (ruif.dmemREN),
    .\ruif.dmemWEN (ruif.dmemWEN),
    .\ruif.halt (ruif.halt),
    .\ruif.MemWr (ruif.MemWr)
  );
`endif

endmodule

program test (
  input logic CLK, 
  output logic nRST, 
  request_unit_if ruif
);
  parameter PERIOD = 10;

  initial begin

    nRST = 0;
    #(PERIOD)
    nRST = 1;
    #(PERIOD)
    nRST = 0;
    #(PERIOD)
    nRST = 1;

    for (int i = 0; i < 64; i++) begin
      ruif.ihit = i[5];
      ruif.dhit = i[4];
      ruif.dREN = i[3];
      ruif.dWEN = i[2];
      ruif.halt = i[1];
      ruif.MemWr= i[0];
      $display("ihit: %0d, dhit: %0d, dREN: %0d, dWEN: %0d, halt: %0d, MemWr: %0d",
        ruif.ihit, ruif.dhit, ruif.dREN, ruif.dWEN, ruif.halt, ruif.MemWr
      );
      #(PERIOD);

      check(.edmemREN((!(!nRST || ruif.halt || ruif.dhit) && ruif.ihit) ? ruif.dREN : 0), 
        .edmemWEN((!(!nRST || ruif.halt || ruif.dhit) && ruif.ihit && ruif.MemWr) ? ruif.dWEN : 0));
      
    end
  end

  task check(
    input logic edmemREN=0, edmemWEN=0
  );
    int error;
    error = 0;

    assert(edmemREN == ruif.dmemREN) else error = 1;
    assert(edmemWEN == ruif.dmemWEN) else error = 1;

    if (error) begin
      $display("@%00g Actual vs. Expected\n", $time,
        "=============================================\n",
        "dmemREN:    %0d, %0d |\t dmemWEN:   %0d, %0d\n", ruif.dmemREN, edmemREN, ruif.dmemWEN, edmemWEN,
      );
    end

  endtask

endprogram