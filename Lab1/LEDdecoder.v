`timescale 1ns / 1ps

module LEDdecoder(
  char,
  LED
);

input [3:0] char;
output reg [7:0] LED;

always @(char)
begin
	case (char)
		4'h0: LED = 8'b11111111;

		4'h1: LED = 8'b10011111;
      
		4'h2: LED = 8'b00100101;

    	4'h3: LED = 8'b00001101;

    	4'h4: LED = 8'b10011001;

    	4'h5: LED = 8'b01001001;

    	4'h6: LED = 8'b01000001;

    	4'h7: LED = 8'b00011111;

    	4'h8: LED = 8'b00000001;

 		4'h9: LED = 8'b00001001;

    	4'ha: LED = 8'b00010001;

    	4'hb: LED = 8'b00000101;

    	4'hc: LED = 8'b01100011;

    	4'hd: LED = 8'b00000011;

    	4'he: LED = 8'b01100001;

    	4'hf: LED = 8'b01110001;

		default: LED = 8'b00000001;
	endcase
end  

endmodule // LEDdecoder