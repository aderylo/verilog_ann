`timescale 1ns / 1ps

module vec_hadamard_product_tb;

  parameter int VECTOR_LEN = 4;
  parameter CLK_PERIOD = 20;  // Clock period for 50 MHz in nanoseconds 

  // initalize interface and device 
  vec_vec_to_vec #(.VECTOR_LEN(VECTOR_LEN)) vintf ();
  vec_hadamard_product dut (.intf(vintf.DUT));

  // intialize vars
  integer   i = 0;
  shortreal test_in1  [] = {1, 1, 1, 1};
  shortreal test_in2  [] = {2, 1, 1, 1};
  shortreal test_out  [] = new[VECTOR_LEN];
  shortreal grandtruth[] = {2, 1, 1, 1};

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
    for (i = 0; i < VECTOR_LEN; i++) begin
      test_out[i] = $bitstoshortreal(vintf.result[i]);
    end


    assert (utils::fp32VectorEquals(test_out, grandtruth)) $display("PASSED");
    else $display("FAILED");

    $finish;
  end


endmodule
