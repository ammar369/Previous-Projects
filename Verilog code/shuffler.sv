module shuffler
(
input start,
input [7:0] data_i,
input [7:0] data_j,
input loop_signal,
input [7:0] ram_data,
input [23:0] secret_key,

output logic [7:0] data_to_ram,
output logic [7:0] address_to_ram,
output logic ram_wren,

output logic [7:0] init_count,
output logic start_count,
output logic pause_i,

output logic [7:0] reg_in,
output logic reg_enable,

output logic finish
);

localparam idle = 3'b000;
localparam get_var = 3'b001;
localparam calculate = 3'b011;
localparam read_Sj = 3'b010;
localparam write_Si = 3'b110;
localparam write_Sj = 3'b100;
localparam incrmnt_i = 3'b101;
localparam finished = 3'b111;

logic [2:0] state = idle;
logic [2:0] next_state;

logic [7:0] key [0:2];
logic [1:0] c;

assign c = data_i % 2'b11;
assign key[0] = secret_key[23:16];
assign key[1] = secret_key[15:8];
assign key[2] = secret_key[7:0];

logic [7:0] temp_Si;
logic [7:0] temp_j;

always @(posedge clk or posedge reset)
begin
	if (reset) state <= idle;
	else state <= next_state;	
end

always @(*)
begin
	case(state)
	idle:		begin	data_to_ram = 0;
						address_to_ram = 0;
						ram_wren = 0;
						init_count = 0;
						start_count = 0;
						pause_i = 0;
						reg_in = 0;
						reg_enable = 0;
						next_state <= start ? get_var : idle;		//if start is high, we start operation
				end
	get_var:	begin	pause_i = 1'b1;
						if (loop_signal) next_state <= finished;	//loop signal tells if i overflows (reaches 256) and it then stops the loop
						address_to_ram <= data_i;	//value of i is passed as address to the ram to get data at that position S[i]
						next_state <= calculate;
				end
	calculate:	begin	temp_Si = ram_data;			//data from ram is stored in a temp variable
						temp_j = data_j + key[c] + ram_data	//we take in old value of j, secret key, and S[i](in ram data)
						next_state <= read_Sj;
				end
	read_Sj:	begin	reg_in = temp_j;			//we update value of j stored in register
						reg_enable = 1'b1;			//we write to register with new j
						address_to_ram <= temp_j;	//we read S[j]
						next_state <= write_Si;
				end
	write_Si:	begin	temp_Sj = ram_data;			//S[j] is stored in variable
						data_to_ram = temp_Sj;		//S[j] is data to be written in ram
						address_to_ram = data_i;	//it is to be written at address of i, so S[i] = S[j]
						ram_wren = 1'b1;			//we start writing
						next_state <= write_Sj;
				end
	write_Sj:	begin	data_to_ram = temp_Si;		//we take value of S[i] and send that to be written to ram
						address_to_ram = data_j;	//we write the data at address S[j]
						ram_wren = 1'b1;			
						next_state <= incrmnt_i;
				end
	incrmnt_i:	begin	start_count = 1'b1;			//we enable the counter register to increment (if for first  timme)
						pause_i = 1'b0;				//we unpause the counter (for following times)	
						next_state <= get_var;
				end
	finished:	begin	finish = 1;					//when loop computes 256 times, we finish execution
						next_state <= idle;			//then we again go to idle state to wait for next start input
				end
	default:	next_state <= idle;
	endcase
end

endmodule