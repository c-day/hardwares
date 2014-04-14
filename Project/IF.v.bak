
module IF(instr, pc, hlt, clk, rst_n, PCSrc, target, takeJump, jrValue);
  input hlt, clk, rst_n, PCSrc, takeJump;
  input [15:0] target, jrValue;
  output [15:0] instr, pc;
  
  wire [15:0] jAddress;
  
  assign jAddress = (instr[15:12] == 4'b1101) ? (pc+1) + instr[11:0] : jrValue;
  
  PC PC(pc, hlt, clk, rst_n, PCSrc, target, takeJump, jAddress);

  IM IM(clk, pc, 1'b1, instr);

  
  
endmodule
