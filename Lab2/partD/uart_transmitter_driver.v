/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D: uart_transmitter_driver
 *
 *
 * uart_transmitter_driver: Selects the data to be transmitted
 *
 * input : clk, reset, Tx_BUSY
 * output: Tx_WR, Tx_DATA
 *
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

  always @ (posedge clk or posedge reset) begin
    if(reset)
    begin
      Tx_DATA_buffer[0] = 8'b10101010;
      Tx_DATA_buffer[1] = 8'b01010101;
      Tx_DATA_buffer[2] = 8'b11001100;
      Tx_DATA_buffer[3] = 8'b10001001;
      word_counter = 2'b11;

      Tx_DATA = Tx_DATA_buffer[0];
      Tx_WR = 1'b0;
    end
    else
    begin
      if(Tx_WR)
        Tx_WR = ~Tx_WR;
      if(!Tx_BUSY) begin
        word_counter = word_counter + 1;
        // $display("Gonna try transmitting %x\n", Tx_DATA_buffer[word_counter]);

        Tx_DATA = Tx_DATA_buffer[word_counter];

        Tx_WR = 1'b1;  //so that it won't mess up with the always
      end
    end
  end

  // always @(posedge clk)
  //   if(Tx_WR)
      // Tx_WR <= ~Tx_WR;

endmodule
