interface vec_vec_to_vec #(
    parameter VECTOR_LEN = 4
);
  logic clk;
  logic rst;
  logic [31:0] vec1[VECTOR_LEN-1:0];
  logic [31:0] vec2[VECTOR_LEN-1:0];
  logic [31:0] result[VECTOR_LEN-1:0];
  logic done;

  modport DUT(input clk, rst, vec1, vec2, output result, done);
endinterface  //vec_vec_to_vec

module vec_hadamard_product (
    vec_vec_to_vec intf
);

  logic [31:0] mul_elem1, mul_elem2, mul_result;

  utils::state mul_state = utils::IDLE;
  integer idx = 0, ticker = 0, old = idx;

  mul_fp mul_fp_instance (
      .clk(intf.clk),
      .areset(intf.rst),
      .a(mul_elem1),
      .b(mul_elem2),
      .q(mul_result)
  );


  always_ff @(posedge intf.clk) begin
    if (intf.rst) begin
      idx <= 0;
      mul_state <= utils::IDLE;
      ticker <= 0;

      intf.done <= 0;
      for (int i = 0; i < intf.VECTOR_LEN; i++) begin
        intf.result[i] <= 32'h00000000;
      end
    end else begin
      case (mul_state)
        utils::IDLE: begin
          if (idx < intf.VECTOR_LEN) begin
            mul_elem1 <= intf.vec1[idx];
            mul_elem2 <= intf.vec2[idx];
            mul_state <= utils::WAIT;
            ticker <= 0;
          end else begin
            intf.done <= 1;
            idx <= 0;
          end
        end

        utils::WAIT: begin
          // + 1 to account for transition betwen WAIT->READY  
          if (ticker + 1 == latency::MUL_FP) begin
            mul_state <= utils::READY;
          end else begin
            ticker <= ticker + 1;
          end
        end

        utils::READY: begin
          intf.result[idx] <= mul_result;
          idx <= idx + 1;
          mul_state = utils::IDLE;
        end

      endcase
    end
  end


endmodule
