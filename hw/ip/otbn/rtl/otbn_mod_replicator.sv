// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * This module replicates WLEN/ELEN times the ELEN bit long modulus value stored in a
 * WLEN register. Modularized to simplify future extension and hardening.
 */
module otbn_mod_replicator
  import otbn_pkg::*;
(
  input  logic clk_i,
  input  logic rst_ni,

  input  logic [WLEN-1:0]      mod_i,
  input  logic [NELEN_ALU-1:0] elen_onehot_i,
  output logic [WLEN-1:0]      mod_replicated_o
);
  logic [WLEN-1:0] mod; // from MOD WSR
  logic [WLEN-1:0] mod_rep [NELEN_ALU];

  assign mod = mod_i;

  assign mod_rep[AluElen32]  = {(WLEN/32){mod[31:0]}};
  assign mod_rep[AluElen256] = mod;

  prim_onehot_mux #(
    .Width(WLEN),
    .Inputs(NELEN_ALU)
  ) u_sel_elen_mux (
    .clk_i,
    .rst_ni,
    .in_i  (mod_rep),
    .sel_i (elen_onehot_i),
    .out_o (mod_replicated_o)
  );

endmodule
