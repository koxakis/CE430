module VGAHsync(
	clk,
	clk_d,
	reset,
	h_sync,
	vga_red,
	vga_green,
	vga_blue,
	h_sync_en
);

	input clk, reset;
	input h_sync_en;

	input clk_d;

	output h_sync;

	output reg vga_red, vga_green, vga_blue;

	reg [63:0] port_a_b_data_red;
	reg [63:0] port_a_b_data_green;
	reg [63:0] port_a_b_data_blue;

	wire [31:0] port_a_red_data;
	wire [31:0] port_b_red_data;

	wire [31:0] port_a_green_data;
	wire [31:0] port_b_green_data;

	wire [31:0] port_a_blue_data;
	wire [31:0] port_b_blue_data;

	reg [13:0] port_a_addr, port_b_addr;
	reg [11:0] master_hsync_count;
	reg [6:0] pixel_counter;
	reg [2:0] pixel_scale_count;

	reg [1:0]line_comp_counter;
	wire display_time_en;

	VGAMemory vga_vram_0(
		.reset (reset),
		.clk (clk),
  		.pixel_addr_a(port_a_addr),
		.pixel_addr_b(port_b_addr),
		.red_out_p1 (port_a_red_data),
		.green_out_p1 (port_a_green_data),
		.blue_out_p1 (port_a_blue_data) ,
		.red_out_p2 (port_b_red_data),
		.green_out_p2 (port_b_green_data),
		.blue_out_p2 (port_b_blue_data)
	);

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			master_hsync_count <= 0;
		end else begin
			master_hsync_count <= master_hsync_count + 1;
			if (master_hsync_count == 1599) begin
				master_hsync_count <= 0;
			end
		end
	end

	assign h_sync = ( (h_sync_en) && ( (master_hsync_count >= 0) && (master_hsync_count <= 12'd191) ) ) ? 0 : 1;
	//assign h_sync = ( (h_sync_en) && ( (master_hsync_count > 12'd95) || (master_hsync_count == 12'd799) ) ) ? 0 : 1;

	assign display_time_en = ( (h_sync_en) && ( (master_hsync_count >= 12'd287) && (master_hsync_count <= 12'd1566) ) ) ? 1 : 0;
	//assign display_time_en = ( (h_sync_en) && ( (master_hsync_count >= 12'd798) && (master_hsync_count <= 12'd2078) ) ) ? 1 : 0;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			port_a_addr <= 'h0000;
			port_b_addr <= 'h0020;
			pixel_counter <= 0;
			line_comp_counter <= 0;
			pixel_scale_count <= 0;
		end else begin
			if (line_comp_counter == 2) begin
				port_a_addr <= port_a_addr + 'h40;
				port_b_addr <= port_b_addr + 'h40;

				if (port_a_addr == 'h3000) begin
					port_a_addr <= 'h0000;
					port_b_addr <= 'h0020;
				end

				pixel_counter <= 0;
				line_comp_counter <= 0;
				pixel_scale_count <= 0;
			end else begin
				if ( !display_time_en ) begin
					vga_red <= 0;
					vga_green <= 0;
					vga_blue <= 0;
					pixel_counter <= 0;
					pixel_scale_count <= 0;
				end else begin
					port_a_b_data_red <= {port_b_red_data, port_a_red_data};
					port_a_b_data_green <= {port_b_green_data , port_a_green_data };
					port_a_b_data_blue <= {port_b_blue_data , port_a_blue_data };

					if (pixel_counter == 63) begin
						pixel_counter <= 0;
						line_comp_counter <= line_comp_counter + 1;
					end else begin
						if (pixel_scale_count == 4) begin
							pixel_counter <= pixel_counter + 1;
							pixel_scale_count <= 0;
						end else begin
							vga_red <= port_a_b_data_red[pixel_counter];
							vga_green <= port_a_b_data_green[pixel_counter];
							vga_blue <= port_a_b_data_blue[pixel_counter];
							pixel_scale_count <= pixel_scale_count + 1;
						end
					end
				end
			end
		end
	end

endmodule // VGAHsync