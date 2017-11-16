//For 15ns period
module UARTBaudController_15clk(
	clk,
	reset,
	baud_select,
	sample_enable
);

	input wire reset, clk;
	input wire [2:0] baud_select;
 
	output reg sample_enable;

	reg [15:0] max_counter;
	
	reg [15:0] counter;

	always @(baud_select) begin
		case (baud_select)
		3'b000: begin
			max_counter = 16'd13889; 	
		end	
		3'b001: begin
			max_counter = 16'd3472; 	
		end
		3'b010: begin
			max_counter = 16'd868; 	
		end
		3'b011: begin
			max_counter = 16'd434; 	
		end
		3'b100: begin
			max_counter = 16'd217; 	
		end
		3'b101: begin
			max_counter = 16'd109; 	
		end
		3'b110: begin
			max_counter = 16'd72; 	
		end
		3'b111: begin
			max_counter = 16'd36; 	
		end	
		default begin
			max_counter = 16'd10417;					
		end
		endcase	
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			counter <= 'b0;
			sample_enable <= 0; 
		end else begin
			if (counter == max_counter) begin
				sample_enable <= 1;
				counter <= 'b0;
			end else begin
				counter <= counter + 1;
				sample_enable <= 0; 
			end
		end
	end

endmodule // UARTBaudController_15clk