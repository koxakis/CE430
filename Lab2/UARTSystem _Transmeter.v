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
	Tx_D,
	Tx_BUSY
);

	input clk, reset;

	input [7:0] Tx_DATA;

	wire [2:0] baud_select;
	wire Tx_EN; 
	input Tx_WR;

	output Tx_BUSY;
	output Tx_D;

	assign Tx_EN = 1;
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

endmodule // UARTSystem