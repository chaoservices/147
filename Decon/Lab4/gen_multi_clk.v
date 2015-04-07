`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:05 05/14/2008 
// Design Name: 
// Module Name:    gen_multi_clk 
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
module gen_multi_clk(CLOCK, CK_1Hz, CK_10Hz, CK_100Hz, CK_1KHz);
    input  CLOCK;
    output CK_1Hz, CK_10Hz, CK_100Hz, CK_1KHz;
	 reg [13:0] n_wexp4, n_ck1, n_ck10, n_ck100, n_ck1K;
	 reg        wexp4, i_ck1, i_ck10, i_ck100, i_ck1K;
    always @(posedge CLOCK) begin
	   if (n_wexp4 == 4999) begin   // 100MHz div by 10000 or exp4 => 10KHz
		   wexp4     <= ~wexp4;
			n_wexp4   <= 0;
		end
		else 
			n_wexp4   <= n_wexp4 + 1;
	 end
			
    always @(posedge wexp4) begin    // wexp4 = 10KHz clock coming
	   if (n_ck1 == 4999) begin       // 10KHz div by 10000 => 1Hz
		   i_ck1  <= ~i_ck1;
			n_ck1  <= 0;
		end 
		else 
			n_ck1  <= n_ck1 + 1;

	   if (n_ck10 == 499) begin // div by 1000  => 10Hz
		   i_ck10  <= ~i_ck10;
			n_ck10  <= 0;
		end 
		else 
			n_ck10  <= n_ck10 + 1;

	   if (n_ck100 == 49) begin // div by 100 => 100Hz
		   i_ck100  <= ~i_ck100;
			n_ck100  <= 0;
		end 
		else 
			n_ck100  <= n_ck100 + 1;

	   if (n_ck1K == 4) begin  // div by 10 => 1KHz
		   i_ck1K  <= ~i_ck1K;
			n_ck1K  <= 0;
		end 
		else 
			n_ck1K  <= n_ck1K + 1;
	 end // of always
		
	   assign CK_1Hz   = i_ck1;
	   assign CK_10Hz  = i_ck10;
	   assign CK_100Hz = i_ck100;
	   assign CK_1KHz  = i_ck1K;

endmodule
