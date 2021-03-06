sh date
set initial_time [sh date +%s]

source ./scripts/common.tcl

set reportDir build/${topModule}/reports
set outputDir build/${topModule}/outputs
set logDir    build/${topModule}/logs

set dirs []
set dirs [list ${reportDir} ${outputDir} ${logDir}]

foreach dir $dirs {
  if { [file exists ${dir}] == 0 } {
    file mkdir ${dir}
  }
}

set_svf ${outputDir}/${topModule}_dc.svf

source ./scripts/lib_setup.tcl

set verilogout_no_tri "true"
set timing_enable_multiple_clocks_per_reg true
set bind_unused_hierarchical_pins false
set compile_delete_unloaded_sequential_cells true
set compile_preserve_subdesign_interfaces false
set power_cg_iscgs_enable true

set hdlin_auto_save_templates true
set hdlin_work_directory .template/
define_design_lib work -path .template/

#####################
# analyze & elaborate
#####################
set high_fanout_net_threshold 64
set_clock_gating_style  -minimum_bitwidth 4 -sequential_cell latch \
         -control_point before -control_signal scan_enable \
         -positive_edge_logic integrated \
         -max_fanout 12

analyze -format sverilog -vcs "-f ${flistPath}" > ${logDir}/analyze.log
elaborate ${topModule} > ${logDir}/elaborate.log

link > ${reportDir}/link.rpt
if {[link] == 0} {
   echo "Linking Error";
   exit;
}

check_design > ${reportDir}/check_design.rpt
if {[check_design] == 0} {
   echo "Check Design Error";
   exit;
}

check_mv_design -verbose > ${reportDir}/check_mv_design.rpt
check_timing > ${reportDir}/check_timing.rpt

write -f verilog -h -o ${outputDir}/${topModule}_gtech.v
#####################
# compile
#####################
set power_cg_flatten true
set compile_ultra_ungroup_dw true
set uniquify_naming_style ${topModule}\_%s_%d ; uniquify -force

source -e -v ./scripts/design_constrains.sdc

current_design	${topModule}

compile_ultra -no_autoungroup -gate_clock -no_seq_output_inversion
compile_ultra -incremental
optimize_netlist -area

#remove_unconnected_ports [get_cells * -h ]
change_names -hier -rule verilog
write -f verilog -h -o ${outputDir}/${topModule}_dc.v
write -f ddc     -h -o  ${outputDir}/${topModule}_dc.ddc
write_sdc ${outputDir}/${topModule}_dc.sdc
#####################
# report
#####################
proc syn_done {topModule} {
  echo mem max usage : [mem] , cpu : [cpu_time]
  echo $topModule syn finished
  sh rm -rf clog* filenames*.log
}

update_timing
check_timing > ${reportDir}/check_timing_syn.rpt
source -e -v ./scripts/report.tcl
set_svf -off
sh date
syn_done ${topModule} 
# exit
