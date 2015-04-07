/**Name: alu.v
   Module: ALU
   Input: OP1[32] - operand 1
          OP2[32] - operand 2
          OPRN[6] - operation code
   Output: OUT[32] - output result for the operation
  
   Notes: 32 bit combinatorial ALU
   
   Supports the following functions
  	- Integer add (0x1), sub(0x2), mul(0x3)
  	- Integer shift_rigth (0x4), shift_left (0x5)
  	- Bitwise and (0x6), or (0x7), nor (0x8)
        - set less than (0x9)
  
   Revision History:
  
   Version	Date		Who		email			note
------------------------------------------------------------------------------------------
    1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
------------------------------------------------------------------------------------------*/
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
	// input list
	input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
	input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
	input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

	// output list
	output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
	output ZERO;

	wire [31:0] addSubWire;
	wire [31:0] shftWire;
	wire [31:0] mulWire;
	wire [31:0] andWire;
	wire [31:0] orWire;
	wire [31:0] norWire;
	// TBD
	wire [31:0] nullWire;
	wire [31:0] muxWire;
	wire lnr;
	wire andADDWire;
	wire orADDWire;

	and andADD(andADDWire, OPRN[0], OPRN[3]);

	rc_add_sub_32 addSub(.result(addSubWire), .carryOut(nullWire[0]), .operand1(OP1), .operand2(OP2), .subtractNotAdd(OPRN[1]));//R=A+B

	mult mult_32Bit_Signed(.resultHigh(nullWire), .resultLow(mulWire), .multiplicand(OP1), .multiplier(OP2));

	not lnrNOT(lnr, OPRN[0]);
	barrel_shifter b1(shftWire, OP1, OP2, lnr);
	
	nor32 n1(.result(norWire), .operand1(OP1), .operand2(OP2));

	or32 o1(.result(orWire), .operand1(OP1), .operand2(OP2));
	
	and32 a1(.result(andWire), .operand1(OP1), .operand2(OP2));

	mux32_16x1 m1(muxWire, addSubWire, addSubWire, addSubWire, mulWire, 
		shftWire, shftWire, andWire, orWire, 
		norWire, addSubWire, addSubWire, addSubWire, 
		addSubWire, addSubWire, addSubWire, 
		addSubWire, OPRN[3:0]);

	or31x1 or1(ZERO, muxWire);
	buf32 bbb(OUT, muxWire);
endmodule
