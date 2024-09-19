module manager #(parameter 
	N_LAYER_W =1,
	WIDTH = 32,
	WIDTH_W = 9, 
	LENGHT_I = 32,
	LENGHT_MID = 8,
	LENGHT_O = 2,
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
	output [WIDTH-1:0] out_d,
	output ready,down,//manager is ready to input
	//nw in 
	
	//nw out
   output wr,
	output logic [MAX_REG_W-2:0] [WIDTH_W-1:0] w_o

  );
//  logic [MAX_REG_W:0 ] [WIDTH-1:0]          w_reg;
//  logic [MAX_REG_I:MAX_REG_W+1] [WIDTH-1:0] i_reg;
//  logic [MAX_REG_O:MAX_REG_I+1] [WIDTH-1:0] o_reg;
  logic  [MAX_REG_O-1:0] [WIDTH-1:0] buf_reg;
  logic addr_range_w, addr_range_i,non_equal; 
  ////обьявление ргеистров для входных данных (нейроны )и вызодныз(неироны вызода ) 
  
  enum int unsigned { 
							Reset_St   = 0,
							Wait_St    = 1, 
							Write_W_St = 2, 
							Write_I_St = 3,
						   Read_O_St  = 4,
					      Read_W_St  = 5,
							Load_St    = 6,
							Work_St    = 7,
						   Cmplt_St   = 8	} 
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
							if ( &buf_reg[MAX_REG_W])
						     begin
							    next_state = Load_St;
							  end  
							else 
							  begin
							    next_state = Write_W_St;
							  end  
		            end 
						
	    Write_I_St:begin 
							if (&buf_reg[MAX_REG_I])
						     begin
							    next_state = Work_St;
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
						
	    Load_St:begin 
					  next_state = Wait_St;		
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
		            end 
		  
		  Wait_St:	begin 
		  
		               wr <= 0;
							
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
						
	    Load_St:begin 
					  wr <= 1 ;
					  w_o <= buf_reg[MAX_REG_W-2:0];
					  
		         end 
						
	    Work_St:begin 
							if (non_equal)
						     begin
							    
							  end  
							else 
							  begin
							    
							  end  
		            end 
						
	    Cmplt_St:begin 
							if (!write && read && !ready && down)
						     begin
							    
							  end  
							else 
							  begin
							    
							  end  
		            end
				
				
			 endcase
			 
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
				
			 else if (!write && read && !ready && down)// state of read 
		      begin
			     	if (1)
				    begin
					    
						
					 end
				end 
				
			 else  // state of waiting 
		      begin
			     	
				end 
			 

		
		  end 
   
	end 
  assign addr_range_i = address > LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O && address <= LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O+LENGHT_I;
  assign addr_range_w = address <= LENGHT_I*LENGHT_MID+LENGHT_MID*LENGHT_O;
endmodule   
  
  
  
  
  
  
  
  
  
  
  
  
  
  