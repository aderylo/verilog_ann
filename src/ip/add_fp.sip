set_global_assignment -entity "add_fp" -library "lib_add_fp" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "add_fp" -library "lib_add_fp" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "add_fp" -library "lib_add_fp" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_add_fp" -name SPD_FILE [file join $::quartus(sip_path) "add_fp.spd"]

set_global_assignment -library "lib_add_fp" -name MISC_FILE [file join $::quartus(sip_path) "add_fp_sim/add_fp.vo"]
