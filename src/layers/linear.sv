interface linear_layer_if #(
    parameter int INPUT_SIZE = 4,
    parameter int COUNT = 1,
    parameter int OUTPUT_SIZE = 4
);

  logic clk;
  logic rst;
  logic enable;
  logic done;
  logic [31:0] data_in[COUNT][INPUT_SIZE];
  logic [31:0] data_out[COUNT][OUTPUT_SIZE];
  logic [31:0] weights[INPUT_SIZE][OUTPUT_SIZE];
  logic [31:0] biases[COUNT][OUTPUT_SIZE];

endinterface

module linear (
    linear_layer_if intf
);

  // following pytroch convenvtion of input x Weights + Biases
  matrix_matrix_to_matrix_if #(
      .ROWS1(1),
      .COLS1(intf.INPUT_SIZE),
      .ROWS2(intf.INPUT_SIZE),
      .COLS2(intf.OUTPUT_SIZE)
  ) mmm_if ();

  mmmul mmmul_instance (.intf(mmm_if));


  assign mmm_if.clk = intf.clk;
  assign mmm_if.matrix1 = intf.data_in;
  assign mmm_if.matrix2 = intf.weights;
  assign mmm_if.rst = intf.rst;

  always_ff @(intf.clk, intf.rst) begin
    if (intf.rst) begin
      // reset logic
      intf.done   <= 0;
      intf.enable <= 0;
    end else begin
      if (intf.enable) mmm_if.enable <= 1;

      if (mmm_if.done) begin
        intf.data_out <= mmm_if.result;
        intf.done <= 1;
      end

    end

  end

endmodule


