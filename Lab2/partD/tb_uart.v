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
wire Tx_BUSY, Tx_WR, TxD;

wire Tx_EN, Rx_EN;
reg reg_Tx_EN, reg_Rx_EN;

wire Rx_FERROR, Rx_PERROR, Rx_VALID;
wire an1, an0;
wire a, b, c, d, e, f, g, dp;

initial begin
  clk = 1'b1;

  #200 reset = 1'b1;
  #1000 reset = 1'b0;
  
  reg_Tx_EN = 1'b1;
  reg_Rx_EN = 1'b1;
end

assign Tx_EN = reg_Tx_EN;
assign Rx_EN = reg_Rx_EN;

always #10 clk = ~clk;

uart uart_INSTANCE(.reset(reset), .clk(clk),
                   .Tx_BUSY(Tx_BUSY), .Tx_WR(Tx_WR), .TxD(TxD), .Tx_EN(Tx_EN), 
						 .Rx_EN(Rx_EN), .an1(an1), .an0(an0), 
						 .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp),
						 .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));
endmodule
