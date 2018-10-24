/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part B: 4-char message display (static)
 * 
 * fsm: chooses which anode is down and the character to display
 *  
 * input: the signals clk, reset
 * output: the anode and the char
 *
 *
 * Implementation: 
 * 
 *                                FLOW TABLE
 * 
 *     STATES        I N P U T S         O  U  T  P  U  T  S
 *
 *  state/counter |  reset  |  reset' | an3 | an2 | an1 | an0 || char
 *  -----------------------------------------------------------------
 *   init_state   | init_st |  0/0000 |  x  |  x  |  x  |  x  ||  x  
 *     15/1111    | init_st | 14/1110 |  0  |  1  |  1  |  1  ||  2     <- char: decimal values
 *     14/1110    | init_st | 13/1101 |  1  |  1  |  1  |  1  ||  2  
 *     12/1100    | init_st | 11/1011 |  1  |  1  |  1  |  1  ||  1  
 *     11/1011    | init_st | 10/1010 |  1  |  0  |  1  |  1  ||  1  
 *     10/1010    | init_st |  9/1001 |  1  |  1  |  1  |  1  ||  1  
 *      8/1000    | init_st |  7/0111 |  1  |  1  |  1  |  1  ||  6  
 *      7/0111    | init_st |  6/0110 |  1  |  1  |  0  |  1  ||  6  
 *      6/0110    | init_st |  5/0101 |  1  |  1  |  1  |  1  ||  6  
 *      4/0100    | init_st |  3/0011 |  1  |  1  |  1  |  1  ||  1  
 *      3/0011    | init_st |  2/0010 |  1  |  1  |  1  |  0  ||  1   
 *      2/0010    | init_st |  1/0001 |  1  |  1  |  1  |  1  ||  1  
 *      0/0000    | init_st | 15/1111 |  1  |  1  |  1  |  1  ||  2 
 *     default    | init_st | state-1 |  x  |  x  |  x  |  x  ||  x  <- the x value here means that we 
 *                                                                   don't care about the current value
 * How to read the table:
 * The reset & reset' columns show the next state.
 * The outputs columns show the current values of the regs.
 */

module fsm(clk, reset, an3, an2, an1, an0, char);
input clk, reset;
output an3, an2, an1, an0;
output [3:0] char;

reg [3:0] counter;
reg an3, an2, an1, an0;
reg [3:0] char;

always @(posedge clk or posedge reset) 
begin
	if(reset) 
	begin
		counter = 4'b0000;
		char = 4'b0010; 
		
		an3 = 1'b1; 
		an2 = 1'b1;
		an1 = 1'b1;
		an0 = 1'b1;
	end
	else 
	begin
		case(counter)
			4'b1111: 
			begin
				an3 = 1'b1;
				counter = counter - 1;
			end
			4'b1110: 
			begin 
				counter = counter - 1;
				char = 4'b0001;
			end
			4'b1100: 
			begin 
				counter = counter - 1; 
				an2 = 1'b0; 
			end 
			4'b1011: 
			begin 
				counter = counter - 1;
				an2 = 1'b1; 
			end	
			4'b1010: 
			begin 
				counter = counter - 1; 
				char = 4'b0110; 
			end
			4'b1000: 
			begin 
				counter = counter - 1; 
				an1 = 1'b0; 
			end 
			4'b0111: 
			begin
				counter = counter - 1;
				an1 = 1'b1;
			end
			4'b0110: 
			begin
				counter = counter - 1; 
				char = 4'b0001; 
			end
			4'b0100: 
			begin 
				counter = counter - 1; 
				an0 = 1'b0; 
			end 
			4'b0011: 
			begin
				counter = counter - 1;
				an0 = 1'b1;
			end
			4'b0010: 
			begin
				counter = counter - 1; 
				char = 4'b0010; 
			end
			4'b0000: 
			begin 
				counter = counter - 1; 
				an3 = 1'b0; 
			end
			default: counter = counter - 1;
		endcase
	end
end
endmodule 
