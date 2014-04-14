/*******************************************************************************
* ECE 552
* WISC architecture
* Simple program counter with asynchronous reset and increment by 1
*
* Craig Day
*******************************************************************************/
module PC(pc, hlt, clk, rst_n, PCSrc, bAddress, takeJump, jAddress);
  input rst_n, hlt, clk, PCSrc, takeJump;
  input [15:0] bAddress, jAddress;
  output reg [15:0] pc;
  wire [15:0] nextPC, temp;
  
  //pc source mux, used for branching
  //assign temp = (PCSrc == 1'b1) ? target : pc + 1; 
  
  assign nextPC = (takeJump == 1'b1) ? jAddress : (PCSrc == 1'b1) ? bAddress : pc + 1;
  
  //at the posedge of clk, reset the pc if rst_n is low, otherwise
  //grab the next value from the hlt mux
  always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
      pc <= 16'd0;
    end else begin
      if(hlt) pc <= pc;
      else pc <= nextPC;
    end
  end
  
endmodule
  