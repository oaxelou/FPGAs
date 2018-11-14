/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part C: receiver implementation
 *
 *
 * synchronizer: Synchronizes the input of the receiver (asynchronous communication)
 *
 * input : clk, input_signal
 * output: syncronized signal
 *
 * Implementation:
 *   Uses 2 flip-flops.
 *   The first one is to ensure that there will be no setup problem
 *   and the second one is for the metastability.
 */

module channel_synchronizer(clk, reset, input_signal, output_signal);
	input clk, reset, input_signal;
	output output_signal;

	reg output_signal, ff1_output;

	always @(posedge clk or posedge reset)
		if(reset)
			output_signal = 1'b1;
		else
			output_signal = ff1_output;

	always @(posedge clk or posedge reset)
		if(reset)
			ff1_output = 1'b1;
		else
			ff1_output = input_signal;
endmodule
