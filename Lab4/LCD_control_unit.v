////////////////////////////////////////////////////
//Module : LCD Control Unit module 
//File : LCD_control_unit.v
//Discreption : Main LCD control module - controls when signals are issued to the LCD controller
////////////////////////////////////////////////////

module LCD_control_unit(
	clk,
	reset,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_SF_D
);

//LCD outputs
input clk, reset;
output [3:0] LCD_SF_D;
output LCD_RS, LCD_RW, LCD_EN;

// Reg for storing the message
reg [7:0] message [30:0];
//Data pass to the instruction decoder
reg [7:0] data_reg;
//FSM states
reg [3:0] next_send_state;
reg [4:0] next_control_state;
//Instruction to be send
reg [3:0] instruction;
//Upper and lower nibbles from the lcd decode module
wire [3:0] LCD_upper_4, LCD_lower_4;

//LCD enable signals from the control or send_instruction FSM 
reg LCD_EN_send, LCD_EN_cont;
//Flag to determen if the enable signal comes from the send_instruction FSM or the 
reg in_send_flag;

//Flag to determen whenever to send the upper or lower nibble
reg upper_flag;

//Flag to determen if the instruction has been send from the send_instruction FSM both upper and lower nibble
reg send_complete_flag;
//Flag to unfreeze state progression in send_instruction FSM
reg cont_flag;
//Flag to determen if the message has been send
reg message_send_flag;
//Flag to unfreeze the control FSM counter
reg cont_counter;

//FSM and message counters
reg [12:0] send_counter;
reg [21:0] control_counter;
reg [4:0] message_counter;

//Given an instruction the module decodes and assigns the appropriate LCD outputs
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

//Assign either the upper nibble or the lower 
assign LCD_SF_D = (upper_flag) ? LCD_upper_4 : LCD_lower_4;
//Assign the LCD_EN signal from either the send_instruction FSM or the cotrol FSM 
assign LCD_EN = (in_send_flag) ? LCD_EN_send : LCD_EN_cont;

//Message
always @(posedge clk or posedge reset) begin
	if (reset) begin
		message[0] <= 'h41;
		message[1] <= 'h68;
		message[2] <= 'h6d;
		message[3] <= 'h65;
		message[4] <= 'h74;
		message[5] <= 'h21;
		message[6] <= 'h21;
		message[7] <= 'h21;
		message[8] <= 'h21;
		message[9] <= 'h21;
		message[10] <= 'h21;
		message[11] <= 'h21;
		message[12] <= 'h3c;
		message[13] <= 'h33;
		message[14] <= 'h3c;
		message[15] <= 'h33;

		message[16] <= 'h43;
		message[17] <= 'h45;
		message[18] <= 'h20;
		message[19] <= 'h34;
		message[20] <= 'h33;
		message[21] <= 'h30;
		message[22] <= 'h3c;
		message[23] <= 'h33;
		message[24] <= 'h3c;
		message[25] <= 'h33;
		message[26] <= 'h21;
		message[27] <= 'h20;
		message[28] <= 'h20;
		message[29] <= 'h20;
		message[30] <= 'h23;
	end
end

//Send Instruction FSM counter
always @(posedge clk or posedge reset) begin
	if (reset) begin
		send_counter <= 'b0;
	end else begin
		//Increment counter only when the send_instruction FSM is active
		if (cont_flag) begin
			send_counter <= send_counter + 1'b1;
			//Reset the counter at the appropriate time 
			if (send_counter == 'd2080) begin
				send_counter <= 'b0;
			end
		end
	end
end

//Send Instruction FSM
always @(posedge clk or posedge reset) begin
	if (reset) begin
		upper_flag <= 'b1;
		in_send_flag <= 1'b0;
		send_complete_flag <= 1'b0;
		LCD_EN_send <= 1'b0;
		next_send_state <= 'd1;
	end else begin
		case (next_send_state)
			//State 1 wait 40ns(2cc)
			'd1:
			begin	
				//If the cont_flag is 0 then the send_instruction FSM must stay frozzen
				if ((send_counter == 'd2) && cont_flag) begin	
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd2;
				end else begin
					//Return signals to their starting state
					send_complete_flag <= 1'b0;
					//Wait 20ns(1cc) to indicate the upper nibble to be send 
					if (send_counter == 'd1) begin
						upper_flag <= 1'b1;
					end
				end
			end
			//State 2 wait 250ns(12cc) send LCD_EN signal 
			'd2:
			begin  
				if (send_counter == 'd14) begin	
					upper_flag <= 1'b1;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd3;
				end 
			end
			//State 3 wait 20ns(1cc) reset LCD_EN signal
			'd3:
			begin
				if (send_counter == 'd15) begin	
					upper_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					in_send_flag <= 1'b1;
					next_send_state <= 'd4;
				end 
			end
			//State 4 wait 1us(50cc) change to lower nibble 
			'd4:
			begin
				if (send_counter == 'd65) begin	
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd5;
				end 
			end
			//State 5 wait 40ns(2cc)
			'd5:
			begin  
				if (send_counter == 'd67) begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b1;
					next_send_state <= 'd6;
				end
			end
			//State 6 wait 250ns(12cc) send LCD_EN signal 
			'd6:
			begin
				if (send_counter == 'd79) begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;	
					next_send_state <= 'd7;
				end 
			end
			//State 7 wait 20ns(1cc) reset LCD_EN signal
			'd7:
			begin	  
				if (send_counter == 'd80) begin	
					upper_flag <= 1'b0;
					in_send_flag <= 1'b1;
					LCD_EN_send <= 1'b0;
					next_send_state <= 'd8;
				end
			end
			//State 8 wait 40us(2000) send instruction is complete 
			'd8:
			begin	  
				if (send_counter == 'd2080) begin
					upper_flag <= 1'b0;
					in_send_flag <= 1'b0;
					LCD_EN_send <= 1'b0;	
					//Flag is raised to show the instruction has been send 
					send_complete_flag <= 1'b1;
					next_send_state <= 'd1;
				end 
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

//Control FSM counter 
always @(posedge clk or posedge reset) begin
	if (reset) begin
		control_counter <= 'b0;
	end else begin
		/*Increment the counter only when the next FSM state is depentand on it insted 
			of an instruction complete signal send_complete_flag*/
		if (cont_counter) begin
		control_counter <= control_counter + 1'b1;
		end else begin
			/*If the counter reaches this value reset it to the prevoius state value in order 
				to maintain the state until the next reset */
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
		case (next_control_state)
			//State 1 wait 15ms(750000cc) and send LCD_EN signal with SF_D=0x03
			'd1:
			begin	  
				if (control_counter == 'd750000) begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd2;
				end 
			end 
			//State 2 wait 240ns(12cc) reset LCD_EN signal
			'd2:
			begin
				if (control_counter == 750012) begin
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd3;
				end 
			end 
			//State 3 wait 4.1ms(205000cc) and send LCD_EN signal with SF_D=0x03
			'd3:
			begin
				if (control_counter == 955012) begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd4;
				end 
			end
			//State 4 wait 240ns(12cc) reset LCD_EN signal
			'd4:
			begin
				if (control_counter == 955024) begin
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd5;
				end 
			end 
			//State 5 100us(5000cc) and send LCD_EN signal with SF_D=0x03
			'd5:
			begin
				if (control_counter == 960024) begin
					instruction <= 'd11;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd6;
				end 
			end
			//State 6 wait 240ns(12cc) reset LCD_EN signal
			'd6:
			begin
				if (control_counter == 960036) begin
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd7;
				end 
			end
			//State 7 wait 40us(2000cc) and send LCD_EN signal with SF_D=0x02
			'd7:
			begin
				if (control_counter == 962036) begin
					instruction <= 'd12;
					LCD_EN_cont <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd8;
				end
			end  
			//State 8 wait 240ns(12cc) reset LCD_EN signal
			'd8:
			begin
				if (control_counter == 962048) begin
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd9;
				end
			end 
			//State 9 wait 40us(2000cc) and issue function set instruction SF_D=0x28
			'd9:
			begin
				if (control_counter == 964048) begin
					instruction <= 'd5;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b1;
					cont_counter <= 1'b0;
					next_control_state <= 'd10;
				end
			end 
			//State 10 wait until instruction is done being issued and issue the next, entry mode set SF_D=0x06
			'd10:
			begin
				if (send_complete_flag) begin
					instruction <= 'd2;
					LCD_EN_cont <= 1'b0;
					//Freeze FSM in order to be unfrozen by the next state 
					cont_flag <= 1'b0;
					cont_counter <= 1'b0;
					next_control_state <= 'd11;
				end  else begin
					//Unfreeze the send instruction FSM to in order to send the instruction
					cont_flag <= 1'b1;
				end
			end 
			//State 11 wait until instruction is done being issued and issue the next, display on/off SF_D=0x0C
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
			//State 12 wait until instruction is done being issued and issue the next, display on/off SF_D=0x0C
			'd12:
			begin
				if (send_complete_flag) begin
					instruction <= 'd3;
					LCD_EN_cont <= 1'b0;
					cont_flag <= 1'b0;
					next_control_state <= 'd13;
				end else begin
					cont_flag <= 1'b1;
				end
			end  
			//State 13 wait until instruction is done being issued and issue the next, clear display SF_D=0x01
			'd13:
			begin
				if (send_complete_flag) begin
					instruction <= 'd0;
					LCD_EN_cont <= 1'b0;
					//Unfreeze control counter in order to wait for the next state 
					cont_counter <= 1'b1;
					cont_flag <= 1'b0;
					next_control_state <= 'd14;
				end else begin
					cont_flag <= 1'b1;
				end
			end 
			//State 14 wait 1.64us(82000cc) and issue set DDRAM address instruction 
			'd14:
			begin
				if (control_counter == 1046048) begin
					//Set the DDRAM address through the decode module to be send with the instruction
					data_reg <= message_counter;
					instruction <= 'd7;
					cont_flag <= 1'b1;
					cont_counter <= 1'b0;
					next_control_state <= 'd15;
				end 
			end 
			//State 15 wait until instruction is done being issued and issue the next, write data to DDRAM 
			'd15:
			begin
				if (send_complete_flag) begin
					//Increment message counter
					message_counter <= message_counter + 1'b1;
					//Assign first letter to be writen in the DDRAM 
					data_reg <= message[message_counter];
					instruction <= 'd9;
					cont_flag <= 1'b0;
					next_control_state <= 'd16;
				end  else begin
					cont_flag <= 1'b1;
				end
			end 
			/*State 16 wait until the message has been send in order to go to through the cofiguration phase again else
				wait until the insrtuction is done being issued and control the message */
			'd16:
			begin
				if (message_send_flag) begin
					instruction <= 'd5;
					message_send_flag <= 1'b0;
					cont_flag <= 1'b0;
					//Go to through the cofiguration phase again
					next_control_state <= 'd10;
				end else begin
					if (send_complete_flag) begin
						//Issue write data to DDRAM 
						instruction <= 'd9;
						cont_flag <= 1'b0;
						message_counter <= message_counter + 1'b1;
						/*If the message counter is lower than 16 we are on the first LCD line
							if not we must compensate for the invinsible display pixels*/
						if (message_counter <= 16) begin
							data_reg <= message[message_counter];
						end else begin
							data_reg <= message[message_counter-1'b1];
						end
						/*If the message counter is 16 and the previous instruction has been issued
							then skip the invinsible display pixels and set the cursor to the start of the next line*/
						if (message_counter == 16) begin
							if (send_complete_flag) begin
								data_reg <= 'h40;
								instruction <=7;
							end
						end
						//If the message has been send and the cofiguration phase can begin again
						if (message_counter == 30) begin
							message_counter <= 'b0;
							message_send_flag <= 1'b1;
						end 
						//Stay in this state until the message has been send 
					  	next_control_state <= 'd16;		
					end else begin
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