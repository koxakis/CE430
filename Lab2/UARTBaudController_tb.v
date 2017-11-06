`default_nettype none

module tb_UARTBaudController;
reg clk;
reg rst_n;

reg [2:0] baud_in;

wire mod_en;	
UARTBaudController uart_controller_0 
(
	.clk (clk),
	.reset (rst_n),
	.baud_select (baud_in),
	.sample_enable (mod_en)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial 
begin
	clk = 1;
	rst_n = 1;
	#10;

	rst_n = 0;
	baud_in = 3'b101;
	#1000;


end

endmodule
`default_nettype wire	