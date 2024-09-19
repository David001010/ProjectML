module midlayer #(parameter LENGHT_I = 32,
                   parameter LENGHT_O = 8,
                   parameter WIDTH_W = 9,
                   parameter WIDTH_S = 10,
                   parameter WIDTH_O = 7,
                   parameter WIDTH_SM = 8)
                 (
                  input                   logic            clk,
                  input [WIDTH_W-1:0]     w_i,
                  input [LENGHT_I-1:0]    in,
                  output [WIDTH_O-1:0]    out
                 );

  logic [WIDTH_W-1:0] w[0:LENGHT_I*LENGHT_O-1];
  logic [WIDTH_SM-1:0] sum_mult[LENGHT_O-1:0];
  logic [WIDTH_O-1:0] f_out[LENGHT_O-1:0];

  genvar k, m, l;

  generate
    for (k = 0; k < LENGHT_O; k = k + 1) begin : loop_k
      for (m = 0; m < LENGHT_I; m = m + 1) begin : loop_m
        wire [WIDTH_S+WIDTH_W-1:0] mult;
        if (m == 0) begin
          assign loop_m[m].mult = w[m]*in[m];
        end
        else if (m == LENGHT_I-1) begin
          assign sum_mult[k] = w[m]*in[m] + loop_m[m-1].mult;
        end
        else begin
          assign loop_m[m].mult = w[m]*in[m] + loop_m[m-1].mult;
        end
      end
    end
  endgenerate

  generate
    for (l = 0; l < LENGHT_O; l = l + 1) begin : loop_l
      sigmoid #(.WIDTH_S(WIDTH_S), .WIDTH_W(WIDTH_W+WIDTH_S+LENGHT_O))
               sigm_inst_o(.x(sum_mult[l]), .f(f_out[l]));
    end
  endgenerate

  // Output assignment
  always_ff @(posedge clk)
    out <= f_out;

endmodule
