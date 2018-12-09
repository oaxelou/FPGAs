/* Axelou Olympia
 * oaxelou@uth.gr
 * 2161
 *
 * ce430
 * Project3: VGA Controller
 *
 * Part B: HSYNC Implementation + Horizontal Pixel Counter (changed for partC)
 *
 *
 * pixelcontroller: Takes as input the selected address and gives as
 * output the RGB color (3bit).
 *
 * input :  reset, clk, display_time, vert_counter
 * output: red, green, blue
 *
 * Implementation:
 *   -> 1 always block (sequential). I use 2 counters for the pixel counter:
 *        1. memorycounter: it shows in which pixel of the VRAM we are
 *           currently (only shows the column)
 *        2. multipliercounter: it shows how many cycles we have to remain in
 *           the current horizontal pixel to display a 192x96 frame as 640x480.
 *           In order to fill the display_time of the hsync signal, each pixel
 *           has to be displayed 10 times. However, as the resolution of the
 *           memory is 5 times less than the original one that we want to display
 *           the max value of the multipliercounter is set to 5 and not 10
 *
 *  -> 1 assign (combinational logic). Combines the vert_counter (input) and the
 *          memorycounter to produce the final form of the address.
 *          I subtract both counters from the max value of each of them as the
 *          memory is backwards.
 *
 *  -> 1 instantiation (the bram)
 */

module pixelcontroller(reset, clk, vert_counter, display_time, red, green, blue);
input reset, clk, display_time;
input [6:0] vert_counter;
output red, green, blue;

wire red_output, green_output, blue_output;

reg [6:0] memorycounter;
reg [3:0] multipliercounter;
wire [13:0] address;
reg en;

always @ (posedge clk or posedge reset) begin
  if(reset)
  begin
    memorycounter = 7'b0000000;
    multipliercounter = 4'b0000;
    en = 1'b0;
  end
  else if(display_time)
  begin
    en = 1'b1;
    case (multipliercounter)
      4'b0100: /* 4'b1001:*/  // 10x per pixel to fill the display time. When set to 5x,
      begin                   // the counter overflows and begins from the start
        case (memorycounter)
          7'b1111111: memorycounter = 7'b0000000;
          default: memorycounter = memorycounter + 1;
        endcase
        multipliercounter = 4'b0000;
      end
      default: multipliercounter = multipliercounter + 1;
    endcase
  end
  else if(!display_time)
  begin
    memorycounter = 7'b0000000;
    multipliercounter = 3'b000;
    en = 1'b0;
  end
end


// sets the final address combining the vertical and the horizontal counter
assign address = (((7'b101_1111 - vert_counter) << 7 ) + 7'b111_1111) - memorycounter;

bram Bram_INSTANCE(.clk(clk), .reset(reset), .en(en), .address(address),
                      .red_output(red_output), .green_output(green_output), .blue_output(blue_output));

assign red = (display_time)? red_output: 0;
assign green = (display_time) ? green_output : 0;
assign blue = (display_time) ? blue_output : 0;

endmodule
