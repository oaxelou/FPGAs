/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 
 *
 * FourDigitLEDdriver.v: TOP LEVEL MODULE
 * 
 * input : clk, reset
 * output: the anodes and the segments to open.
 */

module FourDigitLEDdriver(reset, clk, an3, an2, an1, an0,
                          a, b, c, d, e, f, g, dp);
	input clk, reset;
	output an3, an2, an1, an0;
	output a, b, c, d, e, f, g, dp;

	wire new_clk, fb_output;
	wire reset_synchr, reset_debounce;

	wire [6:0] LED;
	wire [3:0] char;

	reset_synchronizer rst_synchr_inst(.clk(clk), 
												.reset(reset), 
												.new_reset(reset_synchr));  

	debounce_circuit #(.SUFFICIENT_CYCLES(10) 
	/*I originally had 2cycles but with 320ns -> so 32cycles for 20ns*/
							)debounceINSTANCE(.clk(clk), 
													.reset_synchr(reset_synchr), 
													.reset_debounc(reset_debounce));

   DCM #(
      .SIM_MODE("SAFE"),  // Simulation: "SAFE" vs. "FAST", see "Synthesis and Simulation Design Guide" for details
      .CLKDV_DIVIDE(16), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                          //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      .CLKFX_DIVIDE(1),   // Can be any integer from 1 to 32
      .CLKFX_MULTIPLY(4), // Can be any integer from 2 to 32
      .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
      .CLKIN_PERIOD(0.0),  // Specify period of input clock
      .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
      .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
      .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                            //   an integer from 0 to 15
      .DFS_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for frequency synthesis
      .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
      .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, TRUE or FALSE
      .FACTORY_JF(16'hC080),   // FACTORY JF values
      .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
      .STARTUP_WAIT("FALSE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
   ) DCM_inst (
      .CLK0(fb_output),     // 0 degree DCM CLK output
      .CLKDV(new_clk),   // Divided DCM CLK out (CLKDV_DIVIDE)
      .CLKFB(fb_output),   // DCM clock feedback
      .CLKIN(clk),   // Clock input (from IBUFG, BUFG or DCM)
      .RST(reset_debounce)        // DCM asynchronous reset input
   ); 

// PROSWRINA ASSIGNS (antikatastash DCM & debounce kuklwmatos)
//assign new_clk = clk;
//assign reset_debounce = reset_synchr;


	fsm fsmINSTANCE(.clk(new_clk), .reset(reset_debounce), 
						.an3(an3), .an2(an2), .an1(an1), .an0(an0), 
						.char(char));

	LEDdecoder LEDdecoderINSTANCE(.in(char), .LED(LED));

	assign a = LED[6];
	assign b = LED[5];
	assign c = LED[4];
	assign d = LED[3];
	assign e = LED[2];
	assign f = LED[1];
	assign g = LED[0];
	assign dp = 1'b1;

endmodule

