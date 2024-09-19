module midlayer #(parameter
  LENGHT_I = 32,
  LENGHT_O = 8,
  WIDTH_W = 9,
  WIDTH_S = 10, 
  WIDTH_O = 7, 
  WIDTH_SM =8
  
)

(
	input                clk,
	input [WIDTH_W-1:0]  w_i,
	input [LENGHT_I-1:0] in,
	
	
	output [WIDTH_O-1:0] out 
	
	
	
); 


  reg [WIDTH_W-1:0] w[0:LENGHT_I*LENGHT_O-1];
  wire [WIDTH_SM-1:0] sum_mult[LENGHT_O-1:0];


genvar k,m;
  
  generate  
    for (k=0;k<LENGHT_O;k = k+1) begin:loop_k
	   for (m=0;m<LENGHT ;m = m+1)
		  begin:loop_m
		    wire [WIDTH_S+WIDTH_W-1:0] mult; 
		    if(m == 0)
		        assign loop_m[m].mult = w[m]*in[m];
			 else if (m == LENGHT-1)
		        assign sum_mult[k] = w[m]*in[m]+loop_m[m-1].mult;
			 else 
			     assign loop_m[m].mult = w[m]*in[m]+loop_m[m-1].mult;
		  end 
		end  
  endgenerate 
  
  
  
 genvar l;
  
  generate 
    for (l=0;l<LENGHT_O;l=l+1) begin:loop_l
	   sigmoid #(.WIDTH_S(WIDTH_S),.WIDTH_W(WIDTH_W+WIDTH_S+LENGHT_O))
		sigm_inst_o(.x(sum_mult[l]),.f(f_out[l]));
	   end
  endgenerate 




 