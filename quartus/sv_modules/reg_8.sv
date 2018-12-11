module score_reg (
	input  logic Clk, Reset, increment,
	output logic [15:0] out
);
	
	logic [15:0] score, score_next;
					
	always_ff @ (posedge Clk) begin
		if (Reset)				// clear on reset
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
	
	end
endmodule
