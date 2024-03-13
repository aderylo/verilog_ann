`timescale 1ns / 1ps

module mlp_tb;

  parameter int INPUT_SIZE = 4;
  parameter int HIDDEN_SIZE = 2;
  parameter int OUTPUT_SIZE = 1;
  parameter int COUNT = 1;
  parameter int CLK_PERIOD = 20;  // Clock period in ns

  two_layer_mlp_if #(
      .INPUT_SIZE(INPUT_SIZE),
      .HIDDEN_SIZE(HIDDEN_SIZE),
      .OUTPUT_SIZE(OUTPUT_SIZE),
      .COUNT(COUNT)
  ) mlp_intf ();

  mlp mlp_dut (.intf(mlp_intf));

  // variables
  int r = 0, c = 0;
  bit good = 1;
  shortreal data_in[COUNT][INPUT_SIZE] = '{'{1.0, 2.0, 3.0, 4.0}};
  shortreal weights1[INPUT_SIZE][HIDDEN_SIZE] = '{
      '{0.5, 0.5},
      '{0.5, 0.5},
      '{0.5, 0.5},
      '{0.5, 0.5}
  };
  shortreal weights2[HIDDEN_SIZE][OUTPUT_SIZE] = '{'{0.5}, '{0.5}};
  shortreal grandtruth[COUNT][OUTPUT_SIZE] = '{'{5.0}};
  shortreal test_out[COUNT][OUTPUT_SIZE];



  initial begin
    mlp_intf.clk = 0;
    forever #(CLK_PERIOD / 2) mlp_intf.clk = ~mlp_intf.clk;
  end


  initial begin
    mlp_intf.rst = 1;
    mlp_intf.enable = 0;


    // initalize weights for first layer
    for (r = 0; r < INPUT_SIZE; r++) begin
      for (c = 0; c < HIDDEN_SIZE; c++) begin
        mlp_intf.weights1[r][c] = $shortrealtobits(weights1[r][c]);
      end
    end

    // initalize weights for second layer
    for (r = 0; r < HIDDEN_SIZE; r++) begin
      for (c = 0; c < OUTPUT_SIZE; c++) begin
        mlp_intf.weights2[r][c] = $shortrealtobits(weights2[r][c]);
      end
    end

    // feed input data
    for (r = 0; r < COUNT; r++) begin
      for (c = 0; c < INPUT_SIZE; c++) begin
        mlp_intf.data_in[r][c] = $shortrealtobits(data_in[r][c]);
      end
    end

    // wait for data to be loaded and toggle off reset
    #(CLK_PERIOD * 2) mlp_intf.rst = 0;
    mlp_intf.enable <= 1;

    // wait for the results
    @(posedge mlp_intf.done);

    // read the results
    for (r = 0; r < COUNT; r++) begin
      for (c = 0; c < OUTPUT_SIZE; c++) begin
        test_out[r][c] = $bitstoshortreal(mlp_intf.data_out[r][c]);
      end
    end


    // print and check
    good = 1;
    for (r = 0; r < COUNT; r++) begin
      for (c = 0; c < OUTPUT_SIZE; c++) begin
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
