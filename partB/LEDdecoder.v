module LEDdecoder(in, LED);
input [3:0] in;
output [6:0] LED;

wire in0, in1, in2, in3;

assign in3 = in[3];
assign in2 = in[2];
assign in1 = in[1];
assign in0 = in[0];

assign LED = in3 ? (in2 ? (in1 ? (in0? 7'b0111000 : 7'b0110000)  : 
                                 (in0? 7'b1000010 : 7'b1110010)) : 
                          (in1 ? (in0? 7'b1100000 : 7'b0001000)  : 
                                 (in0? 7'b0000100 : 7'b0000000))): 
                   (in2 ? (in1 ? (in0? 7'b0001111 : 7'b0100000)  :
                                 (in0? 7'b0100100 : 7'b1001100)) : 
                          (in1 ? (in0? 7'b0000110 : 7'b0010010)  : 
                                 (in0? 7'b1001111 : 7'b0000001)));

endmodule
