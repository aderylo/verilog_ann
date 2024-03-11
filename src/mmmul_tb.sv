`timescale 1ns / 1ps

module mmmul_tb;

  parameter int ROWS1 = 4;
  parameter int COLS1 = 4;
  parameter int ROWS2 = 4;
  parameter int COLS2 = 4;
  parameter int CLK_PERIOD = 20;  // Clock period for 50 MHz in nanoseconds 

  // initalize interface and device
  matrix_matrix_to_matrix_if #(
      .ROWS1(ROWS1),
      .COLS1(COLS1),
      .ROWS2(ROWS2),
      .COLS2(COLS2)
  ) tintf ();
  mmmul dut (.intf(tintf));

  // intialize vars
  integer r = 0, c = 0;
  shortreal matrix1[ROWS1][COLS1] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  shortreal matrix2[ROWS2][COLS2] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  shortreal grandtruth[ROWS1][COLS2] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  shortreal test_out[ROWS1][COLS2];
  bit good = 1;

  // generate clk
  always #(CLK_PERIOD / 2) tintf.clk = ~tintf.clk;

  initial begin
    // restart clock and device
    tintf.clk = 0;
    tintf.rst = 1;

    // initalize first matrix
    for (r = 0; r < ROWS1; r++) begin
      for (c = 0; c < COLS1; c++) begin
        tintf.matrix1[r][c] = $shortrealtobits(matrix1[r][c]);
      end
    end


    // initalize second matrix
    for (r = 0; r < ROWS2; r++) begin
      for (c = 0; c < COLS2; c++) begin
        tintf.matrix2[r][c] = $shortrealtobits(matrix2[r][c]);
      end
    end


    #(CLK_PERIOD * 2) tintf.rst = 0;

    @(posedge tintf.done);

    // collect results
    for (r = 0; r < ROWS1; r++) begin
      for (c = 0; c < COLS2; c++) begin
        test_out[r][c] = $bitstoshortreal(tintf.result[r][c]);
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
