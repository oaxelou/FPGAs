`timescale 1ns / 10ps

module tb_hsync;

reg reset, clk;

wire hsync, display_time;

hsynchronizer hsync_INSTANCE(.reset(reset), .clk(clk), .hsync(hsync), .display_time(display_time));

pixelcontroller PixelController_INSTANCE(.reset(reset), .clk(clk),
  .display_time(display_time), .red(red), .green(green), .blue(blue));

initial
begin
  clk = 1'b1;
  reset = 1'b1;
  #100 reset = 1'b0;
end

always #10 clk = ~clk;

endmodule
