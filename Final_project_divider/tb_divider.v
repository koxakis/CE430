`default_nettype none

module tb_divider;

reg signed [31:0] dividend;
reg signed [15:0] divisor;

reg clk, reset;
reg valid_input, mode;

wire valid_output;
wire signed [16:0] final_output;

reg signed [16:0] check_div;
reg signed [15:0] check_mod;
reg [2:0] test_cases;

Div_mod_top_level divider_dut 
(
	.clk(clk) ,
	.reset(reset) ,
	.divisor(divisor),
	.dividend(dividend),
	.mode(mode),
	.valid_input(valid_input),
	.valid_output(valid_output),
	.final_output(final_output)
);

always @(posedge clk or posedge reset) begin
	if ((final_output == check_div) && (mode)) begin
		$display ("Success\n");
		$display("\tIdeal ,\tFinal Out,\tDivitend,\tDivisor");
		$display("\t%d,\t%d,\t%d,\t%d", check_div, final_output,dividend, divisor);
	end
end
//Divider Ideal unit
always @(posedge clk or posedge reset) begin
	if (reset) begin
		check_div <= 'b0;
		check_mod <= 'b0;
	end else begin
		check_div <= dividend / divisor;
		check_mod <= dividend % divisor;
	end
end

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	clk = 1;
	mode = 1;
	reset = 1;
	valid_input = 1'b0;
	#50;
	reset = 0;

	for (test_cases = 0; test_cases < 3; test_cases = test_cases + 1'b1) begin
		valid_input = 1'b1;
		//dividend = $random;
		dividend = 32'd50;
		divisor = -16'd5;
		//divisor = $random;
		#50;
	end
	
end

endmodule
`default_nettype wire