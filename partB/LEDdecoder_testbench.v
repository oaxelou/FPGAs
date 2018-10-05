`timescale 1ns / 100ps

module LEDdecoder_testbench(/*clk*/);

// input clk;
reg [3:0] in;
wire [6:0] out;

LEDdecoder deco(in, out);

integer i;
initial begin
	in = 4'b0000;
	#1;
   	for(i = 1; i < 16; i = i + 1) begin
		in = in + 1;
		$display("input changed!");
		#1;
   	end	
end


// while @( posedge clk)

endmodule