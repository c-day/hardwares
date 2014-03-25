module cpu(hlt, pc, clk, rst_n);
  input clk, rst_n;
  output hlt;
  output [15:0] pc;
  
  //connections between the IF and ID stages
  wire [15:0] instr_IF_ID;
  wire [15:0] pc_IF_ID;
  
  //connections between the ID and EX stages
  wire [15:0] p0_ID_EX, p1_ID_EX, sext_ID_EX, pc_ID_EX;
  wire [3:0] shAmt_ID_EX;
  wire [2:0] aluOp_ID_EX, branchOp_ID_EX;
  wire src1sel, sawBranch_ID_EX;
  
  //connections between the EX and MEM stages
  wire [15:0] dst_EX_MEM;
  wire zr_EX_MEM;
  wire [15:0] target_EX_MEM;
  wire sawBranch_EX_MEM;
  wire [2:0] branchOp_EX_MEM;
  
  //connections between the MEM and WB stages
  wire [15:0] readData_MEM_WB;
  
  wire PCSrc_MEM_IF;
  
  //stage passthroughs
  assign branchOp_EX_MEM = branchOp_ID_EX;
  assign sawBranch_EX_MEM = sawBranch_ID_EX;
  assign pc_ID_EX = pc_IF_ID;
  
  
  //instruction fetch stage
  IF IF(.instr(instr_IF_ID), .pc(pc_IF_ID), .hlt(hlt), .clk(clk), .rst_n(rst_n), .PCSrc(PCSrc_MEM_IF), .target(target_EX_MEM));
  
  //instruction decode stage
  ID ID(.sextOut(sext_ID_EX), .sawBranch(sawBranch_ID_EX), .branchOp(branchOp_ID_EX), .p0(p0_ID_EX), .p1(p1_ID_EX), .shAmt(shAmt_ID_EX), .aluOp(aluOp_ID_EX), .src1sel(src1sel), .hlt(hlt), .instr(instr_IF_ID), .zr(zr_EX_MEM), .dst(dst_EX_MEM), .clk(clk));
  
  //execute stage
  EX EX(dst, V, .Z(zr_EX_MEM), N, .addResult(target_EX_MEM), .sextIn(sext_ID_EX), .p0(p0_ID_EX), .p1(p1_ID_EX), .shAmt(shAmt_ID_EX), .aluOp(aluOp_ID_EX), .imm(instr_IF_ID[7:0]), .sel(src1sel), .pc(pc_ID_EX));
  
  //memory access stage
  MEM MEM(.PCSrc(PCSrc_MEM_IF), .readData(readData_MEM_WB), memRead, memWrite, sawBranch, branchOp, clk, writeData, .address(dst_EX_MEM));
  
  //write back stage
  WB WB(writeData, .readData(readData_MEM_WB), .address(dst_EX_MEM), memToReg);
endmodule