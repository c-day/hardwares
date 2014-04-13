`include "defines.v"
module branchLogic(PCSrc, N, Z, V, takeBranch, branchOp);
  input takeBranch, N, Z, V; 
  input [2:0] branchOp;
  output PCSrc;
  
  wire temp;
  
  assign PCSrc = temp & takeBranch;
  
  assign temp =  (branchOp == `BNEQ && Z == 1'b0) ? 1'b1 :
                 (branchOp == `BEQ && Z == 1'b1) ? 1'b1 :
                 (branchOp == `BGT && {Z,N} == 2'b00) ? 1'b1 :
                 (branchOp == `BLT && N == 1'b1) ? 1'b1 :
                 (branchOp == `BGTE && N == 1'b0) ? 1'b1 :
                 (branchOp == `BLTE && (N | Z) == 1'b1) ? 1'b1 :
                 (branchOp == `BOVFL && V == 1'b1) ? 1'b1 :
                 (branchOp == `BUNCOND) ? 1'b1 :
                 1'b0;
  
endmodule
