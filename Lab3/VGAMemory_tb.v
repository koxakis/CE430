`default_nettype none

module VGAMemory_tb;
reg clk;
reg rst_n;
reg [13:0] pixel_addr_a;
reg [13:0] pixel_addr_b;

wire [31:0] VGA_Red0_p1, VGA_Green0_p1, VGA_Blue1_p1;
wire [31:0] VGA_Red0_p2, VGA_Green0_p2, VGA_Blue1_p2;
 
VGAMemory vga_vram_0(
	.reset (rst_n),
	.clk (clk),
  	.pixel_addr_a(pixel_addr_a),
	.pixel_addr_b(pixel_addr_b),
	.red_out_p1 (VGA_Red0_p1),
	.green_out_p1 (VGA_Green0_p1),
	.blue_out_p1 (VGA_Blue1_p1) ,
	.red_out_p2 (VGA_Red0_p2),
	.green_out_p2 (VGA_Green0_p2),
	.blue_out_p2 (VGA_Blue1_p2)
);

localparam CLK_PERIOD = 20;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	rst_n = 1;
	clk = 1;
	#20; 
	rst_n = 0;
	pixel_addr_a = 14'h2400;
	pixel_addr_b = 14'h2440;
	#200;
	pixel_addr_a = 14'h2480;
	pixel_addr_b = 14'h24c0;
	#20;
	pixel_addr_a = 14'h24ff;
	pixel_addr_b = 14'h2500;

	#1000
	$finish;

end

endmodule
`default_nettype wire