`timescale 1ns / 10ps

module tb_uart_transmitter;

reg reset, clk;
reg Tx_EN, Tx_WR;
reg [7:0] Tx_DATA;

wire Tx_BUSY, TxD;

initial
begin
  clk = 1'b1;

  #200 reset = 1'b1;
  #100 reset = 1'b0;

  Tx_EN = 1'b1;

  #100
  $display("Gonna try transmitting AA");
  if(!Tx_BUSY)
  begin
    Tx_DATA[7] = 1;
    Tx_DATA[6] = 0;
    Tx_DATA[5] = 1;
    Tx_DATA[4] = 0;
    Tx_DATA[3] = 1;
    Tx_DATA[2] = 0;
    Tx_DATA[1] = 1;
    Tx_DATA[0] = 0;
    // Tx_DATA = {1,0,1,0,1,0,1,0};
    Tx_WR = 1'b1;
    #20 Tx_WR = 1'b0;
  end

  #300000
  $display("Gonna try transmitting 89");
  if(!Tx_BUSY)
  begin
  Tx_DATA[7] = 1;
  Tx_DATA[6] = 0;
  Tx_DATA[5] = 0;
  Tx_DATA[4] = 0;
  Tx_DATA[3] = 1;
  Tx_DATA[2] = 0;
  Tx_DATA[1] = 0;
  Tx_DATA[0] = 1;
  // Tx_DATA = {1,0,0,0,1,0,0,1};
  Tx_WR = 1'b1;
  #20 Tx_WR = 1'b0;
  end
end

always #10 clk = ~clk;

uart_transmitter uart_transmitter_instance(.reset(reset), .clk(clk), .Tx_DATA(Tx_DATA), .baud_select(111),
                                           .Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

endmodule
