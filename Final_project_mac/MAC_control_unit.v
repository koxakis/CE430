module MAC_control_unit(
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
	input [7:0] num_a, num_b, num_c, num_x;
	input mode;

	output reg valid_output;
	output [16:0] final_output;

	reg [1:0] tri_state;
	reg [2:0] tri_state_counter;

	reg sump_state;
	reg [1:0] sump_state_counter;
	wire [16:0] mac_output;

	reg mul_input_mux, adder_input_mux;
	reg [7:0] in_1, in_2, in_add;

	//Trinomial states
	//Wait for valid and last input
	parameter IDLE_TRI = 2'b00;
	/*Multiply with the input from the control unit a and x 
		and add with third in_add number b
		1st step of the culculation (a*x) + b = r*/
	parameter MUL_WITH_INPUT = 2'b01;
	/*Multiply with the input from the register r and x 
		and add with third in_add number c
		2nd step of the culculation (r*x) + c */
	parameter MUL_WITH_REG = 2'b10;

	//SUMP states
	/*Wait for valid and last input that indicates these are the last 2
		inputs unitl the next ones x1 a1 then x2 a2*/
	parameter IDLE_SUM = 0;
	// Do the culculation (a*x) + (previous (a*x))
	parameter CULCULATE = 1;

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

	//Valid output is 1 the output is redirected to the final out
	assign final_output = (valid_output) ? mac_output : 17'b0;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			tri_state <= 'b0;
			valid_output <= 'b0;
			mul_input_mux <= 1'b0;
			adder_input_mux <= 1'b0;
			in_1 <= 'b0;
			in_2 <= 'b0;
			in_add <= 'b0;
			tri_state_counter <= 'b0;
			sump_state <= 'b0;
			sump_state_counter <= 'b0;
		end else begin
			if (mode) begin
				case (tri_state)
					IDLE_TRI:
					begin
					//Wait for input from higher level
						valid_output <= 1'b0;
						mul_input_mux <= 1'b0;
						tri_state_counter <= tri_state_counter + 1'b1;
						if ((last_input) && (valid_input) ) begin
							in_1 <= num_a;
							in_2 <= num_x;
							in_add <= num_b;
							tri_state <= MUL_WITH_INPUT;
						end
					end
					MUL_WITH_INPUT:
					//Multiply with the first three inputs of the trinomial a*x+b
					begin
						in_1 <= num_a;
						in_2 <= num_x;
						in_add <= num_b;
						mul_input_mux <= 1'b0;
						adder_input_mux <= 1'b0;
						tri_state_counter <= tri_state_counter + 1'b1;
						if ((tri_state_counter == 1) ) begin
							tri_state <= MUL_WITH_REG;
						end 
					end
					MUL_WITH_REG:
					//Multiply with the first three inputs of the trinomial r*x+c
					begin
						in_add <= num_c;
						mul_input_mux <= 1'b1;
						tri_state_counter <= tri_state_counter + 1'b1;
						if (tri_state_counter == 3) begin
							tri_state_counter <= 'b0;
							valid_output <= 1'b1;
							tri_state <= IDLE_TRI;
						end
					end
					default: 
					begin
					end
				endcase	
			end else begin
				case (sump_state)
					IDLE_SUM:
					begin
						valid_output <= 1'b0;
						mul_input_mux <= 1'b0;
						adder_input_mux <= 1'b1;
						if ((valid_input) && (last_input)) begin
							in_1 <= num_a;
							in_2 <= num_x;
							sump_state <= CULCULATE;
						end
					end 
					CULCULATE:
					begin
						in_1 <= num_a;
						in_2 <= num_x;
						sump_state_counter <= sump_state_counter + 1'b1;
						if (sump_state_counter == 1) begin
							valid_output <= 1'b1;
							sump_state_counter <= 0;
							sump_state <= IDLE_SUM;
						end
					end
					default: 
					begin
					end
				endcase
			end		
		end
	end


endmodule // MAC_control_unit