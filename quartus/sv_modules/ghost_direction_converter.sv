module ghost_direction_reader(
	input [15:0] ghost_direction_nios,
	output [3:0][2:0] ghost_direction_fpga
);

always_comb begin
	ghost_direction_fpga[0][2:0] = ghost_direction_nios[2:0];
	ghost_direction_fpga[1][2:0] = ghost_direction_nios[6:4];
	ghost_direction_fpga[2][2:0] = ghost_direction_nios[10:8];
	ghost_direction_fpga[3][2:0] = ghost_direction_nios[14:12];
end

endmodule

module ghost_direction_writer(
	input [3:0][2:0] ghost_direction_fpga,
	output [15:0] ghost_direction_nios
);

always_comb begin
	ghost_direction_nios[3:0] 		= {1'b0, ghost_direction_fpga[0][2:0]};
	ghost_direction_nios[7:4] 		= {1'b0, ghost_direction_fpga[1][2:0]};
	ghost_direction_nios[11:8] 	= {1'b0, ghost_direction_fpga[2][2:0]};
	ghost_direction_nios[15:12] 	= {1'b0, ghost_direction_fpga[3][2:0]};
end

endmodule
