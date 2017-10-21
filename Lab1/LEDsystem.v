`timescale 1ns / 1ps

module LEDsystem(
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

input reset, clk,r_btn;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;

//Implemet debouncer for inputs

//Pass debouncer through pulse generator  


LEDfourDigitDriver LEDdriver_0(
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



endmodule // LEDsystem