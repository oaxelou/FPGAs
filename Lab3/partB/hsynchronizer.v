module hsynchronizer(reset, clk, hsync, display_time);
input reset, clk;
output hsync, display_time;

reg [10:0] hsync_counter;
reg display_time, hsync;

always @ (posedge clk or posedge reset)
begin
  if(reset)
    hsync_counter = 11'b00000000000;
  else
    case (hsync_counter)
      11'b110_0011_1111: hsync_counter = 11'b000_0000_0000;
      default: hsync_counter = hsync_counter + 1;
    endcase
end

always @(hsync_counter or reset)
begin
	if(reset)
	begin
		display_time = 1'b0;
		hsync = 1'b1;
	end
	else
  case (hsync_counter)
    11'b000_0000_0000: hsync = 1'b0;
    11'b000_1100_0000: hsync = 1'b1;
    11'b001_0010_0000: display_time = 1'b1;
    11'b110_0010_0000: display_time = 1'b0;
  endcase
end

endmodule
