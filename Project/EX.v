
module EX(dst, V, Z, N, addResult, sextIn, p0, p1, shAmt, aluOp, imm, sel, pc);
  input [15:0] p0, p1;
  input [7:0] imm;
  input [3:0] shAmt;
  input [2:0] aluOp;
  input sel;
  input [31:0] sextIn;
  input [15:0] pc;
  output [15:0] dst;
  output V, Z, N;
  output [15:0] addResult;
  
  wire [15:0] src1;
 
  SRC_MUX SRC_MUX(src1, p1, sextIn, sel);
  
  ALU ALU(dst, V, Z, N, p0, src1, aluOp, shAmt);
  
  branchAddress BA(addResult, pc, sextIn);
  
endmodule
