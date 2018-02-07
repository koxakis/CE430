module div_cell(
	clk,
	reset,
	T_in,
	Divisor_in,
	Remainder_in,
	Remainder_out,
	C_in,
	C_out
);


	input clk, reset;

	input T_in, Divisor_in, Remainder_in, C_in;

	output Remainder_out, C_out;

	//Outputs 
	assign C_out = Remainder_in & C_in | (Divisor_in ^ T_in)&(Remainder_in | C_in) ;

	assign Remainder_out = Remainder_in ^ C_in ^ (Divisor_in ^ T_in);



endmodule // div_cell