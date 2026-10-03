# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# TEMPORARY clock diagnostic for the AST-move IO-clock-tree debug.
# Runs after init_design (netlist open, XDC applied), prints to the impl log.
set workroot [file dirname [info script]]

puts "===== CLKDIAG begin (init_design_post) ====="

# Full clock list (also written to a file next to the run).
report_clocks -file ${workroot}/clkdiag_report_clocks.rpt
report_clocks

# Which clock(s) actually survive on the key IO-clock-tree pins.
foreach pin {
  top_*/*_pd_main/u_ast_part_primary/u_ast_clks_byp_primary/u_no_scan_clk_src_io_d1ord2/gen_div_bufg.u_bufg_div_full/O
  top_*/*_pd_main/u_ast_part_primary/u_ast_clks_byp_primary/u_no_scan_clk_src_io_d1ord2/gen_div_bufg.u_bufg_div_stepdown/O
  top_*/*_pd_main/u_ast_part_primary/u_ast_clks_byp_primary/u_no_scan_clk_src_io_d1ord2/gen_div_bufg.u_bufg_div_mux/O
  top_*/*_pd_aon/u_clkmgr/u_no_scan_io_div2_div/gen_div_bufg.u_bufg_div_full/O
  top_*/*_pd_aon/u_clkmgr/u_no_scan_io_div4_div/gen_div_bufg.u_bufg_div_full/O
  top_*/*_pd_aon/u_clkmgr/u_no_scan_io_div4_div/gen_div_bufg.u_bufg_div_stepdown/O
} {
  set clks [get_clocks -quiet -of_objects [get_pins -quiet $pin]]
  puts "CLKDIAG pin=$pin -> clocks={$clks}"
}

# How many registers does each functional clock actually drive?
# 0 / suspiciously-low = that clock is defined but does not reach its loads.
foreach clk {clk_main clk_io clk_io_div2 clk_io_div4 clk_usb_48 clk_aon jtag_tck lc_jtag_tck rv_jtag_tck} {
  set c [get_clocks -quiet $clk]
  if {$c ne ""} {
    puts "CLKDIAG2 clock=$clk period=[get_property PERIOD $c] registers=[llength [all_registers -quiet -clock $c]]"
  } else {
    puts "CLKDIAG2 clock=$clk MISSING"
  }
}

# Which clock(s) actually clock the debug module / CPU / strap sampler?
# nregs=0 => that block is not in the netlist; clocks={} => defined but unclocked.
foreach {label pat} {rv_dm *rv_dm* ibex *u_rv_core_ibex* pinmux_tap *u_pinmux_strap_sampling*} {
  set regs [get_cells -quiet -hierarchical -filter "IS_SEQUENTIAL && NAME =~ $pat"]
  if {[llength $regs]} {
    puts "CLKDIAG3 $label nregs=[llength $regs] clocks={[get_clocks -quiet -of_objects $regs]}"
  } else {
    puts "CLKDIAG3 $label nregs=0 (nothing matched $pat)"
  }
}

# Cross-PD AON clock check: what clock drives the MAIN-partition AST reset-release
# flops (u_ast_clks_byp_primary, incl. u_rst_main_da)? Should be clk_aon.
set aon_regs [get_cells -quiet -hierarchical -filter "IS_SEQUENTIAL && NAME =~ *u_ast_clks_byp_primary*"]
puts "CLKDIAG4 ast_clks_byp_primary regs=[llength $aon_regs] clocks={[get_clocks -quiet -of_objects $aon_regs]}"

# Unconstrained-endpoint summary straight to the log (full verbose report to a file too).
puts "----- CLKDIAG check_timing summary -----"
check_timing
check_timing -verbose -file ${workroot}/clkdiag_check_timing.rpt

puts "===== CLKDIAG end ====="
