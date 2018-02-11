`default_nettype none

module tb_divider;

reg signed [31:0] dividend;
reg signed [15:0] divisor;

reg clk, reset;
reg valid_input, mode;

wire valid_output;
wire signed [16:0] final_output;

Div_mod_top_level divider_dut 
(
	.clk(clk) ,
	.reset(reset) ,
	.divisor(divisor),
	.dividend(dividend),
	.mode(mode),
	.valid_input(valid_input),
	.valid_output(valid_output),
	.final_output(final_output)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	clk = 1;
	mode = 1;
	reset = 1;
	#50;
	reset = 0;

	divisor = 16'd3;
	dividend = 32'd80;
end

endmodule
`default_nettype wire