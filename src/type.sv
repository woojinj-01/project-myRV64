//=======================================================
// type.sv
//
// author: Woojin Jung
//=======================================================

/**
  * Supports various user-defined types for the project-myRV64. 
  */

package Type;

  typedef logic[6:0] RobIndex_T;  //Indexing 128-Entry re-order buffer 
  typedef logic[5:0] ArchRegisterId_T; //Register id for 32 architectural registers, msb is for valid bit
  typedef logic[7:0] PhyRegisterId_T; //Register Id for 128 physical registers, msb is for valid bit

  typedef enum logic[7:0]{
      //Operation-to-Id linear mapping
      //e.g, ADD = 8'b00011011
   LUI,    AUIPC,    JAL,    JALR,    BEQ
   BNE,    BLT,      BGE,    BLTU,    BGEU,
   LB,     LH,       LW,     LBU,     LHU,
   SB,     SH,       SW,     ADDI,    SLTI,
   SLTIU,  XORI,     ORI,    ANDI,    SLLI,
   SRLI,   SRAI,     ADD,    SUB,     SLL,
   SLT,    SLTU,     XOR,    SRL,     SRA,
   OR,     AND,      FENCE,  ECALL,   BREAK,
   
   LWU,    LD,       SD,     SLLI,    SRLI,
   SRAI,   ADDIW,    SLLIW,  SRLIW,   SRAIW,
   ADDW,   SUBW,     SLLW,   SRLW,    SRAW
   
  }OperationId_T;
 
  typedef logic[63:0] Instruction_T;
 
  // Data types support 8 Bytes to 1 Byte
  typedef logic[63:0] Data64_T;
  typedef logic[31:0] Data32_T;
  typedef logic[15:0] Data16_T;
  typedef logic[7:0] Data8_T;
  //

  typedef enum logic {
    TRUE = 1'b1, FALSE = 1'b0
  } Boolean_T;


endpackage
