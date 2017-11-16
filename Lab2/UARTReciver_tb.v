`include "UARTReciver.v"
`default_nettype none

module UARTReciver_tb;
reg clk;
reg rst_n;

reg [2:0] baud_in;
reg Rx_D;
reg Rx_EN;

wire Rx_PERROR, Rx_FERROR, Rx_VALID;

wire [7:0] Rx_DATA;

UARTReciver uart_reciver_0(
	.clk(clk) ,
	.reset(rst_n) ,
	.baud_select(baud_in) ,
	.Rx_EN(Rx_EN) ,
	.Rx_PERROR(Rx_PERROR) ,
	.Rx_FERROR(Rx_FERROR) ,
	.Rx_DATA(Rx_DATA) ,
	.Rx_VALID(Rx_VALID) ,
	.Rx_D (Rx_D)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	clk = 1;
	Rx_EN = 0;
	Rx_D = 1;

	rst_n = 1;
	#20
	rst_n = 0;
	#100
	baud_in = 3'b111;
	#100
	Rx_EN = 1;
	//1 0 10101010 0
	Rx_D = 0; //start  
	#4480
	Rx_D = 0;   
	#4480
	Rx_D = 1;   
	#4480
	Rx_D = 0;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 0;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 0;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 1; //parity  
	#4480
		Rx_D = 1; //stop  
	#(4480 *5)

	//1 1 11111011 0
	Rx_D = 0;   
	#4480
	Rx_D = 1;   
	#4480
	Rx_D = 1;   
	#4480
	Rx_D = 0;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 1;   
	#4480
		Rx_D = 1; 
	#(4480 *5)
	
	$finish;

end

endmodule
`default_nettype wire