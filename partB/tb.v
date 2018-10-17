`timescale 1ns/1ns

/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 
 *
 * tb.v: the testbench of the partB circuit
 * 
 * 
 */

module tb;

	reg clk;
	reg reset;

	wire an3,an2,an1,an0;
	wire a,b,c,d,e,f,g,dp;

	initial begin
		clk = 1'b1;
		reset = 1'b0;
		#100 reset = 1'b1;
		#300 reset = 1'b0;
		#2000 reset = 1'b1;
		#1000 reset = ~reset;
	end

	always begin
		#10 clk = ~clk;
	end

	FourDigitLEDdriver topLevelinstance(.reset(reset), .clk(clk), 
							.an3(an3), .an2(an2), .an1(an1), .an0(an0), 
							.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

endmodule
