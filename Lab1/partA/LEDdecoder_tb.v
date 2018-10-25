`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part A: 7-Segment decoder implementation
 * 
 * LEDdecoder_testbench: tests LEDdecoder with the 16 possible inputs
 *                       and uses a counter for the correct outputs
 * For the 16 cases:
 * -> Waits 100ns
 * -> Sets stdout and input
 * -> Waits 100ns
 * -> displays time,in,out,stdout and checks output
 */

module LEDdecoder_testbench;

reg [3:0] in;
wire [6:0] out;
reg [6:0] stdout;

integer correct_cases;

parameter char0 = 7'b0000001,
          char1 = 7'b1001111,
          char2 = 7'b0010010,
          char3 = 7'b0000110,
          char4 = 7'b1001100,
          char5 = 7'b0100100,
          char6 = 7'b0100000,
          char7 = 7'b0001111,
          char8 = 7'b0000000,
          char9 = 7'b0000100,
          charA = 7'b0001000,
          charB = 7'b1100000,
          charC = 7'b1110010,
          charD = 7'b1000010,
          charE = 7'b0110000,
          charF = 7'b0111000;

LEDdecoder decoder_inst(.in(in), .LED(out));

initial 
begin
	correct_cases = 0;

	//1st
	stdout = char0;
	in = 4'b0000;	

	#100 $display("time = %t, in: %b, out: %b, stdout: %b, stdout and myout are the same: %b\n", $time, in, out, stdout, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 2nd
	#100 stdout = char1;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 3rd
	#100 stdout = char2;
	in = in + 1;
	
	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 4th
	#100 stdout = char3;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 5th
	#100 stdout = char4;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 6th
	#100 stdout = char5;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 7th
	#100 stdout = char6;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 8th
	#100 stdout = char7;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;

	// 9th
	#100 stdout = char8;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	// 10th
	#100 stdout = char9;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	// 11th
	#100 stdout = charA;
	in = in + 1;
	
	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	// 12th
	#100 stdout = charB;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	// 13th
	#100 stdout = charC;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	// 14th
	#100 stdout = charD;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	// 15th
	#100 stdout = charE;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	// 16th
	#100 stdout = charF;
	in = in + 1;

	#100 $display("time = %t, in: %b, out: %b, stdout and myout are the same: %b\n", $time, in, out, out == stdout);
	if(out == stdout)
		correct_cases = correct_cases + 1;


	#100 $display("Correct answers: %d / 16\n", correct_cases);
end

endmodule