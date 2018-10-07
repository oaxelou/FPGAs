module debounce_circuit(clk, button, reset);
input clk, button;
output reset;
reg reset;
reg FF1, FF2;
wire enable;

always @(clk or button) begin
	FF1 <= button;
	FF2 <= FF1;
end

assign enable = FF1 ~^ FF2;

always @(clk or enable or FF1) begin  //to FF2 to xreiazetai?!
	if(enable == 1'b1)
		reset <= FF1;
end

endmodule 