
module WB(writeData, readData, address, memToReg);
  input memToReg;
  input [15:0] readData, address;
  output writeData;
  
  assign writeData = (memToReg) ? readData : address;
  
endmodule
