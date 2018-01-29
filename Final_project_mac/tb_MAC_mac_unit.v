`timescale 1ns/1ps

module tb_MAC_mac_unit;
reg clk;
reg reset;

reg [7:0] in_1;
reg [7:0] in_2;
reg [7:0] in_add;
reg mode;
reg mul_input_mux, adder_input_mux;
wire [15:0] mac_output;
reg [16:0] check_tri;

reg adder_en, mul_en;

MAC_mac_unit dut_mac_0(
	.clk(clk) ,
	.reset(reset) ,
	.in_1(in_1) ,
	.in_2(in_2) ,
	.in_add(in_add) ,
	.mode(mode),
	.mul_input_mux(mul_input_mux) ,
	.adder_input_mux(adder_input_mux) ,
	.mac_output(mac_output),
	.adder_en(adder_en),
	.mul_en(mul_en)
);
//Trinomial ideal unit
always @ (posedge clk or posedge reset) begin
	if (reset) begin
		check_tri <= 1'b0;
	end else begin
		check_tri <= (5*3 + 2) * 3 + 1 ;
	end
end
//Trinomial checker
always @(posedge clk or posedge reset) begin
	if (check_tri == mac_output) begin
		//$display ("If not 3rd error in the row ignore\n");
		//$display("\t%d,\t%d,\t%d,\t%d,\t%d,\t%d", in_1, in_2, in_add, mode, mac_output, check_tri);
	//end else begin
		$display ("Success\n");
		$display("\t%d,\t%d,\t%d,\t%d,\t%d,\t%d", in_1, in_2, in_add, mode, mac_output, check_tri);
	end
end

initial begin
	$display("\t\tin_1,\tin_2,\tin_add,\tmode,\tmac_output, \tideal_out");
	clk = 1;
	reset = 1;
	adder_en = 1;
	mul_en = 1;
	#10;
	reset = 0;
	//Assert/De-assert reset
	//#1 -> reset_triger;#19;

	mul_input_mux = 1'b0;
	adder_input_mux = 1'b0;
	//Mode 1 for tri
	mode = 'd1;
	//a
	in_1 = 'd5;
	//x
	in_2 = 'd3; 

	//b
	in_add = 'd2; 
	#10;
	//c
	mul_input_mux = 1'b1;
	in_add = 'd1; 
	#20;
	mul_en = 0;
	#10;
	adder_en = 0;

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