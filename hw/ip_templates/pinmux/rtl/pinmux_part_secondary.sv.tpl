// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Pinmux toplevel.
//

`include "prim_assert.sv"

module pinmux_part_secondary
  import pinmux_pkg::*;
  import pinmux_reg_pkg::*;
  import prim_pad_wrapper_pkg::*;
(
  input clk_i,
  input rst_ni,

  // Muxed Peripheral side
  input        [NMioPeriphOut-1:0] periph_to_mio_i,
  input        [NMioPeriphOut-1:0] periph_to_mio_oe_i,
  output logic [NMioPeriphIn-1:0]  mio_to_periph_o,
  // Intra-IP connections
  input  p2s_t p2s_i,
  output s2p_t s2p_o
);

  /////////////////////
  // MIO Input Muxes //
  /////////////////////
  // The MIO input muxes for peripherals residing in the same domain as this partition. We however
  // stack and loop over all peripherals for convenient indexing but just tie-off irrelevant
  // mio_to_periph_o signals. All raw input signals come directly from the primary partition. See
  // the primary partition for a more detailed explanation.

  // Stack input and default signals for convenient indexing below. Possible defaults are
  // constant 0 or 1. Make sure mux is aligned to a power of 2 to avoid Xes.
  logic [AlignedMioInMuxSize-1:0] mio_mux;
  assign mio_mux = AlignedMioInMuxSize'({p2s_i.mio_in, 1'b1, 1'b0});

  for (genvar k = 0; k < NMioPeriphIn; k++) begin : gen_mio_periph_in
    if (!MioPeriphInIsInPrimary[k]) begin : gen_mio_in_mux
      // This peripheral is handled by this pinmux partition. Apply the pinmux matrix and
      // instantiate the mux. Illegal selections are masked to constant 0.
      logic [AlignedMioInMuxSize-1:0] mio_mux_legal;
      assign mio_mux_legal = mio_mux & AlignedMioInMuxSize'(MioPeriphInselLegal[k]);

      // The actual mux. Index using configured insel.
      assign mio_to_periph_o[k] = mio_mux_legal[p2s_i.reg2hw.mio_periph_insel[k].q];
    end else begin : gen_no_mio_in_mux
      // This peripheral is not managed by this partition. Its signal will not be used in this
      // domain. Tie it off here.
      assign mio_to_periph_o[k] = '0;
    end
  end

  //////////////////////
  // MIO Output Muxes //
  //////////////////////
  // The MIO output muxes generate a vector with the result for each pad. However, we only provide
  // valid values for pads fully muxed in this partition. The other pads are tied-off. The primary
  // partition will mux between the two 'muxing' definition.
  logic [AlignedMioOutMuxSize-1:0] periph_data, periph_oe;
  logic [NMioPads-1:0] periph_data_muxed, periph_oe_muxed;

  // We expect that the periph_to_mio[_oe]_i are tied off for peripherals not managed by this
  // partition.
  assign periph_data = AlignedMioOutMuxSize'({periph_to_mio_i,     1'b0, 1'b1, 1'b0});
  assign periph_oe   = AlignedMioOutMuxSize'({periph_to_mio_oe_i,  1'b0, 1'b1, 1'b1});

  for (genvar k = 0; k < NMioPads; k++) begin : gen_mio_out
    if (!MioPadMuxedInPrimary[k]) begin : gen_mio_out_mux
      // Apply the pinmux matrix. Illegal selections are masked implicitly to high-Z (data and
      // enable are 0)
      logic [AlignedMioOutMuxSize-1:0] periph_data_legal, periph_oe_legal;
      assign periph_data_legal = periph_data & AlignedMioOutMuxSize'(MioOutselLegal[k]);
      assign periph_oe_legal   = periph_oe   & AlignedMioOutMuxSize'(MioOutselLegal[k]);

      // Mux the peripheral source based on the configured index.
      assign periph_data_muxed[k] = periph_data_legal[p2s_i.reg2hw.mio_outsel[k].q];
      assign periph_oe_muxed[k]   = periph_oe_legal[p2s_i.reg2hw.mio_outsel[k].q];
    end else begin : gen_no_mio_out_mux
      // This output is managed by the other partition, so we tie it off to default values.
      assign periph_data_muxed[k] = '0;
      assign periph_oe_muxed[k]   = '0;
    end
  end

  // Forward the raw inputs and result to the other partition.
  assign s2p_o.periph_data = periph_to_mio_i;
  assign s2p_o.periph_oe   = periph_to_mio_oe_i;
  assign s2p_o.pad_data    = periph_data_muxed;
  assign s2p_o.pad_oe      = periph_oe_muxed;

  ///////////////////////////
  // Unused reg2hw signals //
  ///////////////////////////
  logic unused_reg2hw;
  assign unused_reg2hw = ^{
    p2s_i.reg2hw.alert_test,
    p2s_i.reg2hw.mio_pad_attr,
    p2s_i.reg2hw.dio_pad_attr,
    p2s_i.reg2hw.mio_pad_sleep_status,
    p2s_i.reg2hw.mio_pad_sleep_en,
    p2s_i.reg2hw.mio_pad_sleep_mode,
    p2s_i.reg2hw.dio_pad_sleep_status,
    p2s_i.reg2hw.dio_pad_sleep_en,
    p2s_i.reg2hw.dio_pad_sleep_mode,
    p2s_i.reg2hw.wkup_detector_en,
    p2s_i.reg2hw.wkup_detector,
    p2s_i.reg2hw.wkup_detector_cnt_th,
    p2s_i.reg2hw.wkup_detector_padsel,
    p2s_i.reg2hw.wkup_cause
  };

endmodule
