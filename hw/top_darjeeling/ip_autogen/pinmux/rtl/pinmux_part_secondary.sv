// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Pinmux toplevel, secondary partition of the split IP.
//
// The secondary partition does not contain any logic yet. All muxing is done in the primary
// partition.

module pinmux_part_secondary (
  input clk_i,
  input rst_ni
);

  logic unused_clk;
  logic unused_rst_n;
  assign unused_clk   = clk_i;
  assign unused_rst_n = rst_ni;

endmodule : pinmux_part_secondary
