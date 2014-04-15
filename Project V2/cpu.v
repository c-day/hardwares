module cpu(clk, rst_n, hlt);
  input clk, rst_n;
  output hlt;

  wire [2:0] flags_EX_FF, branchOp_EX_FF, branchOp_FF_MEM;

  wire [15:0] FWD_reg1, FWD_reg2;

  wire [15:0] pc_IF_FF, pc_FF_ID, instr_IF_FF, instr_FF_ID, instr_ID_FF, instr_FF_EX,
              sext_FF_EX, sext_ID_FF, aluResult_EX_FF, aluResult_FF_MEM, targetAddr_EX_FF,
              targetAddr_FF_MEM, rdData_MEM_FF, rdData_FF_WB, aluResult_MEM_FF, aluResult_FF_WB,
              reg2_EX_FF, reg2_FF_MEM;

  wire [3:0] reg1_ID_FF, reg1_FF_EX, reg2_ID_FF, reg2_FF_EX, wrReg_FF_EX, wrReg_ID_FF,
              wrReg_EX_FF, wrReg_FF_MEM, wrReg_MEM_FF, wrReg_FF_WB, aluOp_ID_FF, aluOp_FF_EX,
              shAmt_ID_FF, shAmt_FF_EX, rdReg1_ID_FF, rdReg1_FF_EX, rdReg2_ID_FF, rdReg2_FF_EX;

  wire [1:0] reg1hazSel, reg2hazSel;

  wire IF_ID_EN, ID_EX_EN, EX_MEM_EN, MEM_WB_EN, memRd_FF_EX, memRd_ID_FF, memWr_FF_EX, memWr_ID_FF,
        mem2reg_ID_FF, mem2reg_FF_EX, sawBr_ID_FF, sawBr_FF_EX, sawJ_ID_FF, sawJ_FF_EX, aluSrc_ID_FF
        aluSrc_FF_EX, hlt_ID_FF, hlt_FF_EX, memRd_EX_FF, memRd_FF_MEM, memWr_EX_FF, mem2reg_EX_FF,
        sawBr_EX_FF, sawBr_FF_MEM, sawJ_EX_FF, hlt_EX_FF, mem2reg_MEM_FF, mem2reg_FF_WB, hlt_MEM_FF,
        wrRegEn_ID_FF, wrRegEn_FF_EX, wrRegEn_EX_FF, wrRegEn_FF_MEM, wrRegEn_MEM_FF, wrRegEn_FF_WB, PCSrc_MEM_IF;

hazard H(
  .rdReg1_EX(rdReg1_FF_EX),
  .rdReg2_EX(rdReg2_FF_EX),
  .wrReg_EX(wrReg_FF_EX),
  .wrReg_MEM(wrReg_FF_MEM),
  .wrReg_WB(wrReg_FF_WB),
  .reg1hazSel(reg1hazSel),
  .reg2hazSel(reg2hazSel),
);


IF IF(
  .clk(clk),
  .hlt(hlt),
  .nRst(rst_n),
  .altAddress(targetAddr_FF_MEM),
  .useAlt(PCSrc_MEM_IF),
  .pc(pc_IF_FF),
  .instr(instr_IF_FF)
);

//////////////////////////////////////////////////  IF/ID flops ///////////////////////////////////////////////////////
dff_16 ff??(.q(pc_FF_ID), .d(pc_IF_FF), .en(IF_ID_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(instr_FF_ID), .d(instr_IF_FF), .en(IF_ID_EN), .rst_n(rst_n), .clk(clk));

ID ID(
  .i_clk(clk),
  .i_nRst(rst_n),
  .i_hlt(hlt),
  .i_instr(instr_FF_ID),
  .i_pc(pc_FF_ID),
  .i_wrReg(wrReg_FF_WB),
  .i_wrData(wrData_WB_ID),
  .i_wrEn(wrRegEn_FF_WB),
  .o_port0(reg1_ID_FF),
  .o_port1(reg2_ID_FF),
  .o_sext(sext_ID_FF),
  .o_instr(instr_ID_FF),
  .o_wrReg(wrReg_ID_FF),
  .o_memRd(memRd_ID_FF),
  .o_memWr(memWr_ID_FF),
  .o_aluOp(aluOp_ID_FF),
  .o_mem2reg(mem2reg_ID_FF),
  .o_sawBr(sawBr_ID_FF),
  .o_sawJ(sawJ_ID_FF),
  .o_aluSrc(aluSrc_ID_FF),
  .o_shAmt(shAmt_ID_FF),
  .o_rdReg1(rdReg1_ID_FF),
  .o_rdReg2(rdReg2_ID_FF),
  .o_hlt(hlt_ID_FF),
  .o_wrRegEn(wrRegEn_ID_FF)
);

/////////////////////////////////////////////// ID/EX passthrough /////////////////////////////////////////////////////
assign pc_ID_FF = pc_FF_ID;

//////////////////////////////////////////////////  ID/EX flops ///////////////////////////////////////////////////////
dff_15 ff??(.q(pc_FF_EX), .d(pc_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(reg1_FF_EX), .d(reg1_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(reg2_FF_EX), .d(reg2_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(instr_FF_EX), .d(instr_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(sext_FF_EX), .d(sext_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff??(.q(wrReg_FF_EX), .d(wrReg_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff??(.q(aluOp_FF_EX), .d(aluOp_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff??(.q(shAmt_FF_EX), .d(shAmt_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff??(.q(rdReg1_FF_EX), .d(rdReg1_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff??(.q(rdReg2_FF_EX), .d(rdReg2_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(memRd_FF_EX), .d(memRd_ID_FF), .en(ID_EX_EN). .rst_n(rst_n), .clk(clk));
dff    ff??(.q(memWr_FF_EX), .d(memWr_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(mem2reg_FF_EX), .d(mem2reg_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(sawBr_FF_EX), .d(sawBr_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(sawJ_FF_EX), .d(sawJ_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(aluSrc_FF_EX), .d(aluSrc_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(hlt_FF_EX), .d(hlt_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(wrRegEn_FF_EX), .d(wrRegEn_ID_FF), .en(ID_EX_EN), .rst_n(rst_n), .clk(clk));

///////////////////////////////////////////// Data forwarding selection ///////////////////////////////////////////////
assign FWD_reg1 = (reg1hazSel == 2'b00) ? aluResult_FF_MEM :
                  (reg1hazSel == 2'b01) ? wrData_WB_ID :
                  reg1_FF_EX;

assign FWD_reg2 = (reg2hazSel == 2'b00) ? aluResult_FF_MEM :
                  (reg2hazSel == 2'b01) ? wrData_WB_ID :
                  reg2_FF_EX;

EX EX(
  .pc(pc_FF_EX),
  .instr(instr_FF_EX),
  .reg1(FWD_reg1),
  .reg2(FWD_reg2),
  .sextIn(sext_FF_EX),
  .aluSrc(aluSrc_FF_EX),
  .aluOp(aluOp_FF_EX),
  .shAmt(shAmt_FF_EX),
  .aluResult(aluResult_EX_FF),
  .flags(flags_EX_FF),
  .targetAddr(targetAddr_EX_FF)
);

////////////////////////////////////////////// EX/MEM passthrough /////////////////////////////////////////////////////
assign wrReg_EX_FF = wrReg_FF_EX;
assign memRd_EX_FF = memRd_FF_EX;
assign memWr_EX_FF = memWr_FF_EX;
assign mem2reg_EX_FF = mem2reg_FF_EX;
assign sawBr_EX_FF = sawBr_FF_EX;
assign sawJ_EX_FF = sawJ_FF_EX;
assign hlt_EX_FF = hlt_FF_EX;
assign wrRegEn_EX_FF = wrRegEn_FF_EX;
assign reg2_EX_FF = reg2_FF_EX;
assign branchOp_EX_FF = instr_FF_EX[11:9];

////////////////////////////////////////////////// EX/MEM flops ///////////////////////////////////////////////////////
dff_16 ff??(.q(aluResult_FF_MEM), .d(aluResult_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(targetAddr_FF_MEM), .d(targetAddr_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(reg2_FF_MEM), .d(reg2_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff??(.q(wrReg_FF_MEM), .d(wrReg_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_3  ff??(.q(flags_FF_MEM), .d(flags_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_3  ff??(.q(branchOp_FF_MEM), .d(branchOp_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(memRd_FF_MEM), .d(memRd_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(memWr_FF_MEM), .d(memWr_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(mem2reg_FF_MEM), .d(mem2reg_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(sawBr_FF_MEM), .d(sawBr_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(sawJ_FF_MEM), .d(sawJ_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(hlt_FF_MEM), .d(hlt_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(wrRegEn_FF_MEM), .d(wrRegEn_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));


MEM MEM(
  .clk(clk),
  .memAddr(aluResult_FF_MEM),
  .flags(flags_FF_MEM),
  .wrData(reg2_FF_MEM),
  .memWr(memWr_FF_MEM),
  .memRd(memRd_FF_MEM),
  .branchOp(branchOp_FF_MEM),
  .sawBr(sawBr_FF_MEM),
  .sawJ(sawJ_FF_MEM),
  .rdData(rdData_MEM_FF),
  .PCSrc(PCSrc_MEM_IF)
);

////////////////////////////////////////////// MEM/WB passthrough /////////////////////////////////////////////////////
assign wrReg_MEM_FF = wrReg_FF_MEM;
assign aluResult_MEM_FF = aluResult_FF_MEM;
assign mem2reg_MEM_FF = mem2reg_FF_MEM;
assign hlt_MEM_FF = hlt_FF_MEM;
assign wrRegEn_MEM_FF = wrRegEn_FF_MEM;

////////////////////////////////////////////////// MEM/WB flops ///////////////////////////////////////////////////////
dff_16 ff??(.q(rdData_FF_WB), .d(rdData_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff??(.q(aluResult_FF_WB), .d(aluResult_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff??(.q(wrReg_FF_WB), .d(wrReg_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(mem2reg_FF_WB), .d(mem2reg_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(hlt), .d(hlt_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff    ff??(.q(wrRegEn_FF_WB), .d(wrRegEn_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));

WB WB(
  .memData(rdData_FF_WB),
  .aluResult(aluResult_FF_WB),
  .mem2reg(mem2reg_FF_WB),
  .wrData(wrData_WB_ID)
);

endmodule
