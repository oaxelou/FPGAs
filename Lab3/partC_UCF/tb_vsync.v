`timescale 1ns / 10ps

module tb_hsync;

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
