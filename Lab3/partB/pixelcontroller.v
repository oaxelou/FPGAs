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
 * pixelcontroller: Takes as input the selected address and gives as
 * output the RGB color (3bit).
 *
 * input :  reset, clk, display_time
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
 *  -> 1 assign (combinational logic). Subtracts from the beginning of a line
 *          in memory the memorycounter to produce the final address.
 *          For only this part, the beginning of the line is fixed to one of
 *          the last section (the multicolor, vertical one) but in partC it's
 *          changed to its final form.
 *
 *  -> 1 instantiation (the bram)
 */

module pixelcontroller(reset, clk, display_time, red, green, blue);
input reset, clk, display_time;
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
  else if(display_time)  // this part in ON only when it is display_time
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


// sets the final address: Sybtracts the horizontal counter
// from the beginning pixel of the current line
// The current line is the vertical: <1 white, 2 red, 2 green, 2 blue, 1 white>
assign address = 14'b00_1011_0111_1111 - memorycounter;

bram Bram_INSTANCE(.clk(clk), .reset(reset), .en(en), .address(address),
                      .red_output(red_output), .green_output(green_output), .blue_output(blue_output));

assign red = (display_time)? red_output: 0;
assign green = (display_time) ? green_output : 0;
assign blue = (display_time) ? blue_output : 0;

endmodule
