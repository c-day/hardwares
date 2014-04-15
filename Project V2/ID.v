module ID (
  i_clk,
  i_nRst,
  i_hlt,
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
  o_hlt,
  o_wrRegEn
);

  input i_clk, i_nRst, i_wrEn;
  input [3:0] i_wrReg;
  input [15:0] i_wrData, i_instr, i_pc;
  output [15:0] o_port0, o_port1, o_sext, o_instr;
  output [3:0] o_wrReg, o_aluOp, o_shAmt, o_rdReg1, o_rdReg2;
  output o_mem2reg, o_sawBr, o_sawJ, o_memRd, o_memWr, o_wrRegEn;

  assign o_sext = {{8{i_instr[7]}}, i_instr[7:0]};
  assign o_instr = i_instr;

  control(.instr(i_instr), .rdEnReg1(rdEn1), .rdEnReg2(rdEn2), .wrRegEn(o_wrRegEn), .rdReg1(o_rdReg1), .rdReg2(o_rdReg2), .wrReg(o_wrReg), .memRd(o_memRd),
  .memWr(o_memWr), .aluOp(o_aluOp), .shAmt(o_shAmt), .mem2reg(o_mem2reg), .sawBr(o_sawBr), .sawJ(o_sawJ), .aluSrc(o_aluSrc), .hlt(o_hlt));

  rf rf(.clk(i_clk), .p0_addr(o_rdReg1), .p1_addr(o_rdReg2), .p0(o_port0), .p1(o_port1), .re0(rdEn1), .re1(rdEn2), .dst_addr(i_wrReg), .dst(i_wrData), .we(i_wrEn), .hlt(i_hlt));

endmodule
