module pellets(
	input Clk,
	input [10:0] index,
	output logic is_pellet
);

	logic pellets [0:1199];

	initial begin
		$readmemb("../misc/pellets.txt", pellets);
	end

	always_ff @(posedge Clk) begin
		is_pellet <= pellets[index];
	end

endmodule

