/* The initialization-configuration fsm
 *
 * I implemented it as Mealy FSM
 *
 *
 */

module initizalization_fsm(clk, reset, instr_fsm_done, instr_fsm_enable, init_done, e, instruction);
input clk, reset, instr_fsm_done;
output reg instr_fsm_enable, init_done;
output reg e;
output reg [9:0] instruction;

reg [3:0] current_state;
reg [3:0] next_state;
reg [19:0] counter;    // 20 digits to display 1,050,000

parameter state_wait_15ms   = 4'b0000,  /* initialization */
          state_0x03_first  = 4'b0001,
          state_wait_4_1ms  = 4'b0010,
          state_0x03_second = 4'b0011,
          state_wait_100us  = 4'b0100,
          state_0x03_third  = 4'b0101,
          state_wait_40us_1 = 4'b0110,
          state_0x02        = 4'b0111,
          state_wait_40us_2 = 4'b1000,
          state_funct_set   = 4'b1001,  /* configuration */
          state_entry_m_set = 4'b1010,
          state_display_on  = 4'b1011,
          state_clear_displ = 4'b1100,
          state_wait_1_64ms = 4'b1101,
          state_done        = 4'b1110,
          state_reset       = 4'b1111;

always @ (posedge clk or posedge reset)
begin
	if(reset)
	begin
		current_state <= state_reset;
		counter <= 'b0;
	end
	else
  begin
		current_state <= next_state;
		if(~instr_fsm_enable)
			counter <= counter + 1;
	end
end


always @ (current_state or counter or instr_fsm_done)
begin
  init_done = 1'b0;
	case(current_state)

    state_reset:
    begin
     e = 1'b0;
     instruction = 10'b00_0000_0001;   // Clear Display, 0x01
     instr_fsm_enable = 1'b1;
     if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        next_state = state_wait_15ms;
      end
     else
       next_state = state_reset;
    end

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
      begin
        next_state = state_funct_set;
      end
      else
        next_state = state_wait_40us_2;
    end

    // ************************* CONFIGURATION ****************************** //

		state_funct_set:
		begin
			e = 1'b0; // don't care
      instruction = 10'b00_0010_1000;  // Function Set, 0x28
			instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_entry_m_set;
      end
			else
				next_state = state_funct_set;
		end

		state_entry_m_set:
		begin
			e = 1'b0; // don't care
      instruction = 10'b00_0000_0110;  // Entry Mode Set, 0x06
      instr_fsm_enable = 1'b1;
      if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        next_state = state_display_on;
      end
			else
				next_state = state_entry_m_set;
		end

		state_display_on:
		begin
			e = 1'b0; // don't care
      instruction = 10'b00_0000_1100;  // Display ON, 0x0C
			instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_clear_displ;
      end
			else
				next_state = state_display_on;
		end

    state_clear_displ:
		begin
			e = 1'b0; // don't care
      instruction = 10'b00_0000_0001;  // Clear Display, 0x01
			instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_wait_1_64ms;
      end
			else
				next_state = state_clear_displ;
		end

    state_wait_1_64ms:
    begin
      e = 1'b0;
      instruction = 10'b00_0000_0000;  // Don't care
      instr_fsm_enable = 1'b0;
      if(counter == 'b1111_1111_0110_0010_0011)    // decimal: (1,046,048 + 4)-1
        next_state = state_done;
      else
        next_state = state_wait_1_64ms;
    end

    state_done:
    begin
      e = 1'b0;
      instruction = 10'b00_0000_0000;
      instr_fsm_enable = 1'b0;

      init_done = 1'b1;
      next_state = state_done;
    end

		default:
		begin // it will never get in here
      e = 1'b0;
      init_done = 1'b0;
      instruction = 10'bXX_XXXX_XXXX;
      instr_fsm_enable = 1'b0;
			next_state = 4'bXXXX;
		end
	endcase
end

endmodule
