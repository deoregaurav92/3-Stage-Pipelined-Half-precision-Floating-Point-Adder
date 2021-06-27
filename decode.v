module keypad_scan (clk, row , col, dec);

	input clk;
	input [3:0] col;
	output [3:0] row;
	output [3:0] dec;
	reg [3:0] row;
	reg [3:0] dec;

	reg [29:0] delay;

	always @ (posedge clk)
		begin
			delay <= delay + 1'b1;
			case(delay[20:18])
			3'b000 : row <= 4'b0111;
			3'b001 :
				begin
					if (col == 4'b0111)
						dec <= 4'h1; // 1
					if (col == 4'b1011)
						dec <= 4'h2; // 2
					if (col == 4'b1101)
						dec <= 4'h3; // 3
					if(col == 4'b1110)
						dec <= 4'hA; //A
				end
			3'b010 : row <= 4'b1011;
			3'b011 :
				begin
					if (col == 4'b0111)
						dec <= 4'h4; // 4
					if (col == 4'b1011)
						dec <= 4'h5; // 5
					if (col == 4'b1101)
						dec <= 4'h6; // 6
					if (col == 4'b1110)
						dec <= 4'hB; // B
				end
			3'b100 : row <= 4'b1101;
			3'b101 :
				begin
					if (col == 4'b0111)
						dec <= 4'h7; // 7
					if (col == 4'b1011)
						dec <= 4'h8; // 8
					if (col == 4'b1101)
						dec <= 4'h9; // 9
					if (col == 4'b1110)
						dec <= 4'hC; // C
				end
			3'b110 : row <= 4'b1110;
			3'b111 :
				begin
					if (col == 4'b0111)
						dec <= 4'hF; // F
					if (col == 4'b1011)
						dec <= 4'h0; // 0
					if (col == 4'b1101)
						dec <= 4'hE; // E
					if (col == 4'b1110)
						dec <= 4'hD; // D
				end
			endcase
	end
endmodule
