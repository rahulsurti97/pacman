module index_calculator(
	input logic [9:0] x, y,
	output logic [10:0] index
);

	always_comb begin
		index = (x >> 4) + ((y >> 4) * 40);
	end

endmodule
