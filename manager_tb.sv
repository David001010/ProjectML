`timescale 1ns/1ps

module layer_tb
  
  #(parameter
   N_LAYER_W =1,
	WIDTH = 4,
	WIDTH_W = 9, 
	LENGHT_I = 2,
	LENGHT_MID = 2,
	LENGHT_O = 2,
	WIDTH_ADDR = $clog2(LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+LENGHT_I+LENGHT_O+3),
	MAX_REG_W = LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+1,
	MAX_REG_I = MAX_REG_W + LENGHT_I+1,
	MAX_REG_O = MAX_REG_I + LENGHT_O+1 //309
)
  (
  
  );
  
  
   logic 													clk;
	logic                                      reset;
  	logic [WIDTH-1:0]                           in_d;
	logic [WIDTH_ADDR-1:0]                   address;
	logic                                       read;
   logic                                      write;
	
	
	logic                [WIDTH-1:0]    out_d ;
	logic  										ready;
	logic   										down;
	logic                               wr;
	logic [MAX_REG_W-2:0] [WIDTH_W-1:0] w_o;
	
  manager #(.LENGHT_I(LENGHT_I),
          .LENGHT_O(LENGHT_O),
			 .LENGHT_MID(LENGHT_MID),
			 .WIDTH_W(WIDTH_W),
			 .WIDTH(WIDTH),
			 .WIDTH_ADDR(WIDTH_ADDR)
			 
			 
			 
			 
  ) dut ( .*);
				  
  always #10 clk = ~clk; 
  
  initial
    begin
	  
	 clk = 0;
    reset = 1;
    read = 0;
    write = 0;
    in_d = 0;
    address = 9'd0;
	 
	 # 50;
	 reset = 0;

/// write state 
	 # 50;
	 read = 0;
    write = 1;
    in_d = 9'd1;
    address = 9'd0;
	 
	 # 50;
	 read = 0;
    write = 1;
    in_d = 9'd3;
    address = 9'd1;
	 
	 # 50; 
	 read = 0;
    write = 1;
    in_d = 9'd5;
    address = 9'd2;
	 
	 # 50;
	 read = 0;
    write = 1;
    in_d = 9'd1;
    address = 9'd3;
	 
	 # 50;
	 read = 0;
    write = 1;
    in_d = 9'b1111;
    address = 9'd4;          
     #50;
		  $stop;
		  
	 end 
	 
endmodule