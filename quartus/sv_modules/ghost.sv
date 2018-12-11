//module ghost(
//	input 			Clk, Reset, frame_clk,
//	output[9:0]		ghost_x, ghost_y
//);
//
//logic frame_clk_delayed, frame_clk_rising_edge;
//	always_ff @ (posedge Clk) begin
//		frame_clk_delayed <= frame_clk;
//		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
//	end
//	
//	always_ff @ (posedge Clk) begin
//		if (Reset) begin
//			ghost_x <= 10'd320;
//			ghost_y <= 10'd240;
//		end else begin
//			ghost_x <= ghost_x_next;
//			ghost_y <= ghost_y_next;
//		end
//	end
//
//	logic [9:0] ghost_x_next, ghost_y_next;
//	
//	always_comb begin
//		ghost_x_next = ghost_x;
//		ghost_y_next = ghost_y;
//	
//		// Update position and motion only at rising edge of frame clock
//		if (frame_clk_rising_edge) begin
//			if (direction[2]) begin
//				case(direction[1:0])
//					2'b00 : ghost_y_next = ghost_y - 1; // up
//					2'b01 : ghost_x_next = ghost_x + 1; // right
//					2'b10 : ghost_y_next = ghost_y + 1; // down
//					2'b11 : ghost_x_next = ghost_x - 1; // left
//				endcase
//			end
//		end
//	end
//
//endmodule
