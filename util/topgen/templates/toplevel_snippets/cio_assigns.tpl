## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
<%import topgen.lib as lib%>\
<%page args="top, feature_info, cio_info, domain"/>\
% if domain in feature_info["pinmux_domains"]:
## Only the IOs of this domain are connected to the pinmux partition here. The outputs of the
## other IOs are tied off.
  // Pinmux connections
  // All muxed inputs - Inputs handled by other pinmux partition are unused.
  % for sig in top["pinmux"]["ios"]:
    % if sig["connection"] == "muxed" and sig["type"] in ["inout", "input"] and sig["domain"] == domain:
<% literal = lib.get_io_enum_literal(sig, 'mio_in') %>\
  assign cio_${sig["name"]}_p2d${"[" + str(sig["idx"]) +"]" if sig["idx"] !=-1  else ""} = mio_p2d[${literal}];
    % endif
  % endfor
<%
  unused_mio_in = [lib.get_io_enum_literal(sig, 'mio_in') for sig in top["pinmux"]["ios"]
                   if sig["connection"] == "muxed" and sig["type"] in ["inout", "input"] and
                   sig["domain"] != domain]
%>\
  % if unused_mio_in:
  logic unused_mio_p2d;
  assign unused_mio_p2d = ^{
    % for literal in unused_mio_in:
    mio_p2d[${literal}]${"" if loop.last else ","}
    % endfor
  };
  % endif

  // All muxed outputs - Tied-off signals are handled by other pinmux partition.
  % for sig in top["pinmux"]["ios"]:
    % if sig["connection"] == "muxed" and sig["type"] in ["inout", "output"]:
<% literal = lib.get_io_enum_literal(sig, 'mio_out') %>\
      % if sig["domain"] == domain:
  assign mio_d2p[${literal}] = cio_${sig["name"]}_d2p${"[" + str(sig["idx"]) +"]" if sig["idx"] !=-1  else ""};
      % else:
  assign mio_d2p[${literal}] = 1'b0;
      % endif
    % endif
  % endfor

  // All muxed output enables - Tied-off signals are handled by other pinmux partition.
  % for sig in top["pinmux"]["ios"]:
    % if sig["connection"] == "muxed" and sig["type"] in ["inout", "output"]:
<% literal = lib.get_io_enum_literal(sig, 'mio_out') %>\
      % if sig["domain"] == domain:
  assign mio_en_d2p[${literal}] = cio_${sig["name"]}_en_d2p${"[" + str(sig["idx"]) +"]" if sig["idx"] !=-1  else ""};
      % else:
  assign mio_en_d2p[${literal}] = 1'b0;
      % endif
    % endif
  % endfor

  // All dedicated inputs
  logic [${cio_info["num_dio_total"]-1}:0] unused_dio_p2d;
  assign unused_dio_p2d = dio_p2d;
  % for sig in top["pinmux"]["ios"]:
    % if sig["connection"] != "muxed" and sig["type"] in ["input", "inout"] and sig["domain"] == domain:
<% literal = lib.get_io_enum_literal(sig, 'dio') %>\
  assign cio_${sig["name"]}_p2d${"[" + str(sig["idx"]) +"]" if sig["idx"] !=-1  else ""} = dio_p2d[${literal}];
    % endif
  % endfor

  // All dedicated outputs - Tied-off signals are handled by other pinmux partition.
  // Input-only DIOs are tied-off as well.
  % for sig in top["pinmux"]["ios"]:
    % if sig["connection"] != "muxed":
<% literal = lib.get_io_enum_literal(sig, 'dio') %>\
      % if sig["type"] in ["output", "inout"] and sig["domain"] == domain:
  assign dio_d2p[${literal}] = cio_${sig["name"]}_d2p${"[" + str(sig["idx"]) +"]" if sig["idx"] !=-1  else ""};
      % else:
  assign dio_d2p[${literal}] = 1'b0;
      % endif
    % endif
  % endfor

  // All dedicated output enables - Tied-off signals are handled by other pinmux partition.
  // Input-only DIOs are tied-off as well.
  % for sig in top["pinmux"]["ios"]:
    % if sig["connection"] != "muxed":
<% literal = lib.get_io_enum_literal(sig, 'dio') %>\
      % if sig["type"] in ["output", "inout"] and sig["domain"] == domain:
  assign dio_en_d2p[${literal}] = cio_${sig["name"]}_en_d2p${"[" + str(sig["idx"]) +"]" if sig["idx"] !=-1  else ""};
      % else:
  assign dio_en_d2p[${literal}] = 1'b0;
      % endif
    % endif
  % endfor
% endif\
