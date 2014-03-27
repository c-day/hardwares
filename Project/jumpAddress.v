
module jumpAddress(jumpTo, pc, offset);
  input [15:0] pc;
  input [11:0] offset;
  output [15:0] jumpTo;
  
  assign jumpTo = $signed(offset + pc);
  
endmodule
