module UARTTransmeter(
  clk,
  reset,
  Tx_DATA,
  baud_select,
  Tx_WR,
  Tx_EN,
  Tx_D,
  Tx_BUSY
);

	parameter IDLE = 1'b0;
	parameter TRANSMITTING = 1'b1;

	input clk, reset;
	input Tx_EN, Tx_WR;
	input [2:0] baud_select;
	input [7:0] Tx_DATA;

	output reg Tx_BUSY, Tx_D;

	wire baud_enable;
	reg trans_en;
	reg [3:0] baud_count;

	reg [10:0] data_to_send;

	reg state;
	reg next_state;
	reg [3:0] index;
	reg char_to_send, data_transmitting_done;

	UARTBaudController baud_controller_0(
		.clk(clk),
		.reset(reset),
		.baud_select(baud_select),
		.sample_enable(baud_enable)
	);

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			data_to_send <= 11'b1;
		end else begin
			if (Tx_WR) begin	
				data_to_send[10] <= 1;
				data_to_send[9] <= ^Tx_DATA ;
				data_to_send[8] <= Tx_DATA[7];
				data_to_send[7] <= Tx_DATA[6];
				data_to_send[6] <= Tx_DATA[5];
				data_to_send[5] <= Tx_DATA[4];
				data_to_send[4] <= Tx_DATA[3];
				data_to_send[3] <= Tx_DATA[2];
				data_to_send[2] <= Tx_DATA[1];
				data_to_send[1] <= Tx_DATA[0];
				data_to_send[0] <= 0; 
			end
		end	  
	end
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			baud_count <= 0;
			trans_en <= 0;
		end else begin
			if (!Tx_EN) begin
				baud_count <= 0;
				trans_en <= 0;
			end else begin
				if (baud_enable) begin
					baud_count <= baud_count + 1;
					trans_en <= 0;
					if (baud_count == 15) begin
						trans_en <= 1;
						baud_count <= 0;
					end
				end else begin
					if (baud_count == 0) begin
						trans_en <= 0;
					end 
				end 
			end	
		end
	end

	//make sequential 
	always @(state or Tx_WR or char_to_send or data_transmitting_done or Tx_BUSY) begin
		case (state)
		IDLE:
		  begin
			if (!Tx_WR) begin
				Tx_BUSY <= 0;
				Tx_D <= 1;
				next_state <= IDLE;
			end else begin
				Tx_BUSY <= 1;
				Tx_D <= 1;
				next_state <= TRANSMITTING;
			end
		  end
		TRANSMITTING:
		  begin
			if (data_transmitting_done) begin
				next_state <= IDLE;  
				Tx_D <= 1;
				Tx_BUSY <= 0;
			end else begin
				Tx_BUSY <= 1;
				Tx_D <= char_to_send;
				next_state <= TRANSMITTING;
			end
		  end
		default:
		  begin
			Tx_BUSY <= 0;
			Tx_D <= 1;
			next_state <= IDLE;
		  end
		endcase	
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= IDLE;  
		end else begin
			state <= next_state;
		end
	end	

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			char_to_send <= 1;
			index <= 0;
			data_transmitting_done <= 0;
		end else begin
			if (!Tx_BUSY) begin
				char_to_send <= 1;
				index <= 0;
				data_transmitting_done <= 0;
			end else begin
				if (trans_en) begin
					char_to_send <= data_to_send[index];
					index <= index + 1;
					data_transmitting_done <= 0;
				end else begin
					if (index == 11) begin
						data_transmitting_done <= 1;
						index <= 0;
					end else begin
						data_transmitting_done <= 0;
					end
				end
			end
		end
	end


endmodule // UARTTransmeter	