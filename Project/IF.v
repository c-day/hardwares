
module IF(instr, pc, hlt, clk, rst_n, PCSrc, target, jTarget);
  input hlt, clk, rst_n;
  input [1:0] PCSrc;
  input [15:0] target, jTarget;
  output [15:0] instr, pc;
  
  PC PC(pc, hlt, clk, rst_n, PCSrc, target, jTarget);

  IM IM(clk, pc, 1'b1, instr);

  
  
endmodule
