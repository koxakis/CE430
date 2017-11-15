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

	parameter IDLE = 2'b00;
	parameter RECEIVING = 2'b01;	
	parameter ERROR_CHECK = 2'b10;

	input clk, reset;
	input [2:0] baud_select;

	input Rx_EN, Rx_D;

	reg Rx_D_1st, Rx_D_2nd;

	output reg Rx_PERROR, Rx_FERROR, Rx_VALID;
	output reg [7:0] Rx_DATA;

	wire baud_enable;

	reg [1:0] state, next_state;
	reg [10:0] data_to_check;

	wire parity_to_check;

	reg start_reciving_flag, error_check_flag;
	reg data_prossecing_done, data_recived_flag;
	reg f_error_flag;
	reg [3:0] index;
	reg [3:0] trans_counter;


	UARTBaudController baud_controller_0(
		.clk(clk),
		.reset(reset),
		.baud_select(baud_select),
		.sample_enable(baud_enable)
	);

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			Rx_D_1st <= 0;
		end else begin
		  	Rx_D_1st <= Rx_D;
		end
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			Rx_D_2nd <= 0;
		end else begin
			Rx_D_2nd <= Rx_D_1st;
		end
	end

	//reajast states 
	always @(posedge clk or posedge reset) begin

		if (reset) begin
			start_reciving_flag <= 0;
			error_check_flag <= 0;
			next_state <= IDLE;
		end else begin
			case (state)
			IDLE:
			  begin
				if (Rx_D) begin
					start_reciving_flag <= 0;
					error_check_flag <= 0;
					next_state <= IDLE;
				end else begin
					error_check_flag <= 0;
					start_reciving_flag <= 1;
					next_state <= RECEIVING;
				end	
			  end
			RECEIVING:
			  begin
			  	//if state is correct go to idle if not go to error state
				if (data_recived_flag) begin
					start_reciving_flag <= 0;
					error_check_flag <= 1;
					next_state <= ERROR_CHECK;
				end else begin
					start_reciving_flag <= 1;
					error_check_flag <= 0;
				  	next_state <= RECEIVING;
				end	
			  end
			ERROR_CHECK:
			  begin
				if (data_prossecing_done) begin
					start_reciving_flag <= 0;
					error_check_flag <= 0;
					next_state <= IDLE;
				end else begin
					start_reciving_flag <= 0;
					error_check_flag <= 0;
					next_state <= ERROR_CHECK;
				end
			  end
			2'b11:
			  begin
			  	error_check_flag <= 0;
				start_reciving_flag <= 0;
				next_state <= IDLE;
			  end
			default: 
			  begin
			  	error_check_flag <= 0;
				start_reciving_flag <= 0;
				next_state <= IDLE;
			  end
			endcase
		end
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
			data_recived_flag <= 0;
			trans_counter <= 0;
			f_error_flag <= 0;
		end else begin
			if (!Rx_EN) begin
				index <= 0;
				data_recived_flag <= 0;
			end else begin
				if (!start_reciving_flag) begin
					index <= 0;
					if (data_prossecing_done) begin
					  	f_error_flag <= 0;
					end
					data_recived_flag <= 0;
				end else begin
					if (baud_enable) begin
						if (trans_counter == 15) begin
							index <= index + 1;
							trans_counter <= 0;
						end else begin
							trans_counter <= trans_counter + 1; 
						end
						if (index == 0 && Rx_D) begin
							f_error_flag <= 1;
						end
						if ((index == 10) && (~Rx_D)) begin
							f_error_flag <= 1;
						end
						data_to_check[index] <= Rx_D;
						if (index == 11) begin
							data_recived_flag <= 1;
						end else begin
							data_recived_flag <= 0;
						end
					end 
				end
			end
		end
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			Rx_DATA <= 8'b000000000;
		end else begin
		  	Rx_DATA[7] <= data_to_check[8]; 
			Rx_DATA[6] <= data_to_check[7];
			Rx_DATA[5] <= data_to_check[6]; 
			Rx_DATA[4] <= data_to_check[5]; 
			Rx_DATA[3] <= data_to_check[4]; 
			Rx_DATA[2] <= data_to_check[3]; 
			Rx_DATA[1] <= data_to_check[2]; 
			Rx_DATA[0] <= data_to_check[1];  
		end
	end


	assign parity_to_check = ^Rx_DATA; 

	always @(posedge clk or posedge reset) begin
		if (reset) begin
		  	Rx_FERROR <= 0;
			Rx_PERROR <= 0;
			Rx_VALID <= 0;
			data_prossecing_done <= 0;
		end else begin
		  	//perform all checks on the gathered data and output the correct signal
			if (!error_check_flag) begin
				Rx_FERROR <= 0;
				Rx_PERROR <= 0;
				Rx_VALID <= 0;
				data_prossecing_done <= 0;
			end else begin
				if (f_error_flag) begin
					Rx_VALID <= 0;
					Rx_FERROR <= 1;
					data_prossecing_done <= 1;
				end else if (data_to_check[9] != parity_to_check) begin					
					Rx_VALID <= 0;
					Rx_PERROR <= 1;
					data_prossecing_done <= 1;
				end else begin
					Rx_VALID <= 1;
					Rx_FERROR <= 0;
					Rx_PERROR <= 0;
					data_prossecing_done <= 1;
					//end
				end
			end
		end
	end

endmodule // UARTReciver