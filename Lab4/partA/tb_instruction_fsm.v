`timescale 1ns / 10ps

/*
 * Gia na leitourghsei o mhxanismos instr_fsm_enable - instr_fsm_done
 * prepei na uparxei diasthma enos kuklou apo th stigmh pou thetw to
 * instr_fsm_enable = 0 (otan lavw instr_fsm_done) kai apo th stigmh
 * pou tha thesw instr_fsm_enable = 1
 */

module tb_instruction_fsm;

	// Inputs
	reg clk;
	reg reset;
	reg instr_fsm_enable;

	// Outputs
	wire e;
	wire instr_fsm_done;
	wire upper;

	reg [9:0] instruction;

	wire [5:0] encoding;

	instruction_fsm instr_fsm (.clk(clk), .reset(reset),
	                           .instr_fsm_enable(instr_fsm_enable), .e(e),
											       .instr_fsm_done(instr_fsm_done), .upper(upper));

	assign encoding[5] = instruction[9];
	assign encoding[4] = instruction[8];
	assign encoding[3:0] = upper ? instruction[7:4] : instruction[3:0];

	initial begin
		clk = 1;
		reset = 0;
		instr_fsm_enable = 0;

		#100;
      reset = 1;
		#20;
		reset = 0;

		// ############ THE TESTING COMMENCE HERE ################

		// Going to send a Function Set instruction
		instruction = 10'b00_0010_1000;
		instr_fsm_enable = 1;
		while(instr_fsm_done == 0) #20;
		instr_fsm_enable = 0;

		#100;

		// Going to send Display ON instruction
		instruction = 10'b00_0000_1100;
		instr_fsm_enable = 1;
		while(instr_fsm_done == 0) #20;
		instr_fsm_enable = 0;

		#100;

		// Going to write letter 'S'
		instruction = 10'b10_0110_0011;
		instr_fsm_enable = 1;
		while(instr_fsm_done == 0) #20;
		instr_fsm_enable = 0;

	end

	always #10 clk = ~clk;

endmodule
