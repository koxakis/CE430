`timescale 1ns / 1ps

module LEDsystem(
  char,
  LED
);

input [3:0] char;
output [7:0] LED;


LEDdecoder leddecoder_0(
    .char(char),
    .LED(LED)
);

endmodule // LEDsystem