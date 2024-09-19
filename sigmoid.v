module sigmoid #(parameter
  //WIDTH = 32,
  WIDTH_W = 9,
  WIDTH_S = 10  
)
(

  input [WIDTH_W-1:0]x,
  output [WIDTH_S-1:0]f
);
  reg [WIDTH_S-1:0]sigm[0:999];
  
  initial 
    begin
	   $readmemh("snum.txt",sigm);
    end
	
	assign f=sigm[x];
   
  





endmodule 