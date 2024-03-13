interface two_layer_mlp_if #(
    parameter int INPUT_SIZE = 4,
    parameter int HIDDEN_SIZE = 4,
    parameter int OUTPUT_SIZE = 1,
    parameter int COUNT = 1
);

  logic clk;
  logic rst;
  logic enable;
  logic done;
  logic [31:0] data_in[COUNT][INPUT_SIZE];

  logic [31:0] weights1[INPUT_SIZE][HIDDEN_SIZE];
  logic [31:0] biases1[COUNT][HIDDEN_SIZE];

  logic [31:0] weights2[HIDDEN_SIZE][OUTPUT_SIZE];
  logic [31:0] biases2[COUNT][OUTPUT_SIZE];

  logic [31:0] data_out[COUNT][OUTPUT_SIZE];

endinterface


module mlp (
    two_layer_mlp_if intf
);

  linear_layer_if #(
      .INPUT_SIZE(intf.INPUT_SIZE),
      .OUTPUT_SIZE(intf.HIDDEN_SIZE),
      .COUNT(intf.COUNT)
  ) layer_1_if ();

  linear_layer_if #(
      .INPUT_SIZE(intf.HIDDEN_SIZE),
      .OUTPUT_SIZE(intf.OUTPUT_SIZE),
      .COUNT(intf.COUNT)
  ) layer_2_if ();

  linear layer_1 (.intf(layer_1_if));
  linear layer_2 (.intf(layer_2_if));

  assign layer_1_if.clk = intf.clk;
  assign layer_1_if.rst = intf.rst;

  assign layer_2_if.clk = intf.clk;
  assign layer_2_if.rst = intf.rst;

  assign layer_1_if.data_in = intf.data_in;
  assign layer_2_if.data_in = layer_1_if.data_out;
  assign intf.data_out = layer_2_if.data_out;



  always_ff @(intf.clk, intf.rst) begin
    if (intf.rst) begin
      // rest is handled by continous assigments
      intf.done   <= 0;
      intf.enable <= 0;
    end else begin

      if (intf.enable) begin
        layer_1_if.enable <= 1;
      end

      if (layer_1_if.done) begin
        layer_2_if.enable <= 1;
      end

      if (layer_2_if.done) begin
        intf.done <= 1;
      end

    end
  end


endmodule


// layer_1_if.data_in <= intf.data_in;
// layer_1_if.enable  <= 1;

// if (layer_1_if.done) begin
//   layer_2_if.data_in <= layer_1_if.data_out;
//   layer_2_if.enable  <= 1;
// end

// if (layer_2_if.done) begin
//   intf.data_out <= intf.data_out;
//   intf.done <= 1;
// end
