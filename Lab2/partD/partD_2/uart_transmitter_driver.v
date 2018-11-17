/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D-2: uart_transmitter_driver
 *
 *
 * uart_transmitter_driver: Selects the data to be transmitted.
 *
 * input : clk, reset, Tx_BUSY
 * output: Tx_WR, Tx_DATA
 *
 * The 4 symbols to be sent ('aa', '55', 'cc', '89') are stored in a buffer
 * which is accessed circularly.
 *
 * Comments on the implementation:
 * -> This transmitter driver circuit differs from the one of the partD-1:
 *    I have added a 3bit counter to slow down the circuit as - even for the
 *    slowest baud rate - it was too fast in real time.
 */

module uart_transmitter_driver(reset, clk, Tx_BUSY, Tx_DATA, Tx_WR);

  input reset, clk;
  input Tx_BUSY;

  output Tx_WR;
  output [7:0] Tx_DATA;

  reg Tx_WR;
  reg [7:0] Tx_DATA;

  reg [7:0] Tx_DATA_buffer [0:3];
  reg [1:0] word_counter;
  reg [2:0] counter_per_message;

  always @ (posedge clk or posedge reset) begin
    if(reset)
    begin
      Tx_DATA_buffer[0] = 8'b10101010;
      Tx_DATA_buffer[1] = 8'b01010101;
      Tx_DATA_buffer[2] = 8'b11001100;
      Tx_DATA_buffer[3] = 8'b10001001;
      word_counter = 2'b11;

      counter_per_message = 3'b000;

      Tx_DATA = Tx_DATA_buffer[0];
      Tx_WR = 1'b0;
    end
    else
    begin
      if(Tx_WR)
        Tx_WR = ~Tx_WR;
      else if(!Tx_BUSY) begin              // in every posedge of the clk enters
        if(counter_per_message == 3'b111) begin
          word_counter = word_counter + 1;   // the always block but only when
          Tx_DATA = Tx_DATA_buffer[word_counter]; // !Tx_BUSY sends new data
          counter_per_message = 3'b000;
        end
        counter_per_message = counter_per_message + 1;
        Tx_WR = 1'b1;      // to notify the transmitter that there's new data
      end
    end
  end
endmodule
