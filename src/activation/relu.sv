interface activation_function_if #(
    parameter int VECTOR_LEN = 3,
    parameter int COUNT = 1
);

  logic signed [31:0] data_in [COUNT][VECTOR_LEN];
  logic signed [31:0] data_out[COUNT][VECTOR_LEN];

endinterface

module relu (
    activation_function_if intf
);

  always_comb begin
    for (int i = 0; i < intf.COUNT; i++) begin
      for (int j = 0; j < intf.VECTOR_LEN; j++) begin
        // check sign bit if 1 then is negative (IEEE 754)
        if (intf.data_in[i][j][31] == 1) begin
          intf.data_out[i][j] = 0;
        end else begin
          intf.data_out[i][j] = intf.data_in[i][j];
        end
      end
    end
  end

endmodule
