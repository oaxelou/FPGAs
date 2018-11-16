/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D-1: UART (TOP LEVEL MODULE)
 *
 * input : reset, clk, Tx_EN, Rx_EN, baud_select
 * output: Tx_BUSY, Tx_WR, TxD, Rx_FERROR, Rx_PERROR, Rx_VALID, Rx_DATA
 *
 * It connects the transmitter driver with the transmitter, then the transmitter
 * with the receiver and the inputs-outputs with the while circuit.
 *
 */

module uart(reset, clk, baud_select, Tx_BUSY, Tx_WR, TxD, Tx_EN,
            Rx_EN, Rx_DATA, Rx_FERROR, Rx_PERROR, Rx_VALID);
            
  input reset, clk, Tx_EN, Rx_EN;
  input [2:0] baud_select;

  output Rx_FERROR, Rx_PERROR, Rx_VALID;
  output Tx_BUSY, Tx_WR, TxD;
  output [7:0] Rx_DATA;

  wire synchr_reset;
  wire [7:0] Tx_DATA;

  synchronizer synchron_INSTANCE
    (.clk(clk), .input_signal(reset), .output_signal(synchr_reset));

  uart_transmitter_driver transm_driver_INSTANCE(.reset(synchr_reset), .clk(clk),
            .Tx_BUSY(Tx_BUSY), .Tx_DATA(Tx_DATA), .Tx_WR(Tx_WR));

  uart_transmitter transmitter_INSTANCE(.reset(synchr_reset), .clk(clk),
            .Tx_DATA(Tx_DATA), .baud_select(baud_select),
				.Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

  uart_receiver receiver_INSTANCE(.reset(synchr_reset), .clk(clk), .Rx_DATA(Rx_DATA),
            .baud_select(baud_select), .Rx_EN(Rx_EN), .RxD(TxD),
            .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

endmodule
