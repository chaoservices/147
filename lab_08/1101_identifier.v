// Name: 1101_identifier.v
// Module: IDENTIFY_1101
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b11
`define STATE_D 2'b10

module IDENTIFY_1101(OUT, IN, CLK, RST);
// input list
input IN, CLK, RST;
// output list
output OUT;

// reg list
reg OUT;
reg [1:0] state;
reg [1:0] next_state;

// initiation of state
initial
begin
  state = `STATE_A;
  next_state = `STATE_A;  
end

// reset signal handling
always @ (posedge RST)
begin
    state = `STATE_A;
    next_state = `STATE_A;
end

// state switching
always @(posedge CLK)
begin
    state = next_state;
end

// Action on state switching
always @(state or IN)
begin
    if (state === `STATE_A)
    begin 
        if (IN === 1'b0) begin next_state = `STATE_A; OUT = 1'b0; end
        else begin next_state = `STATE_B; OUT = 1'b0; end
    end

    if (state === `STATE_B)
    begin 
        if (IN === 1'b0) begin next_state = `STATE_A; OUT = 1'b0; end
        else begin next_state = `STATE_C; OUT = 1'b0; end
    end

    if (state === `STATE_C)
    begin 
        if (IN === 1'b0) begin next_state = `STATE_D; OUT = 1'b0; end
        else begin next_state = `STATE_C; OUT = 1'b0; end
    end

    if (state === `STATE_D)
    begin 
        if (IN === 1'b0) begin next_state = `STATE_A; OUT = 1'b0; end
        else begin next_state = `STATE_B; OUT = 1'b1; end
    end

end
endmodule;