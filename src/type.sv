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
      //Operation-to-Id mapping
      //e.g, ADD = 7'b10010000
  }OperationId_T;                   //Maps a single operation to a single byte

  // Data types to support 8 Bytes to 1 Byte
  typedef logic[63:0] Data64_T;
  typedef logic[31:0] Data32_T;
  typedef logic[15:0] Data16_T;
  typedef logic[7:0] Data8_T;
  //

  typedef enum logic {
    TRUE = 1'b1, FALSE = 1'b0
  } Boolean_T;


endpackage
