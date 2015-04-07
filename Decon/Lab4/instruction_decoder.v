`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:54:43 05/14/2008 
// Design Name: 
// Module Name:    instruction_decoder 
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
module instruction_decoder(inst, pc_en, r1_en, r1_sel, r2_en, clear, r3_en, comp_en,
result_sel,r4_en);
input [3:0] inst;
output pc_en, r1_en, r1_sel, r2_en, clear, r3_en, comp_en, result_sel,r4_en;
output reg [1:0] result_sel;
reg pc_en, r1_en, r1_sel, r2_en, clear, r3_en, comp_en,r4_en;
always@(inst[3] or inst[2] or inst[1] or inst[0]) begin
case(inst[3:0])
//Initialization
4'b0000:begin
pc_en <=0;
r1_en <=1;
r1_sel <=0;
r2_en <=1;
clear <=1;
r3_en <=1;
r4_en <=0;
comp_en <=0;
result_sel <=0;
end
//Move instant number to r1
4'b0001: begin
pc_en <=0;
r1_en <=1;
r1_sel <=0;
r2_en <=0;
clear <=0;
r3_en <=0;
r4_en <=0;
comp_en <=0;
result_sel <=0;
end
//Move instant number to r2
4'b0010: begin
pc_en <=0;
r1_en <=0;
r1_sel <=0;
r2_en <=1;
clear <=0;
r3_en <=0;
r4_en <=0;
comp_en <=0;
result_sel <=0;
end
//Move previous r3 value to r1
4'b0011: begin
pc_en <=0;
r1_en <=1;
r1_sel <=1;
r2_en <=0;
clear <=0;
r3_en <=0;
r4_en <=0;
comp_en <=0;
result_sel <=0;
end
//Add: r3=r1+r2
4'b0100: begin
pc_en <=0;
r1_en <=0;
r1_sel <=0;
r2_en <=0;
clear <=0;
r3_en <=1;
comp_en <=0;
result_sel <=0;
r4_en <=0;
end
//Multiplication: r3=r1r2
4'b0101: begin
pc_en <=0;
r1_en <=0;
r1_sel <=0;
r2_en <=0;
clear <=0;
r3_en <=1;
comp_en <=0;
result_sel <=1;
r4_en <=0;
end
//Comparison the result of r1 <= r2
4'b0110: begin
pc_en <=0;
r1_en <=0;
r1_sel <=0;
r2_en <=0;
clear <=0;
r3_en <=0;
comp_en <=1;
result_sel <=0;
r4_en <=0;
end
//Branch if comp_result == 1
4'b0111: begin
pc_en <=1;
r1_en <=0;
r1_sel <=0;
r2_en <=0;
clear <=0;
r3_en <=0;
comp_en <=1;
result_sel <=0;
r4_en <=0;
end
//Division
4'b1000: begin
pc_en <=0;
r1_en <=0;
r1_sel <=0;
r2_en <=0;
clear <=0;
r3_en <=1;
comp_en <=0;
result_sel <=2;
r4_en <=1;
end
endcase
end
endmodule
