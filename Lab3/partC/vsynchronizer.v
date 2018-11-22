module vsynchronizer(reset, clk, vsync, hsync_time);
input reset, clk;
output vsync, hsync_time;

reg [19:0] vsync_counter;
reg vsync, hsync_time;

always @ (posedge clk or posedge reset)
begin
  if(reset)
    vsync_counter = 20'b0;
  else
    case (vsync_counter)
      20'b1100_1011_1000_0011_1111: vsync_counter = 20'b0;
      default: vsync_counter = vsync_counter + 1;
    endcase
end

always @(vsync_counter or reset)
begin
	if(reset)
	begin
		hsync_time = 1'b0;
		vsync = 1'b1;
	end
	else
  case (vsync_counter)
    20'b0000_0000_0000_0000_0000: vsync = 1'b0;
    20'b0000_0000_1100_1000_0000: vsync = 1'b1;
    20'b0000_1100_0001_1100_0000: hsync_time = 1'b1;
    20'b1100_0111_1001_1100_0000: hsync_time = 1'b0;
  endcase
end

endmodule
