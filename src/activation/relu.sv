module relu (
    activation_function_if intf
);

  always_comb begin
    if (intf.in_data > 0) begin
      intf.out_data = intf.in_data;
    end else begin
      intf.out_data = 0;
    end
  end

endmodule
