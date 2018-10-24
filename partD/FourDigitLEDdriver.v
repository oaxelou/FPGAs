/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part D: 16-char message display circular with a timer
 * 
 * FourDigitLEDdriver.v: TOP LEVEL MODULE
 * 
 * input : clk, reset
 * output: the anodes and the segments to open.
 *
 * Implementation: 
 * 1)It connects reset with the synchronizer circuit and then 
 * with the anti-bouncer circuit. (using the old clk - 20ns).
 * 2)It drives the old clk to DCM circuit for the new clk (320ns).
 * 3)It connects theses 2 input signals to the fsm circuit which 
 * decides which characters are to display and the anode.
 * 4)Then drives the characters to the LEDdecoder to match them with
 * the segments to open. 
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

	debounce_circuit #(.SUFFICIENT_CYCLES(10) // 10 cycles of 20ns
							)debounceINSTANCE(.clk(clk), 
													.button_input(reset_synchr), 
													.button_output(reset_debounce));
	
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

	assign a = LED[6];
	assign b = LED[5];
	assign c = LED[4];
	assign d = LED[3];
	assign e = LED[2];
	assign f = LED[1];
	assign g = LED[0];
	assign dp = 1'b1;

endmodule

