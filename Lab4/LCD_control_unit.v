module LCD_control_unit(
	clk,
	reset,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_SF_D
);

input clk, reset;
output [3:0] LCD_SF_D;
output LCD_RS, LCD_RW, LCD_EN;

reg [7:0] message [30:0];

reg LCD_EN_send, LCD_EN_cont;
reg upper_flag;
reg [7:0] data_reg;
reg in_send_flag;

reg [3:0] send_state;
reg [3:0] next_send_state;
reg [4:0] control_state;
reg [4:0] next_control_state;

reg [12:0] send_counter;
reg send_complete_flag;

reg [21:0] control_counter;
reg [4:0] message_counter;
reg cont_flag;
reg message_send_flag;
reg [3:0] instruction;
reg cont_counter;

wire [3:0] LCD_upper_4, LCD_lower_4;

LCD_inst_decode lcd_decode_0(
	.clk(clk) ,
	.reset(reset) ,
	.instruction(instruction) ,
	.LCD_RS(LCD_RS) ,
	.LCD_RW(LCD_RW) ,
	.LCD_upper_4(LCD_upper_4) ,
	.LCD_lower_4(LCD_lower_4) ,
	.address_reg(data_reg)
);

assign LCD_SF_D = (upper_flag) ? LCD_upper_4 : LCD_lower_4;
assign LCD_EN = (in_send_flag) ? LCD_EN_send : LCD_EN_cont;

//Message
always @(posedge clk or posedge reset) begin
	if (reset) begin
		message[0] <= 'h48;
		message[1] <= 'h69;
		message[2] <= 'h20;
		message[3] <= 'h4f;
		message[4] <= 'h6c;
		message[5] <= 'h76;
		message[6] <= 'h6d;
		message[7] <= 'h70;
		message[8] <= 'h69;
		message[9] <= 'h61;
		message[10] <= 'h21;
		message[11] <= 'h21;
		message[12] <= 'h20;
		message[13] <= 'h20;
		message[14] <= 'h20;
		message[15] <= 'h20;

		message[16] <= 'h43;
		message[17] <= 'h45;
		message[18] <= 'h20;
		message[19] <= 'h34;
		message[20] <= 'h33;
		message[21] <= 'h30;
		message[22] <= 'h3c;
		message[23] <= 'h33;
		message[24] <= 'h20;
		message[25] <= 'h20;
		message[26] <= 'h20;
		message[27] <= 'h20;
		message[28] <= 'h20;
		message[29] <= 'h20;
		message[30] <= 'h20;
	end
end

//Counters

always @(posedge clk or posedge reset) begin
	if (reset) begin
		send_state <= 'd1;
	end else begin
		send_state <= next_send_state;
	end
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
		send_counter <= 'b0;
	end else begin
		if (cont_flag) begin
			send_counter <= send_counter + 1'b1;
			if (send_counter == 'd2083) begin
				send_counter <= 'b0;
			end
		end
	end
end

//Send stuff FSM
always @(posedge clk or posedge reset) begin
	if (reset) begin
		upper_flag <= 'b1;
		in_send_flag <= 1'b0;
		send_complete_flag <= 1'b0;
		LCD_EN_send <= 1'b0;
		next_send_state <= 'd1;
	end else begin
		case (send_state)
			'd1:
			begin
				if ((send_counter == 'd2) && cont_flag) begin	
					upper_flag <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd2;
				end else begin
					send_complete_flag <= 1'b0;
					/*else begin
					upper_flag <= 1'b1;
					in_send_flag <= 1'b0;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd1;
				end */
				end
			end
			'd2:
			begin  
				if (send_counter == 'd14) begin	
					upper_flag <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd3;
				end /*else begin
					upper_flag <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd2;
				end */
			end
			'd3:
			begin
				if (send_counter == 'd16) begin	
					upper_flag <= 1'b0;
					LCD_EN_send <= 1'b0;
					in_send_flag <= 1'b1;
					next_send_state <= 'd4;
				end /*else begin
					LCD_EN_send <= 1'b0;
					upper_flag <= 1'b1;
					in_send_flag <= 1'b1;
					next_send_state <= 'd3;
				end */
			end
			'd4:
			begin
				if (send_counter == 'd66) begin	
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd5;
				end /*else begin
					LCD_EN_send <= 1'b0;
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					next_send_state <= 'd4;
				end */
			end
			'd5:
			begin  
				if (send_counter == 'd68) begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd6;
				end /*else begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd5;
				end */
			end
			'd6:
			begin
				if (send_counter == 'd80) begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;	
					next_send_state <= 'd7;
				end /* else begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd6;
				end */
			end
			'd7:
			begin	  
				if (send_counter == 'd82) begin	
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd8;
				end /* else begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd7;
				end */
			end
			'd8:
			begin	  
				if (send_counter == 'd2082) begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b0;
					LCD_EN_send <= 1'b0;	
					send_complete_flag <= 1'b1;
					next_send_state <= 'd1;
				end /*else begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					send_complete_flag <= 1'b0;
					next_send_state <= 1'd0;
				end*/
			end
			default: 
			begin
				upper_flag <= 'b0;
				in_send_flag <= 1'b0;
				send_complete_flag <= 1'b0;
			end
		endcase
	end
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
		control_state <= 'd1;
	end else begin
		control_state <= next_control_state;
	end
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
		control_counter <= 'b0;
	end else begin
		if (cont_counter) begin
		control_counter <= control_counter + 1'b1;
		end else begin
			if (control_counter == 1046049) begin
				control_counter <= 'd964048;
			end
		end
	end
end

//Control FSM
always @(posedge clk or posedge reset) begin
	if (reset) begin	
		cont_flag <= 1'b0;
		message_counter <= 'd0;
		next_control_state <= 'd1;
		message_send_flag <= 1'b0;
		cont_counter <= 1'b1;
		LCD_EN_cont <= 1'b0;
		data_reg <= 'd0;
		instruction <= 'd0;
	end else begin
		case (control_state)
			'd1:
			begin	  
				if (control_counter == 'd750000) begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd2;
				end /*else begin
					instruction <= 'd0;
					LCD_EN_cont <= 1'b0;
					next_control_state <= 'd1;
				end */
			end 
			'd2:
			begin
				if (control_counter == 750012) begin
					instruction <= 'd13;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd3;
				end /*else begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					next_control_state <= 'd2;
				end*/
			end 
			'd3:
			begin
				if (control_counter == 955012) begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd4;
				end /*else begin
					instruction <= 'd0;
					LCD_EN_cont <= 1'b0;
					next_control_state <= 'd3;
				end*/
			end 
			'd4:
			begin
				if (control_counter == 955024) begin
					instruction <= 'd13;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd5;
				end /*else begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					next_control_state <= 'd4;
				end */
			end 
			'd5:
			begin
				if (control_counter == 960024) begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd6;
				end /* else begin
					instruction <= 'd0;
					LCD_EN_cont <= 1'b0;
					next_control_state <= 'd5;
				end */
			end
			'd6:
			begin
				if (control_counter == 960036) begin
					instruction <= 'd13;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd7;
				end /*else begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					next_control_state <= 'd6;		
				end */
			end
			'd7:
			begin
				if (control_counter == 962036) begin
					instruction <= 'd12;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd8;
				end/* else begin
					instruction <= 'd0;
					LCD_EN_cont <= 1'b0;
					next_control_state <= 'd7;				
				end */
			end  
			'd8:
			begin
				if (control_counter == 962048) begin
					instruction <= 'd13;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd9;
				end/* else begin
					instruction <= 'd12;
					LCD_EN_cont <= 1'b1;
					next_control_state <= 'd8;				
				end*/
			end 
			'd9:
			begin
				if (control_counter == 964048) begin
					instruction <= 'd5;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b1;
					cont_counter <= 1'b0;
					next_control_state <= 'd10;
				end/* else begin 
					instruction <= 'd0;
					LCD_EN_cont <= 1'b0;
					next_control_state <= 'd9;				
				end */
			end 
			'd10:
			begin
				if (send_complete_flag) begin
					instruction <= 'd2;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					cont_counter <= 1'b0;
					next_control_state <= 'd11;
				end  else begin
					cont_flag <= 1'b1;
				end
			end 
			'd11:
			begin
				if (send_complete_flag) begin
					instruction <= 'd3;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd12;
				end else begin
					cont_flag <= 1'b1;
				end
			end
			'd12:
			begin
				if (send_complete_flag) begin
					instruction <= 'd13;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd13;
				end  else begin
					cont_flag <= 1'b1;
				end
			end  
			'd13:
			begin
				if (send_complete_flag) begin
					instruction <= 'd13;
					LCD_EN_cont <= 1'b0;
					cont_counter <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd14;
				end else begin
					cont_flag <= 1'b1;
				end
			end 
			'd14:
			begin
				if (control_counter == 1046048) begin
					data_reg <= message[message_counter];
					instruction <= 'd7;
					cont_flag <= 1'b1;
					cont_counter <= 1'b0;
					next_control_state <= 'd15;
				end /*else begin
					cont_counter <= 1'b1;
					next_control_state <= 'd14;	
				end */
			end 
			'd15:
			begin
				if (send_complete_flag) begin
					data_reg <= message[message_counter];
					instruction <= 'd9;
					cont_flag <= 1'b0;
					next_control_state <= 'd16;
				end  else begin
					cont_flag <= 1'b1;
				end
			end 
			'd16:
			begin
				if (message_send_flag) begin
					instruction <= 'd5;
					message_send_flag <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd10;
				end else begin
					if (send_complete_flag) begin
						instruction <= 'd7;
						cont_flag <= 1'b0;
						message_counter <= message_counter + 1'b1;
						if (message_counter == 31) begin
							message_counter <= 'b0;
							message_send_flag <= 1'b1;
						end 
					  	next_control_state <= 'd15;		
					end else begin
						/*data_reg <= message[message_counter];
						message_counter <= message_counter + 1'b1;
						if (message_counter == 31) begin
							message_counter <= 'b0;
							message_send_flag <= 1'b1;
						end */
						cont_flag <= 1'b1;
					end
				end
			end 			 
			default: 
			begin
				cont_flag <= 1'b0;
			end
		endcase
	end
end

endmodule // LCD_control_unit