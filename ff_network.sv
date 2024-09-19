module ff_network #(parameter
  WIDTH= 32,
  RANGE_SIGM = 1000,
  //neiron in 
  LENGHT_I = 32,
  WIDTH_I = 1,
  //neiron mid 
  LENGHT_MID = 8,
  WIDTH_MID = $clog2(RANGE_SIGM),
  //neiron out
  LENGHT_O = 2,
  WIDTH_O = $clog2(RANGE_SIGM),
  //weight in 
//  WIDTH_W_I = 9,
//  //weight out
//  WIDTH_W_O = 9 ,
  WIDTH_W = 9,
  MAX_REG_W = LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+1,//273
  MAX_REG_I = MAX_REG_W + LENGHT_I+1, //306
  MAX_REG_O = MAX_REG_I + LENGHT_O+1, //309
  WIDTH_ADDR = $clog2(LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+LENGHT_I+LENGHT_O+3),
  
  
  
  
  WIDTH_SM = WIDTH_I+WIDTH_W+$clog2(LENGHT_I),//8
  ZERO_NUM = $clog2(RANGE_SIGM)-WIDTH_SM,
  WIDTH_SIGM = $clog2(RANGE_SIGM)
  
)
(
  input clk,reset,
  input read,write,
  input [WIDTH-1:0] in_d, 
  input [WIDTH_ADDR-1:0] address,
  
  output [WIDTH-1:0] out_d,
  output ready,down//system is ready to input 
   
  );
//  logic [LENGHT_I*LENGHT_MID-1:0] [WIDTH_W_I-1:0] reg_w_i;
//  logic [LENGHT_O*LENGHT_MID-1:0] [WIDTH_W_O-1:0] reg_w_o;
  logic [MAX_REG_W-2:0 ] [WIDTH_W-1:0] reg_w;
  
  logic [LENGHT_I-1:0] [WIDTH_I-1:0]          reg_i;
  logic [LENGHT_MID-1:0] [WIDTH_MID-1:0] mid_neiron; 
  logic [LENGHT_O-1:0] [WIDTH_O-1:0]          reg_o;
  logic 														 wr;
 
  manager #(.WIDTH(WIDTH),
           .WIDTH_W(WIDTH_W), 
	        .LENGHT_I(LENGHT_I),
	        .LENGHT_MID(LENGHT_MID),
	        .LENGHT_O(LENGHT_O)
           )
			  manager_inst(
			  .clk(clk),
			  .reset(reset),
	        .read(read),
			  .write(write),	
	        .in_d(in_d), 
           .address(address),
	        .out_d(out_d),
	        .ready(ready),
			  .down(down),
			  .wr(wr),
	        .w_o(reg_w)
			  
			   );
  
  layer#(.LENGHT_I(LENGHT_I),
			.LENGHT_O(LENGHT_MID),
			.WIDTH_W(WIDTH_W),
			.WIDTH_I(WIDTH_I),
			.RANGE_SIGM(RANGE_SIGM)
         )  
			layer_inst_in(
			.clk(clk),
			.wr(wr),
			.w_i(reg_w[LENGHT_I*LENGHT_MID-1:0]),
			.in(reg_i),
			.out(mid_neiron)//goes to in 
			
			);
			
  layer#(.LENGHT_I(LENGHT_MID),
			.LENGHT_O(LENGHT_O),
			.WIDTH_W(WIDTH_W),
			.WIDTH_I(WIDTH_MID),
			.RANGE_SIGM(RANGE_SIGM)
         )  
			layer_inst_out(
			.clk(clk),
			.wr(wr),
			.w_i(reg_w[MAX_REG_W-2:LENGHT_I*LENGHT_MID]),
			.in(mid_neiron),
			.out(reg_o)
			
			
			);
	
  
  
endmodule  
