module mux (a,b,sel,c);
	input [3:0] a,b;
	input sel;
	output [3:0] c;
	assign c = sel ? b : a;
endmodule