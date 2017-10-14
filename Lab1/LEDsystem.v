`timescale 1ns / 1ps

module LEDsystem(
	reset,
	clk,
	an3,
	an2,
	an1,
	an0,
	a,
	b,
	c,
	d,
	e,
	f	
);

input reset, clk;
output an3, an2, an1, an0;
output a, b, c, d, e, f;


LEDfourDigitDriver LEDdriver_0(
	reset,
	clk,
	an3,
	an2,
	an1,
	an0,
	a,
	b,
	c,
	d,
	e,
	f	
);



endmodule // LEDsystem