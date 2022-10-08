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
  input Packet::RobToRru packetFromRob,
  
  output Packet::RruToRob1 packetToRob1,
  output Packet::RruToRob2 pacektToRob2
);
  parameter VALID_START = 14, VALID_END = 14,
            CURRENTMAP_START = 13, CURRENTMAP_END = 7,
            PASTMAP_START = 6, PASTMAP_END = 0;
  
  typedef enum{MAP_CONSUMER, MAP_PRODUCER}   mapOption_t;
  typedef logic[VALID_START:PASTMAP_END] mapTable_t[0:NUM_ARCHREG-1];
  typedef logic[0:NUM_PHYREG-1] bitmap_t;
  typedef logic[$clog2(NUM_PHYREG)-1:0] phyRegPtr_t;
 
  
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
    phyRegPtr <= $clog2(NUM_PHYREG){1'b0};
    
  endfunction
  
  function PhyRegisterId_T phyRegToMap(
    input ArchRegisterId_T archReg,
    input mapTable_t mapTable,
    input bitmap_t phyRegBitmap,
    input phyRegPtr_t phyRegPtr,
    input mapOption_t option
  );
    //INVALIDATES msb in returning PhyRegisterId_T when no phyreg is avaliable.
    PhyRegisterId_T tempPhyreg;
    
    if(!archReg[$clog2(NUM_PHYREG)])begin
      tempPhyreg = 
      return tempPhyreg;
    end
    
    if(MAP_CONSUMER == option) begin
      return mapTable[archReg][CURRENTMAP_START:CURRENTMAP_END];
    end
    else if(MAP_PRODUCER == option) begin
      tempPhyreg = findNewPhyReg(
       phyRegBitmap, phyRegPtr
      );
      phyRegBitmap = phyRegBitmap ^ {{1'b1}<<tempPhyReg};
      
      return tempPhyreg;
    end
  endfunction
  
  function PhyRegisterId_T phyRegToMapManually(
    input ArchRegisterId_T archReg,
    input mapTable_t mapTable,
    input bitmap_t phyRegBitmap,
    input PhyRegisterId_T targetReg
  );
    
    if(!phyRegBitmap[targetReg]) phyRegBitmap = phyRegBitmap ^ {{1'b1}<<targetReg};
    
    return targetReg;
  endfunction
  
  function PhyRegisterId_T findNewPhyReg(
    input bitmap_t phyRegBitmap,
    input phyRegPtr_t phyRegPtr
  );
    //INVALIDATES msb in PhyRegisterId_T when no phyreg is avaliable.
    bitmap_t tempBitmap;
    phyRegPtr_T tempPtr;
    int i;
    
    if(!(|phyRegBitmap)) return {1'b1}<<($clog2(NUM_PHYREG));       //case: no phyreg available
    else begin
      tempPtr = phyRegPtr;
      for(i=0;i<NUM_PHYREG;i++)begin
         if(!phyRegBitmap[tempPtr]) return tempPtr;
         else tempPtr = (tempPtr + 1) / NUM_PHYREG;
      end
    end
    
    return {1'b1}<<($clog2(NUM_PHYREG));
  endfunction
  
  function bitmap_t freeThisPhyReg(
    input bitmap_t phyRegBitmap,
    input PhyRegisterId_T targetReg
  );
    bitmap_t tempBitmap;
    
    if(phyRegBitmap[targetReg]) tempBitmap = phyRegBitmap ^ {{1'b1} << targetReg};
    
    return tempBitmap;
    
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
