/*
  James Weber
  weber99@purdue.edu

  Memory Control Testbench
*/

`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

parameter INPUT_W  = 100;
parameter OUTPUT_W = 132;

typedef logic [INPUT_W -1:0] input_t;
typedef logic [OUTPUT_W-1:0] output_t;

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 1, nRST;

  // clock
  always #(PERIOD/2) CLK++;
  
  // caches
  caches_if cif0();
  caches_if cif1();
  // control interface
  parameter CPUS = 1;
  cache_control_if #(.CPUS (CPUS)) ccif(cif0, cif0);

  // RAM interface
  cpu_ram_if ramif();
  // test program
  test #(.PERIOD (PERIOD)) PROG (CLK, nRST, ccif, cif0, ramif);

  // DUT
`ifndef MAPPED
  memory_control #(.CPUS (CPUS)) DUT(.CLK, .nRST, .ccif);
  // RAM module
  ram RAM(.CLK, .nRST, .ramif);
`else
  memory_control DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\ccif.iREN (ccif.iREN),
    .\ccif.dREN (ccif.dREN),
    .\ccif.dWEN (ccif.dWEN),
    .\ccif.dstore (ccif.dstore),
    .\ccif.iaddr (ccif.iaddr),
    .\ccif.daddr (ccif.daddr),
    .\ccif.ramload (ccif.ramload),
    .\ccif.ramstate (ccif.ramstate)
  );
  // RAM module
  ram RAM(
  	.\CLK (CLK),
  	.\nRST (nRST),
  	.\ramif.ramaddr  (ram_if.ramaddr),
  	.\ramif.ramstore (ram_if.ramstore),
  	.\ramif.ramREN   (ram_if.ramREN),
  	.\ramif.ramWEN   (ram_if.ramWEN),
  	.\ramif.ramstate (ram_if.ramstate),
  	.\ramif.ramload  (ram_if.ramload)
  );
`endif

endmodule

program test (
	input logic CLK, output logic nRST,
	cache_control_if tb_ccif, 
	caches_if tb_cif0,
	cpu_ram_if ram_if
);
	parameter PERIOD = 10;

	initial begin

		input_t inputs;
		int dstore;

		assign ram_if.ramaddr = tb_ccif.ramaddr;
		assign ram_if.ramREN = tb_ccif.ramREN;
		assign ram_if.ramWEN = tb_ccif.ramWEN;
		assign ram_if.ramstore = tb_ccif.ramstore;
		assign tb_ccif.ramstate = ram_if.ramstate;
		assign tb_ccif.ramload = ram_if.ramload;

		reset();

		#(PERIOD)

		nRST = 1;
		dstore = 0;		

		// Normal Testbench
		// for (int addr = 0; addr < 'h7FFF0000; addr += 'hFFFFFF) begin
		// 	for (int rw = 4; rw > 0; rw -= 1) begin
		// 		inputs = { nRST, rw[0], rw[1], rw[2], addr, addr, dstore++ };
		// 		set_and_check(.inputs (inputs));
		// 	end
		// 	if (dstore % 64 == 0) begin
		// 		nRST = 0;
		// 		#(PERIOD)
		// 		nRST = 1;
		// 	end
		// end

		// Unit tests
		// for (int addr = 0; addr <= 'h10; addr += 'h4) begin
		// 	inputs = { nRST, 1'b1, 1'b0, 1'b0, addr, addr, dstore++ };
		// 	set_and_check(.inputs (inputs));
		// end

		// Change memory
		for (int addr = 0; addr <= 'hF8; addr += 'h4) begin
			if (addr == 'h0C) begin
				inputs = { nRST, 1'b0, 1'b0, 1'b1, addr, addr, 32'hFFFFFFFF };
				set_and_check(.inputs (inputs));
				inputs = { nRST, 1'b1, 1'b0, 1'b0, addr, addr, dstore++ };
			end else begin
				inputs = { nRST, 1'b1, 1'b0, 1'b0, addr, addr, dstore++ };
			end
			set_and_check(.inputs (inputs));
		end

		dump_memory();

	end

	task set_and_check(input input_t inputs);
		begin
			// Declarations
			logic nRST, iREN, dREN, dWEN;
			word_t iaddr, daddr, dstore;
			logic iwait, dwait, ramWEN, ramREN;
			word_t iload, dload, ramstore, ramaddr;
			ramstate_t prev_ramstate;
			output_t exp_out;
			int error;

			// Initializations - inputs
			nRST = inputs[99]; iREN = inputs[98]; dREN = inputs[97]; dWEN = inputs[96];
			iaddr = inputs[95:64]; daddr = inputs[63:32]; dstore = inputs[31:0];

			set(inputs);
			
			do begin
				#(PERIOD/100)
				prev_ramstate = ram_if.ramstate;
				#(PERIOD*99/100)
				// Get expected outputs
				exp_out = exp_outputs(inputs);
				// Initializations - outputs
				iwait = exp_out[131]; dwait = exp_out[130]; ramWEN = exp_out[129]; ramREN = exp_out[128];
				iload = exp_out[127:96]; dload = exp_out[95:64]; ramstore = exp_out[63:32]; ramaddr = exp_out[31:0];
				error = 0;

				/* ==================== Check all signals ==================== */
				// Check wait signals
				assert (tb_ccif.iwait == iwait) else begin
					print_ave_logic("iwait", tb_ccif.iwait, iwait); error = 1;
				end
				assert (tb_ccif.dwait == dwait) else begin
					print_ave_logic("dwait", tb_ccif.dwait, dwait); error = 1;
				end
				// Check RAM R/W
				assert (tb_ccif.ramWEN == ramWEN) else begin
					print_ave_logic("ramWEN", tb_ccif.ramWEN, ramWEN); error = 1;
				end
				assert (tb_ccif.ramREN == ramREN) else begin
					print_ave_logic("ramREN", tb_ccif.ramREN, ramREN); error = 1;
				end
				// Check load signals
				assert(tb_ccif.dload == dload) else begin
					print_ave_word_t("dload", tb_ccif.dload, dload); error = 1;
				end
	    		assert(tb_ccif.iload == iload) else begin
					print_ave_word_t("iload", tb_ccif.iload, iload); error = 1;
				end
				// Check ram store/addr
				assert(tb_ccif.ramstore == ramstore) else begin
					print_ave_word_t("ramstore", tb_ccif.ramstore, ramstore); error = 1;
				end
	    		assert(tb_ccif.ramaddr == ramaddr) else begin
					print_ave_word_t("iload", tb_ccif.ramaddr, ramaddr); error = 1;
				end

				if (error) begin
					$display("\nActual, Expected",);
			    $display("========================================================================================");
			    $display("iREN:  %0d, %0d\t| dREN:  %0d, %0d\t| dWEN:     %0d, %0d\t| ramstate: %0s, %0s", tb_ccif.iREN, iREN, tb_ccif.dREN, dREN, tb_ccif.dWEN, dWEN, tb_ccif.ramstate, ram_if.ramstate);
					$display("iaddr: %0d, %0d\t| daddr: %0d, %0d\t| dstore:   %0d, %0d\t| ramload:  %0d, %0d", tb_ccif.iaddr, iaddr,  tb_ccif.daddr, daddr, tb_ccif.dstore, dstore, tb_ccif.ramload, ram_if.ramload);
					$display("----------------------------------------------------------------------------------------");
					$display("iwait: %0d, %0d\t| dwait: %0d, %0d\t| ramWEN:   %0d, %0d\t| ramREN:  %0d, %0d", tb_ccif.iwait, iwait, tb_ccif.dwait, dwait, tb_ccif.ramWEN, ramWEN, tb_ccif.ramREN, ramREN);
					$display("iload: %0d, %0d\t| dload: %0d, %0d\t| ramstore: %0d, %0d\t| ramaddr: %0d, %0d", tb_ccif.iload, iload, tb_ccif.dload, dload, tb_ccif.ramstore, ramstore, tb_ccif.ramaddr, ramaddr);
			    $display("========================================================================================\n");
				end
			end while ((ram_if.ramload == 32'hBAD1BAD1 && ramREN) || (prev_ramstate== BUSY && ramWEN));
		end
	endtask

	task set(input input_t inputs);
		begin
			nRST   		   = inputs[99];
			tb_cif0.iREN   = inputs[98];
			tb_cif0.dREN   = inputs[97];
			tb_cif0.dWEN   = inputs[96];
			tb_cif0.iaddr  = inputs[95:64];
			tb_cif0.daddr  = inputs[63:32];
			tb_cif0.dstore = inputs[31:0];
		end
	endtask

	task reset();
		begin
			set('0);
		end
	endtask

	task print_ave_logic(input string name, logic actual, expected);
		// Print actual vs expected
		begin
			$display("%s:\t(A)%0d\t| (E)%0d", name, actual, expected);
		end
	endtask

	task print_ave_word_t(input string name, word_t actual, expected);
		// Print actual vs expected
		begin
			$display("%s:\t(A)%0d\t| (E)%0d", name, actual, expected);
		end
	endtask

	task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    reset();

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      tb_cif0.iaddr = i << 2;
      tb_cif0.iREN = 1;
      repeat (4) @(posedge CLK);
      // if (syif.load === 0)
      //   continue;
      values = {8'h04,16'(i),8'h00,tb_cif0.iload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),tb_cif0.iload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      tb_cif0.iREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

	function output_t exp_outputs(input input_t inputs);
		// Declarations
		logic nRST, iREN, dREN, dWEN;
		word_t iaddr, daddr, dstore, ramload;
		ramstate_t ramstate;
		output_t exp_out;
		
		// Initializations
		nRST = inputs[99]; iREN = inputs[98]; dREN = inputs[97]; dWEN = inputs[96];
		iaddr = inputs[95:64]; daddr = inputs[63:32]; dstore = inputs[31:0];
		ramload = ram_if.ramload; ramstate = ram_if.ramstate;

		return { 
			expected_iwait(iREN, dREN, dWEN, ramstate),
			expected_dwait(iREN, dREN, dWEN, ramstate),
			expected_ramWEN(dWEN),
			expected_ramREN(iREN, dREN),
			expected_iload(ramload),
			expected_dload(ramload),
			expected_ramstore(dWEN, dstore),
			expected_ramaddr(iREN, dREN, dWEN, iaddr, daddr)
		};
	endfunction	

	// Sub-functions

	function logic expected_iwait(input logic iREN, dREN, dWEN, ramstate_t ramstate);
		return ramstate == ACCESS && iREN && !(dREN || dWEN) ? 0 : 1;
	endfunction

	function logic expected_dwait(input logic iREN, dREN, dWEN, ramstate_t ramstate);
		return ramstate == ACCESS && (dREN || dWEN) ? 0 : 1;
	endfunction

	function logic expected_ramWEN(input logic dWEN);
		return dWEN;
	endfunction

	function logic expected_ramREN(input logic iREN, dREN);
		return iREN || dREN;
	endfunction

	function word_t expected_iload(input word_t ramload);
		return ramload;
	endfunction

	function word_t expected_dload(input word_t ramload);
		return ramload;
	endfunction

	function word_t expected_ramstore(input logic dWEN, word_t dstore);
		return dWEN ? dstore : '0;
	endfunction

	function word_t expected_ramaddr(input logic iREN, dREN, dWEN, word_t iaddr, daddr);
		return (dREN || dWEN) ? daddr : iREN ? iaddr : '0;
	endfunction

endprogram
