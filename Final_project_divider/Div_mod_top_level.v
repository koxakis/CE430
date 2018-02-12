module Div_mod_top_level(
	clk,
	reset,
	divisor,
	dividend,
	mode,
	valid_input,
	valid_output,
	final_output
);

	input signed [31:0] dividend;
	input signed [15:0] divisor;

	input clk, reset;
	input valid_input, mode;

	output valid_output;
	output signed [16:0] final_output;

	interconect_cells connected_cells 
	(
		.clk(clk) ,
		.reset(reset) ,
		.in_divisor(divisor),
		.in_dividend(dividend),
		.mode(mode),
		.valid_input(valid_input),
		.valid_output(valid_output),
		.final_output(final_output)
	);


endmodule // Div_mod_top_level