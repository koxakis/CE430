module LEDstateDriver(
  state_in,
  char_out,
  an0_out,
  an1_out,
  an2_out,
  an3_out	
);

	input [3:0] state_in;
	
	output reg [3:0] char_out;
	output reg an3_out, an2_out, an1_out, an0_out;

	always @(state_in) begin
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

					char_out = 4'h0;
				end 

			4'b0010:
				begin
					an0_out = 0;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h1;
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

					char_out = 4'h0;
				end 
			4'b0110:
				begin
					an0_out = 1;
					an1_out = 0;
					an2_out = 1;
					an3_out = 1;

					char_out = 4'h1;

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

					char_out = 4'h0;
				end 
			4'b1010: 
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 0;
					an3_out = 1;

					char_out = 4'h7;
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

					char_out = 4'h0;
				end 
				
			4'b1110: 
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 0;

					char_out = 4'h1;
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