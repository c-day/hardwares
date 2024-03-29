/*******************************************************************************
* ECE 552
* HW 2, Problem 3
* Authors:
* Ethan Massey
*******************************************************************************/

module rf(clk,p0_addr,p1_addr,p0,p1,re0,re1,dst_addr,dst,we,hlt);

input clk;
input [3:0] p0_addr, p1_addr;			
input re0,re1;							
input [3:0] dst_addr;					
input [15:0] dst;						
input we;							
input hlt;								

output reg [15:0] p0,p1;  				

// looping variable used when dumping memory
integer indx;

// the "array" that will represent the 16 registers
reg [15:0]mem[0:15];

// intermediate registers to store the values provided as input
reg [3:0] dst_addr_lat;				
reg [15:0] dst_lat;				
reg we_lat;							

/******************************************************************************
* go to the file rfinit.txt and readin all of the values to initialize
* the registers (represented by the array mem)
******************************************************************************/
initial begin
  $readmemh("./rfinit.txt",mem);
  mem[0] = 16'h0000;	
end

/******************************************************************************
* At every clock edge or change of dst_addr, dst, we, if the clock is low,
* save the values of all three into a local to be used within the module
******************************************************************************/
always @(clk,dst_addr,dst,we)
  if (~clk)
    begin
	  dst_addr_lat <= dst_addr;
	  dst_lat      <= dst;
	  we_lat       <= we;
	end

/******************************************************************************
* If clk is high and we, dst_addr, dst were changed to high, store dst into
* the register at mem[dst_addr]
******************************************************************************/
always @(clk,we_lat,dst_addr_lat,dst_lat)
  if (clk && we_lat && |dst_addr_lat)
    mem[dst_addr_lat] <= dst_lat;
	
/******************************************************************************
* If the clock is low and we want to read on port 0, take the value from reg
* represented at p0_addr and put it onto port 0
******************************************************************************/
always @(clk,re0,p0_addr)
  if (~clk && re0)
    p0 <= mem[p0_addr];
	
/******************************************************************************
* If the clock is low and we want to read on port 1, take the vlue from reg
* stored at p1_addr and put it onto port 1
******************************************************************************/
always @(clk,re1,p1_addr)
  if (~clk && re1)
    p1 <= mem[p1_addr];
	
/******************************************************************************
* If halt ever goes high, display the contents of all of the registers
******************************************************************************/
always @(posedge hlt)
  for(indx=1; indx<16; indx = indx+1)
    $display("R%1h = %h",indx,mem[indx]);
	
endmodule
  

