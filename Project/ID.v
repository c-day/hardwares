
module ID(dst_addr_out, weOut, sawJump, memRd, memWr, sextOut, sawBranch, branchOp, p0, p1, shAmt, aluOp, src1sel, hltOut, hltIn, 
						instr, zr, dst, clk, link, dst_addr_in, weIn);
  input zr, clk, hltIn, weIn;
  input [15:0] dst, instr, link;
	input [3:0] dst_addr_in;
  output [15:0] p0, p1;
  output [3:0] shAmt;
  output [3:0] aluOp, dst_addr_out;
  output src1sel, hltOut, weOut;
  output sawBranch, memRd, memWr, sawJump;
  output [2:0] branchOp;
  output [15:0] sextOut;
  
  wire [3:0] p0_addr, p1_addr, dst_addr;
  wire re0, re1, we;
  
  wire [15:0] toWrite;
  wire [7:0] toSext;
  
  assign toWrite = (sawJump == 1'b1) ? link+1 : dst;
  
  assign toSext = //(instr[15:12] == 4'h9) ? {{4{instr[3]}}, instr[3:0]} :
                  //(instr[15:12] == 4'h8) ? {{4{instr[3]}}, instr[3:0]} :
                  instr[7:0];
  
  instr_dec instr_dec(sawJump, memRd, memWr, p0_addr, p1_addr, dst_addr_out, re0, re1, weOut, sawBranch, branchOp, aluOp, shAmt, src1sel, hltOut, instr, zr);
  
  RF RF(clk, p0_addr, p1_addr, p0, p1, re0, re1, dst_addr_in, toWrite, weIn, hltIn);
  
  sext8_16 sext(sextOut, toSext);
  
endmodule
