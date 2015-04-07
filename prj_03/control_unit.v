/** Module: CONTROL_UNIT
* Output: CTRL  : Control signal for data path
*         READ  : Memory read signal
*         WRITE : Memory Write signal
*
* Input:  ZERO : Zero status from ALU
*         CLK  : Clock signal
*         RST  : Reset Signal
*	  INSTRUCTION: Current instruction
*
* Notes: - Control unit synchronize operations of a processor
*          Assign each bit of control signal to control one part of data path
*
* Revision History:
*
*	Version	Date		Who		email			note
*------------------------------------------------------------------------------------------
*	1.0	Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
*	2.0	5, Dec 2014	David Thorpe              	      	Coded CTRL
*------------------------------------------------------------------------------------------*/
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
	// Output signals
	output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
	output READ, WRITE;
	reg [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
	reg READ, WRITE;

	// input signals
	input ZERO, CLK, RST;
	input [`DATA_INDEX_LIMIT:0] INSTRUCTION;

	reg [5:0] opcode;
	reg [4:0] rs;
	reg [4:0] rt;
	reg [4:0] rd;
	reg [4:0] shamt;
	reg [5:0] funct;
	reg [15:0] immediate;
	reg [25:0] address;

	wire [2:0] proc_state;
	PROC_SM state_machine(proc_state, CLK, RST);
	always @ (proc_state) begin
	        case (proc_state)
	        `PROC_FETCH : begin
			READ=1;
			WRITE=0;
			CTRL='b00000001010000000000000001010000;//CTRL='b0000 0001 0100 0000 0000 0000 0101 0000;
		end
		`PROC_DECODE : begin
		        {opcode, rs, rt, immediate} = INSTRUCTION;
		        {opcode, address} = INSTRUCTION;
		        {opcode, rs, rt, rd, shamt, funct} = INSTRUCTION;
			CTRL='b00000001000000000000000001010000;//b0000 0001 0000 0000 0000 0000 0101 0000//DONE!
		end
		`PROC_EXE : begin
			case(opcode)
			6'h00:/*R-Type operations*/ begin
            			case(funct)
            			6'h20:/*add: R[rd] = R[rs] + R[rt]*/ begin
					CTRL='b00000001000100000100000001000000;//CTRL='b0000 0001 0001 XXXX X100 0000 0100 0000;
            			end
            			6'h22:/*sub: R[rd] = R[rs] - R[rt]*/ begin
	            			CTRL='b00000001000010000100000001000000;//CTRL='b0000 0001 000X 1XXX X100 0000 0100 0000;
            			end
            			6'h2c:/*mul: R[rd] = R[rs] * R[rt]*/ begin
            				//CTRL='b0000 0010 0000 001X XXX1 1000 1000 0000//DONE!
            			end
            			6'h24:/*and: R[rd] = R[rs] & R[rt]*/ begin
            				//CTRL='b0000 0010 0000 001X XX11 X000 1000 0000//DONE!
            			end
            			6'h25:/*or: R[rd] = R[rs] | R[rt]*/  begin
            				//CTRL='b0000 0010 0000 001X XX11 1000 1000 0000//DONE!
            			end
            			6'h27:/*nor: R[rd] = ~(R[rs] | R[rt])*/ begin
            			 	//CTRL='b0000 0010 0000 001X X1xx X000 1000 0000//DONE!
            			end
            			6'h2a:/*Set less than(slt): R[rd] = (R[rs] < R[rt])?1:0*/ begin
            				//CTRL='b0000 0010 0000 001X XX11 1000 1000 0000//DONE!
            			end
            			6'h00:/*Shift less logical(sll): R[rd] = R[rs] << shamt*/ begin
            				//CTRL='b0000 0010 0001 010X XX10 0000 1000 0000//DONE!
            			end
            			6'h02:/*Shift right logical(srl): R[rd] = R[rs] >> shamt*/ begin
            				//CTRL='b0000 0010 0001 010X XX10 1000 1000 0000//DONE!
            			end
            			6'h08:/*Jump regester(jr): PC = R[rs]*/ begin
					CTRL='b00000001000000000000000001000000;//CTRL='b0000 0001 000X XXXX X000 0000 0100 0000;
            			end
				endcase
        		end
		        // I-type (I and J are cased solely on oppcode)
		        6'h08:/*addi: R[rt] = R[rs] + SignExtImm*/ begin
				CTRL='b00000001000100000001000001000000;//CTRL='b0000 0001 0001 XXXX X001 0000 0100 0000;
		        end
		        6'h1d:/*muli: R[rt] = R[rs] * SignExtImm*/ begin
				//CTRL='b0000 0010 0000 100X XXX1 1000 1000 0000//DONE!
		        end
		        6'h0c:/*andi: R[rt] = R[rs] & ZeroExtImm*/ begin
				//CTRL='b0000 0010 0000 000X XX11 X000 1000 0000//DONE!
		        end
		        6'h0d:/*ori: R[rt] = R[rs] | ZeroExtImm*/ begin
				//CTRL='b0000 0010 0000 000X XX11 1000 1000 0000//DONE!
		        end
		        6'h0f:/*lui: R[rt] = {imm, 16'b0}*/ begin
				CTRL='b00000001000000000000000001000000;//CTRL='b0000 0001 000X XXXX X000 0000 0100 0000;
		        end
		        6'h0a:/*slti: R[rt] = (R[rs] < SignExtImm)?1:0*/ begin
				//CTRL='b0000 0010 0000 000X X1XX 1000 1000 0000;//DONE!
		        end
		        6'h04:/*beq: If (R[rs] == R[rt]) PC = PC + 1 + BranchAddress*/ begin
				//CTRL='b0000 0010 0000 001X XXX1 X000 1000 0000;//DONE!
		        end
		        6'h05:/*bne: If (R[rs] != R[rt]) PC = PC + 1 + BranchAddress*/ begin
		            /*Tests for equality. In WB checks zero flag*/
				//CTRL='b0000 0010 0000 001X XXX1 X000 1000 0000;//DONE!
		        end
		        6'h23:/*lw: R[rt] = M[R[rs]+SignExtImm]*/ begin
				//CTRL='b0000 0010 0000 100X XXXX 1000 1000 0000;//DONE!
		        end
		        6'h2b:/*sw: M[R[rs]+SignExtImm] = R[rt]*/ begin
				CTRL='b00000001000100000001000001000000;//CTRL='b0000 0001 0001 XXXX X001 0000 0100 0000;
		        end
		        // J-Type
		        6'h02:/*jmp: PC = JumpAddress*/ begin
				//CTRL='b0000 0010 0000 0000 0000 0000 1000 0000//DONE!
		        end
		        6'h03:/*jal: R[31] = PC + 1; PC = JumpAddress*/ begin
				//CTRL='b0000 0010 0000 0000 0000 0000 1000 0000//DONE!
		        end
		        6'h1b:/*push: M[$sp] = R[0];$sp = $sp - 1*/ begin
				//CTRL='b0000 0010 0000 100X XXX1 X000 1000 0000;//DONE!
		        end
		        6'h1c:/*pop: $sp = $sp + 1;R[0] = M[$sp]*/ begin
				//CTRL='b0000 0010 0110 100X XXXX 1000 1000 0000;//DONE!
		        end
			endcase
		end
		`PROC_MEM: begin
			//CTRL='b0000 0010 0110 010X XXXX X000 1000 0000;//DONE!
		        case(opcode)
		        6'h23:/*lw: R[rt] = M[R[rs]+SignExtImm]*/ begin
				READ=1;
				WRITE=0;
			    	//CTRL='b0000 0010 0000 100X XXXX X000 1010 0000;//
		        end
		        6'h2b:/*sw: M[R[rs]+SignExtImm] = R[rt]*/ begin
				READ=0;
				WRITE=1;
			    	CTRL='b00000010000100000001000001000000;//CTRL='b0000 0010 0001 0000 0001 0000 0100 0000;//DONE!
		        end
		        6'h1b:/*push: M[$sp] = R[0];$sp = $sp - 1*/ begin
				READ=0;
				WRITE=1;
			    	//CTRL='b0000 0010 0000 100X XXXX X100 1000 0000;//
		        end
		        6'h1c:/*pop: $sp = $sp + 1;R[0] = M[$sp]*/ begin
				READ=1;
				WRITE=0;
			    	//CTRL='b0000 0010 0000 100X XXXX X100 1000 0000;//DONE!
		        end
		        endcase
		end
		`PROC_WB : begin
			case(opcode)
			6'h00:/*R-Type operations*/ begin
            			case(funct)
            			6'h20:/*add: R[rd] = R[rs] + R[rt]*/ begin
					CTRL='b10010001000100000100000010001011;//CTRL='b1001 0001 0001 XXXX X100 0000 1000 1011;
            			end
            			6'h22:/*sub: R[rd] = R[rs] - R[rt]*/ begin
            				CTRL='b10010001000010000100000010001011;//CTRL='b1001 0001 000X 1XXX X100 0000 1000 1011;
				end
            			6'h2c:/*mul: R[rd] = R[rs] * R[rt]*/ begin
            				//CTRL='b1101 1001 0000 001X XXX1 1000 1000 1001//DONE!
            			end
            			6'h24:/*and: R[rd] = R[rs] & R[rt]*/ begin
            				//CTRL='b1101 1001 0000 001X XX11 X000 1000 1001//DONE!
            			end
            			6'h25:/*or: R[rd] = R[rs] | R[rt]*/  begin
            				//CTRL='b1101 1001 0000 001X XX11 1000 1000 1001//DONE!
            			end
            			6'h27:/*nor: R[rd] = ~(R[rs] | R[rt])*/ begin
            			 	//CTRL='b1101 1001 0000 001X X1xx X000 1000 1001//DONE!
            			end
            			6'h2a:/*Set less than(slt): R[rd] = (R[rs] < R[rt])?1:0*/ begin
            				//CTRL='b0000 0010 0000 001X XX11 1000 1000 0000//
            			end
            			6'h00:/*Shift less logical(sll): R[rd] = R[rs] << shamt*/ begin
            				//CTRL='b0000 0010 0001 010X XX10 0000 1000 0000//
            			end
            			6'h02:/*Shift right logical(srl): R[rd] = R[rs] >> shamt*/ begin
            				//CTRL='b0000 0010 0001 010X XX10 1000 1000 0000//
            			end
            			6'h08:/*Jump regester(jr): PC = R[rs]*/ begin
					//CTRL='b0000 0010 0000 0000 0000 0000 1000 0000//
            			end
				endcase
        		end
		        // I-type (I and J are cased solely on oppcode)
		        6'h08:/*addi: R[rt] = R[rs] + SignExtImm*/ begin
				CTRL='b10110001000100000001000010001011;//CTRL='b1011 0001 0001 XXXX X001 0000 1000 1011;
		        end
		        6'h1d:/*muli: R[rt] = R[rs] * SignExtImm*/ begin
				//CTRL='b0000 0010 0000 100X XXX1 1000 1000 0000//
		        end
		        6'h0c:/*andi: R[rt] = R[rs] & ZeroExtImm*/ begin
				//CTRL='b0000 0010 0000 000X XX11 X000 1000 0000//
		        end
		        6'h0d:/*ori: R[rt] = R[rs] | ZeroExtImm*/ begin
				//CTRL='b0000 0010 0000 000X XX11 1000 1000 0000//
		        end
		        6'h0f:/*lui: R[rt] = {imm, 16'b0}*/ begin
				CTRL='b10111001000000000000000010001011;//CTRL='b1011 1001 000X XXXX X000 0000 1000 1011;
		        end
		        6'h0a:/*slti: R[rt] = (R[rs] < SignExtImm)?1:0*/ begin
				//CTRL='b0000 0010 0000 000X X1XX 1000 1000 0000;//
		        end
		        6'h04:/*beq: If (R[rs] == R[rt]) PC = PC + 1 + BranchAddress*/ begin
				//CTRL='b0000 0010 0000 001X XXX1 X000 1000 0000;//
		        end
		        6'h05:/*bne: If (R[rs] != R[rt]) PC = PC + 1 + BranchAddress*/ begin
		            /*Tests for equality. In WB checks zero flag*/
				//CTRL='b0000 0010 0000 001X XXX1 X000 1000 0000;//
		        end
		        6'h23:/*lw: R[rt] = M[R[rs]+SignExtImm]*/ begin
				//CTRL='b0000 0010 0000 100X XXXX 1000 1000 0000;//
		        end
		        6'h2b:/*sw: M[R[rs]+SignExtImm] = R[rt]*/ begin
				CTRL='b00000001000100000001000001001011;//CTRL='b0000 0001 0001 XXXX X001 0000 0100 1011;
		        end
		        // J-Type
		        6'h02:/*jmp: PC = JumpAddress*/ begin
				CTRL='b00000001000000000000000000000001;//CTRL='b0000 0001 000X XXXX X000 0000 0000 0001;
		        end
		        6'h03:/*jal: R[31] = PC + 1; PC = JumpAddress*/ begin
				//CTRL='b0000 0010 0000 0000 0000 0000 1000 0000//
		        end
		        6'h1b:/*push: M[$sp] = R[0];$sp = $sp - 1*/ begin
				//CTRL='b0000 0010 0000 100X XXX1 X000 1000 0000;//
		        end
		        6'h1c:/*pop: $sp = $sp + 1;R[0] = M[$sp]*/ begin
				//CTRL='b0000 0010 0110 100X XXXX 1000 1000 0000;//
		        end
			endcase
		end
	        endcase
	end
endmodule

/**------------------------------------------------------------------------------------------
* Module: PROC_SM
* Output: STATE      : State of the processor
*         
* Input:  CLK        : Clock signal
*         RST        : Reset signal
*
* INOUT: MEM_DATA    : Data to be read in from or write to the memory
*
* Notes: - Processor continuously cycle witnin fetch, decode, execute, 
*          memory, write back state. State values are in the prj_definition.v
*
* Revision History:
*
* Version	Date		Who		email			note
*------------------------------------------------------------------------------------------
*  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
*------------------------------------------------------------------------------------------*/
module PROC_SM(STATE, CLK, RST);
	// list of inputs
	input CLK, RST;
	// list of outputs
	output [2:0] STATE;
	// list of regesters
	reg [2:0] NEXT_STATE;
	reg [2:0] STATE ;
	initial
	begin
		STATE=`PROC_FETCH;
		NEXT_STATE=`PROC_FETCH;
	end
	//On reset
	always @ (negedge RST) begin
		STATE = 2'bxx;
		NEXT_STATE=`PROC_FETCH;
	end
	//On clock cycle
	always @ (posedge CLK) begin
        	case (NEXT_STATE)
        	`PROC_FETCH : begin               
			STATE = NEXT_STATE;
			NEXT_STATE = `PROC_DECODE;
        	end
        	`PROC_DECODE : begin   
			STATE = NEXT_STATE;
			NEXT_STATE = `PROC_EXE;
        	end
        	`PROC_EXE : begin   
        		STATE = NEXT_STATE;
        		NEXT_STATE = `PROC_MEM;
        	end
        	`PROC_MEM : begin   
        		STATE = NEXT_STATE;
        		NEXT_STATE = `PROC_WB;
        	end
        	`PROC_WB : begin   
        	 	STATE = NEXT_STATE;
            		NEXT_STATE = `PROC_FETCH;
        	end
        	default: begin
			STATE = 2'bxx;
			NEXT_STATE =`PROC_FETCH;
        	end
        	endcase
	end
endmodule
