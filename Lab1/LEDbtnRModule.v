//LED right button module - keeps a message in a register memory and implements the right button behaviour  
//Nikolaos Koxenoglou 1711 
`timescale 1ns / 1ps
module LEDbtnRModule(
	clk,
	reset,
	r_btn,
	char_an0,
	char_an1,
	char_an2,
	char_an3
);

	parameter N = 16;
	input clk, reset, r_btn;
	output reg [3:0] char_an0, char_an1, char_an2, char_an3;
	reg [3:0]index;
	reg inc_flag, first_flag;

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

	// This always block resets the output characters to the first of the memory
	always @(posedge clk or posedge reset) 
	begin
		if (reset) 
		begin
			index <=0;
			char_an3 <= message [index ];
			char_an2 <= message [index + 1];
			char_an1 <= message [index + 2];
			char_an0 <= message [index + 3];

			inc_flag <=0;
			first_flag <=1;
		end else begin
		/* When the button is pressed the output characters are assigned from memory to the respected 
			anode the flag first_flag is used for the first loading in order to show the memory contents with out
			the need to press reset or any button*/
			if (r_btn || first_flag) 
			begin
				char_an3 <= message [index ];
				char_an2 <= message [index + 1];
				char_an1 <= message [index + 2];
				char_an0 <= message [index + 3];
				
				first_flag <= 0;
				inc_flag <= 1;
			end
			/*The index increments when the button is not pressed and the flag is high to allow the character 
			output for one extra cycle in order for the character to appear on the corresponding anode */
			if (!r_btn & inc_flag) 
			begin
				index <= index + 1;
				inc_flag <= 0;
			end
				
		end
	end

endmodule // LEDbtnRModule