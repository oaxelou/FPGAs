`timescale 1ns / 10ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:08:40 12/19/2018
// Design Name:   bram
// Module Name:   C:/Users/oaxel/Desktop/ce430/Lab4/partB/tb_bram.v
// Project Name:  partB
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_bram;

	// Inputs
	reg clk;
	reg reset;
	reg [10:0] address;

	// Outputs
	wire [7:0] output_char;

	// Instantiate the Unit Under Test (UUT)
	bram uut (
		.clk(clk), 
		.reset(reset), 
		.address(address), 
		.output_char(output_char)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 0;
		address = 0;

		// Wait 100 ns for global reset to finish
		#100 reset = 1'b1;
		#100 reset = 1'b0;
	end
   
	always #10 clk = ~clk;
	
	always @ (posedge clk)
	begin
		address = address + 1;
	end
	
endmodule

