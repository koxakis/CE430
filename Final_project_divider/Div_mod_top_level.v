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

	input [31:0] dividend;
	input [15:0] divisor;

	input clk, reset;
	input valid_input;

	output valid_output;
	output [16:0] final_output;

endmodule // Div_mod_top_level