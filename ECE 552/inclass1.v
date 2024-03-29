`timescale 1ns/1ns
module inclass1(en, out);
	input en;
	output out;
	wire n1, n2;

	nand #5 (n1, en, out);
	not #5 (n2, n1);
	not #5 (out, n2);

endmodule

module t_inclass1();
	reg enable;
	wire out;

	inclass1 DUT(enable, out);

	initial begin
		enable <= 1'b0;
		#15 enable <= 1'b1;
		#60 $stop;

	end
endmodule
