// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

<%!
  from ipgen.pinmux_gen import (INSEL_NUM_CONST, OUTSEL_NUM_CONST, check_params,
                                mio_insel_legal, mio_outsel_in_primary, mio_outsel_legal,
                                mio_pad_muxed_in_primary, mio_periph_in_parts, pad_attr_sv)
%>\
package pinmux_pkg;

  import pinmux_reg_pkg::*;
  import prim_pad_wrapper_pkg::*;

  parameter int NumIOs     = NMioPads + NDioPads;
  parameter int NDFTStraps = 2;
  parameter int NTapStraps = 2;

  // Since the target-specific top-levels often have slightly different debug signal positions, we
  // need a way to pass this info from the target specific top-level into the pinmux logic. The
  // datastructure below serves this purpose. Note that all the indices below are with respect to
  // the concatenated {DIO, MIO} packed array.
  typedef struct packed {
  % if enable_strap_sampling:
    integer                   tck_idx;
    integer                   tms_idx;
    integer                   trst_idx;
    integer                   tdi_idx;
    integer                   tdo_idx;
    integer                   tap_strap0_idx;
    integer                   tap_strap1_idx;
    integer                   dft_strap0_idx;
    integer                   dft_strap1_idx;
  % endif
  % if enable_usb_wakeup:
    integer                   usb_dp_idx;
    integer                   usb_dn_idx;
    integer                   usb_sense_idx;
  % endif
    pad_type_e [NDioPads-1:0] dio_pad_type;
    pad_type_e [NMioPads-1:0] mio_pad_type;
    scan_role_e [NDioPads-1:0] dio_scan_role;
    scan_role_e [NMioPads-1:0] mio_scan_role;
  } target_cfg_t;

  parameter target_cfg_t DefaultTargetCfg = '{
  % if enable_strap_sampling:
    tck_idx:           0,
    tms_idx:           0,
    trst_idx:          0,
    tdi_idx:           0,
    tdo_idx:           0,
    tap_strap0_idx:    0,
    tap_strap1_idx:    0,
    dft_strap0_idx:    0,
    dft_strap1_idx:    0,
  % endif
  % if enable_usb_wakeup:
    usb_dp_idx:        0,
    usb_dn_idx:        0,
    usb_sense_idx:     0,
  % endif
    dio_pad_type:      {NDioPads{BidirStd}},
    mio_pad_type:      {NMioPads{BidirStd}},
    dio_scan_role:     {NDioPads{NoScan}},
    mio_scan_role:     {NMioPads{NoScan}}
  };

  // Widths of the dense mux vectors aligned to power of two to avoid Xes. Input has two constant
  // options (0, 1) and output has 3 (0, 1, high-Z).
  parameter int AlignedMioInMuxSize  = (NMioPads + 2 > NDioPads) ? 2**$clog2(NMioPads + 2) :
                                                                  2**$clog2(NDioPads);
  parameter int AlignedMioOutMuxSize = 2**$clog2(NMioPeriphOut + 3);

<%
  check_params(n_mio_pads, n_dio_pads, n_mio_periph_in, n_mio_periph_out, mio_periph_ins,
               mio_periph_outs, mio_pad_attr_resvals, dio_pad_attr_resvals)
  # The pad attrs list has one entry per MIO pad, take the pad names from there.
  mio_pad_names = [name for name, _ in mio_pad_attr_resvals]
  insel_w = n_mio_pads + INSEL_NUM_CONST
  outsel_w = n_mio_periph_out + OUTSEL_NUM_CONST
%>\
  // Legal MIO_PERIPH_INSEL values for each MIO peripheral input. LSB corresponds to lowest index.
  // Includes static options.
  parameter logic [NMioPeriphIn-1:0][NMioPads+1:0] MioPeriphInselLegal = {
% for name, mask in mio_insel_legal(mio_periph_ins)[::-1]:
    ${insel_w}'h${"{:0{}x}".format(mask, (insel_w + 3) // 4)}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
% for name, mask in mio_outsel_legal(mio_pad_names, mio_periph_outs)[::-1]:
    ${outsel_w}'h${"{:0{}x}".format(mask, (outsel_w + 3) // 4)}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Partitions of a split pinmux muxing a MIO peripheral input. Bit 0: primary, bit 1: secondary.
  // A non-split pinmux only has the primary partition.
  typedef enum logic [1:0] {
    MuxPartPrimary   = 2'b01,
    MuxPartSecondary = 2'b10,
    MuxPartBoth      = 2'b11
  } mux_part_e;

  // Partitions muxing each MIO peripheral input. LSB corresponds to lowest index.
  parameter mux_part_e [NMioPeriphIn-1:0] MioPeriphInPart = {
% for name, part in mio_periph_in_parts(mio_periph_ins)[::-1]:
    ${part}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Whether the source of each MIO_OUTSEL value is in the primary partition. LSB corresponds to
  // lowest index. Includes the static options, which exist in both partitions.
  parameter logic [AlignedMioOutMuxSize-1:0] MioOutselInPrimary = AlignedMioOutMuxSize'({
% for name, in_primary in mio_outsel_in_primary(mio_periph_outs)[::-1]:
    1'b${int(in_primary)}, // ${name}
% endfor
    ${OUTSEL_NUM_CONST}'b${"1" * OUTSEL_NUM_CONST}  // static options
  });

  // Whether the output mux of each MIO pad is in the primary partition. This is the case if any
  // legal peripheral output of the pad is in the primary partition. LSB corresponds to lowest
  // index.
  parameter logic [NMioPads-1:0] MioPadMuxedInPrimary = {
% for name, in_primary in mio_pad_muxed_in_primary(mio_pad_names, mio_periph_outs)[::-1]:
    1'b${int(in_primary)}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
  parameter pad_attr_t [NMioPads-1:0] MioPadAttrResval = {
% for name, attrs in mio_pad_attr_resvals[::-1]:
    ${pad_attr_sv(attrs)}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Reset values of the DIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
% for name, attrs in dio_pad_attr_resvals[::-1]:
    ${pad_attr_sv(attrs)}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Wakeup Detector Modes
  typedef enum logic [2:0] {
    Posedge   = 3'b000,
    Negedge   = 3'b001,
    Edge      = 3'b010,
    HighTimed = 3'b011,
    LowTimed  = 3'b100
  } wkup_mode_e;

  // Interface with LC controller
  typedef struct packed {
    logic                  valid;
    logic [NDFTStraps-1:0] straps;
  } dft_strap_test_req_t;

  typedef enum logic [NTapStraps-1:0] {
    FuncSel   = 2'b00,
    LcTapSel  = 2'b01,
    RvTapSel  = 2'b10,
    DftTapSel = 2'b11
  } tap_strap_t;

  // Intra-IP connections
  typedef struct packed {
    logic [NMioPads-1:0] mio_in;
    pinmux_reg2hw_t reg2hw;
  } p2s_t;

  typedef struct packed {
    logic [NMioPeriphOut-1:0] periph_data;
    logic [NMioPeriphOut-1:0] periph_oe;
    logic [NMioPads-1:0] pad_data;
    logic [NMioPads-1:0] pad_oe;
  } s2p_t;

endpackage : pinmux_pkg
