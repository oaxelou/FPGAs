/* Axelou Olympia
 * oaxelou@uth.gr 
 * 2161
 * 
 * ce430
 * Project1: 7-Segment display
 *
 * Part A: 7-Segment decoder implementation
 * 
 * LEDdecoder: input: the character to project
 *               (active high i.e. char 'a' : 4'b1010)
 *	      output: the LEDs of the 7-Segment display
 *               (active low)
 */

module LEDdecoder(in, LED);
input [3:0] in;
output [6:0] LED;

parameter char0 = 7'b0000001,
          char1 = 7'b1001111,
          char2 = 7'b0010010,
          char3 = 7'b0000110,
          char4 = 7'b1001100,
          char5 = 7'b0100100,
          char6 = 7'b0100000,
          char7 = 7'b0001111,
          char8 = 7'b0000000,
          char9 = 7'b0000100,
          charA = 7'b0001000,
          charB = 7'b1100000,
          charC = 7'b1110010,
          charD = 7'b1000010,
          charE = 7'b0110000,
          charF = 7'b0111000;

assign LED = in[3] ? (in[2] ? (in[1] ? (in[0]? charF : charE)  : 
                                       (in[0]? charD : charC)) : 
                              (in[1] ? (in[0]? charB : charA)  : 
                                       (in[0]? char9 : char8))): 
                     (in[2] ? (in[1] ? (in[0]? char7 : char6)  :
                                       (in[0]? char5 : char4)) : 
                              (in[1] ? (in[0]? char3 : char2)  : 
                                       (in[0]? char1 : char0)));

endmodule
