`timescale 1ns/1ns
module tb;

reg clk;
reg reset;

wire an3,an2,an1,an0;
wire a,b,c,d,e,f,g,dp;

initial begin
	clk = 1'b1;
	#100 reset = 1'b1;
	#100 reset = ~reset;
end

always begin
	#10 clk = ~clk;
end

FourDigitLEDdriver topLevelinstance(reset, clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

endmodule
