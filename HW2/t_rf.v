/*******************************************************************************
* ECE 552
* HW 2, Problem 3
* Authors:
* Ethan Massey
*******************************************************************************/

module t_rf();
	reg [3:0] dst_addr, p0_addr, p1_addr;
	reg re0, re1, we, hlt, clk, clk2;
	reg [15:0] dst;
	wire [15:0] p0, p1;
	
	reg [15:0] myRegs [0:15];
	
	integer i;
	reg [15:0] rand;
	
	rf DUT(clk,p0_addr,p1_addr,p0,p1,re0,re1,dst_addr,dst,we,hlt);
	
	/******************************************************************************
	* Initialize our parameters.  Start clocks, set counter, load starting memory,
	* generate first random value to write
	******************************************************************************/
	initial begin
	  clk = 1'b1;
	  clk2 = 1'b1;
	  we = 1'b0;
	  re0 = 1'b0;
	  re1 = 1'b0;
	  i = 0;
	  $readmemh("./rfinit.txt",myRegs);
	  myRegs[0]  = 16'd0;
	  rand = 16'h0000;
	  $random(0);
	end
	
	/******************************************************************************
	* Give our clocks a 4ns period, offset by 1ns
	******************************************************************************/
	always begin
	 #1 clk = ~clk;
	 #1 clk2 = ~clk2;
	end
	
	/******************************************************************************
	* We use clk2 to change the values passed to the register file so all values 
	* are stable on clk.  If clk is currently high, setup values we want when it 
	* transitions to low and vice-versa.  
	******************************************************************************/
	always @(clk2) begin
	  if(clk) begin
	    re0= 1'b1;
	    re1 = 1'b1;
	    we = 1'b0;
	    p0_addr = i;
	    p1_addr = i;
	  end else begin
	   re0 = 1'b0;
	   re1 = 1'b0;
	   we = 1'b1;
	   dst = rand;
	   dst_addr = i;
	  end
	end
	
	/******************************************************************************
	* Write to our comparison registers at the same time the register file will.
	******************************************************************************/
	always @(clk) begin
	  if(clk) begin
	   myRegs[i] = rand;
	  end
	end
	
	/******************************************************************************
	* Compare what is on p0 and p1 to what we have in our registers.  p0 and p1
	* will be stable on the negedge of clk2
	******************************************************************************/
	always @(negedge clk2) begin
	  if(p0 != myRegs[i] || p1 != myRegs[i]) begin
	   $display("ERROR!  Expecting: %h, P0: %h, P1: %h, i: %d", myRegs[i], p0, p1, i);
	   $stop;
	  end
	  rand =$random(rand);
	   
	  //if we haven't randomly updated all 15 registers, increment i to do the next one 
	  if(i < 16) i = i + 1;
	  else $stop; 
	end
	
endmodule