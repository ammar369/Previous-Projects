module flash_tb();

logic 		 sim_clk;
logic            sim_flash_mem_read;
logic            sim_flash_mem_waitrequest;		
logic    [22:0]  sim_flash_mem_address;		//this will be the slaves 23 bit address
logic    [31:0]  sim_flash_mem_readdata;		//this will be a 32 bit block containing 2 16 bit words
logic            sim_flash_mem_readdatavalid;
logic    [3:0]   sim_flash_mem_byteenable = 4'b0011;//we will only read the lower 16 bit word



flash flash_test (
    .clk_clk                 (sim_clk),
    .reset_reset_n           (1'b1),
    .flash_mem_write         (1'b0),
    .flash_mem_burstcount    (1'b1),
    .flash_mem_waitrequest   (sim_flash_mem_waitrequest),
    .flash_mem_read          (sim_flash_mem_read),
    .flash_mem_address       (sim_flash_mem_address),
    .flash_mem_writedata     (),
    .flash_mem_readdata      (sim_flash_mem_readdata),
    .flash_mem_readdatavalid (sim_flash_mem_readdatavalid),
    .flash_mem_byteenable    (sim_flash_mem_byteenable)
);

	initial begin	//this block generates a 50MHZ clock for clk
		sim_clk = 1'b0;
		forever #10000 sim_clk = ~sim_clk;
	end

	initial begin
	#50000;
	sim_flash_mem_read = 1'b1;
	sim_flash_mem_address = 23'h0;
	#200000;
	$stop;
	end
endmodule

