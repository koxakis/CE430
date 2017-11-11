module UARTReciver(
	clk,
	reset,
	baud_select,
	Rx_EN,
	Rx_PERROR,
	Rx_FERROR,
	Rx_DATA,
	Rx_VALID,
	Rx_D
);

	input clk, reset;
	input baud_select;

	input Rx_EN, Rx_D;

	output Rx_PERROR, Rx_FERROR, Rx_VALID;
	output [7:0] Rx_DATA

	wire baud_enable;

	reg state, next_state;
	reg [10:0] data_to_check;
	reg char_to_check;

	reg flag;
	reg [3:0] index;
	reg [4:0] trans_counter;


	UARTBaudController baud_controller_0(
		.clk(clk),
		.reset(reset),
		.baud_select(baud_select),
		.sample_enable(baud_enable)
	);

	//reajast states 
	always @(state) begin
		case (state)
		IDLE:
		  begin

			if (Tx_D) begin
				next_state <= IDLE;
			end else begin
				next_state <= RECEIVING;
			end	
		  end
		RECEIVING:
		  begin
		  	//if state is correct go to idle if not go to error state
			if (flag) begin
				next_state <= IDLE;
			end else begin
			  	next_state <= RECEIVING;
			end	
		  end
		default: 
		  begin
			next_state <= IDLE;
		  end
		endcase
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= IDLE;
		end else begin
			state <= next_state ;
		end
	end

	//Ajaust logic of the transmeter to the resiver to sample and store
	always @(posedge clk or posedge reset) begin
		if (reset) begin
		  	index <= 0;
			flag <= 0;
		end else begin
			if (!Rx_EN) begin
				index <= 0;
				flag <= 0;
			end else begin
				if (baud_enable) begin
				  	data_to_check[index] <= Rx_D; 
					if (trans_counter == 16) begin
						index <= index + 1;
						trans_counter <= 0;
					end else begin
						trans_counter <= trans_counter + 1;
					end
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

	always @(posedge clk or posedge reset) begin
		if (reset) begin
		  	Rx_FERROR <= 0;
			Rx_PERROR <= 0;
			Rx_VALID <= 0;
			Rx_DATA <= 8'b0;
		end else begin
		  	//perform all checks on the gathered data
		end
	end

endmodule // UARTReciver