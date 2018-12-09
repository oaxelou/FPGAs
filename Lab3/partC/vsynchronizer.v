/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part C: VSYNC Implementation + Vertical Pixel Counter
 *
 *
 * vsynchronizer: Calculates based on the timings of VGA protocol the vsync and
 *                hsync_time period.
 *
 * input : reset, clk
 * output: vsync,hsync_time
 *
 * Implementation:
 *   -> 2 always block (sequential). I use 2 counters for the line counter:
 *      > 1st. increments the vsync_counter (which calculates the vsync period)
 *      > 2nd. chooses when to change the value of vsync and hsync_time based
 *             on the counter of the 1st always block
 *
 */

module vsynchronizer(reset, clk, vsync, hsync_time);
input reset, clk;
output vsync, hsync_time;

reg [19:0] vsync_counter;
reg vsync, hsync_time;

always @ (posedge clk or posedge reset)
begin
  if(reset)
    vsync_counter = 'b0;  
  else
    case (vsync_counter)
      20'b1100_1011_1000_0011_1111: vsync_counter = 'b0; // decimal: 833600 - 1 (end of S)
      default: vsync_counter = vsync_counter + 1;
    endcase
end

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		hsync_time = 1'b0;
		vsync = 1'b1;
	end
	else
  case (vsync_counter)
    20'b0000_0000_0000_0000_0000: vsync = 1'b0;
    20'b0000_0000_1100_0111_1111: vsync = 1'b1;      // decimal:   3200 - 1  (end of P)
    20'b0000_1100_0001_1011_1111: hsync_time = 1'b1; // decimal:  49600 - 1  (end of Q)
    20'b1100_0111_1001_1011_1111: hsync_time = 1'b0; // decimal: 812000 - 1  (end of R)
  endcase
end

endmodule
