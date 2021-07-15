#######PrimeTime Variable Setting ###############
set sh_enable_page_mode true
set svr_keep_unconnected_nets true
set timing_non_unate_clock_compatibility true
set timing_remove_clock_reconvergence_pessimism true
set timing_report_unconstrained_paths true
set si_enable_analysis true
set si_xtalk_delay_analysis_mode all_violating_paths
set si_xtalk_exit_on_max_iteration_count 2

set power_enable_analysis true

set auto_wire_load_selection true

#######Library Variable Setting ###############

set targetLib "/home/tools/pdk/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn28hpcplusbwp12t40p140lvt_180a/tcbn28hpcplusbwp12t40p140lvtssg0p81v125c_ccs.db
/home/tools/pdk/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn28hpcplusbwp12t40p140hvt_180a/tcbn28hpcplusbwp12t40p140hvtssg0p81v125c_ccs.db
/home/tools/pdk/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn28hpcplusbwp12t40p140_180a/tcbn28hpcplusbwp12t40p140ssg0p81v125c_ccs.db
/home/tools/pdk/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn28hpcplusbwp12t40p140cg_110c/tcbn28hpcplusbwp12t40p140cgssg0p81v125c_ccs.db";

set mem_library ""
set memDBList []
set memDBFlist ./dut/memDBFlist.f
set memDBList [open $memDBFlist]
while {[gets $memDBList line] >= 1} {
   lappend mem_library $line
}

set ip_library ""
set ipDBList []
set ipDBFlist ./dut/ipDBFlist.f
set ipDBList [open $ipDBFlist]
while {[gets $ipDBList line] >= 1} {
   lappend ip_library $line
}

set_app_var search_path  [list $search_path]
set_app_var target_library $targetLib
set_app_var link_library "* $target_library $synthetic_library $mem_library $ip_library"

set DESIGN_NAME "ChipTop";
set RTL_SOURCE_FILES_VERILOG "/home/guangda.dong/work/project/tmp/chipyard/vlsi/generated-src/chipyard.TestHarness.LargeBoomConfig/chipyard.TestHarness.LargeBoomConfig.top.v
/home/guangda.dong/work/project/tmp/chipyard/vlsi/generated-src/chipyard.TestHarness.LargeBoomConfig/chipyard.TestHarness.LargeBoomConfig.top.mems.v
/home/guangda.dong/work/project/tmp/chipyard/vlsi/generated-src/chipyard.TestHarness.LargeBoomConfig/EICG_wrapper.v
/home/guangda.dong/work/project/tmp/chipyard/vlsi/example.v
/home/guangda.dong/work/project/tmp/chipyard/vlsi/generated-src/chipyard.TestHarness.LargeBoomConfig/plusarg_reader.v
/home/guangda.dong/work/project/tmp/chipyard/vlsi/generated-src/chipyard.TestHarness.LargeBoomConfig/IOCell.v
/home/guangda.dong/work/project/tmp/chipyard/vlsi/generated-src/chipyard.TestHarness.LargeBoomConfig/ClockDividerN.sv";
