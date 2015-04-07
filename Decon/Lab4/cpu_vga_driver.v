`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:11:38 05/15/2008 
// Design Name: 
// Module Name:    cpu_debug_vga_driver 
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
module cpu_vga_driver(clk, XPos, YPos, Valid, vga_rgb, instruction, inst_addr, r1, r2, r3, dp_result, comp_result);
	input 	clk;
	input 	[9:0] YPos;	// [0..479]     
	input 	[10:0] XPos;	// [0...1287]
	input 	Valid;
   input   	[3:0] r1, r2, r3, dp_result;
	input    [6:0] instruction;
	input    [3:0] inst_addr;
   input   	comp_result;

	// Composite RGB signal
	output 	[5:0] vga_rgb;

	// Connecting wires
	wire		[7:0] tcgrom_d, tcgrom_q;
	wire    	[5:0] char_selection_d, char_selection_q;
	reg 		color;
	reg    	[5:0] char_selection;
   reg		[5:0] char_color;
   wire    	[5:0] char_color_d, char_color_q;
	wire		[5:0] char_color_2_d, char_color_2_q;
	wire		line1Valid, line2Valid, line3Valid, line4Valid, line5Valid, line6Valid, line7Valid, line8Valid;
	wire		gridValid;
	wire		[8:0] currentConflict;
	wire		[8:0] nextConflict;

     // Wires to connect to output
	wire 	[1:0] vga_red;
	wire 	[1:0] vga_green;
	wire 	[1:0] vga_blue;

//=============================================================================
//  Hook up the VGA modules and define the output colors
//=============================================================================
	always @(YPos or XPos or r1 or r2 or r3 or dp_result or comp_result or instruction or inst_addr)
	begin
	    char_selection = 6'b100000;
         char_color = 6'b111111;  // RRBBGG

	    // INST XXXXXXX
	    if (YPos[9:5] == 5'b00001) begin
           char_color = 6'b110000;
           if (XPos[10:6] == 5'd2)
           		char_selection = 6'd09; //I
	      	 else if (XPos[10:6] == 5'd3)
	      	 	  char_selection = 6'd14; //N
	      	 else if (XPos[10:6] == 5'd4)
	      	 	  char_selection = 6'd19; //S
	      	 else if (XPos[10:6] == 5'd5)
	      	 	  char_selection = 6'd20; //T
	      	 else if (XPos[10:6] == 5'd7)
	      	 	  char_selection = instruction[6] ? 6'd49 : 6'd48;
	      	 else if (XPos[10:6] == 5'd8)
	      	 	  char_selection = instruction[5] ? 6'd49 : 6'd48; 
	      	 else if (XPos[10:6] == 5'd9)
	      	 	  char_selection = instruction[4] ? 6'd49 : 6'd48;
	      	 else if (XPos[10:6] == 5'd10)
	      	 	  char_selection = instruction[3] ? 6'd49 : 6'd48;
	      	 else if (XPos[10:6] == 5'd11)
	      	 	  char_selection = instruction[2] ? 6'd49 : 6'd48;
	      	 else if (XPos[10:6] == 5'd12)
	      	 	  char_selection = instruction[1] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd13)
	      	 	  char_selection = instruction[0] ? 6'd49 : 6'd48;
	      	 else
	        char_selection = 6'b100000;
	    end

		// INSTADDR XXXX
	    if (YPos[9:5] == 5'b00011) begin
           char_color = 6'b110000;
           if (XPos[10:6] == 5'd2)
           		char_selection = 6'd09; //I
	      	 else if (XPos[10:6] == 5'd3)
	      	 	  char_selection = 6'd14; //N
	      	 else if (XPos[10:6] == 5'd4)
	      	 	  char_selection = 6'd19; //S
	      	 else if (XPos[10:6] == 5'd5)
	      	 	  char_selection = 6'd20; //T
				 else if (XPos[10:6] == 5'd6)
					  char_selection = 6'd1; //a
	      	 else if (XPos[10:6] == 5'd7)
	      	 	  char_selection = 6'd4; //d
	      	 else if (XPos[10:6] == 5'd8)
	      	 	  char_selection = 6'd4; //d
	      	 else if (XPos[10:6] == 5'd9)
	      	 	  char_selection = 6'd18;
	      	 else if (XPos[10:6] == 5'd11)
	      	 	  char_selection = inst_addr[3] ? 6'd49 : 6'd48;
	      	 else if (XPos[10:6] == 5'd12)
	      	 	  char_selection = inst_addr[2] ? 6'd49 : 6'd48;
	      	 else if (XPos[10:6] == 5'd13)
	      	 	  char_selection = inst_addr[1] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd14)
	      	 	  char_selection = inst_addr[0] ? 6'd49 : 6'd48;
	      	 else
	        char_selection = 6'b100000;
	    end

		// R1 XXXX R2 XXXX
	    if (YPos[9:5] == 5'b00101) begin
           char_color = 6'b110000;
           if (XPos[10:6] == 5'd2)
           		char_selection = 6'd18; //R
	      	 else if (XPos[10:6] == 5'd3)
	      	 	  char_selection = 6'd49; //1
	      	 else if (XPos[10:6] == 5'd5)
	      	 	  char_selection = r1[3] ? 6'd49 : 6'd48;
			    else if (XPos[10:6] == 5'd6)
	      	 	  char_selection = r1[2] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd7)
	      	 	  char_selection = r1[1] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd8)
	      	 	  char_selection = r1[0] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd10)
	      	 	  char_selection = 6'd18; //R
			    else if (XPos[10:6] == 5'd11)
	      	 	  char_selection = 6'd50; //2
				 else if (XPos[10:6] == 5'd13)
	      	 	  char_selection = r2[3] ? 6'd49 : 6'd48;
			    else if (XPos[10:6] == 5'd14)
	      	 	  char_selection = r2[2] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd15)
	      	 	  char_selection = r2[1] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd16)
	      	 	  char_selection = r2[0] ? 6'd49 : 6'd48;
	      	 else
	        char_selection = 6'b100000;
	    end

		// R3 XXXX DP XXXX
	    if (YPos[9:5] == 5'b00111) begin
           char_color = 6'b110000;
           if (XPos[10:6] == 5'd2)
           		char_selection = 6'd18; //R
	      	 else if (XPos[10:6] == 5'd3)
	      	 	  char_selection = 6'd51; //3
	      	 else if (XPos[10:6] == 5'd5)
	      	 	  char_selection = r3[3] ? 6'd49 : 6'd48;
			    else if (XPos[10:6] == 5'd6)
	      	 	  char_selection = r3[2] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd7)
	      	 	  char_selection = r3[1] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd8)
	      	 	  char_selection = r3[0] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd10)
	      	 	  char_selection = 6'd4; //D
			    else if (XPos[10:6] == 5'd11)
	      	 	  char_selection = 6'd16; //P
				 else if (XPos[10:6] == 5'd13)
	      	 	  char_selection = dp_result[3] ? 6'd49 : 6'd48;
			    else if (XPos[10:6] == 5'd14)
	      	 	  char_selection = dp_result[2] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd15)
	      	 	  char_selection = dp_result[1] ? 6'd49 : 6'd48;
				 else if (XPos[10:6] == 5'd16)
	      	 	  char_selection = dp_result[0] ? 6'd49 : 6'd48;
	      	 else
	        char_selection = 6'b100000;
	    end

	    if (YPos[9:5] == 5'b01001) begin
           char_color = 6'b110000;
           if (XPos[10:6] == 5'd2)
           		char_selection = 6'd03; //C
	      	 else if (XPos[10:6] == 5'd3)
	      	 	  char_selection = 6'd15; //O
	      	 else if (XPos[10:6] == 5'd4)
	      	 	  char_selection = 6'd13; //M
	      	 else if (XPos[10:6] == 5'd5)
	      	 	  char_selection = 6'd16; //P
	      	 else if (XPos[10:6] == 5'd7)
	      	 	  char_selection = comp_result ? 6'd49 : 6'd48;
	      	 else
	        char_selection = 6'b100000;
	    end
	end
	
		// Register the output of the character generator and the color value
			assign char_selection_d = char_selection;
			assign char_color_d = char_color;
			assign gridValid = 0;
	// Register the output of the tcgrom
     tcgrom tcgrom(.addr({char_selection_q, YPos[4:2]}), .data(tcgrom_d));
     assign char_color_2_d = char_color_q;
   
     always @(XPos or tcgrom_q)
     begin  	
	    case (XPos[5:3])
	      3'h0 : color = tcgrom_q[7];
	      3'h1 : color = tcgrom_q[6];
	      3'h2 : color = tcgrom_q[5];
	      3'h3 : color = tcgrom_q[4];
	      3'h4 : color = tcgrom_q[3];
	      3'h5 : color = tcgrom_q[2];
	      3'h6 : color = tcgrom_q[1];
	      3'h7 : color = tcgrom_q[0];	 	      	 	      
	    endcase 
	end  

	// Generates the RGB signals based on raster position
	// Note: try playing around here to see if you can change the colors of the display.
	// The way this works is that color is true when we want to display part of a letter,
	// so, if you only turned on the blue when color was true you would just see blue.
	assign vga_red[1]   = gridValid ? 1'b1 : ((Valid & color) ? char_color_2_q[5] : 1'b0);
	assign vga_red[0]   = gridValid ? 1'b1 : ((Valid & color) ? char_color_2_q[4] : 1'b0);
	assign vga_blue[1]  = gridValid ? 1'b1 : ((Valid & color) ? char_color_2_q[3] : 1'b0);
	assign vga_blue[0]  = gridValid ? 1'b1 : ((Valid & color) ? char_color_2_q[2] : 1'b0);
	assign vga_green[1] = gridValid ? 1'b1 : ((Valid & color) ? char_color_2_q[1] : 1'b0);
	assign vga_green[0] = gridValid ? 1'b1 : ((Valid & color) ? char_color_2_q[0] : 1'b0);

	assign vga_rgb = {vga_red, vga_green, vga_blue}; //match the colors to the output

  Dff #(8) tcgrom_reg (.clk(clk), .clear(1'b0), .load(1'b1), .D(tcgrom_d), .Q(tcgrom_q));
  Dff #(6) char_selection_reg (.clk(clk), .clear(1'b0), .load(1'b1), .D(char_selection_d), .Q(char_selection_q));
  Dff #(6) char_color_reg (.clk(clk), .clear(1'b0), .load(1'b1), .D(char_color_d), .Q(char_color_q));
  Dff #(6) char_color_2_reg (.clk(clk), .clear(1'b0), .load(1'b1), .D(char_color_2_d), .Q(char_color_2_q));
endmodule
