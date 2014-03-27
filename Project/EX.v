
module EX(aluResult, V, Z, N, addResult, jumpTo, offset, sextIn, p0, p1, shAmt, aluOp, imm, src1sel, pc);
  input [15:0] p0, p1;
  input [7:0] imm;
  input [3:0] shAmt;
  input [2:0] aluOp;
  input src1sel;
  input [31:0] sextIn;
  input [15:0] pc;
  input [12:0] offset;
  output [15:0] aluResult;
  output V, Z, N;
  output [15:0] addResult;
  output [15:0] jumpTo;
  
  wire [15:0] src1;
 
  SRC_MUX SRC_MUX(src1, p1, sextIn, src1sel);
  
  ALU ALU(aluResult, V, Z, N, p0, src1, aluOp, shAmt);
  
  branchAddress BA(addResult, pc, sextIn);
  
  jumpAddress JA(jumpTo, pc, offset);
  
endmodule
