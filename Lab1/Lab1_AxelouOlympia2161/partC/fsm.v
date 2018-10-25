/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part C: button triggered message display (circular)
 * 
 * fsm: chooses which anode is down and the character to display
 *  
 * input: the signals clk, reset and button
 * output: the anode and the char
 *
 * Implementation: 
 * 
 *                                            FLOW TABLE
 * 
 *     STATES     |        I   N   P   U   T   S         |       O  U  T  P  U  T  S
 *                |                                      |
 *  state/counter |  reset  |  reset' [button | button'] | an3 | an2 | an1 | an0 ||      char
 *  --------------|---------|-----------------|----------|-----|-----|-----|-----||------------------
 *   init_state   | init_st |  0/0000 [  0    |    0   ] |  x  |  x  |  x  |  x  ||       x  
 *     15/1111    | init_st | 14/1110 [index  | index+1] |  0  |  1  |  1  |  1  || message[index  ]
 *     14/1110    | init_st | 13/1101 [index  | index+1] |  1  |  1  |  1  |  1  || message[index  ]
 *     12/1100    | init_st | 11/1011 [index  | index+1] |  1  |  1  |  1  |  1  || message[index+1] 
 *     11/1011    | init_st | 10/1010 [index  | index+1] |  1  |  0  |  1  |  1  || message[index+1] 
 *     10/1010    | init_st |  9/1001 [index  | index+1] |  1  |  1  |  1  |  1  || message[index+1] 
 *      8/1000    | init_st |  7/0111 [index  | index+1] |  1  |  1  |  1  |  1  || message[index+2] 
 *      7/0111    | init_st |  6/0110 [index  | index+1] |  1  |  1  |  0  |  1  || message[index+2] 
 *      6/0110    | init_st |  5/0101 [index  | index+1] |  1  |  1  |  1  |  1  || message[index+2]  
 *      4/0100    | init_st |  3/0011 [index  | index+1] |  1  |  1  |  1  |  1  || message[index+3] 
 *      3/0011    | init_st |  2/0010 [index  | index+1] |  1  |  1  |  1  |  0  || message[index+3]
 *      2/0010    | init_st |  1/0001 [index  | index+1] |  1  |  1  |  1  |  1  || message[index+3]  
 *      0/0000    | init_st | 15/1111 [index  | index+1] |  1  |  1  |  1  |  1  || message[index  ] 
 *     default    | init_st | state-1 [index  |  index ] |  x  |  x  |  x  |  x  ||       x  <-
 *                                                                                            | 
 *                                                                     The x values here mean that we don't
 *                                                                       care about the current value
 * How to read the table:
 * The reset & reset' columns show the next state.
 * The button & button' columns show the next value of the register index
 * The outputs columns show the current values of the regs.
 */

module fsm(clk, reset, button, an3, an2, an1, an0, char);
	input clk, reset, button;
	output an3, an2, an1, an0;
	output [3:0] char;

	reg an3, an2, an1, an0;
	reg [3:0] char;
	reg [3:0] counter;
	
	reg button_old;
	reg [4:0] index;
	reg [4:0] index_an3, index_an2, index_an1, index_an0;
	reg [3:0] message [0:15];		 

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		button_old = 1'b0;
		
		index = 5'b0000;
		index_an3 = index;
		index_an2 = index + 1;
		index_an1 = index + 2;
		index_an0 = index + 3;
	end
	else
	begin
		if(button_old == 1'b0 && button == 1'b1)
		begin
			index = index + 1;
			
			if(index[4])
				index[4] = 1'b0;
				
			index_an3 = index;
			index_an2 = index + 1;
			index_an1 = index + 2;
			index_an0 = index + 3;
		end

		if(button == 1'b0 || button == 1'b1)
			button_old = button;
	end
end

always @(posedge clk or posedge reset) 
	begin
		if(reset) 
		begin
			counter = 4'b0000;
		
			message[0]  = 4'b0000; 
			message[1]  = 4'b0001;
			message[2]  = 4'b0010;
			message[3]  = 4'b0011;

			message[4]  = 4'b0100; 
			message[5]  = 4'b0101;
			message[6]  = 4'b0110;
			message[7]  = 4'b0111;

			message[8]  = 4'b1000; 
			message[9]  = 4'b1001;
			message[10] = 4'b1010;
			message[11] = 4'b1011;
	
			message[12] = 4'b1100; 
			message[13] = 4'b1101;
			message[14] = 4'b1110;
			message[15] = 4'b1111; 
		
			an3 = 1'b1; 
			an2 = 1'b1;
			an1 = 1'b1;
			an0 = 1'b1;
		
			char = message[0];
		end
		else 
		begin
			case(counter)
				4'b1111: 
				begin
					counter = counter - 1;
					an3 = 1'b1;
				end
				4'b1110: 
				begin
					counter = counter - 1;
					char = message[index_an2[3:0]];
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
					char = message[index_an1[3:0]]; 
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
					char = message[index_an0[3:0]];
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
					char = message[index_an3[3:0]];
				end
				4'b0000: 
				begin 
					counter = counter - 1;
					an3 = 1'b0; 
				end
				default: 
				begin 
					counter = counter - 1;
				end
			endcase
		end
	end
endmodule
