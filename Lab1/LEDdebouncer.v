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
   
	
	always @(posedge clk, posedge reset) begin
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