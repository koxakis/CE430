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
	wire [16:0] mac_output;

	reg mul_input_mux, adder_input_mux;
	reg [7:0] in_1, in_2, in_add;

	//Trinomial states
	parameter IDLE = 2'b00;
	parameter MUL_WITH_INPUT = 2'b01;
	parameter MUL_WITH_REG = 2'b10;
	parameter OUTPUT_FINAL = 2'b11;

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
	assign final_output = (valid_output) ? mac_output : 'b0;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			tri_state_counter <= 'b0;
		end else begin
			if (!last_input) begin
				tri_state_counter <= 'b0;
			end else begin
				tri_state_counter <= tri_state_counter + 1'b1;
				if (tri_state_counter == 6) begin
					tri_state_counter <= 'b0;
				end
			end
		end
	end

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
		end else begin
			case (tri_state)
				IDLE:
				begin
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
				begin
					in_add <= num_c;
					mul_input_mux <= 1'b1;
					tri_state_counter <= tri_state_counter + 1'b1;
					if (tri_state_counter == 4) begin
						tri_state_counter <= 'b0;
						valid_output <= 1'b1;
						tri_state <= IDLE;
					end
				end
				OUTPUT_FINAL:
				begin
				end
				default: 
				begin
				end
			endcase			
		end
	end


endmodule // MAC_control_unit