module MAC_top_level(
	clk,
	reset,
	valid_inut,
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

	input valid_inut, last_input;
	input num_a, num_b, num_c, num_x;
	input mode;

	output valid_output;
	output final_output;

endmodule // MAC_top_level