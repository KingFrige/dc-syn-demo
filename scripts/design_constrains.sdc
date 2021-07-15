#####################
# timing
#####################

set MAX_FANOUT  20
set MAX_TRANS   0.3
set MAX_CAP     0.2
set OUTPUT_LOAD 0.1

# freqMHz = 100
set CLK_PERIOD      (1000/100)
set CLK_HALF        [expr 0.50 * $CLK_PERIOD]
set CLK_ONETHIRD    [expr 0.33 * $CLK_PERIOD]
set CLK_TWOTHIRD    [expr 0.67 * $CLK_PERIOD]
set CLK_TENTH       [expr 0.10 * $CLK_PERIOD]

# create clock
create_clock -name CLK [get_ports clock] -period $CLK_PERIOD -waveform "0 $CLK_HALF"
set_dont_touch_network [get_ports clock]

set clk_reset {reset_wire_reset}
set_dont_touch_network [get_ports reset]
set_input_delay  -min $CLK_TENTH    -clock CLK $clk_reset
set_input_delay  -max $CLK_ONETHIRD -clock CLK $clk_reset -add_delay
set_max_capacitance $MAX_CAP    [get_ports $clk_reset]

set clk_input {serial_tl_bits_in_valid serial_tl_bits_in_bits* serial_tl_bits_out_ready uart_0_rxd}
set_input_delay  -min $CLK_TENTH    -clock CLK $clk_input -add_delay
set_input_delay  -max $CLK_ONETHIRD -clock CLK $clk_input -add_delay
set_max_capacitance $MAX_CAP    [get_ports $clk_input]

set clk_output {serial_tl_clock serial_tl_bits_in_ready serial_tl_bits_out_valid serial_tl_bits_out_bits uart_0_txd}
set_output_delay -min -0.05         -clock CLK $clk_output -add_delay
set_output_delay -max $CLK_ONETHIRD -clock CLK $clk_output -add_delay
set_max_capacitance $MAX_CAP    [get_ports $clk_output]


set JTCK_PERIOD      (1000/10)
set JTCK_HALF        [expr 0.50 * $JTCK_PERIOD]
set JTCK_ONETHIRD    [expr 0.33 * $JTCK_PERIOD]
set JTCK_TWOTHIRD    [expr 0.67 * $JTCK_PERIOD]
set JTCK_TENTH       [expr 0.10 * $JTCK_PERIOD]

create_clock -name JTCK [get_ports jtag_TCK] -period $JTC_PERIOD -waveform "0 $JTCK_HALF"
set_dont_touch_network [get_ports jtag_TCK]

set_input_delay  -min $JTCK_TENTH    -clock JTCK
set_input_delay  -max $JTCK_ONETHIRD -clock JTCK 

set jtck_input {jtag_TMS jtag_TDI}
set_input_delay  -min $JTCK_TENTH    -clock JTCK $jtck_input -add_delay
set_input_delay  -max $JTCK_ONETHIRD -clock JTCK $jtck_input -add_delay
set_max_capacitance $MAX_CAP    [get_ports $jtck_input]

set jtck_output {jtag_TDO_data jtag_TDO_driven}
set_output_delay -min -0.05         -clock JTCK $jtck_output -add_delay
set_output_delay -max $JTCK_ONETHIRD -clock JTCK $jtck_output -add_delay
set_max_capacitance $MAX_CAP    [get_ports $jtck_output]





#clock uncertainty
set_clock_uncertainty 0.200 -setup [all_clocks]
set_clock_uncertainty 0.0 -hold  [all_clocks]

# Load/Drive and DRC rules
set_load -pin_load 10 [all_output]
set_drive 0 [all_input]

# Define design environments:
set_max_fanout      $MAX_FANOUT [current_design]
set_max_transition  $MAX_TRANS  [current_design]
set_max_capacitance $MAX_CAP    [current_design]

set_clock_groups -asynchronous -name grp1 -group [get_clocks {CLK}]
                 -group [get_clocks {JTCK}]
#####################
# area
#####################
set_max_area 0



#####################
# report group
#####################
group_path -name reg2reg -weight 10 -critical_range 0.5 -from [all_registers] -to [all_registers]
group_path -name reg2out -weight 2  -critical_range 0.5 -to   [all_outputs]
group_path -name in2reg  -weight 2  -critical_range 0.5 -from [all_inputs]
group_path -name in2out  -weight 1  -critical_range 0.5 -from [all_inputs]    -to [all_outputs]



