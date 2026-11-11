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

  # Constant selections preceding the pads/peripheral outputs: INSEL 0, 1 and OUTSEL 0, 1, high-Z.
  INSEL_NUM_CONST = 2
  OUTSEL_NUM_CONST = 3
  # Reset selections without a default: INSEL constant 0 and OUTSEL high-Z.
  INSEL_RESVAL = 0
  OUTSEL_RESVAL = 2

  def _pad_name(mio_pad_names, pad):
    return mio_pad_names[pad] if type(pad) is int and 0 <= pad < len(mio_pad_names) else repr(pad)

  def _check_mio_periph_list(kind, mio_pad_names, n_periphs, periphs, default_keys):
    """Check a list of {name, pads} dicts with an optional default, one per MIO peripheral input
    or output."""
    assert len(periphs) == n_periphs, f"Expected {n_periphs} MIO {kind}s, got {len(periphs)}"
    for periph in periphs:
      assert {"name", "pads"} <= set(periph), f"MIO {kind} {periph} needs a name and pads"
      name, pads = periph["name"], periph["pads"]
      unknown = set(periph) - {"name", "pads"} - default_keys
      assert not unknown, f"MIO {kind} {name} has unknown keys {sorted(unknown)}"
      assert len(set(periph) & default_keys) <= 1, f"MIO {kind} {name} has more than one default"
      for pad in pads:
        assert type(pad) is int and 0 <= pad < len(mio_pad_names), (
            f"MIO {kind} {name} has pad {pad!r}. Expected an int in [0, {len(mio_pad_names) - 1}]")
      dups = sorted({mio_pad_names[pad] for pad in pads if pads.count(pad) > 1})
      assert not dups, f"MIO {kind} {name} lists the pads {dups} more than once"
      if "default_pad" in periph:
        assert periph["default_pad"] in pads, (
            f"MIO {kind} {name} has the default pad "
            f"{_pad_name(mio_pad_names, periph['default_pad'])} which is not one of its pads")
      if "default_const" in periph:
        const = periph["default_const"]
        assert type(const) is int and const in (0, 1), (
            f"MIO {kind} {name} has the default {const!r}. Expected a pad or the constant 0 or 1")

  def check_mio_periphs(mio_pad_names, n_mio_periph_in, n_mio_periph_out, mio_periph_ins,
                        mio_periph_outs):
    """Check the MIO peripheral inputs and outputs (see mio_periph_ins/outs in the tpldesc)."""
    for periph in mio_periph_outs:
      assert "default_const" not in periph, (
          f"MIO output {periph.get('name')} has the constant default "
          f"{periph['default_const']!r}. The default of an output must be a pad.")
    _check_mio_periph_list("input", mio_pad_names, n_mio_periph_in, mio_periph_ins,
                           {"default_pad", "default_const"})
    _check_mio_periph_list("output", mio_pad_names, n_mio_periph_out, mio_periph_outs,
                           {"default_pad"})
    for pad, pad_name in enumerate(mio_pad_names):
      outs = [periph["name"] for periph in mio_periph_outs if periph.get("default_pad") == pad]
      assert len(outs) <= 1, f"MIO pad {pad_name} is the default pad of multiple outputs {outs}"

  def mio_insel_legal(mio_periph_ins):
    """Legal MIO_PERIPH_INSEL values as bitmask, one per peripheral input."""
    return [sum(1 << (pad + INSEL_NUM_CONST) for pad in periph["pads"]) |
            ((1 << INSEL_NUM_CONST) - 1) for periph in mio_periph_ins]

  def mio_outsel_legal(n_mio_pads, mio_periph_outs):
    """Legal MIO_OUTSEL values as bitmask, one per MIO pad."""
    masks = [(1 << OUTSEL_NUM_CONST) - 1] * n_mio_pads
    for idx, periph in enumerate(mio_periph_outs):
      for pad in periph["pads"]:
        masks[pad] |= 1 << (idx + OUTSEL_NUM_CONST)
    return masks

  def mio_insel_resvals(mio_periph_ins):
    """MIO_PERIPH_INSEL reset values, one per peripheral input. A constant is encoded as is."""
    return [periph["default_pad"] + INSEL_NUM_CONST if "default_pad" in periph else
            periph.get("default_const", INSEL_RESVAL) for periph in mio_periph_ins]

  def mio_outsel_resvals(n_mio_pads, mio_periph_outs):
    """MIO_OUTSEL reset values, one per MIO pad."""
    resvals = [OUTSEL_RESVAL] * n_mio_pads
    for idx, periph in enumerate(mio_periph_outs):
      if "default_pad" in periph:
        resvals[periph["default_pad"]] = idx + OUTSEL_NUM_CONST
    return resvals

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
  check_pad_attrs("mio_pad_attr_resvals", n_mio_pads, mio_pad_attr_resvals)
  check_pad_attrs("dio_pad_attr_resvals", n_dio_pads, dio_pad_attr_resvals)
  # The pad attrs list has one entry per MIO pad, take the pad names from there.
  mio_pad_names = [name for name, _ in mio_pad_attr_resvals]
  check_mio_periphs(mio_pad_names, n_mio_periph_in, n_mio_periph_out, mio_periph_ins,
                    mio_periph_outs)
  insel_w = n_mio_pads + INSEL_NUM_CONST
  outsel_w = n_mio_periph_out + OUTSEL_NUM_CONST
  insel_legal = list(zip([p["name"] for p in mio_periph_ins], mio_insel_legal(mio_periph_ins)))
  outsel_legal = list(zip(mio_pad_names, mio_outsel_legal(n_mio_pads, mio_periph_outs)))
%>\
  // Legal MIO_PERIPH_INSEL values for each MIO peripheral input. LSB corresponds to lowest index.
  // Includes static options.
  parameter logic [NMioPeriphIn-1:0][NMioPads+1:0] MioPeriphInselLegal = {
% for name, mask in insel_legal[::-1]:
    ${insel_w}'h${"{:0{}x}".format(mask, (insel_w + 3) // 4)}${f"  // {name}" if loop.last else f", // {name}"}
% endfor
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
% for name, mask in outsel_legal[::-1]:
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
