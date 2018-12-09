`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part B: HSYNC Implementation + Horizontal Pixel Counter
 *
 *
 * tb_hsync: Testbench of hsync. Includes the instantiation of the top level module.
 *
 *
 * Testing:
 *    -> Sets the clock and resets the circuit. The testing is done by
 *       watching the waveforms.
 *
 */

module tb_hsync;

reg reset, clk;
wire hsync;

vgacontroller VGAcontroller_INSTANCE(.resetbutton(reset), .clk(clk), .VGA_HSYNC(hsync),
                                     .VGA_RED(red), .VGA_GREEN(green), .VGA_BLUE(blue));

initial
begin
  clk = 1'b1;
  reset = 1'b1;
  #100 reset = 1'b0;
end

always #10 clk = ~clk;

endmodule
