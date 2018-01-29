`timescale 1ns/1ps

module tb_MAC_mac_unit;
reg clk;
reg reset;

reg [7:0] in_1;
reg [7:0] in_2;
reg [7:0] in_add, num_a, num_x, num_b, num_c;
reg mode;
reg mul_input_mux, adder_input_mux;
wire [15:0] mac_output;
reg [16:0] check_tri;

MAC_mac_unit dut_mac_0(
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
	if (check_tri == mac_output) begin
		$display ("Success\n");
		$display("\t%d,\t%d,\t%d,\t%d,\t%d,\t%d", in_1, in_2, in_add, mode, mac_output, check_tri);
	end
end

initial begin
	$display("\t\tin_1,\tin_2,\tin_add,\tmode,\tmac_output, \tideal_out");
	clk = 1;
	reset = 1;
	#10;
	reset = 0;
	//Assert/De-assert reset
	//#1 -> reset_triger;#19;

	//(a*x + b)*x+c
	//For test (5*3 + 2)*3 + 1;
	mul_input_mux = 1'b0;
	adder_input_mux = 1'b0;
	//Mode 1 for tri
	mode = 'd1;
	//a
	in_1 = 'd5;
	num_a = 'd5;
	//x
	in_2 = 'd3; 
	num_x = 'd3;
	//b
	in_add = 'd2;
	num_b = 'd2; 
	//c for testing
	num_c = 'd1; 
	#10;
	//c
	mul_input_mux = 1'b1;
	in_add = 'd1;

	#30;

	//(a*x + b)*x+c
	//For test (9*8 + 7)*8 + 6
	mul_input_mux = 1'b0;
	adder_input_mux = 1'b0;
	//Mode 1 for tri
	mode = 'd1;
	//a
	in_1 = 'd9;
	num_a = 'd9;
	//x
	in_2 = 'd8; 
	num_x = 'd8;
	//b
	in_add = 'd7;
	num_b = 'd7; 
	//c for testing
	num_c = 'd6; 
	#10;
	//c
	mul_input_mux = 1'b1;
	in_add = 'd6;
	#60
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