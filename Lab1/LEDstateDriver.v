module LEDstateDriver(
	clk,
	reset,
	state_in,
	r_btn,
	char_out,
	an0_out,
	an1_out,
	an2_out,
	an3_out	
);

	input [3:0] state_in;
	input r_btn, clk, reset;
	
	output reg [3:0] char_out;
	output reg an3_out, an2_out, an1_out, an0_out;

	wire [3:0] char_an0, char_an1, char_an2, char_an3;

	LEDbtnRModule ledbtn_0(
		.clk(clk),
		.reset(reset),
		.r_btn(r_btn),
		.char_an0(char_an0),
		.char_an1(char_an1),
		.char_an2(char_an2),
		.char_an3(char_an3)
	);

	// Change the char assignment state to two cycles before the respected ANn
	always @ ( state_in or char_an0 or char_an1 or char_an2 or char_an3) 
	begin
		case (state_in)

			4'b0000:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;
				end 

			4'b0001:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = char_an0;
				end 

			4'b0010:
				begin
					an0_out = 0;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = char_an0;
				end 

			4'b0011:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;
				end 
			4'b0100:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;
				end 
			4'b0101:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = char_an1;
				end 
			4'b0110:
				begin
					an0_out = 1;
					an1_out = 0;
					an2_out = 1;
					an3_out = 1;

					char_out = char_an1;

				end
			4'b0111:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;

				end
			4'b1000:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;
				end 
			4'b1001:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = char_an2;
				end 
			4'b1010: 
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 0;
					an3_out = 1;

					char_out = char_an2;
				end
			4'b1011:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;
				end 
			4'b1100:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;
				end 
			4'b1101:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = char_an3;
				end 
				
			4'b1110: 
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 0;

					char_out = char_an3;
				end
			4'b1111:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h0;
				end 
			default:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;
				end
		endcase
   end 
	

endmodule // LEDstateDriver