module seven_seg_display (DisVal, SegOut);

   input [3:0] DisVal;
	output [7:0] SegOut;


	reg [7:0] SegOut;

	always @ (DisVal)

	begin

		case(DisVal)

		4'h0 : SegOut = 8'b11000000;  	// 0
		4'h1 : SegOut = 8'b11111001;  	// 1
		4'h2 : SegOut = 8'b10100100;  	// 2
		4'h3 : SegOut = 8'b10110000;  	// 3
		4'h4 : SegOut = 8'b10011001;  	// 4
		4'h5 : SegOut = 8'b10010010;  	// 5
		4'h6 : SegOut = 8'b10000010;  	// 6
		4'h7 : SegOut = 8'b11111000;  	// 7
		4'h8 : SegOut = 8'b10000000;  	// 8
		4'h9 : SegOut = 8'b10010000;  	// 9
		4'hA : SegOut = 8'b10001000;  	// A
		4'hB : SegOut = 8'b10000011;	 // B
		4'hC : SegOut = 8'b11000110;	 // C
		4'hD : SegOut = 8'b10100001;	 // D
		4'hE : SegOut = 8'b10000110;	 // E
		4'hF : SegOut = 8'b10001110;	 // F
		default : SegOut = 8'b10111111;

		endcase
	end
endmodule
