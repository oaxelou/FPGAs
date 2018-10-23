`timescale 1ns/10ps

/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 4-char message display (static)
 *
 * tb.v: the testbench of the partB circuit
 * 
 * Tests the reset button: 
 * 1) Sends a 'theoretical' reset signal (with no bouncing) 
 * 2) after 2000ns sends a more realistic signal 
 *    (bouncing at posedge and at negedge)
 */

module tb;

	reg clk;
	reg reset;

	wire an3,an2,an1,an0;
	wire a, b, c, d, e, f, g, dp;

	initial begin
		clk = 1'b1;
		reset = 1'b0;
		
		#100 reset = 1'b1;  // 1st signal
		#1250 reset = 1'b0;
		
		#2000 reset = 1'b1; // 2nd signal
		#5  reset = 1'b0;
		#10 reset = 1'b1;
		#20 reset = 1'b0;
		#10 reset = 1'b1;
		
		#250 reset = 1'b0;
		#10  reset = 1'b1;
		#15  reset = 1'b0;
		#5   reset = 1'b1;
		#10  reset = 1'b0;
	end

	always begin
		#10 clk = ~clk;
	end

	FourDigitLEDdriver topLevelinstance(.reset(reset), .clk(clk), 
							.an3(an3), .an2(an2), .an1(an1), .an0(an0), 
							.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

endmodule
