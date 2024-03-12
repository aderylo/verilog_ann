interface activation_function_if #(
    parameter int DATA_WIDTH = 32
);

  logic signed [DATA_WIDTH-1:0] in_data;
  logic signed [DATA_WIDTH-1:0] out_data;

endinterface
