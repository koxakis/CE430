module VGAVsync(
	clk,
	reset,
	vga_red,
	vga_green,
	vga_blue,
	h_sync,
	v_sync
);

	input clk, reset;

	output vga_red, vga_green, vga_blue;
	output wire v_sync; 
	output wire h_sync;

	//reg draw_line_count;
	reg [19:0] master_vsync_count;
	wire h_sync_en;

	VGAHsync vga_hsync_0(
		.clk(clk) ,
		.clk_d(clk_d) ,
		.reset(reset) ,
		.h_sync(h_sync) ,
		.vga_red(vga_red) ,
		.vga_green(vga_green) ,
		.vga_blue(vga_blue) ,
		.h_sync_en(h_sync_en)
	);

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			master_vsync_count <= 0;
		end else begin
			master_vsync_count <= master_vsync_count + 1;
			if (master_vsync_count == 833599) begin
				master_vsync_count <= 0;
			end
		end
	end

	assign v_sync = ( (master_vsync_count > 20'd0) && (master_vsync_count <= 20'd3199) ) ? 0 : 1;
	assign h_sync_en = ( (master_vsync_count > 20'd49600) || (master_vsync_count <= 20'd817600) ) ? 1 : 0;

endmodule // VGAVsync	