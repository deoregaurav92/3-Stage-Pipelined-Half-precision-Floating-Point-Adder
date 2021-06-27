module main (clk,row,col,seg1,seg2,seg3,seg4,rst,s1,s2,s3,sw,enable,done,count);

	input enable;
	output done;
	input [3:0] sw;
	input rst,s1,s2,s3;
	input clk;
	input [3:0] col;
	output [3:0] row;
	output reg [7:0] seg1;
	output reg [7:0] seg2;
	output reg [7:0] seg3;
	output reg [7:0] seg4;
	output reg [1:0] count;
	wire [7:0] sego_2,sego_3,sego_4,sego_1;
	wire [7:0] seg;
	wire [3:0] decoded_in;
	wire [3:0] decoded_mux;
	wire [15:0] numA;
	wire [15:0] numB;
	wire [15:0] numC;
	wire sel;
	wire enable,done;
	reg [15:0] tmpA;
	reg [15:0] tmpB;
	reg [3:0] decoded_out;
	wire [15:0]sumC;
	assign numA = tmpA;
	assign numB = tmpB;
	assign sel = 0;
	seven_seg_display D0(decoded1,sego_1);
	seven_seg_display D3(decoded2,sego_2);
	seven_seg_display D4(decoded3,sego_3);
	seven_seg_display D5(decoded4,sego_4);
	seven_seg_display D (decoded_mux,seg);

	keypad_scan S (clk, row, col ,decoded_in);
	HP_FP_Pipelined_Adder F1(clk,numA,numB,enable,done,numC);
	mux M1 (decoded_in,decoded_out,sel,decoded_mux);

	reg [3:0] decoded1,decoded2,decoded3,decoded4;
	always @ (posedge clk)
	begin

	if({rst,s1,s2,s3} == 4'b1000)
		begin
						count = 2'b00;
						{seg4,seg3,seg2,seg1} = {4{8'b11000000}};
						tmpA = 0;
						tmpB = 0;
		end
	if({rst,s1,s2,s3} == 4'b0100)
		begin
					count = 2'b01;
					if (sw==4'b0001) begin
							seg1 = seg;
							tmpA[3:0] = decoded_in;
							end
					if (sw == 4'b0010) begin
							seg2 = seg;
							tmpA[7:4] = decoded_in;
							end
					if (sw == 4'b0100) begin
							seg3 = seg;
							tmpA[11:8] = decoded_in;
							end
					if (sw == 4'b1000) begin
							seg4 = seg;
							tmpA[15:12] = decoded_in;
							end
		end

	if({rst,s1,s2,s3} == 4'b0010)
		 begin
					count = 2'b10;
					if (sw==4'b0001) begin
							seg1 = seg;
							tmpB[3:0] = decoded_in;
							end
					if (sw == 4'b0010) begin
							seg2 = seg;
							tmpB[7:4] = decoded_in;
							end
					if (sw == 4'b0100) begin
							seg3 = seg;
							tmpB[11:8] = decoded_in;
							end
					if (sw == 4'b1000) begin
							seg4 = seg;
							tmpB[15:12] = decoded_in;
							end
		end
	if({rst,s1,s2,s3} == 4'b0001)
		begin
							count = 2'b11;
							decoded1 = numC[3:0];
							seg1 = sego_1;
							decoded2 = numC[7:4];
							seg2 = sego_2;
							decoded3 = numC[11:8];
							seg3 = sego_3;
							decoded4 = numC[15:12];
							seg4 = sego_4;
		end
	end
	endmodule
