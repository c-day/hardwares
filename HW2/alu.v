/*******************************************************************************
* ECE 552 ALU
* Author: Craig Day and Ethan Massey
*
* The ALU accepts 2 16 bit sources (src0, src1) and will perform the operation
* specified by the 4 bit control signal (ctrl).  It will return the result on 
* a 16 bit bus (dst) and set overflow (ov) and zero (zr) flags accordingly. When
* a shit is to be performed, src0 will be shifted by an amount specified in the
* shamt parameter.
*
* Parameters:
* src0 - input used for all operations
* src1 - input used in any two-op operations
* ctrl - the control signal specifying the operation to be performed
* shamt - the amount to shift by if a shift is being performed
* 
* Returns:
* dst - the result of the operation specified by ctrl
* ov - contains 1 on overflow, 0 otherwise
* zr - contains 1 if result is 0, 0 otherwise
*******************************************************************************/

//preforms addition and checks for overflow
module SAT(sum, ov, src0, src1);
  input [15:0] src0, src1;
  output ov;
  output [15:0] sum;
  
  //intermediate sum used to check for overflow
  wire [15:0] sumTemp;
  
  assign sumTemp = src0 + src1;
  
  //check for positive or negative overflow
  assign negOV = ~src0[15] & ~src1[15] & sumTemp[15];
  assign posOV = src0[15] & src1[15] & ~sumTemp[15];
  
  //make a type of mux here with assigns
  assign sum = ({posOV, negOV} == 2'b00) ? sumTemp :    //no overflow
                ({posOV, negOV} == 2'b01) ? 16'h8000 :  //neg overflow
                ({posOV, negOV} == 2'b10) ? 16'h7FFF :  //pos overflow
                16'hFFFF;                               //shouldn't happen
      
  assign ov = ({posOV, negOV} == 2'b00) ? 1'b0 :        //no overflow
              ({posOV, negOV} == 2'b01) ? 1'b1 :        //neg overflow
              ({posOV, negOV} == 2'b10) ? 1'b1 :        //pos overflow
              15'hFFFF;                                 //shouldnt happen
endmodule

module ALU(dst, ov, zr, src0, src1, ctrl, shamt);
	input [15:0] src0, src1;
	input [3:0] ctrl;
	input [3:0] shamt;
	output [15:0] dst;
	output ov, zr;
	
	wire [15:0] added, subed;
	wire aov, sov;

	// Use parameters so that the opcodes can be specified by higher
	// level modules.  
	parameter addOp = 4'b0000;
	parameter subOp = 4'b0001;
	parameter andOp = 4'b0010;
	parameter norOp = 4'b0011;
	parameter sllOp = 4'b0100;
	parameter srlOp = 4'b0101;
	parameter sraOp = 4'b0110;
	parameter lhbOp = 4'b0111;
	
	SAT saturate1(added, aov, src0, src1);
	SAT saturate2(subed, sov, src0, (~src1 + 1));

	//signed wire to contain the right arithmatic shift value	
	wire signed [15:0] sra;
	
	// do the right arathmatic shift using the signed bus,
	// forces the MSB to behave correctly
	assign sra = src0 >>> shamt;
	
	//parallel_case
	assign 	{ov, dst} = (ctrl == addOp) ? {aov, added} :
											(ctrl == subOp) ? {sov, subed} :
											(ctrl == andOp) ? {1'b0, src0 & src1} :
											(ctrl == norOp) ? {1'b0, ~(src0 | src1)} :
											(ctrl == sllOp) ? {1'b0, src0 << shamt} :
											(ctrl == srlOp) ? {1'b0, src0 >> shamt} :
											(ctrl == sraOp) ? {1'b0, sra} :	
											(ctrl == lhbOp) ? {1'b0, {src0[15:8], 8'd0} | src1} :
											17'd0;
	
// nor all of the bits together, will set zr to 1 only when all bits of result are 0
	assign zr = ~|dst;

endmodule