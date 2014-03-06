
module t_cpu();
  wire hlt;
  reg clk, rst_n;
  
  
  cpu CPU(hlt, clk, rst_n);
  
  always 
    #4 clk = ~clk;
    
  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    #8 rst_n = 1'b0;
    #8 rst_n = 1'b1;
    $stop;
  end
endmodule
