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
  
  typedef enum{MAP_CONSUMER, MAP_PRODUCER}      mapOption_t;
  typedef logic[VALID_START:PASTMAP_END] mapTable_t[0:NUM_ARCHREG-1];
  typedef logic[0:NUM_PHYREG-1] bitmap_t;
  typedef logic[SIZE_PHYREGPTR-1:0] phyRegPtr_t;
  
  parameter SIZE_PHYREGPTR = 7 //log2(NUM_PHYREG)
  
  RobIndex_T dstRobIndex;
  ArchRegisterId_T dstArchReg, srcArchReg1, srcArchReg2;
  PhyRegisterId_T dstPhyReg, srcPhyReg1, srcPhyReg2, prevMappedPhyReg;
  maptable_t mapTable;
  bitmap_t phyRegBitmap;
  phyRegPtr_t phyRegPtr;
  
  
  function void resetToZero(
    input mapTable_t mapTable,
    input bitmap_t phyRegBitmap,
    input phyRegPtr_t phyRegPtr
  );
    int i;
    
    for(i=VALID_START;i>=PASTMAP_END;i--) begin
      mapTable[i] <= NUM_ARCHREG{1'b0};
    end
    
    phyRegBitmap <= NUM_PHYREG{1'b0};
    phyRegPtr <= SIZE_PHYREGPTR{1'b0};
    
  endfunction
  
  function PhyRegisterId_T phyRegToMap(
    input ArchRegisterId_T archReg,
    input mapTable_t mapTable,
    input bitmap_t phyRegBitmap,
    input phyRegPtr_t phyRegPtr
    input mapOption_t option,
  );
    if(MAP_CONSUMER == option) begin
      return mapTable[archReg][CURRENTMAP_START:CURRENTMAP_END];
    end
    else if(MAP_PRODUCER == option) begin
      return findNewPhyReg(
       phyRegBitmap, phyRegPtr
      );
    end
  endfunction
  
  function findNewPhyReg(
    input bitmap_t phyRegBitmap,
    input phyRegPtr_t phyRegPtr
  );
    /*
    
      Algorithm to find new phyreg.
    
    */
  endfunction
    
  
  
  always_comb begin
    Packet::DecapDecoderToRru(
        packetFromRlu, 
        dstRobIndex, dstArchReg, srcArchReg1, srcArchReg2
      );
    //map src1 (should atomically update bitmap&maptable)
    srcPhyReg1 = phyRegToMap(
      srcArchReg1, mapTable, phyRegBitmap, phyRegPtr, MAP_CONSUMER
    );
    //map src2 (should atomically update bitmap&maptable)
    srcPhyReg2 = phyRegToMap(
      srcArchReg2, mapTable, phyRegBitmap, phyRegPtr, MAP_CONSUMER
    );
    //map dst (should atomically update bitmap&maptable)
    dstPhyReg = phyRegToMap(
      dstArchReg, mapTable, phyRegBitmap, phyRegPtr, MAP_PRODUCER
    );
    /*
      
          Intermediate Stages have to be filled.
          Also, prevMappedReg should be assigned. (not at the above code yet)
      
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
