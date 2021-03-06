/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D-2: UART (TOP LEVEL MODULE)
 *
 * input : reset, clk, Tx_EN, Rx_EN, baud_select
 * output: an3, an2, an1, an0, a, b, c, d, e, f, g, dp
 *
 * It connects the trasmitter driver with the transmitter, the transmitter with
 * the receiver, the receiver with the seven segment driver and the LEDdecoder
 * and in general the inputs-outputs with the whole circuit.
 *   As I did in the first assignment, I use the Spartan 3 DCM to divide the
 * frequency of the seven segment display counter.
 *   It assigns the fixed value (1'b1) to an3, an2 and dp as I don't use them
 * in this implementation.
 *
 * In particular:
 *    Inputs: -> reset is the 1st button (L14)
 *            -> baud select is the first 3 switches (K13, K14, J13)
 *            -> Tx_EN & Rx_EN are the 4th & 5th switches (J14, H13)
 *
 *  Outputs: To display the symbols I use the 3rd & the 4th anodes
 *           of the seven segment displays (an1, an0)
 *
 * (more details about the I/O connections in the .ucf file)
 */

module uart(reset, clk, baud_select, Tx_EN, Rx_EN, an3, an2, an1, an0,
            a, b, c, d, e, f, g, dp);
  input reset, clk, Tx_EN, Rx_EN;
  input [2:0] baud_select;
  output an3, an2, an1, an0;
  output a, b, c, d, e, f, g, dp;

  wire synchr_reset, Tx_BUSY, Tx_WR, TxD, Tx_EN, Rx_EN;
  wire [7:0] Tx_DATA, Rx_DATA;
  wire [2:0] baud_select;
  wire Rx_FERROR, Rx_PERROR, Rx_VALID;

  wire an1, an0;
  wire [3:0] char_for_7segm;
  wire [6:0] LED;

  wire fb_output, new_clk;

   // The DCM exists only for the seven segment display circuit! 20ns -> 320ns
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
      .RST(synchr_reset)
   );

  synchronizer synchron_INSTANCE
    (.clk(clk), .input_signal(reset), .output_signal(synchr_reset));

  uart_transmitter_driver transm_driver_INSTANCE(.reset(synchr_reset), .clk(clk),
            .Tx_BUSY(Tx_BUSY), .Tx_DATA(Tx_DATA), .Tx_WR(Tx_WR));
  uart_transmitter transmitter_INSTANCE(.reset(synchr_reset), .clk(clk),
            .Tx_DATA(Tx_DATA), .baud_select(baud_select),
				.Tx_WR(Tx_WR), .Tx_EN(Tx_EN), .TxD(TxD), .Tx_BUSY(Tx_BUSY));

  uart_receiver receiver_INSTANCE(.reset(synchr_reset), .clk(clk), .Rx_DATA(Rx_DATA),
            .baud_select(baud_select), .Rx_EN(Rx_EN), .RxD(TxD),
            .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

  seven_segment_driver sevsegm_INSTANCE(.reset(synchr_reset), .clk(new_clk), .Rx_VALID(Rx_VALID),
                   .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_DATA(Rx_DATA),
						 .an1(an1), .an0(an0), .char_for_7segm(char_for_7segm));
  LEDdecoder ledcoder_INSTANCE(.in(char_for_7segm), .LED(LED));

	assign an3 = 1'b1;
	assign an2 = 1'b1;

  assign a = LED[6];
	assign b = LED[5];
	assign c = LED[4];
	assign d = LED[3];
	assign e = LED[2];
	assign f = LED[1];
	assign g = LED[0];
	assign dp = 1'b1;

endmodule
