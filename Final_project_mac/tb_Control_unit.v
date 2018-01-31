`timescale 1ns/1ps

module tb_Control_unit;
reg clk;
reg reset;

reg [7:0] num_a_in, num_b_in, num_c_in, num_x_in;
reg [7:0] num_a, num_x, num_b, num_c;
reg valid_input, last_input;

wire valid_output;

wire [16:0] final_output;

reg mode;
reg [16:0] check_tri;

reg [7:0] num_a_test [2:0];
reg [7:0] num_x_test [2:0];
reg [7:0] num_b_test [2:0];
reg [7:0] num_c_test [2:0];

reg [1:0] tri_test_inputs;

reg test_mode;

parameter TEST_TRI = 1'b0;
parameter TEST_SUMP = 1'b1;

MAC_top_level MAC_top_level_0(
	.clk(clk) ,
	.reset(reset) ,
	.valid_input(valid_input) ,
	.valid_output(valid_output) ,
	.last_input(last_input) ,
	.num_a(num_a_in) ,
	.num_b(num_b_in) ,
	.num_c(num_c_in) ,
	.num_x(num_x_in) ,
	.final_output(final_output) ,
	.mode(mode)
);
//Trinomial ideal unit
always @ (posedge clk or posedge reset) begin
	if (reset) begin
		check_tri <= 1'b0;
	end else begin
		//(a*x + b)*x+c
		//(in_1*in_2 + in_add)*in_2 + in_add
		check_tri <= (((num_a*num_x) + num_b)*num_x) + num_c;
	end
end
//Trinomial checker
always @(posedge clk or posedge reset) begin
	if (check_tri == final_output) begin
		$display ("Success\n");
		$display("\t%d,\t%d,\t%d,\t%d,\t%d,\t%d", num_a, num_x, num_b, num_c, final_output, check_tri);
	end
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
		num_a_test[0] <= 'd5;
		num_x_test[0] <= 'd3;
		num_b_test[0] <= 'd2;
		num_c_test[0] <= 'd1;

		num_a_test[1] <= 'd9;
		num_x_test[1] <= 'd8;
		num_b_test[1] <= 'd7;
		num_c_test[1] <= 'd6;

		num_a_test[2] <= $random;
		num_x_test[2] <= $random;
		num_b_test[2] <= $random;
		num_c_test[2] <= $random;
	end
end

initial begin
	$display("\t\tin_1,\tin_2,\tin_add,\tmode,\tmac_output, \tideal_out");
	clk = 1;
	reset = 1;				
	valid_input = 1'b0;
	last_input = 1'b0;
	test_mode = TEST_TRI;
	//tri_test_inputs = 'b0;
	#10;
	reset = 0;

	//Assert/De-assert reset
	//#1 -> reset_triger;#19;

	case (test_mode)
		TEST_TRI:
		begin
			for (tri_test_inputs = 0; tri_test_inputs < 3; tri_test_inputs = tri_test_inputs + 1'b1) begin
				//change to control control unit
				//(a*x + b)*x+c
				//Mode 1 for tri
				mode = 'd1;
				valid_input = 1'b1;
				//a
				num_a_in = num_a_test[tri_test_inputs];
				num_a = num_a_test[tri_test_inputs];
				//x
				num_x_in = num_x_test[tri_test_inputs]; 
				num_x = num_x_test[tri_test_inputs];
				//b
				num_b_in = num_b_test[tri_test_inputs];
				num_b = num_b_test[tri_test_inputs]; 
				//c for testing
				num_c = num_c_test[tri_test_inputs]; 
				//c
				num_c_in = num_c_test[tri_test_inputs];
				last_input = 1'b1;


				#40;
				last_input = 1'b0;
				valid_input = 1'b0;
				#10;
			end
		end 
		TEST_SUMP:
		begin

		end
		default: 
		begin
		
		end
	endcase


	$finish;
end

//code for reset logic 
event reset_triger;
	event reset_done_trigger;

	initial begin
		forever begin
			@(reset_triger);
			@(posedge clk);
			reset = 1'b1;
			@(posedge clk);
			reset = 1'b0;
			-> reset_done_trigger;
		end
	end

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

endmodule
`default_nettype wire