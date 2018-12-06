module pacman(
	input 			Clk,
	input 			Reset,
	input 			frame_clk,
	input [2:0] 	direction,
	output[9:0]		pacman_x, pacman_y
);

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			pacman_x <= 10'd320;
			pacman_y <= 10'd240;
		end else begin
			pacman_x <= pacman_x_next;
			pacman_y <= pacman_y_next;
		end
	end

	logic [9:0] pacman_x_next, pacman_y_next;
	
	always_comb begin
		pacman_x_next = pacman_x;
		pacman_y_next = pacman_y;
	
		// Update position and motion only at rising edge of frame clock
		if (frame_clk_rising_edge) begin
			if (direction[2]) begin
				case(direction[1:0])
					2'b00 : pacman_y_next = pacman_y - 1; // up
					2'b01 : pacman_x_next = pacman_x + 1; // right
					2'b10 : pacman_y_next = pacman_y + 1; // down
					2'b11 : pacman_x_next = pacman_x - 1; // left
				endcase
			end
		end
	end

endmodule
