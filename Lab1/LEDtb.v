`include "LEDsystem.v"
`default_nettype none

module tb_LEDsystem;
reg clk;
reg rst_p;

wire an3, an2, an1, an0;
wire a, b, c, d, e, f;

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
	.f(f)
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
`default_nettype wire
