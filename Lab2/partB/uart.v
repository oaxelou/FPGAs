/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part B: UART transmitter (TOP LEVEL MODULE)
 *
 * input : reset, clk, Tx_EN, baud_select, Tx_DATA, Tx_WR
 * output: Tx_BUSY, TxD
 *
 * Connects the transmitter circuit with the inputs and the outputs
 * ( + the reset synchronizer)
 */

module uart(reset, clk, baud_select, Tx_DATA, Tx_BUSY, Tx_WR, TxD, Tx_EN);
  input reset, clk, Tx_EN, Tx_WR;
  input [2:0] baud_select;
  input [7:0] Tx_DATA;
  output Tx_BUSY, TxD;

  wire synchr_reset, Tx_BUSY, Tx_WR, TxD, Tx_EN;

  synchronizer synchron_INSTANCE
    (.clk(clk), .input_signal(reset), .output_signal(synchr_reset));

  uart_transmitter transmitter_INSTANCE(.reset(synchr_reset), .clk(clk),
            .Tx_DATA(Tx_DATA), .baud_select(baud_select),
				.Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

endmodule
