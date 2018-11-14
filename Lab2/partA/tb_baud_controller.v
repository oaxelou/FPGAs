/*
 *
 * Treksto gia 600ns !
 */

module tb_baud_controller;

reg clk, reset;
reg [2:0] reg_baud_select;

wire sample_ENABLE;

initial
begin
  clk = 1'b1;

  #200 reset = 1'b1;
  #100 reset = 1'b0;

  #1200 reset = 1'b1;
  #100  reset = 1'b0;
  
  reg_baud_select = 3'b111;
  #5000
  reg_baud_select = 3'b110;
  #5000
  reg_baud_select = 3'b101;
  #5000
  reg_baud_select = 3'b100;
  #10000
  reg_baud_select = 3'b011;
  #15000
  reg_baud_select = 3'b010;
  #30000
  reg_baud_select = 3'b001;
  #60000
  reg_baud_select = 3'b000;
end

always #10 clk = ~clk;

baud_controller baud_controllerINSTANCE(.reset(reset), .clk(clk), .baud_select(reg_baud_select),
                                        .sample_ENABLE(sample_ENABLE));

endmodule
