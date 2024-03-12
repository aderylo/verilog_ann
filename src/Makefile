
# IP files ------------------------------------------

ADD_FP_VHDL_FILES := ip/add_fp/dspba_library_package.vhd \
              ip/add_fp/dspba_library.vhd \
              ip/add_fp/add_fp_0002.vhd

ADD_FP_VLOG_FILES := ip/add_fp.v

MUL_FP_VHDL_FILES := ip/mul_fp/dspba_library_package.vhd \
              ip/mul_fp/dspba_library.vhd \
              ip/mul_fp/mul_fp_0002.vhd 

MUL_FP_VLOG_FILES := ip/mul_fp.v


add_fp:
	@echo "Compiling VHDL files for add_fp..."
	@for file in $(ADD_FP_VHDL_FILES); do vcom $$file; done
	@echo "Compiling Verilog files for add_fp..."
	@for file in $(ADD_FP_VLOG_FILES); do vlog $$file; done

mul_fp:
	@echo "Compiling VHDL files for mul_fp..."
	@for file in $(MUL_FP_VHDL_FILES); do vcom $$file; done
	@echo "Compiling Verilog files for mul_fp..."
	@for file in $(MUL_FP_VLOG_FILES); do vlog $$file; done


# Utils
UTILS_FILES := utils.sv

utils: add_fp
	@echo "Compiling Verilog files for utils..."
	@for file in $(UTILS_FILES); do vlog -sv $$file; done


# Vector operations

VECTOR_ELEM_SUM_FILES := vector/elem_sum.sv vector/elem_sum_tb.sv
VECTOR_HADAMARD_FILES := vector/hadamard_product.sv vector/hadamard_product_tb.sv
VECTOR_DOT_PRODUCT_FILES := vector/dot_product.sv vector/dot_product_tb.sv


vec_elem_sum: add_fp utils
	@echo "Compiling Verilog files for vec_elem_sum..."
	@for file in $(VECTOR_ELEM_SUM_FILES); do vlog -sv $$file; done

vec_h_prod: mul_fp utils
	@echo "Compiling Verilog files for vec_h_prod..."
	@for file in $(VECTOR_HADAMARD_FILES); do vlog -sv $$file; done

vec_d_prod: vec_elem_sum vec_h_prod
	@echo "Compiling Verilog files for vec_d_prod..."
	@for file in $(VECTOR_DOT_PRODUCT_FILES); do vlog -sv $$file; done


# Matrix multiplication

MMMUL_FILES = mmmul.sv mmmul_tb.sv

mmmul: vec_d_prod
	@echo "Compiling Verilog files for mmmul..."
	@for file in $(MMMUL_FILES); do vlog -sv $$file; done


# Activation functions
ACTV_FN_FILES = activation/relu.sv activation/utils.sv

activ:
	@echo "Compiling Verilog files for activations functions..."
	@for file in $(MMMUL_FILES); do vlog -sv $$file; done

# Layers
LAYERS_FILES = layers/linear.sv layers/linear_tb.sv

layers: mmmul
	@echo "Compiling Verilog files for ann layers..."
	@for file in $(LAYERS_FILES); do vlog -sv $$file; done

clean:
	@echo "Cleaning up..."
	@rm -rf work transcript *.wlf

.PHONY: all add_fp mul_fp v_elem_sum v_h_prod clean