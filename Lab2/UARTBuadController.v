module UARTBudRateGenerator(
	clk,
	reset,
	baud_select,
	sample_enable
);

	input wire reset, clk;
	input wire [2:0] baud_select;
 
	output wire sample_enable;

	reg [19:0] max_counter, counter;

	always @(baud_select) begin
		case (baud_select)
		000: begin
			max_counter = 4'd166667; 	
			end	
		001: begin
			max_counter = 4'd41667; 	
			end
		010: begin
			max_counter = 4'd10417; 	
			end
		011: begin
			max_counter = 4'd5208; 	
			end
		100: begin
			max_counter = 4'd2604; 	
			end
		101: begin
			max_counter = 4'd1302; 	
			end
		110: begin
			max_counter = 4'd868; 	
			end
		111: begin
			max_counter = 4'd434; 	
			end							
		default: begin
			max_counter = 4'd1000; 	
			end	
		endcase	
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			counter <= 0;
			sample_enable <= 0; 
		end else begin
			if (counter != max_counter) begin
				sample_enable <= 1;
			end else begin
				counter = counter + 1;
			end
		end
	end

	

endmodule // UARTBudRateGenerator