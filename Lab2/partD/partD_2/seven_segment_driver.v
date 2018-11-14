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

module seven_segment_driver(reset, clk, Rx_VALID, Rx_FERROR, Rx_PERROR, Rx_DATA, an1, an0, char_for_7segm);

  input reset, clk;
  input Rx_VALID, Rx_FERROR, Rx_PERROR;
  input [7:0] Rx_DATA;

  output an1, an0;
  output [3:0] char_for_7segm;

  reg [3:0] char_for_7segm;
  reg an1, an0;

  reg [2:0] counter;
  reg [3:0] message[0:1];

  always @ (posedge clk or posedge reset) begin
    if(reset) begin
      message[1] = 4'b0000;
      message[0] = 4'b0000;
    end
    else if(Rx_FERROR) begin
      message[0] = 4'b1111;   // F  (frame)
      message[1] = 4'b1110;   // E  (error)
    end
    else if(Rx_PERROR) begin
      message[0] = 4'b0001;   // P (parity)
      message[1] = 4'b1110;   // E  (error)
    end
    else if(Rx_VALID) begin
      message[0] = Rx_DATA[7:4];
      message[1] = Rx_DATA[3:0];
    end
  end

  always @(posedge clk or posedge reset) begin
  	if(reset)
  	begin
  		counter = 3'b000;
  		char_for_7segm = 4'b0000;

  		an1 = 1'b1;
  		an0 = 1'b1;
  	end
  	else begin
  		case(counter)
  			3'b111: an1 = 1'b1;
  			3'b110: char_for_7segm = message[1];
  			3'b100: an0 = 1'b0;
  			3'b011: an0 = 1'b1;
  			3'b010: char_for_7segm = message[0];
  			3'b000: an1 = 1'b0;
  		endcase
		counter = counter - 1;
  	end
  end

endmodule


