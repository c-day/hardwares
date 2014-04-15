module hazard(
  instr,
  rdReg1_EX,
  rdReg2_EX,
  wrReg_EX,
  wrReg_MEM,
  wrReg_WB,
  reg1hazSel,
  reg2hazSel,
);

  input [15:0] instr;
  input [3:0] rdReg1_EX, rdReg2_EX, wrReg_EX, wrReg_MEM, wrReg_WB;
  output [1:0] reg1hazSel, reg2hazSel;

  assign reg1hazSel = (rdReg1_EX == wrReg_MEM) ? 2'b00 :
                      (rdReg1_EX == wrReg_WB) ? 2'b01 :
                      2'b11;

  assign reg2hazSel = (rdReg2_EX == wrReg_MEM) ? 2'b00 :
                      (rdReg2_EX == wrReg_WB) ? 2'b01 :
                      2'b11;

endmodule
