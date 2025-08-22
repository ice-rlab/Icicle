
set sdc_version 1.6
if { [expr {[llength [info procs set_asap7_units]] > 0}] } {
    set_asap7_units
}

# set top cell
if { [info exists TOPCELL] } {
    current_design $TOPCELL
}

# create clock
if { ![info exists clk_name] } {
    set clk_name core_clock
    set clk_port_name clock
    set clk_period 5000
}
create_clock -name $clk_name -add -period $clk_period [get_ports $clk_port_name]

# Transition/Slew settings
set_max_transition [expr 0.3*$clk_period] [current_design]
set_max_transition [expr 0.1*$clk_period] [get_clocks $clk_name] -clock_path
set_clock_transition [expr 0.1*$clk_period] [get_clocks $clk_name]

# % of cycle given to parent for input/output paths, e.g., 0.3 gives 30% of the cycle to the parent
set clk_io_pct 0.1
set_input_delay -max -clock [get_clocks $clk_name] [expr $clk_io_pct * $clk_period] [remove_from_collection [all_inputs] [get_ports $clk_port_name]]
set_input_delay -min -clock [get_clocks $clk_name] [expr 0.0 * $clk_period] [remove_from_collection [all_inputs] [get_ports $clk_port_name]]
set_output_delay -max -clock [get_clocks $clk_name] [expr $clk_io_pct * $clk_period] [all_outputs]
set_output_delay -min -clock [get_clocks $clk_name] [expr 0.0 * $clk_period] [all_outputs]

# Uncertainty to give to clocks
set_clock_uncertainty 5 [all_clocks]
