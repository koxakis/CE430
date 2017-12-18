////////////////////////////////////////////////////
//Module : VGA BRAM Memory module
//File : VGAMemory.v
//Discreption : Instansiates and initialises BRAM
////////////////////////////////////////////////////
module VGAMemory(
	reset,
	clk,
	pixel_addr_a,
	pixel_addr_b,
	red_out_p1,
	green_out_p1,
	blue_out_p1,
	red_out_p2,
	green_out_p2,
	blue_out_p2
);

	input reset, clk;
	input [13:0] pixel_addr_a;
	input [13:0] pixel_addr_b;


	output [31:0] red_out_p1, green_out_p1, blue_out_p1;
	output [31:0] red_out_p2, green_out_p2, blue_out_p2;
	//Red color memory 

	// RAMB16BWER: 16k-bit Data and 2k-bit Parity Configurable Synchronous Dual Port Block RAM with Optional Output Registers
	//             Spartan-6
	// Xilinx HDL Language Template, version 14.7

   RAMB16BWER #(
      // DATA_WIDTH_A/DATA_WIDTH_B: 0, 1, 2, 4, 9, 18, or 36
      .DATA_WIDTH_A(36),
      .DATA_WIDTH_B(36),
      // DOA_REG/DOB_REG: Optional output register (0 or 1)
      .DOA_REG(0),
      .DOB_REG(0),
      // EN_RSTRAM_A/EN_RSTRAM_B: Enable/disable RST
      .EN_RSTRAM_A("TRUE"),
      .EN_RSTRAM_B("TRUE"),
      // INITP_00 to INITP_07: Initial memory contents.
      .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    // INIT_00 to INIT_3F: Initial memory contents.
		//Start of red-white alternate lines (2 lines per line 12 in total) 
		//			00ff   00e0	    000c0	 00a0	  0080 	   0060		0040	0020   0000
      .INIT_00(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_01(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_02(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_03(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_04(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_05(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_06(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_07(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_08(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_09(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_0A(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
	  .INIT_0B(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
	  	//End of first set of red lines
		//Start of green-white alternate lines (2 lines per line 12 in total) 
      .INIT_0C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_10(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_11(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_12(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_13(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_14(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_15(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_16(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  .INIT_17(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//End of first set of green lines
		//Start of blue-white alternate lines (2 lines per line 12 in total) 
      .INIT_18(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_19(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_20(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_21(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_22(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_23(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  	//End of first set of blue lines
		//Start of black with rgb vertical alternate lines (2 lines per line 12 in total) 
      .INIT_24(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_25(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_26(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_27(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_28(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_29(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2A(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2B(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2C(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2D(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2E(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2F(256'h99999999999999999999999999999999_11111111111111111111111111111111),
		//			00ff   00e0	    000c0	 00a0	  0080 	   0060		0040	0020   0000
	  //End of image 
      .INIT_30(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_31(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_32(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_33(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_34(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_35(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_36(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_37(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_38(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_39(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_3A(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_3B(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_3C(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_3D(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_3E(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      .INIT_3F(256'h00000000000000000000000000000000_00000000000000000000000000000000),
      // INIT_A/INIT_B: Initial values on output port
      .INIT_A(36'h000000000),
      .INIT_B(36'h000000000),
      // INIT_FILE: Optional file used to specify initial RAM contents
      .INIT_FILE("NONE"),
      // RSTTYPE: "SYNC" or "ASYNC" 
      .RSTTYPE("SYNC"),
      // RST_PRIORITY_A/RST_PRIORITY_B: "CE" or "SR" 
      .RST_PRIORITY_A("CE"),
      .RST_PRIORITY_B("CE"),
      // SIM_COLLISION_CHECK: Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
      .SIM_COLLISION_CHECK("ALL"),
      // SIM_DEVICE: Must be set to "SPARTAN6" for proper simulation behavior
      .SIM_DEVICE("SPARTAN6"),
      // SRVAL_A/SRVAL_B: Set/Reset value for RAM output
      .SRVAL_A(36'h000000000),
      .SRVAL_B(36'h000000000),
      // WRITE_MODE_A/WRITE_MODE_B: "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
      .WRITE_MODE_A("WRITE_FIRST"),
      .WRITE_MODE_B("WRITE_FIRST") 
   )
   VGA_RED_memory_inst (
      // Port A Data: 32-bit (each) output: Port A data
      .DOA(red_out_p1),       // 32-bit output: A port data output
      //.DOPA(DOPA),     // 4-bit output: A port parity output
      // Port B Data: 32-bit (each) output: Port B data
      .DOB(red_out_p2),       // 32-bit output: B port data output
      //.DOPB(DOPB),     // 4-bit output: B port parity output
      // Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals
      .ADDRA(pixel_addr_a),   // 14-bit input: A port address input
      .CLKA(clk),     // 1-bit input: A port clock input
      .ENA(1'b1),       // 1-bit input: A port enable input
      .REGCEA(1'b1), // 1-bit input: A port register clock enable input
      .RSTA(reset),     // 1-bit input: A port register set/reset input
      .WEA(4'b0000),       // 4-bit input: Port A byte-wide write enable input
      // Port A Data: 32-bit (each) input: Port A data
      //.DIA(DIA),       // 32-bit input: A port data input
      //.DIPA(DIPA),     // 4-bit input: A port parity input
      // Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals
      .ADDRB(pixel_addr_b),   // 14-bit input: B port address input
      .CLKB(clk),     // 1-bit input: B port clock input
      .ENB(1'b1),       // 1-bit input: B port enable input
      .REGCEB(1'b1), // 1-bit input: B port register clock enable input
      .RSTB(reset),     // 1-bit input: B port register set/reset input
      .WEB(4'b0000)       // 4-bit input: Port B byte-wide write enable input
      // Port B Data: 32-bit (each) input: Port B data
      //.DIB(DIB),       // 32-bit input: B port data input
      //.DIPB(DIPB)      // 4-bit input: B port parity input
   );

   // End of RAMB16BWER_inst instantiation

   //Green color memory 

	// RAMB16BWER: 16k-bit Data and 2k-bit Parity Configurable Synchronous Dual Port Block RAM with Optional Output Registers
	//             Spartan-6
	// Xilinx HDL Language Template, version 14.7

   RAMB16BWER #(
      // DATA_WIDTH_A/DATA_WIDTH_B: 0, 1, 2, 4, 9, 18, or 36
      .DATA_WIDTH_A(36),
      .DATA_WIDTH_B(36),
      // DOA_REG/DOB_REG: Optional output register (0 or 1)
      .DOA_REG(0),
      .DOB_REG(0),
      // EN_RSTRAM_A/EN_RSTRAM_B: Enable/disable RST
      .EN_RSTRAM_A("TRUE"),
      .EN_RSTRAM_B("TRUE"),
      // INITP_00 to INITP_07: Initial memory contents.
      .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
      // INIT_00 to INIT_3F: Initial memory contents.
		//Start of red-white alternate lines (2 lines per line 12 in total) 
		//			00ff		  000c0				0080				0040		0000
      .INIT_00(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_01(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_02(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_03(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_04(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_05(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_06(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_07(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_08(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_09(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  .INIT_0B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  	//End of first set of red lines
		//Start of green-white alternate lines (2 lines per line 12 in total) 
      .INIT_0C(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_0D(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_0E(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_0F(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_10(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_11(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_12(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_13(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_14(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_15(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_16(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
	  .INIT_17(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
		//End of first set of green lines
		//Start of blue-white alternate lines (2 lines per line 12 in total) 
      .INIT_18(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_19(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_20(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_21(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_22(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_23(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  	//End of first set of blue lines
		//Start of black with rgb vertical alternate lines (2 lines per line 12 in total) 
      .INIT_24(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_25(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_26(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_27(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_28(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_29(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2A(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2B(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2C(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2D(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2E(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2F(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
	  	//			00ff		  000c0				0080				0040		0000
	  //End of image 
      .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
      // INIT_A/INIT_B: Initial values on output port
      .INIT_A(36'h000000000),
      .INIT_B(36'h000000000),
      // INIT_FILE: Optional file used to specify initial RAM contents
      .INIT_FILE("NONE"),
      // RSTTYPE: "SYNC" or "ASYNC" 
      .RSTTYPE("SYNC"),
      // RST_PRIORITY_A/RST_PRIORITY_B: "CE" or "SR" 
      .RST_PRIORITY_A("CE"),
      .RST_PRIORITY_B("CE"),
      // SIM_COLLISION_CHECK: Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
      .SIM_COLLISION_CHECK("ALL"),
      // SIM_DEVICE: Must be set to "SPARTAN6" for proper simulation behavior
      .SIM_DEVICE("SPARTAN6"),
      // SRVAL_A/SRVAL_B: Set/Reset value for RAM output
      .SRVAL_A(36'h000000000),
      .SRVAL_B(36'h000000000),
      // WRITE_MODE_A/WRITE_MODE_B: "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
      .WRITE_MODE_A("WRITE_FIRST"),
      .WRITE_MODE_B("WRITE_FIRST") 
   )
   VGA_GREEN_memory_inst (
      // Port A Data: 32-bit (each) output: Port A data
      .DOA(green_out_p1),       // 32-bit output: A port data output
      //.DOPA(DOPA),     // 4-bit output: A port parity output
      // Port B Data: 32-bit (each) output: Port B data
      .DOB(green_out_p2),       // 32-bit output: B port data output
      //.DOPB(DOPB),     // 4-bit output: B port parity output
      // Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals
      .ADDRA(pixel_addr_a),   // 14-bit input: A port address input
      .CLKA(clk),     // 1-bit input: A port clock input
      .ENA(1'b1),       // 1-bit input: A port enable input
      .REGCEA(1'b1), // 1-bit input: A port register clock enable input
      .RSTA(reset),     // 1-bit input: A port register set/reset input
      .WEA(4'b0000),       // 4-bit input: Port A byte-wide write enable input
      // Port A Data: 32-bit (each) input: Port A data
      //.DIA(DIA),       // 32-bit input: A port data input
      //.DIPA(DIPA),     // 4-bit input: A port parity input
      // Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals
      .ADDRB(pixel_addr_b),   // 14-bit input: B port address input
      .CLKB(clk),     // 1-bit input: B port clock input
      .ENB(1'b1),       // 1-bit input: B port enable input
      .REGCEB(1'b1), // 1-bit input: B port register clock enable input
      .RSTB(reset),     // 1-bit input: B port register set/reset input
      .WEB(4'b0000)       // 4-bit input: Port B byte-wide write enable input
      // Port B Data: 32-bit (each) input: Port B data
      //.DIB(DIB),       // 32-bit input: B port data input
      //.DIPB(DIPB)      // 4-bit input: B port parity input
   );

   // End of RAMB16BWER_inst instantiation

   //Blue color memory 

	// RAMB16BWER: 16k-bit Data and 2k-bit Parity Configurable Synchronous Dual Port Block RAM with Optional Output Registers
	//             Spartan-6
	// Xilinx HDL Language Template, version 14.7

   RAMB16BWER #(
      // DATA_WIDTH_A/DATA_WIDTH_B: 0, 1, 2, 4, 9, 18, or 36
      .DATA_WIDTH_A(36),
      .DATA_WIDTH_B(36),
      // DOA_REG/DOB_REG: Optional output register (0 or 1)
      .DOA_REG(0),
      //.DOB_REG(0),
      // EN_RSTRAM_A/EN_RSTRAM_B: Enable/disable RST
      .EN_RSTRAM_A("TRUE"),
      //.EN_RSTRAM_B("TRUE"),
      // INITP_00 to INITP_07: Initial memory contents.
      .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
      // INIT_00 to INIT_3F: Initial memory contents.
		//Start of red-white alternate lines (2 lines per line 12 in total) 
		//			00ff		  000c0				0080			0040		   0000
      .INIT_00(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_01(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_02(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_03(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_04(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_05(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_06(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_07(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_08(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_09(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  .INIT_0B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  	//End of first set of red lines
		//Start of green-white alternate lines (2 lines per line 12 in total) 
      .INIT_0C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_10(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_11(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_12(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_13(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_14(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_15(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_16(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	  .INIT_17(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//End of first set of green lines
		//Start of blue-white alternate lines (2 lines per line 12 in total) 
      .INIT_18(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_19(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1A(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1B(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1C(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1D(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1E(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1F(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_20(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_21(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_22(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_23(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
	  	//End of first set of blue lines
		//Start of black with rgb vertical alternate lines (2 lines per line 12 in total) 
      .INIT_24(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_25(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_26(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_27(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_28(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_29(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2A(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2B(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2C(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2D(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2E(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2F(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
	  	//			00ff		  000c0				0080			0040		   0000
	  //End of image 
      .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
      // INIT_A/INIT_B: Initial values on output port
      .INIT_A(36'h000000000),
      .INIT_B(36'h000000000),
      // INIT_FILE: Optional file used to specify initial RAM contents
      .INIT_FILE("NONE"),
      // RSTTYPE: "SYNC" or "ASYNC" 
      .RSTTYPE("SYNC"),
      // RST_PRIORITY_A/RST_PRIORITY_B: "CE" or "SR" 
      .RST_PRIORITY_A("CE"),
      .RST_PRIORITY_B("CE"),
      // SIM_COLLISION_CHECK: Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
      .SIM_COLLISION_CHECK("ALL"),
      // SIM_DEVICE: Must be set to "SPARTAN6" for proper simulation behavior
      .SIM_DEVICE("SPARTAN6"),
      // SRVAL_A/SRVAL_B: Set/Reset value for RAM output
      .SRVAL_A(36'h000000000),
      .SRVAL_B(36'h000000000),
      // WRITE_MODE_A/WRITE_MODE_B: "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
      .WRITE_MODE_A("WRITE_FIRST"),
      .WRITE_MODE_B("WRITE_FIRST") 
   ) VGA_BLUE_memory_inst (
      // Port A Data: 32-bit (each) output: Port A data
      .DOA(blue_out_p1),       // 32-bit output: A port data output
      //.DOPA(DOPA),     // 4-bit output: A port parity output
      // Port B Data: 32-bit (each) output: Port B data
      .DOB(blue_out_p2),       // 32-bit output: B port data output
      //.DOPB(DOPB),     // 4-bit output: B port parity output
      // Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals
      .ADDRA(pixel_addr_a),   // 14-bit input: A port address input
      .CLKA(clk),     // 1-bit input: A port clock input
      .ENA(1'b1),       // 1-bit input: A port enable input
      .REGCEA(1'b1), // 1-bit input: A port register clock enable input
      .RSTA(reset),     // 1-bit input: A port register set/reset input
      .WEA(4'b0000),       // 4-bit input: Port A byte-wide write enable input
      // Port A Data: 32-bit (each) input: Port A data
      //.DIA(DIA),       // 32-bit input: A port data input
      //.DIPA(DIPA),     // 4-bit input: A port parity input
      // Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals
      .ADDRB(pixel_addr_b),   // 14-bit input: B port address input
      .CLKB(clk),     // 1-bit input: B port clock input
      .ENB(1'b1),       // 1-bit input: B port enable input
      .REGCEB(1'b1), // 1-bit input: B port register clock enable input
      .RSTB(reset),     // 1-bit input: B port register set/reset input
      .WEB(4'b0000)    // 4-bit input: Port B byte-wide write enable input
      // Port B Data: 32-bit (each) input: Port B data
      //.DIB(DIB),       // 32-bit input: B port data input
      //.DIPB(DIPB)      // 4-bit input: B port parity input
   );

   // End of RAMB16BWER_inst instantiation

endmodule // VGAMemory