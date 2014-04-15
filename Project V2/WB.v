module WB(
  memData, 
  aluResult, 
  mem2reg, 
  wrData
);
  input [15:0] memData, aluResult;
  input mem2reg;
  output [15:0] wrData;
  
  assign wrData = (mem2reg == 1'b1) ? memData : aluResult;
  
endmodule