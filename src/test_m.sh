#bin/bash!

make clean
make mmmul
vsim -c -do mmmul_tb.do