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
	reg button;

	wire an3,an2,an1,an0;
	wire a,b,c,d,e,f,g,dp;

	initial begin
		clk = 1'b1;
		//reset = 1'b1;
		#1000 reset = 1'b1;
		#300 reset = 1'b0;
		/*#280; // proswrina gia thn prosomoiwsh
				// edw ksekinaei to roloi ths DCM (320ns)
		#660 reset = 1'b0; //#920 eimaste edw
		#3160;
		if(an3 == 1'b1 && an2 == 1'b0 && an1 == 1'b1 && an0 == 1'b1)
			$display("PASS (anode)");
		else
			$display("FAIL (anode)");
	
		if(a == 1 && b == 0 && c == 0 &&
			d == 1 && e == 1 && f == 1 && 
			g == 1)
			$display("PASS (char)");
		else
			$display("FAIL (char)");*/
		//#100 reset = 1'b1;
		//#100 reset = ~reset;
		
		//#800 reset = ~reset;
		//#50 reset = ~reset;
		//#1000 reset = 1'b1;
		//#700 reset = 1'b0;
		#1200 reset = 1'b1;
		#1500 reset = 1'b0;
		$display("going to push the next button in 1000ns!\n"); //4000
		#2000 button = 1'b1;
		#2000 button = 1'b0;
		$display ("button released!\n");
		$display("going to push the next button in 1000ns!\n"); //4000
		#2000 button = 1'b1;
		#2000 button = 1'b0;
		$display ("button released!\n");
		$display("going to push the next button in 1000ns!\n"); //4000
		#2000 button = 1'b1;
		#2000 button = 1'b0;
		$display ("button released!\n");
		$display("going to push the next button in 1000ns!\n"); //4000
		#2000 button = 1'b1;
		#2000 button = 1'b0;
		$display ("button released!\n");
		$display("going to push the next button in 1000ns!\n"); //4000
		#2000 button = 1'b1;
		#2000 button = 1'b0;
		$display ("button released!\n");
		
		#1000;
		
		#10 button = 1'b1;
		#10 button = 1'b0;
		#10 button = 1'b1;
		#10 button = 1'b0;
		#10 button = 1'b1;
		#10 button = 1'b0;
		#10 button = 1'b1;
		#10 button = 1'b0;   // 4 talantwseis
		
		#10 button = 1'b1;
		
		#1000 button = 1'b0;
		#10 button = 1'b1;
		#10 button = 1'b0;
		#10 button = 1'b1;
		#10 button = 1'b0;  // statheropoihsh sto 0 meta apo 2 talantwseis
	end

	always begin
		#10 clk = ~clk;
	end

	FourDigitLEDdriver topLevelinstance(.reset(reset), .nxt_button(button), .clk(clk), 
							.an3(an3), .an2(an2), .an1(an1), .an0(an0), 
							.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

endmodule
