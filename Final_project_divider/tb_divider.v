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
	valid_input = 1'b0;
	#50;
	reset = 0;

	valid_input = 1'b1;
	dividend = 32'd80;
	divisor = -16'd3;
end

endmodule
`default_nettype wire