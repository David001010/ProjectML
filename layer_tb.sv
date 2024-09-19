`timescale 1ns/1ps

module layer_tb
  
  #(parameter
  LENGHT_I = 4,//32
  LENGHT_O = 2,//8
  WIDTH_W = 9,//9
  WIDTH_S = 10,//10
  WIDTH_O = $clog2(RANGE_SIGM), //7
  WIDTH_I = 1,//1
  WIDTH_SM =WIDTH_I+WIDTH_W+$clog2(LENGHT_I),//8
  RANGE_SIGM = 1000,
  ZERO_NUM = $clog2(RANGE_SIGM)-WIDTH_SM,
  WIDTH_SIGM = $clog2(RANGE_SIGM) 
)
  (
  
  );
  
  
   logic 													clk;
  	logic [LENGHT_I*LENGHT_O-1:0] [WIDTH_W-1:0]  w_i;
	logic [LENGHT_I-1:0] [WIDTH_I-1:0] 				in;
	
	
	logic [LENGHT_O-1:0] [WIDTH_O-1:0] out ;
	
  layer #(.LENGHT_I(LENGHT_I),
          .LENGHT_O(LENGHT_O),
			 .WIDTH_W(WIDTH_W),
			 .WIDTH_S(WIDTH_S),
			 .WIDTH_I(WIDTH_I),
			 .RANGE_SIGM(RANGE_SIGM)
			 
			 
			 
  ) dut ( .*);
				  
  always #10 clk = ~clk; 
  
  initial
    begin
	  
		clk = 1'b0;
		w_i[0]= 0;
		w_i[1]= 0;
		w_i[2]= 0;
		w_i[3]= 0;	
		w_i[4]= 0;
		w_i[5]= 0;
		w_i[6]= 0;
		w_i[7]= 0;
		in[0] = 0;
		in[1] = 0;
		in[2] = 0;
		in[3] = 0;
		
		
		# 50;
///////////////////// ///////////////////////////////		
		w_i[0]= 1;
		w_i[1]= 2;
		w_i[2]= 3;
		w_i[3]= 4;	
		w_i[4]= 5;
		w_i[5]= 1;
		w_i[6]= 2;
		w_i[7]= 3;	
		in[0] = 0;
		in[1] = 1;
		in[2] = 1;
		in[3] = 1;
		
		 
		#20;
		w_i[0]= 0;
		w_i[1]= 0;
		w_i[2]= 0;
		w_i[3]= 0;	
		w_i[4]= 0;
		w_i[5]= 0;
		w_i[6]= 0;
		w_i[7]= 0;	
		in[0] = 0;
		in[1] = 0;
		in[2] = 0;
		in[3] = 0;
		
//		#50;
//		w_i[0]= -2;
//		w_i[1]= 4;
//		in[0] = 1;
//		in[1] = 1;
                #35;
		
		          
//////////////////////////////////////////////////////
		#50;
		
		
		 
		#20;
//		
//		w_i[0]= -2;
//		w_i[1]= -4;
//		in[0] = 1;
//		in[1] = 1;
		
		
		#50;
		
                #35;
		
//////////////////////////////////////////////////////
               
                #50;
		  $stop;
		  
	 end 
	 
endmodule