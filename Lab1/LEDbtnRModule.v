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
	reg inc_flag;

	reg [3:0] message [N-1:0];

	initial
	begin
		message[0] = 4'h0;
		message[1] = 4'h1;
		message[2] = 4'h2;
		message[3] = 4'h3;
		message[4] = 4'h4;
		message[5] = 4'h5;
		message[6] = 4'h6;
		message[7] = 4'h7;
		message[8] = 4'h8;
		message[9] = 4'h9;
		message[10] = 4'ha;
		message[11] = 4'hb;
		message[12] = 4'hc;
		message[13] = 4'hd;
		message[14] = 4'he;
		message[15] = 4'hf;

		index = 1;
		char_an3 = message [index - 1];
		char_an2 = message [index ];
		char_an1 = message [index + 1];
		char_an0 = message [index + 2];
	end

	always @(posedge clk, posedge reset) 
	begin
		if (reset) 
		begin
			index <=1;
			char_an3 <= message [index - 1];
			char_an2 <= message [index ];
			char_an1 <= message [index + 1];
			char_an0 <= message [index + 2];

			inc_flag <=0;
		end else begin
			if (r_btn) 
			begin
				char_an3 <= message [index ];
				char_an2 <= message [index + 1];
				char_an1 <= message [index + 2];
				char_an0 <= message [index + 3];
				
				inc_flag <= 1;
			end
			if (!r_btn & inc_flag) 
			begin
				index <= index + 1;
				inc_flag <= 0;
			end
				
		end
	end

endmodule // LEDbtnRModule