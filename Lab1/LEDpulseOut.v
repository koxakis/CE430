module LEDpulseOut(
	clk ,
	cont_in ,
	reset ,
	pulse
);

	input clk , reset, cont_in; 
	output reg pulse;
	reg [1:0] state;
	reg [1:0] nextstate;
	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
   
   // Compute next state of the FSM 
   always @(state, cont_in) begin
	 	case(state)
			S0:
		      begin
		         pulse <= 0;
			     if (cont_in == 1'b0)
			         nextstate <= S0;
				 else
					 nextstate <= S1;		
		      end
		      
			S1:
		      begin
		         pulse <= 1;
				 if (cont_in == 1'b0)
				    nextstate <= S0;
				 else
				    nextstate <= S2;			
		      end
		      
			S2:
			  begin
			     pulse <= 0;
			     if (cont_in == 1'b0)
			         nextstate <= S0;
			     else
			         nextstate <= S2;
		      end
		      
			default:
			  begin
			  	 pulse <= 1'bx;
			     nextstate <= 2'bxx;  
			  end
		endcase
   end
	
	  
	// Set the new state 
	always @(posedge clk, posedge reset) begin
				if(reset == 1'b1)
					state <= S0;
				else
					state <= nextstate;
	end

endmodule // LEDpulseOut