`timescale 1ns / 1ps

module vec_elem_sum_tb;

  parameter int VECTOR_LEN = 4;
  parameter CLK_PERIOD = 20;  // Clock period for 50 MHz in nanoseconds 

  // initalize interface and device 
  vec_to_scalar #(.VECTOR_LEN(VECTOR_LEN)) vintf ();
  vec_elem_sum dut (.intf(vintf.DUT));

  // intialize vars
  integer   i = 0;
  shortreal test_in[] = {1, 1, 1, 1};

  // generate clk
  always #(CLK_PERIOD / 2) vintf.clk = ~vintf.clk;


  initial begin
    // restart clock and device
    vintf.clk = 0;
    vintf.rst = 1;
    #(CLK_PERIOD * 2) vintf.rst = 0;

    for (i = 0; i < VECTOR_LEN; i++) begin
      vintf.vec[i] <= $shortrealtobits(test_in[i]);
    end

    // enable and wait for result
    vintf.enable <= 1;
    @(posedge vintf.done);

    // #500; 

    assert ($bitstoshortreal(vintf.result) == 4) $display("PASSED");
    else $display("FAILED: %f != %f", $bitstoshortreal(vintf.result), 4);

    $finish;
  end


endmodule
