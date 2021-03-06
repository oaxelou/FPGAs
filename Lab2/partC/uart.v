/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part C: UART receiver (TOP LEVEL MODULE)
 *
 * input : reset, clk, RxD, Rx_EN, baud_select,
 * output: Rx_FERROR, Rx_PERROR, Rx_VALID, Rx_DATA
 *
 * Connects the receiver circuit to the inputs and the outputs
 */

module uart(reset, clk, baud_select, RxD, Rx_EN, Rx_DATA, Rx_FERROR, Rx_PERROR, Rx_VALID);
  input reset, clk, RxD, Rx_EN;
  input [2:0] baud_select;
  output Rx_FERROR, Rx_PERROR, Rx_VALID;
  output [7:0] Rx_DATA;

  wire synchr_reset;

  synchronizer synchron_INSTANCE
    (.clk(clk), .input_signal(reset), .output_signal(synchr_reset));

  uart_receiver receiver_INSTANCE(.reset(synchr_reset), .clk(clk), .Rx_DATA(Rx_DATA),
            .baud_select(baud_select), .Rx_EN(Rx_EN), .RxD(RxD),
            .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

endmodule
