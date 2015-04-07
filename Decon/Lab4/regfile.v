`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 22:13:22 02/07/2010
// Design Name:
// Module Name: regfile
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Create
// Additional Comments:
//
/////////////////////////////////////////////////////////////////////////////////
module regfile(clk, instant, dp_result, r1_en, r1_sel, r2_en, clear, r3_en, comp_in, comp_en, r1,
r2, r3, comp_out,r4_en,r4,dp_result1);
input clk, r1_en, r1_sel, r2_en, clear, r3_en, comp_in, comp_en,r4_en;
input [3:0] instant;
input [3:0] dp_result;
input [3:0] dp_result1;
output [3:0] r1;
output [3:0] r2;
output [3:0] r3;
output [3:0] r4;
output comp_out;
reg [3:0] r1;
reg [3:0] r2;
reg [3:0] r3;
reg[3:0] r4;
reg comp_out;
always@(posedge clk) begin
if(clear) begin
r1 <=4'b0000;
r2 <=4'b0000;
r3 <=4'b0000;
r4 <=4'b0000;
comp_out <=1'b0;
end
else if(r1_en) begin
r1 <= r1_sel ? r3:instant;
end
else if(r2_en) begin
r2 <= instant;
end
else if(r3_en) begin
r3 <=dp_result;
end
else if(comp_en) begin
comp_out <= comp_in;
end
if(r4_en && !clear) begin
r4 <= dp_result1;
end
end
endmodule
