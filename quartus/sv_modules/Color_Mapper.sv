//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (
	input              is_wall, is_pellet,
//	input [3:0]		adjacent_walls,
   input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							 pacman_x, pacman_y,
   output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
);
    
	logic [7:0] Red, Green, Blue;

	// Output colors to VGA
	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;
	
	always_comb begin
		Red = 8'h00; 
		Green = 8'h00;
		Blue = 8'h00;
		
		if (is_wall == 1'b1) begin // blue wall
			Red = 8'h19; 
			Green = 8'h19;
			Blue = 8'ha6;		
		end else begin
			if (is_pellet == 1'b1) begin
				if (DrawX[3:0] > 5 && DrawX[3:0] < 10 && DrawY[3:0] > 5 && DrawY[3:0] < 10) begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			end
			
//			if (DrawY[3:0] == 4'b0000 && adjacent_walls[0] == 1'b1) begin //up
//				Red = 8'hff; 
//				Green = 8'h00;
//				Blue = 8'h00;
//			end
//			
//			if (DrawX[3:0] == 4'b1111 && adjacent_walls[1] == 1'b1) begin //right
//				Red = 8'hff; 
//				Green = 8'h00;
//				Blue = 8'h00;
//			end
//			
//			if (DrawY[3:0] == 4'b1111 && adjacent_walls[2] == 1'b1) begin //down
//				Red = 8'hff; 
//				Green = 8'h00;
//				Blue = 8'h00;
//			end
//			
//			if (DrawX[3:0] == 4'b0000 && adjacent_walls[3] == 1'b1) begin //left
//				Red = 8'hff; 
//				Green = 8'h00;
//				Blue = 8'h00;
//			end
		end
		
		if (pacman_x + 2 <= DrawX && pacman_x + 14 > DrawX && 
		    pacman_y + 2 <= DrawY && pacman_y + 14 > DrawY) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'h00;
		end 
	end
endmodule
