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

module fsm(clk, reset, an3, an2, an1, an0, char);

	input clk, reset;
	output an3, an2, an1, an0;
	output [3:0] char;

	reg [1:0] counter;
	reg an3, an2, an1, an0;
	reg [3:0] char;

	/*parameter state15 = 4'b1111,
				 state14 = 4'b1110,
			 	 state13 = 4'b1101,
				 state12 = 4'b1100,
				 state11 = 4'b1011,
				 state10 = 4'b1010,
				 state9  = 4'b1001,
				 state8  = 4'b1000,
	parameter state7  = 3'b111,
				 state6  = 3'b110,
				 state5  = 3'b101,
				 state4  = 3'b100,*/
	parameter state3  = 2'b11,
				 state2  = 2'b10,
				 state1  = 2'b01,
				 state0  = 2'b00;

	/* 4bit counter as Fine Machine State.
	* The setup time is 2 cycles. 
	* For example, in order for the An3 to light up (1->0) at 1010
	* we change the value at 1100.
	*/
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			$display("resetting..");
			counter = 2'b11;
			
			an3 = 1'b0;
			an2 = 1'b1;
			an1 = 1'b1;
			an0 = 1'b1;
			char = 3'b000; 
		
			// [3:0] char doesn't need to change when an3-0 (0->1) 
			// because they are not used
		end
		else begin
			$display("counter is going to change");

			case(counter)
				state3 : begin
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
				end
			endcase
		end
	end
endmodule 