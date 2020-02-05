module FSM_reader_TB();

	logic sim_clk;
	logic sim_reset;
	logic sim_waitrequest;
	logic sim_readdatavalid;
	logic [15:0] sim_readdata;

	logic [15:0] sim_audio_sample;

	FSM_reader test1(
	.clk(sim_clk),
	.reset(sim_reset),
	.waitrequest(sim_waitrequest),
	.readdatavalid(sim_readdatavalid),
	.readdata(sim_readdata),
	.audio_sample(sim_audio_sample));

	initial begin	//this block generates a 50MHZ clock for clk
		sim_clk = 1'b0;
		forever #10000 sim_clk = ~sim_clk;
	end

	initial begin
	#21000;
	sim_reset = 1'b1;		//goes to WAIT
	sim_waitrequest = 1'b1;
	#21000;
	sim_reset = 1'b0;
	#201000;
	sim_waitrequest = 1'b0;		//goes to COPY
	#42000;
	sim_readdata = 16'b0101010101010101;
	#1000;
	sim_readdatavalid = 1'b1;	//copies and then goes to SEND
	#92000;				//goes to SEND
	sim_waitrequest = 1'b1;		//goes to WAIT
	#50000;
	$stop;
	end
endmodule
