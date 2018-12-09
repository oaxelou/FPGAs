`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part A: VRAM Implementation
 *
 *
 * tb_bram: testbench for the VRAM
 *
 * Testing:
 *    -> Sets the address, waits 1 cycle and then it checks
 *       if the RGB color is the one we expected.
 *       In this case, it also prints at the beginning of the
 *       sentence in display: "[OK]"
 *
 */

module tb_bram;

reg clk, reset;
reg en;
reg [13:0] address;

wire red_output, green_output, blue_output;

initial begin
  clk = 1'b1;
  reset = 1'b0;
  en = 1'b1;
  #20 reset = 1'b1;
  #40 reset = 1'b0;
  #1000;

  // ********************************************* RED AREA **********************************************
  $display("Red Area");

  address = 14'b10111111111111;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
    $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
    $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b10111100000000;
  #20;
  if(red_output == 1'b1 && green_output == 1'b0 && blue_output == 1'b0)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b10111000000000;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // **************************************** GREEN AREA **********************************************
  $display("Green Area");

  address = 14'b10001111111111;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b10001100000000;
  #20;
  if(red_output == 1'b0 && green_output == 1'b1 && blue_output == 1'b0)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b10001010000000;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // **************************************** BLUE AREA **********************************************
  $display("Blue Area");

  address = 14'b01011111111111;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b01011100000000;
  #20;
  if(red_output == 1'b0 && green_output == 1'b0 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b01011010000000;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // ************************************* VERTICAL AREA **********************************************
  $display("Vertical Multicolor Area");

  address = 14'b00101111111111;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  //  ********************** VERTICAL 8 BIT PATTERN **********************
  // the white zone
  address = 14'b00101101111111;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // the red zone
  address = 14'b00101101111110;
  #20;
  if(red_output == 1'b1 && green_output == 1'b0 && blue_output == 1'b0)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b00101101111101;
  #20;
  if(red_output == 1'b1 && green_output == 1'b0 && blue_output == 1'b0)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // the green zone
  address = 14'b00101101111100;
  #20;
  if(red_output == 1'b0 && green_output == 1'b1 && blue_output == 1'b0)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b00101101111011;
  #20;
  if(red_output == 1'b0 && green_output == 1'b1 && blue_output == 1'b0)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // the blue zone
  address = 14'b00101101111010;
  #20;
  if(red_output == 1'b0 && green_output == 1'b0 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  address = 14'b00101101111001;
  #20;
  if(red_output == 1'b0 && green_output == 1'b0 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // the white zone
  address = 14'b00101101111000;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;

  // ************************ END OF THE 8-BIT PATTERN ZONE ***********************
  address = 14'b000000011111111;
  #20;
  if(red_output == 1'b1 && green_output == 1'b1 && blue_output == 1'b1)
  $display("[OK] address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  else
  $display("address = %d: R: %b | G: %b | B: %b", address, red_output, green_output, blue_output);
  #1000;
end

always #10 clk = ~clk;

bram Bram_INSTANCE(.clk(clk), .reset(reset), .en(en), .address(address),
                      .red_output(red_output), .green_output(green_output), .blue_output(blue_output));

endmodule
