`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D-2: UART receiver controlled by switches (inputs)
 *                         and 7-segment display (outputs)
 *
 * testbench : initializes the circuit (clock, reset, enable signals, baud rate)
 * Let it run for 6000ns.
 */

module tb_uart;

reg reset, clk;
reg [2:0] baud_select;
reg Tx_EN, Rx_EN;

wire an3, an2, an1, an0;
wire a, b, c, d, e, f, g, dp;

initial begin
  clk = 1'b1;

  baud_select = 3'b111;

  #190 reset = 1'b1;
  #1000 reset = 1'b0;

  Tx_EN = 1'b1;
  Rx_EN = 1'b1;

  //#1310000 baud_select = 3'b100;
end

always #10 clk = ~clk;

uart uart_INSTANCE(.reset(reset), .clk(clk), .baud_select(baud_select),
                   .Tx_EN(Tx_EN), .Rx_EN(Rx_EN), .an3(an3), .an2(an2), .an1(an1), .an0(an0),
						 .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));
endmodule
