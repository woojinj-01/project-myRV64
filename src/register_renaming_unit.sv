//=======================================================
// register_renaming_unit.sv
//
// author: Woojin Jung
//=======================================================

import Type::*;

module RegRenamingUnit #(
  parameter NUM_PHYREG = 128, NUM_ARCHREG = 32, 
  
)(
  input SIG_CLK,
  input SIG_RSTn,
  
  input Packet::DecoderToRru packetFromRru,
  
  output Packet::RruToRob1 packetToRob1,
  output Packet::RruToRob2 pacektToRob2
);
  parameter VALID_START = 14, VALID_END = 14,
            CURRENTMAP_START = 13, CURRENTMAP_END = 7,
            PASTMAP_START = 6, PASTMAP_END = 0;
  
  parameter SIZE_PHYREGPTR = 7 //log2(NUM_PHYREG)
  
  logic[0:NUM_ARCHREG-1] mapTable [VALID_START:PASTMAP_END];
  logic[0:NUM_PHYREG-1] phyRegBitmap;    //manage resource availability
  logic[SIZE_PHYREGPTR-1:0] phyRegPtr;  //pointer to phyreg bitmap
  
  RobIndex_T dstRobIndex;
  ArchRegisterId_T dstArchReg, srcArchReg1, srcArchReg2;
  PhyRegisterId_T dstPhyReg, srcPhyReg1, srcPhyReg2, prevMappedPhyReg;
  
  
  function void resetToZero(
    logic[0:NUM_ARCHREG-1] mapTable [VALID_START:PASTMAP_END],
    logic[0:NUM_PHYREG-1] phyRegBitmap,
    logic[SIZE_PHYREGPTR-1:0] phyRegPtr
  );
    int i;
    
    for(i=VALID_START;i>=PASTMAP_END;i--) begin
      mapTable[i] <= NUM_ARCHREG{1'b0};
    end
    
    phyRegBitmap <= NUM_PHYREG{1'b0};
    phyRegPtr <= SIZE_PHYREGPTR{1'b0};
    
  endfunction
  
  
  always_comb begin
    Packet::DecapDecoderToRru(
        packetFromRlu, 
        dstRobIndex, dstArchReg, srcArchReg1, srcArchReg2
      );
    /*
      
          Intermediate Stages have to be filled.
      
      */
    
  end
  
  always_ff@(SIG_CLK) begin
    if(!SIG_RSTn) resetToZero(mapTable, phyRegBitmap, phyRegPtr);
    else begin
      /*
      
          Intermediate Stages have to be filled.
      
      */
      packetToRob1 <= EncapRruToRob1(
        dstRobIndex, dstPhyReg, srcPhyReg1, srcPhyReg2
      );
      packetToRob2 <= EncapRruToRob2(
        prevMappedPhyReg
      );
      
    end
  end
    
  endfunction
  
  
  
  
  
  
  
  
  
  
  
endmodule
