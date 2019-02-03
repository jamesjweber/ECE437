/*
  James Weber
  weber99@purdue.edu

  Control Unit Types 
*/

`ifndef CU_TYPES_PKG_VH
`define CU_TYPES_PKG_VH
package cu_types_pkg;

  // control signal width
  parameter CS_W      = 1;

// control signal types

  // pcsrc type
  typedef enum logic [CS_W-1:0] {
    INCR_PC   = 1'b0,
    BRANCH    = 1'b1
  } pcsrc_t;

  // alusrc type
  typedef enum logic [CS_W-1:0] {
    REG_B     = 1'b0,
    IMM       = 1'b1
  } alusrc_t;

  // extop type
  typedef enum logic [CS_W-1:0] {
    ZERO_EXT  = 1'b0,
    SIGN_EXT  = 1'b1
  } extop_t;

  // memwr type
  typedef enum logic [CS_W-1:0] {
    M_READ    = 1'b0,
    M_WRITE   = 1'b1
  } memwr_t;

  // memtoreg type
  typedef enum logic [CS_W-1:0] {
    ALU_RES   = 1'b0,
    MEMORY    = 1'b1
  } memtoreg_t;

  // regwr type
  typedef enum logic [CS_W-1:0] {
    R_READ    = 1'b0,
    R_WRITE   = 1'b1
  } regwr;

  // regdst type
  typedef enum logic [CS_W-1:0] {
    RT        = 1'b0,
    RD        = 1'b1
  } regdst_t;

endpackage
`endif //CU_TYPES_PKG_VH
