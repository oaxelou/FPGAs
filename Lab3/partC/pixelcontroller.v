module pixelcontroller(reset, clk, vert_counter, display_time, red, green, blue);
input reset, clk, display_time;
input [6:0] vert_counter;
output red, green, blue;

reg [6:0] memorycounter;
reg [2:0] multipliercounter;
reg [13:0] address;
reg en;

always @ (posedge clk or posedge reset) begin
  if(reset || !display_time)
  begin
    memorycounter = 7'b0000000;
    multipliercounter = 3'b000;
    en = 1'b0;
  end
  else if(display_time)
  begin
    en = 1'b1;
    case (multipliercounter)
      3'b100:  // 5 fores kathe pixel (twn 128)
      begin
        case (memorycounter)
          7'b11111111: memorycounter = 7'b00000000;
          default: memorycounter = memorycounter + 1;
        endcase
        multipliercounter = 3'b000;
      end
      default: multipliercounter = multipliercounter + 1;
    endcase
  end
end


// dialegei se poio address tha paei na diavasei
always @ (reset or memorycounter) begin
  address = (((7'b101_1111 - vert_counter) << 7 ) + 7'b111_1111) - memorycounter;
end


bram Bram_INSTANCE(.clk(clk), .reset(reset), .en(en), .wen(1'b0), .address(address),
                      .red_output(red), .green_output(green), .blue_output(blue));

endmodule
