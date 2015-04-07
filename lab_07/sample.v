// Name: sample.v
// Module: sample
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module sample(e,f,a,b,m,n,c,d);
// input list
input [7:0] c,d;
// output list
output [7:0] e,f,a,b,m,n;

// reg list
reg [7:0] a,b, m, n;

// continuous assignment
assign e = c + d;
assign f = e + d;

always @(c or d)
begin
a = c + d;
b = a + d;
end

always @(c or d)
begin
m <= c + d;
n <= m + d;
end

endmodule;