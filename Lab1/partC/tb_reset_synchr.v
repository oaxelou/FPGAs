`timescale 1ns/10ps

module reset_synchr_tb;

reg clk;
reg reset;
wire new_reset;

initial begin
clk = 1'b1;
#110 reset = 1;
#100 reset = 0;

#380 reset = 1;
#100 reset = 0;

#410 reset = 1;
#100 reset = 0;
end

always begin
#50 clk = ~clk;
end

reset_synchronizer synchr_inst(.clk(clk), .reset(reset), .new_reset(new_reset));

endmodule
