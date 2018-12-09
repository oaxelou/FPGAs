/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part B: HSYNC Implementation + Horizontal Pixel Counter
 *
 *
 * hsynchronizer: Calculated based on the timings of VGA protocol the hsync and
 *                display_time period.
 *
 * input : reset, clk
 * output: hsync, display_time
 *
 * Implementation:
 *   -> 2 always block (sequential). I use 2 counters for the pixel counter:
 *      > 1st. increments the hsync_counter (which calculates the hsync period)
 *      > 2nd. chooses when to change the value of hsync and display_time based
 *             on the counter of the 1st always block
 *
 *   This module is altered in partC so that it takes into consideration the
 *   vertical counter.
 */

module hsynchronizer(reset, clk, hsync, display_time);
input reset, clk;
output hsync, display_time;

reg [10:0] hsync_counter;
reg display_time, hsync;

always @ (posedge clk or posedge reset)
begin
  if(reset)
  begin
    hsync_counter = 11'b000_0000_0000;
  end
  else
    case (hsync_counter)
      11'b110_0011_1111:                           // decimal: 1600 - 1
      begin
        hsync_counter = 11'b000_0000_0000;
      end
      default: hsync_counter = hsync_counter + 1;
    endcase
end

always @ (posedge clk or posedge reset)
begin
	if(reset)
  begin
		hsync = 1'b1;
    display_time = 1'b0;
	end
  else
			case(hsync_counter)
				11'b000_0000_0000: hsync = 1'b0;
				11'b000_1011_1111: hsync = 1'b1;        // decimal:  192 - 1
  			11'b001_0001_1111: display_time = 1'b1; // decimal:  288 - 1
  			11'b110_0001_1111: display_time = 1'b0; // decimal: 1568 - 1
			endcase
end

endmodule
