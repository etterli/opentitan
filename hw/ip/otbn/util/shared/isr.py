# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from typing import Dict, Iterable
from serialize.parse_helpers import (check_keys, check_str, check_list,
                                     check_int, check_bool, load_yaml)


class Isr:
    def __init__(self, name: str, address: int,
                 doc: str, read_only: bool, bits: Dict[int, str]) -> None:
        self.name = name
        self.address = address
        self.doc = doc
        self.read_only = read_only
        self.bits = bits

    def access_str(self) -> str:
        return 'RO' if self.read_only else 'RW'

    @staticmethod
    def from_yml(yml: object) -> 'Isr':
        yd = check_keys(yml, 'isr',
                        ['name', 'address', 'doc'],
                        ['read-only', 'bits'])
        name = check_str(yd['name'], 'name')
        address = check_int(yd['address'], 'index/address')
        if address < 0:
            raise ValueError(f'Address of ISR {name:!r} is negative.')
        read_only = check_bool(yd.get('read-only', False), 'read-only flag')
        doc = check_str(yd['doc'], 'documentation')
        pre_bits = yd.get('bits', {})
        if not isinstance(pre_bits, dict):
            raise ValueError(f'bits field of ISR {name:!r} is not a dict.')
        bits = {}  # type: Dict[int, str]
        for idx, desc in pre_bits.items():
            # An entry in the bit section can either describe a single bit or a bit field.
            # A single bit is described as "integer: string".
            # A bit field is described with a range of bits (2:3), a description and optionally a
            # list of allowed values.
            if isinstance(idx, int):
                # We have a single bit
                desc = check_str(desc, f'description of ISR bit {idx}')
            elif isinstance(idx, str) and ':' in idx:
                # We have a bit field. Check if the doc is there. Check the optional list of 
                # values.
                desc = check_keys(desc, f'bit field {idx} of ISR {name!r}',
                                  ['doc'], ['values'])
                # If there is a values section, check it.
                if 'values' in desc:
                    # Check if the values is a dict with integer keys and string descriptions.
                    for k, v in desc['values'].items():
                        check_int(k, f'value index of ISR {name!r} is not an integer.')
                        check_str(v, f'description of value {v} in bit field of ISR {name!r} is '
                                  'not a string.')
            else:
                raise ValueError(f'Invalid bit index {idx!r} in bits section of ISR {name!r}.')
            bits[idx] = desc

        return Isr(name, address, doc, read_only, bits)


def read_isrs(path: str) -> Iterable[Isr]:
    isrs = {}  # type: Dict[int, Isr]
    yml = load_yaml(path, None)
    for isr_yml in check_list(yml, 'contents of ISR file'):
        isr = Isr.from_yml(isr_yml)
        if isr.address in isrs:
            raise ValueError(f'Multiple ISRs at address {isr.address}')
        isrs[isr.address] = isr

    return isrs.values()


class IsrMap:
    def __init__(self, isrs: Dict[str, Isr]):
        self.name_to_isr = isrs
        self.addr_to_isr = {}  # type: Dict[int, Isr]
        for isr in isrs.values():
            if isr.address in self.addr_to_isr:
                raise ValueError(f'Duplicate ISR at address {isr.address:x}')
            self.addr_to_isr[isr.address] = isr


class IsrMaps:
    def __init__(self, csrs: IsrMap, wsrs: IsrMap):
        self.csrs = csrs
        self.wsrs = wsrs
