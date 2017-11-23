//LED state driver - takes the state and drives the corresponding anode output 
//Nikolaos Koxenoglou 1711 
`timescale 1ns / 1ps
module LEDstateDriver(
	clk,
	reset,
	state_in,
	char_out,
	an0_out,
	an1_out,
	an2_out,
	an3_out,
	r_btn,
	Rx_DATA
);

	input [3:0] state_in;
	input clk, reset;
	input r_btn;

	input [7:0] Rx_DATA;

	output reg [3:0] char_out;
	output reg an3_out, an2_out, an1_out, an0_out;

	wire [3:0] char_an0, char_an1, char_an2, char_an3;
	
	/*
	LEDsimulatedButton led_sim_btn_0(
		.clk(clk),
		.reset(reset),
		.char_an0(char_an0),
		.char_an1(char_an1),
		.char_an2(char_an2),
		.char_an3(char_an3)
	);*/
	LEDbtnRModule led_r_btn_0(
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

					//char_out = char_an0;
					char_out = Rx_DATA[3:0];

				end 
			4'b0001:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an0;
					char_out = Rx_DATA[3:0];

				end
			4'b0010:
				begin
					an0_out = 0;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an0;
					char_out = Rx_DATA[3:0];
				end 
			4'b0011:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an1;
					char_out = Rx_DATA[3:0];
				end 
			4'b0100:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an1;
					char_out = Rx_DATA[3:0];
				end 
			4'b0101:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an1;
					char_out = Rx_DATA[3:0];
				end 
			4'b0110:
				begin
					an0_out = 1;
					an1_out = 0;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an1;
					char_out = Rx_DATA[3:0];
				end
			4'b0111:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an2;
					char_out = Rx_DATA[7:4];
				end
			4'b1000:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an2;
					char_out = Rx_DATA[7:4];

				end 
			4'b1001:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an2;
					char_out = Rx_DATA[7:4];
				end 
			4'b1010: 
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 0;
					an3_out = 1;

					//char_out = char_an2;
					char_out = Rx_DATA[7:4];
				end
			4'b1011:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an3;
					char_out = Rx_DATA[7:4];
				end 
			4'b1100:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an3;
					char_out = Rx_DATA[7:4];
				end 
			4'b1101:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an3;
					char_out = Rx_DATA[7:4];
				end 
				
			4'b1110: 
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 0;

					//char_out = char_an3;
					char_out = Rx_DATA[7:4];
				end
			4'b1111:
				begin
					an0_out = 1;
					an1_out = 1;
					an2_out = 1;
					an3_out = 1;

					//char_out = char_an0;
					char_out = Rx_DATA[3:0];
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