module fa(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
	wire n1, n2, n3;

	xor(n1, a, b);
	xor(s, n1, cin);
	and(n2, n1, cin);
	and(n3, a, b);
	or(cout, n2, n3);

endmodule
