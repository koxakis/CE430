////////////////////////////////////////////////////
//Module : UART System
//File : UARTSystem.v
//Discreption : Top system module to connect transmitter and receiver in 
//					order to implement on a FPGA
////////////////////////////////////////////////////
module UARTSystem(
	clk,
	reset,
	Tx_DATA,
	Tx_WR,
	Rx_DATA,
	an0,
	an1,
	an2,
	an3,
	a,
	b,
	c,
	d,
	e,
	f,
	g,
	dp,
	r_btn
);

	input clk, reset;

	input r_btn;
	output an3, an2, an1, an0;
	output a, b, c, d, e, f, g, dp;


	input [7:0] Tx_DATA;
	output [7:0] Rx_DATA;

	wire [2:0] baud_select;
	wire Tx_EN,  Rx_EN; 
	input Tx_WR;

	wire Tx_BUSY;
	wire Tx_D;
	wire Rx_PERROR, Rx_FERROR, Rx_VALID;


	assign Tx_EN = 1;
	assign Rx_EN = 1;
	assign baud_select = 3'b111;

	UARTTransmeter uart_transmeter_0(
		.clk(clk) ,
		.reset(reset) ,
		.Tx_DATA(Tx_DATA) ,
		.baud_select(baud_select) ,
		.Tx_WR(Tx_WR) ,
		.Tx_EN(Tx_EN) ,
		.Tx_D(Tx_D) ,
		.Tx_BUSY(Tx_BUSY)
	);

	UARTReciver uart_reciver_0(
		.clk(clk) ,
		.reset(reset) ,
		.baud_select(baud_select) ,
		.Rx_EN(Rx_EN) ,
		.Rx_PERROR(Rx_PERROR) ,
		.Rx_FERROR(Rx_FERROR) ,
		.Rx_DATA(Rx_DATA) ,
		.Rx_VALID(Rx_VALID) ,
		.Rx_D (Tx_D)
	);

	LEDsystem led_system_0 (
		.reset(reset),
		.clk(clk),
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
		.dp(dp),
		.r_btn(r_btn)
	);

endmodule // UARTSystem