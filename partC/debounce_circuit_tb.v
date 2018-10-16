`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:37:22 10/10/2018
// Design Name:   debounce_circuit
// Module Name:   /home/olympia/ce430/lab1_partB/debounce_circuit_tb.v
// Project Name:  lab1_partB
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: debounce_circuit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module debounce_circuit_tb;

	// Inputs
	reg clk;
	reg reset_synchr;

	// Outputs
	wire reset_debounc;

	// Instantiate the Unit Under Test (UUT)
	debounce_circuit uut (
		.clk(clk), 
		.reset_synchr(reset_synchr), 
		.reset_debounc(reset_debounc)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset_synchr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
	always begin
		#160 clk = ~clk;
	end
	
	always begin
		#160 reset_synchr = ~reset_synchr;
	end
endmodule

