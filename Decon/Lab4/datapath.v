`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:26:37 05/14/2008 
// Design Name: 
// Module Name:    datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module datapath(r1, r2, op, comp, dp_out,dp_out1);
input [3:0] r1;
input [3:0] r2;
input[1:0] op;
output comp;
output [3:0] dp_out,dp_out1;
reg [7:0] op_result,op_result1;
always @ (op)
begin
if(op == 2'b00)
begin
op_result = r1*r2;
op_result1 = 0;
end
if(op == 2'b01)
begin
op_result = r1 + r2;
op_result1 = 0;
end
if(op == 2'b10)
begin
op_result = r1/r2;
op_result1 = r1%r2;
end
end
assign dp_out = op_result[3:0];
assign dp_out1 = op_result1[3:0];
assign comp = (r1 <= r2);
endmodule
