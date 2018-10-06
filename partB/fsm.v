module fsm(clk, reset, an3, an2, an1, an0, char);

input clk, reset;
output an3, an2, an1, an0;
output [3:0] char;

reg [3:0] counter;
reg an3, an2, an1, an0;
reg [3:0] char;

parameter state15 = 4'b1111,
          state14 = 4'b1110,
          state13 = 4'b1101,
          state12 = 4'b1100,
          state11 = 4'b1011,
          state10 = 4'b1010,
          state9  = 4'b1001,
          state8  = 4'b1000,
          state7  = 4'b0111,
          state6  = 4'b0110,
          state5  = 4'b0101,
          state4  = 4'b0100,
          state3  = 4'b0011,
          state2  = 4'b0010,
          state1  = 4'b0001,
          state0  = 4'b0000;

always @(posedge clk or posedge reset) begin
	if(reset) begin
		$display("resetting..");
		counter = 4'b0000;
		an3 = 1'b1;
		an2 = 1'b1;
		an1 = 1'b1;
		an0 = 1'b1;
	end
	else begin
		$display("counter is going to change");

		case(counter)
			state15: counter = 4'b1110;
			state14: begin 
				counter = 4'b1101; 
				an3 = 1'b1; 
			end
			state13: counter = 4'b1100;
			state12: begin 
				counter = 4'b1011; 
				an2 = 1'b0; 				// prwth h anathesh sto char wste na mhn parei allo char?
				char = 4'b0001; 
			end 
			state11: counter = 4'b1010;
			state10: begin 
				counter = 4'b1001; 
				an2 = 1'b1; 
			end
			state9 : counter = 4'b1000;
			state8 : begin 
				counter = 4'b0111; 
				an1 = 1'b0; 
				char = 4'b1010; 
			end 
			state7 : counter = 4'b0110;
			state6 : begin 
				counter = 4'b0101; 
				an1 = 1'b1; 
			end
			state5 : counter = 4'b0100;
			state4 : begin 
				counter = 4'b0011; 
				an0 = 1'b0; 
				char = 4'b1111; 
			end 
			state3 : counter = 4'b0010;
			state2 : begin 
				counter = 4'b0001; 
				an0 = 1'b1; 
			end
			state1 : counter = 4'b0000;
			state0 : begin 
				counter = 4'b1111; 
				an3 = 1'b0; 
				char = 4'b0000; 
			end
			default: begin $display ("DEFAULT"); 
                        counter = 4'b1111; end
		endcase
	end
end
endmodule 