`timescale 1ns/1ps

module network_tb
  
  #(parameter
   N_LAYER_W =1,
	WIDTH = 32,
	//log2(RANGE_SIGM)<WIDTH_I+WIDTH_W+$clog2(LENGHT_I) 
  RANGE_SIGM = 1000,
  //neiron in 
  LENGHT_I = 2,
  WIDTH_I = 10,
  //neiron mid 
  LENGHT_MID = 2,
  WIDTH_MID = $clog2(RANGE_SIGM),
  //neiron out
  LENGHT_O = 2,
  WIDTH_O = $clog2(RANGE_SIGM),
  
  //weight in 
//  WIDTH_W_I = 9,
//  //weight out
//  WIDTH_W_O = 9 ,
  WIDTH_W = 4,
	WIDTH_ADDR = $clog2(LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+LENGHT_I+LENGHT_O+3),
	MAX_REG_W = LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+1,
	MAX_REG_I = MAX_REG_W + LENGHT_I+1,
	MAX_REG_O = MAX_REG_I + LENGHT_O+1 //309
)
  (
  
  );
  
  //in 
    logic 										 clk;
	logic                                      reset;
  	logic [WIDTH-1:0]                           in_d;
	logic [WIDTH_ADDR-1:0]                   address;
	logic                                       read;
    logic                                      write;
	
	//out 
	logic                       [WIDTH-1:0]    out_d ;
	logic  										ready;
	logic   								    down;
	logic [LENGHT_I-1:0] [WIDTH_I-1:0]          reg_i;
    logic [LENGHT_MID-1:0] [WIDTH_MID-1:0] mid_neiron; 
    logic [LENGHT_O-1:0] [WIDTH_O-1:0]          reg_o;
	
  ff_network #(.LENGHT_I(LENGHT_I),
             .LENGHT_O(LENGHT_O),
			 .LENGHT_MID(LENGHT_MID),
			 .WIDTH_W(WIDTH_W),
			 .WIDTH(WIDTH),
			 .WIDTH_I(WIDTH_I),
			 .WIDTH_O(WIDTH_O),
			 .RANGE_SIGM(RANGE_SIGM)
			 
			 
			 
			 
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
      #50;
		gen_write_w(8,clk);
		@(posedge clk);
	   in_d = {WIDTH{1'b1}};
      address = 9'd8;
		@(posedge clk);
	   wait_task(4,clk);	
		gen_write_i(2,clk);
		@(posedge clk);
		in_d = {WIDTH{1'b1}};
		address = 9'd11;
		@(posedge  clk);
		//network_out(7,clk);
		#250;
		  $stop;
  
		  
	 end 
	 

task automatic gen_write_w(int rpt, ref logic clk);
	begin
	   read = 0;
		write = 1;
		in_d = 15;
		repeat(rpt-1) 
		  begin 
		    @(posedge clk);
			 //in_d = in_d + 1;
			 address = address + 1;
		  end
		
	end
endtask
task automatic wait_task(int rpt, ref logic clk);
	begin
	   read = 0;
		write = 0;
		address++;	
		in_d = 9'b0000;
		
		repeat(rpt-1) 
		  begin 
		    @(posedge clk);
			 
		  end
		
	end
endtask 

task automatic gen_write_i(int rpt, ref logic clk);
	begin
	   read = 0;
		write = 1;
		in_d = 1023;
		repeat(rpt-1) 
		  begin 
		    @(posedge clk);
			 //in_d = in_d + 100;
			 address = address + 1;
			 
		  end
		
	end
endtask
endmodule