//LED right button module - keeps a message in a register memory and implements the right button behaviour  
//Nikolaos Koxenoglou 1711 
`timescale 1ns / 1ps
module LEDsimulatedButton(
	clk,
	reset,
	char_an0,
	char_an1,
	char_an2,
	char_an3
);

	parameter N = 16;
	input clk, reset;
	output reg [3:0] char_an0, char_an1, char_an2, char_an3;
	reg [3:0]index;

	reg [21:0] count;

	reg [3:0] message [N-1:0];

	always @(posedge clk or posedge reset ) begin
		if (reset)
		begin
			message[0] <= 4'h0;
			message[1] <= 4'h1;
			message[2] <= 4'h2;
			message[3] <= 4'h3;
			message[4] <= 4'h4;
			message[5] <= 4'h5;
			message[6] <= 4'h6;
			message[7] <= 4'h7;
			message[8] <= 4'h8;
			message[9] <= 4'h9;
			message[10] <= 4'ha;
			message[11] <= 4'hb;
			message[12] <= 4'hc;
			message[13] <= 4'hd;
			message[14] <= 4'he;
			message[15] <= 4'hf;
		end 
	end

	always @(posedge clk or posedge reset)
	begin
		if (reset) 
		begin
			count <= 0;
			index <= 0;
		end else begin
			//3125000 for 1 sec delay 
			if (count == 22'b1011111010111100001000) 
			begin
				count <= 0;
				index <= index + 1;
			end else begin
				count <= count + 1;
				index <= index;
			end 
		end
	end

	always @(index) 
	begin

		char_an3 <= message [index ];
		char_an2 <= message [index + 1];
		char_an1 <= message [index + 2];
		char_an0 <= message [index + 3];
		
	end

endmodule // LEDsimulatedButton