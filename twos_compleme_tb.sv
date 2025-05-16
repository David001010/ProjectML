`timescale 1ns/1ps

module twos_compleme_tb 


	#(parameter
	
	WIDTH_I = 1,//1
   WIDTH_W = 9//9
	
)
(

 
);

		logic  clk;
      logic  [WIDTH_W + WIDTH_I+1-1:0]in;
 
      logic  [WIDTH_W + WIDTH_I+1-1:0]out;

		
	twos_compleme #(.WIDTH_I(WIDTH_I),
						 .WIDTH_W(WIDTH_W)
						 
	
	
	) dut(.*);
							
							
	always #10 clk = ~clk; 
  
  initial
    begin
	 
		clk = 0;
		in = 11'b00000000000;
		#50 
		in = 11'b00001000000;
		#50 
		in = 11'b10000010000;
		#50
		
		$stop(); 
		
	 end
endmodule
	