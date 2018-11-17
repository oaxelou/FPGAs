/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part A: Baud Rate Controller
 *
 *
 * baud rate controller testbench:
 * Sets the baud_select to the 9 possible states
 * and checks if the baud_controller circuit works properly.
 *
 * The results should be the following:
 *   baud_select   |  sample_ENABLE period (ns)
 *     3'b111      |          540
 *     3'b110      |        1,080
 *     3'b101      |        1,620
 *     3'b100      |        3,260
 *     3'b011      |        6,520
 *     3'b010      |       13,020
 *     3'b001      |       52,080
 *     3'b000      |      208,340
 *
 * To notice the results run this testbench for 600μs.
 */

module tb_baud_controller;

reg clk, reset;
reg [2:0] reg_baud_select;

wire sample_ENABLE;

initial
begin
  clk = 1'b1;

  #200 reset = 1'b1;
  #100 reset = 1'b0;

  #1200 reset = 1'b1;
  #100  reset = 1'b0;

  reg_baud_select = 3'b111;
  #5000
  reg_baud_select = 3'b110;
  #5000
  reg_baud_select = 3'b101;
  #5000
  reg_baud_select = 3'b100;
  #10000
  reg_baud_select = 3'b011;
  #15000
  reg_baud_select = 3'b010;
  #30000
  reg_baud_select = 3'b001;
  #60000
  reg_baud_select = 3'b000;
end

always #10 clk = ~clk;

baud_controller baud_controllerINSTANCE(.reset(reset), .clk(clk), .
    baud_select(reg_baud_select), .sample_ENABLE(sample_ENABLE));

endmodule
