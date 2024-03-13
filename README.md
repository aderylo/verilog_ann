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

Convention used here is that ip for float addtion is generated with following path `src/ip/add_fp`. And float multiplication `src/ip/mul_fp`. Feel free to subsitute those IP cores for your own implementations of single precision float airithmetic operations. For the time being, IP cores generated with Quartus for Cyclone V hardware are included in the project.

## Usage

### Multi layer perceptron

This is a core design of the project which you can find in the `src/mlp.sv`. MLP architecture with single hidden layer was implemented, however nothing would stop you in extending it with additional layers due to modular design of the project. Anyhow,

1. **Compilation**:
    - Navigate to the `src` directory
    - Use make to compile necessary files:
    ``` make mlp ```

2. **Simulation**:
    - Use `vsim` to simulate behaviour of the design.
    - Example: 

        ```
            vsim work.mlp_tb
            add wave *
            run -a
        ```
3. **Automated testing**:

    To run testbenches in an automated way one can utilize test scripts: `src/test_*.sh` which compile and then simulate testbenches for respective designs without runing GUI. For example,
    ```
    bash test_mlp.sh
    ```
    will run the respective testbench for the MLP device.

### Other modules

Apart from utilizng MLP design, one might be intrested in checking out one of it's building blocks such as:

- matrix_matrix_multiplication 
- dot_product
- hadamard_product

Compilation, simulation and testing steps are analogous to the MLP device.



