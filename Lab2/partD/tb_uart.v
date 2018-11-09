`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D: UART receiver
 *
 *
 * testbench : tests 3 cases: first one : 'AA' with parity bit: 0
 *                            second one: '55' with parity bit: 0
 *                            third one : 'CC' with parity bit: 0
 *                            fourth one: '89' with parity bit: 1
 *
 */

module tb_uart;

reg reset, clk;
reg Tx_EN, Rx_EN;
reg [2:0] baud_select;

initial begin
  clk = 1'b1;
  baud_select = 3'b111;

  #200 reset = 1'b1;
  #100 reset = 1'b0;

  Tx_EN = 1'b1;
  Rx_EN = 1'b1;
end

always #10 clk = ~clk;

uart uart_INSTANCE(.reset(reset), .clk(clk), .Tx_EN(Tx_EN), .Rx_EN(Rx_EN),
                   .baud_select(baud_select), .an1(an1), .an0(an0),
                   .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));
endmodule
