module clock_divider
		     #(parameter N=32)
    		 (
				input inclk,
				input [N-1:0] freq,
				output logic outclk = 1'b0
			 );

	logic [N-1:0] divisor;
	logic [N-1:0] count = {32{1'b0}};
	 
	assign divisor = 32'd100000000/freq;

        always_ff @(posedge inclk)	begin
        	if(count >= divisor)	begin
					outclk <= ~outclk;
					count <= {N{1'b0}};		end
			else 	count <= count + 1'b1;	end
endmodule