/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part C: UART receiver
 *
 *
 * receiver: Receives as input the data(1 bit at a time) & control signals (from the user)
 *           and produces the final bus of data (8bit) and passes it to the user.
 *
 * input : clk, clk, baud_select, Rx_EN, RxD
 * output: Rx_DATA, Rx_FERROR, Rx_PERROR, Rx_VALID
 *
 * Implementation:
 *   The circuit for the receiver is divided into 6 sub-circuits:
 *     1) The one that searches for the start bit
 *     2) The one with the counter: It is used for both aligning the sampling process
 *                                  to the center of the input signal and for counting
 *                                  the cycles for the next input data.
 *     3) The data collector unit which saves in a temp buffer the 8 bits. (uses a data counter)
 *     4) The one that checks the parity bit (parity error)
 *     5) The one that checks the end bit (frame error)
 *     6) Lastly, the control unit which synchronizes all the other sub-circuits.
 *        It uses "start" and "finshed" signals to make sure that data will not
 *        get mixed up and - as a result - produce the wrong output.
 */

module uart_receiver(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD,
                     Rx_FERROR, Rx_PERROR, Rx_VALID);
input reset, clk;
input [2:0] baud_select;
input Rx_EN;
input RxD;
output [7:0] Rx_DATA;
output Rx_FERROR; // Framing Error //
output Rx_PERROR; // Parity Error //
output Rx_VALID; // Rx_DATA is Valid //

reg Rx_FERROR, Rx_PERROR, Rx_VALID;
reg [7:0] Rx_DATA;

reg old_start, start_bit_detected;

reg found_sampling_center;
reg [4:0] counter;

reg sample_ENABLE, data_received;
reg [3:0] data_counter;
reg [7:0] data_buffer;

reg parity_check_done;
reg frame_check_done, end_of_communication;

reg [2:0] circuit_enabled;

parameter start_bit = 3'b000,
          locking_s = 3'b001,
          sampling  = 3'b011,
          parity_ch = 3'b010,
          frame_che = 3'b110,
          send_d    = 3'b111;

baud_controller baud_controller_rx_instance(reset, clk, baud_select,
                                            Rx_sample_ENABLE);

/******************************************************************/
/* allaksa sta inputs tou synchronizer to clk se Rx_sample_ENABLE */
/******************************************************************/
channel_synchronizer data_synchronizer_instance(.clk(Rx_sample_ENABLE), .reset(reset),
                     .input_signal(RxD),.output_signal(synchronized_RxD));


// THE CONTROL UNIT
always @ (posedge Rx_sample_ENABLE or posedge reset) begin
  if(reset)
    circuit_enabled = start_bit;
  else if(Rx_EN)
    case (circuit_enabled)
      start_bit:
        if(start_bit_detected)
          circuit_enabled = locking_s;
      locking_s:
        if(found_sampling_center)
          circuit_enabled = sampling;
      sampling:
        if(data_received)
          circuit_enabled = parity_ch;
      parity_ch:
        if(parity_check_done)
          circuit_enabled = frame_che;
      frame_che:
      if(frame_check_done)
        circuit_enabled = send_d;
      send_d:
      if(end_of_communication)
        circuit_enabled = start_bit;
    endcase
end

// THE START BIT FINDER UNIT
always @ (posedge Rx_sample_ENABLE or posedge reset) begin
  if(reset)
  begin
    start_bit_detected <= 1'b0;
    old_start <= 1'b1;
  end
  else if(Rx_EN)
    case(circuit_enabled)
      start_bit:
      begin
        if(old_start == 1'b1 && old_start != synchronized_RxD)
        begin
          start_bit_detected <= 1'b1;
          old_start <= synchronized_RxD;
        end
      end
      locking_s:
      begin
        start_bit_detected <= 1'b0;
        old_start <= 1'b1;
      end
    endcase
end

// THE COUNTER - FSM UNIT : synchronizes the sampling process
always @ (posedge Rx_sample_ENABLE or posedge reset) begin
  if(reset)
  begin
    counter = 5'b00000;
    found_sampling_center = 1'b0;
    sample_ENABLE = 1'b0;
  end
  else if(Rx_EN)
    case(circuit_enabled)
      locking_s:
        case(counter)                     // counter max: 24 cycles
          5'b10010:
          begin
            counter = 5'b01110;           // starts from this bit so that
            found_sampling_center = 1'b1; // sample_ENABLE will become 1
          end                             // at the first cycle
          default: counter = counter + 1;
        endcase
      sampling, parity_ch, frame_che, send_d:
        case(counter)               // the 16cylces counter is used for data collection,
          5'b01111:                 // the parity checking and the frame checking
          begin
            counter = 5'b00000;
            sample_ENABLE = 1'b1;
          end
          default:
          begin
            counter = counter + 1;
            sample_ENABLE = 1'b0;
          end
        endcase
      default:
        if(end_of_communication)
        begin
          counter = 5'b00000;
          found_sampling_center = 1'b0;
          sample_ENABLE = 1'b0;
        end
    endcase
end

// THE DATA COLLECTOR CIRCUIT
always @ (posedge sample_ENABLE or posedge reset) begin
  if(reset)
  begin
    data_received = 1'b0;

    data_counter = 4'b0000;
    data_buffer = 8'b0000_0000;

    Rx_VALID = 1'b0;
    Rx_DATA = 8'b0000_0000;

    end_of_communication = 1'b0;
  end
  else if(Rx_EN)
    case(circuit_enabled)
      sampling:
      begin
        data_buffer = data_buffer >> 1;
        data_buffer[7] = synchronized_RxD;
        data_counter = data_counter + 1;

        if(data_counter == 4'b1000)    // received all of the 8 bits
          data_received = 1'b1;
        else if(data_counter == 4'b0001)
        begin
          Rx_VALID = 1'b0;             // the initialization of the last part of
          end_of_communication = 1'b0; // the previous communication
        end
      end
      send_d:
      begin
        if(frame_check_done && !Rx_PERROR && !Rx_FERROR)
        begin
          Rx_VALID = 1'b1;
          Rx_DATA = data_buffer;
        end
        data_received = 1'b0;
        data_counter = 4'b0000;
        data_buffer = 8'b0000_0000;

        end_of_communication = 1'b1;
      end
    endcase
end

// THE PARITY CHECK CIRCUIT
always @ (posedge sample_ENABLE or posedge reset) begin
  if(reset)
  begin
    parity_check_done = 1'b0;
    Rx_PERROR = 1'b0;
  end
  else if(Rx_EN)
    case(circuit_enabled)
      parity_ch:
      begin
        if(synchronized_RxD != ^data_buffer)
          Rx_PERROR = 1'b1;
        parity_check_done = 1'b1;
      end
      frame_che:
        parity_check_done = 1'b0;
      sampling:                        // is done in the next communication,
        Rx_PERROR = 1'b0;              // and particularly in sampling process
    endcase
end

// THE FRAME CHECK CIRCUIT
always @ (posedge sample_ENABLE or posedge reset) begin
  if(reset)
  begin
    Rx_FERROR = 1'b0;
    frame_check_done = 1'b0;
  end
  else if(Rx_EN)
    case(circuit_enabled)
      frame_che:
      begin
        if(!synchronized_RxD)
          Rx_FERROR = 1'b1;
        frame_check_done = 1'b1;
      end
      sampling:
      begin                             // initialization for the next set of data
        Rx_FERROR = 1'b0;               // is done in the next communication,
        frame_check_done = 1'b0;
      end                               // and particularly in sampling process
    endcase
end

endmodule
