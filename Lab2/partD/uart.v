/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D: UART (TOP LEVEL MODULE)
 *
 * input : reset, clk, Tx_EN, Rx_EN, Tx_WR, Tx_DATA,
 * output: Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID, Rx_DATA_aka_output
 *
 *
 * Connects:
 */

 // inputs: clk, reset, 3 switches! (for the baud_select)
 // outputs: the 7-segment pins

module uart(reset, clk, Tx_BUSY, Tx_WR, TxD, Tx_EN, Rx_EN, an1, an0,
            a, b, c, d, e, f, g, dp, Rx_FERROR, Rx_PERROR, Rx_VALID);
  input reset, clk, Tx_EN, Rx_EN;
  output Rx_FERROR, Rx_PERROR, Rx_VALID;
  output Tx_BUSY, Tx_WR, TxD, an1, an0;
  output a, b, c, d, e, f, g, dp;
  
  wire synchr_reset, Tx_BUSY, Tx_WR, TxD, Tx_EN, Rx_EN;
  wire [7:0] Tx_DATA, Rx_DATA;
  wire [2:0] baud_select;
  wire Rx_FERROR, Rx_PERROR, Rx_VALID;
  wire an1, an0;
  wire [3:0] char_for_7segm;
  wire [6:0] LED;
  
  synchronizer synchron_INSTANCE
    (.clk(clk), .input_signal(reset), .output_signal(synchr_reset));
  
  assign baud_select = 3'b111;
  
  uart_transmitter_driver transm_driver_INSTANCE(.reset(synchr_reset), .clk(clk), 
            .Tx_BUSY(Tx_BUSY), .Tx_DATA(Tx_DATA), .Tx_WR(Tx_WR));
  uart_transmitter transmitter_INSTANCE(.reset(synchr_reset), .clk(clk), 
            .Tx_DATA(Tx_DATA), .baud_select(baud_select), 
				.Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));
  uart_receiver receiver_INSTANCE(.reset(synchr_reset), .clk(clk), .Rx_DATA(Rx_DATA), 
            .baud_select(baud_select), .Rx_EN(Rx_EN), .RxD(TxD),
            .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));
  
  seven_segment_driver sevsegm_INSTANCE(.reset(reset), .clk(clk), .Rx_VALID(Rx_VALID), 
                   .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_DATA(Rx_DATA), 
						 .an1(an1), .an0(an0), .char_for_7segm(char_for_7segm));
  
  LEDdecoder ledcoder_INSTANCE(.in(char_for_7segm), .LED(LED));	
	
  	assign a = LED[6];
	assign b = LED[5];
	assign c = LED[4];
	assign d = LED[3];
	assign e = LED[2];
	assign f = LED[1];
	assign g = LED[0];
	assign dp = 1'b1;
	
endmodule
