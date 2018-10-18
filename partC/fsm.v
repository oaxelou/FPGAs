module fsm(clk, reset, button, an3, an2, an1, an0, char);
input clk, reset, button;
output an3, an2, an1, an0;
output [3:0] char;

reg [3:0] counter;
reg an3, an2, an1, an0;
reg [3:0] char;
reg button_old;
reg [3:0] message_index;

reg [3:0] message [0:15];

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
		counter = 4'b1111;
		message_index = 4'b0000;
		button_old = 1'b0;
		char = message[0];
		
		an3 = 1'b1; 
		an2 = 1'b1;
		an1 = 1'b1;
		an0 = 1'b1;
		
		message[0]  = 4'b0000; 
		message[1]  = 4'b0001;
		message[2]  = 4'b0010;
		message[3]  = 4'b0011;

		message[4]  = 4'b0100; 
		message[5]  = 4'b0101;
		message[6]  = 4'b0110;
		message[7]  = 4'b0111;

		message[8]  = 4'b1000; 
		message[9]  = 4'b1001;
		message[10] = 4'b1010;
		message[11] = 4'b1011;

		message[12] = 4'b1100; 
		message[13] = 4'b1101;
		message[14] = 4'b1110;
		message[15] = 4'b1111; 
		
	end
	else begin
		//$display("counter is going to change");
		
		if(button_old == 1'b1 && button == 1'b0) begin
			$display("message_index going to be added!\n");
			message_index = message_index + 1;
		end
		button_old = button;
		
		case(counter)
			state15: begin
				an3 = 1'b1;
				counter = counter - 1;
			end
			state14: begin
				counter = counter - 1;
				char = message[message_index + 1];
			end
			//state13: counter = 4'b1100;
			state12: begin 
				counter = counter - 1;
				an2 = 1'b0; 				// prwth h anathesh sto char wste na mhn parei allo char? 
			end 
			state11: begin 
				counter = counter - 1;
				an2 = 1'b1; 
			end	
			state10: begin
				counter = counter - 1;
				char = message[message_index + 2]; 
			end
			//state9 : counter = 4'b1000;
			state8 : begin 
				counter = counter - 1;
				an1 = 1'b0; 
			end 
			state7 : begin
				counter = counter - 1;
				an1 = 1'b1;
			end
			state6 : begin
				counter = counter - 1;
				char = message[message_index + 3];
			end
			//state5 : counter = 4'b0100;
			state4 : begin 
				counter = counter - 1;
				an0 = 1'b0; 
			end 
			state3 : begin
				counter = counter - 1;
				an0 = 1'b1;
			end
			state2 : begin
				counter = counter - 1;
				char = message[message_index];
			end
			//state1 : counter = 4'b0000;
			state0 : begin 
				counter = counter - 1;
				an3 = 1'b0; 
			end
			default: begin 
				//$display ("DEFAULT"); 
				counter = counter - 1;
			end
		endcase
	end
end
endmodule 