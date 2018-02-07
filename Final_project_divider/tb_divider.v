`default_nettype none

module tb_divider;
reg clk;
reg rst_n;

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

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
  dumpfile("tb_divider.vcd");
  dumpvars(0, tb_divider);
end

initial begin
  #1 rst_n<=1'bx;clk<=1'bx;
  #(CLK_PERIOD*3) rst_n<=1;
  #(CLK_PERIOD*3) rst_n<=0;clk<=0;
  repeat(5) @(posedge clk);
  rst_n<=1;
  @(posedge clk);
  repeat(2) @(posedge clk);
  finish(2);
end

endmodule
`default_nettype wire