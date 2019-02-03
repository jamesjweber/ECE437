/*
  James Weber
	weber99@purdue.edu

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test #(.PERIOD (PERIOD)) PROG (
		CLK,
		nRST,
		rfif
	);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test (
	input logic CLK, output logic nRST,
	register_file_if.tb tb_rfif
);
	parameter PERIOD = 10;
	initial begin
		// Writing to regs w/write enable ON
		reset();
		for (int i = 1; i < WORD_W; i++) set_and_check(1, 1, '1, i, i, i, '1, '1);
		
		// Writing to regs w/write enable off
		reset();
		for (int i = 1; i < WORD_W; i++) set_and_check(1, 0, '1, i, i, i, '0, '0);
		
		// Trys to set the zero register
		set_and_check(1, 1, '1, '0, '0, 8'hF, '0, '0);
	end

	task set_and_check(input logic reset, WEN, word_t wdat, regbits_t wsel, rsel1, rsel2, word_t expected_rdat1, expected_rdat2);
		begin
			set(reset, WEN, wdat, wsel, rsel1, rsel2);
			#(PERIOD)
			// check
			assert (expected_rdat1 == tb_rfif.rdat1 && expected_rdat2 == tb_rfif.rdat2)
			else begin
				$display("@%00g CLK = %b nRST = %b WEN = %b wdat = %h wsel = %h rsel1 = %h rsel2 = %h", $time, CLK, nRST, WEN, wdat, wsel, rsel1, rsel2);
				if(expected_rdat1 != tb_rfif.rdat1) begin
					 $display("ERROR: rdat1 = %h does not match expected value: %h", tb_rfif.rdat1, expected_rdat1);
				end
				if(expected_rdat2 != tb_rfif.rdat2) begin
					 $display("ERROR: rdat2 = %h does not match expected value: %h", tb_rfif.rdat2, expected_rdat2);
				end
			end
		end
	endtask

	task set(input logic reset, WEN, word_t wdat, regbits_t wsel, rsel1, rsel2);
		begin
			nRST = reset;			
			tb_rfif.WEN = WEN;
			tb_rfif.wsel = wsel;
			tb_rfif.wdat = wdat;
			tb_rfif.rsel1 = rsel1;
			tb_rfif.rsel2 = rsel2;
		end
	endtask

	task reset();
		begin
			set_and_check(0, 0, '0, '0, '0, '0, '0, '0);
		end
	endtask

endprogram
