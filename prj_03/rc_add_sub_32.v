/** Full 32 bit adder subtractor
* @param result is the result of the sum of the opperands
* @param carryOut is the carry from the sum of the opperands if they exceed available digit
* @param operand1 is one oppernad to be added
* @param operand2 is the other opperand to be added
* @param subtractNotAdd is the 
*/
module rc_add_sub_32(result, carryOut, operand1, operand2, subtractNotAdd);
	input [31:0] operand1, operand2;
	input subtractNotAdd;
	output [31:0] result;
	output carryOut;
	
	wire [31:0] xorProduct;
	wire [31:0] wireNext;

	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin : rc_add_sub_32_loop
			xor xor_inst(xorProduct[i], subtractNotAdd, operand2[i]);
			if(i!=0 && i!=31) begin
				full_adder fa(result[i], wireNext[i],
					operand1[i], xorProduct[i], wireNext[i-1]);
			end else if(i==0) begin
				full_adder fa(result[i], wireNext[i],
					operand1[i], xorProduct[i], subtractNotAdd);
			end else if(i==31) begin
				full_adder fa(result[i], carryOut,
					operand1[i], xorProduct[i], wireNext[i-1]);
			end
		end
	endgenerate
endmodule
/** Full 64 bit adder subtractor
* @param r is the result of the sum of the opperands
* @param c is the carry from the sum of the opperands if they exceed available digit
* @param o is one oppernad to be added
* @param p is the other opperand to be added
* @param sNa is the type of operation to be performed
*/
module rc_add_sub_64(r, c, o, p, sNa);
	input [63:0] o, p;
	input sNa;
	output [63:0] r;
	output c;
	
	wire [63:0] xorProduct, wireNext;

	genvar i;
	generate
		for (i=0; i<64; i=i+1) begin : rc_add_sub_64_loop
			xor xor_inst(xorProduct[i], sNa, p[i]);
			if(i!=0 && i!=63) begin
				full_adder fa(r[i], wireNext[i], o[i], xorProduct[i], wireNext[i-1]);
			end else if(i==0) begin
				full_adder fa(r[i], wireNext[i], o[i], xorProduct[i], sNa);
			end else if(i==63) begin
				full_adder fa(r[i], c, o[i], xorProduct[i], wireNext[i-1]);
			end
		end
	endgenerate
endmodule
/** Basic full adder, does single bit addition between two bits and a carry in
* @param s is the result of the sum of the opperands
* @param co is the carry from the sum of the opperands if they exceed available digit
* @param o is one oppernad to be added
* @param p is the other opperand to be added
* @param ci is a carry in bit
*/
module full_adder(s, co, o, p, ci);
	input o, p, ci;
	output s, co;

	wire HA1sum, HA1carry, HA2carry;

	half_adder h1(HA1sum, HA1carry, o, p);
	half_adder h2(s, HA2carry, HA1sum, ci);

	or orI(co, HA1carry, HA2carry);
endmodule
/** Basic half adder, does single bit addition only between two bits
* @param s is the result of the sum of the opperands
* @param c is the carry from the sum of the opperands if they exceed available digit
* @param o is one oppernad to be added
* @param p is the other opperand to be added
*/
module half_adder(s, c, o, p);
	input o, p;
	output s, c;
	xor i(s, o, p);
	and j(c, o, p);
endmodule
