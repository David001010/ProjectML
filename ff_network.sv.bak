module ff_nnetwork #(parameter
  WIDTH = 32,
  LENGHT = 8,
  WIDTH_W = 9,
  WIDTH_S = 10,// width sigmoid 
  WIDTH_O = 7, // width out
  LENGHT_O =2
  
)
(
  input clk,reset,
  input read,write,
  input [WIDTH-1:0] in_d, 
  //input [] address,
  
  output [WIDTH-1:0] out_d,
  output ready,
  output [WIDTH_W+WIDTH-1:0]sum_mult_0o,sum_mult_1o,sum_mult_2o,sum_mult_3o,sum_mult_4o,sum_mult_5o,
  output [WIDTH_W+WIDTH-1:0]sum_mult_6o,sum_mult_7o
  
  
  
  ); 
  
  
  
  reg [WIDTH_W-1:0] w_i[0:WIDTH*LENGHT-1];//ves input
  reg [WIDTH_W-1:0] w_o [0:LENGHT_O*LENGHT-1];
  wire [WIDTH_S-1:0]f_mid[LENGHT];
  wire [WIDTH_W-1:0]sum_mult_i[0:LENGHT-1];//suma *
  //wire [WIDTH_W-1:0]mult_i;//midmult
  wire [WIDTH_O-1:0]f_out[0:LENGHT_O-1];
  wire [WIDTH_W+WIDTH_S+LENGHT_O-1:0]sum_mult_o[0:LENGHT_O-1];
  
  
  
  initial 
    begin 
	   $readmemh("wi.txt",w_i);
		$readmemh("wo.txt",w_o);
	 end
  
  
  
//  assign sum_mult_i[0] = w_i[0]*in_d[0]+w_i[1]*in_d[1]+....+w_i[31]*in_d[31]
//  assign sum_mult_i[1] = w_i[32]*in_d[0]+w_i[33]*in_d[1]+....+w_i[63]*in_d[31]
//  assign sum_mult_i[7] = w_i[224]*in_d[0]+w_i[225]*in_d[1]+....+w_i[255]*in_d[31] 
  
  
  
  genvar i,n;
  
  generate  
    for (n=0;n<LENGHT;n = n+1) begin:loop_n 
	   for (i=0;i<WIDTH ;i = i+1)
		  begin:loop_i
		    wire [WIDTH_W-1:0] mult_i;//midmult
		    if(i == 0)
		        assign loop_i[i].mult_i = w_i[i]*in_d[i];
			 else if (i == WIDTH-1)
		        assign sum_mult_i[n] = w_i[i]*in_d[i]+loop_i[i-1].mult_i;
			 else 
			     assign loop_i[i].mult_i = w_i[i]*in_d[i] + loop_i[i-1].mult_i;
		  end 
		end  
  endgenerate 
  
//  assign sum_mult_i_0o = sum_mult_i[0];
//  assign sum_mult_i_1o = sum_mult_i[1];
//  assign sum_mult_i_2o = sum_mult_i[2];
//  assign sum_mult_i_3o = sum_mult_i[3];
//  assign sum_mult_i_4o = sum_mult_i[4];
//  assign sum_mult_i_5o = sum_mult_i[5];
//  assign sum_mult_i_6o = sum_mult_i[6];
//  assign sum_mult_i_7o = sum_mult_i[7];
  
  
  //sigmoid sigm_inst(.x(sum_mult_i[0]),.f(f_mid[0]));
  
  genvar j;
  
  generate 
    for (j=0;j<LENGHT;j=j+1) begin:loop_j
	   sigmoid #(.WIDTH_S(WIDTH_S),.WIDTH_W(WIDTH_W))
		sigm_inst_i(.x(sum_mult_i[j]),.f(f_mid[j]));
	   end
  endgenerate 
  ////////////////////////////////////////////////////////////////
  genvar k,m;
  
  generate  
    for (k=0;k<LENGHT_O;k = k+1) begin:loop_k
	   for (m=0;m<LENGHT ;m = m+1)
		  begin:loop_m
		    wire [WIDTH_S+WIDTH_W-1:0] mult_o;//outmult
		    if(m == 0)
		        assign loop_m[m].mult_o = w_o[m]*f_mid[m];
			 else if (m == LENGHT-1)
		        assign sum_mult_o[k] = w_o[m]*f_mid[m]+loop_m[m-1].mult_o;
			 else 
			     assign loop_m[m].mult_o = w_o[m]*f_mid[m]+loop_m[m-1].mult_o;
		  end 
		end  
  endgenerate  
  
  genvar l;
  
  generate 
    for (l=0;l<LENGHT_O;l=l+1) begin:loop_l
	   sigmoid #(.WIDTH_S(WIDTH_S),.WIDTH_W(WIDTH_W+WIDTH_S+LENGHT_O))
		sigm_inst_o(.x(sum_mult_o[l]),.f(f_out[l]));
	   end
  endgenerate 
  //////////////////////////////
  
  
  assign out1 = f_out[0];
  assign out2 = f_out[1];
  
  
endmodule  
