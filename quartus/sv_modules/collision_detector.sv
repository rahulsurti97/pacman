module collision_detector(
	input [10:0] 		pacman_index,
	input [3:0][10:0] ghost_index,
	output Restart
);

	always_comb begin
		Restart = 0;
		
		if (pacman_index == ghost_index[0] || pacman_index == ghost_index[1] || 
			 pacman_index == ghost_index[2] || pacman_index == ghost_index[3]) begin 
			 
			Restart = 1;
		end
	end

endmodule

