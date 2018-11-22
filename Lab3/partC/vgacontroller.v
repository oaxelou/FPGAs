module vgacontroller(resetbutton, clk, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC);
input resetbutton, clk;
output VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC;

wire hsync, display_time, hsync_time;
wire [6:0] vert_counter;

vsynchronizer vsync_INSTANCE(.reset(resetbutton), .clk(clk), .vsync(VGA_VSYNC),
                             .hsync_time(hsync_time));
hsynchronizer hsync_INSTANCE(.reset(resetbutton), .clk(clk), .hsync_time(hsync_time),
                             .hsync(VGA_HSYNC), .display_time(display_time), .vert_counter(vert_counter));

pixelcontroller PixelController_INSTANCE(.reset(resetbutton), .clk(clk), .vert_counter(vert_counter),
  .display_time(display_time), .red(VGA_RED), .green(VGA_GREEN), .blue(VGA_BLUE));

endmodule
