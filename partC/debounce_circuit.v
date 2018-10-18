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
	( clk, button_input, button_output);
	input clk, button_input;
	output button_output;	
	reg button_output;

	reg ff1;
	reg ff2;

	reg [31:0] counter;

	always @(posedge clk) begin
		//if(reset == 1'b1) begin
		
		//end
		//else begin
			ff2 = ff1;
			ff1 = button_input;
	
			if((ff1 == 1'b1 && ff2 == 1'b1) || (ff1 == 1'b0 && ff2 == 1'b0)) begin
				counter = counter + 1;
			end
			else
				counter = 0'b0;
		
			if(counter >= SUFFICIENT_CYCLES) begin
				button_output = ff1;
				counter = 0'b0;
			end
		//end
	end

endmodule
