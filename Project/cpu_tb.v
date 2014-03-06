
module t_cpu();
  
  reg hlt, clk, rst_n;
  
  
  cpu CPU(hlt, clk, rst_n);
  
  always 
    #4 clk = ~clk;
    
  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    hlt = 1'b0;
    #8 rst_n = 1'b0;
    #8 rst_n = 1'b1;
    #100 hlt = 1'b1;
    $stop;
  end
endmodule