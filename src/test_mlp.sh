#bin/bash!

make clean
make mlp
vsim -c -do mlp_tb.do