/*******************************************************************************
* ECE 552
* WISC architecture
* Single cycle, non-branching implementation
* ALU input src select mux
*
* Craig Day
*******************************************************************************/
module SRC_MUX(src1, p1, imm, sel);
  input [15:0] p1;
  input [7:0] imm;
  input sel;
  output [15:0] src1;
  
  assign src1 = (sel) ? p1 : {{8{imm[7]}}, imm[7:0]};
  
endmodule
