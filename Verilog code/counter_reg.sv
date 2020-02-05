module counter_reg		//gives out_data that increments at every clock cycle to reach a max value of 255 and then resets to 0
(
input clk,
input rst,
input [7:0] in,
input enable,
input pause,

output logic [7:0] out_data,
output logic overflow
);

logic [8:0] count;
logic [1:0] state = idle;
logic [1:0] next_state;

localparam idle = 2'b00;
localparam counting = 2'b01;
localparam waiting = 2'b11;

always @(posedge clk or posedge reset) 
begin
	if (reset) state <= idle;
	else state <= next_state;
end

always @(posedge clk) 
begin
	out_data <= count [7:0];
	overflow <= count [8];
end

always @(*)
begin
	case(state)
		idle:		begin	count = in;									//count gets value of input in, this is where we start counting
							next_state <= enable ? counting : idle;		//if enable is high, we initiate counting from idle state
					end
		counting:	begin	if (pause) next_state <= paused;			//if pause is high, we go to pause state instead
							else 	begin 	count = count + 1'b1;		//we increment count (i)
											if (count[8] == 1'b1) 	begin	overflow <= 1'b1;		//if overflows, we set overflow bit to 1
																			next_state <= waiting;	//then we go to wait state
																	end
											else next_state <= counting;	//if we do not overflow, we will count again
									end
					end
		paused:		begin	count = count;
							next_state <= pause ? paused : counting;
					end
		waiting:	begin	overflow <= 1'b0;		//overflow is reset
							count <= 9'b0;			//count is also reset
							next_state <= idle; 	//we go to idle state next if enable is high
					end
		default:			next_state <= idle;
	endcase
end

endmodule

module register
(
input clk,
input rst,
input en,
input [7:0] in_data,

output logic [7:0] out_data
);
	
always @(posedge clk)
begin
	if (rst) out_data <= 8'b0;
	else 	begin	if (en) out_data <= in_data;
			end
end

endmodule