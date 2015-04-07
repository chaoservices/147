// Name: alu.v
// Module: simp_alu_comb
// Input: op1[32] - operand 1
//        op2[32] - operand 2
//        oprn[6] - operation code
// Output: result[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Sep 06, 2014	Kaushik Patra	kpatra@sjsu.edu		Fixed encoding for not and slt
//  1.2     Sep 08, 2014	Kaushik Patra	kpatra@sjsu.edu		Changed logical operation to bitwise operation for and, or, nor.
//  1.3     Sep 13, 2014        Kaushik Patra   kpatra@sjsu.edu         Data Flow style implementation of ALU
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module alu(result, op1, op2, oprn);
// input list
input [`DATA_INDEX_LIMIT:0] op1; // operand 1
input [`DATA_INDEX_LIMIT:0] op2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] oprn; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] result; // result of the operation.

assign result =   (oprn === `ALU_OPRN_WIDTH'h01)?(op1 + op2):
                ( (oprn === `ALU_OPRN_WIDTH'h02)?(op1 - op2): 
                ( (oprn === `ALU_OPRN_WIDTH'h03)?(op1 * op2):
                ( (oprn === `ALU_OPRN_WIDTH'h04)?(op1 >> op2):
                ( (oprn === `ALU_OPRN_WIDTH'h05)?(op1 << op2): 
                ( (oprn === `ALU_OPRN_WIDTH'h06)?(op1 & op2):
                ( (oprn === `ALU_OPRN_WIDTH'h07)?(op1 | op2):
                ( (oprn === `ALU_OPRN_WIDTH'h08)?~(op1 | op2):
                ( (oprn === `ALU_OPRN_WIDTH'h09)?(op1 < op2):
                  `DATA_WIDTH'hxxxxxxxx
                ))))))));

endmodule
