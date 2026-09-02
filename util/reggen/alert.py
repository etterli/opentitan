# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from typing import Dict, List

from reggen.bits import Bits
from reggen.signal import Signal
from reggen.lib import (PARTITIONS, PART_PRIMARY, check_keys, check_name, check_str, check_list,
                        check_partition)


class Alert(Signal):

    def __init__(self, name: str, desc: str, bit: int, fatal: bool, partition: str):
        super().__init__(name, desc, Bits(bit, bit), partition)
        self.bit = bit
        self.fatal = fatal

    @staticmethod
    def from_raw(what: str, lsb: int, raw: object) -> 'Alert':
        rd = check_keys(raw, what, ['name', 'desc'], ['partition'])

        name = check_name(rd['name'], 'name field of ' + what)
        desc = check_str(rd['desc'], 'desc field of ' + what)
        partition = check_partition(rd.get('partition', PART_PRIMARY),
                                    'partition field of ' + what)

        # Make sense of the alert name, which should be prefixed with recov_ or
        # fatal_.
        pfx = name.split('_')[0]
        if pfx == 'recov':
            fatal = False
        elif pfx == 'fatal':
            fatal = True
        else:
            raise ValueError(
                f'Invalid name field of {what}: alert names must be prefixed '
                f'with "recov_" or "fatal_". Saw {name!r}.')

        return Alert(name, desc, lsb, fatal, partition)

    @staticmethod
    def from_raw_list(what: str, raw: object) -> List['Alert']:
        # Order the alerts by partition, primary first. This is required to
        # guarantee a contiguous bit order. Otherwise, if primary and secondary
        # alerts are mixed in the hjson, there will be bits skipped in the
        # primary alert order.
        # TODO: can this be done in a better way?
        def partition_rank(entry: object) -> int:
            # The partition attribute is an optional key in the alert dict.
            assert isinstance(entry, dict)
            partition = entry.get('partition', PART_PRIMARY)
            return (PARTITIONS.index(partition)
                    if partition in PARTITIONS else len(PARTITIONS))

        ret = []
        for idx, entry in enumerate(sorted(check_list(raw, what),
                                           key=partition_rank)):
            entry_what = 'entry {} of {}'.format(idx, what)
            alert = Alert.from_raw(entry_what, idx, entry)
            ret.append(alert)
        return ret

    def _asdict(self) -> Dict[str, object]:
        ret = {
            'name': self.name,
            'desc': self.desc,
        }
        # TODO: this seems unused. Should we remove it?
        if self.partition != PART_PRIMARY:
            ret['partition'] = self.partition
        return ret
