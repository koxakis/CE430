////////////////////////////////////////////////////
//Module : CAS unit
//File : div_cell.v
//Discreption : Controlled add subtrack module 
////////////////////////////////////////////////////
module div_cell(
	T_in,
	Divisor_in,
	Remainder_in,
	Remainder_out,
	C_in,
	C_out
);

	input T_in, Divisor_in, Remainder_in, C_in;

	output Remainder_out, C_out;

	//Output for curry
	assign C_out = Remainder_in & C_in | (Divisor_in ^ T_in)&(Remainder_in | C_in) ;

	//Output for full adder 
	assign Remainder_out = Remainder_in ^ C_in ^ (Divisor_in ^ T_in);

endmodule // div_cell