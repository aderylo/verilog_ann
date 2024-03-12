`timescale 1ns / 1ps

module linear_tb;
  parameter int INPUT_SIZE = 4;
  parameter int OUTPUT_SIZE = 4;
  parameter int COUNT = 1;
  parameter int CLK_PERIOD = 20;  // Clock period for 50 MHz in nanoseconds


  linear_layer_if #(
      .INPUT_SIZE(INPUT_SIZE),
      .OUTPUT_SIZE(OUTPUT_SIZE),
      .COUNT(COUNT)
  ) intf ();

  linear dut (.intf(intf));

  // variables
  shortreal data_in[COUNT][INPUT_SIZE] = '{'{1.0, 2.0, 3.0, 4.0}};
  shortreal weights[INPUT_SIZE][OUTPUT_SIZE] = '{
      '{0.5, -0.5, 0.5, -0.5},
      '{0.5, -0.5, 0.5, -0.5},
      '{0.5, -0.5, 0.5, -0.5},
      '{0.5, -0.5, 0.5, -0.5}
  };
  shortreal biases[OUTPUT_SIZE] = '{0.0, 0.0, 0.0, 0.0};
  shortreal grandtruth[COUNT][OUTPUT_SIZE] = '{'{5.0, -5.0, 5.0, -5.0}};
  shortreal test_out[COUNT][OUTPUT_SIZE];
  bit good;


  // generate clk
  always #(CLK_PERIOD / 2) intf.clk = ~intf.clk;



  // testing logic
  initial begin
    // restart clock and device
    intf.clk = 0;
    intf.rst = 1;

    // initalize first input data
    for (r = 0; r < COUNT; r++) begin
      for (c = 0; c < INPUT_SIZE; c++) begin
        intf.data_in[r][c] = $shortrealtobits(data_in[r][c]);
      end
    end

    // initalize weights
    for (r = 0; r < INPUT_SIZE; r++) begin
      for (c = 0; c < OUTPUT_SIZE; c++) begin
        intf.weights[r][c] = $shortrealtobits(weights[r][c]);
      end
    end

    // initalize bias
    for (r = 0; r < COUNT; r++) begin
      for (c = 0; c < OUTPUT_SIZE; c++) begin
        intf.bias[r][c] = $shortrealtobits(bias[r][c]);
      end
    end

    // wait for data to be loaded and toggle off reset
    #(CLK_PERIOD * 2) tintf.rst = 0;

    @(posedge tintf.done);

    for (r = 0; r < COUNT; r++) begin
      for (c = 0; c < OUTPUT_SIZE; c++) begin
        test_out[r][c] = $bitstoshortreal(intf.data_out[r][c]);
      end
    end


    // print and check
    good = 1;
    for (r = 0; r < ROWS1; r++) begin
      for (c = 0; c < COLS2; c++) begin
        $display("%f", test_out[r][c]);
        good &= (grandtruth[r][c] == test_out[r][c]);
      end
      $display("\n");
    end


    assert (good) $display("PASSED");
    else $display("FAILED");

    $finish;
  end


endmodule
