module MAC_control_unit(
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

	MAC_mac_unit mac_0(
		.clk(clk) ,
		.reset(reset) ,
		.in_1(in_1) ,
		.in_2(in_2) ,
		.in_add(in_add) ,
		.mode(mode),
		.mul_input_mux(mul_input_mux) ,
		.adder_input_mux(adder_input_mux) ,
		.mac_output(mac_output)
	);

endmodule // MAC_control_unit