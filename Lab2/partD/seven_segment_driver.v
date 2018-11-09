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
  output [4:0] char_for_7segm;

  reg [4:0] char_for_7segm;
  reg an1, an0;

  reg [2:0] counter;
  reg [4:0] message[0:1];

  always @ (Rx_FERROR) begin
    message[0] = 5'b10001;
    message[1] = 5'b10000;
  end

  always @ (Rx_PERROR) begin
    message[0] = 5'b10000;
    message[1] = 5'b10001;
  end

  always @(Rx_VALID) begin
    message[0] = Rx_DATA[7:4];
    message[1] = Rx_DATA[3:0];
  end

  always @(posedge clk or posedge reset)
  begin
  	if(reset)
  	begin
  		counter = 3'b000;
  		char_for_7segm = 5'b00000;
      message[1] = 5'b00000;
      message[0] = 5'b00000;

  		an1 = 1'b1;
  		an0 = 1'b1;
  	end
  	else
  	begin
  		case(counter)
  			3'b111:
  			begin
  				an1 = 1'b1;
  				counter = counter - 1;
  			end
  			3'b110:
  			begin
  				counter = counter - 1;
  				char_for_7segm = message[1];
  			end
  			3'b100:
  			begin
  				counter = counter - 1;
  				an0 = 1'b0;
  			end
  			3'b011:
  			begin
  				counter = counter - 1;
  				an0 = 1'b1;
  			end
  			3'b010:
  			begin
  				counter = counter - 1;
  				char_for_7segm = message[0];
  			end
  			3'b000:
  			begin
  				counter = counter - 1;
  				an1 = 1'b0;
  			end
  			default: counter = counter - 1;
  		endcase
  	end
  end

endmodule
