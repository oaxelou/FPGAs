/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project2: UART
 *
 * Part D_1: Baud Rate Controller (the same from partA)
 *
 *
 * baud rate controller: Takes as input the selected baud rate code and gives as
 * output the sampling enable signal.
 *
 * input : reset, clk, baud_select
 * output: sample_ENABLE
 *
 * Implementation:
 *   -> 1 combinational always block which sets the max value of the counter
 *      (based on the input)
 *   -> 1 sequential always block which changes the value of the counter
 *   -> 1 combinational always block which calculates the next state
 *      (whether to enable the sample_ENABLE signal or not)
 */

module baud_controller(reset, clk, baud_select, sample_ENABLE);

input reset, clk;
input [2:0] baud_select;
output sample_ENABLE;
reg sample_ENABLE;
reg [15:0] counter;
reg [15:0] samp_period_counter;

always @(baud_select)
  case(baud_select)
    3'b000: samp_period_counter = 16'b0010_1000_1011_0001;
    3'b001: samp_period_counter = 16'b0000_1010_0010_1100;
    3'b010: samp_period_counter = 16'b0000_0010_1000_1011;
    3'b011: samp_period_counter = 16'b0000_0001_0100_0110;
    3'b100: samp_period_counter = 16'b0000_0000_1010_0011;
    3'b101: samp_period_counter = 16'b0000_0000_0101_0001;
    3'b110: samp_period_counter = 16'b0000_0000_0011_0110;
    3'b111: samp_period_counter = 16'b0000_0000_0001_1011;
    default: samp_period_counter = 16'bx_x;
  endcase

always @(posedge clk or posedge reset)
  if(reset)
    counter = 16'b0_0;
  else
    case(counter)
	   samp_period_counter - 1: counter = 16'b0;
	   default: counter = counter + 1;
	 endcase

always @(counter or samp_period_counter)
  case(counter)
    samp_period_counter - 1: sample_ENABLE = 1'b1;
	 default: sample_ENABLE = 1'b0;
  endcase

endmodule
