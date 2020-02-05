module FSM_speed_control(

input inclk,
input key0,
input key1,
input key2,
output reg set_clk);

logic [31:0] divider;
//logic [31:0] inc = 32'd500;		//default freq is set as 22000
//logic [31:0] dec = 32'd300;	//default input clock rate is set as 50MHz
logic [31:0] div = 32'd2272;
//assign div = in_rate/freq;		//divisor is 50M divided by the freq needed

always @(posedge inclk) begin
		divider <= div;
end

always @(*)begin	//freq will only change when KEY is pressed, not based on how long it is pressed
	if (key2) div = 32'd2272;
	else if (key1) div = div + 32'd500;
	else if (key0) div = div - 32'd300;
	else div = div;
	//case(KEY)
	//	3'b1xx: div = 32'd2272;		//freq becomes 22000 when key2 pressed
	//	3'bx1x: div = div + 32'd500;		//freq decrements by 2200, sampling rate slows, when key1 pressed
	//	3'bxx1: div = div - 32'd300;		//freq increment by 2200, sampling rate increases, when key0 pressed
	//	default: div = div;			//guard against latches
	//endcase
end
Generate_Arbitrary_Divided_Clk32 dut(
.inclk(inclk),
.outclk(set_clk),
.outclk_Not(),
.div_clk_count(divider), //change this if necessary to suit your module
.Reset(1'h1)); 
endmodule

