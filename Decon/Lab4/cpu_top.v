module cpu_top(clk, clear, inst_addr, instruction, r1, r2, r3, dp_result, comp_out);
	input clk;
	input clear;
	output [3:0] inst_addr;
	output [6:0] instruction;
	output [3:0] r1, r2, r3;
	output [3:0] dp_result;
	output comp_out;
	wire cpu_clk, clk_1, clk_10, clk_100, clk_1k;
	wire simulation = 1'b1;
	assign cpu_clk = simulation ? clk : clk_1;
	gen_multi_clk c0(
		.CLOCK(clk),
		.CK_1Hz(clk_1),
		.CK_10Hz(clk_10),
		.CK_100Hz(clk_100),
		.CK_1KHz(clk_1k));
	wire [3:0] inst_addr;
	wire pc_enable, pc_load;
	wire comp_out;
	wire pc_en, r1_en, r1_sel, r2_en, clear_regfile, r3_en, comp_en, result_sel;
	wire [6:0] instruction;
	wire [3:0] dp_result;
	wire [3:0] r1, r2, r3;
	//disable pc after address 1111
	assign pc_enable = ~(inst_addr[0] & inst_addr[1] & inst_addr[2] & inst_addr[3]);
	assign pc_load = pc_en & comp_out;
	program_counter pc0(
		.clk(cpu_clk),
		.enable(pc_enable),
		.reset(clear),
		.load(pc_load),
		.data(instruction[3:0]),
		.q(inst_addr));
	instruction_ROM ir0(
		.addr(inst_addr),
		.inst(instruction));
	instruction_decoder id0(
		.inst(instruction[6:4]),
		.pc_en(pc_en),
		.r1_en(r1_en),
		.r1_sel(r1_sel),
		.r2_en(r2_en),
		.clear(clear_regfile),
		.r3_en(r3_en),
		.comp_en(comp_en),
		.result_sel(result_sel));
	regfile r0(
		.clk(cpu_clk),
		.instant(instruction[3:0]),
		.dp_result(dp_result),
		.r1_en(r1_en),
		.r1_sel(r1_sel),
		.r2_en(r2_en),
		.clear(clear_regfile),
		.r3_en(r3_en),
		.comp_in(dp_comp_out),
		.comp_en(comp_en),
		.r1(r1),
		.r2(r2),
		.r3(r3),
		.comp_out(comp_out));
	datapath dp0(
		.r1(r1),
		.r2(r2),
		.op(result_sel),
		.comp(dp_comp_out),
		.dp_out(dp_result));
endmodule
