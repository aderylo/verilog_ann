`timescale 1ns / 1ps

module relu_tb;

  parameter int VECTOR_LEN = 4;
  parameter int CLK_PERIOD = 20;  // 50 Mhz

  activation_function_if #(.VECTOR_LEN(VECTOR_LEN)) intf ();
  relu relu_dut (.intf(intf));

  // variables for testing
  bit good = 1;
  int i = 0;
  shortreal test_in[VECTOR_LEN] = '{-1.0, 1.0, -2.0, 2.0};
  shortreal grandtruth[VECTOR_LEN] = '{0.0, 1.0, 0.0, 2.0};
  shortreal test_out[VECTOR_LEN];

  initial begin
    // load data
    for (i = 0; i < VECTOR_LEN; i++) begin
      intf.data_in[i] = $shortrealtobits(test_in[i]);
    end

    #(CLK_PERIOD * 6);

    // get data out
    for (i = 0; i < VECTOR_LEN; i++) begin
      test_out[i] = $bitstoshortreal(intf.data_out[i]);
    end

    // verify
    good = 1;
    for (i = 0; i < VECTOR_LEN; i++) begin
      $display("%f", test_out[i]);
      good &= (grandtruth[i] == test_out[i]);
    end

    assert (good) $display("PASSED");
    else $display("FAILED");

    $finish;
  end


endmodule
