module FSM_speed_control_TB;

	logic sim_inclk;
	logic sim_set_clk;
	logic [2:0] sim_key = 3'b000;
	
	FSM_speed_control test1(.inclk(sim_inclk), .KEY(sim_key), .set_clk(sim_set_clk));

	initial begin	//this block generates a 50MHZ clock
		sim_inclk = 1'b0;
		forever #10000 sim_inclk = ~sim_inclk;
	end

	initial begin
		sim_key = 3'b010;
		#21000;
		sim_key = 3'b000;
		#21000;
		sim_key = 3'b010;
		#21000;
		sim_key = 3'b000;
		#21000;
		sim_key = 3'b010;
		#21000;
		sim_key = 3'b000;
		//#21000;
		//sim_key = 3'b100;
		#90880000;
		$stop;
	end

endmodule


