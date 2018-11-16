/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part C: UART transmitter (from partB)
 *
 *
 * transmitter: Receives the data to transmit from the user and sends them one
 *              by one through the channel.
 *
 * input : reset, clk, baud_select, Tx_DATA, Tx_EN, Tx_WR
 * output: TxD, Tx_BUSY
 *
 * Implementation:
 *   The circuit for the transmitter is divided into 4 sub-circuits:
 *     1) Control Unit - Sends enable signals to the proper circuit
       2) The one with the counter: 16-cycles counter calculates when to transmit
 *     3) The one that sends a busy signal when data from the system have arrived
 *        (it's also used after the transmission to stop sending BUSY signal)
 *     4) The one that stores the data from the user in a buffer
 *     5) The transmission unit: increments the data_counter and drives the
 *        correct bit to the output.
 *
 * To enable-disable each circuit, I use 2 buses. The first one to enable the
 * circuit: it's set in the control unit and used in each of the circuit and the
 * second one is to disable the circuit and is set in each of the circuits and
 * used in the control unit: that's how we pass from the one circuit to the other.
 *
 * The control unit and the busy-signal unit are in the clock domain of the system.
 * of the user and the data assign and transmission unit are enabled when the
 * signal Tx_sample_ENABLE is enabled, which is produced by the circuit with the
 * 16-cycles counter (which is in the transmit_ENABLE domain).
 *
 * Each of the circuit is used when the signal that corresponds to it is enabled.
 * The initialization of the circuit is done when another circuit is currently
 * used (so that is will be ready for the next set of data).
 *
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

reg transmit_ENABLE;
reg [3:0] counter;

reg [4:0] index_data_to_send; //value: 0 - 10
reg [0:10] data_to_send;

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

reg got_WR_signal, data_assigned, data_transmitted;

reg [1:0] circuit_enabled;

parameter WR_signal_check_ENABLE = 2'b00,
          data_assign_ENABLE = 2'b01,
          transmission_ENABLE  = 2'b11;

//Control Unit - Sends enable signals to the proper circuit
always @ (posedge clk or posedge reset) begin
  if(reset) begin
    circuit_enabled = 2'b00;
  end
  else if(Tx_EN)
    case(circuit_enabled)
		WR_signal_check_ENABLE: begin
        if(got_WR_signal)
		    circuit_enabled = data_assign_ENABLE;
      end
      data_assign_ENABLE: begin
        if(data_assigned)
          circuit_enabled = transmission_ENABLE;
      end
		transmission_ENABLE: begin
		  if(data_transmitted)
		    circuit_enabled = WR_signal_check_ENABLE;
      end
    endcase
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

// sends BUSY signal when data from the system have arrived
always @(posedge clk or posedge reset) begin
  if(reset) begin
    Tx_BUSY = 1'b0;
    got_WR_signal = 1'b0;
  end
  else if(Tx_EN && Tx_WR) begin
    Tx_BUSY = 1'b1;
    got_WR_signal = 1'b1;
  end
  else if(Tx_EN && circuit_enabled == data_assign_ENABLE) begin
    got_WR_signal = 1'b0;
  end
  else if(Tx_EN && data_transmitted && !got_WR_signal) begin
    Tx_BUSY = 1'b0;
  end
end

// DATA BUFFER ASSIGN UNIT
always @ (posedge transmit_ENABLE or posedge reset) begin
  if(reset)
  begin
    data_to_send = 11'b0_0;
    data_assigned = 1'b0;
  end
  else if(Tx_EN)
    case(circuit_enabled)
	 data_assign_ENABLE: begin
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
	 transmission_ENABLE:
      data_assigned = 1'b0;
    endcase
end

// THE TRANSMISSION UNIT
always @(posedge transmit_ENABLE or posedge reset) begin
  if(reset)
  begin
    data_transmitted = 1'b0;
    TxD = 1'b1;
    index_data_to_send = 4'b0000;
  end
  else if(Tx_EN)
    case(circuit_enabled)
	   transmission_ENABLE: begin
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
		data_assign_ENABLE: begin     // initialization for the next set of data
        data_transmitted = 1'b0;
        index_data_to_send = 4'b0000;
        TxD = 1'b1;
      end
	 endcase
end

endmodule
