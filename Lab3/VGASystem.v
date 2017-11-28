module VGASystem(
  reset,
  clk,
  VGA_Red0,
  VGA_Red1,
  VGA_Red2,
  VGA_Green0,
  VGA_Green1,
  VGA_Green2,
  VGA_Blue1,
  VGA_Blue2,
  VGA_HSYNC,
  VGA_VSYNC
);

input reset, clk;

output [31:0] VGA_Red0, VGA_Red1, VGA_Red2; 
output [31:0] VGA_Green0, VGA_Green1, VGA_Green2, 
output [31:0] VGA_Blue1, VGA_Blue2;
output VGA_HSYNC, VGA_HSYNC;

//instansiate memory module - test returning values through thest bench
VGAMemory vga_vram_0(
	.reset(reset),
	.clk(clk),
	.pixel_addr(pixel_addr),
	.red_out(VGA_Red0),
	.green_out(VGA_Green0),
	.blue_out(VGA_Blue1)
);
//instansiate Hsync

endmodule // VGASystem