module score_reg (
	input  logic Clk, Reset, Reset_game, increment,
	output logic [15:0] out
);
	
	logic [15:0] score, score_next;
					
	always_ff @ (posedge Clk) begin
		if (Reset | Reset_game)				// clear on reset
			score <= 16'h0;
		else
			score <= score_next;
		
		out <= score_next;
	end
	
	always_comb begin
		score_next = score;
		
		if (increment) begin
			score_next = score + 1;
			
		end
		
		if (score[3:0] == 4'ha) begin
			score_next = score + 6;
		end
		
		else if (score[7:4] == 4'ha) begin
			score_next = score + 8'h60;
		end

	end
endmodule
