////////////////////////////////////////////////////
//Module : LCD instruction decode module 
//File : LCD_inst_decode.v
//Discreption : Decodes each instruction to the appropriate signals to be send
////////////////////////////////////////////////////
module LCD_inst_decode(
	clk,
	reset,
	instruction,
	LCD_RS,
	LCD_RW,
	LCD_upper_4,
	LCD_lower_4,
	address_reg
);

input clk, reset;
input [7:0] address_reg;

output reg LCD_RS, LCD_RW;	

output reg [3:0] LCD_upper_4;
output reg [3:0] LCD_lower_4;

input [3:0] instruction;


always @(posedge clk or posedge reset) begin
	if (reset) begin
		LCD_RS <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_upper_4 <= 4'b0000;
		LCD_lower_4 <= 4'b0001;
	end else begin
		case(instruction)
			//Instruction 0 Clear Display
			'd0:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0001;
			end
			//Instruction 1 Return Cursor Home
			'd1:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0010;					
			end
			//Instruction 2 Entry Mode Set 
			'd2:
			begin
				LCD_RS <= 'b0;
				LCD_RW <= 'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0110;	
			end
			//Instruction 3 Display On/Off
			'd3:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b1100;
			end
			//Instruction 4 Cursor and Display Shift
			'd4:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0001;
				LCD_lower_4 <= 4'b0001;
			end
			//Instruction 5 Function Set
			'd5:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0010;
				LCD_lower_4 <= 4'b1000;
			end
			//Instruction 6 Set CGRAM Addres
			'd6:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= {2'b01, address_reg[5:4]};
				LCD_lower_4 <= address_reg[3:0];
			end
			//Instruction 7 Set DDRAM Address
			'd7:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= {1'b1, address_reg[6:4]};
				LCD_lower_4 <= address_reg[3:0];
			end
			//Instruction 8 Ready Busy Flag and Address
			'd8:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b1;
				LCD_upper_4 <= address_reg[7:4];
				LCD_lower_4 <= address_reg[3:0];
			end
			//Instruction 9 Write Data to CGRAM/DDRAM
			'd9:
			begin
				LCD_RS <= 1'b1;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= address_reg[7:4];
				LCD_lower_4 <= address_reg[3:0];
			end
			//Instruction 10 Read Data from CGRAM/DDRAM
			'd10:
			begin
				LCD_RS <= 1'b1;
				LCD_RW <= 1'b1;
				LCD_upper_4 <= address_reg[7:4];
				LCD_lower_4 <= address_reg[3:0];
			end
			//Instruction 11 Send 0x03 to the SF_D
			'd11:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0011;
				LCD_lower_4 <= 4'b0011;
			end
			//Instruction 12 Send 0x02 to the SF_D
			'd12:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0010;
				LCD_lower_4 <= 4'b0010;
			end
			default:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0000;
			end
		endcase
	end
end

endmodule // LCD_FSM