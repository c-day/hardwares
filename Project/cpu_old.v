/*******************************************************************************
* ECE 552
* WISC architecture
* Single cycle, non-branching implementation
*
* Craig Day
*******************************************************************************/
module cpu(hlt, clk, rst_n);
  input clk, rst_n;
  output hlt;
  
  wire [15:0] pc;
  wire im_rd, halt;
  wire re0, re1, we;
  wire [15:0] instr;
  wire [15:0] p0, p1, dst;
  wire [7:0] instr_imm;
  wire [2:0] aluOp;
  wire src1sel;
  wire [3:0] p0_addr, p1_addr, dst_addr;
  
  assign im_rd = 1'b1;
  assign instr_imm = instr[7:0];
  assign hlt = halt;
  
  //define the instruction memory
  IM IM(.clk(clk), .addr(pc), .rd_en(im_rd), .instr(instr));
  
  //define the register file
  RF RF(.clk(clk), .p0_addr(p0_addr), .p1_addr(p1_addr), .p0(p0), .p1(p1), .re0(re0), .re1(re1), .dst_addr(dst_addr), .dst(), .we(we), .hlt(halt));
  
  //define the pc logic
  PC PC(.pc(pc), .hlt(halt), .clk(clk), .rst_n(rst_n));
  
  //define the instruction decoder
  instr_dec ID(.p0_addr(p0_addr), .p1_addr(p1_addr), .dst_addr(dst_addr), .re0(re0), .re1(re1), .we(we), .aluOp(aluOp), .shAmt(), .src1sel(src1sel), .hlt(halt), .instr(instr), .zr());
  
  //define the ALU src select mux
  SRC_MUX SRC_MUX(.src1(), .p1(p1), .imm(instr_imm), .sel(src1sel));
  
  //define the ALU
    
   
endmodule