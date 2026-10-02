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

# Flag any unconstrained endpoints / missing clocks.
check_timing -verbose -file ${workroot}/clkdiag_check_timing.rpt

puts "===== CLKDIAG end ====="
