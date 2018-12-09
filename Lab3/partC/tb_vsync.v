`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part C: VSYNC Implementation + Vertical Pixel Counter
 *
 *
 * tb_vsync: Testbench of vsync. Includes the instantiation of the top level module.
 *
 *
 * Testing:
 *    -> Sets the clock and resets the circuit. The testing is done by
 *       observing the waveforms.
 *
 */

module tb_vsync;

reg reset, clk;
wire hsync, vsync, red, green, blue;

vgacontroller VGAcontroller_INSTANCE(.resetbutton(reset), .clk(clk),
                                     .VGA_HSYNC(hsync), .VGA_VSYNC(vsync),
                                     .VGA_RED(red), .VGA_GREEN(green), .VGA_BLUE(blue));
initial
begin
  clk = 1'b1;
  reset = 1'b1;
  #100 reset = 1'b0;
end

always #10 clk = ~clk;

endmodule
