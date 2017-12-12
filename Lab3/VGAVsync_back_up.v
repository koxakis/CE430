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
	output reg v_sync; 
	output h_sync;

	//reg draw_line_count;
	reg [19:0] master_vsync_count;
	reg h_sync_en;

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
			//draw_line_count <= 0;
			master_vsync_count <= 0;
			v_sync <= 1;
			//draw_line_count <= 0;
			h_sync_en <= 0;
		end else begin
		//	if (!v_sync_en) begin
				//draw_line_count <= 0;
		//		master_vsync_count <= 0;
		//		v_sync <= 1;
		//		h_sync_en <= 0;
		//	end else begin
			if (master_vsync_count == 0) begin
				v_sync <= 0;
				h_sync_en <= 0;
				master_vsync_count <= master_vsync_count + 1;
			end else begin
				if (master_vsync_count == 3200) begin
					v_sync <= 1;
					h_sync_en <= 0;
					master_vsync_count <= master_vsync_count + 1;
				end else begin
					if (master_vsync_count == 49600) begin
						h_sync_en <= 1;
						v_sync <= 1;
						master_vsync_count <= master_vsync_count + 1;
					end else begin
						if (master_vsync_count == 817600) begin
							h_sync_en <= 0;
							v_sync <= 1;
							master_vsync_count <= master_vsync_count + 1;
						end else begin
							if (master_vsync_count == 833600) begin
								h_sync_en <= 0;
								v_sync <= 1;
								master_vsync_count <= 0;
							end else begin
								master_vsync_count <= master_vsync_count + 1;
							end
						end
					end
				end
			end
		end
	end


endmodule // VGAVsync	