`timescale 1ns/10ps

/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part C: button triggered 16-char message display (circular)
 * (the same file as of part B)  
 * 
 * tb.v: the testbench of the partB circuit
 * 
 * Tests the button: 
 * 1) It sends 2 signals with bouncing at posedge and at negedge
 * 2) then sends 2 signals with no bouncing
 */

module tb;

	reg clk;
	reg reset;
	reg button;

	wire an3,an2,an1,an0;
	wire a,b,c,d,e,f,g,dp;

	initial begin
		clk = 1'b1;
		button = 1'b0;
		
		#100 reset = 1'b1;
		#5 reset = 1'b0;
		#15 reset = 1'b1;
		#5 reset = 1'b0;
		#5 reset = 1'b1;
		#15 reset = 1'b0;
		#5 reset = 1'b1;
		#1000 reset = 1'b0;
		#5 reset = 1'b1;
		#15 reset = 1'b0;
		#5 reset = 1'b1;
		#25 reset = 1'b0;
		#5 reset = 1'b1;
		#5 reset = 1'b0;
		
		// 1st button press
		#2000 button = 1'b1;
		#5 button = 1'b0;
		#15 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		
		#1000 button = 1'b0;
		#15 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		#15 button = 1'b0;
		
		// 2nd button press
		#5200 button = 1'b1;
		#5 button = 1'b0;
		#15 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		
		#1000 button = 1'b0;
		#15 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		#5 button = 1'b0;
		#5 button = 1'b1;
		#15 button = 1'b0;
	
		
		// 3rd button press
		#5200 button = 1'b1;
		#1000 button = 1'b0;
		
		// 4th button press
		#52000 button = 1'b1;
		#10000 button = 1'b0;
	end

	always begin
		#10 clk = ~clk;
	end

	FourDigitLEDdriver topLevelinstance(.reset(reset), .button(button), .clk(clk), 
							.an3(an3), .an2(an2), .an1(an1), .an0(an0), 
							.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

endmodule
