
module FSM_updater_interface (

input clk,
input set_clk,
input reset,
input [7:0] keystroke,

output logic read,
output logic [22:0] addr
);

parameter [2:0] FORWARD = 3'b000;
parameter [2:0] BACKWARD = 3'b001;
parameter [2:0] PAUSED = 3'b011;
parameter [2:0] START = 3'b010;
parameter [2:0] START_END = 3'b110;

parameter [7:0] D = 8'h44;
parameter [7:0] E = 8'h45;
parameter [7:0] F = 8'h46;
parameter [7:0] B = 8'h42;
parameter [7:0] R = 8'h52;

logic playback;
logic [2:0] state;
logic [2:0] next_state;
logic [22:0] next_addr;
logic [22:0] first_addr = 23'h0;
logic [22:0] last_addr = 23'h7ffff;

always_ff @(posedge clk or posedge reset) begin
	if (reset) state <= START;
	else state <= next_state;	end
	
always_ff @(posedge set_clk) begin
	addr <= next_addr;
end

always @(*) begin 
	case (state)
	START:	begin	next_addr = first_addr;
				if (addr == first_addr) next_state <= FORWARD;
				else next_state <= START;	end
	START_END: begin next_addr = last_addr;
				if (addr == last_addr) next_state <= BACKWARD;
				else next_state <= START_END; end
	FORWARD: begin 	next_addr = addr + 1'b1; //forward playback
			playback = 1'b1;	//if bit is set, it will resume forward playback
			if (addr == last_addr) next_addr = first_addr;	
			case (keystroke) 
				D: next_state <= PAUSED;
				E: next_state <= FORWARD;
				B: next_state <= BACKWARD;
				F: next_state <= FORWARD;
				R: next_state <= START;
				default: next_state <= FORWARD;
			endcase	end
	BACKWARD: begin	next_addr = addr - 1'b1; //backward playback
			playback = 1'b0;	//if bit is not set, it will resume backward playback
			if (addr == first_addr) next_addr = last_addr;	
			case (keystroke) 
				D: next_state <= PAUSED;
				E: next_state <= BACKWARD;
				B: next_state <= BACKWARD;
				F: next_state <= FORWARD;
				R: next_state <= START_END;
				default: next_state <= BACKWARD;
			endcase	end
	PAUSED: begin	next_addr = addr;
			case (keystroke) 
				D: next_state <= PAUSED;
				E: begin if (playback) next_state <= FORWARD;
					else next_state <= BACKWARD;	end
				B: playback = 1'b0;
				F: playback = 1'b1;
				R: begin if (playback) next_state <= START;
					else next_state <= START_END;	end
				default: next_state <= PAUSED;
			endcase	end

	default: next_addr = addr;
	endcase

	if (state == START | START_END) read = 1'b1;
	if (state == PAUSED) read = 1'b0;

end

endmodule

