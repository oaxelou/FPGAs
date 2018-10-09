module FourDigitLEDdriver(reset, clk, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);
input clk, reset;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;

wire new_clk, fb_output;
wire reset_synchr, reset_debounce;
wire [6:0] LED;
wire [3:0] char;
/*
   DCM #(
      .CLKDV_DIVIDE(16.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                          //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
      .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
      .PHASE_SHIFT(0)     // Amount of fixed phase shift from -255 to 255
   ) DCM_inst (
      .CLK0(new_clk),     // 0 degree DCM CLK output
      .CLKFB(new_clk),   // DCM clock feedback
      //.CLKDV(new_clk),   // Divided DCM CLK out (CLKDV_DIVIDE)
		.CLKIN(clk),   // Clock input (from IBUFG, BUFG or DCM)
      .RST(reset)        // DCM asynchronous reset input
   );*/
	

//     DCM     : In order to incorporate this function into the design,
//   Verilog   : the forllowing instance declaration needs to be placed
//  instance   : in the body of the design code.  The instance name
// declaration : (DCM_inst) and/or the port declarations within the
//    code     : parenthesis may be changed to properly reference and
//             : connect this function to the design.  Unused inputs
//             : and outputs may be removed or commented out.

//  <-----Cut code below this line---->

   // DCM: Digital Clock Manager Circuit
   //      Spartan-3
   // Xilinx HDL Language Template, version 14.7

   /*DCM #(
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
      .RST(reset)        // DCM asynchronous reset input
   );*/

assign new_clk = clk;

reset_synchronizer rst_synchr_inst(.clk(clk), .reset(reset), .new_reset(reset_synchr));

assign reset_debounce = reset_synchr; // aplo assign proswrino
//debounce_circuit debounceINSTANCE(.clk(new_clk), .button(reset_synchr), .reset(reset_debounce));

fsm fsmINSTANCE(.clk(new_clk), .reset(reset_debounce), .an3(an3), .an2(an2), .an1(an1), .an0(an0), .char(char));

LEDdecoder LEDdecoderINSTANCE(.in(char), .LED(LED));

assign a = LED[6];
assign b = LED[5];
assign c = LED[4];
assign d = LED[3];
assign e = LED[2];
assign f = LED[1];
assign g = LED[0];
assign dp = 1'b0;

endmodule
