/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 
 *
 * reset_synchronizer: Synchronizes raw reset signal
 * 
 * input : clk, reset
 * output: syncronized reset
 */

module reset_synchronizer(clk, reset, new_reset);

	input clk, reset;
	output new_reset;
	reg new_reset;
	reg f1_output;

	always @(posedge clk) begin
		new_reset = f1_output;
		f1_output = reset;
	end

endmodule