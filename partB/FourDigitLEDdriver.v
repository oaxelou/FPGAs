module FourDigitLEDdriver(reset, clk, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);
input clk, reset;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;

wire new_clk;
wire reset_debounce;
wire [6:0] LED;
wire [3:0] char;

/*DCM #( ...
) DCM_inst (
);*/


assign new_clk = clk;   // PROSWRINA

debounce_circuit debounceINSTANCE(clk, reset, reset_debounce);

fsm fsmINSTANCE(new_clk, reset_debounce, an3, an2, an1, an0, char);

LEDdecoder LEDdecoderINSTANCE(char, LED);

assign a = LED[6];
assign b = LED[5];
assign c = LED[4];
assign d = LED[3];
assign e = LED[2];
assign f = LED[1];
assign g = LED[0];
assign dp = 1'b0;

endmodule
