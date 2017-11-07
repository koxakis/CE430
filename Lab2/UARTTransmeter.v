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

	input clk, reset;
	input Tx_EN, Tx_WR;
	input [2:0] baud_select;
	input [7:0] Tx_DATA;

	output Tx_BUSY, Tx_D;

	wire baud_enable;
	reg trans_en;
	reg [4:0] baud_count;

	UARTBaudController baud_controller_0(
		.clk(clk),
		.reset(reset),
		.baud_select(baud_select),
		.sample_enable(baud_enable)
	);

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
						//baud_count <= baud_count + 1;
					end 
				end 
			end	
		end
	end


endmodule // UARTTransmeter	