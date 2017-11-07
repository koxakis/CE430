module UARTSystem(
	clk,
	reset,
	Tx_DATA,
	baud_select,
	Tx_WR,
	Tx_EN,
	Tx_D,
	Tx_BUSY
);

	input clk, reset;

	input [7:0] Tx_DATA;
	input [2:0] baud_select;
	input Tx_EN, Tx_WR;

	output Tx_BUSY, Tx_D;

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

endmodule // UARTSystem