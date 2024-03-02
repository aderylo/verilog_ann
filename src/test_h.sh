#bin/bash!

make clean
make vec_h_prod
vsim -c -do vector/hadamard_product_tb.do