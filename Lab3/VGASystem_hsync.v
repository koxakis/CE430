////////////////////////////////////////////////////
//Module : VGA system top module for HSYNC testing
//File : VGASystem_hsync.v
//Discreption : Produces VSYNC vga control signal
////////////////////////////////////////////////////
module VGASystem_hsync(
  clk,
  reset,
  VGA_Red0,
  VGA_Red1,
  VGA_Red2,
  VGA_Green0,
  VGA_Green1,
  VGA_Green2,
  VGA_Blue1,
  VGA_Blue2,
  VGA_HSYNC,
  VGA_VSYNC,
  h_sync_en
);

input reset, clk;
input h_sync_en;

output VGA_Red0, VGA_Red1, VGA_Red2; 
output VGA_Green0, VGA_Green1, VGA_Green2;
output VGA_Blue1, VGA_Blue2;
output VGA_HSYNC, VGA_VSYNC;

wire h_sync_en;

assign VGA_Red1 = 0;
assign VGA_Red2 = 0;

assign VGA_Green1 = 0;
assign VGA_Green2 = 0;

assign VGA_Blue2 = 0;

//instansiate memory module - test returning values through thest bench
VGAHsync vga_hsync_0(
	.clk(clk) ,
	.reset(reset) ,
	.h_sync(VGA_HSYNC) ,
	.vga_red(VGA_Red0) ,
	.vga_green(VGA_Green0) ,
	.vga_blue(VGA_Blue1) ,
	.h_sync_en(h_sync_en)
);
//instansiate Hsync

endmodule // VGASystem_hsync