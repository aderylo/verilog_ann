interface matrix_matrix_to_matrix #(
    parameter ROWS1 = 4,
    parameter COLS1 = 4,
    parameter ROWS2 = 4,
    parameter COLS2 = 4
);

  logic clk;
  logic rst;
  logic enable;
  logic [31:0] matrix1[ROWS1-1:0][COLS1-1:0];
  logic [31:0] matrix2[ROWS2-1:0][COLS2-1:0];
  logic [31:0] result[ROWS1-1:0][COLS2-1:0];
  logic done;



endinterface  //matrix_matrix_to_matrix


module mmmul (
    matrix_matrix_to_matrix intf
);

  vec_vec_to_scalar #(.VECTOR_LEN(intf.COLS1)) d_intf ();
  dot_product dot_product_instance (.intf(d_intf.DUT));
  assign d_intf.clk = intf.clk;

  integer r_idx = 0, c_idx = 0;

  always_ff @(intf.clk, intf.rst) begin
    if (intf.rst) begin
      d_intf.rst <= 1;
    end else begin
      d_intf.rst <= 0;

      if (d_intf.done) begin
        $display("RES : %h", d_intf.result);
        intf.result[r_idx][c_idx] <= d_intf.result;

        if (r_idx + 1 < intf.ROWS1) r_idx <= r_idx + 1;
        else if (c_idx + 1 < intf.COLS2) begin
          r_idx <= 0;
          c_idx <= c_idx + 1;
        end else begin
          intf.done <= 1;
        end

        d_intf.rst <= 1;
      end else begin
        d_intf.rst <= 0;
      end
    end

  end


endmodule
