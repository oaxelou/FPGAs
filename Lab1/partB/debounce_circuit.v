/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 4-char message display (static)
 * 
 * debounce_circuit: input: synchronized reset signal
 *	                 output: debounce-checked reset signal
 *
 * Implementation: 
 *   Uses 2 flip-flops to get the values of the signal 
 *   and a counter: compares the 2 ff and if the values 
 *   are the same it's incremented. 
 *   
 *   When it reaches the number SUFFICIENT_CYCLES the output
 *   is set to the (common) value of the ffs. 
 *   
 *   That's when the circuit is sure that the button has been 
 *   pressed for enough time to be considered a deliberate action.
 *
 *
 *   State Table: (assuming SUFFICIENT_CYCLES = 2)
 *                Every entry of the table is a cycle.   
 *
 *  reset_synchr |  ff1  |  ff2  |  counter  |  output
 *         x     |   x   |   x   |    0      |    x
 *         0     |   x   |   x   |    0      |    x
 *         0     |   0   |   x   |    0      |    x
 *         0     |   0   |   0   |    1      |    x
 *         0     |   0   |   0   |    2      |    0
 *         1     |   0   |   0   |    3      |    0
 *         1     |   1   |   0   |    0      |    0
 *         1     |   1   |   1   |    1      |    0
 *         1     |   1   |   1   |    2      |    1
 *                          ...
 */
 
module debounce_circuit
	#(parameter SUFFICIENT_CYCLES = 5)
	( clk, reset_synchr, reset_debounc);
	input clk, reset_synchr;
	output reset_debounc;	
	
	reg reset_debounc;
	reg ff1, ff2;
	reg[31:0] counter;

	always @(posedge clk) 
		ff2 = ff1;
	
	always @(posedge clk)
		ff1 = reset_synchr;
	
	always @(posedge clk)
	begin
		if((ff1 == 1'b1 && ff2 == 1'b1) || (ff1 == 1'b0 && ff2 == 1'b0))
			counter = counter + 1;
		else
			counter = 0;
		
		if(counter >= SUFFICIENT_CYCLES)
			reset_debounc = ff1;
	end

endmodule
