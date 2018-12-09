/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part C: VSYNC Implementation + Vertical Pixel Counter (altered from partB)
 *
 *
 * hsynchronizer: Calculates based on the timings of VGA protocol the hsync and
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
 *  What differs from partB is that when the hsync_counter reaches the max value,
 *  the 2 new counters increment (vert_counter and vert_multiplier) in order to
 *  control when to pass to the next line of the image.
 */

module hsynchronizer(reset, clk, hsync_time, hsync, display_time, vert_counter);
input reset, clk, hsync_time;
output hsync, display_time;
output [6:0] vert_counter;

reg [10:0] hsync_counter;
reg [6:0] vert_counter;
reg [2:0] vert_multiplier;

reg display_time, hsync;

always @ (posedge clk or posedge reset)
begin
  if(reset)
  begin
    hsync_counter = 11'b000_0000_0000;
    vert_counter = 7'b000_0000;
    vert_multiplier = 3'b000;
  end
  else if(hsync_time)
    case (hsync_counter)
      11'b110_0011_1111:                           // decimal: 1600 - 1
      begin
        hsync_counter = 11'b000_0000_0000;
        case(vert_multiplier)
          3'b100:
          begin
            vert_multiplier = 3'b000;
            case(vert_counter)
              7'b101_1111: vert_counter = 'b0;   // decimal: 95
              default: vert_counter = vert_counter + 1;
            endcase
          end
          default: vert_multiplier = vert_multiplier + 1;
        endcase
      end
      default: hsync_counter = hsync_counter + 1;
    endcase
  else if(!hsync_time)   // initializations for the next line of the image
  begin
    hsync_counter = 11'b000_0000_0000;
    vert_counter = 7'b000_0000;
    vert_multiplier = 3'b000;
  end
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
