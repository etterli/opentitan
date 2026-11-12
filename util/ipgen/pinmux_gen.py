# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Provides support functions for the pinmux ipgen templates.

The templates check their parameter values and derive the pinmux constants with these functions.
See the pinmux tpldesc for the parameters.
"""

from typing import Dict, List, Tuple

from .lib import ParamErrors

# Pad attribute fields a top can define the reset value of per pad, keyed by the
# MIO/DIO_PAD_ATTR CSR field name: (pad_attr_t member, width). All other fields reset to 0.
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


def check_params(n_mio_pads: int, n_dio_pads: int,
                 mio_pad_attr_resvals: List[Tuple[str, Dict]],
                 dio_pad_attr_resvals: List[Tuple[str, Dict]]) -> None:
    """Check the parameter values of the pinmux templates (see the tpldesc). Raises a
    TemplateParamError with all errors found."""
    errors = ParamErrors()
    _check_pad_attrs(errors, "mio_pad_attr_resvals", n_mio_pads, mio_pad_attr_resvals)
    _check_pad_attrs(errors, "dio_pad_attr_resvals", n_dio_pads, dio_pad_attr_resvals)
    errors.raise_errors()


def _check_pad_attrs(errors: ParamErrors, param: str, n_pads: int,
                     pad_attrs: List[Tuple[str, Dict]]) -> None:
    """Check a list of (name, attrs) tuples with one entry per pad."""
    if len(pad_attrs) != n_pads:
        errors.add(f"{param} needs {n_pads} entries, got {len(pad_attrs)}")
    for name, attrs in pad_attrs:
        if not isinstance(attrs, dict):
            errors.add(f"pad attrs of {name} must be a dict, got {attrs!r}")
            continue
        for field, value in attrs.items():
            if field not in PAD_ATTR_FIELDS:
                errors.add(f"pad attrs of {name} has unknown field {field}. "
                           f"Valid fields are {list(PAD_ATTR_FIELDS)}")
                continue
            max_value = (1 << PAD_ATTR_FIELDS[field][1]) - 1
            if type(value) is not int or not 0 <= value <= max_value:
                errors.add(f"pad attrs of {name} has {field}: {value!r}. Expected an int in "
                           f"[0, {max_value}]")


def pad_attr_sv(attrs: Dict[str, int]) -> str:
    """Render the attrs of a pad as pad_attr_t constant."""
    members = [f"{PAD_ATTR_FIELDS[field][0]}: {PAD_ATTR_FIELDS[field][1]}'h{value:x}"
               for field, value in attrs.items()]
    return "pad_attr_t'{" + ", ".join(members + ["default: '0"]) + "}"


def render_attr_resval(pad_attrs: List[Tuple[str, Dict]], field: str) -> object:
    """Render the reset value of a pad attribute field, indexed per pad if the pads differ."""
    vals = [attrs.get(field, 0) for _, attrs in pad_attrs]
    return vals[0] if len(set(vals)) == 1 else f'"{vals}[multireg_idx]"'
