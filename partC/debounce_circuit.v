/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: debounce circuit
 * 
 * LEDdecoder: input: synchronized reset signal
 *	      output: debounce-checked reset signal
 */
 
module debounce_circuit
	#(parameter SUFFICIENT_CYCLES = 5)
	( clk, reset_synchr, reset_debounc);
	input clk, reset_synchr;
	output reset_debounc;	
	reg reset_debounc;

	reg ff1;
	reg ff2;

	integer counter;

	always @(posedge clk) begin
		ff2 = ff1;
		ff1 = reset_synchr;
	
		if(ff1 == ff2) begin
		counter = counter + 1;
		end
		else
			counter = 0;
		
		if(counter >= SUFFICIENT_CYCLES)
			reset_debounc = ff1;
	end

endmodule
