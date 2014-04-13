
module ID(sawJump, memRd, memWr, sextOut, sawBranch, branchOp, p0, p1, shAmt, aluOp, src1sel, hlt, instr, zr, dst, clk, link);
  input zr, clk;
  input [15:0] dst, instr, link;
  output [15:0] p0, p1;
  output [3:0] shAmt;
  output [3:0] aluOp;
  output src1sel, hlt;
  output sawBranch, memRd, memWr, sawJump;
  output [2:0] branchOp;
  output [15:0] sextOut;
  
  wire [3:0] p0_addr, p1_addr, dst_addr;
  wire re0, re1, we;
  
  wire [15:0] toWrite;
  wire [7:0] toSext;
  
  assign toWrite = (sawJump == 1'b1) ? link+1 : dst;
  
  assign toSext = (instr[15:12] == 4'h9) ? {{4{instr[3]}}, instr[3:0]} :
                  (instr[15:12] == 4'h8) ? {{4{instr[3]}}, instr[3:0]} :
                  instr[7:0];
  
  instr_dec instr_dec(sawJump, memRd, memWr, p0_addr, p1_addr, dst_addr, re0, re1, we, sawBranch, branchOp, aluOp, shAmt, src1sel, hlt, instr, zr);
  
  RF RF(clk, p0_addr, p1_addr, p0, p1, re0, re1, dst_addr, toWrite, we, hlt);
  
  sext8_16 sext(sextOut, toSext);
  
endmodule
