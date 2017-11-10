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

	parameter IDLE = 0;
	parameter TRANSMIDING = 1;

	input clk, reset;
	input Tx_EN, Tx_WR;
	input [2:0] baud_select;
	input [7:0] Tx_DATA;

	output reg Tx_BUSY, Tx_D;

	wire baud_enable;
	reg trans_en;
	reg [4:0] baud_count;

	reg [10:0] data_to_send;

	reg state;
	reg next_state;
	reg [3:0] index;
	reg char_to_send, flag;

	UARTBaudController baud_controller_0(
		.clk(clk),
		.reset(reset),
		.baud_select(baud_select),
		.sample_enable(baud_enable)
	);

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			data_to_send <= 'b0;
		end else begin
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
				end else begin
					if (baud_count == 16) begin
						trans_en <= 1;
						baud_count <= 0;
					end else begin
						trans_en <= 0;
					end 
				end 
			end	
		end
	end

	always @(state or reset or Tx_WR or char_to_send) begin

		if (reset) begin
			next_state <= IDLE;  
		end else begin
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
					next_state <= TRANSMIDING;
				end
			  end
			TRANSMIDING:
			  begin
				if (flag) begin
					next_state <= IDLE;  
					Tx_D <= 1;
				end else begin
					Tx_D <= char_to_send;
					next_state <= TRANSMIDING;
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
			flag <= 0;
		end else begin
			if (!Tx_WR) begin
				char_to_send <= 1;
				index <= 0;
				flag <= 0;
			end else begin
				if (trans_en) begin
					char_to_send <= data_to_send[index];
					index <= index + 1;
					flag <= 0;
				end else begin
					if (index == 11) begin
						flag <= 1;
						index <= 0;
					end else begin
						flag <= 0;
					end
				end
			end
		end
	end


endmodule // UARTTransmeter	