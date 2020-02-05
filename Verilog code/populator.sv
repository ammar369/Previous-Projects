module populator(

input clk,
input rst,
input start,
input [7:0] in_data,
input loop_signal,

output logic [7:0] data_wr,
output logic [7:0] address_wr,
output logic finish,
output start_count,
output [7:0] init_count
output write
);

localparam idle = 2'b00;
localparam populating = 2'b01;
localparam finished = 2'b11;

logic [1:0] state = idle;
logic [1:0] next_state;

always @(posedge clk or posedge reset)
begin
	if (reset) state <= idle;
	else state <= next_state;	
end

always @(*)
begin
	case(state)
	idle:		begin	data_wr = 0;			//we initialize everything to 0 initailly
						address_wr = 0;
						start_count = 0;
						init_count = 0;
						write = 0;
						next_state <= start ? populating : idle;		//if start is high, we start execution
				end
	populating:	begin	data_wr <= in_data;			//we write i
						address_wr <= in_data;		//at address S[i]
						write <= 1'b1;				//write is enabled
						start_count <= 1'b1;		//we start counter
						next_state <= loop_signal ? finished : populating;		//if loop signal is high (loop finishes) we go to finished state
				end
	finished:	begin	start_count <= 1'b0;		//stop counting
						finish <= 1'b1;				//finish is high
						next_state <= idle;			//wait for next start input
				end
	default:	next_state <= idle;
	endcase
end

endmodule