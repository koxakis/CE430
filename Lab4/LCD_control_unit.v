module LCD_control_unit(
	clk,
	reset,
	LCD_RC,
	LCD_RW,
	LCD_EN,
	LCD_SF_D
);

input clk, reset;
output [3:0] LCD_SF_D;
output LCD_RC, LCD_RW, LCD_EN;
reg [4:0] LCD_4_bit_out;

reg [7:0] message [30:0];

reg LCD_EN_send, LCD_EN_cont;
reg upper_flag;
reg cont_send_flag;
reg cont_control_flag;
reg data_reg;
reg in_send_flag;
reg send_state;
reg send_counter;
reg upper;
reg send_complete_flag;
reg next_send_state;
reg control_state;
reg next_control_state;
reg control_counter;
reg message_counter;
reg cont_flag;
reg message_send_flag;

LCD_inst_decode lcd_decode_0(
	.clk(clk) ,
	.reset(reset) ,
	.LCD_RC(LCD_RC) ,
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
		send_counter <= send_counter + 1'b1;
		if (send_counter == 'd2080) begin
			send_counter <= 'b0;
		end
	end
end

//Send stuff FSM
always @(posedge clk or posedge reset) begin
	if (reset) begin
		upper <= 'b0;
		in_send_flag <= 1'b0;
		send_complete_flag <= 1'b0;
	end else begin
		case (send_state)
			'd1:
			begin
				if (send_counter == 'd2 && cont_flag) begin	
					upper <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd2;
				end else begin
					upper <= 1'b1;
					in_send_flag <= 1'b0;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd1;
				end
			end
			'd2:
			begin  
				if (send_counter == 'd14) begin	
					upper <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd3;
				end else begin
					upper <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd2;
				end
			end
			'd3:
			begin
				if (send_counter == 'd15) begin	
					upper <= 1'b0;
					LCD_EN_send <= 1'b0;
					in_send_flag <= 1'b1;
					next_send_state <= 'd4;
				end else begin
					LCD_EN_send <= 1'b0;
					upper <= 1'b1;
					in_send_flag <= 1'b1;
					next_send_state <= 'd3;
				end
			end
			'd4:
			begin
				if (send_counter == 'd65) begin	
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd5;
				end else begin
					LCD_EN_send <= 1'b0;
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					next_send_state <= 'd4;
				end
			end
			'd5:
			begin  
				if (send_counter == 'd67) begin
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd6;
				end else begin
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd5;
				end
			end
			'd6:
			begin
				if (send_counter == 'd79) begin
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;	
					next_send_state <= 'd7;
				end else begin
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd6;
				end
			end
			'd7:
			begin	  
				if (send_counter == 'd80) begin	
					upper <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd8;
				end else begin
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd7;
				end
			end
			'd8:
			begin	  
				if (send_counter == 'd2080) begin
					upper <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;	
					next_send_state <= 'd0;
					send_complete_flag <= 1'b1;
				end else begin
					upper <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					send_complete_flag <= 1'b0;
					next_send_state <= 1'd0;
				end
			end
			default: 
			begin
				upper <= 'b0;
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
		message_counter <= 'b0;
	end else begin
		control_counter <= control_counter + 1'b1;
		message_counter <= message_counter + 1'b1;
		if (message_counter == 'd30) begin
			message_counter <= 1'b0;
		end
	end
end

//Control FSM
always @(posedge clk or posedge reset) begin
	if (reset) begin	
		cont_flag <= 1'b0;
	end else begin
		case (control_counter)
			'd1:
			begin	  
				if (control_counter == 'd7500000) begin
					next_control_state <= 'd2;
				end else begin
					next_control_state <= 'd1;
				end
			end 
			'd2:
			begin
				if (control_counter == 7500012) begin
					next_control_state <= 'd3;
				end else begin
					next_control_state <= 'd2;
				end
			end 
			'd3:
			begin
				if (control_counter == 7705012) begin
					next_control_state <= 'd4;
				end else begin
					next_control_state <= 'd3;
				end
			end 
			'd4:
			begin
				if (control_counter == 7500024) begin
					next_control_state <= 'd5;
				end else begin
					next_control_state <= 'd4;
				end
			end 
			'd5:
			begin
				if (control_counter == 7710024) begin
					next_control_state <= 'd6;
				end else begin
					next_control_state <= 'd5;
				end
			end
			'd6:
			begin
				if (control_counter == 7710036) begin
					next_control_state <= 'd7;
				end else begin
					next_control_state <= 'd6;		
				end
			end
			'd7:
			begin
				if (control_counter == 7712036) begin
					next_control_state <= 'd8;
				end else begin
					next_control_state <= 'd7;				
				end
			end  
			'd8:
			begin
				if (control_counter == 7712048) begin
					next_control_state <= 'd9;
				end else begin
					next_control_state <= 'd8;				
				end
			end 
			'd9:
			begin
				if (control_counter == 7714048) begin
					next_control_state <= 'd10;
				end else begin 
					next_control_state <= 'd9;				
				end
			end 
			'd10:
			begin
				if (send_complete_flag) begin
					next_control_state <= 'd11;
				end else begin
					next_control_state <= 'd10;	
				end			
			end 
			'd11:
			begin
				if (send_complete_flag) begin
					next_control_state <= 'd12;
				end else begin
					next_control_state <= 'd11;				
				end
			end
			'd12:
			begin
				if (send_complete_flag) begin
					next_control_state <= 'd13;
				end else begin
					next_control_state <= 'd12;				
				end
			end  
			'd13:
			begin
				if (send_complete_flag) begin
					next_control_state <= 'd14;
				end else begin
					next_control_state <= 'd13;				
				end
			end 
			'd14:
			begin
				if (control_counter == 7796048) begin
					next_control_state <= 'd15;
				end else begin
					next_control_state <= 'd14;	
				end
			end 
			'd15:
			begin
				if (send_complete_flag) begin
					next_control_state <= 'd16;
				end else begin
					next_control_state <= 'd15;				
				end
			end 
			'd16:
			begin
				if (message_send_flag) begin
					next_control_state <= 'd10;
				end else begin
					next_control_state <= 'd15;				
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