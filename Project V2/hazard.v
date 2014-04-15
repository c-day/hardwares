module hazard(
  wrReg_FF_EX,
  wrReg_FF_MEM,
  wrReg_FF_WB,
  rdReg1_ID_FF,
  rdReg2_ID_FF,
  EX_reg1_haz,
  EX_reg2_haz
);

  input [3:0] wrReg_FF_EX, wrReg_FF_MEM, wrReg_FF_WB, rdReg1_ID_FF, rdReg2_ID_FF;
  output EX_reg1_haz, EX_reg2_haz;
  
  assign EX_reg1_haz = (wrReg_FF_EX == rdReg1_ID_FF) ? 1'b1 :
                       (wrReg_FF_MEM == rdReg1_ID_FF) ? 1'b1 :
                       (wrReg_FF_WB == rdReg1_ID_FF) ? 1'b1 :
                       1'b0;
                       
  assign EX_reg2_haz = (wrReg_FF_EX == rdReg2_ID_FF) ? 1'b1 :
                       (wrReg_FF_MEM == rdReg2_ID_FF) ? 1'b1 :
                       (wrReg_FF_WB == rdReg2_ID_FF) ? 1'b1 :
                       1'b0;
  
endmodule