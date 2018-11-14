/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D: UART (TOP LEVEL MODULE)
 *
 * input : reset, clk, Tx_EN, Rx_EN, Tx_WR, Tx_DATA,
 * output: Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID, Rx_DATA_aka_output
 *
 *
 * 
 */

 // inputs: clk, reset, 3 switches! (for the baud_select)
 // outputs: the 7-segment pins

module uart(reset, clk, baud_select, Tx_DATA, Tx_BUSY, Tx_WR, TxD, Tx_EN);
  input reset, clk, Tx_EN;
  input [2:0] baud_select;
  input [7:0] Tx_DATA;
  output Tx_BUSY, Tx_WR, TxD;

  wire synchr_reset, Tx_BUSY, Tx_WR, TxD, Tx_EN;
  
  synchronizer synchron_INSTANCE
    (.clk(clk), .input_signal(reset), .output_signal(synchr_reset));
  
  uart_transmitter transmitter_INSTANCE(.reset(synchr_reset), .clk(clk), 
            .Tx_DATA(Tx_DATA), .baud_select(baud_select), 
				.Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));
				
endmodule
