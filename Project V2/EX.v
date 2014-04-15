`include "defines.v"
module EX(
  pc, 
  instr,
  reg1, 
  reg2,
  sextIn,  
  aluSrc, 
  aluOp, 
  shAmt, 
  aluResult,
  flags,
  targetAddr
);

  input [15:0] pc, instr, reg1, reg2;
  input [7:0] sextIn;
  input [3:0] aluOp, shAmt;
  output [15:0] aluResult, targetAddr;
  output [2:0] flags;

  wire src1;
  wire [15:0] offset;
  
  assign src1 = (aluSrc == 1'b1) ? reg2 : sextIn;
  
  assign offset = (instr[15:12] == `B) ? {{6{instr[8]}}, instr[8:0]} : {{4{instr[11]}}, instr[11:0]};

  assign targetAddr = pc + offset;

  ALU(.dst(aluResult), .V(flags[0]), .Z(flags[1]), .N(flags[2]), .src0(reg1), .src1(src1), .aluOp(aluOp), .shAmt(shAmt));

endmodule