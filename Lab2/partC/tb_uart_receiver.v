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
 *                            second one: '89' with parity bit: 1
 *                            third one : 'FF' with parity bit: 0
 *
 */

module tb_uart_receiver;

reg reset, clk;
reg Tx_EN, Tx_WR, Rx_EN;
reg [7:0] Tx_DATA;

reg [7:0] Tx_DATA_buffer [0:2];
reg [1:0] word_counter;

wire Tx_BUSY, TxD;

wire [7:0] Rx_DATA_aka_output;
wire Rx_FERROR, Rx_PERROR, Rx_VALID;

initial
begin
  Tx_DATA_buffer[0] = 8'b10101010;
  Tx_DATA_buffer[1] = 8'b10001001;
  Tx_DATA_buffer[2] = 8'b11111111;
  word_counter = 2'b10;

  clk = 1'b1;

  #200 reset = 1'b1;
  #100 reset = 1'b0;

  Tx_EN = 1'b1;
  Rx_EN = 1'b1;
end

always @ (negedge Tx_BUSY) begin
  word_counter = word_counter + 1;
  if(word_counter == 2'b11)
    word_counter = 2'b00;

  Tx_DATA = Tx_DATA_buffer[word_counter];

  Tx_WR = 1'b1;
  #20 Tx_WR = 1'b0;

  $display("Gonna try transmitting %x\n", Tx_DATA_buffer[word_counter]);
end

always @ (posedge Rx_VALID) begin
  $display("received : %x%x\n", Rx_DATA_aka_output[7:4], Rx_DATA_aka_output[3:0]);
  // if(word_counter == 2'b11) begin      // uncomment to test the EN signals
  //   Tx_EN = 1'b0;
  //   Rx_EN = 1'b0;
  // end
end

always #10 clk = ~clk;

uart_transmitter uart_transmitter_instance(.reset(reset), .clk(clk), .Tx_DATA(Tx_DATA), .baud_select(3'b111),
                                           .Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

uart_receiver uart_receiver_instance(.reset(reset), .clk(clk), .Rx_DATA(Rx_DATA_aka_output),
                                     .baud_select(3'b111), .Rx_EN(Rx_EN), .RxD(TxD),
                                     .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

endmodule
