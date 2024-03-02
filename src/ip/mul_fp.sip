set_global_assignment -entity "mul_fp" -library "lib_mul_fp" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "mul_fp" -library "lib_mul_fp" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "mul_fp" -library "lib_mul_fp" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_mul_fp" -name SPD_FILE [file join $::quartus(sip_path) "mul_fp.spd"]

set_global_assignment -library "lib_mul_fp" -name MISC_FILE [file join $::quartus(sip_path) "mul_fp_sim/mul_fp.vo"]
