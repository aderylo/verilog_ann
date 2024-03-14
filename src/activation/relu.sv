interface activation_function_if #(
    parameter int VECTOR_LEN = 3
);

  logic signed [31:0] data_in [VECTOR_LEN];
  logic signed [31:0] data_out[VECTOR_LEN];

endinterface

module relu (
    activation_function_if intf
);

  always_comb begin
    for (int i = 0; i < intf.VECTOR_LEN; i++) begin
      // check sign bit if 1 then is negative (IEEE 754)
      if (intf.data_in[i][31] == 1) begin
        intf.data_out[i] = 0;
      end else begin
        intf.data_out[i] = intf.data_in[i];
      end
    end
  end

endmodule
