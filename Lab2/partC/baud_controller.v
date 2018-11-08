
module baud_controller(reset, clk, baud_select, sample_ENABLE);

input reset, clk;
input [2:0] baud_select;
output sample_ENABLE;
reg sample_ENABLE;
reg [15:0] counter;
reg [15:0] samp_period_counter;

always @(posedge clk or posedge reset)
begin
  if(reset)
    case(baud_select)
      3'b000: samp_period_counter = 16'b0010_1000_1011_0001;
      3'b001: samp_period_counter = 16'b0000_1010_0010_1100;
      3'b010: samp_period_counter = 16'b0000_0010_1000_1011;
      3'b011: samp_period_counter = 16'b0000_0001_0100_0110;
      3'b100: samp_period_counter = 16'b0000_0000_1010_0011;
      3'b101: samp_period_counter = 16'b0000_0000_0101_0001;
      3'b110: samp_period_counter = 16'b0000_0000_0011_0110;
      3'b111: samp_period_counter = 16'b0000_0000_0001_1011;
    endcase
end

// reset asychrono??????
always @(posedge clk or posedge reset)
  if(reset)
  begin
    counter = 16'b0;
    sample_ENABLE = 1'b0;
  end
  else
    if (counter == samp_period_counter - 1)
    begin
      sample_ENABLE = 1'b1;
      counter = 16'b0;
    end
    else
    begin
      sample_ENABLE = 1'b0;
      counter = counter + 1;
    end
begin

end

endmodule
