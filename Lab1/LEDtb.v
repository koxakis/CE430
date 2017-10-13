`timescale 1ns / 1ps

module tb_LEDsystem;

reg [3:0] in_char;
wire [7:0] out;


LEDsystem sys0(
    .char(in_char),
    .LED(out)
);

initial 
begin

    in_char = 4'h0;
    #20;
    in_char = 4'h1;
    #20;
    in_char = 4'h2;
    #20;
    in_char = 4'h3;
    #20;
	in_char = 4'h4;
	#20;
	in_char = 4'h5;
	#20;
	in_char = 4'h6;
	#20;
	in_char = 4'h7;
	#20;
	in_char = 4'h8;
	#20;
	in_char = 4'h9;
	#20;
	in_char = 4'ha;
	#20;
	in_char = 4'hb;
	#20;
	in_char = 4'hc;
	#20;
	in_char = 4'hd;
	#20;
	in_char = 4'he;
	#20;
	in_char = 4'hf;

end

endmodule
