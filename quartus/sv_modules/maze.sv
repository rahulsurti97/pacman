module maze(
	input Clk,
	input [10:0] index, pacman_index,
	output is_wall,
	output [3:0] adjacent_walls, adjacent_walls_vga
);

	logic [4:0] walls [0:1199];

	initial begin
		$readmemb("../misc/maze_5bit.txt", walls);
	end

	always_ff @(posedge Clk) begin
		is_wall <= walls[index][0];
		adjacent_walls <= walls[pacman_index][4:1];
		adjacent_walls_vga <= walls[index][4:1];
	end

endmodule

