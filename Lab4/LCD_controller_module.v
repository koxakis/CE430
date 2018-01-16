////////////////////////////////////////////////////
//Module : LCD Controller module 
//File : LCD_controller_module.v
//Discreption : Top level module for the LCD controller
////////////////////////////////////////////////////
module LCD_controller_module(
	clk,
	reset,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_SF_D
);

input clk, reset;
output [3:0] LCD_SF_D;
output LCD_RS, LCD_RW, LCD_EN;

// Module instansiation for LCD control unit
LCD_control_unit lcd_control_inst_0(
	.clk(clk) ,
	.reset(reset) ,
	.LCD_RS(LCD_RS) ,
	.LCD_RW(LCD_RW) ,
	.LCD_EN(LCD_EN) ,
	.LCD_SF_D(LCD_SF_D)
);
endmodule // LCD_controller_module