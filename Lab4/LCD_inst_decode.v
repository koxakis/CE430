module LCD_inst_decode(
	clk,
	reset,
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


always @(posedge clk or posedge reset) begin
	if (reset) begin
		LCD_RS <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_upper_4 <= 4'b0000;
		LCD_lower_4 <= 4'b0001;
	end else begin
		case(instruction)
			0:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0001;
			end
			1:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0010;					
			end
			2:
			begin
				LCD_RS <= 'b0;
				LCD_RW <= 'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0111;	
			end
			3:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b1111;
			end
			4:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0001;
				LCD_lower_4 <= 4'b0001;
			end
			5:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0010;
				LCD_lower_4 <= 4'b1000;
			end
			6:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= {2'b01, address_reg[5:4]};
				LCD_lower_4 <= address_reg[3:0];
			end
			7:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= {1'b1, address_reg[6:4]};
				LCD_lower_4 <= address_reg[3:0];
			end
			8:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b1;
				LCD_upper_4 <= address_reg[7:4];
				LCD_lower_4 <= address_reg[3:0];
			end
			9:
			begin
				LCD_RS <= 1'b1;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= address_reg[7:4];
				LCD_lower_4 <= address_reg[3:0];
			end
			10:
			begin
				LCD_RS <= 1'b1;
				LCD_RW <= 1'b1;
				LCD_upper_4 <= address_reg[7:4];
				LCD_lower_4 <= address_reg[3:0];
			end
			//Init 0x03
			11:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0011;
			end
			//init 0x02
			12:
			begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_upper_4 <= 4'b0000;
				LCD_lower_4 <= 4'b0011;
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