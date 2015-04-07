// Name: register_file.v
/*
 Module: REGISTER_FILE_32x32
 Input:  DATA_W : Data to be written at address ADDR_W
         ADDR_W : Address of the memory location to be written
         ADDR_R1 : Address of the memory location to be read for DATA_R1
         ADDR_R2 : Address of the memory location to be read for DATA_R2
         READ    : Read signal
         WRITE   : Write signal
         CLK     : Clock signal
         RST     : Reset signal
 Output: DATA_R1 : Data at ADDR_R1 address
         DATA_R2 : Data at ADDR_R1 address

 Notes: - 32 bit word accessible dual read register file having 32 regsisters.
        - Reset is done at -ve edge of the RST signal
        - Rest of the operation is done at the +ve edge of the CLK signal
        - Read operation is done if READ=1 and WRITE=0
        - Write operation is done if WRITE=1 and READ=0
        - X is the value at DATA_R* if both READ and WRITE are 0 or 1

 Revision History:

 Version	Date		Who		email			note
------------------------------------------------------------------------------------------
  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
------------------------------------------------------------------------------------------
*/
`include "prj_definition.v"
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

    // input ports
    input READ, WRITE, CLK, RST;
    input [`DATA_INDEX_LIMIT:0] DATA_W;
    input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

    // Routput ports
    output [`DATA_INDEX_LIMIT:0] DATA_R1, DATA_R2;
    reg [`DATA_INDEX_LIMIT:0] DATA_R1, DATA_R2;

    // 32x32 internal storage
    reg [`DATA_INDEX_LIMIT:0] sreg32x32 [`REG_INDEX_LIMIT:0]; // memory storage 32x32

    // index for initial and reset operation
    integer i; 

    //Initializes content of all 32 registers as 0.
    initial begin
        for(i = 0; i < `DATA_INDEX_LIMIT; i=i+1) begin
            sreg32x32[i]={ `DATA_WIDTH{1'b1} };
        end
    end

    always @ (negedge RST or posedge CLK) begin
        if (RST === 1'b0)/*Register block is reset on a negative edge of RST signal.*/ begin
            for(i=0;i<=`DATA_INDEX_LIMIT; i = i +1) begin
                sreg32x32[i] = { `DATA_WIDTH{1'b0} };
            end
        end
        else begin
            if ((READ===1'b1)&&(WRITE===1'b0))/*read*/ begin
                /*On read request, both the content from address ADDR_R1 and ADDR_R2 are returned.*/
                DATA_R1 = sreg32x32[ADDR_R1];
                DATA_R2 = sreg32x32[ADDR_R2];
            end
            else if ((READ===1'b0)&&(WRITE===1'b1))/*write*/ begin
                /*On write request, data @ ADDR_W content is modified to DATA_W.*/
                sreg32x32[ADDR_W] =  DATA_W;
            end
            /*Does not handle read,write = 00 or 11. In that way the RF hold the
            previously read data.*/
        end
    end
endmodule
