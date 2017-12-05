module VGAVsync(
	clk,
	reset,

);


module VGAHsync(
	.clk(clk) ,
	.clk_d(clk_d) ,
	.reset(reset) ,
	.h_sync(h_sync) ,
	.vga_red(vga_red) ,
	.vga_green(vga_green) ,
	.vga_blue(vga_blue) ,
	.h_sync_en(h_sync_en)
);




endmodule // VGAVsync	