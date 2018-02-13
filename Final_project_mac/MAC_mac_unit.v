module MAC_mac_unit(
	clk,
	reset,
	in_1,
	in_2,
	in_add,
	//mode,
	mul_input_mux,
	adder_input_mux,
	mac_output
);

	input clk, reset;
	input signed [7:0] in_1, in_2; 
	input mul_input_mux, adder_input_mux;

	input signed [7:0] in_add;
	//input mode;

	//Due to carry-out and mull oporation the output is 17 bit 
	output signed [16:0] mac_output;

	reg signed [16:0] adder_out;
	wire signed [15:0] mul_out;
	reg signed [16:0] intermidiate_res;

	//output Select for output mux mode modes 1 for tri 0 for sump
	//assign mac_output = (mode) ? intermidiate_res : intermidiate_res ;
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