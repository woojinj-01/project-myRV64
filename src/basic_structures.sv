//=======================================================
// basic_structures.sv
//
// author: Woojin Jung
//=======================================================

import Type::*;

module SRAM#(
  parameter DATA_WIDTH = 32 //in bits
  parameter DATA_DEPTH = 8
)(
  
  input SIG_CLK,
  input SIG_RSTn,
  
  input CMD_WR,
  input CMD_RD,
  
  input [$clog2(DATA_DEPTH)-1:0] ADDR_IN,
  input [DATA_WIDTH-1:0] DATA_IN,
  
  output logic [DATA_WIDTH-1:0]DATA_OUT
);
  logic memory,dataOut;
  assign DATA_OUT = dataOut;
  
  always_ff@(posedge SIG_CLK) begin
    if(!SIG_RSTn) memory <= 1'b0;
    else if(CMD_WR) memory <= DATA_IN;
    else if(CMD_RD) dataOut <= memory;
  end
endmodule


module Register32(
  
  input SIG_CLK,
  input SIG_RSTn,
  input CMD_KEEP,
  input Data32_T DATA_IN,
  
  output Data32_T DATA_OUT
);
  
  Data32_T nextDataOut;
  assign nextDataOut = CMD_KEEP ? DATA_OUT : DATA_IN;
  
  always_ff@(SIG_CLK) begin
    if(!SIG_RSTn) DATA_OUT<=32'b0;
    else DATA_OUT<=nextDataOut;
    
  end
  
endmodule

module Queue32#(
  parameter QUEUE_DEPTH; 
)(
  input SIG_CLK,
  input SIG_RSTn,
  
  input CMD_POP,
  input CMD_PUSH,
  input Data32_T DATA_TO_PUSH,
  
  output Data32_T DATA_FROM_POP,
  output SIG_FULL
);
  /*declare Data32_T array*/
  Register32 inputReg(
    .SIG_CLK(SIG_CLK),
    .SIG_RSTn(SIG_RSTn),
    .CMD_KEEP(),
    .DATA_IN(),
    
    .DATA_OUT()
  );
  
  Register32 outputReg(
    .SIG_CLK(SIG_CLK),
    .SIG_RSTn(SIG_RSTn),
    .CMD_KEEP(),
    .DATA_IN(),
    
    .DATA_OUT()
  );
  
  generate
    genvar i;
    for(i=0;i<QUEUE_DEPTH-1;i++) begin: bridgeRegister
      Register32 bridgeReg(
        .SIG_CLK(),
        .SIG_RSTn(),
        .CMD_KEEP(),
        .DATA_IN(),

        .DATA_OUT()
      );
    end
  endgenerate
  
  
  
  
  
endmodule
