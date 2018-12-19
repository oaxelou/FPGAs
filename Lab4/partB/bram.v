module bram(clk, reset, address, output_char);
input clk, reset;
input [10:0] address;
output [7:0] output_char;

//  RAMB16_S9  : In order to incorporate this function into the design,
//   Verilog   : the forllowing instance declaration needs to be placed
//  instance   : in the body of the design code.  The instance name
// declaration : (RAMB16_S9_inst) and/or the port declarations within the
//    code     : parenthesis may be changed to properly reference and
//             : connect this function to the design.  All inputs
//             : and outputs must be connected.

//  <-----Cut code below this line---->

   // RAMB16_S9: 2k x 8 + 1 Parity bit Single-Port RAM
   //            Spartan-3E
   // Xilinx HDL Language Template, version 14.7

   RAMB16_S9 #(
      .INIT(9'h000),  // Value of output RAM registers at startup
      .SRVAL(9'h000), // Output value upon SSR assertion
      .WRITE_MODE("NO_CHANGE"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

      // The forllowing INIT_xx declarations specify the initial contents of the RAM
      // Address 0 to 255

      //Theoretical A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  a  b  c  d  e  f   g  h  i  j  k  l  m  n  o [ ]
      //Reality     [] o  n  m  l  k  j  i  h  g  f  e  d  c  b  a  P  O  N  M  L  K  J  I  H  G  F  E  D  C  B  A
      .INIT_00(256'h20_6F_6E_6D_6C_6B_6A_69_68_67_66_65_64_63_62_61_50_4F_4E_4D_4C_4B_4A_49_48_47_46_45_44_43_42_41),
      .INIT_01(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_FF),
      //            M  e  r  r  y     C  h  r  i  s  t  m  a  s  ,   y  a     f  i  l  t  h  y     a  n  i  m  a  l
      //            l  a  m  i  n  a     y  h  t  l  i  f     y  a  ,  s  a  m  t  s  i  r  h  C     y  r  r  e  M
      .INIT_02(256'h6C_61_6D_69_6E_61_20_79_68_74_6C_69_66_20_79_61_2C_73_61_6D_74_73_69_72_68_43_20_79_72_72_65_4D)
   ) RAMB16_S9_inst (
      .DO(output_char),      // 8-bit Data Output
      //.DOP(DOP),    // 1-bit parity Output
      .ADDR(address),  // 11-bit Address Input
      .CLK(clk),    // Clock
      //.DI(DI),      // 8-bit Data Input
      //.DIP(DIP),    // 1-bit parity Input
      .EN(1'b1),      // RAM Enable Input
      .SSR(reset),    // Synchronous Set/Reset Input
      .WE(1'b0)       // Write Enable Input
   );

   // End of RAMB16_S9_inst instantiation
endmodule
