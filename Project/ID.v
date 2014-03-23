
module ID(sawBranch, branchOp, p0, p1, shAmt, aluOp, src1sel, hlt, sextOut, instr, zr, dst, clk);
  input zr, clk;
  input [15:0] dst, instr;
  output [15:0] p0, p1;
  output [3:0] shAmt;
  output [2:0] aluOp;
  output src1sel, hlt;
  output [31:0] sextOut;
  output sawBranch;
  output [2:0] branchOp;
  
  wire [3:0] p0_addr, p1_addr, dst_addr;
  wire re0, re1, we;
  
  instr_dec instr_dec(p0_addr, p1_addr, dst_addr, re0, re1, we, sawBranch, branchOp, aluOp, shAmt, src1sel, hlt, instr, zr);
  
  RF RF(clk, p0_addr, p1_addr, p0, p1, re0, re1, dst_addr, dst, we, hlt);
  
  sext8_16 sext8_16(sextOut, instr[7:0]);
  
  
endmodule
