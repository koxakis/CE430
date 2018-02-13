module MAC_top_level(
	clk,
	reset,
	valid_input,
	valid_output,
	last_input,
	num_a,
	num_b,
	num_c,
	num_x,
	final_output,
	mode
);
	input clk, reset;

	input valid_input, last_input;
	input signed [7:0] num_a, num_b, num_c, num_x;
	input mode;

	output valid_output;
	output signed [24:0] final_output;

	MAC_control_unit control_unit_trinomial_sump_0(
		.clk(clk) ,
		.reset(reset) ,
		.valid_input(valid_input) ,
		.valid_output(valid_output) ,
		.last_input(last_input) ,
		.num_a(num_a) ,
		.num_b(num_b) ,
		.num_c(num_c) ,
		.num_x(num_x) ,
		.final_output(final_output) ,
		.mode(mode)
	);

endmodule // MAC_top_level