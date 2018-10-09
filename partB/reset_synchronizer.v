module reset_synchronizer(clk, reset, new_reset);

input clk, reset;
output new_reset;
reg new_reset;
reg f1_output;

always @(posedge clk) begin
	f1_output = reset;
end

always @(posedge clk) begin
	new_reset = f1_output;
end

endmodule