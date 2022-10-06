//=======================================================
// packet.sv
//
// author: Woojin Jung
//=======================================================

/**
  * Various components in project-myRV64 communicates by 32-bit packets.
  * packet.sv defines various packet format between distinct components.
  */

/*=======================================================
                    [Packet Infos]
1. DecoderToRru
  Src: Instruction Decoder
  Dst: Register Renaming Unit
  
2. RruToRob[1-2]
  Src: Register Renaming Unit
  Dst: Re-Order Buffer

3. DecoderToRob[1-4]
  Src: Instruction Decoder
  Dst: Re-Order Buffer

=======================================================*/

package Packet;
	
	typedef struct packed{
      
      Type::RobIndex_T robIndex;
      logic[24:19] reserved;
      Type::ArchRegisterId_T destArchReg;
      Type::ArchRegisterId_T srcArchReg1;
      Type::ArchRegisterId_T srcArchReg2;
    
  }DecoderToRru;

	typedef struct packed{
      
      Type::RobIndex_T robIndex;
      logic[24:24] reserved;
      Type::PhyRegisterId_T destPhyReg;
      Type::PhyRegisterId_T srcPhyReg1;
      Type::PhyRegisterId_T srcPhyReg2;
    
  }RruToRob1;

	typedef struct packed{
      
      logic[31:8] reserved;
      Type::PhyRegisterId_T prevMappedPhyReg;
	
	}RruToRob2;

	typedef struct packed{
      
      Type::RobIndex_T robIndex;
      logic[24:23] reserved1;
      Type::Boolean_T isBranchInstruction;
      Type::Boolean_T isBranchTaken;
      logic[20:8] reserved2;
      Type::OperationId_T operationId;
      
    }DecoderToRob1

	typedef struct packed{
      
      Type::Data32_T lowerImmediate;
      
    }DecoderToRob2;

	typedef struct packed{
      
      Type::Data32_T upperPC;
      
    }DecoderToRob3;

	typedef struct packed{
      
      Type::Data32_T lowerPC;
      
    }DecoderToRob4;
  
endpackage
