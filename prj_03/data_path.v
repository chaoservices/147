/**Name: data_path.v
 Module: DATA_PATH
 Output:  DATA : Data to be written at address ADDR
          ADDR : Address of the memory location to be accessed

 Input:   DATA : Data read out in the read operation
          CLK  : Clock signal
          RST  : Reset signal

 Notes: - 32 bit processor implementing cs147sec05 instruction set

 Revision History:

 Version	Date		Who		email			note
------------------------------------------------------------------------------------------
  1.0     Sep 10, 2014	      Kaushik Patra     kpatra@sjsu.edu	        Initial creation
  1.1     Oct 19, 2014        Kaushik Patra     kpatra@sjsu.edu         Fixed the RF connection
  1.2     5 Dec, 2014         David-Eric Thorpe                         Implimented 
------------------------------------------------------------------------------------------
TDB figure out what if the memory controls work */
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

	// output list
	output [`ADDRESS_INDEX_LIMIT:0] ADDR;
	output ZERO;
	output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

	// input list
	input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
	input CLK, RST;
	input [`DATA_INDEX_LIMIT:0] DATA_IN;
	
	//wires
	wire dull;
	wire [31:0] pcw, spw, addw, add1w, rfw1, rfw2, irw, aw, wd_sel_1w, wd_sel_2w, wd_sel_3w,
		wa_sel_1w, wa_sel_2w, wa_sel_3w, r1_sel_1w, ma_sel_1w, ma_sel_2w, op1_sel_1w,
		op2_sel_1w, op2_sel_2w, op2_sel_3w, op2_sel_4w, pc_sel_1w, pc_sel_2w, pc_sel_3w;
	//wires

	rc_add_sub_32 add(addw, nowhere, add1w, {{16{irw[15]}}, irw[15:0]}, 0);//16 bit sign extended {{16{irw[15]}}, immediate}
	rc_add_sub_32 add1(add1w, nowhere, 1, pcw, 0);

	defparam PC.PATTERN=32'h00001000;
	REG32_PP PC(pcw, pc_sel_3w, CTRL[0], CLK, RST);

	mux32_2x1 pc_sel_1(pc_sel_1w, rfw1, add1w, CTRL[1]);
	mux32_2x1 pc_sel_2(pc_sel_2w, pc_sel_1w, addw, CTRL[2]);
	mux32_2x1 pc_sel_3(pc_sel_3w, {6'b0, irw[25:0]}, pc_sel_2w, CTRL[2]);//6-bit zero extender {6'b0, address}

	//ctrl[5:4] mem read and write
	bit32_regester ir(irw, CLK, CTRL[4], DATA_IN, RST);

	REGISTER_FILE_32x32 rf(rfw1, rfw2, r1_sel_1w, irw[20:16], 
        	wd_sel_3w, wa_sel_3w, CTRL[6], CTRL[7], CLK, RST);

	mux32_2x1 r1_sel_1(r1_sel_1w, irw[25:21], 0, CTRL[8]);

	defparam SP.PATTERN=32'h03ffffff;
	REG32_PP SP(spw, aw, CTRL[9], CLK, RST);

	mux32_2x1 op1_sel_1(op1_sel_1w, rfw1, spw, CTRL[10]);

	mux32_2x1 op2_sel_1(op2_sel_1w, 1, {27'b0, irw[10:6]}, CTRL[11]);//27 bit zero extended SHAMT [10:6]
	mux32_2x1 op2_sel_2(op2_sel_2w, {{{16'b0}}, irw[15:0]}, {{16{irw[15]}}, irw[15:0]}, CTRL[12]);//16 bit zero extended imm//16 bit sign extended imm
	mux32_2x1 op2_sel_3(op2_sel_3w, op2_sel_2w, op2_sel_1w, CTRL[13]);
	mux32_2x1 op2_sel_4(op2_sel_4w, op2_sel_3w, rfw2, CTRL[14]);

	ALU a(aw, ZERO, op2_sel_4w, op1_sel_1w, CTRL[20:15]); //op1 and op2 order?

	mux32_2x1 ma_sel_1(ma_sel_1w, aw, spw, CTRL[21]);
	mux32_2x1 ma_sel_2(ADDR, ma_sel_1w, pcw, CTRL[22]);

	mux32_2x1 md_sel_1(DATA_OUT, rfw2, rfw, CTRL[23]);

	//dmem1_r[24] dmem2_r[25]

	mux32_2x1 wd_sel_1(wd_sel_1w, aw, DATA_IN, CTRL[26]);
	mux32_2x1 wd_sel_2(wd_sel_2w, wd_sel_1w, {irw[15:0], {16{irw[15]}}}, CTRL[27]); //16 bit LSB exteneded{16{1'b0}}immm {irw[15:0], {16{irw[15]}}}
	mux32_2x1 wd_sel_3(wd_sel_3w, add1w, wd_sel_2w, CTRL[28]);

	mux32_2x1 wa_sel_1(wa_sel_1w, irw[20:16], irw[15:11], CTRL[29]);
	mux32_2x1 wa_sel_2(wa_sel_2w, 0, 31, CTRL[30]);
	mux32_2x1 wa_sel_3(wa_sel_3w, wa_sel_2w, wa_sel_1w, CTRL[31]);

endmodule	
