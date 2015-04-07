`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:45:55 05/14/2008 
// Design Name: 
// Module Name:    instruction_ROM 
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
module instruction_ROM(addr, inst);
input [3:0] addr;
output [6:0] inst;

wire [6:0] memory [15:0];

	assign memory[0] = 7'b0000000;
	assign memory[1] = 7'b0010001;
	assign memory[2] = 7'b0100010;
	assign memory[3] = 7'b1000000;
	assign memory[4] = 7'b0110000;
	assign memory[5] = 7'b0100100;
	assign memory[6] = 7'b1100000;
	assign memory[7] = 7'b1110011;
	assign memory[8] = 7'b0000000;
	assign memory[9] = 7'b0000000;
	assign memory[10] = 7'b0000000;
	assign memory[11] = 7'b0000000;
	assign memory[12] = 7'b0000000;
	assign memory[13] = 7'b0000000;
	assign memory[14] = 7'b0000000;
	assign memory[15] = 7'b0000000;


	assign inst = memory[addr];
endmodule
