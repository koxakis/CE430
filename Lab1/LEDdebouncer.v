//Denouncer module - Denounces the input button 
//Nikolaos Koxenoglou 1711 
`timescale 1ns / 1ps
module LEDdebouncer(
	clk,
	reset,
	b_noise,
	b_clean
);

   parameter DELAY = 100000;
   input clk, b_noise, reset;
   output b_clean;
   reg [16:0] count;
   reg b_clean;
   
	// The always block xors the noisy signal with the clean signal 
	always @(posedge clk or posedge reset) begin
		if ( reset) begin
			count <= 0;
		end
		else begin
	    	if (b_noise^b_clean) 
	        begin
	            if (count == DELAY)
	            begin
	                b_clean <= b_noise;
	                count <= 0;
	            end 
	            else
	            begin
	        		count <= count + 1'b1;
	            end 
	    	end 
	    	else
	           count <= 0;
	    	end
	end

endmodule // LEDdebouncer