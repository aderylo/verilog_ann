#bin/bash!

make clean
make layers
vsim -c -do layers/linear_tb.do