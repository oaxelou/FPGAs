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
reg data_to_send [0:10];

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

always @(posedge Tx_sample_ENABLE or posedge reset)
begin
  if(reset)
  begin
    counter = 4'b0;
    transmit_ENABLE = 1'b0;
  end
  else
  begin
    if(counter == 4'b1111)
    begin
      counter = 4'b0;
      transmit_ENABLE = 1'b1;
    end
    else
    begin
      counter = counter + 1;
      transmit_ENABLE = 1'b0;
    end
	end
end

always @(Tx_WR)
begin
  Tx_BUSY = 1'b1;
  internal_BUSY = 1'b1;
end

always @ (posedge transmit_ENABLE or posedge reset)
begin
  if(internal_BUSY)
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
    // data_to_send[8:1] = Tx_DATA;
    data_to_send[9] = ^Tx_DATA;
    data_to_send[10] = 1'b1;

    index_data_to_send = 4'b0000;
    // TxD = data_to_send[0];

    internal_BUSY = 1'b0;
  end
end

always @(posedge transmit_ENABLE or posedge reset)
begin
  if(reset)
  begin
    Tx_BUSY = 1'b0;
    TxD = 1'b1;
  end
  else if(Tx_EN && Tx_BUSY)
    if(index_data_to_send == 4'b1011)
    begin
      Tx_BUSY = 1'b0;
      TxD = 1'b1;
    end
    else
    begin
      // metadosh dedomenwn!! (start bit, data, parity bit, end bit) sunolika 11 bits
      TxD = data_to_send[index_data_to_send];
      index_data_to_send = index_data_to_send + 1;
    end
end

endmodule
