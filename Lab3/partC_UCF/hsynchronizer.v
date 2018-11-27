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
      11'b110_0011_1111:
      begin
        hsync_counter = 11'b000_0000_0000;
        case(vert_multiplier)
          3'b100:
          begin
            vert_multiplier = 3'b000;
            case(vert_counter)
              7'b101_1111: vert_counter = 7'b0;
              default: vert_counter = vert_counter + 1;
            endcase
          end
          default: vert_multiplier = vert_multiplier + 1;
        endcase
      end
      default: hsync_counter = hsync_counter + 1;
    endcase
  else if(!hsync_time)
  begin
    hsync_counter = 11'b000_0000_0000;
    vert_counter = 7'b000_0000;
    vert_multiplier = 3'b000;
  end
end

always @(posedge clk or posedge reset)
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
