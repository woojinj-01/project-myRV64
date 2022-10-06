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
import Type::*;

package Packet;
	
	/*========== Packet Structures ==========*/
	
	typedef struct packed{
		RobIndex_T robIndex;
		logic[24:19] reserved;
      		ArchRegisterId_T dstArchReg;
      		ArchRegisterId_T srcArchReg1;
      		ArchRegisterId_T srcArchReg2;
		
	}DecoderToRru;

	typedef struct packed{
		RobIndex_T robIndex;
		logic[24:24] reserved;
		PhyRegisterId_T dstPhyReg;
		PhyRegisterId_T srcPhyReg1;
		PhyRegisterId_T srcPhyReg2;
		
	}RruToRob1;

	typedef struct packed{
		logic[31:8] reserved;
		PhyRegisterId_T prevMappedPhyReg;
		
	}RruToRob2;

	typedef struct packed{
		RobIndex_T robIndex;
		logic[24:23] reserved1;
		Boolean_T isBranchInstruction;
		Boolean_T isBranchTaken;
		logic[20:8] reserved2;
		OperationId_T operationId;
		
	}DecoderToRob1

	typedef struct packed{
		Data32_T lowerImmediate;
	
	}DecoderToRob2;

	typedef struct packed{
		Data32_T upperPC;
	
	}DecoderToRob3;

	typedef struct packed{
		Data32_T lowerPC;
	
	}DecoderToRob4;
	
	/*=======================================*/
	
	
	
	/*========== Packet Encapsulation Functions ==========*/
	
	function automatic Packet::DecoderToRru EncapDecoderToRru (
		
		input RobIndex_T robIndex,
      		input ArchRegisterId_T dstArchReg,
      		input ArchRegisterId_T srcArchReg1,
      		input ArchRegisterId_T srcArchReg2
	);
		Packet::DecoderToRru packet;
		
		packet.robIndex = robIndex;
		packet.reserved = 6'b000000;
		packet.dstArchReg = dstArchReg;
		packet.srcArchReg1 = srcArchReg1;
		packet.srcArchReg2 = srcArchReg2;
		
		return packet;
		
	endfunction
	
	function automatic Packet::RruToRob1 EncapRruToRob1 (
		
		input RobIndex_T robIndex,
		input PhyRegisterId_T dstPhyReg,
		input PhyRegisterId_T srcPhyReg1,
		input PhyRegisterId_T srcPhyReg2
	);
		Packet::RruToRob1 packet;
		
		packet.robIndex = robIndex;
		packet.reserved = 1'b0;
		packet.dstPhyReg = dstPhyReg;
		packet.srcPhyReg1 = srcPhyReg1;
		packet.srcPhyReg2 = srcPhyReg2;
		
		return packet;
		
	endfunction
	
	function automatic Packet::RruToRob2 EncapRruToRob2 (
		
		input PhyRegisterId_T prevMappedPhyReg
	);
		Packet::RruToRob2 packet;
		
		packet.reserved = 24'b0;
		packet.prevMappedPhyReg = prevMappedPhyReg;
		
		return packet;
		
	endfunction
	
	function automatic Packet::DecoderToRob1 EncapDecoderToRob1 (
		
		input RobIndex_T robIndex,
		input Boolean_T isBranchInstruction,
		input Boolean_T isBranchTaken,
		input OperationId_T operationId
	);
		Packet::DecoderToRob1 packet;
		
		packet.robIndex = robIndex;
		packet.reserved1 = 2'b00;
		packet.isBranchInstruction = isBranchInstruction;
		packet.isBranchTaken = isBranchTaken;
		packet.reserved2 = 13'b0;
		packet.operationId = operationId;
		
		return packet;
		
	function automatic Packet::DecoderToRob2 EncapDecoderToRob2 (
		input Data32_T lowerImmediate
	);
		Packet::DecoderToRob2 packet;
		packet.lowerImmediate = lowerImmediate;
		
		return packet;
		
	endfunction
		
	function automatic Packet::DecoderToRob3 EncapDecoderToRob3 (
		input Data32_T upperPC
	);
		Packet::DecoderToRob3 packet;
		packet.upperPC = upperPC;
		
		return packet;
		
	endfunction
		
	function automatic Packet::DecoderToRob4 EncapDecoderToRob4 (
		input Data32_T lowerPC
	);
		Packet::DecoderToRob4 packet;
		packet.lowerPC = lowerPC;
		
		return packet;
		
	endfunction
	
	/*====================================================*/
		
	/*========== Packet Decapsulation Functions ==========*/
	
	function automatic void DecapDecoderToRru (
		
		input Packet::DecoderToRru packet,
		
		output RobIndex_T robIndex,
      		output ArchRegisterId_T dstArchReg,
      		output ArchRegisterId_T srcArchReg1,
      		output ArchRegisterId_T srcArchReg2
	);
		robIndex = packet.robIndex;
		dstArchReg = packet.dstArchReg;
		srcArchReg1 = packet.srcArchReg1;
		srcArchReg1 = packet.srcArchReg2;
		
		return;
	endfunction
	
	function automatic void DecapRruToRob1 (
		
		input Packet::RruToRob1 packet,
		
		output RobIndex_T robIndex,
		output PhyRegisterId_T dstPhyReg,
		output PhyRegisterId_T srcPhyReg1,
		output PhyRegisterId_T srcPhyReg2
	);
		
		robIndex = packet.robIndex;
		dstPhyReg = packet.dstPhyReg;
		srcPhyReg1 = packet.srcPhyReg1;
		srcPhyReg2 = packet.srcPhyReg2;
		
		return;
	endfunction
	
	function automatic void DecapRruToRob2 (
		
		input Packet::RruToRob2 packet,
		
		output PhyRegisterId_T prevMappedPhyReg
	);
		prevMappedPhyReg = packet.prevMappedPhyReg;
		
		return;
		
	endfunction
	
	function automatic void DecapDecoderToRob1 (
		
		input Packet::DecoderToRob1 packet,
		
		output RobIndex_T robIndex,
		output Boolean_T isBranchInstruction,
		output Boolean_T isBranchTaken,
		output OperationId_T operationId
	);
		
		robIndex = packet.robIndex;
		isBranchInstruction = packet.isBranchInstruction;
		isBranchTaken = packet.isBranchTaken;
		operationId = packet.operationId;
		
		return;
	endfunction
		
	function automatic void DecapDecoderToRob2 (
		
		input Packet::DecoderToRob2 packet,
		
		output Data32_T lowerImmediate
	);
		lowerImmediate = packet.lowerImmediate;
	
		return;
	endfunction
		
	function automatic void DecapDecoderToRob3 (
		
		input Packet::DecoderToRob3 packet,
		
		output Data32_T upperPC
	);
		upperPC = packet.upperPC;
		
		return;
	endfunction
		
	function automatic void DecapDecoderToRob4 (
		
		input Packet::DecoderToRob4 packet,
		
		output Data32_T lowerPC
	);
		lowerPC = packet.lowerPC;
		
		return;
	endfunction
	
	/*====================================================*/
	
	
  
endpackage
