module FSM_updater_interface_TB();

	logic sim_clk;
	logic sim_set_clk;
	logic sim_reset;
	logic [2:0] sim_KEY;
	logic [7:0] sim_keystroke;

	logic sim_read;
	logic [22:0] sim_addr;

	FSM_speed_control test1(.inclk(sim_clk), .KEY(sim_KEY), .set_clk(sim_set_clk));
	FSM_updater_interface test2(.clk(sim_clk), .set_clk(sim_set_clk), .reset(sim_reset), .keystroke(sim_keystroke), .read(sim_read), .addr(sim_addr));

	initial begin	//this block generates a 50MHZ clock for clk
		sim_clk = 1'b0;
		forever #10000 sim_clk = ~sim_clk;
	end

	//initial begin	//this block generates a 22kHZ clock for set_clk
	//	sim_set_clk = 1'b0;
	//	forever #22720000 sim_set_clk = ~sim_set_clk;
	//end
	
	initial begin
	sim_reset = 1'b1;
	#22730000;
	sim_reset = 1'b0;
	#136330000;
	sim_keystroke = 8'h44;	//this is D, it pauses the signal
	#45440000;
	sim_keystroke = 8'h42;  //this is B, it only rewinds playback
	#45450000;
	sim_keystroke = 8'h45;  //this resumes playback but it will be opposite since we pressed B
	#908800000;
	$stop;
	end
endmodule

