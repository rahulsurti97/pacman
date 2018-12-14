module pacman(
	input 			Clk, Reset, frame_clk, Restart,
	input [2:0] 	direction, id,
	output[9:0]		pacman_x, pacman_y
);

	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk) begin
		if (Reset || Restart) begin
			case(id[2:0])
				3'b000 : begin // ghost 0
					pacman_x <= 10'd288;
					pacman_y <= 10'd160;
				end
				3'b001 : begin // ghost 1
					pacman_x <= 10'd304;
					pacman_y <= 10'd160;
				end
				3'b010 : begin // ghost 2
					pacman_x <= 10'd320;
					pacman_y <= 10'd160;
				end
				3'b011 : begin // ghost 3
					pacman_x <= 10'd336;
					pacman_y <= 10'd160;
				end
				3'b100 : begin // pacman
					pacman_x <= 10'd304;
					pacman_y <= 10'd288;
				end
				default: begin
					pacman_x <= 10'd0;
					pacman_y <= 10'd0;
				end
			endcase
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
