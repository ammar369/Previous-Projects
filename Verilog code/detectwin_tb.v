module detectwin_tb ();
  // No inputs or outputs, because it is a testbench

   reg [8:0] sim_ain;
   reg [8:0] sim_bin;
 
   wire [7:0] sim_win_line;

    DetectWinner dut (
      .ain(sim_ain),
      .bin(sim_bin),
      .win_line(sim_win_line)  );

    initial begin
      // start out with an empty board
      sim_ain = 9'b0;
      sim_bin = 9'b0;
      
      // wait five simulation timesteps to allow those changes to happen
      #50;
      
      // Our first test: winner in top row
      sim_ain = 9'b111000000;
      
      // again, wait five timesteps to allow changes to occur
      #50;
      
      // print the current values to the Modelsim command line
      $display("Output is %b, we expected 00000001", sim_win_line);

	  #50;
	  
      // win in middle row
      sim_ain = 9'b000111000;
      sim_bin = 9'b0;
      #50;

      $display("Output is %b, we expected 00000010", sim_win_line);
      
      // win in bottom row
      sim_ain = 9'b000000111;
      sim_bin = 9'b000000000;
      #50;
        
      $display("Output is %b, we expected 00000100", sim_win_line);
          
      // win in first column
      sim_ain = 9'b101110100;
      sim_bin = 9'b000000000;
      #50;
        
      $display("Output is %b, we expected 00001000", sim_win_line);
	  
	  // win in second column
      sim_ain = 9'b010110011;
      sim_bin = 9'b000000000;
      #50;
        
      $display("Output is %b, we expected 00010000", sim_win_line);
	  
	  // win in third column
      sim_ain = 9'b011101001;
      sim_bin = 9'b000000000;
      #50;
        
      $display("Output is %b, we expected 00100000", sim_win_line);
	  
	  // win in downward diagonal
      sim_ain = 9'b000000000;
      sim_bin = 9'b100010001;
      #50;
        
      $display("Output is %b, we expected 01000000", sim_win_line);
	  
	  // win in upward diagonal
      sim_ain = 9'b000000000;
      sim_bin = 9'b101010100;
      #50;
        
      $display("Output is %b, we expected 10000000", sim_win_line);
	  
	  // test case: all X's in grid
      sim_ain = 9'b111111111;
      sim_bin = 9'b000000000;
      #50;
        
      $display("Output is %b, we expected 00000001 as top row gets priority", sim_win_line);

      $stop;
  end
endmodule
