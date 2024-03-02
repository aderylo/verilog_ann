# SystemVerilog ANN Project

## Prerequisites

Before you can run or modify this SystemVerilog project, you need to have the following software and Intellectual Property (IP) components installed and configured on your system:

### Software Requirements

- **Intel ModelSim**:
    - Used for simulation of SystemVerilog files. Ensure you have `vlog`, `vcom`, and `vsim` commands available in your environment path to compile and simulate your designs.
    - [Installation Guide](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html)

- **Intel Quartus Prime**:
    - Required for synthesizing the SystemVerilog code for FPGA deployment. Quartus Prime provides a comprehensive environment for designing with Intel FPGAs, SoCs, and CPLDs.
    - [Installation Guide](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/download.html)

### IP Components

Ensure you have the following IPs available in your Intel Quartus Prime installation to support the functionality of the ANN:

- **<FP_FUNCTIONS Intel® FPGA IP or Floating Point Functions Intel® FPGA IP Core>**: (Add)
- **<FP_FUNCTIONS Intel® FPGA IP or Floating Point Functions Intel® FPGA IP Core>**: (Multiply)

Convention used here is that ip for float addtion is generated with following path `src/ip/add_fp`. And float multiplication `src/ip/mul_fp`. Feel free to subsitute those IP cores for your own implementations of single precision float airithmetic operations.

## Usage

1. **Compilation**:
    - Navigate to the 'src' directory
    - Use make to compile all files:
    ``` make all ```
    - Or find specific target you are intresed in the Makfile and compile it. E.g.:
    ``` make mmmul ```

2. **Simulation**:
    - Use `vsim` to simulate specific designs.
    - Example: 

        ```
            vsim work.mmmul_tb
            add wave *
            run -a
        ```

3. **Testing**:

    To run testbenches in an automated way one can utilize test scripts: `src/test_*.sh` which compile and then simulate testbenches for respective designs without runing GUI. 



