`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:41:38 05/14/2008 
// Design Name: 
// Module Name:    program_counter 
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
module program_counter(clk, enable, reset, load, data, q);
input clk, enable, reset, load;
input [3:0] data;
output [3:0] q;
reg [3:0] q;
always@(posedge clk) begin
if(reset)
q <= 0;
else if(load)
q <= data;
else if(enable)
q <= q+1;
end
endmodule
