/* The main fsm
 *
 * I implemented it as Mealy FSM
 *
 * FTIAKSE TI TIMES TWN STATES
 *
 * MPORW NA RUTHMISW SE POIO MEROS THS MNHMHS THA PAEI NA DIAVASEI ME TON COUNTER
 */

module infinite_fsm(clk, reset, init_done, instr_fsm_done, instr_fsm_enable, instruction);
input clk, reset, init_done, instr_fsm_done;
output reg instr_fsm_enable;
output reg [9:0] instruction;

reg [4:0] current_state;
reg [4:0] next_state;
reg [25:0] counter;    // 26 digits to display 50,000,000

parameter state_wait_4_init = 5'b00000,  /*  write  data  */
          state_set_aDDr_00 = 5'b01110,
          state_write_top   = 5'b01111,
          state_set_aDDr_40 = 5'b10000,
          state_write_bottom= 5'b10001,
          state_wait_1sec   = 5'b10010,
          state_set_aDDr_4F = 5'b10011,
          state_write_bit   = 5'b10100;

always @ (posedge clk or posedge reset)
begin
	if(reset)
	begin
		current_state <= state_wait_4_init;
		counter <= 'b0;
	end
	else
	begin
		current_state <= next_state;
		if(~instr_fsm_enable & init_done)
			counter <= counter + 1;
	end
end


always @ (current_state or counter or instr_fsm_done)
begin
	case(current_state)
    // **************************  WRITE DATA  ****************************** //
    state_wait_4_init:
    begin
      instruction = 10'b00_0000_0000;  // don't care
      instr_fsm_enable = 1'b0;         // don't care
      if(counter == 1)
        next_state = state_set_aDDr_00;
      else
        next_state = state_wait_4_init;
    end

    state_set_aDDr_00:
    begin
      instruction = 10'b00_1000_0000;  // Set DDRAM address to 00 (top left corner)
      instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_write_top;
      end
      else
        next_state = state_set_aDDr_00;
    end

		state_write_top:
		begin
      instruction = 10'b10_0100_0001;  // Write character 'A'
			instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_set_aDDr_40;
      end
			else
				next_state = state_write_top;
		end

		state_set_aDDr_40:
		begin
      instruction = 10'b00_1100_0000;  // Set DDRAM address to 40 (bottom left corner)
      instr_fsm_enable = 1'b1;
      if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        next_state = state_write_bottom;
      end
			else
				next_state = state_set_aDDr_40;
		end

		state_write_bottom:
		begin
      instruction = 10'b10_0110_0001;  // Write character 'a'
			instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_wait_1sec;
      end
			else
				next_state = state_write_bottom;
		end

    state_wait_1sec:
    begin
      instruction = 10'b00_0000_0000;  // Don't care
      instr_fsm_enable = 1'b0;
      if(counter == 'b10_1111_1010_1111_0000_1000_0101)    // decimal: (50,000,000 + 6)-1
        next_state = state_set_aDDr_4F;
      else
        next_state = state_wait_1sec;
    end

    state_set_aDDr_4F:
		begin
      instruction = 10'b00_1100_1111;  // Set DDRAM address to 4F (bottom right corner)
      instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_write_bit;
      end
			else
				next_state = state_set_aDDr_4F;
		end

    state_write_bit:
    begin
      instruction = 10'b10_1111_1111;  // Write cursor character
      instr_fsm_enable = 1'b1;
      if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        next_state = 5'bXXXXX;
      end
      else
        next_state = state_write_bit;
    end

		default:
		begin // it will never get in here
      instruction = 10'bXX_XXXX_XXXX;
      instr_fsm_enable = 1'b0;
			next_state = 5'bXXXXX;
		end
	endcase
end

endmodule
