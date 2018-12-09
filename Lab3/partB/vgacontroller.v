/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part B: HSYNC Implementation + Horizontal Pixel Counter
 *
 * TOP LEVEL MODULE
 * vgacontroller: Top Level Module. Includes the instantiation of
 *                hsynchronizer and pixelcontroller
 *
 * input : resetbutton, clk
 * output: VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC
 */

module vgacontroller(resetbutton, clk, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC);
input resetbutton, clk;
output VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC;

hsynchronizer hsync_INSTANCE(.reset(resetbutton), .clk(clk), .hsync(VGA_HSYNC), .display_time(display_time));

pixelcontroller PixelController_INSTANCE(.reset(resetbutton), .clk(clk),
  .display_time(display_time), .red(VGA_RED), .green(VGA_GREEN), .blue(VGA_BLUE));

endmodule
