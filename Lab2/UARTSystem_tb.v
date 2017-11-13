`default_nettype none

module UARTSystem_tb;
reg clk;
reg rst_n;

reg [2:0] baud_in;

reg [7:0] Tx_DATA;
reg Tx_EN, Tx_WR;

reg Rx_EN;

wire Rx_PERROR, Rx_FERROR, Rx_VALID;

wire [7:0] Rx_DATA;

wire Tx_BUSY, Tx_D;

UARTTransmeter uart_transmeter_0(
	.clk(clk) ,
	.reset(rst_n) ,
	.Tx_DATA(Tx_DATA) ,
	.baud_select(baud_in) ,
	.Tx_WR(Tx_WR) ,
	.Tx_EN(Tx_EN) ,
	.Tx_D(Tx_D) ,
	.Tx_BUSY(Tx_BUSY)
);

UARTReciver uart_reciver_0(
	.clk(clk) ,
	.reset(rst_n) ,
	.baud_select(baud_in) ,
	.Rx_EN(Rx_EN) ,
	.Rx_PERROR(Rx_PERROR) ,
	.Rx_FERROR(Rx_FERROR) ,
	.Rx_DATA(Rx_DATA) ,
	.Rx_VALID(Rx_VALID) ,
	.Rx_D (Tx_D)
);


localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial 
begin
	clk = 1;
	Tx_DATA = 8'b01010101;
	Tx_EN = 0;
	Rx_EN = 0;
	Tx_WR = 0;
	rst_n = 1;
	#10;
	rst_n = 0;
	#10;
	baud_in = 3'b111;
	Tx_EN = 1;
	Rx_EN = 1;
	
	#100;

	Tx_WR = 1;


	#100000;

	Tx_WR = 0;


end

endmodule
`default_nettype wire	