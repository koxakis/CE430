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

	//Signals for the 2flip-flop synchronizer 
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

	// Instantiate UARTBaudController for 20ns UARTBaudController_15clk for 15ns
	UARTBaudController baud_controller_0(
	//UARTBaudController_15clk baud_controller_1(
		.clk(clk),
		.reset(reset),
		.baud_select(baud_select),
		.sample_enable(baud_enable)
	);

	/*Pass the input signal through 2flip-flops in order to synchronize with transmitter 
        in case transmitter and receiver work with different clocks */
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			Rx_D_1st <= 1;
		end else begin
		  	Rx_D_1st <= Rx_D;
		end
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			Rx_D_2nd <= 1;
		end else begin
			Rx_D_2nd <= Rx_D_1st;
		end
	end

	//Sequential clock based state machine
	always @(posedge clk or posedge reset) begin

		if (reset) begin
			start_reciving_flag <= 0;
			error_check_flag <= 0;
			next_state <= IDLE;
		end else begin
			case (state)
			/*IDLE state is the state where the Receiver waits for the 
				main channel to become 0 denoting the start bit */
			IDLE:
			  begin
			  	//Use Rx_D in order to bypass the synchronizer 
				//if (Rx_D) begin
				if (Rx_D_2nd) begin
					start_reciving_flag <= 0;
					error_check_flag <= 0;
					next_state <= IDLE;
				end else begin
					error_check_flag <= 0;
					start_reciving_flag <= 1;
					next_state <= RECEIVING;
				end	
			  end
			/*RECEIVING state is the state where the Receiver is receiving data*/
			RECEIVING:
			  begin
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
			/*ERROR_CHECK state is the state where the received message is being 
				error checked*/
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
			/*Completed states in order to avoid a latch*/
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

	//Sequential clock based state driver 
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= IDLE;
		end else begin
			state <= next_state ;
		end
	end

	//RECEIVING state block
	always @(posedge clk or posedge reset) begin
		if (reset) begin
		  	index <= 0;
			data_recived_flag <= 0;
			trans_counter <= 0;
			f_error_flag <= 0;
		end else begin
			//If the module enable signal is 0 do nothing 
			if (!Rx_EN) begin
				index <= 0;
				data_recived_flag <= 0;
			end else begin
				//Don't start transmitting unless you have the start bit   
				if (!start_reciving_flag) begin
					index <= 0;
					if (data_prossecing_done) begin
					  	f_error_flag <= 0;
					end
					data_recived_flag <= 0;
				end else begin 
					//Baud_enable is used to receive data data with the specified baud rate  
					if (baud_enable) begin
						if (trans_counter == 15) begin
							index <= index + 1;
							trans_counter <= 0;
						end else begin
							trans_counter <= trans_counter + 1; 
						end
						//Use Rx_D in order to bypass the synchronizer 
						//if (index == 0 && Rx_D) begin
						//If the start bit becomes 1 earlier than 16 cycles there is a framing error 
						if (index == 0 && Rx_D_2nd) begin
							f_error_flag <= 1;
						end
						//Use Rx_D in order to bypass the synchronizer 
						//if ((index == 10) && (~Rx_D)) begin
						//If the stop bit becomes 0 earlier than 16 cycles there is a framing error 
						if ((index == 10) && (~Rx_D_2nd)) begin
							f_error_flag <= 1;
						end
						//Use Rx_D in order to bypass the synchronizer 
						//data_to_check[index] <= Rx_D;
						//Sample 16 times per transmeter cycle 
						data_to_check[index] <= Rx_D_2nd;
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

	//Assign 8-bit message to the output regs
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


	//Parity bit calculation for the receiver end
	assign parity_to_check = ^Rx_DATA; 

	//ERROR_CHECK state block
	always @(posedge clk or posedge reset) begin
		if (reset) begin
		  	Rx_FERROR <= 0;
			Rx_PERROR <= 0;
			Rx_VALID <= 0;
			data_prossecing_done <= 0;
		end else begin
			//Don't start error checking unless all data has been received 
			if (!error_check_flag) begin
				Rx_FERROR <= 0;
				Rx_PERROR <= 0;
				Rx_VALID <= 0;
				data_prossecing_done <= 0;
			end else begin
				//If flag is 1 then a framing-error has occurred  
				if (f_error_flag) begin
					Rx_VALID <= 0;
					Rx_FERROR <= 1;
					data_prossecing_done <= 1;
				//If flag is 1 then a parity mismatch has occurred 
				end else if (data_to_check[9] != parity_to_check) begin					
					Rx_VALID <= 0;
					Rx_PERROR <= 1;
					data_prossecing_done <= 1;
				//If no flag is 1 then the message is correct and the Rx_VALID is 1 
				end else begin
					Rx_VALID <= 1;
					Rx_FERROR <= 0;
					Rx_PERROR <= 0;
					data_prossecing_done <= 1;
				end
			end
		end
	end

endmodule // UARTReciver