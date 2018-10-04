`timescale 1ns / 100ps

module LEDdecoder_testbench;

reg [3:0] in;
wire [6:0] out;

LEDdecoder deco(in, out);

initial begin
in = 4'b0000;

#1 in[0] = 1;  // 0001

#1 in[1] = 1;
   in[0] = 0;  // 0010

#1 in[0] = 1;  // 0011

#1 in[2] = 1;
   in[1] = 0;
   in[0] = 0;  // 0100

#1 in[0] = 1;  // 0101

#1 in[1] = 1;
   in[0] = 0;  // 0110

#1 in[0] = 1;  // 0111

#1 in[3] = 1;
   in[2] = 0;
   in[1] = 0;
   in[0] = 0;  // 1000

#1 in[0] = 1;  // 1001

#1 in[1] = 1;
   in[0] = 0;  // 1010

#1 in[0] = 1;  // 1011

#1 in[2] = 1;
   in[1] = 0;
   in[0] = 0;  // 1100

#1 in[0] = 1;  // 1101

#1 in[1] = 1;
   in[0] = 0;  // 1110

#1 in[0] = 1;  // 1111
end 


endmodule