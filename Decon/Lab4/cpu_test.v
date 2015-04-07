`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:35:50 05/15/2008 
// Design Name: 
// Module Name:    cpu_test 
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
module cpu_test(clk, PD, vga_hsync, vga_vsync,vga_red0, vga_green0, vga_blue0, vga_red1, vga_green1, vga_blue1, vga_out_pixel_clock, vga_out_blank_z, vga_comp_sync);

	 input clk, PD;
    output vga_hsync;
    output vga_vsync;
    output vga_red0;
    output vga_green0;
    output vga_blue0;
    output vga_red1;
    output vga_green1;
    output vga_blue1;
    output vga_out_pixel_clock;
    output vga_out_blank_z;
    output vga_comp_sync;


	 wire [3:0] inst_addr;
	 wire [6:0] instruction;
	 wire [3:0] r1, r2, r3, dp_result;
	 wire dp_comp_out;
	
//wires for display
	wire 	[9:0] YPos;	// [0..479]     
	wire 	[10:0] XPos;	// [0...1287]
	wire 	Valid;
	wire 	vga_hsync_d, vga_hsync_q;
	wire 	vga_vsync_d, vga_vsync_q; 
	wire	[1:0] vga_red_d, vga_red_q;
	wire	[1:0] vga_green_d, vga_green_q;
	wire 	[1:0] vga_blue_d, vga_blue_q;
	// Create composite RGB signal
	wire		[5:0] vga_rgb;
	
	
	assign	vga_red_d = vga_rgb[5:4];
	assign	vga_green_d = vga_rgb[3:2];
	assign	vga_blue_d = vga_rgb[1:0];
	
	
	// Top module of mini CPU
	cpu_top cpu0(
		.clk(clk), 
		.clear(~PD), 
		.inst_addr(inst_addr), 
		.instruction(instruction), 
		.r1(r1), 
		.r2(r2), 
		.r3(r3), 
		.dp_result(dp_result), 
		.dp_comp_out(dp_comp_out));


//=============================================================================
// Display management
//=============================================================================
	// Module producing signals synchronized to the VGA
	sync_gen100 syncVGA(.clk(clk),
					.CounterX(XPos),
					.CounterY(YPos),
           		.Valid(Valid),
					.vga_h_sync(vga_hsync_d),
					.vga_v_sync(vga_vsync_d));
		
 	// Display Driver		
   cpu_vga_driver vga0(
		.clk(clk), 
		.XPos(XPos), 
		.YPos(YPos), 
		.Valid(Valid), 
		.vga_rgb(vga_rgb), 
		.instruction(instruction), 
		.inst_addr(inst_addr), 
		.r1(r1), 
		.r2(r2), 
		.r3(r3),
		.dp_result(dp_result), 
		.comp_result(dp_comp_out));

//=============================================================================
// Connect the latched vga signals to the outputs
//=============================================================================
	assign vga_vsync = vga_vsync_q;
   	assign vga_hsync = vga_hsync_q;
   	assign vga_red1 = vga_red_q[1];
   	assign vga_red0 = vga_red_q[0];
   	assign vga_green1 = vga_green_q[1];
   	assign vga_green0 = vga_green_q[0];
   	assign vga_blue1 = vga_blue_q[1];
   	assign vga_blue0 = vga_blue_q[0];

   	// VGA outputs
   	assign vga_out_pixel_clock = clk; 
   	assign vga_out_blank_z = 1'b1;
   	assign vga_comp_sync = 1'b0;

   	// Output flops;
   	Dff #(1) vga_vsync_reg (.clk(clk), .clear(clear), .load(1'b1), .D(vga_vsync_d), .Q(vga_vsync_q));
  	Dff #(1) vga_hsync_reg (.clk(clk), .clear(clear), .load(1'b1), .D(vga_hsync_d), .Q(vga_hsync_q));
   	Dff #(2) vga_red_reg (.clk(clk), .clear(clear), .load(1'b1), .D(vga_red_d), .Q(vga_red_q));
   	Dff #(2) vga_green_reg (.clk(clk), .clear(clear), .load(1'b1), .D(vga_green_d), .Q(vga_green_q));
   	Dff #(2) vga_blue_reg (.clk(clk), .clear(clear), .load(1'b1), .D(vga_blue_d), .Q(vga_blue_q));  


endmodule

module Dff(clk, clear, load, D, Q);
	parameter w=4;
	input clk;
	input [w-1:0] D;
	input clear;
	input load;
	output [w-1:0] Q;
	
	reg	Q;
	
	always@(posedge clk)begin
	if(clear)
		Q <= 0;
	else if(load)
		Q <= D;
	else
		Q <= Q;
	end
	
endmodule