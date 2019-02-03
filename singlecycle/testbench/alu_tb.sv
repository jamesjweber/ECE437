/*
  James Weber
  weber99@purdue.edu

  alu test bench
*/

// mapped needs this
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;
  
  // inputs/outputs
  aluop_t ALUOP;
  word_t port_a, port_b, output_port;
  logic negative, overflow, zero; 

  // test program
  test #(.PERIOD (PERIOD)) PROG (output_port, negative, overflow, zero, ALUOP, port_a, port_b);

  // DUT
`ifndef MAPPED
  alu DUT(.ALUOP, .port_a, .port_b, .output_port, .negative, .overflow, .zero);
`else
  alu DUT(
    .\ALUOP (ALUOP),
    .\port_a (port_a),
    .\port_b (port_b),
    .\output_port (output_port),
    .\negative (negative),
    .\overflow (overflow),
    .\zero (zero)
  );
`endif

endmodule

program test (
  input word_t output_port, 
  logic negative, overflow, zero,
  output aluop_t ALUOP, 
  word_t port_a, port_b
);
  parameter PERIOD = 10;

  aluop_t [9:0] opcodes = {ALU_SLL, ALU_SRL, ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR, ALU_NOR, ALU_SLT, ALU_SLTU};
  word_t output_port_tb;
  logic negative_tb, overflow_tb, zero_tb;

  initial begin
    reset();
    for (int i = 0; i < 10; i++) begin
      // Check each opcode
      for (int unsigned data_1 = 0; data_1 < 4294967200; data_1 += 536870911) begin
        for (int unsigned data_2 = 0; data_2 < 4294967200; data_2 += 536870911) begin
          // Check all data combinations
          #(PERIOD)
          output_port_tb = 0;
          overflow_tb = 0;
          casez (opcodes[i])
            ALU_SLL : begin // Shift Left Logic Variable
              output_port_tb = data_2 << data_1[4:0];  
            end
            ALU_SRL : begin // Shift Right Logic Variable
              output_port_tb = data_2 >> data_1[4:0];  
            end 
            ALU_ADD : begin // Add
              output_port_tb = $signed(data_1) + $signed(data_2); 
              overflow_tb = data_1[WORD_W-1] == data_2[WORD_W-1] ? data_1[WORD_W-1] != output_port_tb[WORD_W-1] ? 1 : 0 : 0;
            end
            ALU_SUB : begin // Subtract 
              output_port_tb = $signed(data_1) - $signed(data_2);  
              overflow_tb = data_1[WORD_W-1] != data_2[WORD_W-1] ? data_1[WORD_W-1] != output_port_tb[WORD_W-1] ? 1 : 0 : 0;
            end
            ALU_AND : begin // Bitwise And
              output_port_tb = data_1 & data_2;
            end
            ALU_OR  : begin // Bitwise Or
              output_port_tb = data_1 | data_2;
            end
            ALU_XOR : begin // Bitwise Xor
              output_port_tb = data_1 ^ data_2;  
            end
            ALU_NOR : begin // Bitwise Nor
              output_port_tb = ~(data_1 | data_2);   
            end
            ALU_SLT : begin // Set On Less Than
              output_port_tb = ($signed(data_1) < $signed(data_2)) ? 1 : 0;  
            end
            ALU_SLTU: begin // Set On Less Than Unsigned
              output_port_tb = (data_1 < data_2) ? 1 : 0;
            end
          endcase
          zero_tb = output_port_tb == '0 ? 1 : 0;
          negative_tb = output_port_tb[WORD_W-1];
          set_and_check(opcodes[i], data_1, data_2, output_port_tb, negative_tb, overflow_tb, zero_tb);
        end
      end
    end
  end

  task set_and_check(input aluop_t ALUOP_tb, word_t port_a_tb, port_b_tb, 
    output_port_tb, logic negative_tb, overflow_tb, zero_tb);
    begin 
      set(ALUOP_tb, port_a_tb, port_b_tb);
      #(PERIOD)

      // check
      assert(output_port == output_port_tb && negative == negative_tb && overflow == overflow_tb && zero == zero_tb)
      else begin
        $display("Input: ");
        printOpcode(ALUOP_tb);
        $display("%h,%h => %h, %h", port_a_tb, port_b_tb, port_a_tb[WORD_W-1], port_b_tb[WORD_W-1]);
        $display("Actual vs. expected\n==================================",);
        $display("output_port: %h, %h\nnegative: %h, %h\noverflow: %h, %h\nzero: %h, %h\n",
          output_port, output_port_tb, negative, negative_tb, overflow_tb, overflow_tb, zero, zero_tb);
      end
    end
    
  endtask

  task printOpcode(input aluop_t opcode);
    begin
      casez (opcode)
        ALU_SLL : begin // Shift Left Logic Variable
          $display("SLL: Shift Left Logic Variable");
        end
        ALU_SRL : begin // Shift Right Logic Variable
          $display("SRL: Shift Right Logic Variable");
        end 
        ALU_ADD : begin // Add
          $display("ADD: Add");  
        end
        ALU_SUB : begin // Subtract 
          $display("SUB: Subtract");  
        end
        ALU_AND : begin // Bitwise And
          $display("AND: Bitwise And");  
        end
        ALU_OR  : begin // Bitwise Or
          $display("OR: Bitwise Or");  
        end
        ALU_XOR : begin // Bitwise Xor
          $display("XOR: Bitwise Xor");
        end
        ALU_NOR : begin // Bitwise Nor
          $display("NOR: Bitwise Nor");
        end
        ALU_SLT : begin // Set On Less Than
          $display("SLT: Set On Less Than");
        end
        ALU_SLTU: begin // Set On Less Than Unsigned
          $display("STLU: Set On Less Than Unsigned");
        end
      endcase
    end
  endtask 

  task set(input aluop_t ALUOP_tb, word_t port_a_tb, port_b_tb);
    begin
        ALUOP = ALUOP_tb;
        port_a = port_a_tb;
        port_b = port_b_tb;
    end
  endtask

  task reset();
    begin
      ALUOP = aluop_t'('0);
      port_a = word_t'('0);
      port_b = word_t'('0);
      #(PERIOD)
      $display("");
    end
  endtask 

endprogram
