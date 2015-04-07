module multiply4(resultLow, resultHigh, product, ready, multiplicand, multiplier, sign, clk);
	input clk;
	input sign;
	input [3:0] multiplier, multiplicand;
	output [7:0] product;//output
	output [3:0] resultLow, resultHigh;
	output ready;
	reg [7:0] product, product_temp;
	reg [3:0] multiplier_copy;
	reg [7:0] multiplicand_copy;
	reg negative_output;

	reg [2:0] bit;
	wire ready, carryOut;
	notAnd3Bit b(ready, bit);
	reg [3:0] resultLow, resultHigh;

	//rc_add_sub_8 adder(product_temp, carryOut, product_temp, multiplicand_copy, 1'b0);

	initial bit = 0;
	initial negative_output = 0;
	always @( posedge clk )
		if( ready ) begin
			bit = 3'b100;
			product = 0;
			product_temp = 0;
			multiplicand_copy = (!sign || !multiplicand[3]) ?//determin between signed and unsigned
				{ 4'd0, multiplicand } :
				{ 4'd0, ~multiplicand + 1'b1};
			multiplier_copy = (!sign || !multiplier[3]) ?//determin between signed and unsigned
				multiplier :
				~multiplier + 1'b1;
			negative_output = sign &&//determin between signed and unsigned
				((multiplier[3] && !multiplicand[3])
				||(!multiplier[3] && multiplicand[3]));
		end else if ( bit > 0 ) begin
 			if( multiplier_copy[0] == 1'b1 )
				product_temp = product_temp + multiplicand_copy;
 			product = (!negative_output)?product_temp:(~product_temp + 1'b1);
 			multiplier_copy = multiplier_copy >> 1;
 			multiplicand_copy = multiplicand_copy << 1;
 			bit = bit - 1'b1;
			resultLow = product[3:0];
			resultHigh = product[7:4];
		end
endmodule
module controlUnit();
	
endmodule
module a_4bitSeqMul_TB;
	reg clk;
	reg sign;
	reg [3:0] multiplier, multiplicand;
	wire [3:0] resultLow, resultHigh;
	wire ready;
	wire [7:0] product;

	multiply4 m(resultLow, resultHigh, product, ready, multiplicand, multiplier, sign, clk);
	initial begin
		multiplier = 4'b0001;
		multiplicand = 4'b0001; sign = 1'b0;
		#1 clk = 1'b0; #1 clk = 1'b1; #1 clk = 1'b0; #1 clk = 1'b1; #1 clk = 1'b0; 
		#1 clk = 1'b1; #1 clk = 1'b0; #1 clk = 1'b1; #1 clk = 1'b0; #1 clk = 1'b1; 
		#1 clk = 1'b1; #1 clk = 1'b0;
		multiplier = 4'b1000;
		multiplicand = 4'b1000; sign = 1'b0;
		#1 clk = 1'b0; #1 clk = 1'b1; #1 clk = 1'b0; #1 clk = 1'b1; #1 clk = 1'b0; 
		#1 clk = 1'b1; #1 clk = 1'b0; #1 clk = 1'b1; #1 clk = 1'b0; #1 clk = 1'b1; 
	end
endmodule