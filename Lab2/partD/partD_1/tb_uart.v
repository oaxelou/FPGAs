`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D-1: UART communication
 *
 *
 * testbench : initializes the circuit (clock, reset, enable signals, baud rate)
 *
 * Let it run for 6000μs.
 */

module tb_uart;

wire Tx_BUSY, Tx_WR, TxD;
wire [7:0] Rx_DATA;
wire Rx_FERROR, Rx_PERROR, Rx_VALID;

reg reset, clk;
reg [2:0] baud_select;
reg Tx_EN, Rx_EN;

initial begin
  clk = 1'b1;

  baud_select = 3'b111;

  #190 reset = 1'b1;
  #1000 reset = 1'b0;

  Tx_EN = 1'b1;
  Rx_EN = 1'b1;

  #1310000 baud_select = 3'b100;
end

always #10 clk = ~clk;

uart uart_INSTANCE(.reset(reset), .clk(clk), .baud_select(baud_select),
                   .Tx_BUSY(Tx_BUSY), .Tx_WR(Tx_WR), .TxD(TxD), .Tx_EN(Tx_EN),
						       .Rx_EN(Rx_EN), .Rx_DATA(Rx_DATA), .Rx_FERROR(Rx_FERROR),
						       .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));
endmodule
