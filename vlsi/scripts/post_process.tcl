
if {[info exists ::env(STEP)]} {
    set step $::env(STEP)
} else {
    set step "place"
}

if {[get_db designs] == ""} {
    set in_flow false
    source ../../input/project_setup.tcl
    source ../../code/tcl/adam_flow_procs.tcl
    set_asap7_units
    read_db ../output/dbs/$step.db

    enable_metrics -on
    push_snapshot_stack
} else {
    set in_flow true
}

set nets [get_nets -of_objects [get_cells csr*]]
set max_len 0
set max_len_name ""
set sum_len 0
foreach_in_collection net $nets {
    if { [get_db $net .is_clock] } continue
    set len 0
    foreach w [get_db $net .wires] {
        set len [expr $len + [get_db $w .length]]
    }

    set sum_len [expr $sum_len + $len]
    if { $len > $max_len } {
        set max_len $len
        set max_len_name "$w"
    }
}
puts "Max length with $max_len_name: $max_len"
puts "Total length: $sum_len"

report_timing -through $nets -max_paths 1 -group [list reg2reg] -path_type summary > $iv::reportDir/longest_csr_path.txt
grep "Data Path" $iv::reportDir/longest_csr_path.txt > $iv::reportDir/longest_csr_path_delay.txt
set f [open $iv::reportDir/longest_csr_path_delay.txt "r"]
set longest_csr_path [lindex [split [gets $f]] end]
close $f

define_metric -name csr_wirelength
set_metric -name csr_wirelength -value "$sum_len"
define_metric -name max_csr_wirelength
set_metric -name max_csr_wirelength -value "$max_len"
define_metric -name longest_csr_path
set_metric -name longest_csr_path -value "$longest_csr_path"

if { !$in_flow } {
#    snapshot -name $step -dbs_dir $iv::OutDir/dbs -metrics_dir $iv::metricsDir
    exit
} else {
    puts "Continuing"
}


