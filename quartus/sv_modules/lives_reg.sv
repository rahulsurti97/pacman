module lives_reg (
	input  logic Clk, Reset, Restart,
	output logic [1:0] out,
	output Reset_game
);
	
	logic [1:0] lives, lives_next;
	logic Reset_game_next;
					
	always_ff @ (posedge Clk) begin
		if (Reset)				// clear on reset
			lives <= 2'b11;
		else
			lives <= lives_next;
		
		out <= lives_next;
		Reset_game <= Reset_game_next;
	end
	
	always_comb begin
		lives_next = lives;
		Reset_game_next = 0;
		
		if (Restart) begin
			lives_next = lives - 1;
			
			if (lives == 1) begin
				Reset_game_next = 1;
				lives_next = 2'b11;
			end
		end
	
	end

endmodule
