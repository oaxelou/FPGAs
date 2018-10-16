/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 
 *
 * fsm.v: counter to drive the 4 digits
 * 
 * input : clk, reset
 * output: the anode to open & the char to display
 */

module fsm(fpga_clk, clk, reset, an3, an2, an1, an0, char);

	input fpga_clk, clk, reset;
	output an3, an2, an1, an0;
	output [3:0] char;

	//reg [1:0] counter;
	reg [5:0] counter;
	reg internal_reset;
	reg an3, an2, an1, an0;
	reg [3:0] char;

	/* 4bit counter as Fine Machine State.
	* The setup time is 2 cycles. 
	* For example, in order for the An3 to light up (1->0) at 1010
	* we change the value at 1100.
	*/
	
	always @ (negedge reset) begin
		internal_reset = 1'b1;
	end
	
	always @ (posedge clk) begin
		internal_reset = 1'b0;
	end

	always @(posedge fpga_clk) begin  // edw den exw valei sth sensitivity list to internal_reset
		if(internal_reset) begin			 // epeidh to reset einai sugxronismeno sto fpga_clk
			$display("resetting..");
			//counter = 2'b11;
			counter = 6'b000001;
			
			an3 = 1'b0;
			an2 = 1'b1;
			an1 = 1'b1;
			an0 = 1'b1;
			char = 4'b0000; 
		
			// [3:0] char doesn't need to change when an3-0 (0->1) 
			// because they are not used
		end
		else begin
			$display("counter is going to change");

			case(counter)
				6'b000000: begin // decimal: 0
					char = 4'b0000;
					an3 =1'b0;
					counter = counter + 1'b1;
				end
				
				6'b001110: begin // decimal: 14
					an3 = 1'b1;
					counter = counter + 1;
				end
				
				6'b010000: begin // decimal: 16
					char = 4'b0001;
					an2 = 1'b0;
					counter = counter + 1;
				end
				
				6'b011110: begin // decimal: 30
					an2 = 1'b1;
					counter = counter + 1;
				end
				
				6'b100000: begin // decimal: 32
					char = 4'b1010;
					an1 = 1'b0;
					counter = counter + 1;
				end
				
				6'b101110: begin // decimal: 46
					an1 = 1'b1;
					counter = counter + 1;
				end
				
				6'b110000: begin // decimal: 48
					char = 4'b1111;
					an0 = 1'b0;
					counter = counter + 1;
				end
				
				6'b111110: begin // decimal: 62
					an0 = 1'b1;
					counter = counter + 1;
				end
				
				default: begin
					$display("In default: counter = %b\n", counter);
					counter = counter + 1;
				end
				
				/*state3 : begin
					counter = 2'b10;
					an3 = 1'b1; 
					an2 = 1'b0;
					char = 3'b001; 
				end
				state2 : begin 
					counter = 2'b01; 
					an2 = 1'b1; 
					an1 = 1'b0; 
					char = 4'b1010; 
				end
				state1 : begin
					counter = 2'b00;
					an1 = 1'b1; 
					an0 = 1'b0; 
					char = 4'b1111; 
				end
				state0 : begin 
					counter = 2'b11; 
					an0 = 1'b1; 
					an3 = 1'b0; 
					char = 3'b000; 
				end*/
			endcase
		end
	end
endmodule 