module sigmoid #(parameter
  //WIDTH = 32,
  RANGE = 1000,
  WIDTH_I = $clog2(RANGE),
  WIDTH_O = $clog2(RANGE) 
)
(
  input  [WIDTH_I-1:0]x,
  output [WIDTH_O-1:0]f
);
  reg [WIDTH_O-1:0]sigm[0:RANGE-1];
  
  initial 
    begin
	   $readmemh("snum.txt",sigm);
    end
	
	assign f=sigm[x];
   
  





endmodule 