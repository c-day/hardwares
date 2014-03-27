
module IF(instr, pc, hlt, clk, rst_n, PCSrc, target);
  input hlt, clk, rst_n, PCSrc;
  input [15:0] target;
  output [15:0] instr, pc;
  
  PC PC(pc, hlt, clk, rst_n, PCSrc, target);

  IM IM(clk, pc, 1'b1, instr);

  
  
endmodule
