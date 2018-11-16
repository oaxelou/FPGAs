/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART communication
 *
 * Part D-2: 16-char message display circular with a timer
 *
 * LEDdecoder: input: the character to project
 *                    (active high i.e. char 'a' : 4'b1010)
 *	          output: the LEDs of the 7-Segment display
 *                    (active low)
 *
 * This circuit maps the binary code of a char to the segments that
 * must be opened to display the char on the seven segment indicator.
 * (given that a segment is 0 when opened)
 *
 * E.g., char 'a' :
 *                  binary code: 1010
 *                  7-S-D  code: 0001000
 *                                _
 *                visual result: | |
 *                                -
 *                               | |
 *
 * Comments on the LEDdecoder:
 * -> The file is taken from the first project (message on a 7-segment display)
 *    but since I want now to display a specific message that does not
 *    include the character '1', I map on it the 'P' character in order to
 *    display the parity error like this : "--PE"
 *    and the frame error in the same way: "--FE"
 *
 */

module LEDdecoder(in, LED);
input [3:0] in;
output [6:0] LED;

reg [6:0] LED;

parameter char0 = 7'b0000001,
          char1 = 7'b1001111,
          char2 = 7'b0010010,
          char3 = 7'b0000110,
          char4 = 7'b1001100,
          char5 = 7'b0100100,
          char6 = 7'b0100000,
          char7 = 7'b0001111,
          char8 = 7'b0000000,
          char9 = 7'b0001100,
          charA = 7'b0001000,
          charB = 7'b1100000,
          charC = 7'b1110010,
          charD = 7'b1000010,
          charE = 7'b0110000,
          charF = 7'b0111000,
          charP = 7'b0011000;

always @(in)
	case(in)
		4'b1111: LED = charF;
		4'b1110: LED = charE;
		4'b1101: LED = charD;
		4'b1100: LED = charC;
		4'b1011: LED = charB;
		4'b1010: LED = charA;
		4'b1001: LED = char9;
		4'b1000: LED = char8;
		4'b0111: LED = char7;
		4'b0110: LED = char6;
		4'b0101: LED = char5;
		4'b0100: LED = char4;
		4'b0011: LED = char3;
		4'b0010: LED = char2;
		4'b0001: LED = charP;  // as I don't use character '1', I map 'P' on it.
		4'b0000: LED = char0;
	endcase
endmodule
