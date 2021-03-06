/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D-1: transmitter implementation
 *
 *
 * synchronizer: Synchronizes the reset signal
 *
 * input : clk, input_signal
 * output: syncronized signal
 *
 * Implementation:
 *   Uses 2 flip-flops.
 *   The first one is to ensure that there will be no setup problem
 *   and the second one is for the metastability.
 */

module synchronizer(clk, input_signal, output_signal);
	input clk, input_signal;
	output output_signal;

	reg output_signal, ff1_output;

	always @(posedge clk)
		output_signal = ff1_output;

	always @(posedge clk)
		ff1_output = input_signal;
endmodule
