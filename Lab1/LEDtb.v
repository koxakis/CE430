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

    in_char = 4'b0000;
    #20;
    in_char = 4'b0001;
    #20;
    in_char = 4'b0010;
    #20;
    in_char = 4'b0011;
    #20;
	in_char = 4'b0100;
	#20;
	in_char = 4'b0101;
	#20;
	in_char = 4'b0110;
	#20;
	in_char = 4'b0111;
	#20;
	in_char = 4'b1000;
	#20;
	in_char = 4'b1001;
	#20;
	in_char = 4'b1010;
	#20;
	in_char = 4'b1011;
	#20;
	in_char = 4'b1100;
	#20;
	in_char = 4'b1101;
	#20;
	in_char = 4'b1110;
	#20;
	in_char = 4'b1111;

end

endmodule
