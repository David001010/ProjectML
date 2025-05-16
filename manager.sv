module manager #(parameter 
	N_LAYER_W =1,
	WIDTH= 32,
   RANGE_SIGM = 1000,
	WIDTH_W = 9,
   //neiron in 
   LENGHT_I = 32,
   WIDTH_I = 1,
   //neiron mid 
   LENGHT_MID = 8,
   WIDTH_MID = $clog2(RANGE_SIGM),
   //neiron out
   LENGHT_O = 2,
   WIDTH_O = $clog2(RANGE_SIGM),
	WIDTH_ADDR = $clog2(LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+LENGHT_I+LENGHT_O+3),
	MAX_REG_W = LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+1,
	MAX_REG_I = MAX_REG_W + LENGHT_I+1,
	MAX_REG_O = MAX_REG_I + LENGHT_O+1 //309
	
	
	
	


)
  (
	input clk,reset,
	//cpu in 
	input read,write,	
	input [WIDTH-1:0] in_d, 
   input [WIDTH_ADDR-1:0] address,
  //cpu out 
	output logic [WIDTH-1:0] out_d,
	output logic ready,down,//manager is ready to inputsad
	//nw in 
	input [LENGHT_O-1:0] [WIDTH_O-1:0] i_in,
	//nw out
   output logic wr,
	output logic [LENGHT_I-1:0] [WIDTH_I-1:0] i_o,
	output logic [MAX_REG_W-2:0] [WIDTH_W-1:0] w_o //w_out

  );
//  logic [MAX_REG_W:0 ] [WIDTH-1:0]          w_reg;
//  logic [MAX_REG_I:MAX_REG_W+1] [WIDTH-1:0] i_reg;
//  logic [MAX_REG_O:MAX_REG_I+1] [WIDTH-1:0] o_reg;
  logic  [MAX_REG_O-1:0] [WIDTH-1:0] buf_reg;
  logic  addr_range_w, addr_range_i,non_equal;
  logic  [LENGHT_O-1:0] [WIDTH-1:0]prev_reg; 
  logic  [1:0] [WIDTH-1:0] tmp; 
  
  ////обьявление ргеистров для входных данных (нейроны )и вызодныз(неироны вызода ) 
  
  enum int unsigned { 
							Reset_St   = 0,
							Wait_St    = 1, 
							Write_W_St = 2, 
							Write_I_St = 3,
						   Read_O_St  = 4,
					      Read_W_St  = 5,
							Load_I_St  = 6,
							Load_W_St  = 7,
							Work_St    = 8,
						   Cmplt_St   = 9	} 
							state, next_state;
	////reset 
  always @(posedge clk or posedge reset)
    begin
	   if (reset)
        begin
		    state <= Reset_St;
		  end 
		else   
		  begin
		    state <= next_state;	 
		  end 
	 end 
	 
  always @(*)
    begin
	   case (state)
		  Reset_St: begin 
							if (reset)
							  begin
							    next_state = Reset_St;
							  end  
							else 
							  begin
							    next_state = Wait_St;
							  end  
		            end 
		  
		  Wait_St:	begin 
							if (write && !read && ready && !down && addr_range_w )
							  begin
							    next_state = Write_W_St;
							  end  
							else if (write && !read && ready && !down && addr_range_i )
							  begin
							    next_state = Write_I_St;
							  end 
							else 
							  begin
							    next_state = Wait_St;   	
							  end 	
		            end 
						
	    Write_W_St:begin 
							if ( &buf_reg[MAX_REG_W - 1])
						     begin
							    next_state = Load_W_St;
							  end  
							  
							else 
							  begin
							    next_state = Write_W_St;
							  end  
		            end 
						
	    Write_I_St:begin 
							if (&buf_reg[MAX_REG_I-1])
						     begin
							    next_state = Load_I_St;
							  end  
							else 
							  begin
							    next_state = Write_I_St;
							  end  
		            end 

	    Read_O_St:begin 
							if (&buf_reg[MAX_REG_O-1])
						     begin
							    next_state = Wait_St;
							  end  
							else 
							  begin
							    next_state = Read_O_St;
							  end  
		            end
						
	    Read_W_St:begin 
							if (reset)
						     begin
							    next_state = Write_W_St;
							  end  
							else 
							  begin
							    next_state = Read_W_St;
							  end  
		            end 
						
	    Load_W_St:begin 
					  next_state = Wait_St;		
		         end 
					
					
		 Load_I_St:begin 
					  next_state = Work_St;		
		         end 
						
	    Work_St:begin 
							if (non_equal)
						     begin
							    next_state = Cmplt_St;
							  end  
							else 
							  begin
							    next_state = Work_St;
							  end  
		            end 
						
	    Cmplt_St:begin 
							if (!write && read && !ready && down)
						     begin
							    next_state = Read_O_St;
							  end  
							else 
							  begin
							    next_state = Cmplt_St;
							  end  
		            end 

						
		 			
			

		  
	   endcase	
	 end  
  
  always @(posedge clk or posedge reset)
	begin 
	   if(reset)
		  begin
		    buf_reg <= 0;
		  end 
		else
		  begin
		    case (state)
			 
		  Reset_St: begin 
						  buf_reg <= 0;
						  ready <= 0;
						  down <= 0;
						  prev_reg <= 0;
						  wr <= 0;
						  i_o <= 0;
						  w_o <= 0;
						  out_d <=0;
		            end 
		  
		  Wait_St:	begin 
		  
		               wr <= 0;
							ready <= 1;
							down <=0;
							
							if(write && !read && ready && !down )// state of  write 
								begin
									if (addr_range_w)//reg width 
										begin
											buf_reg[address] <= in_d; 
										end
									else if (addr_range_i)// reg neiron 
										begin
											buf_reg[address] <= in_d;
										end 
									else 
										begin 
											buf_reg <= buf_reg;  
										end 		
					       
								end 
							else 
							   begin 
							     ready <= 1;
								  down <= 0;
							   end
		            end 
						
	    Write_W_St:begin 
							if(write && !read && ready && !down && addr_range_w )// state of  write 
								begin		
								 buf_reg[address] <= in_d; 
								end  
							 else 
							   begin
							     	buf_reg <= buf_reg;
								end 
		            end 
						
	    Write_I_St:begin 
							if(write && !read && ready && !down && addr_range_i )// state of  write 
								begin		
								 buf_reg[address] <= in_d;
								end  
							 else 
							   begin
							     	buf_reg <= buf_reg;
								end 
		            end 

	    Read_O_St:begin 
							if (&buf_reg[MAX_REG_O-1])
						     begin
							    
							  end  
							else 
							  begin
							    
							  end  
		            end
						
	    Read_W_St:begin 
							if (reset)
						     begin
							    
							  end  
							else 
							  begin
							    
							  end  
		            end 
						
	  Load_W_St:begin 
					  wr <= 1 ;
					  for (int i = 0;i <= LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O-1;i = i+1)
							begin
								w_o[i] <= buf_reg[i][WIDTH_W-1:0];
							end
					  ready <= 0;
					  
		         end 
					
					
	  Load_I_St:begin
	              for (int i = 0;i <= LENGHT_I-1;i = i+1)
								begin
									i_o[i] <= buf_reg[i+LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+1][WIDTH_I-1:0];
									
								end
								
					  //i_o <= buf_reg[MAX_REG_I-2:MAX_REG_W];
					  buf_reg[MAX_REG_O-2:MAX_REG_I] <= i_in;
					  ready <= 0;	
					  tmp <= buf_reg[MAX_REG_I-2:MAX_REG_W];
		         end
						
	  Work_St:begin 
							if (non_equal)
						     begin
							    buf_reg[MAX_REG_O-1] <= {WIDTH{1'b1}};
								 down <= 1;
							  end  
							else 
							  begin
							    prev_reg <= buf_reg[MAX_REG_O-2:MAX_REG_I]; 
							    buf_reg[MAX_REG_O-2:MAX_REG_I] <= i_in;
								 
							  end  
		            end 
						
	    Cmplt_St:begin 
		             prev_reg <= buf_reg[MAX_REG_O-2:MAX_REG_I];
							if (!write && read && !ready && down)
						     begin
							    out_d <= buf_reg[MAX_REG_O-2:MAX_REG_I];
							  end  
							else 
							  begin
							    out_d <= 0;
							  end  
		            end
				
				
			 endcase
			 
//		    if(write && !read && ready && !down )// state of  write 
//			   begin
//				  if (addr_range_w)//reg width 
//				    begin
//					   buf_reg[address] <= in_d; 
//					 end
//				  else if (addr_range_i)// reg neiron 
//				    begin
//					    buf_reg[address] <= in_d;
//					 end 
//				  else 
//				    begin 
//					   buf_reg <= buf_reg;
//					 end 		
//					  
//				end 
//				
//			 else if (!write && read && !ready && down)// state of read 
//		      begin
//			     	if (1)
//				    begin
//					    
//						
//					 end
//				end 
//				
//			 else  // state of waiting 
//		      begin
//			     	
//				end 
			 

		
		  end 
   
	end 
  assign addr_range_i = address > LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O && address <= LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+1+LENGHT_I + 1;
  assign addr_range_w = address <= LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O;
  assign non_equal =  (buf_reg[MAX_REG_O-2:MAX_REG_I] != prev_reg);
  

  
  
endmodule   
  
  
  
  
  
  
  
  
  
  
  
  
  
  