/* The main fsm
 *
 * I implemented it as Mealy FSM
 *
 */

module infinite_fsm(clk, reset, init_done, instr_fsm_done, instr_fsm_enable, instruction, address, output_char);
input clk, reset, init_done, instr_fsm_done;
input [7:0] output_char;
output reg instr_fsm_enable;
output reg [9:0] instruction;
output reg [10:0] address;

reg [3:0] current_state;
reg [3:0] next_state;
reg [26:0] counter;    // 26 digits to display 50,000,000


parameter state_wait_4_init  = 4'b0000, //  0
          state_set_aDDr_00  = 4'b0001, //  1
          state_write_top    = 4'b0010, //  2
          state_set_aDDr_40  = 4'b0011, //  3
          state_write_bottom = 4'b0100, //  4
          state_wait_1s_1    = 4'b0101, //  5
          state_set_aDDr_4F  = 4'b0110, //  6
          state_write_cursor = 4'b0111, //  7
          state_wait_1s_2    = 4'b1000, //  8
          state_set_aDDr_4F_2= 4'b1001, //  9
          state_write_blank  = 4'b1010; // 10


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
      if(counter == 'd100000038)
        counter <= 35;
      else
			   counter <= counter + 1;
	end
end


always @ (current_state or counter or instr_fsm_done or output_char)
begin

	case(current_state)
    // **************************  WRITE DATA  ****************************** //
    state_wait_4_init:
    begin
      address = 'b0;
      instruction = 10'b00_0000_0000;  // don't care
      instr_fsm_enable = 1'b0;         // don't care
      if(counter == 1)
        next_state = state_set_aDDr_00;
      else
        next_state = state_wait_4_init;
    end

    state_set_aDDr_00:
    begin
      address = 'b0;
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
      instruction = {2'b10, output_char};
      //instruction = 10'b10_0100_0001;  // Write character 'A'
      address = counter - 'b11; // dhladh address = 0 thn prwth fora

      instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        if(address == 15)
				  next_state = state_set_aDDr_40;
        else
          next_state = state_write_top;
      end
			else
				next_state = state_write_top;
		end

		state_set_aDDr_40:
		begin
      address = 16;
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
      instruction = {2'b10, output_char};
      //instruction = 10'b10_0110_0001;  // Write character 'a'
      address = counter - 'b100;
			instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        if(address == 31)
				    next_state = state_wait_1s_1;
        else
          next_state = state_write_bottom;
      end
			else
				next_state = state_write_bottom;
		end

    // ****************** THE INFINITE LOOP ********************************* //

    state_wait_1s_1:
    begin
      address = 'b0;
      instruction = 10'b00_0000_0000;  // Don't care
      instr_fsm_enable = 1'b0;
      if(counter == 'd50000035) //'b10_0100_1100_0100_1011_1010_0100)    // decimal: (50,000,000 + 36)-1
        next_state = state_set_aDDr_4F;
      else
        next_state = state_wait_1s_1;
    end

    state_set_aDDr_4F:
		begin
      address = 'b0;
      instruction = 10'b00_1100_1111;  // Set DDRAM address to 4F (bottom right corner)
      instr_fsm_enable = 1'b1;
			if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
				next_state = state_write_cursor;
      end
			else
				next_state = state_set_aDDr_4F;
		end

    state_write_cursor:
    begin
      address = 'b0;
      instruction = 10'b10_1111_1111;  // Write cursor character
      instr_fsm_enable = 1'b1;
      if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        next_state = state_wait_1s_2;
      end
      else
        next_state = state_write_cursor;
    end

    state_wait_1s_2:
    begin
      address = 'b0;
      instruction = 10'b00_0000_0000;  // Don't care
      instr_fsm_enable = 1'b0;
      if(counter == 'd100000037) //'b10_0100_1100_0100_1011_1010_0100)    // decimal: (100,000,000 + 38)-1
        next_state = state_set_aDDr_4F_2;
      else
        next_state = state_wait_1s_2;
    end

    state_set_aDDr_4F_2:
    begin
      address = 'b0;
      instruction = 10'b00_1100_1111;  // Set DDRAM address to 4F (bottom right corner)
      instr_fsm_enable = 1'b1;
      if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        next_state = state_write_blank;
      end
      else
        next_state = state_set_aDDr_4F_2;
    end

    state_write_blank:
    begin
      address = 'b0;
      instruction = 10'b10_0010_0000;  // Write blank space character
      instr_fsm_enable = 1'b1;
      if(instr_fsm_done)
      begin
        instr_fsm_enable = 1'b0;
        next_state = state_wait_1s_1;
      end
      else
        next_state = state_write_blank;
    end

		default:
		begin // it will never get in here
      address = 11'bXXX_XXXX_XXXX;
      instruction = 10'bXX_XXXX_XXXX;
      instr_fsm_enable = 1'b0;
			next_state = 4'bXXXX;
		end
	endcase
end

endmodule
