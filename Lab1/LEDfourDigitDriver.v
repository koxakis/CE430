module LEDfourDigitDriver(
	reset,
	clk,
	an3,
	an2,
	an1,
	an0,
	a,
	b,
	c,
	d,
	e,
	f,
	g	
);

input reset, clk;
output reg an3, an2, an1, an0;
output reg a, b, c, d, e, f, g;

reg [3:0] char;
reg [3:0] state;
wire [7:0] LED;

// DCM_SP: Digital Clock Manager
   //         Spartan-6
   // Xilinx HDL Language Template, version 14.7

   DCM_SP #(
	  .CLKDV_DIVIDE(16.0),                   // CLKDV divide value
											// (1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,9,10,11,12,13,14,15,16).
	  .CLKFX_DIVIDE(1),                     // Divide value on CLKFX outputs - D - (1-32)
	  .CLKFX_MULTIPLY(4),                   // Multiply value on CLKFX outputs - M - (2-32)
	  .CLKIN_DIVIDE_BY_2("FALSE"),          // CLKIN divide by two (TRUE/FALSE)
	  .CLKIN_PERIOD(10.0),                  // Input clock period specified in nS
	  .CLKOUT_PHASE_SHIFT("NONE"),          // Output phase shift (NONE, FIXED, VARIABLE)
	  .CLK_FEEDBACK("1X"),                  // Feedback source (NONE, 1X, 2X)
	  .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SYSTEM_SYNCHRNOUS or SOURCE_SYNCHRONOUS
	  .DFS_FREQUENCY_MODE("LOW"),           // Unsupported - Do not change value
	  .DLL_FREQUENCY_MODE("LOW"),           // Unsupported - Do not change value
	  .DSS_MODE("NONE"),                    // Unsupported - Do not change value
	  .DUTY_CYCLE_CORRECTION("TRUE"),       // Unsupported - Do not change value
	  .FACTORY_JF(16'hc080),                // Unsupported - Do not change value
	  .PHASE_SHIFT(0),                      // Amount of fixed phase shift (-255 to 255)
	  .STARTUP_WAIT("FALSE")                // Delay config DONE until DCM_SP LOCKED (TRUE/FALSE)
   )
   DCM_SP_inst (
	  .CLK0(CLK0),         // 1-bit output: 0 degree clock output
	 // .CLK180(CLK180),     // 1-bit output: 180 degree clock output
	 // .CLK270(CLK270),     // 1-bit output: 270 degree clock output
	 // .CLK2X(CLK2X),       // 1-bit output: 2X clock frequency clock output
	 // .CLK2X180(CLK2X180), // 1-bit output: 2X clock frequency, 180 degree clock output
	 // .CLK90(CLK90),       // 1-bit output: 90 degree clock output
	  .CLKDV(CLKDV),       // 1-bit output: Divided clock output
	 // .CLKFX(CLKFX),       // 1-bit output: Digital Frequency Synthesizer output (DFS)
	 // .CLKFX180(CLKFX180), // 1-bit output: 180 degree CLKFX output
	  .LOCKED(LOCKED),     // 1-bit output: DCM_SP Lock Output
	 // .PSDONE(PSDONE),     // 1-bit output: Phase shift done output
	 // .STATUS(STATUS),     // 8-bit output: DCM_SP status output
	  .CLKFB(CLK0),       // 1-bit input: Clock feedback input
	  .CLKIN(clk),// 1-bit input: Clock input
	  //.DSSEN(DSSEN),       // 1-bit input: Unsupported, specify to GND.
	  //.PSCLK(PSCLK),       // 1-bit input: Phase shift clock input
		//.PSEN(PSEN),         // 1-bit input: Phase shift enable
		//.PSINCDEC(PSINCDEC), // 1-bit input: Phase shift increment/decrement input
	  .RST(reset)            // 1-bit input: Active high reset input
   );

   // End of DCM_SP_inst instantiation

	always @(posedge CLKDV, posedge reset) begin
		if (reset) begin
		  state <= 4'b0000;
		end else begin
		  state <= state + 1'b1;
		end
	end

	LEDdecoder leddecoder_0(
	.char(char),
	.LED(LED)
	);
   
	// TO-DO to be changed to module instansiation 
   always @(state) begin
	case (state)
		4'b0010: 
			begin
	  			an0 <= 1;
				an1 <= 1;
				an2 <= 1;
				an3 <= 0;

				a <= 1;
				b <= 0;
				c <= 0; 
				d <= 1;
				e <= 1;
				f <= 1;
				g <= 1;
			end
		4'b0110: 
			begin
	  			an0 <= 1;
				an1 <= 1;
				an2 <= 0;
				an3 <= 1;

				a <= 0;
				b <= 0;
				c <= 0; 
				d <= 1;
				e <= 1;
				f <= 1;
				g <= 1;
			end
		4'b1010:
			begin
	  			an0 <= 1;
				an1 <= 0;
				an2 <= 1;
				an3 <= 1;

				a <= 1;
				b <= 0;
				c <= 0; 
				d <= 1;
				e <= 1;
				f <= 1;
				g <= 1;
			end
		4'b1100:
			begin
	  			an0 <= 1;
				an1 <= 1;
				an2 <= 1;
				an3 <= 0;

				a <= 1;
				b <= 0;
				c <= 0; 
				d <= 1;
				e <= 1;
				f <= 1;
				g <= 1;
			end
	  	default:
	  		begin
	  			an0 <= 1;
				an1 <= 1;
				an2 <= 1;
				an3 <= 1;
			end
	endcase
   end


endmodule // LEDfourDigitDriver