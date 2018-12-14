module maze(
	input Clk,
	input [10:0] index, pacman_index,
	input [3:0][10:0] ghost_index,
	output is_wall,
	output [3:0] adjacent_walls, adjacent_walls_vga, 
	output [3:0][3:0] adjacent_walls_ghost
);

	logic [4:0] walls [0:1199];

	initial begin
		$readmemb("../misc/maze_5bit.txt", walls);
	end

	always_ff @(posedge Clk) begin
		is_wall <= walls[index][0];
		adjacent_walls <= walls[pacman_index][4:1];
		adjacent_walls_vga <= walls[index][4:1];
		adjacent_walls_ghost[0] <= walls[ghost_index[0]][4:1];
		adjacent_walls_ghost[1] <= walls[ghost_index[1]][4:1];
		adjacent_walls_ghost[2] <= walls[ghost_index[2]][4:1];
		adjacent_walls_ghost[3] <= walls[ghost_index[3]][4:1];
	end

endmodule

