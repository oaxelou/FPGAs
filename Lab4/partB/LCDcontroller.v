/* PartA: The command FSM (internal)
 *
 *
 *
 */


module LCDcontroller(clk, reset, LCD_E, LCD_RS, LCD_RW, SF_D);
input clk, reset;
output LCD_E, LCD_RS, LCD_RW;
output [3:0] SF_D;

wire [9:0] instruction, init_fsm_instr, write_fsm_instr;
wire instr_fsm_enable;
wire init_done, upper;
wire write_instr_fsm_enable, init_instr_fsm_enable;
wire instr_LCD_E, init_LCD_E;

assign instr_fsm_enable = init_done ? write_instr_fsm_enable : init_instr_fsm_enable;
assign instruction = init_done ? write_fsm_instr : init_fsm_instr;

assign LCD_E  = init_done | instr_fsm_enable ? instr_LCD_E : init_LCD_E;
assign LCD_RS = instruction[9];
assign LCD_RW = instruction[8];
assign SF_D = (instr_fsm_enable & upper) ? instruction[7:4]:
                                           instruction[3:0]; // because we want to choose the second one when instr_fsm is not enabled
                                                             // otherwise to choose between upper & lower (instr_fsm 's responsibility)

main_fsm main_fsm_inst(.clk(clk), .reset(reset), .init_done(init_done));

initizalization_fsm init_fsm_inst(.clk(clk), .reset(reset),
                                  .instr_fsm_done(instr_fsm_done),
                                  .instr_fsm_enable(init_instr_fsm_enable),
                                  .init_done(init_done), .e(init_LCD_E),
                                  .instruction(init_fsm_instr));

infinite_fsm write_fsm_inst(.clk(clk), .reset(reset), .init_done(init_done),
                            .instr_fsm_done(instr_fsm_done),
                            .instr_fsm_enable(write_instr_fsm_enable),
                            .instruction(write_fsm_instr));

instruction_fsm instr_fsm (.clk(clk), .reset(reset),
                           .instr_fsm_enable(instr_fsm_enable), .e(instr_LCD_E),
                           .instr_fsm_done(instr_fsm_done), .upper(upper));
endmodule
