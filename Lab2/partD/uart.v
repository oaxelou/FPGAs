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

module uart(reset, clk, Tx_EN, Rx_EN, baud_select, an1, an0, a, b, c, d, e, f, g, dp);
  input reset, clk;
  input Tx_EN, Rx_EN;
  input [2:0] baud_select;

  output an1, an0;
  output a, b, c, d, e, f, g, dp;

  wire synchr_reset, debounce_reset;
  wire fb_output, new_clk;

  wire [7:0] Tx_DATA;
  wire Tx_WR, Tx_BUSY;

  wire TxD;

  wire [7:0] Rx_DATA;
  wire [4:0] char_for_7segm;
  wire [7:0] LED;

  synchronizer synchron_INSTANCE
    (.clk(clk), .input_signal(reset), .output_signal(synchr_reset));

  debounce_circuit #(.SUFFICIENT_CYCLES(2)) debounce_INSTANCE 
  	( .clk(clk), .button_input(synchr_reset), .button_output(debounce_reset));

  DCM #(
   .SIM_MODE("SAFE"),
   .CLKDV_DIVIDE(16),
   .CLKFX_DIVIDE(1),
   .CLKFX_MULTIPLY(4),
   .CLKIN_DIVIDE_BY_2("FALSE"),
   .CLKIN_PERIOD(0.0),
   .CLKOUT_PHASE_SHIFT("NONE"),
   .CLK_FEEDBACK("1X"),
   .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"),
   .DFS_FREQUENCY_MODE("LOW"),
   .DLL_FREQUENCY_MODE("LOW"),
   .DUTY_CYCLE_CORRECTION("TRUE"),
   .FACTORY_JF(16'hC080),
   .PHASE_SHIFT(0),
   .STARTUP_WAIT("FALSE")
) DCM_inst (
   .CLK0(fb_output),
   .CLKDV(new_clk),
   .CLKFB(fb_output),
   .CLKIN(clk),
   .RST(debounce_reset)
);

  uart_transmitter_driver transmitter_driver_INSTANCE
             (.reset(debounce_reset), .clk(clk), .Tx_BUSY(Tx_BUSY), .Tx_DATA(Tx_DATA), .Tx_WR(Tx_WR));

  uart_transmitter uart_transmitter_instance
               (.reset(debounce_reset), .clk(clk), .Tx_DATA(Tx_DATA), .baud_select(baud_select),
                .Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

  uart_receiver uart_receiver_instance
               (.reset(debounce_reset), .clk(clk), .Rx_DATA(Rx_DATA),
                .baud_select(baud_select), .Rx_EN(Rx_EN), .RxD(TxD),
                .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

  seven_segment_driver sev_segm_dr_INSTANCE
                       (.reset(debounce_reset), .clk(new_clk), .Rx_VALID(Rx_VALID),
                        .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR),
                        .Rx_DATA(Rx_DATA), .an1(an1), .an0(an0),
                        .char_for_7segm(char_for_7segm));


  LEDdecoder LEDdecoderINSTANCE(.in(char_for_7segm), .LED(LED));  // to .in tha ginei 5 bit gia thn teleia!

  assign a = LED[6];
	assign b = LED[5];
	assign c = LED[4];
	assign d = LED[3];
	assign e = LED[2];
	assign f = LED[1];
	assign g = LED[0];
	assign dp =LED[7];

endmodule
