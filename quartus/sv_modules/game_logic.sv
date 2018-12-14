module game_logic (
	input 			Clk, Reset, Restart,
	input [9:0] 	pacman_x, pacman_y,
	input [3:0]		adjacent_walls,
	input [7:0] 	keyboard_direction,
	output [2:0]	direction
);

	logic [2:0] direction_next, 
					queued_keyboard_direction, 
					queued_keyboard_direction_next;
						
	always_ff @ (posedge Clk) begin		
		if (Reset || Restart) begin
			direction <= 3'b000;
			queued_keyboard_direction <= 3'b000;
		end else begin
			direction <= direction_next;
			queued_keyboard_direction <= queued_keyboard_direction_next;
		end
	end
	
	always_comb begin
		queued_keyboard_direction_next = queued_keyboard_direction;
		direction_next = direction;
		
		if (keyboard_direction[7:0] != 8'h00) begin // key is being pressed
			case (keyboard_direction[7:0])
				8'h52: 	queued_keyboard_direction_next = 3'b100; //up
				8'h4F: 	queued_keyboard_direction_next = 3'b101; //right
				8'h51: 	queued_keyboard_direction_next = 3'b110; //down
				8'h50: 	queued_keyboard_direction_next = 3'b111; //left
				default: queued_keyboard_direction_next = 3'b000; //stop				
			endcase
		end
		
		if (pacman_x[3:0] == 4'b0000 && pacman_y[3:0] == 4'b0000) begin // exactly at tile
			direction_next = queued_keyboard_direction;
			
			if (queued_keyboard_direction == 3'b100) begin // up
				if (adjacent_walls[0] == 1'b1) begin
					direction_next = direction;
				end
			end else if (queued_keyboard_direction == 3'b101) begin // right
				if (adjacent_walls[1] == 1'b1) begin
					direction_next = direction;
				end
			end else if (queued_keyboard_direction == 3'b110) begin // down
				if (adjacent_walls[2] == 1'b1) begin
					direction_next = direction;
				end
			end else if (queued_keyboard_direction == 3'b111) begin // left
				if (adjacent_walls[3] == 1'b1) begin
					direction_next = direction;
				end
			end
			
			case (direction[2:0])
				3'b100: begin //up
					if (adjacent_walls[0] == 1'b1) begin
						direction_next = 3'b000;
					end
				end
				
				3'b101: begin //right
					if (adjacent_walls[1] == 1'b1) begin
						direction_next = 3'b000;
					end
				end
				
				3'b110: begin //down
					if (adjacent_walls[2] == 1'b1) begin
						direction_next = 3'b000;
					end
				end
				
				3'b111: begin //left
					if (adjacent_walls[3] == 1'b1) begin
						direction_next = 3'b000;
					end
				end
				
				3'b000: begin //stopped
					direction_next = queued_keyboard_direction;
					
					case (queued_keyboard_direction)
						3'b100: begin //up
							if (adjacent_walls[0] == 1'b1) begin
								direction_next = 3'b000;
							end
						end
						
						3'b101: begin //right
							if (adjacent_walls[1] == 1'b1) begin
								direction_next = 3'b000;
							end
						end
						
						3'b110: begin //down
							if (adjacent_walls[2] == 1'b1) begin
								direction_next = 3'b000;
							end
						end
						
						3'b111: begin //left
							if (adjacent_walls[3] == 1'b1) begin
								direction_next = 3'b000;
							end
						end

						3'b000: begin
							direction_next = 3'b000;
						end

						default: ;
					endcase
				end
				
				default: ;
				
			endcase
		end
	end
endmodule
