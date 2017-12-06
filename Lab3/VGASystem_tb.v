`default_nettype none

module VGASystem_tb;
reg clk;
reg rst_n;
reg v_sync_en;

wire VGA_Red0, VGA_Red1, VGA_Red2; 
wire VGA_Green0, VGA_Green1, VGA_Green2;
wire VGA_Blue1, VGA_Blue2;
wire VGA_HSYNC, VGA_VSYNC;

VGASystem vga_system_0
(
  	.clk(clk) ,
	.reset(rst_n) ,
  	.VGA_Red0(VGA_Red0) ,
  	.VGA_Red1(VGA_Red1) ,
  	.VGA_Red2(VGA_Red2) ,
  	.VGA_Green0(VGA_Green0) ,
  	.VGA_Green1(VGA_Green1) ,
  	.VGA_Green2(VGA_Green2) ,
  	.VGA_Blue1(VGA_Blue1) ,
  	.VGA_Blue2(VGA_Blue2) ,
  	.VGA_HSYNC(VGA_HSYNC) ,
  	.VGA_VSYNC(VGA_VSYNC),
	.v_sync_en(v_sync_en)
);

localparam CLK_PERIOD = 20;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	rst_n = 1;
	clk = 1;
	v_sync_en = 0;
	#20; 
	v_sync_en = 1;
	rst_n = 0;
	#200

	#1000000
	$finish;
end

endmodule
`default_nettype wire		