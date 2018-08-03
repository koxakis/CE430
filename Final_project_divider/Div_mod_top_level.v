////////////////////////////////////////////////////
//Module : Divider top module
//File : Div_mod_top_level.v
//Discreption : Top level module for divider
////////////////////////////////////////////////////
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

	wire signed [16:0] div_res;
	wire signed [15:0] mod_res;

	// Assign final output based on iput mode selection and valid output control signal 
	assign final_output = (valid_output) ? ((mode) ? div_res : mod_res) : 'b0;

	interconect_cells connected_cells 
	(
		.clk(clk) ,
		.reset(reset) ,
		.in_divisor(divisor),
		.in_dividend(dividend),
		.valid_input(valid_input),
		.valid_output(valid_output),
		.mod_res(mod_res),
		.div_res_tmp(div_res)
	);


endmodule // Div_mod_top_level