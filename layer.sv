module layer #(parameter
  LENGHT_I = 4,//32
  LENGHT_O = 2,//8
  WIDTH_W = 9,//9
  WIDTH_O = $clog2(RANGE_SIGM), //7
  WIDTH_I = 1,//1
  WIDTH_SM =WIDTH_I+WIDTH_W+$clog2(LENGHT_I),//8
  RANGE_SIGM = 1000,
  ZERO_NUM = $clog2(RANGE_SIGM)-WIDTH_SM,
  WIDTH_SIGM = $clog2(RANGE_SIGM)
  
)

(
	input                								clk,
	input [LENGHT_I*LENGHT_O-1:0] [WIDTH_W-1:0]  w_i,
	input [LENGHT_I-1:0] [WIDTH_I-1:0] 				in,
	input 													wr, 
	
	
	output [LENGHT_O-1:0] [WIDTH_O-1:0] 			out 
	
	
	
	
); 

  reg zero = 1'b0;   
  reg signed [LENGHT_I*LENGHT_O-1:0] [WIDTH_W-1:0] w;
  wire signed  [WIDTH_SM-1:0] sum_mult[LENGHT_O-1:0];

	always_comb 
		begin 
		   if (wr)
			  begin 
			    w = w_i ;
			  end 
		end 
	
	
genvar k,m;
  
  generate  
    for (k=0;k<LENGHT_O;k = k+1) begin:loop_k
	   for (m=0;m<LENGHT_I ;m = m+1)
		  begin:loop_m
		    wire [WIDTH_SM-1:0] mult; 
		    if(m == 0)
		        assign loop_m[m].mult = w[m+k*LENGHT_I]*in[m];
			 else if (m == LENGHT_I-1)
		        assign sum_mult[k] = w[m+k*LENGHT_I]*in[m]+loop_m[m-1].mult;
			 else 
			     assign loop_m[m].mult = w[m+k*LENGHT_I]*in[m]+loop_m[m-1].mult;
		  end 
		end  
  endgenerate  
  
  
  
 genvar l;
  
  generate 
    for (l=0;l<LENGHT_O;l=l+1) begin:loop_l
	   sigmoid #(.RANGE(RANGE_SIGM))
		sigm_inst_o(.x(sum_mult[l][WIDTH_SM-1:WIDTH_SM-WIDTH_SIGM-1]),.f(out[l]));//{{ZERO_NUM{1'b0}},sum_mult[l]}
		//assign out[l] = f_out[l]; 
	   end
		
  endgenerate 


endmodule 

 