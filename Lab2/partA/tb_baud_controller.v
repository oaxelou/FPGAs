module tb_baud_controller;

reg clk, reset;

wire sample_ENABLE;

initial
begin
  clk = 1'b1;

  #200 reset = 1'b1;
  #100 reset = 1'b0;

  #1200 reset = 1'b1;
  #100  reset = 1'b0;
end

always #10 clk = ~clk;

baud_controller baud_controllerINSTANCE(.reset(reset), .clk(clk), .baud_select(000),
                                        .sample_ENABLE(sample_ENABLE));

endmodule
