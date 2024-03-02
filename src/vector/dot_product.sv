
interface vec_vec_to_scalar #(
    parameter VECTOR_LEN = 4
);
  logic clk;
  logic rst;
  logic [31:0] vec1[VECTOR_LEN-1:0];
  logic [31:0] vec2[VECTOR_LEN-1:0];
  logic [31:0] result;
  logic done;

  modport DUT(input clk, rst, vec1, vec2, output result, done);

endinterface  // vec_vec_to_scalar


module dot_product (
    vec_vec_to_scalar intf
);

  logic [31:0] h_result[intf.VECTOR_LEN-1:0];
  logic h_done = 0, s_done = 0, s_enable = 0;

  vec_vec_to_vec #(.VECTOR_LEN(intf.VECTOR_LEN)) h_intf ();

  assign h_intf.clk  = intf.clk;
  assign h_intf.rst  = intf.rst;
  assign h_intf.vec1 = intf.vec1;
  assign h_intf.vec2 = intf.vec2;

  vec_to_scalar #(.VECTOR_LEN(intf.VECTOR_LEN)) s_intf ();

  assign s_intf.clk  = intf.clk;
  assign s_intf.rst  = intf.rst;
  assign s_intf.vec  = h_intf.result;
  assign intf.result = s_intf.result;
  assign intf.done   = s_intf.done;

  vec_hadamard_product h_product_instance (.intf(h_intf.DUT));
  vec_elem_sum sum_instance (.intf(s_intf.DUT));

  always_ff @(intf.clk) begin
    if (h_intf.done && ~s_intf.done) begin
      s_intf.enable <= 1;
    end
  end

endmodule


