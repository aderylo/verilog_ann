package utils;

  typedef enum logic [1:0] {
    IDLE,
    WAIT,
    READY
  } state;


  function automatic bit fp32VectorEquals(shortreal vec1[], shortreal vec2[]);
    int len = $size(vec1);
    bit same = 1;

    assert ($size(vec1) == $size(vec2))
    else $display("Vector size mismatch");


    for (int i = 0; i < len; i++) begin
      same &= (vec1[i] == vec2[i]);
    end

    return same;
  endfunction

endpackage


package latency;
  localparam integer ADD_FP = 2;
  localparam integer MUL_FP = 2;
endpackage
