////////////////////////////////////////////////////
//Module : VGA VSYNC module 
//File : VGAVsync.v
//Discreption : Produces VSYNC vga control signal
////////////////////////////////////////////////////
module VGAVsync(
	clk,
	reset,
	vga_red_0,
	vga_red_1,
	vga_red_2,
	vga_green_0,
	vga_green_1,
	vga_green_2,
	vga_blue_1,
	vga_blue_2,
	h_sync,
	v_sync
);

	input clk, reset;

	output vga_red_0, vga_red_1, vga_red_2;
	output vga_green_0, vga_green_1, vga_green_2;
	output vga_blue_1, vga_blue_2;
	output wire v_sync; 
	output wire h_sync;

	//reg draw_line_count;
	reg [19:0] master_vsync_count;
	wire h_sync_en;

	//HSYNC module
	VGAHsync vga_hsync_0(
		.clk(clk) ,
		.reset(reset) ,
		.h_sync(h_sync) ,
		.vga_red_0( vga_red_0),
		.vga_red_1( vga_red_1) ,
		.vga_red_2( vga_red_2) ,
		.vga_green_0 (vga_green_0),
		.vga_green_1 (vga_green_1),
		.vga_green_2 (vga_green_2),
		.vga_blue_1	(vga_blue_1),
		.vga_blue_2	(vga_blue_2),
		.h_sync_en(h_sync_en)
	);

	//Master VSYNC counter - reset to zero after whole screen has been scanned
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

	//Assign the VSYNC signal output to 0 only when counter is in range and 1 otherwise
	assign v_sync = ( (master_vsync_count >= 20'd0) && (master_vsync_count <= 20'd3199) ) ? 0 : 1;

	//Enable the hsync module to draw only when vertical active video time or disable it otherwise
	assign h_sync_en = ( (master_vsync_count > 20'd49599) && (master_vsync_count <= 20'd817599) ) ? 1 : 0;

endmodule // VGAVsync	