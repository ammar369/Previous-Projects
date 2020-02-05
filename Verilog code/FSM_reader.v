module FSM_reader(

	input clk,
	input reset,
	input waitrequest,
	input readdatavalid,
	input [31:0] readdata,

	output logic [15:0] audio_sample
);

logic [1:0] state;
logic [1:0] next_state;
logic [15:0] buffer;

parameter [1:0] WAIT = 2'b00;
parameter [1:0] COPY = 2'b01;
parameter [1:0] SEND = 2'b11;


always_ff @(posedge clk or posedge reset) begin
	if(reset) state <= WAIT;
	else state <= next_state; end

always @(*) begin
	case(state)
	WAIT:	begin 	if (waitrequest) next_state <= WAIT;
			else next_state <= COPY;	end
	COPY:	begin 	if (readdatavalid) begin
				buffer = readdata [15:0];
				next_state <= SEND;	end
			else next_state <= COPY;	end
	SEND:	begin 	audio_sample = buffer;
			if (waitrequest) next_state <= WAIT;
			else next_state <= SEND;	end
	default: 	next_state = WAIT;
	endcase
	end

endmodule
