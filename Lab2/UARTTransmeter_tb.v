`default_nettype none

module UARTTransmeter_tb;
reg clk;
reg rst_n;

reg [2:0] baud_in;

reg [7:0] Tx_DATA;
reg Tx_EN, Tx_WR;

wire Tx_BUSY, Tx_D;

UARTSystem uart_system_0(
	.clk(clk) ,
	.reset(rst_n) ,
	.Tx_DATA(Tx_DATA) ,
	.baud_select(baud_in) ,
	.Tx_WR(Tx_WR) ,
	.Tx_EN(Tx_EN) ,
	.Tx_D(Tx_D) ,
	.Tx_BUSY(Tx_BUSY)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial 
begin
	clk = 1;
	Tx_DATA = 8'b01010101;
	Tx_EN = 0;
	Tx_WR = 0;
	rst_n = 1;
	#10;
	rst_n = 0;
	#10;
	baud_in = 3'b111;
	Tx_EN = 1;
	
	#100;

	Tx_WR = 1;


	#100000;

	Tx_WR = 0;


end

endmodule
`default_nettype wire	