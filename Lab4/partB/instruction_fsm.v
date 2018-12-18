/* The instruction fsm
 *
 * I implemented it as Mealy FSM 
 *
 *
 */

module instruction_fsm(clk, reset, instr_fsm_enable, e, instr_fsm_done, upper);
input clk, reset, instr_fsm_enable;
output reg  e, instr_fsm_done;
output upper;
// output [3:0] sf_d;

reg [2:0] current_state;
reg [2:0] next_state;
reg [11:0] counter;

parameter state_setup_upper = 3'b000,
          state_data_upper  = 3'b001,
          state_hold_upper  = 3'b010,
          state_wait_interm = 3'b011,
          state_setup_lower = 3'b100,
          state_data_lower  = 3'b101,
          state_hold_lower  = 3'b110,
          state_done        = 3'b111;


// edw tha ginei ena assign me poluplekth gia upper h lower nibble
assign upper = (current_state == state_setup_upper ||
                current_state == state_data_upper  ||
                current_state == state_hold_upper ) ? 1 : 0;

always @ (posedge clk or posedge reset)
begin
	if(reset)
	begin
		current_state <= state_setup_upper;
		counter <= 'b0;
	end
	else
	begin
		current_state <= next_state;
		if(instr_fsm_enable)
			counter <= counter + 1;
		else
			counter <= 'b0;
	end
end


always @ (current_state or counter)
begin
	case(current_state)

		state_setup_upper:
		begin
			e = 1'b0;
			instr_fsm_done = 1'b0;
			if(counter == 'b10)                         // decimal:  2
				next_state = state_data_upper;
			else
				next_state = state_setup_upper;
		end

		state_data_upper:
		begin
			e = 1'b1;
			instr_fsm_done = 1'b0;
			if(counter == 'b1110)                      // decimal: 14
				next_state = state_hold_upper;
			else
				next_state = state_data_upper;
		end

		state_hold_upper:
		begin
			e = 1'b0;
			instr_fsm_done = 1'b0;
			if(counter == 'b1111)                     // decimal: 15
				next_state = state_wait_interm;
			else
				next_state = state_hold_upper;
		end

		state_wait_interm:
		begin
			e = 1'b0;
			instr_fsm_done = 1'b0;
			if(counter == 'b0100_0001)               // decimal: 65
				next_state = state_setup_lower;
			else
				next_state = state_wait_interm;
		end

		state_setup_lower:
		begin
			e = 1'b0;
			instr_fsm_done = 1'b0;
			if(counter == 'b100_0011)               // decimal:  67
				next_state = state_data_lower;
			else
				next_state = state_setup_lower;
		end

		state_data_lower:
		begin
			e = 1'b1;
			instr_fsm_done = 1'b0;
			if(counter == 'b0100_1111)             // decimal: 79
				next_state = state_hold_lower;
			else
				next_state = state_data_lower;
		end

		state_hold_lower:
		begin
			e = 1'b0;
			instr_fsm_done = 1'b0;
			if(counter == 'b0101_0000)            // decimal: 80
				next_state = state_done;
			else
				next_state = state_hold_lower;
		end

		state_done:
		begin
			e = 1'b0;
			if(counter == 'b1000_0010_0000)      // decimal: 2080
			begin
				next_state = state_setup_upper;
				instr_fsm_done = 1'b1;
			end
			else
			begin
				next_state = state_done;
				instr_fsm_done = 1'b0;
			end
		end

		default:
		begin // it will never get in here
			next_state = 3'bXXX;
			e = 1'b0;
			instr_fsm_done = 1'b0;
		end
	endcase
end

endmodule
