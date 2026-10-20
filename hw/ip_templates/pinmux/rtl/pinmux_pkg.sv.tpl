// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

<%!
  # Pad attribute fields a top can define the reset value of per pad, keyed by the
  # MIO/DIO_PAD_ATTR CSR field name: (pad_attr_t member, width). All other fields reset to 0.
  PAD_ATTR_FIELDS = {
    "invert":         ("invert",         1),
    "virtual_od_en":  ("virt_od_en",     1),
    "pull_en":        ("pull_en",        1),
    "pull_select":    ("pull_select",    1),
    "keeper_en":      ("keep_en",        1),
    "schmitt_en":     ("schmitt_en",     1),
    "od_en":          ("od_en",          1),
    "input_disable":  ("input_disable",  1),
    "slew_rate":      ("slew_rate",      2),
    "drive_strength": ("drive_strength", 4),
  }

  def check_pad_attrs(param, n_pads, pad_attrs):
    """Check a list of (name, attrs) tuples with one entry per pad."""
    assert len(pad_attrs) == n_pads, f"{param} needs {n_pads} entries, got {len(pad_attrs)}"
    for name, attrs in pad_attrs:
      assert isinstance(attrs, dict), f"pad attrs of {name} must be a dict, got {attrs!r}"
      for field, value in attrs.items():
        assert field in PAD_ATTR_FIELDS, (f"pad attrs of {name} has unknown field {field}. "
                                          f"Valid fields are {list(PAD_ATTR_FIELDS)}")
        max_value = (1 << PAD_ATTR_FIELDS[field][1]) - 1
        assert type(value) is int and 0 <= value <= max_value, (
            f"pad attrs of {name} has {field}: {value!r}. Expected an int in [0, {max_value}]")

  def pad_attr_sv(attrs):
    """Render the attrs of a pad as pad_attr_t constant."""
    members = [f"{PAD_ATTR_FIELDS[field][0]}: {PAD_ATTR_FIELDS[field][1]}'h{value:x}"
               for field, value in attrs.items()]
    return "pad_attr_t'{" + ", ".join(members + ["default: '0"]) + "}"
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

<%
  insel_w = n_mio_pads + 2
  outsel_w = n_mio_periph_out + 3
  assert len(mio_insel_legal) == n_mio_periph_in, \
      f"mio_insel_legal needs {n_mio_periph_in} entries, got {len(mio_insel_legal)}"
  assert len(mio_outsel_legal) == n_mio_pads, \
      f"mio_outsel_legal needs {n_mio_pads} entries, got {len(mio_outsel_legal)}"
  for name, mask in mio_insel_legal:
      assert mask & 0b11 == 0b11 and mask >> insel_w == 0, f"invalid INSEL mask for {name}"
  for name, mask in mio_outsel_legal:
      assert mask & 0b111 == 0b111 and mask >> outsel_w == 0, f"invalid OUTSEL mask for {name}"
  check_pad_attrs("mio_pad_attr_resvals", n_mio_pads, mio_pad_attr_resvals)
  check_pad_attrs("dio_pad_attr_resvals", n_dio_pads, dio_pad_attr_resvals)
%>\
  // Legal MIO_PERIPH_INSEL values for each MIO peripheral input. LSB corresponds to lowest index.
  // Includes static options.
  parameter logic [NMioPeriphIn-1:0][NMioPads+1:0] MioPeriphInselLegal = {
% for name, mask in mio_insel_legal[::-1]:
    ${insel_w}'h${"{:0{}x}".format(mask, (insel_w + 3) // 4)}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
% for name, mask in mio_outsel_legal[::-1]:
    ${outsel_w}'h${"{:0{}x}".format(mask, (outsel_w + 3) // 4)}${f"  // {name}" if loop.last else f", // {name}"}
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

endpackage : pinmux_pkg
