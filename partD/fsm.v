/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part D: 16-char message display circular with a timer
 * 
 * fsm: chooses which anode is down and the character to display
 *  
 * input: the signals clk, reset
 * output: the anode and the char
 *
 *
 * Implementation: 
 * 
 *                                            FLOW TABLE
 * 
 *     STATES     |     I N P U T S   |          O  U  T  P  U  T  S
 *                |                                      |
 *  state/counter |  reset  |  reset' | an3 | an2 | an1 | an0 ||      char
 *  --------------|---------|-----------------|----------|----||------------------
 *   init_state   | init_st | 15/1111 |  x  |  x  |  x  |  x  ||       x  
 *     15/1111    | init_st | 14/1110 |  0  |  1  |  1  |  1  || message[index  ]
 *     14/1110    | init_st | 13/1101 |  1  |  1  |  1  |  1  || message[index  ]
 *     12/1100    | init_st | 11/1011 |  1  |  1  |  1  |  1  || message[index+1] 
 *     11/1011    | init_st | 10/1010 |  1  |  0  |  1  |  1  || message[index+1] 
 *     10/1010    | init_st |  9/1001 |  1  |  1  |  1  |  1  || message[index+1] 
 *      8/1000    | init_st |  7/0111 |  1  |  1  |  1  |  1  || message[index+2] 
 *      7/0111    | init_st |  6/0110 |  1  |  1  |  0  |  1  || message[index+2] 
 *      6/0110    | init_st |  5/0101 |  1  |  1  |  1  |  1  || message[index+2]  
 *      4/0100    | init_st |  3/0011 |  1  |  1  |  1  |  1  || message[index+3] 
 *      3/0011    | init_st |  2/0010 |  1  |  1  |  1  |  0  || message[index+3]
 *      2/0010    | init_st |  1/0001 |  1  |  1  |  1  |  1  || message[index+3]  
 *      0/0000    | init_st | 15/1111 |  1  |  1  |  1  |  1  || message[index  ] 
 *     default    | init_st | state-1 |  x  |  x  |  x  |  x  ||       x  <-
 *                                                                         | 
 *                                              The x values here mean that we don't
 *                                                 care about the current value
 * How to read the table:
 * The reset & reset' columns show the next state.
 * The outputs columns show the current values of the regs.
 * If (index_change_counter == 1_1) then index = index + 1 
 * and at init_state index = 0
 */
 
 module fsm(clk, reset, an3, an2, an1, an0, char);
input clk, reset;
output an3, an2, an1, an0;
output [3:0] char;

reg [3:0] counter;
reg an3, an2, an1, an0;
reg [3:0] char;

reg [3:0] index;
reg [3:0] message [0:15];

reg [4:0] index_change_counter;
//reg [14:0] index_change_counter;	 

always @(posedge clk or posedge reset) begin
	if(reset) 
	begin
		counter = 4'b1111;
		index_change_counter = 5'b00000; //22'b0_0; 
		index = 4'b0000;
		
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
		index_change_counter = index_change_counter + 1;
		if(index_change_counter == 5'b11111)  //15'b1_1)
			index = index + 1;
		
		case(counter)
			4'b1111: 
			begin
				counter = counter - 1;
				an3 = 1'b1;
			end
			4'b1110: 
			begin
				counter = counter - 1;
				char = message[index + 1];
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
				char = message[index + 2]; 
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
				char = message[index + 3];
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
				char = message[index];
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