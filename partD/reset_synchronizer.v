/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part D: 16-char message display circular with a timer
 * 
 * reset_synchronizer: Synchronizes raw reset signal
 * 
 * input : clk, reset
 * output: syncronized reset
 *
 * Implementation: 
 *   Uses 2 flip-flops. 
 *   The first one is to ensure that there will be no setup problem
 *   and the second one is for the metastability.
 */

module reset_synchronizer(clk, reset, new_reset);

	input clk, reset;
	output new_reset;
	reg new_reset;
	reg f1_output;

	always @(posedge clk) 
		new_reset = f1_output;

	always @(posedge clk) 
		f1_output = reset;

endmodule
