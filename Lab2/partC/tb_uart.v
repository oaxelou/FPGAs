`timescale 1ns / 10ps

/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D: UART receiver
 *
 *
 * testbench : tests 3 cases: first one : 'AA' with parity bit: 0
 *                            second one: '55' with parity bit: 0
 *                            third one : 'CC' with parity bit: 0
 *                            fourth one: '89' with parity bit: 1
 * Treskto auto 6000ns
 */

module tb_uart;

wire [7:0] Rx_DATA;
wire Rx_FERROR, Rx_PERROR, Rx_VALID;

reg reset, clk;
reg [2:0] baud_select;
reg Rx_EN, RxD, Tx_EN;

reg [3:0] counter;
wire Tx_sample_ENABLE;
reg transmit_ENABLE;

reg [5:0] index_data_to_send; //value: 0 - 10
reg [0:38] data_to_send;

initial begin
  clk = 1'b1;
  RxD = 1'b1;
  baud_select = 3'b111;

  #190 reset = 1'b1;
  #1000 reset = 1'b0;

  Rx_EN = 1'b1;

  // VALID
  data_to_send[0]  = 0;
  data_to_send[1]  = 0;
  data_to_send[2]  = 1;
  data_to_send[3]  = 0;
  data_to_send[4]  = 1;
  data_to_send[5]  = 0;
  data_to_send[6]  = 1;
  data_to_send[7]  = 0;
  data_to_send[8]  = 1;
  data_to_send[9]  = 0;
  data_to_send[10] = 1;

  data_to_send[11] = 1;
  data_to_send[12] = 1;

  // PERROR
  data_to_send[13] = 0;
  data_to_send[14] = 0;
  data_to_send[15] = 1;
  data_to_send[16] = 0;
  data_to_send[17] = 1;
  data_to_send[18] = 0;
  data_to_send[19] = 1;
  data_to_send[20] = 0;
  data_to_send[21] = 1;
  data_to_send[22] = 1;   //  <- HERE LIES THE ERROR
  data_to_send[23] = 1;

  data_to_send[24] = 1;
  data_to_send[25] = 1;

  // FERROR
  data_to_send[26] = 0;
  data_to_send[27] = 0;
  data_to_send[28] = 1;
  data_to_send[29] = 0;
  data_to_send[30] = 1;
  data_to_send[31] = 0;
  data_to_send[32] = 1;
  data_to_send[33] = 0;
  data_to_send[34] = 1;
  data_to_send[35] = 0;
  data_to_send[36] = 0;  // <- HERE LIES THE ERROR

  data_to_send[37] = 1;  // END OF COMMUNICATION
  data_to_send[38] = 1;

  Tx_EN = 1'b1;

end

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

// upologizei pote na steilei kati
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

always @(posedge transmit_ENABLE or posedge reset) begin
  if(reset)
    index_data_to_send = 6'b000000;   // auto tha paei sto katw always
  else if(Tx_EN) begin  // data transmission (start bit, data, parity bit, end bit)
    if(index_data_to_send == 6'b100111)
      index_data_to_send = 6'b000000;
    else begin
      RxD = data_to_send[index_data_to_send];    // in total: 11 bits
      index_data_to_send = index_data_to_send + 1;
    end
  end
end

always @ (posedge Rx_VALID)
  $display("received : %x%x\n", Rx_DATA[7:4], Rx_DATA[3:0]);

always #10 clk = ~clk;

uart uart_INSTANCE(.reset(reset), .clk(clk), .baud_select(baud_select), .RxD(RxD),
						 .Rx_EN(Rx_EN), .Rx_DATA(Rx_DATA), .Rx_FERROR(Rx_FERROR),
						 .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));
endmodule
