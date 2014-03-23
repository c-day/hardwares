
module branchAddress(addResult, pc, toShift);
  input [15:0] pc;
  input [15:0] toShift;
  output [15:0] addResult;

  assign addResult = pc + (toShift << 2);
  
endmodule