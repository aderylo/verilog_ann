interface matrix_matrix_to_matrix_if #(
    parameter int ROWS1 = 4,
    parameter int COLS1 = 4,
    parameter int ROWS2 = 4,
    parameter int COLS2 = 4
);

  logic clk;
  logic rst;
  logic enable;
  logic [31:0] matrix1[ROWS1][COLS1];
  logic [31:0] matrix2[ROWS2][COLS2];
  logic [31:0] result[ROWS1][COLS2];
  logic done;

endinterface  //matrix_matrix_to_matrix_if


module mmmul (
    matrix_matrix_to_matrix_if intf
);

  int r_idx = 0, c_idx = 0, i = 0;
  vec_vec_to_scalar #(.VECTOR_LEN(intf.COLS1)) d_intf ();
  dot_product dot_product_instance (.intf(d_intf.DUT));

  assign d_intf.clk  = intf.clk;
  assign d_intf.vec1 = intf.matrix1[r_idx];
  // assign d_intf.vec2 = intf.matrix2[c_idx];

  always_ff @(intf.clk, intf.rst) begin
    if (intf.rst) begin
      d_intf.rst <= 1;
      r_idx <= 0;
      c_idx <= 0;
      intf.done <= 0;
      intf.enable <= 0;
    end else if (d_intf.done && !intf.done && intf.enable) begin
      // get result and schedule next dot product
      // if all are done finish matrix multiplication
      intf.result[r_idx][c_idx] <= d_intf.result;
      d_intf.rst <= 1;

      if (r_idx + 1 < intf.ROWS1) begin
        r_idx <= r_idx + 1;
      end else if (c_idx + 1 < intf.COLS2) begin
        c_idx <= c_idx + 1;
        r_idx <= 0;
      end else begin
        intf.done <= 1;
      end
    end else begin
      // wait for dot product calculation
      d_intf.rst <= 0;

      /* since there is no slicing in system verilog
        we have to do it by hand in order to get column
        from second matrix for dot product calculation */
      for (i = 0; i < intf.ROWS2; i++) begin
        d_intf.vec2[i] <= intf.matrix2[i][c_idx];
      end
    end
  end

endmodule
