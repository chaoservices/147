//=============================================================================
// This implementation supports display control signals on a 100MHz clock
//=============================================================================
module sync_gen100 (clk, CounterX, CounterY, Valid, vga_h_sync, vga_v_sync);

	input clk;

	// Valid - asserted when visible rectangle is being drawn.
	output Valid, vga_h_sync, vga_v_sync;
	// CounterY[9:0]  - current pixel's Yposition. [0...479 ]
	output [9:0] CounterY;
	// CounterX[10:0] - current pixel's Xposition. [0...1287]
	output [10:0] CounterX;
        
	reg [9:0] CounterY;
	reg [11:0] CounterX_2;
    	reg ResetCntX, EnableCntY, ResetCntY;
	reg Valid, vga_h_sync, vga_v_sync;    

     // In order to maintain backwards compatability from previous designs 
	// so only use 10 bits
     assign CounterX = CounterX_2[11:1];

	// Counters, they hold the indices of the current pixel
	always @ (posedge clk)
		begin
			if (ResetCntX)
				CounterX_2[11:0] <= 11'b0;
			else
				CounterX_2[11:0] <= CounterX_2[11:0] + 1;

			if (ResetCntY)
				CounterY[9:0] <= 10'b0;
			else
				if (EnableCntY)
					CounterY[9:0] <= CounterY + 1;
				else
					CounterY[9:0] <= CounterY[9:0];	
		end

	// Synchronizer controller. Go across the screen in raster fashion.    
	always @(posedge clk )
       	begin	
              	ResetCntX  <= (CounterX_2[11:0] == 3172 /*1586*/); 
              	EnableCntY <= (CounterX_2[11:0] == 2600 /*1300*/); 
              	ResetCntY  <= (CounterY[9:0] == 527);
		end

	// Signal synchronizer
	always @(posedge clk)
		begin
			vga_h_sync <= ~((CounterX_2[11:0] >= 2608 /*1304*/ ) && (CounterX_2[11:0] <= 2986 /*1493*/));
			vga_v_sync <= ~((CounterY[9:0] == 493) || (CounterY[9:0]  == 494 ));
			Valid 	 <=  (((CounterX_2 == 3174 /*1587*/) || (CounterX_2 < 2576 /*1288*/)) &&
                		     ((CounterY ==  527) || (CounterY < 480 )) );
		end

endmodule