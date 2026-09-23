## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
##
## This connects the AST memory configuration signals to the memories defined in mem_cfg_consumers.
## mem_cfg_consumers must be of type:
## (struct field, flat inter-signal base name, cfg type kind, array width expr or None)
<%page args="mem_cfg_consumers"/>\
<%
  # cfg type kind -> (req struct type, rsp struct type)
  mem_cfg_types = {
    '1p':   ('prim_ram_1p_pkg::ram_1p_cfg_req_t',     'prim_ram_1p_pkg::ram_1p_cfg_rsp_t'),
    '1r1w': ('prim_ram_1r1w_pkg::ram_1r1w_cfg_req_t', 'prim_ram_1r1w_pkg::ram_1r1w_cfg_rsp_t'),
    'rom':  ('prim_rom_pkg::rom_cfg_req_t',           'prim_rom_pkg::rom_cfg_rsp_t'),
  }
  # Width of the widest left-hand side, so the '=' align across both directions.
  mem_cfg_lhs_pad = max(max(len(w) + len('_req') for f, w, k, a in mem_cfg_consumers),
                        max(len('ast_mem_cfg_rsp.') + len(f) for f, w, k, a in mem_cfg_consumers))
%>\
  // Connect local memory configurations
% for field, wire, kind, width in mem_cfg_consumers:
  assign ${(wire + '_req').ljust(mem_cfg_lhs_pad)} = ast_mem_cfg_req.${field};
  assign ${('ast_mem_cfg_rsp.' + field).ljust(mem_cfg_lhs_pad)} = ${wire}_rsp;
% endfor
