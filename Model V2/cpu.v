`include "defines.v"
module cpu(clk, rst_n, hlt);
  input clk, rst_n;
  output hlt;

  wire [2:0] flags_EX_FF, branchOp_EX_FF, branchOp_FF_MEM, flags_FF_MEM;

  wire [15:0] FWD_reg1, FWD_reg2;

  wire [15:0] pc_IF_FF, pc_FF_ID, instr_IF_FF, instr_FF_ID, instr_ID_FF, instr_FF_EX,
              sext_FF_EX, sext_ID_FF, aluResult_EX_FF, aluResult_FF_MEM, targetAddr_EX_FF,
              targetAddr_FF_MEM, rdData_MEM_FF, rdData_FF_WB, aluResult_MEM_FF, aluResult_FF_WB,
              wrData_WB_ID, reg1_ID_FF, reg1_FF_EX, reg2_ID_FF, reg2_FF_EX, reg2_EX_FF, reg2_FF_MEM,
							pc_FF_EX, pc_ID_FF, pc_EX_FF, pc_FF_MEM, pc_MEM_FF, pc_FF_WB, instr_FF_MEM, instr_EX_FF;

  wire [3:0]  wrReg_FF_EX, wrReg_ID_FF,
              wrReg_EX_FF, wrReg_FF_MEM, wrReg_MEM_FF, wrReg_FF_WB, aluOp_ID_FF, aluOp_FF_EX,
              shAmt_ID_FF, shAmt_FF_EX, rdReg1_ID_FF, rdReg1_FF_EX, rdReg2_ID_FF, rdReg2_FF_EX;

  wire [1:0] reg1hazSel, reg2hazSel;

  wire IF_ID_EN, ID_EX_EN, EX_MEM_EN, MEM_WB_EN, memRd_FF_EX, memRd_ID_FF, memWr_FF_EX, memWr_ID_FF,
        mem2reg_ID_FF, mem2reg_FF_EX, sawBr_ID_FF, sawBr_FF_EX, sawJ_ID_FF, sawJ_FF_EX, aluSrc_ID_FF,
        aluSrc_FF_EX, hlt_ID_FF, hlt_FF_EX, memRd_EX_FF, memRd_FF_MEM, memWr_EX_FF, mem2reg_EX_FF,
        sawBr_EX_FF, sawBr_FF_MEM, sawJ_EX_FF, hlt_EX_FF, mem2reg_MEM_FF, mem2reg_FF_WB, hlt_MEM_FF,
        wrRegEn_ID_FF, wrRegEn_FF_EX, wrRegEn_EX_FF, wrRegEn_FF_MEM, wrRegEn_MEM_FF, wrRegEn_FF_WB, PCSrc_MEM_IF,
				rst_n_IF_ID, rst_n_ID_EX, PCSrc_FF_WB;

	assign IF_ID_EN = 1'b1;
	assign ID_EX_EN = 1'b1;
	assign EX_MEM_EN = 1'b1;
	assign MEM_WB_EN = 1'b1;

	assign rst_n_IF_ID = rst_n & ~PCSrc_MEM_IF;
	assign rst_n_ID_EX = rst_n & ~PCSrc_MEM_IF;

hazard H(
	.opCode(instr_FF_EX[15:12]),
  .rdReg1_EX(rdReg1_FF_EX),
  .rdReg2_EX(rdReg2_FF_EX),
  .wrReg_EX(wrReg_FF_EX),
  .wrReg_MEM(wrReg_FF_MEM),
  .wrReg_WB(wrReg_FF_WB),
  .reg1hazSel(reg1hazSel),
  .reg2hazSel(reg2hazSel)
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
dff_16 ff00(.q(pc_FF_ID), .d(pc_IF_FF), .en(IF_ID_EN), .rst_n(rst_n_IF_ID), .clk(clk));
dff_16 ff01(.q(instr_FF_ID), .d(instr_IF_FF), .en(IF_ID_EN), .rst_n(rst_n_IF_ID), .clk(clk));

ID ID(
  .i_clk(clk),
  .i_nRst(rst_n),
  .i_hlt(hlt),
  .i_instr(instr_FF_ID),
  .i_pc(pc_FF_ID),
  .i_wrReg(wrReg_FF_WB),
  .i_wrData(wrData_WB_ID),
  .i_wrEn(wrRegEn_FF_WB),
	.i_Z(flags_EX_FF[1]),
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
dff_16 ff02(.q(pc_FF_EX), .d(pc_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_16 ff03(.q(reg1_FF_EX), .d(reg1_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_16 ff04(.q(reg2_FF_EX), .d(reg2_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_16 ff05(.q(instr_FF_EX), .d(instr_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_16 ff06(.q(sext_FF_EX), .d(sext_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_4  ff07(.q(wrReg_FF_EX), .d(wrReg_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_4  ff08(.q(aluOp_FF_EX), .d(aluOp_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_4  ff09(.q(shAmt_FF_EX), .d(shAmt_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_4  ff10(.q(rdReg1_FF_EX), .d(rdReg1_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff_4  ff11(.q(rdReg2_FF_EX), .d(rdReg2_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff12(.q(memRd_FF_EX), .d(memRd_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff13(.q(memWr_FF_EX), .d(memWr_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff14(.q(mem2reg_FF_EX), .d(mem2reg_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff15(.q(sawBr_FF_EX), .d(sawBr_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff16(.q(sawJ_FF_EX), .d(sawJ_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff17(.q(aluSrc_FF_EX), .d(aluSrc_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff18(.q(hlt_FF_EX), .d(hlt_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));
dff    ff19(.q(wrRegEn_FF_EX), .d(wrRegEn_ID_FF), .en(ID_EX_EN), .rst_n(rst_n_ID_EX), .clk(clk));

///////////////////////////////////////////// Data forwarding selection ///////////////////////////////////////////////
assign FWD_reg1 = (reg1hazSel == 2'b00) ? //aluResult_FF_MEM :
											(instr_FF_MEM[15:12] == `LW) ? rdData_MEM_FF : aluResult_FF_MEM :
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
assign reg2_EX_FF = FWD_reg2;
assign branchOp_EX_FF = instr_FF_EX[11:9];
assign pc_EX_FF = pc_FF_EX;
assign instr_EX_FF = instr_FF_EX;

////////////////////////////////////////////////// EX/MEM flops ///////////////////////////////////////////////////////
dff_16 ff20(.q(aluResult_FF_MEM), .d(aluResult_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff21(.q(targetAddr_FF_MEM), .d(targetAddr_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff22(.q(reg2_FF_MEM), .d(reg2_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff39(.q(pc_FF_MEM), .d(pc_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff42(.q(instr_FF_MEM), .d(instr_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff23(.q(wrReg_FF_MEM), .d(wrReg_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_3  ff24(.q(flags_FF_MEM), .d(flags_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff_3  ff25(.q(branchOp_FF_MEM), .d(branchOp_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff26(.q(memRd_FF_MEM), .d(memRd_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff27(.q(memWr_FF_MEM), .d(memWr_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff28(.q(mem2reg_FF_MEM), .d(mem2reg_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff29(.q(sawBr_FF_MEM), .d(sawBr_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff30(.q(sawJ_FF_MEM), .d(sawJ_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff31(.q(hlt_FF_MEM), .d(hlt_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));
dff    ff32(.q(wrRegEn_FF_MEM), .d(wrRegEn_EX_FF), .en(EX_MEM_EN), .rst_n(rst_n), .clk(clk));


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
assign pc_MEM_FF = pc_FF_MEM;
assign PCSrc_MEM_FF = PCSrc_MEM_IF;

////////////////////////////////////////////////// MEM/WB flops ///////////////////////////////////////////////////////
dff_16 ff33(.q(rdData_FF_WB), .d(rdData_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff34(.q(aluResult_FF_WB), .d(aluResult_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff_16 ff40(.q(pc_FF_WB), .d(pc_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff_4  ff35(.q(wrReg_FF_WB), .d(wrReg_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff    ff36(.q(mem2reg_FF_WB), .d(mem2reg_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff    ff37(.q(hlt), .d(hlt_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff    ff38(.q(wrRegEn_FF_WB), .d(wrRegEn_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));
dff    ff41(.q(PCSrc_FF_WB), .d(PCSrc_MEM_FF), .en(MEM_WB_EN), .rst_n(rst_n), .clk(clk));

WB WB(
  .memData(rdData_FF_WB),
  .aluResult(aluResult_FF_WB),
  .mem2reg(mem2reg_FF_WB),
  .wrData(wrData_WB_ID), 
	.pc(pc_FF_WB),
	.PCSrc(PCSrc_FF_WB)
);

endmodule
