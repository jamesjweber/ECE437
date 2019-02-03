/*
  James Weber
  weber99@purdue.edu

  control unit testbench
*/

// mapped needs this
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;
  
  // interface
  control_unit_if cuif();

  // test program
  test #(.PERIOD (PERIOD)) PROG (CLK, nRST, cuif);

  // DUT
`ifndef MAPPED
  control_unit DUT(.cuif);
`else
  // implement
`endif

endmodule

program test (
  input logic CLK, 
  output logic nRST, 
  control_unit_if cuif
);
  parameter PERIOD = 10;

  initial begin

    opcode_t [15-1:0] OPS;
    funct_t [13-1:0] functs;
    opcode_t OP;
    funct_t funct; 

    OPS = {J, JAL, ADDI, ADDIU, ANDI, BEQ, BNE, LUI, LW, ORI, SLTI, SLTIU, SW, XORI, HALT};
    functs = {ADD, ADDU, AND, JR, OR, NOR, SLT, SLTU, SLLV, SRLV, SUBU, SUB, XOR};

    #(PERIOD)

    for (int j =13-1; j >= 0; j--) begin
      funct = functs[j];
      cuif.Instr = {RTYPE, 20'h000000, funct};

      #(PERIOD/10)

      $display("\nRTYPE - funct: %s", funct);
      
      casez(funct)
        ADD: begin 
          check(.eALUOp(ALU_ADD));
        end
        ADDU: begin 
          check(.eALUOp(ALU_ADD));
        end
        AND: begin 
          check(.eALUOp(ALU_AND));
        end
        JR: begin 
          check(.ePCSrc(3), .eRegWr(0));
        end
        OR: begin 
          check(.eALUOp(ALU_OR));
        end
        NOR: begin 
          check(.eALUOp(ALU_NOR));
        end
        SLT: begin 
          check(.eALUOp(ALU_SLT));
        end
        SLTU: begin 
          check(.eALUOp(ALU_SLT));
        end
        SLLV: begin 
          check();
        end
        SRLV: begin 
          check(.eALUOp(ALU_SRL));
        end
        SUBU: begin 
          check(.eALUOp(ALU_SUB));
        end
        SUB: begin 
          check(.eALUOp(ALU_SUB));
        end
        XOR: begin 
          check(.eALUOp(ALU_XOR));
        end
      endcase
      #(PERIOD*9/10);
    end

    for (int i = 15-1; i >= 0; i--) begin
      OP = OPS[i];
      for (int equal = 0; equal <= 1; equal++) begin
        
        #(PERIOD/10)

        // SET
        cuif.Instr = {OP, 20'h000000, funct};
        cuif.Equal = equal;

        #(PERIOD/10)

        // CHECK
        $display("\nOP: %s, Equal: %0d", OP, equal);
        casez(OP)
          J: begin
            check(.ePCSrc(2), .eRegWr(0));
          end
          JAL: begin
            check(.ePCSrc(2), .eMemToReg(2), .eRegDst(2));
          end
          ADDI: begin
            check(.eRegDst(1), .eALUSrc(1), .eALUOp(ALU_ADD));
          end
          ADDIU: begin
            check(.eRegDst(1), .eALUSrc(1), .eALUOp(ALU_ADD));
          end
          ANDI: begin
            check(.eRegDst(1), .eExtOp(0), .eALUSrc(1), .eALUOp(ALU_AND));
          end
          BEQ: begin
            check(.ePCSrc(equal), .eRegWr(0), .eALUOp(ALU_SUB));
          end
          BNE: begin
            check(.ePCSrc(!equal ? 1 : 0), .eRegWr(0), .eALUOp(ALU_SUB));
          end
          LUI: begin
            check(.eRegDst(1), .eExtOp(2), .eALUSrc(1));
          end
          LW: begin
            check(.eRegDst(1), .eALUSrc(1), .eALUOp(ALU_ADD), .eMemToReg(1), .edmemREN(1));
          end
          ORI: begin
            check(.eRegDst(1), .eExtOp(0), .eALUSrc(1), .eALUOp(ALU_OR));
          end
          SLTI: begin
            check(.eRegDst(1), .eALUSrc(1), .eALUOp(ALU_SLT));
          end
          SLTIU: begin
            check(.eRegDst(1), .eALUSrc(1), .eALUOp(ALU_SLT));
          end
          SW: begin
            check(.eRegWr(0), .eRegDst(1), .eALUSrc(1), .eMemWr(1), .edmemWEN(1), .eALUOp(ALU_ADD));
          end
          XORI: begin
            check(.eRegDst(1), .eExtOp(0), .eALUSrc(1), .eALUOp(ALU_XOR));
          end
          HALT: begin
            check(.eRegWr(0), .eMemWr(0), .eHalt(1));
          end
        endcase

        #(PERIOD*8/10);
      
      end
    end
  end

  task check(
    input logic eRegWr =1, eMemWr=0, eimemREN=1, edmemWEN=0, edmemREN =0, eHalt=0,
    logic [1:0] eRegDst=0, ePCSrc=0, eALUSrc =0, eExtOp  =1, eMemToReg=0,
    aluop_t     eALUOp  =ALU_SLL
  );
    int error;
    error = 0;

    assert(eRegWr == cuif.RegWr) else error = 1;
    assert(eMemWr == cuif.MemWr) else error = 1;
    assert(eimemREN == cuif.imemREN) else error = 1;
    assert(edmemWEN == cuif.dmemWEN) else error = 1;
    assert(edmemREN == cuif.dmemREN) else error = 1;
    assert(eHalt == cuif.Halt) else error = 1;
    assert(eRegDst == cuif.RegDst) else error = 1;
    assert(ePCSrc == cuif.PCSrc) else error = 1;
    assert(eALUSrc == cuif.ALUSrc) else error = 1;
    assert(eExtOp == cuif.ExtOp) else error = 1;
    assert(eMemToReg == cuif.MemToReg) else error = 1;
    assert(eALUOp == cuif.ALUOp) else error = 1;

    if (error) begin
      $display("@%00g Actual vs. Expected\n", $time,
        "=============================================\n",
        "RegWr:    %0d, %0d |\t MemWr:   %0d, %0d\n", cuif.RegWr, eRegWr, cuif.MemWr, eMemWr,
        "imemREN:  %0d, %0d |\t dmemWEN: %0d, %0d\n", cuif.imemREN, eimemREN, cuif.dmemWEN, edmemWEN,
        "dmemREN:  %0d, %0d |\t Halt:    %0d, %0d\n", cuif.dmemREN, edmemREN, cuif.Halt, eHalt,
        "RegDst:   %0d, %0d |\t PCSrc:   %0d, %0d\n", cuif.RegDst, eRegDst, cuif.PCSrc, ePCSrc,
        "ALUSrc:   %0d, %0d |\t ExtOP:   %0d, %0d\n", cuif.ALUSrc, eALUSrc, cuif.ExtOp, eExtOp,
        "MemToReg: %0d, %0d |\t ALUOp:   %s, %s\n", cuif.MemToReg, eMemToReg, cuif.ALUOp, eALUOp
      );
    end

  endtask

endprogram