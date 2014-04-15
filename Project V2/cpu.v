module cpu(clk, rst_n, hlt);
  input clk, rst_n;
  output hlt;

  wire [15:0] FWD_reg1, FWD_reg2;

hazard H(
  instr,
  rdReg1_EX,
  rdReg2_EX,
  wrReg_EX,
  wrReg_MEM,
  wrReg_WB,
  reg1hazSel,
  reg2hazSel,
);


IF IF(
  .clk(clk),
  .hlt(hlt),
  .nRst(rst_n),
  altAddress,
  useAlt,
  pc,
  instr
);

ID ID(
  .i_clk(clk),
  .i_nRst(rst_n),
  .i_hlt(hlt),
  i_instr,
  i_pc,
  i_wrReg,
  i_wrData,
  i_wrEn,
  o_port0,
  o_port1,
  o_sext,
  o_instr,
  o_wrReg,
  o_memRd,
  o_memWr,
  o_aluOp,
  o_mem2reg,
  o_sawBr,
  o_sawJ,
  o_aluSrc,
  o_shAmt,
  o_rdReg1,
  o_rdReg2,
  o_hlt
);

assign FWD_reg1 = (reg1hazSel == 2'b00) ? aluResult_FF_MEM :
                  (reg1hazSel == 2'b01) ? wrData_WB_ID :
                  reg1_FF_EX;

assign FWD_reg2 = (reg2hazSel == 2'b00) ? aluResult_FF_MEM :
                  (reg2hazSel == 2'b01) ? wrData_WB_ID :
                  reg2_FF_EX;

EX EX(
  pc,
  instr,
  .reg1(FWD_reg1),
  .reg2(FWD_reg2),
  sextIn,
  aluSrc,
  aluOp,
  shAmt,
  aluResult,
  flags,
  targetAddr
);

MEM MEM(
  .clk(clk),
  memAddr,
  flags,
  wrData,
  memWr,
  memRd,
  branchOp,
  rdData,
  PCSrc
);

WB WB(
  memData,
  aluResult,
  mem2reg,
  wrData
);

endmodule
