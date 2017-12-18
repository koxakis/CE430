////////////////////////////////////////////////////
//Module : VGA HSYNC module 
//File : VGAHsync.v
//Discreption : Produces HSYNC vga control signal and addreses BRAM data
////////////////////////////////////////////////////
module VGAHsync(
	clk,
	reset,
	h_sync,
	vga_red,
	vga_green,
	vga_blue,
	h_sync_en
);

	input clk, reset;
	input h_sync_en;

	output h_sync;

	output reg vga_red, vga_green, vga_blue;

	//64bit Reg storage for concatinated BRAM for both ports a, b red, green, blue data
	reg [63:0] port_a_b_data_red;
	reg [63:0] port_a_b_data_green;
	reg [63:0] port_a_b_data_blue;

	// 32bit BRAM port a, b outpout prior to concatination
	wire [31:0] port_a_red_data;
	wire [31:0] port_b_red_data;

	wire [31:0] port_a_green_data;
	wire [31:0] port_b_green_data;

	wire [31:0] port_a_blue_data;
	wire [31:0] port_b_blue_data;

	reg [13:0] port_a_addr, port_b_addr;
	reg [11:0] master_hsync_count;

	//Line pixel counter 
	reg [6:0] pixel_counter;

	//Scale pixel counter - for with and hight
	reg [2:0] pixel_scale_count;
	reg [2:0] pixel_scale_count_line;

	reg [1:0]line_comp_counter;
	wire display_time_en;

	//BRAM 16x1 dual port 32bits output per port
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

	//Master HSYNC counter - reset to zero after whole line is drawn
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

	//Assign the HSYNC signal output to 0 when counter is in range and 1 otherwise 
	assign h_sync = ( (master_hsync_count >= 0) && (master_hsync_count <= 12'd191) ) ? 0 : 1;

	//Enable the memory module output only when horizonlal acrive video time or disable it in order not to losse pixels
	assign display_time_en = (( (h_sync_en) && (master_hsync_count >= 12'd287) && (master_hsync_count < 12'd1566) ) ) ? 1 : 0;

	//Memory access block
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			/*Reset both ports addreses to these values to ensure 
				port a and b are the 1st and 2nd 32bits of the half-line */
			port_a_addr <= 'h0000;
			port_b_addr <= 'h0020;

			pixel_counter <= 0;
			line_comp_counter <= 0;
			pixel_scale_count <= 0;
			pixel_scale_count_line <= 0;
		end else begin
			/*The memory is accessed by two ports eatch loading 32bits of data
				you need 2 sets of addresses in order to load a single line.
				When the line_comp_counter is 2 it means one line is complited*/
			if (line_comp_counter == 2) begin
				/*This counter keeps eatch address for 5 times in order to scale the image to the 
					desired resolution and then we move to the next set of 64bit data*/
				if (pixel_scale_count_line == 4) begin
					port_a_addr <= port_a_addr + 'h40;
					port_b_addr <= port_b_addr + 'h40;
					pixel_scale_count_line <= 0;
				end else begin
					pixel_scale_count_line <= pixel_scale_count_line + 1;
				end
				//Reset port a and b addresses in order not to read past the stored in BRAM image 
				if (port_a_addr == 'h3000) begin
					port_a_addr <= 'h0000;
					port_b_addr <= 'h0020;
				end
				pixel_counter <= 0;
				line_comp_counter <= 0;
				pixel_scale_count <= 0;
			end else begin
				//If the enable signal is not activated RGB outputs are grounded as to not be wasted 
				if ( !display_time_en ) begin
					vga_red <= 0;
					vga_green <= 0;
					vga_blue <= 0;
					pixel_counter <= 0;
					pixel_scale_count <= 0;
				end else begin
					//Concitinate port a and port b output in a single 64bit reg to make it easyer to be accessed for each colour
					port_a_b_data_red <= {port_b_red_data, port_a_red_data};
					port_a_b_data_green <= {port_b_green_data , port_a_green_data };
					port_a_b_data_blue <= {port_b_blue_data , port_a_blue_data };

					//Count up to 64 and then increment the line completion counter
					if (pixel_counter == 63) begin
						pixel_counter <= 0;
						line_comp_counter <= line_comp_counter + 1;
					end else begin
						/*This counter keeps eatch address for 5 times in order to scale the image to the 
							desired resolution and then we move to the next index*/
						if (pixel_scale_count == 4) begin
							pixel_counter <= pixel_counter + 1;
							pixel_scale_count <= 0;
						end else begin
							//Output the index from the reg to the screen 
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