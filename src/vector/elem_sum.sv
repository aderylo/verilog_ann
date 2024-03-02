interface vec_to_scalar #(
    parameter VECTOR_LEN = 4
);
  logic clk;
  logic rst;
  logic enable;
  logic [31:0] vec[VECTOR_LEN-1:0];
  logic [31:0] result;
  logic done;

  modport DUT(input clk, rst, enable, vec, output result, done);

endinterface  //vec_to_scalar

module vec_elem_sum (
    vec_to_scalar intf
);

  logic [31:0] res, acc, elem;
  utils::state add_fp_state;
  integer i = 0, ticker = 0;

  add_fp add_fp_inst (
      .clk(intf.clk),
      .areset(intf.rst),
      .a(acc),
      .b(elem),
      .q(res)
  );


  always_ff @(posedge intf.clk, posedge intf.rst) begin
    if (intf.rst) begin
      intf.done <= 0;
      intf.enable <= 0;
      intf.result <= 0;

      i <= 0;
      acc <= 0;
      ticker <= 0;
      add_fp_state <= utils::IDLE;
    end else if (~intf.enable) begin
      intf.done <= 0;
    end else begin

      case (add_fp_state)
        
        utils::IDLE: begin
          elem <= intf.vec[i];
          ticker <= 0;
          add_fp_state <= utils::WAIT;
        end

        utils::WAIT: begin
          if (ticker == latency::ADD_FP) begin
            add_fp_state <= utils::READY;
          end else begin
            ticker <= ticker + 1;
          end
        end

        utils::READY: begin
          // handle sum complition
          if (i + 1 == intf.VECTOR_LEN) begin
            i <= 0;
            acc <= 0;
            intf.done <= 1;
            intf.result <= res;
          end else begin
            i   <= i + 1;
            acc <= res;
          end

          add_fp_state <= utils::IDLE;
        end
      endcase
    end
  end

endmodule
