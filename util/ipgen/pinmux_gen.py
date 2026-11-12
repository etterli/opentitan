# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Provides support functions for the pinmux ipgen template."""

from typing import Dict, List, Tuple

# Maps pad attribute names to their pad_attr_t member name and width. This is required because the
# CSR field names and the SV code mismatch.
PAD_ATTR_FIELDS = {
    "invert": ("invert", 1),
    "virtual_od_en": ("virt_od_en", 1),
    "pull_en": ("pull_en", 1),
    "pull_select": ("pull_select", 1),
    "keeper_en": ("keep_en", 1),
    "schmitt_en": ("schmitt_en", 1),
    "od_en": ("od_en", 1),
    "input_disable": ("input_disable", 1),
    "slew_rate": ("slew_rate", 2),
    "drive_strength": ("drive_strength", 4),
}

# Constant selections preceding the pads/peripheral outputs: INSEL 0, 1 and OUTSEL 0, 1, high-Z.
INSEL_NUM_CONST = 2
OUTSEL_NUM_CONST = 3
# Reset selections without a default: INSEL constant 0 and OUTSEL high-Z.
INSEL_RESVAL = 0
OUTSEL_RESVAL = 2


def check_params(n_mio_pads: int, n_dio_pads: int, n_mio_periph_in: int, n_mio_periph_out: int,
                 mio_periph_ins: List[Dict], mio_periph_outs: List[Dict],
                 mio_pad_attr_resvals: List[Tuple[str, Dict]],
                 dio_pad_attr_resvals: List[Tuple[str, Dict]]) -> None:
    """Check the parameters passed to the pinmux template."""
    errors: List[str] = []
    _check_pad_attrs(errors, "mio_pad_attr_resvals", n_mio_pads, mio_pad_attr_resvals)
    _check_pad_attrs(errors, "dio_pad_attr_resvals", n_dio_pads, dio_pad_attr_resvals)
    # The MIO pad attrs list has one entry per MIO pad, take the pad names from there.
    mio_pad_names = [name for name, _ in mio_pad_attr_resvals]
    _check_mio_periph_list(errors, "input", n_mio_pads, mio_pad_names, n_mio_periph_in,
                           mio_periph_ins, True)
    _check_mio_periph_list(errors, "output", n_mio_pads, mio_pad_names, n_mio_periph_out,
                           mio_periph_outs, False)
    for pad in range(n_mio_pads):
        outs = [periph.get("name") for periph in mio_periph_outs
                if periph.get("default_pad") == pad]
        if len(outs) > 1:
            errors.append(f"MIO pad {_pad_name(mio_pad_names, pad)} is the default pad of "
                          f"multiple outputs {outs}")
    assert not errors, "\n".join(errors)


def _check_pad_attrs(errors: List[str], param: str, n_pads: int,
                     pad_attrs: List[Tuple[str, Dict]]) -> None:
    """Validate that the pad attribute parameter specifies each pad correctly."""
    if len(pad_attrs) != n_pads:
        errors.append(f"{param} needs {n_pads} entries, got {len(pad_attrs)}")
    for name, attrs in pad_attrs:
        if not isinstance(attrs, dict):
            errors.append(f"pad attrs of {name} must be a dict, got {attrs!r}")
            continue
        for field, value in attrs.items():
            if field not in PAD_ATTR_FIELDS:
                errors.append(f"pad attrs of {name} has unknown field {field}. "
                              f"Valid fields are {list(PAD_ATTR_FIELDS)}")
                continue
            max_value = (1 << PAD_ATTR_FIELDS[field][1]) - 1
            if type(value) is not int or not 0 <= value <= max_value:
                errors.append(f"pad attrs of {name} has {field}: {value!r}. Expected an int in "
                              f"[0, {max_value}]")


def _pad_name(mio_pad_names: List[str], pad: object) -> str:
    return mio_pad_names[pad] if type(pad) is int and 0 <= pad < len(mio_pad_names) else repr(pad)


def _check_mio_periph_list(errors: List[str], kind: str, n_mio_pads: int,
                           mio_pad_names: List[str], n_periphs: int, periphs: List[Dict],
                           const_default: bool) -> None:
    """Check a list of {name, pads} dicts with an optional default_pad or default_const, one per
    MIO peripheral input or output."""
    if len(periphs) != n_periphs:
        errors.append(f"Expected {n_periphs} MIO {kind}s, got {len(periphs)}")
    for periph in periphs:
        if not {"name", "pads"} <= set(periph):
            errors.append(f"MIO {kind} {periph} needs a name and pads")
            continue
        name, pads = periph["name"], periph["pads"]
        unknown = set(periph) - {"name", "pads", "default_pad", "default_const"}
        if unknown:
            errors.append(f"MIO {kind} {name} has unknown keys {sorted(unknown)}")
        if "default_pad" in periph and "default_const" in periph:
            errors.append(f"MIO {kind} {name} has more than one default")
        for pad in pads:
            if type(pad) is not int or not 0 <= pad < n_mio_pads:
                errors.append(f"MIO {kind} {name} has pad {pad!r}. Expected an int in "
                              f"[0, {n_mio_pads - 1}]")
        dups = sorted({_pad_name(mio_pad_names, pad) for pad in pads if pads.count(pad) > 1})
        if dups:
            errors.append(f"MIO {kind} {name} lists the pads {dups} more than once")
        if "default_pad" in periph and periph["default_pad"] not in pads:
            errors.append(f"MIO {kind} {name} has the default pad "
                          f"{_pad_name(mio_pad_names, periph['default_pad'])} which is not one of "
                          "its pads")
        if "default_const" in periph:
            const = periph["default_const"]
            if not const_default:
                errors.append(f"MIO {kind} {name} has the constant default {const!r}. The default "
                              f"of an {kind} must be a pad.")
            elif type(const) is not int or const not in (0, 1):
                errors.append(f"MIO {kind} {name} has the default {const!r}. Expected a pad or the "
                              "constant 0 or 1")


def mio_insel_legal(mio_periph_ins: List[Dict]) -> List[Tuple[str, int]]:
    """Legal MIO_PERIPH_INSEL values as (name, bitmask), one per peripheral input."""
    return [(periph["name"], sum(1 << (pad + INSEL_NUM_CONST) for pad in periph["pads"]) |
             ((1 << INSEL_NUM_CONST) - 1)) for periph in mio_periph_ins]


def mio_outsel_legal(mio_pad_names: List[str],
                     mio_periph_outs: List[Dict]) -> List[Tuple[str, int]]:
    """Legal MIO_OUTSEL values as (pad name, bitmask), one per MIO pad."""
    masks = [(1 << OUTSEL_NUM_CONST) - 1] * len(mio_pad_names)
    for idx, periph in enumerate(mio_periph_outs):
        for pad in periph["pads"]:
            masks[pad] |= 1 << (idx + OUTSEL_NUM_CONST)
    return list(zip(mio_pad_names, masks))


def mio_insel_resvals(mio_periph_ins: List[Dict]) -> List[int]:
    """MIO_PERIPH_INSEL reset values, one per peripheral input. A constant is encoded as is."""
    return [periph["default_pad"] + INSEL_NUM_CONST if "default_pad" in periph else
            periph.get("default_const", INSEL_RESVAL) for periph in mio_periph_ins]


def mio_outsel_resvals(n_mio_pads: int, mio_periph_outs: List[Dict]) -> List[int]:
    """MIO_OUTSEL reset values, one per MIO pad."""
    resvals = [OUTSEL_RESVAL] * n_mio_pads
    for idx, periph in enumerate(mio_periph_outs):
        if "default_pad" in periph:
            resvals[periph["default_pad"]] = idx + OUTSEL_NUM_CONST
    return resvals


def pad_attr_sv(attrs: Dict[str, int]) -> str:
    """Render the attrs of a pad as pad_attr_t constant."""
    members = [f"{PAD_ATTR_FIELDS[field][0]}: {PAD_ATTR_FIELDS[field][1]}'h{value:x}"
               for field, value in attrs.items()]
    return "pad_attr_t'{" + ", ".join(members + ["default: '0"]) + "}"


def render_attr_resval(pad_attrs: List[Tuple[str, Dict]], field: str) -> object:
    """Render the reset value of a pad attribute field, indexed per pad if the pads differ."""
    vals = [attrs.get(field, 0) for _, attrs in pad_attrs]
    return vals[0] if len(set(vals)) == 1 else f'"{vals}[multireg_idx]"'
