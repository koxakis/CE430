//Testbench module 
//Nikolaos Koxenoglou 1711 
`default_nettype none
`timescale 1ns/ 1ps 
module tb_LEDsystem;
reg clk;
reg rst_p;

wire an3, an2, an1, an0;
wire a, b, c, d, e, f, g, dp;

LEDsystem sys0
(
	.reset (rst_p),
	.clk (clk),
	.an3(an3),
	.an2(an2),
	.an1(an1),
	.an0(an0),
	.a(a),
	.b(b),
	.c(c),
	.d(d),
	.e(e),
	.f(f),
	.g(g),
	.dp(dp)
);

always #10 clk=~clk;
	
initial begin
	rst_p = 1'b1;
	clk = 1'b1;
	#10
	rst_p = 1'b0;

	#1000
	$finish;

end

endmodule

