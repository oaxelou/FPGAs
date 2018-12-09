/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part C: VSYNC Implementation + Vertical Pixel Counter
 *
 * TOP LEVEL MODULE
 * vgacontroller: Top Level Module. Includes the instantiation of
 *                , vsynchronizerhsynchronizer and pixelcontroller
 *
 * input : resetbutton, clk
 * output: VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC
 */

module vgacontroller(resetbutton, clk, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC);
input resetbutton, clk;
output VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC;

wire [6:0] vert_counter;

vsynchronizer vsync_INSTANCE(.reset(resetbutton), .clk(clk), .vsync(VGA_VSYNC),
                             .hsync_time(hsync_time));
hsynchronizer hsync_INSTANCE(.reset(resetbutton), .clk(clk), .hsync_time(hsync_time),
                             .hsync(VGA_HSYNC), .display_time(display_time), .vert_counter(vert_counter));

pixelcontroller PixelController_INSTANCE(.reset(resetbutton), .clk(clk), .vert_counter(vert_counter),
  .display_time(display_time), .red(VGA_RED), .green(VGA_GREEN), .blue(VGA_BLUE));

endmodule
