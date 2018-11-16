`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part B: UART transmitter
 *
 *
 * testbench : tests 4 cases: first one : 'AA' with parity bit: 0
 *                            second one: '55' with parity bit: 0
 *                            third one : 'CC' with parity bit: 0
 *                            fourth one: '89' with parity bit: 1
 * Run for 6000μs.
 */

module tb_uart;

wire Tx_BUSY, TxD;

reg reset, clk, Tx_WR;
reg [2:0] baud_select;
reg Tx_EN;

reg [7:0] Tx_DATA_buffer [0:3];
reg [7:0] Tx_DATA;

initial begin
  Tx_DATA_buffer[0] = 8'b10101010;
  Tx_DATA_buffer[1] = 8'b01010101;
  Tx_DATA_buffer[2] = 8'b11001100;
  Tx_DATA_buffer[3] = 8'b10001001;

  clk = 1'b1;

  baud_select = 3'b111;

  #190 reset = 1'b1;
  #1000 reset = 1'b0;

  Tx_EN = 1'b1;

  #1000000 if(!Tx_BUSY) begin
  Tx_DATA = Tx_DATA_buffer[0];
  $display("Gonna try transmitting %x\n", Tx_DATA);
  Tx_WR = 1'b1;
  #20 Tx_WR = 1'b0;
  end

  #1000000 if(!Tx_BUSY) begin
  Tx_DATA = Tx_DATA_buffer[1];
  $display("Gonna try transmitting %x\n", Tx_DATA);
  Tx_WR = 1'b1;
  #20 Tx_WR = 1'b0;
  end

  #1000000 if(!Tx_BUSY) begin
  Tx_DATA = Tx_DATA_buffer[2];
  $display("Gonna try transmitting %x\n", Tx_DATA);
  Tx_WR = 1'b1;
  #20 Tx_WR = 1'b0;
  end

  #1000000 if(!Tx_BUSY) begin
  Tx_DATA = Tx_DATA_buffer[3];
  $display("Gonna try transmitting %x\n", Tx_DATA);
  Tx_WR = 1'b1;
  #20 Tx_WR = 1'b0;
  end
end

always #10 clk = ~clk;

uart uart_INSTANCE(.reset(reset), .clk(clk), .baud_select(baud_select),
.Tx_DATA(Tx_DATA), .Tx_BUSY(Tx_BUSY), .Tx_WR(Tx_WR), .TxD(TxD), .Tx_EN(Tx_EN));
endmodule
