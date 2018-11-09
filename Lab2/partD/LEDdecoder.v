/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project1: 7-Segment display
 *
 * Part D: 16-char message display circular with a timer
 * (the same file as of part A)
 *
 * LEDdecoder: input: the character to project
 *               (active high i.e. char 'a' : 5'b01010)
 *	      output: the LEDs of the 7-Segment display
 *               (active low)
 *
 *
 * This circuit maps the binary code of a char
 * to the segments that must be opened to display
 * the char on the seven segment indicator.
 * (given that a segment is 0 when opened)
 *
 * E.g., char 'a' :
 *                  binary code: 1010
 *                  7-S-D  code: 0001000
 *                                _
 *                visual result: | |
 *                                -
 *                               | |
 */

module LEDdecoder(in, LED);
input [4:0] in;
output [7:0] LED;

reg [7:0] LED;

parameter char0 = 8'b10000001,
          char1 = 8'b11001111,
          char2 = 8'b10010010,
          char3 = 8'b10000110,
          char4 = 8'b11001100,
          char5 = 8'b10100100,
          char6 = 8'b10100000,
          char7 = 8'b10001111,
          char8 = 8'b10000000,
          char9 = 8'b10000100,
          charA = 8'b10001000,
          charB = 8'b11100000,
          charC = 8'b11110010,
          charD = 8'b11000010,
          charE = 8'b10110000,
          charF = 8'b10111000,
          charNULL = 8'b11111111,
          charPOINT =8'b01111111;

always @(in)
	case(in)
		5'b01111: LED = charF;
		5'b01110: LED = charE;
		5'b01101: LED = charD;
		5'b01100: LED = charC;
		5'b01011: LED = charB;
		5'b01010: LED = charA;
		5'b01001: LED = char9;
		5'b01000: LED = char8;
		5'b00111: LED = char7;
		5'b00110: LED = char6;
		5'b00101: LED = char5;
		5'b00100: LED = char4;
		5'b00011: LED = char3;
		5'b00010: LED = char2;
		5'b00001: LED = char1;
		5'b00000: LED = char0;
    5'b10000: LED = charNULL;
    5'b10001: LED = charPOINT;
	endcase
endmodule
