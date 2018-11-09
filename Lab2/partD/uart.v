/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D: UART
 *
 *
 * receiver: Receives as input the data(1 bit at a time) & control signals (from the user)
 *           and produces the final bus of data (8bit) and passes it to the user.
 *
 * input : clk, clk, baud_select, Tx_DATA, Tx_EN, Tx_WR
 * output: TxD, Tx_BUSY
 *
 */

 // inputs: clk, reset, 3 switches! (for the baud_select)
 // outputs: the 7-segment pins

module uart(reset, clk, Tx_EN, Rx_EN, Tx_WR, Tx_DATA,
            Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID,
            Rx_DATA_aka_output);
input reset, clk;
input Tx_EN, Rx_EN, Tx_WR;
input [7:0] Tx_DATA;

output Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID;
output [7:0] Rx_DATA_aka_output;

wire TxD;

uart_transmitter uart_transmitter_instance
             (.reset(reset), .clk(clk), .Tx_DATA(Tx_DATA), .baud_select(3'b111),
              .Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

uart_receiver uart_receiver_instance
             (.reset(reset), .clk(clk), .Rx_DATA(Rx_DATA_aka_output),
              .baud_select(3'b111), .Rx_EN(Rx_EN), .RxD(TxD),
              .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

endmodule
