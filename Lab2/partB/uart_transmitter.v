/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part B: UART transmitter
 *
 *
 * receiver: Receives as input the data(1 bit at a time) & control signals (from the user)
 *           and produces the final bus of data (8bit) and passes it to the user.
 *
 * input : clk, clk, baud_select, Tx_DATA, Tx_EN, Tx_WR
 * output: TxD, Tx_BUSY
 *
 * Implementation:
 *   The circuit for the transmitter is divided into 4 sub-circuits:
 *     1) The one with the counter: 16-cycles counter calculates when to transmit
 *     2) The one that sends a busy signal when data from the system have arrived
 *        and sets to TRUE the internal_BUSY signal which signals
 *        (so that the data processing can begin)
 *     3) The one that stores the data in a buffer & sets the index of the buffer to 0
 *     4) The transmission unit: icrements the data counter and drives the correct
 *        bit to the output.
 */

module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
input reset, clk;
input [7:0] Tx_DATA;
input [2:0] baud_select;
input Tx_EN;
input Tx_WR;

output TxD;
output Tx_BUSY;

reg TxD;
reg Tx_BUSY;

reg internal_BUSY;
reg transmit_ENABLE;
reg [3:0] counter;

reg [4:0] index_data_to_send; //value: 0 - 10
reg [0:10] data_to_send;

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

// THE COUNTER UNIT: calculates when to transmit
always @(posedge Tx_sample_ENABLE or posedge reset) begin
  if(reset)
  begin
    counter = 4'b0;
    transmit_ENABLE = 1'b0;
  end
  else if(Tx_EN)
    case(counter)
      4'b1111:
      begin
        counter = 4'b0;
        transmit_ENABLE = 1'b1;
      end
      default:
      begin
        counter = counter + 1;
        transmit_ENABLE = 1'b0;
      end
	  endcase
end

// sends BUSY signal when data from the system have arrived
always @(Tx_WR) begin
  Tx_BUSY = 1'b1;
  internal_BUSY = 1'b1;
end

// DATA BUFFER & COUNTER ASSIGN UNIT
always @ (posedge transmit_ENABLE or posedge reset) begin
  if(reset)
  begin
    index_data_to_send = 4'b0000;
    internal_BUSY = 1'b0;
    data_to_send = 11'b0_0;
  end
  else
    if(Tx_EN && internal_BUSY)           // internal_BUSY == 1 when the user has sent
    begin                       // data and the transmitter has to move them to
      data_to_send[0] = 1'b0;   // a buffer before the communication has started
      data_to_send[1] = Tx_DATA[0];
      data_to_send[2] = Tx_DATA[1];
      data_to_send[3] = Tx_DATA[2];
      data_to_send[4] = Tx_DATA[3];
      data_to_send[5] = Tx_DATA[4];
      data_to_send[6] = Tx_DATA[5];
      data_to_send[7] = Tx_DATA[6];
      data_to_send[8] = Tx_DATA[7];
      data_to_send[9] = ^Tx_DATA;
      data_to_send[10] = 1'b1;

      index_data_to_send = 4'b0000;

      internal_BUSY = 1'b0;
    end
end

// THE TRANSMISSION UNIT
always @(posedge transmit_ENABLE or posedge reset) begin
  if(reset)
  begin
    Tx_BUSY = 1'b0;
    TxD = 1'b1;
  end
  else
    if(Tx_EN && Tx_BUSY)
      if(index_data_to_send == 4'b1011)
      begin
        Tx_BUSY = 1'b0;
        TxD = 1'b1;
      end
      else
      begin  // data transmission (start bit, data, parity bit, end bit)
        TxD = data_to_send[index_data_to_send];    // in total: 11 bits
        index_data_to_send = index_data_to_send + 1;
      end
end

endmodule

