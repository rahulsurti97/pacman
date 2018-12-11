module pellets(
	input Clk, Reset,
	input [10:0] index, pacman_index,
	output logic is_pellet, seen_pellet
);

	logic pellets [0:1199];
	logic seen_pellet_next, write_pellet;
	
	initial begin
		$readmemb("../misc/pellets.txt", pellets);
	end
	
	

	always_ff @(posedge Clk) begin
		if (Reset) begin
			$readmemb("../misc/pellets.txt", pellets);
			seen_pellet <= 1'b0;
		end else begin
			pellets[pacman_index] <= write_pellet;
			seen_pellet <= seen_pellet_next;		
		end
		
		is_pellet <= pellets[index];
	end
	
	always_comb begin
		if (seen_pellet) begin
			write_pellet = 1'b0;
			seen_pellet_next = 1'b0;
		end else begin
			write_pellet = pellets[pacman_index];
			
			if (pellets[pacman_index]) begin
				seen_pellet_next = 1'b1;
			end else begin
				seen_pellet_next = 1'b0;
			end
		end
		
	end
	

endmodule

