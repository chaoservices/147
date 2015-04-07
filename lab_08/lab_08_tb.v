`timescale 1ns/10ps
// Name: lab_p08_tb.v
// Module: lab_08_tb
// Input: 
// Output: 
//
// Notes: Testbench for lab 08
// 
// Identification of patten 1101 in incoming bit stream
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
module lab_08_tb;

reg [31:0] input_stream;
reg clk_reg, rst_reg;
wire out_net;
// Instantiation of ALU
IDENTIFY_1101  id_inst_0(.OUT(out_net), .IN(input_stream[31]), 
                         .CLK(clk_reg), .RST(rst_reg));

// Drive the test patterns and test
initial
begin
input_stream=32'b010111011011111011011011111011011;
clk_reg=1'b1;
rst_reg=1'b0;

#5 rst_reg=1'b1;
#5 rst_reg=1'b0;

#140 rst_reg=1'b1;
#5   rst_reg=1'b0;

#195 $stop;
end

always
#5 clk_reg = ~clk_reg;

always @(posedge clk_reg)
input_stream = input_stream << 1;

endmodule
