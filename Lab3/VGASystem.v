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

output VGA_Red0, VGA_Red1, VGA_Red2; 
output VGA_Green0, VGA_Green1, VGA_Green2, 
output VGA_Blue1, VGA_Blue2;
output VGA_HSYNC, VGA_HSYNC;

//instansiate memory module - test returning values through thest bench

//instansiate Hsync

endmodule // VGASystem