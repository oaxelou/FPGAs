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

// reg internal_BUSY;
reg transmit_ENABLE;
reg [3:0] counter;

reg [4:0] index_data_to_send; //value: 0 - 10
reg [0:10] data_to_send;

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

reg WR_signal_check_ENABLE, data_assign_ENABLE, transmission_ENABLE;
reg got_WR_signal, data_assigned, data_transmitted;

always @ (posedge clk or posedge reset) begin
  if(reset) begin
    WR_signal_check_ENABLE = 1'b1;
    data_assign_ENABLE = 1'b0;
    transmission_ENABLE = 1'b0;
  end
  else if(WR_signal_check_ENABLE) begin
    if(got_WR_signal) begin
      WR_signal_check_ENABLE = 1'b0;
      data_assign_ENABLE = 1'b1;
    end
  end
  else if(data_assign_ENABLE) begin
    if(data_assigned) begin
      data_assign_ENABLE = 1'b0;
      transmission_ENABLE = 1'b1;
    end
  end
  else if(transmission_ENABLE) begin
    if(data_transmitted) begin
      transmission_ENABLE = 1'b0;
      WR_signal_check_ENABLE = 1'b1;
    end
  end
end

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

always @ (Tx_EN or Tx_WR or reset or data_transmitted or data_assign_ENABLE) begin
  if(reset) begin
    Tx_BUSY = 1'b0;
    got_WR_signal = 1'b0;
  end
  else if(Tx_EN && Tx_WR) begin
    Tx_BUSY = 1'b1;
    got_WR_signal = 1'b1;
  end
  else if(Tx_EN && data_assign_ENABLE) begin
    got_WR_signal = 1'b0;
  end
  else if(data_transmitted && !data_assign_ENABLE) begin
    Tx_BUSY = 1'b0;
    got_WR_signal = 1'b0;
  end
end

// sends BUSY signal when data from the system have arrived
/*always @(posedge clk or posedge reset) begin
  if(reset) begin
    // Tx_BUSY = 1'b0;
    got_WR_signal = 1'b0;
  end
  else if(Tx_EN && WR_signal_check_ENABLE) begin
    // if(Tx_BUSY && data_assigned)    // edw thelei ki allo elegxo!
      // Tx_BUSY = 1'b0;
    if(Tx_BUSY) begin
      got_WR_signal = 1'b1;
      // Tx_BUSY = 1'b1;
    end
  end
  else if(Tx_EN && data_assign_ENABLE) begin
    got_WR_signal = 1'b0;
  end
end*/

// DATA BUFFER & COUNTER ASSIGN UNIT
always @ (posedge transmit_ENABLE or posedge reset) begin
  if(reset)
  begin
    data_to_send = 11'b0_0;
    data_assigned = 1'b0;
  end
  else if(Tx_EN && data_assign_ENABLE)
  begin
    data_to_send[0] = 1'b0;
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

    data_assigned = 1'b1;
  end
  else if(Tx_EN && transmission_ENABLE) begin
    data_assigned = 1'b0;
  end
end

// THE TRANSMISSION UNIT
always @(posedge transmit_ENABLE or posedge reset) begin
  if(reset)
  begin
    data_transmitted = 1'b0;
    TxD = 1'b1;
    index_data_to_send = 4'b0000;   // auto tha paei sto katw always
  end
  else if(Tx_EN && transmission_ENABLE) begin
    if(index_data_to_send == 4'b1011)
    begin
      TxD = 1'b1;
      data_transmitted = 1'b1;
    end
    else
    begin  // data transmission (start bit, data, parity bit, end bit)
      TxD = data_to_send[index_data_to_send];    // in total: 11 bits
      index_data_to_send = index_data_to_send + 1;
    end
  end
  else if(Tx_EN && data_assign_ENABLE) begin
    data_transmitted = 1'b0;
    index_data_to_send = 4'b0000;
    TxD = 1'b1;
  end
end

endmodule
