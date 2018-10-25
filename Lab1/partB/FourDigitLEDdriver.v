/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 4-char message display (static)
 *
 * FourDigitLEDdriver.v: TOP LEVEL MODULE
 * 
 * input : clk, reset
 * output: the anodes and the segments to open.
 *
 * It consists of the sub-modules instatiations
 * and of the wire connections between them.
 *
 * In particular, it includes a reset_synchronizer and a debounce circuit
 * for the reset signal, the DCM instance and the fsm and the LEDdecoder.
 * 
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

	reset_synchronizer rst_synchrINSTANCE(.clk(clk), 
												     .reset(reset), 
												     .new_reset(reset_synchr));  

	debounce_circuit #(.SUFFICIENT_CYCLES(10) 
							)rst_debounceINSTANCE(.clk(clk), 
													.reset_synchr(reset_synchr), 
													.reset_debounc(reset_debounce));

   DCM #(
      .SIM_MODE("SAFE"),
      .CLKDV_DIVIDE(16),
      .CLKFX_DIVIDE(1),  
      .CLKFX_MULTIPLY(4),
      .CLKIN_DIVIDE_BY_2("FALSE"),
      .CLKIN_PERIOD(0.0), 
      .CLKOUT_PHASE_SHIFT("NONE"),
      .CLK_FEEDBACK("1X"),
      .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"),
      .DFS_FREQUENCY_MODE("LOW"), 
      .DLL_FREQUENCY_MODE("LOW"), 
      .DUTY_CYCLE_CORRECTION("TRUE"), 
      .FACTORY_JF(16'hC080), 
      .PHASE_SHIFT(0),     
      .STARTUP_WAIT("FALSE")
   ) DCM_inst (
      .CLK0(fb_output),
      .CLKDV(new_clk),  
      .CLKFB(fb_output),
      .CLKIN(clk),  
      .RST(reset_debounce)
   ); 

	fsm fsmINSTANCE(.clk(new_clk), .reset(reset_debounce),
						 .an3(an3), .an2(an2), .an1(an1), .an0(an0), .char(char));

	LEDdecoder LEDdecoderINSTANCE(.in(char), .LED(LED));

	assign a  = LED[6];
	assign b  = LED[5];
	assign c  = LED[4];
	assign d  = LED[3];
	assign e  = LED[2];
	assign f  = LED[1];
	assign g  = LED[0];
	assign dp = 1'b1;

endmodule
