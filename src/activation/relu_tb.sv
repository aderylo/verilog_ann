`timescale 1ns / 1ps

module relu_tb;

  parameter int VECTOR_LEN = 4;
  parameter int COUNT = 1;
  parameter int CLK_PERIOD = 20;  // 50 Mhz

  activation_function_if #(
      .VECTOR_LEN(VECTOR_LEN),
      .COUNT(COUNT)
  ) intf ();
  relu relu_dut (.intf(intf));

  // variables for testing
  bit good = 1;
  int i = 0, j = 0;
  shortreal test_in[COUNT][VECTOR_LEN] = '{'{-1.0, 1.0, -2.0, 2.0}};
  shortreal grandtruth[COUNT][VECTOR_LEN] = '{'{0.0, 1.0, 0.0, 2.0}};
  shortreal test_out[COUNT][VECTOR_LEN];

  initial begin
    // load data
    for (i = 0; i < COUNT; i++) begin
      for (j = 0; j < VECTOR_LEN; j++) begin
        intf.data_in[i][j] = $shortrealtobits(test_in[i][j]);
      end
    end

    #(CLK_PERIOD * 1);

    // get data out
    for (i = 0; i < COUNT; i++) begin
      for (j = 0; j < VECTOR_LEN; j++) begin
        test_out[i][j] = $bitstoshortreal(intf.data_out[i][j]);
      end
    end

    // verify
    good = 1;
    for (i = 0; i < COUNT; i++) begin
      for (j = 0; j < VECTOR_LEN; j++) begin
        $display("%f", test_out[i][j]);
        good &= (grandtruth[i][j] == test_out[i][j]);
      end
    end
    assert (good) $display("PASSED");
    else $display("FAILED");

    $finish;
  end


endmodule
