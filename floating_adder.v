module HP_FP_Pipelined_Adder ( //Floating point adder
	input clk,
	input [15:0] in1,
	input [15:0] in2,
	input enable,

	output reg done,
	output [15:0] sum
);

	parameter [2:0]			S0 = 3'b000,
							S1 = 3'b001,
							S2 = 3'b011,
							S3 = 3'b010,
							S4 = 3'b110,
							S5 = 3'b111,
							S6 = 3'b101,
							S7 = 3'b100;

	reg Sg1, Sg2; //Sign bits
	reg overflow, underflow;
	reg [2:0] cur_state;
	reg [4:0] E1, E2; //Exponent's 1 and 2
	reg [12:0] M1, M2; //Mantissa's 1 and 2

	wire fv, fu;
	wire [14:0] M1comp, M2comp;
	wire [14:0] addout, fsum;

	initial begin
		cur_state = S0;
		done = 1'b0;
		overflow = 1'b0;
		underflow = 1'b0;
		Sg1 = 1'b0;
		Sg2 = 1'b0;
		M1 = 13'b0;
		M2 = 13'b0;
		E1 = 5'b0;
		E2 = 5'b0;
	end

	assign M1comp = (Sg1 == 1'b1) ? ~({2'b00, M1}) + 1 : {2'b00, M1} ; //Alternate btwn compliment and reg mantissa depending on sign of input 1
	assign M2comp = (Sg2 == 1'b1) ? ~({2'b00, M2}) + 1 : {2'b00, M2} ; //Alternate btwn compliment and reg mantissa depending on sign of input 2

	assign addout = M1comp + M2comp; //Sum of 2 inputs
	assign fsum = (addout[14] == 1'b0) ? addout : ~addout + 1;

	assign fv = fsum[14] ^ fsum[13];
	assign fu = ~M1[12];
	assign sum = {Sg1, E1, M1[11:2]}; //Final sum

	always @ (posedge clk) begin

		case (cur_state)

			S0: begin //Process first 16-bit input

				if (enable == 1'b1) begin

					E1 <= in1[14:10];
					Sg1 <= in1[15];
					M1[11:0] <= {in1[9:0], 2'b00};

					if (in1 == 0) M1[12] <= 1'b0;

					else M1[12] <= 1'b1;

					done <= 1'b0;
					overflow <= 1'b0;
					underflow <= 1'b0;
					cur_state <= S1;
				end

			end

			S1: begin //Process second 16-bit input

				E2 <= in2[14:10];
				Sg2 <= in2[15];
				M2[11:0] <= {in2[9:0], 2'b00};

				if (in2 == 0) M2[12] <= 1'b0;

				else M2[12] <= 1'b1;

				cur_state <= S2;

			end

			S2: begin //Recursively shift inputs until their exponents match

				if ((M1 == 0) || (M2 == 0)) cur_state <= S3;

				else begin

					if (E1 == E2) cur_state <= S3;

					else if (E1 < E2) begin //Right shift first mantissa if exponent is less than second
						M1 <= {1'b0, M1[12:1]};
						E1 <= E1 + 1;
					end

					else if (E2 < E1) begin //Right shift first mantissa if exponent is less than second
						M2 <= {1'b0, M2[12:1]};
						E2 <= E2 + 1;
					end

				end

			end

			S3: begin

				Sg1 <= addout[14];

				if (fv == 1'b0) M1 <= fsum[12:0];

				else begin
					M1 <= fsum[13:1];
					E1 <= E1 + 1;
				end

				cur_state <= S4;

			end

			S4: begin //Determine is sum is a whole number

				if (M1 == 0) begin
					E1 <= 8'h00;
					cur_state = S6;
				end

				else cur_state <= S5;

			end

			S5: begin

				if (E1 == 0) begin
					underflow <= 1'b1;
					cur_state <= S6;
				end

				else if (fu == 1'b0) cur_state <= S6;

				else begin
					M1 <= {M1[11:0], 1'b0};
					E1 <= E1 - 1;
				end

			end

			S6: begin

				if (E1 == 31) overflow <= 1'b1;

				done <= 1'b1;
				cur_state <= S0;

			end

		endcase

	end

endmodule
