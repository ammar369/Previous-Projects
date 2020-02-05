module Clock_Devider_TB;

	logic sim_inclk;
	logic sim_outclk;
	logic [31:0] sim_freq = 32'd1000000;
	
	clock_divider testClk(.inclk(sim_inclk), .outclk(sim_outclk), .freq(sim_freq));

	initial begin
		sim_inclk = 1'b0;
		forever #10000 sim_inclk = ~sim_inclk;
	end

	initial begin
		#20000000;
		$stop;

	end



endmodule
