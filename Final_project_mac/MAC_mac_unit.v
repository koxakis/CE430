////////////////////////////////////////////////////
//Module : Multiplier / Accumulator
//File : MAC_mac_unit.v
//Discreption : Multiplies and accumulates three inputs 
////////////////////////////////////////////////////
module MAC_mac_unit(
	clk,
	reset,
	in_1,
	in_2,
	in_add,
	mul_input_mux,
	adder_input_mux,
	mac_output
);

	input clk, reset;
	input signed [7:0] in_1, in_2; 
	input mul_input_mux, adder_input_mux;

	input signed [7:0] in_add;

	//Due to carry-out and mull oporation the output is 25 bit 
	output signed [24:0] mac_output;

	reg signed [24:0] adder_out;
	wire signed [23:0] mul_out;
	reg signed [24:0] intermidiate_res;

	//Assign mac_output as the value of the register 
	assign mac_output = intermidiate_res;

	//Do the mul with out delay 
	//Input Select for mul Mux modes 1 for reg 0 for in_1
	assign mul_out = in_2 * ( (mul_input_mux) ? intermidiate_res : in_1);

	always @(posedge clk or posedge reset) begin
		if(reset) begin
			adder_out <= 'b0;
			intermidiate_res <= 'b0;
		end	else begin
			//input Select for adder mux modes 1 for reg 0 for in_add
			adder_out <= mul_out + ((adder_input_mux) ? intermidiate_res :  in_add);
			intermidiate_res <= adder_out;
		end
	end
endmodule // MAC_mac_unit