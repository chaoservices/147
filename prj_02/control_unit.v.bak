/*
 Name: control_unit.v
 Module: CONTROL_UNIT
 Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
         RF_ADDR_W  : Register file address of the memory location to be written
         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
         RF_ADDR_R2 : Register file address of the memory location to be read for RF_DATA_R2
         RF_READ    : Register file Read signal
         RF_WRITE   : Register file Write signal
         ALU_OP1    : ALU operand 1
         ALU_OP2    : ALU operand 2
         ALU_OPRN   : ALU operation code
         MEM_ADDR   : Memory address to be read in
         MEM_READ   : Memory read signal
         MEM_WRITE  : Memory write signal
         
 Input:  RF_DATA_R1 : Data at ADDR_R1 address
         RF_DATA_R2 : Data at ADDR_R1 address
         ALU_RESULT : ALU output data
         CLK        : Clock signal
         RST        : Reset signal
         ZERO       : Spefies if the ALU operation produced zero

 INOUT: MEM_DATA    : Data to be read in from or write to the memory

 Notes: - Control unit synchronize operations of a processor

 Revision History:

 Version	Date		Who		email			note
------------------------------------------------------------------------------------------
  1.0     Sep 10, 2014	      Kaushik Patra   kpatra@sjsu.edu         Initial creation
  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
  2.0     Oct 29, 2014        David Thorpe    DE.Thorpe@gmail.com     Met output goals for DaVinci_TB
------------------------------------------------------------------------------------------*/
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 
    // Output signals
    // Outputs for register file 
    output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
    output [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
    output RF_READ, RF_WRITE, MEM_READ, MEM_WRITE;
    // Outputs for ALU
    output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
    output  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
    // Outputs for memory
    output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
    // Input signals
    input [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
    input ZERO, CLK, RST;
    // Inout signal
    inout [`DATA_INDEX_LIMIT:0] MEM_DATA;
    // State nets
    wire [2:0] proc_state;
    PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));
    /*register for write data to memory and connected to DATA.
    Control Unit for memory read operation DATA must be set to HighZ
    and for write operation DATA must be set to internal write data register. Miror of mem*/
//    assign MEM_DATA = ((MEM_READ===1'b0)&&(MEM_WRITE===1'b1))?RF_DATA_W:{`DATA_WIDTH{1'bz} };
    //additional internal regesters
    reg [`DATA_INDEX_LIMIT:0] PC_REG;
    reg [`DATA_INDEX_LIMIT:0] INST_REG;
    reg [`DATA_INDEX_LIMIT:0] SP_REG;
    reg [`DATA_INDEX_LIMIT:0] MEM_ADDR;
    reg MEM_READ;
    reg MEM_WRITE;
    reg RF_READ;
    reg RF_WRITE;
    reg [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_R1, RF_ADDR_R2, RF_ADDR_W;

    reg [32:0] RF_DATA_W;

    reg [5:0] ALU_OPRN;
    reg [`DATA_INDEX_LIMIT:0] ALU_OP1;
    reg [`DATA_INDEX_LIMIT:0] ALU_OP2;
    reg inst;
    reg [5:0] opcode;
    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] rd;
    reg [4:0] shamt;
    reg [5:0] funct;
    reg [15:0] immediate;
    reg [25:0] address;
    reg [31:0] SXimm, ZXimm, LUIimm;
    reg [31:0] branchAddress;
    reg [31:0] JumpAddress;
    reg [`DATA_INDEX_LIMIT:0] mem_data_ret; 

    assign MEM_DATA = ((MEM_READ===1'b0)&&(MEM_WRITE===1'b1))?mem_data_ret:{`DATA_WIDTH{1'bz} };

    initial begin
        PC_REG = `INST_START_ADDR;
        SP_REG = `INIT_STACK_POINTER;
    end
    always @ (proc_state) begin
        //TBD: Code for the control unit model
        case (proc_state)
        `PROC_FETCH : begin
            /*Set memory address to program counter, memory control for read operation.
            Also set the register file control to hold ({r,w} to 00 or 11) operation.*/
            //Sets the memory address to the program counter
            MEM_ADDR = PC_REG;
            //Sets Memory control for reading
            MEM_READ = 1;
            MEM_WRITE = 0;
            //Sets Register file control to hold
            RF_READ = 1;
            RF_WRITE = 1;
    end
    `PROC_DECODE : begin
        /*Store the memory read data into INST_REG; You may use
the following task code to print the current instruction fetched (usage:
print_instruction(INST_REG); ). It also shows how the instruction is parsed into
required fields (opcode, rs, rt, rd, shamt, funct, immediate, address for different
type of instructions). You may want to calculate and store sign extended value of
immediate, zero extended value of immediate, LUI value for I-type instruction.
For J-type instruction it would be good to store the 32-bit jump address from the
address field. Also set the read address of RF as rs and rt field value with RF
operation set to reading.*/
        //Store the memory into INST_REG
        INST_REG = MEM_DATA;
        //print_instruction(INST_REG);
        //Parse the instruction into all required fields
        {opcode, rs, rt, immediate} = INST_REG;
        {opcode, address} = INST_REG;
        {opcode, rs, rt, rd, shamt, funct} = INST_REG;
        //sign extended value of immediate. BranchAddress.
        SXimm = {{16{immediate[15]}}, immediate};
        //zero extended value of immediate
        ZXimm = {{16{1'b0}}, immediate};
        //LUI value of immediate
        LUIimm = {immediate, {16{1'b0}}};
        //32-bit Jump address
        JumpAddress = {6'b0, address};
        //Read address of RF as rs
        RF_ADDR_R1 = rs;
        RF_ADDR_R2 = rt;
        //RF set to reading
        RF_READ = 1;    
        RF_WRITE = 0;
    end
    `PROC_EXE : begin
    /*In this stage: The ALU operads and operation code are set according to
the opcode/funct of the instruction. Operation that do not need ALU operations
(like lui, jmp or jal) are tested to distinguish from illegal operations.*/
        case(opcode)
        6'h00:/*R-Type operations*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = RF_DATA_R2;
            case(funct)
            6'h20:/*add: R[rd] = R[rs] + R[rt]*/ begin
                ALU_OPRN = 'h01;
            end
            6'h22:/*sub: R[rd] = R[rs] - R[rt]*/ begin
                ALU_OPRN = 'h02;
            end
            6'h2c:/*mul: R[rd] = R[rs] * R[rt]*/ begin
                ALU_OPRN = 'h03;
            end
            6'h24:/*and: R[rd] = R[rs] & R[rt]*/ begin
                ALU_OPRN = 'h06;
            end
            6'h25:/*or: R[rd] = R[rs] | R[rt]*/  begin
                ALU_OPRN = 'h07;
            end
            6'h27:/*nor: R[rd] = ~(R[rs] | R[rt])*/ begin
                ALU_OPRN = 'h08;
            end
            6'h2a:/*Set less than(slt): R[rd] = (R[rs] < R[rt])?1:0*/ begin
                ALU_OPRN = 'h09;
            end
            6'h00:/*Shift less logical(sll): R[rd] = R[rs] << shamt*/ begin
                ALU_OP2 = shamt;
                ALU_OPRN = 'h04;
            end
            6'h02:/*Shift right logical(srl): R[rd] = R[rs] >> shamt*/ begin
                ALU_OP2 = shamt;
                ALU_OPRN = 'h05;
            end
            6'h08:/*Jump regester(jr): PC = R[rs]*/ begin
                /*All operations is in wb. Case is retained for bad instruction parsing*/
            end
            default:/*Error*/$write("Error: R-type instruction does not exist\n");
            endcase
        end
        // I-type (I and J are cased solely on oppcode)
        6'h08:/*addi: R[rt] = R[rs] + SignExtImm*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = SXimm;
            ALU_OPRN = 'h01;
        end
        6'h1d:/*muli: R[rt] = R[rs] * SignExtImm*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = SXimm;
            ALU_OPRN = 'h03;
        end
        6'h0c:/*andi: R[rt] = R[rs] & ZeroExtImm*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = ZXimm;
            ALU_OPRN = 'h06;
        end
        6'h0d:/*ori: R[rt] = R[rs] | ZeroExtImm*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = ZXimm;
            ALU_OPRN = 'h07;
        end
        6'h0f:/*lui: R[rt] = {imm, 16'b0}*/ begin
            /*All operations is in wb. Case is retained for bad instruction parsing*/
        end
        6'h0a:/*slti: R[rt] = (R[rs] < SignExtImm)?1:0*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = SXimm;
            ALU_OPRN = 'h09;
        end
        6'h04:/*beq: If (R[rs] == R[rt]) PC = PC + 1 + BranchAddress*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = RF_DATA_R2;
            ALU_OPRN = 'h02;
        end
        6'h05:/*bne: If (R[rs] != R[rt]) PC = PC + 1 + BranchAddress*/ begin
            /*Tests for equality. In WB checks zero flag*/
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = RF_DATA_R2;
            ALU_OPRN = 'h02;
        end
        6'h23:/*lw: R[rt] = M[R[rs]+SignExtImm]*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = SXimm;
            ALU_OPRN = 'h01;
        end
        6'h2b:/*sw: M[R[rs]+SignExtImm] = R[rt]*/ begin
            ALU_OP1 = RF_DATA_R1;
            ALU_OP2 = SXimm;
            ALU_OPRN = 'h01;
        end
        // J-Type
        6'h02:/*jmp: PC = JumpAddress*/ begin
            /*All operations is in wb. Case is retained for bad instruction parsing*/
        end
        6'h03:/*jal: R[31] = PC + 1; PC = JumpAddress*/ begin
            /*All operations is in wb. Case is retained for bad instruction parsing*/
        end
        6'h1b:/*push: M[$sp] = R[0];$sp = $sp - 1*/ begin
            RF_ADDR_R1=0;
            ALU_OP1=SP_REG;
            ALU_OP2=1;
            ALU_OPRN= 'h02;
        end
        6'h1c:/*pop: $sp = $sp + 1;R[0] = M[$sp]*/ begin
            RF_ADDR_R1=0;
            ALU_OP1=SP_REG;
            ALU_OP2=1;
            ALU_OPRN= 'h01;
        end
        default:/*Error*/$write("Error: I or J type instruction not found.\n");
        endcase
        end
    `PROC_MEM: begin
    /*In this stage: 'lw', 'sw', 'push' and 'pop' instructions perform memory operations.
The Address for the stack operation needs to be set carefully following the ISA specification.
Illigal operations are assumed to have been flaged in the pervious stage.*/
        //Memory out to HighZ
        MEM_READ = 0;
        MEM_WRITE = 0;
        case(opcode)
        6'h23:/*lw: R[rt] = M[R[rs]+SignExtImm]*/ begin
            MEM_READ = 1;
            MEM_WRITE = 0;
            RF_ADDR_W = rt;
            MEM_ADDR = ALU_RESULT;
            RF_DATA_W = MEM_DATA;
        end
        6'h2b:/*sw: M[R[rs]+SignExtImm] = R[rt]*/ begin
            MEM_READ = 0;
            MEM_WRITE = 1;
            MEM_ADDR = ALU_RESULT;
            mem_data_ret = RF_DATA_R2;
        end
        6'h1b:/*push: M[$sp] = R[0];$sp = $sp - 1*/ begin
            MEM_READ = 0;
            MEM_WRITE = 1;
            MEM_ADDR = SP_REG;
            mem_data_ret = RF_DATA_R1;
            SP_REG = ALU_RESULT;
        end
        6'h1c:/*pop: $sp = $sp + 1;R[0] = M[$sp]*/ begin
            MEM_READ = 1;
            MEM_WRITE = 0;
            SP_REG = ALU_RESULT;
            MEM_ADDR = SP_REG;
            RF_DATA_W = MEM_DATA;
        end
        default:/*Not needed.*/ $write("");
        endcase
    end
    `PROC_WB : begin
    /* Write back to RF or PC_REG is done here. Increase PC_REG by 1 by default*/
        RF_READ=0;
        RF_WRITE=1;
        case(opcode)        
            6'h00:/*R-type*/ begin
                if(funct!=6'h08)/*not jr*/ begin
                    RF_ADDR_W = rd;
                    RF_DATA_W = ALU_RESULT;
                end
                else/*Is jr*/ begin
                    PC_REG = RF_DATA_R1;
                end
            end
            6'h04:/*beq: If (R[rs] == R[rt]) PC = PC + 1 + BranchAddress*/ begin
                if(ZERO === 0) begin
                    ALU_OP1 = PC_REG;
                    ALU_OP2 = SXimm;
                    ALU_OPRN = 'h01; 
                    PC_REG = ALU_RESULT;
                end
            end
            6'h05:/*bne: If (R[rs] != R[rt]) PC = PC + 1 + BranchAddress*/ begin
                 if(ZERO !== 0) begin
                    ALU_OP1 = PC_REG;
                    ALU_OP2 = SXimm;
                    ALU_OPRN = 'h01; 
                    PC_REG = ALU_RESULT;
                end
            end
            6'h2b:/*sw: no further work needed*/ begin end
            6'h02:/*jmp: PC = JumpAddress*/ begin
                PC_REG = JumpAddress - 1;
            end
            6'h03:/*jal: R[31] = PC + 1; PC = JumpAddress*/ begin
                RF_ADDR_W = 31;
                RF_DATA_W = PC_REG + 1;
                PC_REG = JumpAddress - 1;
            end
            6'h1b:/*push: M[$sp] = R[0];$sp = $sp - 1*/ begin
                SP_REG = ALU_RESULT;
            end
            6'h1c:/*pop: $sp = $sp + 1;R[0] = M[$sp]*/ begin
                RF_ADDR_W = 0;
                RF_DATA_W = MEM_DATA;
            end
            6'h0f:/*lui: R[rt] = {imm, 16'b0}*/ begin
                RF_ADDR_W = rt;
                RF_DATA_W = LUIimm;
            end
            6'h23:/*lw: R[rt] = M[R[rs]+SignExtImm]*/ begin end
            default:/*addi, muli, andi, ori, lui, slti,*/ begin
                RF_ADDR_W = rt;
                RF_DATA_W = ALU_RESULT;
            end
        endcase
        PC_REG=PC_REG+1;
    end
    endcase
end
task print_instruction;
input [`DATA_INDEX_LIMIT:0] inst;
reg [5:0] opcode;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [4:0] shamt;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;
begin
    // parse the instruction
    // R-type
    {opcode, rs, rt, rd, shamt, funct} = inst;
    // I-type
    {opcode, rs, rt, immediate } = inst;
    // J-type
    {opcode, address} = inst;
    $write("@ %6dns -> [0X%08h] ", $time, inst);
    case(opcode)
    // R-Type
    6'h00 : begin
        case(funct)
        6'h20: $write("add r[%02d], r[%02d], r[%02d];", rs, rt, rd);
        6'h22: $write("sub r[%02d], r[%02d], r[%02d];", rs, rt, rd);
        6'h2c: $write("mul r[%02d], r[%02d], r[%02d];", rs, rt, rd);
        6'h24: $write("and r[%02d], r[%02d], r[%02d];", rs, rt, rd);
        
        6'h25: $write("or r[%02d], r[%02d], r[%02d];", rs, rt, rd);
        6'h27: $write("nor r[%02d], r[%02d], r[%02d];", rs, rt, rd);
        6'h2a: $write("slt r[%02d], r[%02d], r[%02d];", rs, rt, rd);
        6'h00: $write("sll r[%02d], %2d, r[%02d];", rs, shamt, rd);
        6'h02: $write("srl r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
        6'h08: $write("jr r[%02d];", rs);
        default: $write("");
        endcase
    end
    // I-type
    6'h08 : $write("addi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h1d : $write("muli r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h0c : $write("andi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h0d : $write("ori r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h0f : $write("lui r[%02d], 0X%04h;", rt, immediate);
    6'h0a : $write("slti r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h04 : $write("beq r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h05 : $write("bne r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h23 : $write("lw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    6'h2b : $write("sw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    // J-Type
    6'h02 : $write("jmp 0X%07h;", address);
    6'h03 : $write("jal 0X%07h;", address);
    6'h1b : $write("push;");
    6'h1c : $write("pop;");
        default: $write("");
    endcase
    $write("\n");
    end
    endtask
endmodule

/*
------------------------------------------------------------------------------------------
 Module: CONTROL_UNIT
 Output: STATE      : State of the processor
         
 Input:  CLK        : Clock signal
         RST        : Reset signal



 Notes: - Processor continuously cycle witnin fetch, decode, execute, 
          memory, write back state. State values are in the prj_definition.v

 Revision History:

 Version	Date		Who		email			note
------------------------------------------------------------------------------------------
  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
  2.0     Oct 29, 2014  David Thorpe    DE.Thorpe@gmail.com     Met output goals for DaVinci_TB
------------------------------------------------------------------------------------------*/
module PROC_SM(STATE,CLK,RST);
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
    always @ (negedge RST)
    begin
       STATE = 2'bxx;
       NEXT_STATE=`PROC_FETCH;
    end
    //On clock cycle
    always @ (posedge CLK)
    begin

        case (NEXT_STATE)
        `PROC_FETCH :
        begin               
            STATE = NEXT_STATE;
            NEXT_STATE = `PROC_DECODE;
        end
        `PROC_DECODE :
        begin   
            STATE = NEXT_STATE;
            NEXT_STATE = `PROC_EXE;
        end
        `PROC_EXE :
        begin   
            STATE = NEXT_STATE;
            NEXT_STATE = `PROC_MEM;
        end
        `PROC_MEM :
        begin   
            STATE = NEXT_STATE;
            NEXT_STATE = `PROC_WB;
        end
        `PROC_WB :
        begin   
            STATE = NEXT_STATE;
            NEXT_STATE = `PROC_FETCH;
        end
        default:
        begin
            STATE = 2'bxx;
            NEXT_STATE =`PROC_FETCH;
        end
        endcase
// BD - implement the state machine here
    end
endmodule