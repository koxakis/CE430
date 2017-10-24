//LED Driver module - Drives the state counter with the divided clock 
//Nikolaos Koxenoglou 1711 
`timescale 1ns / 1ps
module LEDfourDigitDriver(
	reset,
	clk,
	r_btn,
	an3,
	an2,
	an1,
	an0,
	a,
	b,
	c,
	d,
	e,
	f,
	g,
	dp	
);

input reset, clk, r_btn;
output wire an3, an2, an1, an0;
output wire a, b, c, d, e, f, g, dp;

wire [3:0] char;
reg [3:0] state;
wire [7:0] LED;

wire an3_out, an2_out, an1_out, an0_out;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
		  state <= 4'b1111;
		end else begin
		  state <= state - 1'b1;
		end
	end

	LEDdecoder leddecoder_0(
		.char(char),
		.LED(LED)
	);

	assign a = LED[7];
	assign b = LED[6];
	assign c = LED[5];
	assign d = LED[4];
	assign e = LED[3];
	assign f = LED[2];
	assign g = LED[1];
	assign dp = LED[0]; 
   
	LEDstateDriver ledStateDriver_0(
		.clk(clk),
		.reset(reset),
		.state_in(state),
		.r_btn(r_btn),
		.char_out(char),
		.an0_out(an0),
		.an1_out(an1),
		.an2_out(an2),
		.an3_out(an3)
	);

endmodule // LEDfourDigitDriver