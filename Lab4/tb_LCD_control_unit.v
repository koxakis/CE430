`default_nettype none

module tb_LCD_control_unit;
reg clk;
reg reset;
wire LCD_RS;
wire LCD_RW;
wire LCD_EN;
wire [3:0] LCD_SF_D; 

LCD_control_unit dut_LCD_control_inst(
	.clk(clk) ,
	.reset(reset) ,
	.LCD_RS(LCD_RS) ,
	.LCD_RW(LCD_RW) ,
	.LCD_EN(LCD_EN) ,
	.LCD_SF_D(LCD_SF_D)
);

localparam CLK_PERIOD = 20;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	clk = 1'b1;
	reset = 1'b1;
	#200
	reset = 1'b0;

end

endmodule
`default_nettype wire