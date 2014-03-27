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
  
  //other connections
  wire [1:0] PCSrc_MEM_IF;
  wire memRd, memWr;
<<<<<<< HEAD
  wire [15:0] target_MEM_IF, writeData_WB_ID, aluResult_EX_MEM, jumpAddress_EX_IF;
=======
>>>>>>> parent of ff505f6... i think this is ok
  
  //unpipelined connections
  wire N, Z, V;
  
  //stage passthroughs
  assign branchOp_EX_MEM = branchOp_ID_EX;
  assign sawBranch_EX_MEM = sawBranch_ID_EX;
  assign pc_ID_EX = pc_IF_ID;
  
  
  //instruction fetch stage
  IF IF(.instr(instr_IF_ID), .pc(pc_IF_ID), .hlt(hlt), .clk(clk), .rst_n(rst_n), .PCSrc(PCSrc_MEM_IF), .target(target_MEM_IF), .jTarget(jumpAddress_EX_IF));
  
  //instruction decode stage
  ID ID(.memRd(memRd), .memWr(memWr), .sextOut(sext_ID_EX), .sawBranch(sawBranch_ID_EX), .branchOp(branchOp_ID_EX), .p0(p0_ID_EX), .p1(p1_ID_EX), .shAmt(shAmt_ID_EX), .aluOp(aluOp_ID_EX), .src1sel(src1sel), .hlt(hlt), .instr(instr_IF_ID), .zr(Z), .dst(writeData_WB_ID), .clk(clk));
  
  //execute stage
  EX EX(.aluResult(aluResult_EX_MEM), .V(V), .Z(Z), .N(N), .addResult(target_MEM_IF), .jumpTo(), .offset(instr_IF_ID[11:0]), .sextIn(sext_ID_EX), .p0(p0_ID_EX), .p1(p1_ID_EX), .shAmt(shAmt_ID_EX), .aluOp(aluOp_ID_EX), .imm(instr_IF_ID[7:0]), .src1sel(src1sel), .pc(pc_IF_ID));
  
  //memory access stage
  MEM MEM(.PCSrc(PCSrc_MEM_IF), .readData(readData_MEM_WB), .memRead(memRd), .memWrite(memWr), .sawBranch(sawBranch_EX_MEM), .branchOp(branchOp_EX_MEM), .clk(clk), .writeData(p1_ID_EX), .address(aluResult_EX_MEM), .N(N), .Z(Z), .V(V));
  
  //write back stage
  WB WB(.writeData(writeData_WB_ID), .readData(readData_MEM_WB), .address(aluResult_EX_MEM), .memToReg(memRd));
endmodule