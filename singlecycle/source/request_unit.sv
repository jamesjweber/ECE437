/*
  James Weber
  weber99@purdue.edu

  Request Unit
*/

// Interface
`include "request_unit_if.vh"

module request_unit (input logic CLK, nRST, request_unit_if.ru ruif);
  // import types
  import cpu_types_pkg::*;

  always_ff @(posedge CLK, negedge nRST) begin
    // Need else if's otherwise it doesn't map properly
    if(!nRST) begin
       ruif.dmemREN <= 0;
       ruif.dmemWEN <= 0;
    end
    else if(ruif.halt) begin
       ruif.dmemREN <= 0;
       ruif.dmemWEN <= 0;
    end
  	else if(ruif.dhit) begin
  		 ruif.dmemREN <= 0;
  		 ruif.dmemWEN <= 0;
    end
  	else if (ruif.ihit) begin
  		ruif.dmemREN <= ruif.dREN;
  		ruif.dmemWEN <= ruif.dWEN;
  	end
  end

endmodule