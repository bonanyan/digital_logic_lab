##############################################################################
## Preset global variables and attributes
##############################################################################
set TIME [clock format [clock seconds] -format "%y%m%d%H%m%S"]
##generates <signal>_reg[<bit_width>] format
set_db / .hdl_array_naming_style %s\[%d\] 

set_db / .init_lib_search_path [list ./lib]
set_db / .script_search_path {.}

##Default undriven/unconnected setting is 'none'.  
##set_db / .hdl_unconnected_value 0 | 1 | x | none

set_db / .information_level 7 

###############################################################
## Library setup
###############################################################
set_db library NanGate_15nm_OCL_slow_conditional_ccs.lib

# clock gating
set_db / .lp_insert_clock_gating false

###############################################################
## Read files
###############################################################
# find hdl design files in paths
set_db / .init_hdl_search_path {./src}

#Uncomment one of the next lines for specific files, or all files in a directory
set myFiles [list program_counter.v]
#set myFiles [glob -directory <path to hdl files> *.v]
set basename ProgramCounter
set sysclk clk
set myClk sysclk

set ClockPeriod 5000
set InDelay 300
set OutDelay 300

#Analyze and Elaborate the Design File
read_hdl ${myFiles}
elaborate

# Apply Constraints and generate clocks
create_clock -name ${myClk} -period ${ClockPeriod} [get_ports ${sysclk}]
set_clock_uncertainty 200 [get_clocks ${myClk}]
set_input_delay 100 -clock [get_clocks ${myClk}] [all_inputs]
set_output_delay 100 -clock [get_clocks ${myClk}] [all_outputs]
set_max_fanout 16 [all_inputs]

set_driving_cell -cell INV_X1 [all_inputs]
# set_driving_cell -cell INV_X2 [all_outputs]
set_load 50.0 [all_outputs]

# check that the design is OK so far
check_design -unresolved
report timing -lint

# Synthesize the design to the target library
synthesize -to_mapped -effort medium

# Write out the reports
report_timing > ./report/timing.rep
report_gates  > ./report/cell.rep
report_area   > ./report/area.rep
report_power  > ./report/power.rep

# Write out the structural Verilog and sdc files
write_hdl -mapped > ./gen/${basename}.vg
write_sdc > ./gen/${basename}.sdc
write_sdf > ./gen/${basename}.sdf