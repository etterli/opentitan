## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
<%import topgen.lib as lib%>\
<%from topgen.merge import alert_handler_signals%>\
<%page args="top, feature_info, cio_info, gen_bkdr_loader"/>\
<%
  ast = lib.find_module(top['module'], 'ast')
  ast_internal = ast is not None and lib.is_inst(ast)
%>\
% if not ast_internal:
    // Base clocks from AST
    .ast_base_clks_i(ast_base_clks),
% endif

% for clk in top['unmanaged_clocks']._asdict().values():
    // Unmanaged external clock (${clk.name})
    .clk_${clk.name}_i(ext_clk),
    .cg_en_${clk.name}_i(prim_mubi_pkg::MuBi4True),
% endfor
    // Manual DFT signals
    .scan_rst_ni(scan_rst_n),
% for domain in feature_info["has_scan_en"]:
% if feature_info["has_scan_en"][domain]:
    .scan_en_i  (scan_en   ),
<% continue %>
% endif
% endfor
    .scanmode_i (scanmode  ),

% if feature_info["has_pinmux"]:
% if cio_info["num_mio_pads"] != 0:
% if gen_bkdr_loader:
    // Multiplexed I/O to backdoor
    .mio_in_i (mio_bkdr_in ),
    .mio_out_o(mio_bkdr_out),
    .mio_oe_o (mio_bkdr_oe ),
% else:
    // Multiplexed I/O
    .mio_in_i (mio_in ),
    .mio_out_o(mio_out),
    .mio_oe_o (mio_oe ),
% endif

% endif
% if cio_info["num_dio_total"] != 0:
    // Dedicated I/O
    .dio_in_i (dio_in ),
    .dio_out_o(dio_out),
    .dio_oe_o (dio_oe ),

% endif
    // Pad attributes
% if gen_bkdr_loader:
    .mio_attr_o(mio_bkdr_attr),
% else:
    .mio_attr_o(mio_attr),
% endif
    .dio_attr_o(dio_attr),

% endif\
