`timescale 1ns / 10ps

/*
 *
 */

module tb_LCD_controller;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire LCD_E;
	wire LCD_RS;
	wire LCD_RW;
	wire [3:0] SF_D;

	// Instantiate the Unit Under Test (UUT)
	LCDcontroller LCDcontroller_inst (.clk(clk), .reset(reset), .LCD_E(LCD_E),
                     .LCD_RS(LCD_RS), .LCD_RW(LCD_RW), .SF_D(SF_D));

	initial
	begin
		clk = 1;
		reset = 0;

		#100 reset = 1;
		#100 reset = 0;

		#100000000 reset = 1;
		#100000 reset = 0;

		#100000000 reset = 1;
		#100000 reset = 0;

		#100000000 reset = 1;
		#100000 reset = 0;
	end

	always #10 clk = ~clk;

endmodule
