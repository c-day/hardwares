/*******************************************************************************
* ECE 552
* WISC architecture
* Simple program counter with synchronous reset and increment by 1
*
* Craig Day
*******************************************************************************/
module PC(pc, hlt, clk, rst_n);
  input rst_n, hlt, clk;
  output reg [15:0] pc;
  wire temp;
  
  //read the hlt signal, if halted maintain pc, otherwise increment
  assign temp = (hlt) ? pc : pc + 1;
  
  //at the posedge of clk, reset the pc if rst_n is low, otherwise
  //grab the next value from the hlt mux
  always @(posedge clk, rst_n) begin
    if(~rst_n) begin
      pc <= 16'd0;
    end else begin
      pc <= temp;
    end
  end
  
endmodule
  