`timescale 1ns/1ps

module layer_tb
  ();
  
  reg  pin_name1,pin_name2,pin_name3,pin_name4,clk;
  wire s0,s2,s1;
  
  Block3 dut ( .*);
				  
  always #10 clk = ~clk; 
  
  initial
    begin
	  
		clk = 1'b0;
		
		# 50;
//////////////////////////////////////////////////////		
		
		
		 
		#20;
		
		
		#50;
		
                #35;
		
		          
//////////////////////////////////////////////////////
		#50;
		
		
		 
		#20;
		
		#50;
		
                #35;
		
//////////////////////////////////////////////////////
               
                #50;
		  $stop;
		  
	 end 
	 
endmodule