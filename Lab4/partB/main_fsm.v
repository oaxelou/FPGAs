/* The main fsm
 *
 * I implemented it as Mealy FSM
 *
 *
 */

module main_fsm(clk, reset/*, instr_fsm_done*/, instr_fsm_enable, e, instruction);
input clk, reset/*, instr_fsm_done*/;
output reg instr_fsm_enable;
output reg e;
output reg [9:0] instruction;

reg [3:0] current_state;
reg [3:0] next_state;
reg [25:0] counter;    // 26 digits to display 50,000,000

parameter state_wait_15ms   = 4'b0000,
          state_0x03_first  = 4'b0001,
          state_wait_4_1ms  = 4'b0010,
          state_0x03_second = 4'b0011,
          state_wait_100us  = 4'b0100,
          state_0x03_third  = 4'b0101,
          state_wait_40us_1 = 4'b0110,
          state_0x02        = 4'b0111,
          state_wait_40us_2 = 4'b1000;


always @ (posedge clk or posedge reset)
begin
	if(reset)
	begin
		current_state <= state_wait_15ms;
		counter <= 'b0;
	end
	else
	begin
		current_state <= next_state;
		//if(instr_fsm_enable == 0)
			counter <= counter + 1;
		//else
			//counter <= 'b0;
	end
end


always @ (current_state or counter)
begin
	case(current_state)
    // **************************  INITIALIZATION ***************************//
		state_wait_15ms:
		begin
      e = 1'b0;
      instruction = 10'b00_0000_0000;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1011_0111_0001_1010_1111)     // decimal:  750,000-1
				next_state = state_0x03_first;
			else
				next_state = state_wait_15ms;
		end

		state_0x03_first:
		begin
			e = 1'b1;
      instruction = 10'b00_0000_0011;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1011_0111_0001_1011_1011)     // decimal: 750,012-1
				next_state = state_wait_4_1ms;
			else
				next_state = state_0x03_first;
		end

		state_wait_4_1ms:
		begin
			e = 1'b0;
      instruction = 10'b00_0000_0000;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1110_1001_0010_1000_0011)    // decimal: 955,012-1
				next_state = state_0x03_second;
			else
				next_state = state_wait_4_1ms;
		end

		state_0x03_second:
		begin
			e = 1'b1;
      instruction = 10'b00_0000_0011;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1110_1001_0010_1000_1111)    // decimal: 955,024-1
				next_state = state_wait_100us;
			else
				next_state = state_0x03_second;
		end

		state_wait_100us:
		begin
			e = 1'b0;
      instruction = 10'b00_0000_0000;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1110_1010_0110_0001_0111)    // decimal: 960,024-1
				next_state = state_0x03_third;
			else
				next_state = state_wait_100us;
		end

		state_0x03_third:
		begin
			e = 1'b1;
      instruction = 10'b00_0000_0011;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1110_1010_0110_0010_0011)    // decimal: 960,036-1
				next_state = state_wait_40us_1;
			else
				next_state = state_0x03_third;
		end

		state_wait_40us_1:
		begin
			e = 1'b0;
      instruction = 10'b00_0000_0000;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1110_1010_1101_1111_0011)    // decimal: 962,036-1
				next_state = state_0x02;
			else
				next_state = state_wait_40us_1;
		end

    state_0x02:
		begin
			e = 1'b1;
      instruction = 10'b00_0000_0010;
			instr_fsm_enable = 1'b0;
			if(counter == 'b1110_1010_1101_1111_1111)    // decimal: 962,048-1
				next_state = state_wait_40us_2;
			else
				next_state = state_0x02;
		end

    state_wait_40us_2:
    begin
      e = 1'b0;
      instruction = 10'b00_0000_0000;
      instr_fsm_enable = 1'b0;
      if(counter == 'b1110_1011_0101_1100_1111)    // decimal: 964,048-1
        next_state = 4'bXXXX;
      else
        next_state = state_wait_40us_2;
    end

		default:
		begin // it will never get in here
      e = 1'b0;
      instruction = 10'bXX_XXXX_XXXX;
      instr_fsm_enable = 1'b0;
			next_state = 4'bXXXX;
		end
	endcase
end

endmodule
