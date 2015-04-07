`include "prj_definition.v"
/*
The gate based sequential multipler.
*/
module div(result, divisor, dividend, write, shift, load);
	output [63:0] result;
	input [31:0] divisor, dividend;
	input write, shift, load;
	wire [31:0] adderOut, andOut;
	wire dontCare;
	wire [63:0] shifterOut;

	reg [5:0] shiftNum;
	
	reg [63:0] result;
	reg [31:0] addProduct;

	and32 andGate(andOut, divisor, addProduct);
	rc_add_sub_32 adder(adderOut, dontCare, andOut, result[63:32], 1'b0);

	right_shifter64 b(shifterOut, result, shiftNum);

	initial shiftNum = {6'b000001};
	initial result = {{64'd0000},divisor};
	
	always @(load) begin
		shiftNum = {6'b000001};
		result = {{64'd0000},divisor};
	end
	always @(posedge write) begin
		result[63:32]=adderOut;
	end
	always @(posedge shift) begin
		result=shifterOut;
	end
endmodule
/*
The control unit for the sequential multiplier
*/
module divControl(result, ready, multiplicand, multiplier, clk);
	output [63:0] result;
	output ready;

	input [31:0] multiplicand, multiplier;
	input clk;

	reg shift, write, load;

	multiply mulPath(result, multiplicand,  multiplier, write, shift, load);

	reg [5:0] bit;
	wire ready = !bit;

	initial bit = 1'b0;
	initial load = 1'b1;
	always @( posedge clk )
		if(ready) begin
			bit = 6'b100000;
			load = 1'b0;
			write = 1'b0;
			shift = 1'b0;
		end else begin
			write = 1'b1;
			#1 shift = 1'b1;
			write = 1'b0;
			#1 shift = 1'b0;
 			bit = bit - 1'b1;
		end

endmodule
/*
Test Bench for sequential multiplier
Runs for the number of clock cycles required to complete multiplication
*/
module a_div_TB;
	wire [63:0] result;
	wire ready;
	reg [31:0] multiplicand, multiplier;
	reg clk;

	mulControl mul(result, ready, multiplicand, multiplier, clk);

	initial begin
		multiplier = 32'b00010;
		multiplicand = 32'b0001;
		#1 clk = 1'b0; #1 clk = 1'b1; 
		#1 clk = 1'b0; #1 clk = 1'b1; 
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1; 
		#1 clk = 1'b0; #1 clk = 1'b1; 
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
		#1 clk = 1'b0; #1 clk = 1'b1;
	end
endmodule
module divFast(divWire, readyDiv, OP1, OP2, CLK);
	output [31:0] divWire;
	output readyDiv;
	reg [31:0] divWire;
	reg readyDiv;
	input OP1;
	input OP2;
	input CLK;
	always @(posedge CLK) begin
		divWire = OP1/OP2;
		readyDiv = 1'b1;
	end
endmodule