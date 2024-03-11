`timescale 1ns / 1ps

module dot_product_tb;

  parameter int VECTOR_LEN = 4;
  parameter int CLK_PERIOD = 20;  // Clock period for 50 MHz in nanoseconds

  // initalize interface and device 
  vec_vec_to_scalar #(.VECTOR_LEN(VECTOR_LEN)) vintf ();
  dot_product dut (.intf(vintf.DUT));

  // intialize vars
  integer   i = 0;
  shortreal test_in1  [] = {1, 1, 1, 1};
  shortreal test_in2  [] = {2, 1, 1, 1};
  shortreal test_out;
  shortreal grandtruth = 5;

  // generate clk
  always #(CLK_PERIOD / 2) vintf.clk = ~vintf.clk;

  initial begin
    // restart clock and device
    vintf.clk = 0;
    vintf.rst = 1;
    for (i = 0; i < VECTOR_LEN; i++) begin
      vintf.vec1[i] <= $shortrealtobits(test_in1[i]);
      vintf.vec2[i] <= $shortrealtobits(test_in2[i]);
    end


    #(CLK_PERIOD * 2) vintf.rst = 0;

    @(posedge vintf.done);

    // collect results
    test_out = $bitstoshortreal(vintf.result);


    assert (test_out == grandtruth) $display("PASSED");
    else $display("FAILED");

    $finish;
  end


endmodule
