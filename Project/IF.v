
module IF(instr, hlt, clk, rst_n);
  input hlt, clk, rst_n;
  output [15:0] instr;
  
  wire [15:0] pc;

  PC PC(pc, hlt, clk, rst_n);

  IM IM(clk, addr, 1'b1, pc);

  
  
endmodule