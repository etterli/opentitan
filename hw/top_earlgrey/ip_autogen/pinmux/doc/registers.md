# Registers

<!-- BEGIN CMDGEN util/regtool.py -d ./hw/top_earlgrey/ip_autogen/pinmux/data/pinmux.hjson -->
## Summary

| Name                                                             | Offset   |   Length | Description                                                         |
|:-----------------------------------------------------------------|:---------|---------:|:--------------------------------------------------------------------|
| pinmux.[`ALERT_TEST`](#alert_test)                               | 0x0      |        4 | Alert Test Register                                                 |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_0`](#mio_periph_insel_regwen)   | 0x4      |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_1`](#mio_periph_insel_regwen)   | 0x8      |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_2`](#mio_periph_insel_regwen)   | 0xc      |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_3`](#mio_periph_insel_regwen)   | 0x10     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_4`](#mio_periph_insel_regwen)   | 0x14     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_5`](#mio_periph_insel_regwen)   | 0x18     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_6`](#mio_periph_insel_regwen)   | 0x1c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_7`](#mio_periph_insel_regwen)   | 0x20     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_8`](#mio_periph_insel_regwen)   | 0x24     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_9`](#mio_periph_insel_regwen)   | 0x28     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_10`](#mio_periph_insel_regwen)  | 0x2c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_11`](#mio_periph_insel_regwen)  | 0x30     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_12`](#mio_periph_insel_regwen)  | 0x34     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_13`](#mio_periph_insel_regwen)  | 0x38     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_14`](#mio_periph_insel_regwen)  | 0x3c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_15`](#mio_periph_insel_regwen)  | 0x40     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_16`](#mio_periph_insel_regwen)  | 0x44     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_17`](#mio_periph_insel_regwen)  | 0x48     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_18`](#mio_periph_insel_regwen)  | 0x4c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_19`](#mio_periph_insel_regwen)  | 0x50     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_20`](#mio_periph_insel_regwen)  | 0x54     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_21`](#mio_periph_insel_regwen)  | 0x58     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_22`](#mio_periph_insel_regwen)  | 0x5c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_23`](#mio_periph_insel_regwen)  | 0x60     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_24`](#mio_periph_insel_regwen)  | 0x64     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_25`](#mio_periph_insel_regwen)  | 0x68     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_26`](#mio_periph_insel_regwen)  | 0x6c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_27`](#mio_periph_insel_regwen)  | 0x70     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_28`](#mio_periph_insel_regwen)  | 0x74     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_29`](#mio_periph_insel_regwen)  | 0x78     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_30`](#mio_periph_insel_regwen)  | 0x7c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_31`](#mio_periph_insel_regwen)  | 0x80     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_32`](#mio_periph_insel_regwen)  | 0x84     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_33`](#mio_periph_insel_regwen)  | 0x88     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_34`](#mio_periph_insel_regwen)  | 0x8c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_35`](#mio_periph_insel_regwen)  | 0x90     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_36`](#mio_periph_insel_regwen)  | 0x94     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_37`](#mio_periph_insel_regwen)  | 0x98     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_38`](#mio_periph_insel_regwen)  | 0x9c     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_39`](#mio_periph_insel_regwen)  | 0xa0     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_40`](#mio_periph_insel_regwen)  | 0xa4     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_41`](#mio_periph_insel_regwen)  | 0xa8     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_42`](#mio_periph_insel_regwen)  | 0xac     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_43`](#mio_periph_insel_regwen)  | 0xb0     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_44`](#mio_periph_insel_regwen)  | 0xb4     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_45`](#mio_periph_insel_regwen)  | 0xb8     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_46`](#mio_periph_insel_regwen)  | 0xbc     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_47`](#mio_periph_insel_regwen)  | 0xc0     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_48`](#mio_periph_insel_regwen)  | 0xc4     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_49`](#mio_periph_insel_regwen)  | 0xc8     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_50`](#mio_periph_insel_regwen)  | 0xcc     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_51`](#mio_periph_insel_regwen)  | 0xd0     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_52`](#mio_periph_insel_regwen)  | 0xd4     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_53`](#mio_periph_insel_regwen)  | 0xd8     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_54`](#mio_periph_insel_regwen)  | 0xdc     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_55`](#mio_periph_insel_regwen)  | 0xe0     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_56`](#mio_periph_insel_regwen)  | 0xe4     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_57`](#mio_periph_insel_regwen)  | 0xe8     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_58`](#mio_periph_insel_regwen)  | 0xec     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_59`](#mio_periph_insel_regwen)  | 0xf0     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_60`](#mio_periph_insel_regwen)  | 0xf4     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_61`](#mio_periph_insel_regwen)  | 0xf8     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_62`](#mio_periph_insel_regwen)  | 0xfc     |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_63`](#mio_periph_insel_regwen)  | 0x100    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_64`](#mio_periph_insel_regwen)  | 0x104    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_65`](#mio_periph_insel_regwen)  | 0x108    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_66`](#mio_periph_insel_regwen)  | 0x10c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_67`](#mio_periph_insel_regwen)  | 0x110    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_68`](#mio_periph_insel_regwen)  | 0x114    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_69`](#mio_periph_insel_regwen)  | 0x118    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_70`](#mio_periph_insel_regwen)  | 0x11c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_71`](#mio_periph_insel_regwen)  | 0x120    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_72`](#mio_periph_insel_regwen)  | 0x124    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_73`](#mio_periph_insel_regwen)  | 0x128    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_74`](#mio_periph_insel_regwen)  | 0x12c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_75`](#mio_periph_insel_regwen)  | 0x130    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_76`](#mio_periph_insel_regwen)  | 0x134    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_77`](#mio_periph_insel_regwen)  | 0x138    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_78`](#mio_periph_insel_regwen)  | 0x13c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_79`](#mio_periph_insel_regwen)  | 0x140    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_80`](#mio_periph_insel_regwen)  | 0x144    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_81`](#mio_periph_insel_regwen)  | 0x148    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_82`](#mio_periph_insel_regwen)  | 0x14c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_83`](#mio_periph_insel_regwen)  | 0x150    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_84`](#mio_periph_insel_regwen)  | 0x154    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_85`](#mio_periph_insel_regwen)  | 0x158    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_86`](#mio_periph_insel_regwen)  | 0x15c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_87`](#mio_periph_insel_regwen)  | 0x160    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_88`](#mio_periph_insel_regwen)  | 0x164    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_89`](#mio_periph_insel_regwen)  | 0x168    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_90`](#mio_periph_insel_regwen)  | 0x16c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_91`](#mio_periph_insel_regwen)  | 0x170    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_92`](#mio_periph_insel_regwen)  | 0x174    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_93`](#mio_periph_insel_regwen)  | 0x178    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_94`](#mio_periph_insel_regwen)  | 0x17c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_95`](#mio_periph_insel_regwen)  | 0x180    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_96`](#mio_periph_insel_regwen)  | 0x184    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_97`](#mio_periph_insel_regwen)  | 0x188    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_98`](#mio_periph_insel_regwen)  | 0x18c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_99`](#mio_periph_insel_regwen)  | 0x190    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_100`](#mio_periph_insel_regwen) | 0x194    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_101`](#mio_periph_insel_regwen) | 0x198    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_102`](#mio_periph_insel_regwen) | 0x19c    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_103`](#mio_periph_insel_regwen) | 0x1a0    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_104`](#mio_periph_insel_regwen) | 0x1a4    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_105`](#mio_periph_insel_regwen) | 0x1a8    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_106`](#mio_periph_insel_regwen) | 0x1ac    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_107`](#mio_periph_insel_regwen) | 0x1b0    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_REGWEN_108`](#mio_periph_insel_regwen) | 0x1b4    |        4 | Register write enable for MIO peripheral input selects.             |
| pinmux.[`MIO_PERIPH_INSEL_0`](#mio_periph_insel)                 | 0x1b8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_1`](#mio_periph_insel)                 | 0x1bc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_2`](#mio_periph_insel)                 | 0x1c0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_3`](#mio_periph_insel)                 | 0x1c4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_4`](#mio_periph_insel)                 | 0x1c8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_5`](#mio_periph_insel)                 | 0x1cc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_6`](#mio_periph_insel)                 | 0x1d0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_7`](#mio_periph_insel)                 | 0x1d4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_8`](#mio_periph_insel)                 | 0x1d8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_9`](#mio_periph_insel)                 | 0x1dc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_10`](#mio_periph_insel)                | 0x1e0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_11`](#mio_periph_insel)                | 0x1e4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_12`](#mio_periph_insel)                | 0x1e8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_13`](#mio_periph_insel)                | 0x1ec    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_14`](#mio_periph_insel)                | 0x1f0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_15`](#mio_periph_insel)                | 0x1f4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_16`](#mio_periph_insel)                | 0x1f8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_17`](#mio_periph_insel)                | 0x1fc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_18`](#mio_periph_insel)                | 0x200    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_19`](#mio_periph_insel)                | 0x204    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_20`](#mio_periph_insel)                | 0x208    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_21`](#mio_periph_insel)                | 0x20c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_22`](#mio_periph_insel)                | 0x210    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_23`](#mio_periph_insel)                | 0x214    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_24`](#mio_periph_insel)                | 0x218    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_25`](#mio_periph_insel)                | 0x21c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_26`](#mio_periph_insel)                | 0x220    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_27`](#mio_periph_insel)                | 0x224    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_28`](#mio_periph_insel)                | 0x228    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_29`](#mio_periph_insel)                | 0x22c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_30`](#mio_periph_insel)                | 0x230    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_31`](#mio_periph_insel)                | 0x234    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_32`](#mio_periph_insel)                | 0x238    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_33`](#mio_periph_insel)                | 0x23c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_34`](#mio_periph_insel)                | 0x240    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_35`](#mio_periph_insel)                | 0x244    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_36`](#mio_periph_insel)                | 0x248    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_37`](#mio_periph_insel)                | 0x24c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_38`](#mio_periph_insel)                | 0x250    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_39`](#mio_periph_insel)                | 0x254    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_40`](#mio_periph_insel)                | 0x258    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_41`](#mio_periph_insel)                | 0x25c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_42`](#mio_periph_insel)                | 0x260    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_43`](#mio_periph_insel)                | 0x264    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_44`](#mio_periph_insel)                | 0x268    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_45`](#mio_periph_insel)                | 0x26c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_46`](#mio_periph_insel)                | 0x270    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_47`](#mio_periph_insel)                | 0x274    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_48`](#mio_periph_insel)                | 0x278    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_49`](#mio_periph_insel)                | 0x27c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_50`](#mio_periph_insel)                | 0x280    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_51`](#mio_periph_insel)                | 0x284    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_52`](#mio_periph_insel)                | 0x288    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_53`](#mio_periph_insel)                | 0x28c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_54`](#mio_periph_insel)                | 0x290    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_55`](#mio_periph_insel)                | 0x294    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_56`](#mio_periph_insel)                | 0x298    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_57`](#mio_periph_insel)                | 0x29c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_58`](#mio_periph_insel)                | 0x2a0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_59`](#mio_periph_insel)                | 0x2a4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_60`](#mio_periph_insel)                | 0x2a8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_61`](#mio_periph_insel)                | 0x2ac    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_62`](#mio_periph_insel)                | 0x2b0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_63`](#mio_periph_insel)                | 0x2b4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_64`](#mio_periph_insel)                | 0x2b8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_65`](#mio_periph_insel)                | 0x2bc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_66`](#mio_periph_insel)                | 0x2c0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_67`](#mio_periph_insel)                | 0x2c4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_68`](#mio_periph_insel)                | 0x2c8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_69`](#mio_periph_insel)                | 0x2cc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_70`](#mio_periph_insel)                | 0x2d0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_71`](#mio_periph_insel)                | 0x2d4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_72`](#mio_periph_insel)                | 0x2d8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_73`](#mio_periph_insel)                | 0x2dc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_74`](#mio_periph_insel)                | 0x2e0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_75`](#mio_periph_insel)                | 0x2e4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_76`](#mio_periph_insel)                | 0x2e8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_77`](#mio_periph_insel)                | 0x2ec    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_78`](#mio_periph_insel)                | 0x2f0    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_79`](#mio_periph_insel)                | 0x2f4    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_80`](#mio_periph_insel)                | 0x2f8    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_81`](#mio_periph_insel)                | 0x2fc    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_82`](#mio_periph_insel)                | 0x300    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_83`](#mio_periph_insel)                | 0x304    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_84`](#mio_periph_insel)                | 0x308    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_85`](#mio_periph_insel)                | 0x30c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_86`](#mio_periph_insel)                | 0x310    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_87`](#mio_periph_insel)                | 0x314    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_88`](#mio_periph_insel)                | 0x318    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_89`](#mio_periph_insel)                | 0x31c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_90`](#mio_periph_insel)                | 0x320    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_91`](#mio_periph_insel)                | 0x324    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_92`](#mio_periph_insel)                | 0x328    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_93`](#mio_periph_insel)                | 0x32c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_94`](#mio_periph_insel)                | 0x330    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_95`](#mio_periph_insel)                | 0x334    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_96`](#mio_periph_insel)                | 0x338    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_97`](#mio_periph_insel)                | 0x33c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_98`](#mio_periph_insel)                | 0x340    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_99`](#mio_periph_insel)                | 0x344    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_100`](#mio_periph_insel)               | 0x348    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_101`](#mio_periph_insel)               | 0x34c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_102`](#mio_periph_insel)               | 0x350    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_103`](#mio_periph_insel)               | 0x354    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_104`](#mio_periph_insel)               | 0x358    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_105`](#mio_periph_insel)               | 0x35c    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_106`](#mio_periph_insel)               | 0x360    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_107`](#mio_periph_insel)               | 0x364    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_PERIPH_INSEL_108`](#mio_periph_insel)               | 0x368    |        4 | For each peripheral input, this selects the muxable pad input.      |
| pinmux.[`MIO_OUTSEL_REGWEN_0`](#mio_outsel_regwen)               | 0x36c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_1`](#mio_outsel_regwen)               | 0x370    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_2`](#mio_outsel_regwen)               | 0x374    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_3`](#mio_outsel_regwen)               | 0x378    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_4`](#mio_outsel_regwen)               | 0x37c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_5`](#mio_outsel_regwen)               | 0x380    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_6`](#mio_outsel_regwen)               | 0x384    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_7`](#mio_outsel_regwen)               | 0x388    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_8`](#mio_outsel_regwen)               | 0x38c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_9`](#mio_outsel_regwen)               | 0x390    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_10`](#mio_outsel_regwen)              | 0x394    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_11`](#mio_outsel_regwen)              | 0x398    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_12`](#mio_outsel_regwen)              | 0x39c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_13`](#mio_outsel_regwen)              | 0x3a0    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_14`](#mio_outsel_regwen)              | 0x3a4    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_15`](#mio_outsel_regwen)              | 0x3a8    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_16`](#mio_outsel_regwen)              | 0x3ac    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_17`](#mio_outsel_regwen)              | 0x3b0    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_18`](#mio_outsel_regwen)              | 0x3b4    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_19`](#mio_outsel_regwen)              | 0x3b8    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_20`](#mio_outsel_regwen)              | 0x3bc    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_21`](#mio_outsel_regwen)              | 0x3c0    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_22`](#mio_outsel_regwen)              | 0x3c4    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_23`](#mio_outsel_regwen)              | 0x3c8    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_24`](#mio_outsel_regwen)              | 0x3cc    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_25`](#mio_outsel_regwen)              | 0x3d0    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_26`](#mio_outsel_regwen)              | 0x3d4    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_27`](#mio_outsel_regwen)              | 0x3d8    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_28`](#mio_outsel_regwen)              | 0x3dc    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_29`](#mio_outsel_regwen)              | 0x3e0    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_30`](#mio_outsel_regwen)              | 0x3e4    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_31`](#mio_outsel_regwen)              | 0x3e8    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_32`](#mio_outsel_regwen)              | 0x3ec    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_33`](#mio_outsel_regwen)              | 0x3f0    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_34`](#mio_outsel_regwen)              | 0x3f4    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_35`](#mio_outsel_regwen)              | 0x3f8    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_36`](#mio_outsel_regwen)              | 0x3fc    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_37`](#mio_outsel_regwen)              | 0x400    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_38`](#mio_outsel_regwen)              | 0x404    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_39`](#mio_outsel_regwen)              | 0x408    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_40`](#mio_outsel_regwen)              | 0x40c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_41`](#mio_outsel_regwen)              | 0x410    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_42`](#mio_outsel_regwen)              | 0x414    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_43`](#mio_outsel_regwen)              | 0x418    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_44`](#mio_outsel_regwen)              | 0x41c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_45`](#mio_outsel_regwen)              | 0x420    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_46`](#mio_outsel_regwen)              | 0x424    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_47`](#mio_outsel_regwen)              | 0x428    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_48`](#mio_outsel_regwen)              | 0x42c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_49`](#mio_outsel_regwen)              | 0x430    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_50`](#mio_outsel_regwen)              | 0x434    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_51`](#mio_outsel_regwen)              | 0x438    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_52`](#mio_outsel_regwen)              | 0x43c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_53`](#mio_outsel_regwen)              | 0x440    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_54`](#mio_outsel_regwen)              | 0x444    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_55`](#mio_outsel_regwen)              | 0x448    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_56`](#mio_outsel_regwen)              | 0x44c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_57`](#mio_outsel_regwen)              | 0x450    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_58`](#mio_outsel_regwen)              | 0x454    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_59`](#mio_outsel_regwen)              | 0x458    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_REGWEN_60`](#mio_outsel_regwen)              | 0x45c    |        4 | Register write enable for MIO output selects.                       |
| pinmux.[`MIO_OUTSEL_0`](#mio_outsel)                             | 0x460    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_1`](#mio_outsel)                             | 0x464    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_2`](#mio_outsel)                             | 0x468    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_3`](#mio_outsel)                             | 0x46c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_4`](#mio_outsel)                             | 0x470    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_5`](#mio_outsel)                             | 0x474    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_6`](#mio_outsel)                             | 0x478    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_7`](#mio_outsel)                             | 0x47c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_8`](#mio_outsel)                             | 0x480    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_9`](#mio_outsel)                             | 0x484    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_10`](#mio_outsel)                            | 0x488    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_11`](#mio_outsel)                            | 0x48c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_12`](#mio_outsel)                            | 0x490    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_13`](#mio_outsel)                            | 0x494    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_14`](#mio_outsel)                            | 0x498    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_15`](#mio_outsel)                            | 0x49c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_16`](#mio_outsel)                            | 0x4a0    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_17`](#mio_outsel)                            | 0x4a4    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_18`](#mio_outsel)                            | 0x4a8    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_19`](#mio_outsel)                            | 0x4ac    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_20`](#mio_outsel)                            | 0x4b0    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_21`](#mio_outsel)                            | 0x4b4    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_22`](#mio_outsel)                            | 0x4b8    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_23`](#mio_outsel)                            | 0x4bc    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_24`](#mio_outsel)                            | 0x4c0    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_25`](#mio_outsel)                            | 0x4c4    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_26`](#mio_outsel)                            | 0x4c8    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_27`](#mio_outsel)                            | 0x4cc    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_28`](#mio_outsel)                            | 0x4d0    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_29`](#mio_outsel)                            | 0x4d4    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_30`](#mio_outsel)                            | 0x4d8    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_31`](#mio_outsel)                            | 0x4dc    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_32`](#mio_outsel)                            | 0x4e0    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_33`](#mio_outsel)                            | 0x4e4    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_34`](#mio_outsel)                            | 0x4e8    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_35`](#mio_outsel)                            | 0x4ec    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_36`](#mio_outsel)                            | 0x4f0    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_37`](#mio_outsel)                            | 0x4f4    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_38`](#mio_outsel)                            | 0x4f8    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_39`](#mio_outsel)                            | 0x4fc    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_40`](#mio_outsel)                            | 0x500    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_41`](#mio_outsel)                            | 0x504    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_42`](#mio_outsel)                            | 0x508    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_43`](#mio_outsel)                            | 0x50c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_44`](#mio_outsel)                            | 0x510    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_45`](#mio_outsel)                            | 0x514    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_46`](#mio_outsel)                            | 0x518    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_47`](#mio_outsel)                            | 0x51c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_48`](#mio_outsel)                            | 0x520    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_49`](#mio_outsel)                            | 0x524    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_50`](#mio_outsel)                            | 0x528    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_51`](#mio_outsel)                            | 0x52c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_52`](#mio_outsel)                            | 0x530    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_53`](#mio_outsel)                            | 0x534    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_54`](#mio_outsel)                            | 0x538    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_55`](#mio_outsel)                            | 0x53c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_56`](#mio_outsel)                            | 0x540    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_57`](#mio_outsel)                            | 0x544    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_58`](#mio_outsel)                            | 0x548    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_59`](#mio_outsel)                            | 0x54c    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_OUTSEL_60`](#mio_outsel)                            | 0x550    |        4 | For each muxable pad, this selects the peripheral output.           |
| pinmux.[`MIO_PAD_ATTR_REGWEN_0`](#mio_pad_attr_regwen)           | 0x554    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_1`](#mio_pad_attr_regwen)           | 0x558    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_2`](#mio_pad_attr_regwen)           | 0x55c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_3`](#mio_pad_attr_regwen)           | 0x560    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_4`](#mio_pad_attr_regwen)           | 0x564    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_5`](#mio_pad_attr_regwen)           | 0x568    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_6`](#mio_pad_attr_regwen)           | 0x56c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_7`](#mio_pad_attr_regwen)           | 0x570    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_8`](#mio_pad_attr_regwen)           | 0x574    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_9`](#mio_pad_attr_regwen)           | 0x578    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_10`](#mio_pad_attr_regwen)          | 0x57c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_11`](#mio_pad_attr_regwen)          | 0x580    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_12`](#mio_pad_attr_regwen)          | 0x584    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_13`](#mio_pad_attr_regwen)          | 0x588    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_14`](#mio_pad_attr_regwen)          | 0x58c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_15`](#mio_pad_attr_regwen)          | 0x590    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_16`](#mio_pad_attr_regwen)          | 0x594    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_17`](#mio_pad_attr_regwen)          | 0x598    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_18`](#mio_pad_attr_regwen)          | 0x59c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_19`](#mio_pad_attr_regwen)          | 0x5a0    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_20`](#mio_pad_attr_regwen)          | 0x5a4    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_21`](#mio_pad_attr_regwen)          | 0x5a8    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_22`](#mio_pad_attr_regwen)          | 0x5ac    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_23`](#mio_pad_attr_regwen)          | 0x5b0    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_24`](#mio_pad_attr_regwen)          | 0x5b4    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_25`](#mio_pad_attr_regwen)          | 0x5b8    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_26`](#mio_pad_attr_regwen)          | 0x5bc    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_27`](#mio_pad_attr_regwen)          | 0x5c0    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_28`](#mio_pad_attr_regwen)          | 0x5c4    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_29`](#mio_pad_attr_regwen)          | 0x5c8    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_30`](#mio_pad_attr_regwen)          | 0x5cc    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_31`](#mio_pad_attr_regwen)          | 0x5d0    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_32`](#mio_pad_attr_regwen)          | 0x5d4    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_33`](#mio_pad_attr_regwen)          | 0x5d8    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_34`](#mio_pad_attr_regwen)          | 0x5dc    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_35`](#mio_pad_attr_regwen)          | 0x5e0    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_36`](#mio_pad_attr_regwen)          | 0x5e4    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_37`](#mio_pad_attr_regwen)          | 0x5e8    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_38`](#mio_pad_attr_regwen)          | 0x5ec    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_39`](#mio_pad_attr_regwen)          | 0x5f0    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_40`](#mio_pad_attr_regwen)          | 0x5f4    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_41`](#mio_pad_attr_regwen)          | 0x5f8    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_42`](#mio_pad_attr_regwen)          | 0x5fc    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_43`](#mio_pad_attr_regwen)          | 0x600    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_44`](#mio_pad_attr_regwen)          | 0x604    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_45`](#mio_pad_attr_regwen)          | 0x608    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_46`](#mio_pad_attr_regwen)          | 0x60c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_47`](#mio_pad_attr_regwen)          | 0x610    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_48`](#mio_pad_attr_regwen)          | 0x614    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_49`](#mio_pad_attr_regwen)          | 0x618    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_50`](#mio_pad_attr_regwen)          | 0x61c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_51`](#mio_pad_attr_regwen)          | 0x620    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_52`](#mio_pad_attr_regwen)          | 0x624    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_53`](#mio_pad_attr_regwen)          | 0x628    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_54`](#mio_pad_attr_regwen)          | 0x62c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_55`](#mio_pad_attr_regwen)          | 0x630    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_56`](#mio_pad_attr_regwen)          | 0x634    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_57`](#mio_pad_attr_regwen)          | 0x638    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_58`](#mio_pad_attr_regwen)          | 0x63c    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_59`](#mio_pad_attr_regwen)          | 0x640    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_REGWEN_60`](#mio_pad_attr_regwen)          | 0x644    |        4 | Register write enable for MIO PAD attributes.                       |
| pinmux.[`MIO_PAD_ATTR_0`](#mio_pad_attr)                         | 0x648    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_1`](#mio_pad_attr)                         | 0x64c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_2`](#mio_pad_attr)                         | 0x650    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_3`](#mio_pad_attr)                         | 0x654    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_4`](#mio_pad_attr)                         | 0x658    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_5`](#mio_pad_attr)                         | 0x65c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_6`](#mio_pad_attr)                         | 0x660    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_7`](#mio_pad_attr)                         | 0x664    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_8`](#mio_pad_attr)                         | 0x668    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_9`](#mio_pad_attr)                         | 0x66c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_10`](#mio_pad_attr)                        | 0x670    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_11`](#mio_pad_attr)                        | 0x674    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_12`](#mio_pad_attr)                        | 0x678    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_13`](#mio_pad_attr)                        | 0x67c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_14`](#mio_pad_attr)                        | 0x680    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_15`](#mio_pad_attr)                        | 0x684    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_16`](#mio_pad_attr)                        | 0x688    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_17`](#mio_pad_attr)                        | 0x68c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_18`](#mio_pad_attr)                        | 0x690    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_19`](#mio_pad_attr)                        | 0x694    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_20`](#mio_pad_attr)                        | 0x698    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_21`](#mio_pad_attr)                        | 0x69c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_22`](#mio_pad_attr)                        | 0x6a0    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_23`](#mio_pad_attr)                        | 0x6a4    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_24`](#mio_pad_attr)                        | 0x6a8    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_25`](#mio_pad_attr)                        | 0x6ac    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_26`](#mio_pad_attr)                        | 0x6b0    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_27`](#mio_pad_attr)                        | 0x6b4    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_28`](#mio_pad_attr)                        | 0x6b8    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_29`](#mio_pad_attr)                        | 0x6bc    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_30`](#mio_pad_attr)                        | 0x6c0    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_31`](#mio_pad_attr)                        | 0x6c4    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_32`](#mio_pad_attr)                        | 0x6c8    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_33`](#mio_pad_attr)                        | 0x6cc    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_34`](#mio_pad_attr)                        | 0x6d0    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_35`](#mio_pad_attr)                        | 0x6d4    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_36`](#mio_pad_attr)                        | 0x6d8    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_37`](#mio_pad_attr)                        | 0x6dc    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_38`](#mio_pad_attr)                        | 0x6e0    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_39`](#mio_pad_attr)                        | 0x6e4    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_40`](#mio_pad_attr)                        | 0x6e8    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_41`](#mio_pad_attr)                        | 0x6ec    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_42`](#mio_pad_attr)                        | 0x6f0    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_43`](#mio_pad_attr)                        | 0x6f4    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_44`](#mio_pad_attr)                        | 0x6f8    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_45`](#mio_pad_attr)                        | 0x6fc    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_46`](#mio_pad_attr)                        | 0x700    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_47`](#mio_pad_attr)                        | 0x704    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_48`](#mio_pad_attr)                        | 0x708    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_49`](#mio_pad_attr)                        | 0x70c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_50`](#mio_pad_attr)                        | 0x710    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_51`](#mio_pad_attr)                        | 0x714    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_52`](#mio_pad_attr)                        | 0x718    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_53`](#mio_pad_attr)                        | 0x71c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_54`](#mio_pad_attr)                        | 0x720    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_55`](#mio_pad_attr)                        | 0x724    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_56`](#mio_pad_attr)                        | 0x728    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_57`](#mio_pad_attr)                        | 0x72c    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_58`](#mio_pad_attr)                        | 0x730    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_59`](#mio_pad_attr)                        | 0x734    |        4 | Muxed pad attributes.                                               |
| pinmux.[`MIO_PAD_ATTR_60`](#mio_pad_attr)                        | 0x738    |        4 | Muxed pad attributes.                                               |
| pinmux.[`DIO_PAD_ATTR_REGWEN_0`](#dio_pad_attr_regwen)           | 0x73c    |        4 | Register write enable for DIO PAD attributes.                       |
| pinmux.[`DIO_PAD_ATTR_REGWEN_1`](#dio_pad_attr_regwen)           | 0x740    |        4 | Register write enable for DIO PAD attributes.                       |
| pinmux.[`DIO_PAD_ATTR_0`](#dio_pad_attr)                         | 0x744    |        4 | Dedicated pad attributes.                                           |
| pinmux.[`DIO_PAD_ATTR_1`](#dio_pad_attr)                         | 0x748    |        4 | Dedicated pad attributes.                                           |
| pinmux.[`MIO_PAD_SLEEP_STATUS_0`](#mio_pad_sleep_status_0)       | 0x74c    |        4 | Register indicating whether the corresponding pad is in sleep mode. |
| pinmux.[`MIO_PAD_SLEEP_STATUS_1`](#mio_pad_sleep_status_1)       | 0x750    |        4 | Register indicating whether the corresponding pad is in sleep mode. |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_0`](#mio_pad_sleep_regwen)         | 0x754    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_1`](#mio_pad_sleep_regwen)         | 0x758    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_2`](#mio_pad_sleep_regwen)         | 0x75c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_3`](#mio_pad_sleep_regwen)         | 0x760    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_4`](#mio_pad_sleep_regwen)         | 0x764    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_5`](#mio_pad_sleep_regwen)         | 0x768    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_6`](#mio_pad_sleep_regwen)         | 0x76c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_7`](#mio_pad_sleep_regwen)         | 0x770    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_8`](#mio_pad_sleep_regwen)         | 0x774    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_9`](#mio_pad_sleep_regwen)         | 0x778    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_10`](#mio_pad_sleep_regwen)        | 0x77c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_11`](#mio_pad_sleep_regwen)        | 0x780    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_12`](#mio_pad_sleep_regwen)        | 0x784    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_13`](#mio_pad_sleep_regwen)        | 0x788    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_14`](#mio_pad_sleep_regwen)        | 0x78c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_15`](#mio_pad_sleep_regwen)        | 0x790    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_16`](#mio_pad_sleep_regwen)        | 0x794    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_17`](#mio_pad_sleep_regwen)        | 0x798    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_18`](#mio_pad_sleep_regwen)        | 0x79c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_19`](#mio_pad_sleep_regwen)        | 0x7a0    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_20`](#mio_pad_sleep_regwen)        | 0x7a4    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_21`](#mio_pad_sleep_regwen)        | 0x7a8    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_22`](#mio_pad_sleep_regwen)        | 0x7ac    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_23`](#mio_pad_sleep_regwen)        | 0x7b0    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_24`](#mio_pad_sleep_regwen)        | 0x7b4    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_25`](#mio_pad_sleep_regwen)        | 0x7b8    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_26`](#mio_pad_sleep_regwen)        | 0x7bc    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_27`](#mio_pad_sleep_regwen)        | 0x7c0    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_28`](#mio_pad_sleep_regwen)        | 0x7c4    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_29`](#mio_pad_sleep_regwen)        | 0x7c8    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_30`](#mio_pad_sleep_regwen)        | 0x7cc    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_31`](#mio_pad_sleep_regwen)        | 0x7d0    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_32`](#mio_pad_sleep_regwen)        | 0x7d4    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_33`](#mio_pad_sleep_regwen)        | 0x7d8    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_34`](#mio_pad_sleep_regwen)        | 0x7dc    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_35`](#mio_pad_sleep_regwen)        | 0x7e0    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_36`](#mio_pad_sleep_regwen)        | 0x7e4    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_37`](#mio_pad_sleep_regwen)        | 0x7e8    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_38`](#mio_pad_sleep_regwen)        | 0x7ec    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_39`](#mio_pad_sleep_regwen)        | 0x7f0    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_40`](#mio_pad_sleep_regwen)        | 0x7f4    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_41`](#mio_pad_sleep_regwen)        | 0x7f8    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_42`](#mio_pad_sleep_regwen)        | 0x7fc    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_43`](#mio_pad_sleep_regwen)        | 0x800    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_44`](#mio_pad_sleep_regwen)        | 0x804    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_45`](#mio_pad_sleep_regwen)        | 0x808    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_46`](#mio_pad_sleep_regwen)        | 0x80c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_47`](#mio_pad_sleep_regwen)        | 0x810    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_48`](#mio_pad_sleep_regwen)        | 0x814    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_49`](#mio_pad_sleep_regwen)        | 0x818    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_50`](#mio_pad_sleep_regwen)        | 0x81c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_51`](#mio_pad_sleep_regwen)        | 0x820    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_52`](#mio_pad_sleep_regwen)        | 0x824    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_53`](#mio_pad_sleep_regwen)        | 0x828    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_54`](#mio_pad_sleep_regwen)        | 0x82c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_55`](#mio_pad_sleep_regwen)        | 0x830    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_56`](#mio_pad_sleep_regwen)        | 0x834    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_57`](#mio_pad_sleep_regwen)        | 0x838    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_58`](#mio_pad_sleep_regwen)        | 0x83c    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_59`](#mio_pad_sleep_regwen)        | 0x840    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_REGWEN_60`](#mio_pad_sleep_regwen)        | 0x844    |        4 | Register write enable for MIO sleep value configuration.            |
| pinmux.[`MIO_PAD_SLEEP_EN_0`](#mio_pad_sleep_en)                 | 0x848    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_1`](#mio_pad_sleep_en)                 | 0x84c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_2`](#mio_pad_sleep_en)                 | 0x850    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_3`](#mio_pad_sleep_en)                 | 0x854    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_4`](#mio_pad_sleep_en)                 | 0x858    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_5`](#mio_pad_sleep_en)                 | 0x85c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_6`](#mio_pad_sleep_en)                 | 0x860    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_7`](#mio_pad_sleep_en)                 | 0x864    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_8`](#mio_pad_sleep_en)                 | 0x868    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_9`](#mio_pad_sleep_en)                 | 0x86c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_10`](#mio_pad_sleep_en)                | 0x870    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_11`](#mio_pad_sleep_en)                | 0x874    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_12`](#mio_pad_sleep_en)                | 0x878    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_13`](#mio_pad_sleep_en)                | 0x87c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_14`](#mio_pad_sleep_en)                | 0x880    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_15`](#mio_pad_sleep_en)                | 0x884    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_16`](#mio_pad_sleep_en)                | 0x888    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_17`](#mio_pad_sleep_en)                | 0x88c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_18`](#mio_pad_sleep_en)                | 0x890    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_19`](#mio_pad_sleep_en)                | 0x894    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_20`](#mio_pad_sleep_en)                | 0x898    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_21`](#mio_pad_sleep_en)                | 0x89c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_22`](#mio_pad_sleep_en)                | 0x8a0    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_23`](#mio_pad_sleep_en)                | 0x8a4    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_24`](#mio_pad_sleep_en)                | 0x8a8    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_25`](#mio_pad_sleep_en)                | 0x8ac    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_26`](#mio_pad_sleep_en)                | 0x8b0    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_27`](#mio_pad_sleep_en)                | 0x8b4    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_28`](#mio_pad_sleep_en)                | 0x8b8    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_29`](#mio_pad_sleep_en)                | 0x8bc    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_30`](#mio_pad_sleep_en)                | 0x8c0    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_31`](#mio_pad_sleep_en)                | 0x8c4    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_32`](#mio_pad_sleep_en)                | 0x8c8    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_33`](#mio_pad_sleep_en)                | 0x8cc    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_34`](#mio_pad_sleep_en)                | 0x8d0    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_35`](#mio_pad_sleep_en)                | 0x8d4    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_36`](#mio_pad_sleep_en)                | 0x8d8    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_37`](#mio_pad_sleep_en)                | 0x8dc    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_38`](#mio_pad_sleep_en)                | 0x8e0    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_39`](#mio_pad_sleep_en)                | 0x8e4    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_40`](#mio_pad_sleep_en)                | 0x8e8    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_41`](#mio_pad_sleep_en)                | 0x8ec    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_42`](#mio_pad_sleep_en)                | 0x8f0    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_43`](#mio_pad_sleep_en)                | 0x8f4    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_44`](#mio_pad_sleep_en)                | 0x8f8    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_45`](#mio_pad_sleep_en)                | 0x8fc    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_46`](#mio_pad_sleep_en)                | 0x900    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_47`](#mio_pad_sleep_en)                | 0x904    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_48`](#mio_pad_sleep_en)                | 0x908    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_49`](#mio_pad_sleep_en)                | 0x90c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_50`](#mio_pad_sleep_en)                | 0x910    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_51`](#mio_pad_sleep_en)                | 0x914    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_52`](#mio_pad_sleep_en)                | 0x918    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_53`](#mio_pad_sleep_en)                | 0x91c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_54`](#mio_pad_sleep_en)                | 0x920    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_55`](#mio_pad_sleep_en)                | 0x924    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_56`](#mio_pad_sleep_en)                | 0x928    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_57`](#mio_pad_sleep_en)                | 0x92c    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_58`](#mio_pad_sleep_en)                | 0x930    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_59`](#mio_pad_sleep_en)                | 0x934    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_EN_60`](#mio_pad_sleep_en)                | 0x938    |        4 | Enables the sleep mode of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_0`](#mio_pad_sleep_mode)             | 0x93c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_1`](#mio_pad_sleep_mode)             | 0x940    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_2`](#mio_pad_sleep_mode)             | 0x944    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_3`](#mio_pad_sleep_mode)             | 0x948    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_4`](#mio_pad_sleep_mode)             | 0x94c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_5`](#mio_pad_sleep_mode)             | 0x950    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_6`](#mio_pad_sleep_mode)             | 0x954    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_7`](#mio_pad_sleep_mode)             | 0x958    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_8`](#mio_pad_sleep_mode)             | 0x95c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_9`](#mio_pad_sleep_mode)             | 0x960    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_10`](#mio_pad_sleep_mode)            | 0x964    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_11`](#mio_pad_sleep_mode)            | 0x968    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_12`](#mio_pad_sleep_mode)            | 0x96c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_13`](#mio_pad_sleep_mode)            | 0x970    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_14`](#mio_pad_sleep_mode)            | 0x974    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_15`](#mio_pad_sleep_mode)            | 0x978    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_16`](#mio_pad_sleep_mode)            | 0x97c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_17`](#mio_pad_sleep_mode)            | 0x980    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_18`](#mio_pad_sleep_mode)            | 0x984    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_19`](#mio_pad_sleep_mode)            | 0x988    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_20`](#mio_pad_sleep_mode)            | 0x98c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_21`](#mio_pad_sleep_mode)            | 0x990    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_22`](#mio_pad_sleep_mode)            | 0x994    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_23`](#mio_pad_sleep_mode)            | 0x998    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_24`](#mio_pad_sleep_mode)            | 0x99c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_25`](#mio_pad_sleep_mode)            | 0x9a0    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_26`](#mio_pad_sleep_mode)            | 0x9a4    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_27`](#mio_pad_sleep_mode)            | 0x9a8    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_28`](#mio_pad_sleep_mode)            | 0x9ac    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_29`](#mio_pad_sleep_mode)            | 0x9b0    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_30`](#mio_pad_sleep_mode)            | 0x9b4    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_31`](#mio_pad_sleep_mode)            | 0x9b8    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_32`](#mio_pad_sleep_mode)            | 0x9bc    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_33`](#mio_pad_sleep_mode)            | 0x9c0    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_34`](#mio_pad_sleep_mode)            | 0x9c4    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_35`](#mio_pad_sleep_mode)            | 0x9c8    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_36`](#mio_pad_sleep_mode)            | 0x9cc    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_37`](#mio_pad_sleep_mode)            | 0x9d0    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_38`](#mio_pad_sleep_mode)            | 0x9d4    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_39`](#mio_pad_sleep_mode)            | 0x9d8    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_40`](#mio_pad_sleep_mode)            | 0x9dc    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_41`](#mio_pad_sleep_mode)            | 0x9e0    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_42`](#mio_pad_sleep_mode)            | 0x9e4    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_43`](#mio_pad_sleep_mode)            | 0x9e8    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_44`](#mio_pad_sleep_mode)            | 0x9ec    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_45`](#mio_pad_sleep_mode)            | 0x9f0    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_46`](#mio_pad_sleep_mode)            | 0x9f4    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_47`](#mio_pad_sleep_mode)            | 0x9f8    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_48`](#mio_pad_sleep_mode)            | 0x9fc    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_49`](#mio_pad_sleep_mode)            | 0xa00    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_50`](#mio_pad_sleep_mode)            | 0xa04    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_51`](#mio_pad_sleep_mode)            | 0xa08    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_52`](#mio_pad_sleep_mode)            | 0xa0c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_53`](#mio_pad_sleep_mode)            | 0xa10    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_54`](#mio_pad_sleep_mode)            | 0xa14    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_55`](#mio_pad_sleep_mode)            | 0xa18    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_56`](#mio_pad_sleep_mode)            | 0xa1c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_57`](#mio_pad_sleep_mode)            | 0xa20    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_58`](#mio_pad_sleep_mode)            | 0xa24    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_59`](#mio_pad_sleep_mode)            | 0xa28    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`MIO_PAD_SLEEP_MODE_60`](#mio_pad_sleep_mode)            | 0xa2c    |        4 | Defines sleep behavior of the corresponding muxed pad.              |
| pinmux.[`DIO_PAD_SLEEP_STATUS`](#dio_pad_sleep_status)           | 0xa30    |        4 | Register indicating whether the corresponding pad is in sleep mode. |
| pinmux.[`DIO_PAD_SLEEP_REGWEN_0`](#dio_pad_sleep_regwen)         | 0xa34    |        4 | Register write enable for DIO sleep value configuration.            |
| pinmux.[`DIO_PAD_SLEEP_REGWEN_1`](#dio_pad_sleep_regwen)         | 0xa38    |        4 | Register write enable for DIO sleep value configuration.            |
| pinmux.[`DIO_PAD_SLEEP_EN_0`](#dio_pad_sleep_en)                 | 0xa3c    |        4 | Enables the sleep mode of the corresponding dedicated pad.          |
| pinmux.[`DIO_PAD_SLEEP_EN_1`](#dio_pad_sleep_en)                 | 0xa40    |        4 | Enables the sleep mode of the corresponding dedicated pad.          |
| pinmux.[`DIO_PAD_SLEEP_MODE_0`](#dio_pad_sleep_mode)             | 0xa44    |        4 | Defines sleep behavior of the corresponding dedicated pad.          |
| pinmux.[`DIO_PAD_SLEEP_MODE_1`](#dio_pad_sleep_mode)             | 0xa48    |        4 | Defines sleep behavior of the corresponding dedicated pad.          |
| pinmux.[`WKUP_DETECTOR_REGWEN_0`](#wkup_detector_regwen)         | 0xa4c    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_REGWEN_1`](#wkup_detector_regwen)         | 0xa50    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_REGWEN_2`](#wkup_detector_regwen)         | 0xa54    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_REGWEN_3`](#wkup_detector_regwen)         | 0xa58    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_REGWEN_4`](#wkup_detector_regwen)         | 0xa5c    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_REGWEN_5`](#wkup_detector_regwen)         | 0xa60    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_REGWEN_6`](#wkup_detector_regwen)         | 0xa64    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_REGWEN_7`](#wkup_detector_regwen)         | 0xa68    |        4 | Register write enable for wakeup detectors.                         |
| pinmux.[`WKUP_DETECTOR_EN_0`](#wkup_detector_en)                 | 0xa6c    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_EN_1`](#wkup_detector_en)                 | 0xa70    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_EN_2`](#wkup_detector_en)                 | 0xa74    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_EN_3`](#wkup_detector_en)                 | 0xa78    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_EN_4`](#wkup_detector_en)                 | 0xa7c    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_EN_5`](#wkup_detector_en)                 | 0xa80    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_EN_6`](#wkup_detector_en)                 | 0xa84    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_EN_7`](#wkup_detector_en)                 | 0xa88    |        4 | Enables for the wakeup detectors.                                   |
| pinmux.[`WKUP_DETECTOR_0`](#wkup_detector)                       | 0xa8c    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_1`](#wkup_detector)                       | 0xa90    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_2`](#wkup_detector)                       | 0xa94    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_3`](#wkup_detector)                       | 0xa98    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_4`](#wkup_detector)                       | 0xa9c    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_5`](#wkup_detector)                       | 0xaa0    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_6`](#wkup_detector)                       | 0xaa4    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_7`](#wkup_detector)                       | 0xaa8    |        4 | Configuration of wakeup condition detectors.                        |
| pinmux.[`WKUP_DETECTOR_CNT_TH_0`](#wkup_detector_cnt_th)         | 0xaac    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_CNT_TH_1`](#wkup_detector_cnt_th)         | 0xab0    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_CNT_TH_2`](#wkup_detector_cnt_th)         | 0xab4    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_CNT_TH_3`](#wkup_detector_cnt_th)         | 0xab8    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_CNT_TH_4`](#wkup_detector_cnt_th)         | 0xabc    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_CNT_TH_5`](#wkup_detector_cnt_th)         | 0xac0    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_CNT_TH_6`](#wkup_detector_cnt_th)         | 0xac4    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_CNT_TH_7`](#wkup_detector_cnt_th)         | 0xac8    |        4 | Counter thresholds for wakeup condition detectors.                  |
| pinmux.[`WKUP_DETECTOR_PADSEL_0`](#wkup_detector_padsel)         | 0xacc    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_DETECTOR_PADSEL_1`](#wkup_detector_padsel)         | 0xad0    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_DETECTOR_PADSEL_2`](#wkup_detector_padsel)         | 0xad4    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_DETECTOR_PADSEL_3`](#wkup_detector_padsel)         | 0xad8    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_DETECTOR_PADSEL_4`](#wkup_detector_padsel)         | 0xadc    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_DETECTOR_PADSEL_5`](#wkup_detector_padsel)         | 0xae0    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_DETECTOR_PADSEL_6`](#wkup_detector_padsel)         | 0xae4    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_DETECTOR_PADSEL_7`](#wkup_detector_padsel)         | 0xae8    |        4 | Pad selects for pad wakeup condition detectors.                     |
| pinmux.[`WKUP_CAUSE`](#wkup_cause)                               | 0xaec    |        4 | Cause registers for wakeup detectors.                               |

## ALERT_TEST
Alert Test Register
- Offset: `0x0`
- Reset default: `0x80000000`
- Reset mask: `0x80000001`

### Fields

```wavejson
{"reg": [{"name": "fatal_fault", "bits": 1, "attr": ["wo"], "rotate": -90}, {"bits": 30}, {"name": "regwen", "bits": 1, "attr": ["rw0c"], "rotate": -90}], "config": {"lanes": 1, "fontsize": 10, "vspace": 130}}
```

|  Bits  |  Type  |  Reset  | Name        | Description                                            |
|:------:|:------:|:-------:|:------------|:-------------------------------------------------------|
|   31   |  rw0c  |   0x1   | regwen      | Write 0 to disable alert testing until the next reset. |
|  30:1  |        |         |             | Reserved                                               |
|   0    |   wo   |   0x0   | fatal_fault | Write 1 to trigger one alert event of this kind.       |

## MIO_PERIPH_INSEL_REGWEN
Register write enable for MIO peripheral input selects.
- Reset default: `0x1`
- Reset mask: `0x1`

### Instances

| Name                        | Offset   |
|:----------------------------|:---------|
| MIO_PERIPH_INSEL_REGWEN_0   | 0x4      |
| MIO_PERIPH_INSEL_REGWEN_1   | 0x8      |
| MIO_PERIPH_INSEL_REGWEN_2   | 0xc      |
| MIO_PERIPH_INSEL_REGWEN_3   | 0x10     |
| MIO_PERIPH_INSEL_REGWEN_4   | 0x14     |
| MIO_PERIPH_INSEL_REGWEN_5   | 0x18     |
| MIO_PERIPH_INSEL_REGWEN_6   | 0x1c     |
| MIO_PERIPH_INSEL_REGWEN_7   | 0x20     |
| MIO_PERIPH_INSEL_REGWEN_8   | 0x24     |
| MIO_PERIPH_INSEL_REGWEN_9   | 0x28     |
| MIO_PERIPH_INSEL_REGWEN_10  | 0x2c     |
| MIO_PERIPH_INSEL_REGWEN_11  | 0x30     |
| MIO_PERIPH_INSEL_REGWEN_12  | 0x34     |
| MIO_PERIPH_INSEL_REGWEN_13  | 0x38     |
| MIO_PERIPH_INSEL_REGWEN_14  | 0x3c     |
| MIO_PERIPH_INSEL_REGWEN_15  | 0x40     |
| MIO_PERIPH_INSEL_REGWEN_16  | 0x44     |
| MIO_PERIPH_INSEL_REGWEN_17  | 0x48     |
| MIO_PERIPH_INSEL_REGWEN_18  | 0x4c     |
| MIO_PERIPH_INSEL_REGWEN_19  | 0x50     |
| MIO_PERIPH_INSEL_REGWEN_20  | 0x54     |
| MIO_PERIPH_INSEL_REGWEN_21  | 0x58     |
| MIO_PERIPH_INSEL_REGWEN_22  | 0x5c     |
| MIO_PERIPH_INSEL_REGWEN_23  | 0x60     |
| MIO_PERIPH_INSEL_REGWEN_24  | 0x64     |
| MIO_PERIPH_INSEL_REGWEN_25  | 0x68     |
| MIO_PERIPH_INSEL_REGWEN_26  | 0x6c     |
| MIO_PERIPH_INSEL_REGWEN_27  | 0x70     |
| MIO_PERIPH_INSEL_REGWEN_28  | 0x74     |
| MIO_PERIPH_INSEL_REGWEN_29  | 0x78     |
| MIO_PERIPH_INSEL_REGWEN_30  | 0x7c     |
| MIO_PERIPH_INSEL_REGWEN_31  | 0x80     |
| MIO_PERIPH_INSEL_REGWEN_32  | 0x84     |
| MIO_PERIPH_INSEL_REGWEN_33  | 0x88     |
| MIO_PERIPH_INSEL_REGWEN_34  | 0x8c     |
| MIO_PERIPH_INSEL_REGWEN_35  | 0x90     |
| MIO_PERIPH_INSEL_REGWEN_36  | 0x94     |
| MIO_PERIPH_INSEL_REGWEN_37  | 0x98     |
| MIO_PERIPH_INSEL_REGWEN_38  | 0x9c     |
| MIO_PERIPH_INSEL_REGWEN_39  | 0xa0     |
| MIO_PERIPH_INSEL_REGWEN_40  | 0xa4     |
| MIO_PERIPH_INSEL_REGWEN_41  | 0xa8     |
| MIO_PERIPH_INSEL_REGWEN_42  | 0xac     |
| MIO_PERIPH_INSEL_REGWEN_43  | 0xb0     |
| MIO_PERIPH_INSEL_REGWEN_44  | 0xb4     |
| MIO_PERIPH_INSEL_REGWEN_45  | 0xb8     |
| MIO_PERIPH_INSEL_REGWEN_46  | 0xbc     |
| MIO_PERIPH_INSEL_REGWEN_47  | 0xc0     |
| MIO_PERIPH_INSEL_REGWEN_48  | 0xc4     |
| MIO_PERIPH_INSEL_REGWEN_49  | 0xc8     |
| MIO_PERIPH_INSEL_REGWEN_50  | 0xcc     |
| MIO_PERIPH_INSEL_REGWEN_51  | 0xd0     |
| MIO_PERIPH_INSEL_REGWEN_52  | 0xd4     |
| MIO_PERIPH_INSEL_REGWEN_53  | 0xd8     |
| MIO_PERIPH_INSEL_REGWEN_54  | 0xdc     |
| MIO_PERIPH_INSEL_REGWEN_55  | 0xe0     |
| MIO_PERIPH_INSEL_REGWEN_56  | 0xe4     |
| MIO_PERIPH_INSEL_REGWEN_57  | 0xe8     |
| MIO_PERIPH_INSEL_REGWEN_58  | 0xec     |
| MIO_PERIPH_INSEL_REGWEN_59  | 0xf0     |
| MIO_PERIPH_INSEL_REGWEN_60  | 0xf4     |
| MIO_PERIPH_INSEL_REGWEN_61  | 0xf8     |
| MIO_PERIPH_INSEL_REGWEN_62  | 0xfc     |
| MIO_PERIPH_INSEL_REGWEN_63  | 0x100    |
| MIO_PERIPH_INSEL_REGWEN_64  | 0x104    |
| MIO_PERIPH_INSEL_REGWEN_65  | 0x108    |
| MIO_PERIPH_INSEL_REGWEN_66  | 0x10c    |
| MIO_PERIPH_INSEL_REGWEN_67  | 0x110    |
| MIO_PERIPH_INSEL_REGWEN_68  | 0x114    |
| MIO_PERIPH_INSEL_REGWEN_69  | 0x118    |
| MIO_PERIPH_INSEL_REGWEN_70  | 0x11c    |
| MIO_PERIPH_INSEL_REGWEN_71  | 0x120    |
| MIO_PERIPH_INSEL_REGWEN_72  | 0x124    |
| MIO_PERIPH_INSEL_REGWEN_73  | 0x128    |
| MIO_PERIPH_INSEL_REGWEN_74  | 0x12c    |
| MIO_PERIPH_INSEL_REGWEN_75  | 0x130    |
| MIO_PERIPH_INSEL_REGWEN_76  | 0x134    |
| MIO_PERIPH_INSEL_REGWEN_77  | 0x138    |
| MIO_PERIPH_INSEL_REGWEN_78  | 0x13c    |
| MIO_PERIPH_INSEL_REGWEN_79  | 0x140    |
| MIO_PERIPH_INSEL_REGWEN_80  | 0x144    |
| MIO_PERIPH_INSEL_REGWEN_81  | 0x148    |
| MIO_PERIPH_INSEL_REGWEN_82  | 0x14c    |
| MIO_PERIPH_INSEL_REGWEN_83  | 0x150    |
| MIO_PERIPH_INSEL_REGWEN_84  | 0x154    |
| MIO_PERIPH_INSEL_REGWEN_85  | 0x158    |
| MIO_PERIPH_INSEL_REGWEN_86  | 0x15c    |
| MIO_PERIPH_INSEL_REGWEN_87  | 0x160    |
| MIO_PERIPH_INSEL_REGWEN_88  | 0x164    |
| MIO_PERIPH_INSEL_REGWEN_89  | 0x168    |
| MIO_PERIPH_INSEL_REGWEN_90  | 0x16c    |
| MIO_PERIPH_INSEL_REGWEN_91  | 0x170    |
| MIO_PERIPH_INSEL_REGWEN_92  | 0x174    |
| MIO_PERIPH_INSEL_REGWEN_93  | 0x178    |
| MIO_PERIPH_INSEL_REGWEN_94  | 0x17c    |
| MIO_PERIPH_INSEL_REGWEN_95  | 0x180    |
| MIO_PERIPH_INSEL_REGWEN_96  | 0x184    |
| MIO_PERIPH_INSEL_REGWEN_97  | 0x188    |
| MIO_PERIPH_INSEL_REGWEN_98  | 0x18c    |
| MIO_PERIPH_INSEL_REGWEN_99  | 0x190    |
| MIO_PERIPH_INSEL_REGWEN_100 | 0x194    |
| MIO_PERIPH_INSEL_REGWEN_101 | 0x198    |
| MIO_PERIPH_INSEL_REGWEN_102 | 0x19c    |
| MIO_PERIPH_INSEL_REGWEN_103 | 0x1a0    |
| MIO_PERIPH_INSEL_REGWEN_104 | 0x1a4    |
| MIO_PERIPH_INSEL_REGWEN_105 | 0x1a8    |
| MIO_PERIPH_INSEL_REGWEN_106 | 0x1ac    |
| MIO_PERIPH_INSEL_REGWEN_107 | 0x1b0    |
| MIO_PERIPH_INSEL_REGWEN_108 | 0x1b4    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                     |
|:------:|:------:|:-------:|:-------|:----------------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                        |
|   0    |  rw0c  |   0x1   | EN     | Register write enable bit. If this is cleared to 0, the corresponding MIO_PERIPH_INSEL is not writable anymore. |

## MIO_PERIPH_INSEL
For each peripheral input, this selects the muxable pad input.
- Reset default: `0x2`
- Reset mask: `0x3f`
- Register enable: [`MIO_PERIPH_INSEL_REGWEN`](#mio_periph_insel_regwen)

### Instances

| Name                 | Offset   |
|:---------------------|:---------|
| MIO_PERIPH_INSEL_0   | 0x1b8    |
| MIO_PERIPH_INSEL_1   | 0x1bc    |
| MIO_PERIPH_INSEL_2   | 0x1c0    |
| MIO_PERIPH_INSEL_3   | 0x1c4    |
| MIO_PERIPH_INSEL_4   | 0x1c8    |
| MIO_PERIPH_INSEL_5   | 0x1cc    |
| MIO_PERIPH_INSEL_6   | 0x1d0    |
| MIO_PERIPH_INSEL_7   | 0x1d4    |
| MIO_PERIPH_INSEL_8   | 0x1d8    |
| MIO_PERIPH_INSEL_9   | 0x1dc    |
| MIO_PERIPH_INSEL_10  | 0x1e0    |
| MIO_PERIPH_INSEL_11  | 0x1e4    |
| MIO_PERIPH_INSEL_12  | 0x1e8    |
| MIO_PERIPH_INSEL_13  | 0x1ec    |
| MIO_PERIPH_INSEL_14  | 0x1f0    |
| MIO_PERIPH_INSEL_15  | 0x1f4    |
| MIO_PERIPH_INSEL_16  | 0x1f8    |
| MIO_PERIPH_INSEL_17  | 0x1fc    |
| MIO_PERIPH_INSEL_18  | 0x200    |
| MIO_PERIPH_INSEL_19  | 0x204    |
| MIO_PERIPH_INSEL_20  | 0x208    |
| MIO_PERIPH_INSEL_21  | 0x20c    |
| MIO_PERIPH_INSEL_22  | 0x210    |
| MIO_PERIPH_INSEL_23  | 0x214    |
| MIO_PERIPH_INSEL_24  | 0x218    |
| MIO_PERIPH_INSEL_25  | 0x21c    |
| MIO_PERIPH_INSEL_26  | 0x220    |
| MIO_PERIPH_INSEL_27  | 0x224    |
| MIO_PERIPH_INSEL_28  | 0x228    |
| MIO_PERIPH_INSEL_29  | 0x22c    |
| MIO_PERIPH_INSEL_30  | 0x230    |
| MIO_PERIPH_INSEL_31  | 0x234    |
| MIO_PERIPH_INSEL_32  | 0x238    |
| MIO_PERIPH_INSEL_33  | 0x23c    |
| MIO_PERIPH_INSEL_34  | 0x240    |
| MIO_PERIPH_INSEL_35  | 0x244    |
| MIO_PERIPH_INSEL_36  | 0x248    |
| MIO_PERIPH_INSEL_37  | 0x24c    |
| MIO_PERIPH_INSEL_38  | 0x250    |
| MIO_PERIPH_INSEL_39  | 0x254    |
| MIO_PERIPH_INSEL_40  | 0x258    |
| MIO_PERIPH_INSEL_41  | 0x25c    |
| MIO_PERIPH_INSEL_42  | 0x260    |
| MIO_PERIPH_INSEL_43  | 0x264    |
| MIO_PERIPH_INSEL_44  | 0x268    |
| MIO_PERIPH_INSEL_45  | 0x26c    |
| MIO_PERIPH_INSEL_46  | 0x270    |
| MIO_PERIPH_INSEL_47  | 0x274    |
| MIO_PERIPH_INSEL_48  | 0x278    |
| MIO_PERIPH_INSEL_49  | 0x27c    |
| MIO_PERIPH_INSEL_50  | 0x280    |
| MIO_PERIPH_INSEL_51  | 0x284    |
| MIO_PERIPH_INSEL_52  | 0x288    |
| MIO_PERIPH_INSEL_53  | 0x28c    |
| MIO_PERIPH_INSEL_54  | 0x290    |
| MIO_PERIPH_INSEL_55  | 0x294    |
| MIO_PERIPH_INSEL_56  | 0x298    |
| MIO_PERIPH_INSEL_57  | 0x29c    |
| MIO_PERIPH_INSEL_58  | 0x2a0    |
| MIO_PERIPH_INSEL_59  | 0x2a4    |
| MIO_PERIPH_INSEL_60  | 0x2a8    |
| MIO_PERIPH_INSEL_61  | 0x2ac    |
| MIO_PERIPH_INSEL_62  | 0x2b0    |
| MIO_PERIPH_INSEL_63  | 0x2b4    |
| MIO_PERIPH_INSEL_64  | 0x2b8    |
| MIO_PERIPH_INSEL_65  | 0x2bc    |
| MIO_PERIPH_INSEL_66  | 0x2c0    |
| MIO_PERIPH_INSEL_67  | 0x2c4    |
| MIO_PERIPH_INSEL_68  | 0x2c8    |
| MIO_PERIPH_INSEL_69  | 0x2cc    |
| MIO_PERIPH_INSEL_70  | 0x2d0    |
| MIO_PERIPH_INSEL_71  | 0x2d4    |
| MIO_PERIPH_INSEL_72  | 0x2d8    |
| MIO_PERIPH_INSEL_73  | 0x2dc    |
| MIO_PERIPH_INSEL_74  | 0x2e0    |
| MIO_PERIPH_INSEL_75  | 0x2e4    |
| MIO_PERIPH_INSEL_76  | 0x2e8    |
| MIO_PERIPH_INSEL_77  | 0x2ec    |
| MIO_PERIPH_INSEL_78  | 0x2f0    |
| MIO_PERIPH_INSEL_79  | 0x2f4    |
| MIO_PERIPH_INSEL_80  | 0x2f8    |
| MIO_PERIPH_INSEL_81  | 0x2fc    |
| MIO_PERIPH_INSEL_82  | 0x300    |
| MIO_PERIPH_INSEL_83  | 0x304    |
| MIO_PERIPH_INSEL_84  | 0x308    |
| MIO_PERIPH_INSEL_85  | 0x30c    |
| MIO_PERIPH_INSEL_86  | 0x310    |
| MIO_PERIPH_INSEL_87  | 0x314    |
| MIO_PERIPH_INSEL_88  | 0x318    |
| MIO_PERIPH_INSEL_89  | 0x31c    |
| MIO_PERIPH_INSEL_90  | 0x320    |
| MIO_PERIPH_INSEL_91  | 0x324    |
| MIO_PERIPH_INSEL_92  | 0x328    |
| MIO_PERIPH_INSEL_93  | 0x32c    |
| MIO_PERIPH_INSEL_94  | 0x330    |
| MIO_PERIPH_INSEL_95  | 0x334    |
| MIO_PERIPH_INSEL_96  | 0x338    |
| MIO_PERIPH_INSEL_97  | 0x33c    |
| MIO_PERIPH_INSEL_98  | 0x340    |
| MIO_PERIPH_INSEL_99  | 0x344    |
| MIO_PERIPH_INSEL_100 | 0x348    |
| MIO_PERIPH_INSEL_101 | 0x34c    |
| MIO_PERIPH_INSEL_102 | 0x350    |
| MIO_PERIPH_INSEL_103 | 0x354    |
| MIO_PERIPH_INSEL_104 | 0x358    |
| MIO_PERIPH_INSEL_105 | 0x35c    |
| MIO_PERIPH_INSEL_106 | 0x360    |
| MIO_PERIPH_INSEL_107 | 0x364    |
| MIO_PERIPH_INSEL_108 | 0x368    |


### Fields

```wavejson
{"reg": [{"name": "IN", "bits": 6, "attr": ["rw"], "rotate": 0}, {"bits": 26}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                                                                         |
|:------:|:------:|:-------:|:-------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  31:6  |        |         |        | Reserved                                                                                                                                                                                            |
|  5:0   |   rw   |   0x2   | IN     | 0: tie constantly to zero, 1: tie constantly to 1, >=2: MIO pads (i.e., add 2 to the native MIO pad index). Selecting a pad that is not legal for this peripheral input ties it constantly to zero. |

## MIO_OUTSEL_REGWEN
Register write enable for MIO output selects.
- Reset default: `0x1`
- Reset mask: `0x1`

### Instances

| Name                 | Offset   |
|:---------------------|:---------|
| MIO_OUTSEL_REGWEN_0  | 0x36c    |
| MIO_OUTSEL_REGWEN_1  | 0x370    |
| MIO_OUTSEL_REGWEN_2  | 0x374    |
| MIO_OUTSEL_REGWEN_3  | 0x378    |
| MIO_OUTSEL_REGWEN_4  | 0x37c    |
| MIO_OUTSEL_REGWEN_5  | 0x380    |
| MIO_OUTSEL_REGWEN_6  | 0x384    |
| MIO_OUTSEL_REGWEN_7  | 0x388    |
| MIO_OUTSEL_REGWEN_8  | 0x38c    |
| MIO_OUTSEL_REGWEN_9  | 0x390    |
| MIO_OUTSEL_REGWEN_10 | 0x394    |
| MIO_OUTSEL_REGWEN_11 | 0x398    |
| MIO_OUTSEL_REGWEN_12 | 0x39c    |
| MIO_OUTSEL_REGWEN_13 | 0x3a0    |
| MIO_OUTSEL_REGWEN_14 | 0x3a4    |
| MIO_OUTSEL_REGWEN_15 | 0x3a8    |
| MIO_OUTSEL_REGWEN_16 | 0x3ac    |
| MIO_OUTSEL_REGWEN_17 | 0x3b0    |
| MIO_OUTSEL_REGWEN_18 | 0x3b4    |
| MIO_OUTSEL_REGWEN_19 | 0x3b8    |
| MIO_OUTSEL_REGWEN_20 | 0x3bc    |
| MIO_OUTSEL_REGWEN_21 | 0x3c0    |
| MIO_OUTSEL_REGWEN_22 | 0x3c4    |
| MIO_OUTSEL_REGWEN_23 | 0x3c8    |
| MIO_OUTSEL_REGWEN_24 | 0x3cc    |
| MIO_OUTSEL_REGWEN_25 | 0x3d0    |
| MIO_OUTSEL_REGWEN_26 | 0x3d4    |
| MIO_OUTSEL_REGWEN_27 | 0x3d8    |
| MIO_OUTSEL_REGWEN_28 | 0x3dc    |
| MIO_OUTSEL_REGWEN_29 | 0x3e0    |
| MIO_OUTSEL_REGWEN_30 | 0x3e4    |
| MIO_OUTSEL_REGWEN_31 | 0x3e8    |
| MIO_OUTSEL_REGWEN_32 | 0x3ec    |
| MIO_OUTSEL_REGWEN_33 | 0x3f0    |
| MIO_OUTSEL_REGWEN_34 | 0x3f4    |
| MIO_OUTSEL_REGWEN_35 | 0x3f8    |
| MIO_OUTSEL_REGWEN_36 | 0x3fc    |
| MIO_OUTSEL_REGWEN_37 | 0x400    |
| MIO_OUTSEL_REGWEN_38 | 0x404    |
| MIO_OUTSEL_REGWEN_39 | 0x408    |
| MIO_OUTSEL_REGWEN_40 | 0x40c    |
| MIO_OUTSEL_REGWEN_41 | 0x410    |
| MIO_OUTSEL_REGWEN_42 | 0x414    |
| MIO_OUTSEL_REGWEN_43 | 0x418    |
| MIO_OUTSEL_REGWEN_44 | 0x41c    |
| MIO_OUTSEL_REGWEN_45 | 0x420    |
| MIO_OUTSEL_REGWEN_46 | 0x424    |
| MIO_OUTSEL_REGWEN_47 | 0x428    |
| MIO_OUTSEL_REGWEN_48 | 0x42c    |
| MIO_OUTSEL_REGWEN_49 | 0x430    |
| MIO_OUTSEL_REGWEN_50 | 0x434    |
| MIO_OUTSEL_REGWEN_51 | 0x438    |
| MIO_OUTSEL_REGWEN_52 | 0x43c    |
| MIO_OUTSEL_REGWEN_53 | 0x440    |
| MIO_OUTSEL_REGWEN_54 | 0x444    |
| MIO_OUTSEL_REGWEN_55 | 0x448    |
| MIO_OUTSEL_REGWEN_56 | 0x44c    |
| MIO_OUTSEL_REGWEN_57 | 0x450    |
| MIO_OUTSEL_REGWEN_58 | 0x454    |
| MIO_OUTSEL_REGWEN_59 | 0x458    |
| MIO_OUTSEL_REGWEN_60 | 0x45c    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                               |
|:------:|:------:|:-------:|:-------|:----------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                  |
|   0    |  rw0c  |   0x1   | EN     | Register write enable bit. If this is cleared to 0, the corresponding MIO_OUTSEL is not writable anymore. |

## MIO_OUTSEL
For each muxable pad, this selects the peripheral output.
- Reset default: `0x3`
- Reset mask: `0x7f`
- Register enable: [`MIO_OUTSEL_REGWEN`](#mio_outsel_regwen)

### Instances

| Name          | Offset   |
|:--------------|:---------|
| MIO_OUTSEL_0  | 0x460    |
| MIO_OUTSEL_1  | 0x464    |
| MIO_OUTSEL_2  | 0x468    |
| MIO_OUTSEL_3  | 0x46c    |
| MIO_OUTSEL_4  | 0x470    |
| MIO_OUTSEL_5  | 0x474    |
| MIO_OUTSEL_6  | 0x478    |
| MIO_OUTSEL_7  | 0x47c    |
| MIO_OUTSEL_8  | 0x480    |
| MIO_OUTSEL_9  | 0x484    |
| MIO_OUTSEL_10 | 0x488    |
| MIO_OUTSEL_11 | 0x48c    |
| MIO_OUTSEL_12 | 0x490    |
| MIO_OUTSEL_13 | 0x494    |
| MIO_OUTSEL_14 | 0x498    |
| MIO_OUTSEL_15 | 0x49c    |
| MIO_OUTSEL_16 | 0x4a0    |
| MIO_OUTSEL_17 | 0x4a4    |
| MIO_OUTSEL_18 | 0x4a8    |
| MIO_OUTSEL_19 | 0x4ac    |
| MIO_OUTSEL_20 | 0x4b0    |
| MIO_OUTSEL_21 | 0x4b4    |
| MIO_OUTSEL_22 | 0x4b8    |
| MIO_OUTSEL_23 | 0x4bc    |
| MIO_OUTSEL_24 | 0x4c0    |
| MIO_OUTSEL_25 | 0x4c4    |
| MIO_OUTSEL_26 | 0x4c8    |
| MIO_OUTSEL_27 | 0x4cc    |
| MIO_OUTSEL_28 | 0x4d0    |
| MIO_OUTSEL_29 | 0x4d4    |
| MIO_OUTSEL_30 | 0x4d8    |
| MIO_OUTSEL_31 | 0x4dc    |
| MIO_OUTSEL_32 | 0x4e0    |
| MIO_OUTSEL_33 | 0x4e4    |
| MIO_OUTSEL_34 | 0x4e8    |
| MIO_OUTSEL_35 | 0x4ec    |
| MIO_OUTSEL_36 | 0x4f0    |
| MIO_OUTSEL_37 | 0x4f4    |
| MIO_OUTSEL_38 | 0x4f8    |
| MIO_OUTSEL_39 | 0x4fc    |
| MIO_OUTSEL_40 | 0x500    |
| MIO_OUTSEL_41 | 0x504    |
| MIO_OUTSEL_42 | 0x508    |
| MIO_OUTSEL_43 | 0x50c    |
| MIO_OUTSEL_44 | 0x510    |
| MIO_OUTSEL_45 | 0x514    |
| MIO_OUTSEL_46 | 0x518    |
| MIO_OUTSEL_47 | 0x51c    |
| MIO_OUTSEL_48 | 0x520    |
| MIO_OUTSEL_49 | 0x524    |
| MIO_OUTSEL_50 | 0x528    |
| MIO_OUTSEL_51 | 0x52c    |
| MIO_OUTSEL_52 | 0x530    |
| MIO_OUTSEL_53 | 0x534    |
| MIO_OUTSEL_54 | 0x538    |
| MIO_OUTSEL_55 | 0x53c    |
| MIO_OUTSEL_56 | 0x540    |
| MIO_OUTSEL_57 | 0x544    |
| MIO_OUTSEL_58 | 0x548    |
| MIO_OUTSEL_59 | 0x54c    |
| MIO_OUTSEL_60 | 0x550    |


### Fields

```wavejson
{"reg": [{"name": "OUT", "bits": 7, "attr": ["rw"], "rotate": 0}, {"bits": 25}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                                                                                                    |
|:------:|:------:|:-------:|:-------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  31:7  |        |         |        | Reserved                                                                                                                                                                                                                       |
|  6:0   |   rw   |   0x3   | OUT    | 0: tie constantly to zero, 1: tie constantly to 1, 2: high-Z, >=3: peripheral outputs (i.e., add 3 to the native peripheral pad index). Selecting a peripheral output that is not legal for this pad puts the pad into high-Z. |

## MIO_PAD_ATTR_REGWEN
Register write enable for MIO PAD attributes.
- Reset default: `0x1`
- Reset mask: `0x1`

### Instances

| Name                   | Offset   |
|:-----------------------|:---------|
| MIO_PAD_ATTR_REGWEN_0  | 0x554    |
| MIO_PAD_ATTR_REGWEN_1  | 0x558    |
| MIO_PAD_ATTR_REGWEN_2  | 0x55c    |
| MIO_PAD_ATTR_REGWEN_3  | 0x560    |
| MIO_PAD_ATTR_REGWEN_4  | 0x564    |
| MIO_PAD_ATTR_REGWEN_5  | 0x568    |
| MIO_PAD_ATTR_REGWEN_6  | 0x56c    |
| MIO_PAD_ATTR_REGWEN_7  | 0x570    |
| MIO_PAD_ATTR_REGWEN_8  | 0x574    |
| MIO_PAD_ATTR_REGWEN_9  | 0x578    |
| MIO_PAD_ATTR_REGWEN_10 | 0x57c    |
| MIO_PAD_ATTR_REGWEN_11 | 0x580    |
| MIO_PAD_ATTR_REGWEN_12 | 0x584    |
| MIO_PAD_ATTR_REGWEN_13 | 0x588    |
| MIO_PAD_ATTR_REGWEN_14 | 0x58c    |
| MIO_PAD_ATTR_REGWEN_15 | 0x590    |
| MIO_PAD_ATTR_REGWEN_16 | 0x594    |
| MIO_PAD_ATTR_REGWEN_17 | 0x598    |
| MIO_PAD_ATTR_REGWEN_18 | 0x59c    |
| MIO_PAD_ATTR_REGWEN_19 | 0x5a0    |
| MIO_PAD_ATTR_REGWEN_20 | 0x5a4    |
| MIO_PAD_ATTR_REGWEN_21 | 0x5a8    |
| MIO_PAD_ATTR_REGWEN_22 | 0x5ac    |
| MIO_PAD_ATTR_REGWEN_23 | 0x5b0    |
| MIO_PAD_ATTR_REGWEN_24 | 0x5b4    |
| MIO_PAD_ATTR_REGWEN_25 | 0x5b8    |
| MIO_PAD_ATTR_REGWEN_26 | 0x5bc    |
| MIO_PAD_ATTR_REGWEN_27 | 0x5c0    |
| MIO_PAD_ATTR_REGWEN_28 | 0x5c4    |
| MIO_PAD_ATTR_REGWEN_29 | 0x5c8    |
| MIO_PAD_ATTR_REGWEN_30 | 0x5cc    |
| MIO_PAD_ATTR_REGWEN_31 | 0x5d0    |
| MIO_PAD_ATTR_REGWEN_32 | 0x5d4    |
| MIO_PAD_ATTR_REGWEN_33 | 0x5d8    |
| MIO_PAD_ATTR_REGWEN_34 | 0x5dc    |
| MIO_PAD_ATTR_REGWEN_35 | 0x5e0    |
| MIO_PAD_ATTR_REGWEN_36 | 0x5e4    |
| MIO_PAD_ATTR_REGWEN_37 | 0x5e8    |
| MIO_PAD_ATTR_REGWEN_38 | 0x5ec    |
| MIO_PAD_ATTR_REGWEN_39 | 0x5f0    |
| MIO_PAD_ATTR_REGWEN_40 | 0x5f4    |
| MIO_PAD_ATTR_REGWEN_41 | 0x5f8    |
| MIO_PAD_ATTR_REGWEN_42 | 0x5fc    |
| MIO_PAD_ATTR_REGWEN_43 | 0x600    |
| MIO_PAD_ATTR_REGWEN_44 | 0x604    |
| MIO_PAD_ATTR_REGWEN_45 | 0x608    |
| MIO_PAD_ATTR_REGWEN_46 | 0x60c    |
| MIO_PAD_ATTR_REGWEN_47 | 0x610    |
| MIO_PAD_ATTR_REGWEN_48 | 0x614    |
| MIO_PAD_ATTR_REGWEN_49 | 0x618    |
| MIO_PAD_ATTR_REGWEN_50 | 0x61c    |
| MIO_PAD_ATTR_REGWEN_51 | 0x620    |
| MIO_PAD_ATTR_REGWEN_52 | 0x624    |
| MIO_PAD_ATTR_REGWEN_53 | 0x628    |
| MIO_PAD_ATTR_REGWEN_54 | 0x62c    |
| MIO_PAD_ATTR_REGWEN_55 | 0x630    |
| MIO_PAD_ATTR_REGWEN_56 | 0x634    |
| MIO_PAD_ATTR_REGWEN_57 | 0x638    |
| MIO_PAD_ATTR_REGWEN_58 | 0x63c    |
| MIO_PAD_ATTR_REGWEN_59 | 0x640    |
| MIO_PAD_ATTR_REGWEN_60 | 0x644    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                    |
|:------:|:------:|:-------:|:-------|:-------------------------------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                                       |
|   0    |  rw0c  |   0x1   | EN     | Register write enable bit. If this is cleared to 0, the corresponding [`MIO_PAD_ATTR`](#mio_pad_attr) is not writable anymore. |

## MIO_PAD_ATTR
Muxed pad attributes.
This register has WARL behavior since not each pad type may support
all attributes.
Non-default reset values can be defined in the top.hjson.
- Reset default: `0x0`
- Reset mask: `0xf300ff`
- Register enable: [`MIO_PAD_ATTR_REGWEN`](#mio_pad_attr_regwen)

### Instances

| Name            | Offset   |
|:----------------|:---------|
| MIO_PAD_ATTR_0  | 0x648    |
| MIO_PAD_ATTR_1  | 0x64c    |
| MIO_PAD_ATTR_2  | 0x650    |
| MIO_PAD_ATTR_3  | 0x654    |
| MIO_PAD_ATTR_4  | 0x658    |
| MIO_PAD_ATTR_5  | 0x65c    |
| MIO_PAD_ATTR_6  | 0x660    |
| MIO_PAD_ATTR_7  | 0x664    |
| MIO_PAD_ATTR_8  | 0x668    |
| MIO_PAD_ATTR_9  | 0x66c    |
| MIO_PAD_ATTR_10 | 0x670    |
| MIO_PAD_ATTR_11 | 0x674    |
| MIO_PAD_ATTR_12 | 0x678    |
| MIO_PAD_ATTR_13 | 0x67c    |
| MIO_PAD_ATTR_14 | 0x680    |
| MIO_PAD_ATTR_15 | 0x684    |
| MIO_PAD_ATTR_16 | 0x688    |
| MIO_PAD_ATTR_17 | 0x68c    |
| MIO_PAD_ATTR_18 | 0x690    |
| MIO_PAD_ATTR_19 | 0x694    |
| MIO_PAD_ATTR_20 | 0x698    |
| MIO_PAD_ATTR_21 | 0x69c    |
| MIO_PAD_ATTR_22 | 0x6a0    |
| MIO_PAD_ATTR_23 | 0x6a4    |
| MIO_PAD_ATTR_24 | 0x6a8    |
| MIO_PAD_ATTR_25 | 0x6ac    |
| MIO_PAD_ATTR_26 | 0x6b0    |
| MIO_PAD_ATTR_27 | 0x6b4    |
| MIO_PAD_ATTR_28 | 0x6b8    |
| MIO_PAD_ATTR_29 | 0x6bc    |
| MIO_PAD_ATTR_30 | 0x6c0    |
| MIO_PAD_ATTR_31 | 0x6c4    |
| MIO_PAD_ATTR_32 | 0x6c8    |
| MIO_PAD_ATTR_33 | 0x6cc    |
| MIO_PAD_ATTR_34 | 0x6d0    |
| MIO_PAD_ATTR_35 | 0x6d4    |
| MIO_PAD_ATTR_36 | 0x6d8    |
| MIO_PAD_ATTR_37 | 0x6dc    |
| MIO_PAD_ATTR_38 | 0x6e0    |
| MIO_PAD_ATTR_39 | 0x6e4    |
| MIO_PAD_ATTR_40 | 0x6e8    |
| MIO_PAD_ATTR_41 | 0x6ec    |
| MIO_PAD_ATTR_42 | 0x6f0    |
| MIO_PAD_ATTR_43 | 0x6f4    |
| MIO_PAD_ATTR_44 | 0x6f8    |
| MIO_PAD_ATTR_45 | 0x6fc    |
| MIO_PAD_ATTR_46 | 0x700    |
| MIO_PAD_ATTR_47 | 0x704    |
| MIO_PAD_ATTR_48 | 0x708    |
| MIO_PAD_ATTR_49 | 0x70c    |
| MIO_PAD_ATTR_50 | 0x710    |
| MIO_PAD_ATTR_51 | 0x714    |
| MIO_PAD_ATTR_52 | 0x718    |
| MIO_PAD_ATTR_53 | 0x71c    |
| MIO_PAD_ATTR_54 | 0x720    |
| MIO_PAD_ATTR_55 | 0x724    |
| MIO_PAD_ATTR_56 | 0x728    |
| MIO_PAD_ATTR_57 | 0x72c    |
| MIO_PAD_ATTR_58 | 0x730    |
| MIO_PAD_ATTR_59 | 0x734    |
| MIO_PAD_ATTR_60 | 0x738    |


### Fields

```wavejson
{"reg": [{"name": "invert", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "virtual_od_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "pull_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "pull_select", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "keeper_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "schmitt_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "od_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "input_disable", "bits": 1, "attr": ["rw"], "rotate": -90}, {"bits": 8}, {"name": "slew_rate", "bits": 2, "attr": ["rw"], "rotate": -90}, {"bits": 2}, {"name": "drive_strength", "bits": 4, "attr": ["rw"], "rotate": -90}, {"bits": 8}], "config": {"lanes": 1, "fontsize": 10, "vspace": 160}}
```

|  Bits  |  Type  |  Reset  | Name                                            |
|:------:|:------:|:-------:|:------------------------------------------------|
| 31:24  |        |         | Reserved                                        |
| 23:20  |   rw   |   0x0   | [drive_strength](#mio_pad_attr--drive_strength) |
| 19:18  |        |         | Reserved                                        |
| 17:16  |   rw   |   0x0   | [slew_rate](#mio_pad_attr--slew_rate)           |
|  15:8  |        |         | Reserved                                        |
|   7    |   rw   |   0x0   | [input_disable](#mio_pad_attr--input_disable)   |
|   6    |   rw   |   0x0   | [od_en](#mio_pad_attr--od_en)                   |
|   5    |   rw   |   0x0   | [schmitt_en](#mio_pad_attr--schmitt_en)         |
|   4    |   rw   |   0x0   | [keeper_en](#mio_pad_attr--keeper_en)           |
|   3    |   rw   |   0x0   | [pull_select](#mio_pad_attr--pull_select)       |
|   2    |   rw   |   0x0   | [pull_en](#mio_pad_attr--pull_en)               |
|   1    |   rw   |   0x0   | [virtual_od_en](#mio_pad_attr--virtual_od_en)   |
|   0    |   rw   |   0x0   | [invert](#mio_pad_attr--invert)                 |

### MIO_PAD_ATTR . drive_strength
Drive strength (0x0: weakest, 0xf: strongest)

### MIO_PAD_ATTR . slew_rate
Slew rate (0x0: slowest, 0x3: fastest).

### MIO_PAD_ATTR . input_disable
Disable input drivers.
Setting this to 1 for pads that are not used as input can reduce their leakage current.

### MIO_PAD_ATTR . od_en
Enable open drain.

### MIO_PAD_ATTR . schmitt_en
Enable the schmitt trigger.

### MIO_PAD_ATTR . keeper_en
Enable keeper termination. This weakly drives the previous pad output value when output is disabled, similar to a verilog `trireg`.

### MIO_PAD_ATTR . pull_select
Pull select (0: pull-down, 1: pull-up).

| Value   | Name      | Description                    |
|:--------|:----------|:-------------------------------|
| 0x0     | pull_down | Select the pull-down resistor. |
| 0x1     | pull_up   | Select the pull-up resistor.   |


### MIO_PAD_ATTR . pull_en
Enable pull-up or pull-down resistor.

### MIO_PAD_ATTR . virtual_od_en
Enable virtual open drain.

### MIO_PAD_ATTR . invert
Invert input and output levels.

## DIO_PAD_ATTR_REGWEN
Register write enable for DIO PAD attributes.
- Reset default: `0x1`
- Reset mask: `0x1`

### Instances

| Name                  | Offset   |
|:----------------------|:---------|
| DIO_PAD_ATTR_REGWEN_0 | 0x73c    |
| DIO_PAD_ATTR_REGWEN_1 | 0x740    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                    |
|:------:|:------:|:-------:|:-------|:-------------------------------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                                       |
|   0    |  rw0c  |   0x1   | EN     | Register write enable bit. If this is cleared to 0, the corresponding [`DIO_PAD_ATTR`](#dio_pad_attr) is not writable anymore. |

## DIO_PAD_ATTR
Dedicated pad attributes.
This register has WARL behavior since not each pad type may support
all attributes.
Non-default reset values can be defined in the top.hjson.
- Reset default: `0x0`
- Reset mask: `0xf300ff`
- Register enable: [`DIO_PAD_ATTR_REGWEN`](#dio_pad_attr_regwen)

### Instances

| Name           | Offset   |
|:---------------|:---------|
| DIO_PAD_ATTR_0 | 0x744    |
| DIO_PAD_ATTR_1 | 0x748    |


### Fields

```wavejson
{"reg": [{"name": "invert", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "virtual_od_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "pull_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "pull_select", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "keeper_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "schmitt_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "od_en", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "input_disable", "bits": 1, "attr": ["rw"], "rotate": -90}, {"bits": 8}, {"name": "slew_rate", "bits": 2, "attr": ["rw"], "rotate": -90}, {"bits": 2}, {"name": "drive_strength", "bits": 4, "attr": ["rw"], "rotate": -90}, {"bits": 8}], "config": {"lanes": 1, "fontsize": 10, "vspace": 160}}
```

|  Bits  |  Type  |  Reset  | Name                                            |
|:------:|:------:|:-------:|:------------------------------------------------|
| 31:24  |        |         | Reserved                                        |
| 23:20  |   rw   |   0x0   | [drive_strength](#dio_pad_attr--drive_strength) |
| 19:18  |        |         | Reserved                                        |
| 17:16  |   rw   |   0x0   | [slew_rate](#dio_pad_attr--slew_rate)           |
|  15:8  |        |         | Reserved                                        |
|   7    |   rw   |   0x0   | [input_disable](#dio_pad_attr--input_disable)   |
|   6    |   rw   |   0x0   | [od_en](#dio_pad_attr--od_en)                   |
|   5    |   rw   |   0x0   | [schmitt_en](#dio_pad_attr--schmitt_en)         |
|   4    |   rw   |   0x0   | [keeper_en](#dio_pad_attr--keeper_en)           |
|   3    |   rw   |   0x0   | [pull_select](#dio_pad_attr--pull_select)       |
|   2    |   rw   |   0x0   | [pull_en](#dio_pad_attr--pull_en)               |
|   1    |   rw   |   0x0   | [virtual_od_en](#dio_pad_attr--virtual_od_en)   |
|   0    |   rw   |   0x0   | [invert](#dio_pad_attr--invert)                 |

### DIO_PAD_ATTR . drive_strength
Drive strength (0x0: weakest, 0xf: strongest)

### DIO_PAD_ATTR . slew_rate
Slew rate (0x0: slowest, 0x3: fastest).

### DIO_PAD_ATTR . input_disable
Disable input drivers.
Setting this to 1 for pads that are not used as input can reduce their leakage current.

### DIO_PAD_ATTR . od_en
Enable open drain.

### DIO_PAD_ATTR . schmitt_en
Enable the schmitt trigger.

### DIO_PAD_ATTR . keeper_en
Enable keeper termination. This weakly drives the previous pad output value when output is disabled, similar to a verilog `trireg`.

### DIO_PAD_ATTR . pull_select
Pull select (0: pull-down, 1: pull-up).

| Value   | Name      | Description                    |
|:--------|:----------|:-------------------------------|
| 0x0     | pull_down | Select the pull-down resistor. |
| 0x1     | pull_up   | Select the pull-up resistor.   |


### DIO_PAD_ATTR . pull_en
Enable pull-up or pull-down resistor.

### DIO_PAD_ATTR . virtual_od_en
Enable virtual open drain.

### DIO_PAD_ATTR . invert
Invert input and output levels.

## MIO_PAD_SLEEP_STATUS_0
Register indicating whether the corresponding pad is in sleep mode.
- Offset: `0x74c`
- Reset default: `0x0`
- Reset mask: `0xffffffff`

### Fields

```wavejson
{"reg": [{"name": "EN_0", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_1", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_2", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_3", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_4", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_5", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_6", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_7", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_8", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_9", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_10", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_11", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_12", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_13", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_14", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_15", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_16", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_17", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_18", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_19", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_20", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_21", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_22", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_23", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_24", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_25", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_26", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_27", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_28", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_29", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_30", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_31", "bits": 1, "attr": ["rw0c"], "rotate": -90}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                                                                                                                      |
|:------:|:------:|:-------:|:-------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|   31   |  rw0c  |   0x0   | EN_31  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   30   |  rw0c  |   0x0   | EN_30  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   29   |  rw0c  |   0x0   | EN_29  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   28   |  rw0c  |   0x0   | EN_28  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   27   |  rw0c  |   0x0   | EN_27  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   26   |  rw0c  |   0x0   | EN_26  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   25   |  rw0c  |   0x0   | EN_25  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   24   |  rw0c  |   0x0   | EN_24  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   23   |  rw0c  |   0x0   | EN_23  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   22   |  rw0c  |   0x0   | EN_22  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   21   |  rw0c  |   0x0   | EN_21  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   20   |  rw0c  |   0x0   | EN_20  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   19   |  rw0c  |   0x0   | EN_19  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   18   |  rw0c  |   0x0   | EN_18  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   17   |  rw0c  |   0x0   | EN_17  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   16   |  rw0c  |   0x0   | EN_16  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   15   |  rw0c  |   0x0   | EN_15  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   14   |  rw0c  |   0x0   | EN_14  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   13   |  rw0c  |   0x0   | EN_13  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   12   |  rw0c  |   0x0   | EN_12  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   11   |  rw0c  |   0x0   | EN_11  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   10   |  rw0c  |   0x0   | EN_10  | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   9    |  rw0c  |   0x0   | EN_9   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   8    |  rw0c  |   0x0   | EN_8   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   7    |  rw0c  |   0x0   | EN_7   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   6    |  rw0c  |   0x0   | EN_6   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   5    |  rw0c  |   0x0   | EN_5   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   4    |  rw0c  |   0x0   | EN_4   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   3    |  rw0c  |   0x0   | EN_3   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   2    |  rw0c  |   0x0   | EN_2   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   1    |  rw0c  |   0x0   | EN_1   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   0    |  rw0c  |   0x0   | EN_0   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |

## MIO_PAD_SLEEP_STATUS_1
Register indicating whether the corresponding pad is in sleep mode.
- Offset: `0x750`
- Reset default: `0x0`
- Reset mask: `0x1fffffff`

### Fields

```wavejson
{"reg": [{"name": "EN_32", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_33", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_34", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_35", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_36", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_37", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_38", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_39", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_40", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_41", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_42", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_43", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_44", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_45", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_46", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_47", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_48", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_49", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_50", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_51", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_52", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_53", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_54", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_55", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_56", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_57", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_58", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_59", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_60", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 3}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description   |
|:------:|:------:|:-------:|:-------|:--------------|
| 31:29  |        |         |        | Reserved      |
|   28   |  rw0c  |   0x0   | EN_60  | For MIO_PAD1  |
|   27   |  rw0c  |   0x0   | EN_59  | For MIO_PAD1  |
|   26   |  rw0c  |   0x0   | EN_58  | For MIO_PAD1  |
|   25   |  rw0c  |   0x0   | EN_57  | For MIO_PAD1  |
|   24   |  rw0c  |   0x0   | EN_56  | For MIO_PAD1  |
|   23   |  rw0c  |   0x0   | EN_55  | For MIO_PAD1  |
|   22   |  rw0c  |   0x0   | EN_54  | For MIO_PAD1  |
|   21   |  rw0c  |   0x0   | EN_53  | For MIO_PAD1  |
|   20   |  rw0c  |   0x0   | EN_52  | For MIO_PAD1  |
|   19   |  rw0c  |   0x0   | EN_51  | For MIO_PAD1  |
|   18   |  rw0c  |   0x0   | EN_50  | For MIO_PAD1  |
|   17   |  rw0c  |   0x0   | EN_49  | For MIO_PAD1  |
|   16   |  rw0c  |   0x0   | EN_48  | For MIO_PAD1  |
|   15   |  rw0c  |   0x0   | EN_47  | For MIO_PAD1  |
|   14   |  rw0c  |   0x0   | EN_46  | For MIO_PAD1  |
|   13   |  rw0c  |   0x0   | EN_45  | For MIO_PAD1  |
|   12   |  rw0c  |   0x0   | EN_44  | For MIO_PAD1  |
|   11   |  rw0c  |   0x0   | EN_43  | For MIO_PAD1  |
|   10   |  rw0c  |   0x0   | EN_42  | For MIO_PAD1  |
|   9    |  rw0c  |   0x0   | EN_41  | For MIO_PAD1  |
|   8    |  rw0c  |   0x0   | EN_40  | For MIO_PAD1  |
|   7    |  rw0c  |   0x0   | EN_39  | For MIO_PAD1  |
|   6    |  rw0c  |   0x0   | EN_38  | For MIO_PAD1  |
|   5    |  rw0c  |   0x0   | EN_37  | For MIO_PAD1  |
|   4    |  rw0c  |   0x0   | EN_36  | For MIO_PAD1  |
|   3    |  rw0c  |   0x0   | EN_35  | For MIO_PAD1  |
|   2    |  rw0c  |   0x0   | EN_34  | For MIO_PAD1  |
|   1    |  rw0c  |   0x0   | EN_33  | For MIO_PAD1  |
|   0    |  rw0c  |   0x0   | EN_32  | For MIO_PAD1  |

## MIO_PAD_SLEEP_REGWEN
Register write enable for MIO sleep value configuration.
- Reset default: `0x1`
- Reset mask: `0x1`

### Instances

| Name                    | Offset   |
|:------------------------|:---------|
| MIO_PAD_SLEEP_REGWEN_0  | 0x754    |
| MIO_PAD_SLEEP_REGWEN_1  | 0x758    |
| MIO_PAD_SLEEP_REGWEN_2  | 0x75c    |
| MIO_PAD_SLEEP_REGWEN_3  | 0x760    |
| MIO_PAD_SLEEP_REGWEN_4  | 0x764    |
| MIO_PAD_SLEEP_REGWEN_5  | 0x768    |
| MIO_PAD_SLEEP_REGWEN_6  | 0x76c    |
| MIO_PAD_SLEEP_REGWEN_7  | 0x770    |
| MIO_PAD_SLEEP_REGWEN_8  | 0x774    |
| MIO_PAD_SLEEP_REGWEN_9  | 0x778    |
| MIO_PAD_SLEEP_REGWEN_10 | 0x77c    |
| MIO_PAD_SLEEP_REGWEN_11 | 0x780    |
| MIO_PAD_SLEEP_REGWEN_12 | 0x784    |
| MIO_PAD_SLEEP_REGWEN_13 | 0x788    |
| MIO_PAD_SLEEP_REGWEN_14 | 0x78c    |
| MIO_PAD_SLEEP_REGWEN_15 | 0x790    |
| MIO_PAD_SLEEP_REGWEN_16 | 0x794    |
| MIO_PAD_SLEEP_REGWEN_17 | 0x798    |
| MIO_PAD_SLEEP_REGWEN_18 | 0x79c    |
| MIO_PAD_SLEEP_REGWEN_19 | 0x7a0    |
| MIO_PAD_SLEEP_REGWEN_20 | 0x7a4    |
| MIO_PAD_SLEEP_REGWEN_21 | 0x7a8    |
| MIO_PAD_SLEEP_REGWEN_22 | 0x7ac    |
| MIO_PAD_SLEEP_REGWEN_23 | 0x7b0    |
| MIO_PAD_SLEEP_REGWEN_24 | 0x7b4    |
| MIO_PAD_SLEEP_REGWEN_25 | 0x7b8    |
| MIO_PAD_SLEEP_REGWEN_26 | 0x7bc    |
| MIO_PAD_SLEEP_REGWEN_27 | 0x7c0    |
| MIO_PAD_SLEEP_REGWEN_28 | 0x7c4    |
| MIO_PAD_SLEEP_REGWEN_29 | 0x7c8    |
| MIO_PAD_SLEEP_REGWEN_30 | 0x7cc    |
| MIO_PAD_SLEEP_REGWEN_31 | 0x7d0    |
| MIO_PAD_SLEEP_REGWEN_32 | 0x7d4    |
| MIO_PAD_SLEEP_REGWEN_33 | 0x7d8    |
| MIO_PAD_SLEEP_REGWEN_34 | 0x7dc    |
| MIO_PAD_SLEEP_REGWEN_35 | 0x7e0    |
| MIO_PAD_SLEEP_REGWEN_36 | 0x7e4    |
| MIO_PAD_SLEEP_REGWEN_37 | 0x7e8    |
| MIO_PAD_SLEEP_REGWEN_38 | 0x7ec    |
| MIO_PAD_SLEEP_REGWEN_39 | 0x7f0    |
| MIO_PAD_SLEEP_REGWEN_40 | 0x7f4    |
| MIO_PAD_SLEEP_REGWEN_41 | 0x7f8    |
| MIO_PAD_SLEEP_REGWEN_42 | 0x7fc    |
| MIO_PAD_SLEEP_REGWEN_43 | 0x800    |
| MIO_PAD_SLEEP_REGWEN_44 | 0x804    |
| MIO_PAD_SLEEP_REGWEN_45 | 0x808    |
| MIO_PAD_SLEEP_REGWEN_46 | 0x80c    |
| MIO_PAD_SLEEP_REGWEN_47 | 0x810    |
| MIO_PAD_SLEEP_REGWEN_48 | 0x814    |
| MIO_PAD_SLEEP_REGWEN_49 | 0x818    |
| MIO_PAD_SLEEP_REGWEN_50 | 0x81c    |
| MIO_PAD_SLEEP_REGWEN_51 | 0x820    |
| MIO_PAD_SLEEP_REGWEN_52 | 0x824    |
| MIO_PAD_SLEEP_REGWEN_53 | 0x828    |
| MIO_PAD_SLEEP_REGWEN_54 | 0x82c    |
| MIO_PAD_SLEEP_REGWEN_55 | 0x830    |
| MIO_PAD_SLEEP_REGWEN_56 | 0x834    |
| MIO_PAD_SLEEP_REGWEN_57 | 0x838    |
| MIO_PAD_SLEEP_REGWEN_58 | 0x83c    |
| MIO_PAD_SLEEP_REGWEN_59 | 0x840    |
| MIO_PAD_SLEEP_REGWEN_60 | 0x844    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                |
|:------:|:------:|:-------:|:-------|:-------------------------------------------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                                                   |
|   0    |  rw0c  |   0x1   | EN     | Register write enable bit. If this is cleared to 0, the corresponding [`MIO_PAD_SLEEP_MODE`](#mio_pad_sleep_mode) is not writable anymore. |

## MIO_PAD_SLEEP_EN
Enables the sleep mode of the corresponding muxed pad.
- Reset default: `0x0`
- Reset mask: `0x1`
- Register enable: [`MIO_PAD_SLEEP_REGWEN`](#mio_pad_sleep_regwen)

### Instances

| Name                | Offset   |
|:--------------------|:---------|
| MIO_PAD_SLEEP_EN_0  | 0x848    |
| MIO_PAD_SLEEP_EN_1  | 0x84c    |
| MIO_PAD_SLEEP_EN_2  | 0x850    |
| MIO_PAD_SLEEP_EN_3  | 0x854    |
| MIO_PAD_SLEEP_EN_4  | 0x858    |
| MIO_PAD_SLEEP_EN_5  | 0x85c    |
| MIO_PAD_SLEEP_EN_6  | 0x860    |
| MIO_PAD_SLEEP_EN_7  | 0x864    |
| MIO_PAD_SLEEP_EN_8  | 0x868    |
| MIO_PAD_SLEEP_EN_9  | 0x86c    |
| MIO_PAD_SLEEP_EN_10 | 0x870    |
| MIO_PAD_SLEEP_EN_11 | 0x874    |
| MIO_PAD_SLEEP_EN_12 | 0x878    |
| MIO_PAD_SLEEP_EN_13 | 0x87c    |
| MIO_PAD_SLEEP_EN_14 | 0x880    |
| MIO_PAD_SLEEP_EN_15 | 0x884    |
| MIO_PAD_SLEEP_EN_16 | 0x888    |
| MIO_PAD_SLEEP_EN_17 | 0x88c    |
| MIO_PAD_SLEEP_EN_18 | 0x890    |
| MIO_PAD_SLEEP_EN_19 | 0x894    |
| MIO_PAD_SLEEP_EN_20 | 0x898    |
| MIO_PAD_SLEEP_EN_21 | 0x89c    |
| MIO_PAD_SLEEP_EN_22 | 0x8a0    |
| MIO_PAD_SLEEP_EN_23 | 0x8a4    |
| MIO_PAD_SLEEP_EN_24 | 0x8a8    |
| MIO_PAD_SLEEP_EN_25 | 0x8ac    |
| MIO_PAD_SLEEP_EN_26 | 0x8b0    |
| MIO_PAD_SLEEP_EN_27 | 0x8b4    |
| MIO_PAD_SLEEP_EN_28 | 0x8b8    |
| MIO_PAD_SLEEP_EN_29 | 0x8bc    |
| MIO_PAD_SLEEP_EN_30 | 0x8c0    |
| MIO_PAD_SLEEP_EN_31 | 0x8c4    |
| MIO_PAD_SLEEP_EN_32 | 0x8c8    |
| MIO_PAD_SLEEP_EN_33 | 0x8cc    |
| MIO_PAD_SLEEP_EN_34 | 0x8d0    |
| MIO_PAD_SLEEP_EN_35 | 0x8d4    |
| MIO_PAD_SLEEP_EN_36 | 0x8d8    |
| MIO_PAD_SLEEP_EN_37 | 0x8dc    |
| MIO_PAD_SLEEP_EN_38 | 0x8e0    |
| MIO_PAD_SLEEP_EN_39 | 0x8e4    |
| MIO_PAD_SLEEP_EN_40 | 0x8e8    |
| MIO_PAD_SLEEP_EN_41 | 0x8ec    |
| MIO_PAD_SLEEP_EN_42 | 0x8f0    |
| MIO_PAD_SLEEP_EN_43 | 0x8f4    |
| MIO_PAD_SLEEP_EN_44 | 0x8f8    |
| MIO_PAD_SLEEP_EN_45 | 0x8fc    |
| MIO_PAD_SLEEP_EN_46 | 0x900    |
| MIO_PAD_SLEEP_EN_47 | 0x904    |
| MIO_PAD_SLEEP_EN_48 | 0x908    |
| MIO_PAD_SLEEP_EN_49 | 0x90c    |
| MIO_PAD_SLEEP_EN_50 | 0x910    |
| MIO_PAD_SLEEP_EN_51 | 0x914    |
| MIO_PAD_SLEEP_EN_52 | 0x918    |
| MIO_PAD_SLEEP_EN_53 | 0x91c    |
| MIO_PAD_SLEEP_EN_54 | 0x920    |
| MIO_PAD_SLEEP_EN_55 | 0x924    |
| MIO_PAD_SLEEP_EN_56 | 0x928    |
| MIO_PAD_SLEEP_EN_57 | 0x92c    |
| MIO_PAD_SLEEP_EN_58 | 0x930    |
| MIO_PAD_SLEEP_EN_59 | 0x934    |
| MIO_PAD_SLEEP_EN_60 | 0x938    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name                        |
|:------:|:------:|:-------:|:----------------------------|
|  31:1  |        |         | Reserved                    |
|   0    |   rw   |   0x0   | [EN](#mio_pad_sleep_en--en) |

### MIO_PAD_SLEEP_EN . EN
Deep sleep mode enable.
If this bit is set to 1 the corresponding pad will enable the sleep behavior
specified in [`MIO_PAD_SLEEP_MODE`](#mio_pad_sleep_mode) upon deep sleep entry, and the corresponding bit
in [`MIO_PAD_SLEEP_STATUS`](#mio_pad_sleep_status) will be set to 1.
The pad remains in deep sleep mode until the corresponding bit in
[`MIO_PAD_SLEEP_STATUS`](#mio_pad_sleep_status) is cleared by SW.
Note that if an always on peripheral is connected to a specific MIO pad,
the corresponding [`MIO_PAD_SLEEP_EN`](#mio_pad_sleep_en) bit should be set to 0.

## MIO_PAD_SLEEP_MODE
Defines sleep behavior of the corresponding muxed pad.
- Reset default: `0x2`
- Reset mask: `0x3`
- Register enable: [`MIO_PAD_SLEEP_REGWEN`](#mio_pad_sleep_regwen)

### Instances

| Name                  | Offset   |
|:----------------------|:---------|
| MIO_PAD_SLEEP_MODE_0  | 0x93c    |
| MIO_PAD_SLEEP_MODE_1  | 0x940    |
| MIO_PAD_SLEEP_MODE_2  | 0x944    |
| MIO_PAD_SLEEP_MODE_3  | 0x948    |
| MIO_PAD_SLEEP_MODE_4  | 0x94c    |
| MIO_PAD_SLEEP_MODE_5  | 0x950    |
| MIO_PAD_SLEEP_MODE_6  | 0x954    |
| MIO_PAD_SLEEP_MODE_7  | 0x958    |
| MIO_PAD_SLEEP_MODE_8  | 0x95c    |
| MIO_PAD_SLEEP_MODE_9  | 0x960    |
| MIO_PAD_SLEEP_MODE_10 | 0x964    |
| MIO_PAD_SLEEP_MODE_11 | 0x968    |
| MIO_PAD_SLEEP_MODE_12 | 0x96c    |
| MIO_PAD_SLEEP_MODE_13 | 0x970    |
| MIO_PAD_SLEEP_MODE_14 | 0x974    |
| MIO_PAD_SLEEP_MODE_15 | 0x978    |
| MIO_PAD_SLEEP_MODE_16 | 0x97c    |
| MIO_PAD_SLEEP_MODE_17 | 0x980    |
| MIO_PAD_SLEEP_MODE_18 | 0x984    |
| MIO_PAD_SLEEP_MODE_19 | 0x988    |
| MIO_PAD_SLEEP_MODE_20 | 0x98c    |
| MIO_PAD_SLEEP_MODE_21 | 0x990    |
| MIO_PAD_SLEEP_MODE_22 | 0x994    |
| MIO_PAD_SLEEP_MODE_23 | 0x998    |
| MIO_PAD_SLEEP_MODE_24 | 0x99c    |
| MIO_PAD_SLEEP_MODE_25 | 0x9a0    |
| MIO_PAD_SLEEP_MODE_26 | 0x9a4    |
| MIO_PAD_SLEEP_MODE_27 | 0x9a8    |
| MIO_PAD_SLEEP_MODE_28 | 0x9ac    |
| MIO_PAD_SLEEP_MODE_29 | 0x9b0    |
| MIO_PAD_SLEEP_MODE_30 | 0x9b4    |
| MIO_PAD_SLEEP_MODE_31 | 0x9b8    |
| MIO_PAD_SLEEP_MODE_32 | 0x9bc    |
| MIO_PAD_SLEEP_MODE_33 | 0x9c0    |
| MIO_PAD_SLEEP_MODE_34 | 0x9c4    |
| MIO_PAD_SLEEP_MODE_35 | 0x9c8    |
| MIO_PAD_SLEEP_MODE_36 | 0x9cc    |
| MIO_PAD_SLEEP_MODE_37 | 0x9d0    |
| MIO_PAD_SLEEP_MODE_38 | 0x9d4    |
| MIO_PAD_SLEEP_MODE_39 | 0x9d8    |
| MIO_PAD_SLEEP_MODE_40 | 0x9dc    |
| MIO_PAD_SLEEP_MODE_41 | 0x9e0    |
| MIO_PAD_SLEEP_MODE_42 | 0x9e4    |
| MIO_PAD_SLEEP_MODE_43 | 0x9e8    |
| MIO_PAD_SLEEP_MODE_44 | 0x9ec    |
| MIO_PAD_SLEEP_MODE_45 | 0x9f0    |
| MIO_PAD_SLEEP_MODE_46 | 0x9f4    |
| MIO_PAD_SLEEP_MODE_47 | 0x9f8    |
| MIO_PAD_SLEEP_MODE_48 | 0x9fc    |
| MIO_PAD_SLEEP_MODE_49 | 0xa00    |
| MIO_PAD_SLEEP_MODE_50 | 0xa04    |
| MIO_PAD_SLEEP_MODE_51 | 0xa08    |
| MIO_PAD_SLEEP_MODE_52 | 0xa0c    |
| MIO_PAD_SLEEP_MODE_53 | 0xa10    |
| MIO_PAD_SLEEP_MODE_54 | 0xa14    |
| MIO_PAD_SLEEP_MODE_55 | 0xa18    |
| MIO_PAD_SLEEP_MODE_56 | 0xa1c    |
| MIO_PAD_SLEEP_MODE_57 | 0xa20    |
| MIO_PAD_SLEEP_MODE_58 | 0xa24    |
| MIO_PAD_SLEEP_MODE_59 | 0xa28    |
| MIO_PAD_SLEEP_MODE_60 | 0xa2c    |


### Fields

```wavejson
{"reg": [{"name": "OUT", "bits": 2, "attr": ["rw"], "rotate": -90}, {"bits": 30}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name                            |
|:------:|:------:|:-------:|:--------------------------------|
|  31:2  |        |         | Reserved                        |
|  1:0   |   rw   |   0x2   | [OUT](#mio_pad_sleep_mode--out) |

### MIO_PAD_SLEEP_MODE . OUT
Value to drive in deep sleep.

| Value   | Name     | Description                                                                                                                                                                                     |
|:--------|:---------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0x0     | Tie-Low  | The pad is driven actively to zero in deep sleep mode.                                                                                                                                          |
| 0x1     | Tie-High | The pad is driven actively to one in deep sleep mode.                                                                                                                                           |
| 0x2     | High-Z   | The pad is left undriven in deep sleep mode. Note that the actual driving behavior during deep sleep will then depend on the pull-up/-down configuration of in [`MIO_PAD_ATTR.`](#mio_pad_attr) |
| 0x3     | Keep     | Keep last driven value (including high-Z).                                                                                                                                                      |


## DIO_PAD_SLEEP_STATUS
Register indicating whether the corresponding pad is in sleep mode.
- Offset: `0xa30`
- Reset default: `0x0`
- Reset mask: `0x3`

### Fields

```wavejson
{"reg": [{"name": "EN_0", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "EN_1", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 30}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                                                                                                                          |
|:------:|:------:|:-------:|:-------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  31:2  |        |         |        | Reserved                                                                                                                                                                                                                                             |
|   1    |  rw0c  |   0x0   | EN_1   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`DIO_PAD_SLEEP_MODE`](#dio_pad_sleep_mode)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |
|   0    |  rw0c  |   0x0   | EN_0   | This register is set to 1 if the deep sleep mode of the corresponding pad has been enabled ([`DIO_PAD_SLEEP_MODE`](#dio_pad_sleep_mode)) upon deep sleep entry. The sleep mode of the corresponding pad will remain active until SW clears this bit. |

## DIO_PAD_SLEEP_REGWEN
Register write enable for DIO sleep value configuration.
- Reset default: `0x1`
- Reset mask: `0x1`

### Instances

| Name                   | Offset   |
|:-----------------------|:---------|
| DIO_PAD_SLEEP_REGWEN_0 | 0xa34    |
| DIO_PAD_SLEEP_REGWEN_1 | 0xa38    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                |
|:------:|:------:|:-------:|:-------|:-------------------------------------------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                                                   |
|   0    |  rw0c  |   0x1   | EN     | Register write enable bit. If this is cleared to 0, the corresponding [`DIO_PAD_SLEEP_MODE`](#dio_pad_sleep_mode) is not writable anymore. |

## DIO_PAD_SLEEP_EN
Enables the sleep mode of the corresponding dedicated pad.
- Reset default: `0x0`
- Reset mask: `0x1`
- Register enable: [`DIO_PAD_SLEEP_REGWEN`](#dio_pad_sleep_regwen)

### Instances

| Name               | Offset   |
|:-------------------|:---------|
| DIO_PAD_SLEEP_EN_0 | 0xa3c    |
| DIO_PAD_SLEEP_EN_1 | 0xa40    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name                        |
|:------:|:------:|:-------:|:----------------------------|
|  31:1  |        |         | Reserved                    |
|   0    |   rw   |   0x0   | [EN](#dio_pad_sleep_en--en) |

### DIO_PAD_SLEEP_EN . EN
Deep sleep mode enable.
If this bit is set to 1 the corresponding pad will enable the sleep behavior
specified in [`DIO_PAD_SLEEP_MODE`](#dio_pad_sleep_mode) upon deep sleep entry, and the corresponding bit
in [`DIO_PAD_SLEEP_STATUS`](#dio_pad_sleep_status) will be set to 1.
The pad remains in deep sleep mode until the corresponding bit in
[`DIO_PAD_SLEEP_STATUS`](#dio_pad_sleep_status) is cleared by SW.
Note that if an always on peripheral is connected to a specific DIO pad,
the corresponding [`DIO_PAD_SLEEP_EN`](#dio_pad_sleep_en) bit should be set to 0.

## DIO_PAD_SLEEP_MODE
Defines sleep behavior of the corresponding dedicated pad.
- Reset default: `0x2`
- Reset mask: `0x3`
- Register enable: [`DIO_PAD_SLEEP_REGWEN`](#dio_pad_sleep_regwen)

### Instances

| Name                 | Offset   |
|:---------------------|:---------|
| DIO_PAD_SLEEP_MODE_0 | 0xa44    |
| DIO_PAD_SLEEP_MODE_1 | 0xa48    |


### Fields

```wavejson
{"reg": [{"name": "OUT", "bits": 2, "attr": ["rw"], "rotate": -90}, {"bits": 30}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name                            |
|:------:|:------:|:-------:|:--------------------------------|
|  31:2  |        |         | Reserved                        |
|  1:0   |   rw   |   0x2   | [OUT](#dio_pad_sleep_mode--out) |

### DIO_PAD_SLEEP_MODE . OUT
Value to drive in deep sleep.

| Value   | Name     | Description                                                                                                                                                                                     |
|:--------|:---------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0x0     | Tie-Low  | The pad is driven actively to zero in deep sleep mode.                                                                                                                                          |
| 0x1     | Tie-High | The pad is driven actively to one in deep sleep mode.                                                                                                                                           |
| 0x2     | High-Z   | The pad is left undriven in deep sleep mode. Note that the actual driving behavior during deep sleep will then depend on the pull-up/-down configuration of in [`DIO_PAD_ATTR.`](#dio_pad_attr) |
| 0x3     | Keep     | Keep last driven value (including high-Z).                                                                                                                                                      |


## WKUP_DETECTOR_REGWEN
Register write enable for wakeup detectors.
- Reset default: `0x1`
- Reset mask: `0x1`

### Instances

| Name                   | Offset   |
|:-----------------------|:---------|
| WKUP_DETECTOR_REGWEN_0 | 0xa4c    |
| WKUP_DETECTOR_REGWEN_1 | 0xa50    |
| WKUP_DETECTOR_REGWEN_2 | 0xa54    |
| WKUP_DETECTOR_REGWEN_3 | 0xa58    |
| WKUP_DETECTOR_REGWEN_4 | 0xa5c    |
| WKUP_DETECTOR_REGWEN_5 | 0xa60    |
| WKUP_DETECTOR_REGWEN_6 | 0xa64    |
| WKUP_DETECTOR_REGWEN_7 | 0xa68    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                |
|:------:|:------:|:-------:|:-------|:---------------------------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                                   |
|   0    |  rw0c  |   0x1   | EN     | Register write enable bit. If this is cleared to 0, the corresponding WKUP_DETECTOR configuration is not writable anymore. |

## WKUP_DETECTOR_EN
Enables for the wakeup detectors.
Note that these registers are synced to the always-on clock.
The first write access always completes immediately.
However, read/write accesses following a write will block until that write has completed.
- Reset default: `0x0`
- Reset mask: `0x1`
- Register enable: [`WKUP_DETECTOR_REGWEN`](#wkup_detector_regwen)

### Instances

| Name               | Offset   |
|:-------------------|:---------|
| WKUP_DETECTOR_EN_0 | 0xa6c    |
| WKUP_DETECTOR_EN_1 | 0xa70    |
| WKUP_DETECTOR_EN_2 | 0xa74    |
| WKUP_DETECTOR_EN_3 | 0xa78    |
| WKUP_DETECTOR_EN_4 | 0xa7c    |
| WKUP_DETECTOR_EN_5 | 0xa80    |
| WKUP_DETECTOR_EN_6 | 0xa84    |
| WKUP_DETECTOR_EN_7 | 0xa88    |


### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                                                                                                           |
|:------:|:------:|:-------:|:-------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                                                                                                                                                              |
|   0    |   rw   |   0x0   | EN     | Setting this bit activates the corresponding wakeup detector. The behavior is as specified in [`WKUP_DETECTOR`](#wkup_detector), [`WKUP_DETECTOR_CNT_TH`](#wkup_detector_cnt_th) and [`WKUP_DETECTOR_PADSEL.`](#wkup_detector_padsel) |

## WKUP_DETECTOR
Configuration of wakeup condition detectors.
Note that these registers are synced to the always-on clock.
The first write access always completes immediately.
However, read/write accesses following a write will block until that write has completed.

Note that the wkup detector should be disabled by setting [`WKUP_DETECTOR_EN_0`](#wkup_detector_en_0) before changing the detection mode.
The reason for that is that the pulse width counter is NOT cleared upon a mode change while the detector is enabled.
- Reset default: `0x0`
- Reset mask: `0x1f`
- Register enable: [`WKUP_DETECTOR_REGWEN`](#wkup_detector_regwen)

### Instances

| Name            | Offset   |
|:----------------|:---------|
| WKUP_DETECTOR_0 | 0xa8c    |
| WKUP_DETECTOR_1 | 0xa90    |
| WKUP_DETECTOR_2 | 0xa94    |
| WKUP_DETECTOR_3 | 0xa98    |
| WKUP_DETECTOR_4 | 0xa9c    |
| WKUP_DETECTOR_5 | 0xaa0    |
| WKUP_DETECTOR_6 | 0xaa4    |
| WKUP_DETECTOR_7 | 0xaa8    |


### Fields

```wavejson
{"reg": [{"name": "MODE", "bits": 3, "attr": ["rw"], "rotate": 0}, {"name": "FILTER", "bits": 1, "attr": ["rw"], "rotate": -90}, {"name": "MIODIO", "bits": 1, "attr": ["rw"], "rotate": -90}, {"bits": 27}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name                             |
|:------:|:------:|:-------:|:---------------------------------|
|  31:5  |        |         | Reserved                         |
|   4    |   rw   |   0x0   | [MIODIO](#wkup_detector--miodio) |
|   3    |   rw   |   0x0   | [FILTER](#wkup_detector--filter) |
|  2:0   |   rw   |   0x0   | [MODE](#wkup_detector--mode)     |

### WKUP_DETECTOR . MIODIO
0: select index [`WKUP_DETECTOR_PADSEL`](#wkup_detector_padsel) from MIO pads,
1: select index [`WKUP_DETECTOR_PADSEL`](#wkup_detector_padsel) from DIO pads.

### WKUP_DETECTOR . FILTER
0: signal filter disabled, 1: signal filter enabled. the signal must
be stable for 4 always-on clock cycles before the value is being forwarded.
can be used for debouncing.

### WKUP_DETECTOR . MODE
Wakeup detection mode. Out of range values default to Posedge.

| Value   | Name      | Description                                                                                                                                                       |
|:--------|:----------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0x0     | Posedge   | Trigger a wakeup request when observing a positive edge.                                                                                                          |
| 0x1     | Negedge   | Trigger a wakeup request when observing a negative edge.                                                                                                          |
| 0x2     | Edge      | Trigger a wakeup request when observing an edge in any direction.                                                                                                 |
| 0x3     | TimedHigh | Trigger a wakeup request when pin is driven HIGH for a certain amount of always-on clock cycles as configured in [`WKUP_DETECTOR_CNT_TH.`](#wkup_detector_cnt_th) |
| 0x4     | TimedLow  | Trigger a wakeup request when pin is driven LOW for a certain amount of always-on clock cycles as configured in [`WKUP_DETECTOR_CNT_TH.`](#wkup_detector_cnt_th)  |

Other values are reserved.

## WKUP_DETECTOR_CNT_TH
Counter thresholds for wakeup condition detectors.
Note that these registers are synced to the always-on clock.
The first write access always completes immediately.
However, read/write accesses following a write will block until that write has completed.
- Reset default: `0x0`
- Reset mask: `0xff`
- Register enable: [`WKUP_DETECTOR_REGWEN`](#wkup_detector_regwen)

### Instances

| Name                   | Offset   |
|:-----------------------|:---------|
| WKUP_DETECTOR_CNT_TH_0 | 0xaac    |
| WKUP_DETECTOR_CNT_TH_1 | 0xab0    |
| WKUP_DETECTOR_CNT_TH_2 | 0xab4    |
| WKUP_DETECTOR_CNT_TH_3 | 0xab8    |
| WKUP_DETECTOR_CNT_TH_4 | 0xabc    |
| WKUP_DETECTOR_CNT_TH_5 | 0xac0    |
| WKUP_DETECTOR_CNT_TH_6 | 0xac4    |
| WKUP_DETECTOR_CNT_TH_7 | 0xac8    |


### Fields

```wavejson
{"reg": [{"name": "TH", "bits": 8, "attr": ["rw"], "rotate": 0}, {"bits": 24}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                                                      |
|:------:|:------:|:-------:|:-------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  31:8  |        |         |        | Reserved                                                                                                                                                         |
|  7:0   |   rw   |   0x0   | TH     | Counter threshold for TimedLow and TimedHigh wakeup detector modes (see [`WKUP_DETECTOR`](#wkup_detector)). The threshold is in terms of always-on clock cycles. |

## WKUP_DETECTOR_PADSEL
Pad selects for pad wakeup condition detectors.
This register is NOT synced to the AON domain since the muxing mechanism is implemented in the same way as the pinmux muxing matrix.
- Reset default: `0x0`
- Reset mask: `0x3f`
- Register enable: [`WKUP_DETECTOR_REGWEN`](#wkup_detector_regwen)

### Instances

| Name                   | Offset   |
|:-----------------------|:---------|
| WKUP_DETECTOR_PADSEL_0 | 0xacc    |
| WKUP_DETECTOR_PADSEL_1 | 0xad0    |
| WKUP_DETECTOR_PADSEL_2 | 0xad4    |
| WKUP_DETECTOR_PADSEL_3 | 0xad8    |
| WKUP_DETECTOR_PADSEL_4 | 0xadc    |
| WKUP_DETECTOR_PADSEL_5 | 0xae0    |
| WKUP_DETECTOR_PADSEL_6 | 0xae4    |
| WKUP_DETECTOR_PADSEL_7 | 0xae8    |


### Fields

```wavejson
{"reg": [{"name": "SEL", "bits": 6, "attr": ["rw"], "rotate": 0}, {"bits": 26}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name                              |
|:------:|:------:|:-------:|:----------------------------------|
|  31:6  |        |         | Reserved                          |
|  5:0   |   rw   |   0x0   | [SEL](#wkup_detector_padsel--sel) |

### WKUP_DETECTOR_PADSEL . SEL
Selects a specific MIO or DIO pad (depending on [`WKUP_DETECTOR`](#wkup_detector) configuration).
In case of MIO, the pad select index is the same as used for [`MIO_PERIPH_INSEL`](#mio_periph_insel), meaning that index
0 and 1 just select constants 0 and 1, and the MIO pads live at indices >= 2. In case of DIO pads,
the pad select index corresponds 1:1 to the DIO pad to be selected.

## WKUP_CAUSE
Cause registers for wakeup detectors.
Note that these registers are synced to the always-on clock.
The first write access always completes immediately.
However, read/write accesses following a write will block until that write has completed.
- Offset: `0xaec`
- Reset default: `0x0`
- Reset mask: `0xff`

### Fields

```wavejson
{"reg": [{"name": "CAUSE_0", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "CAUSE_1", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "CAUSE_2", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "CAUSE_3", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "CAUSE_4", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "CAUSE_5", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "CAUSE_6", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"name": "CAUSE_7", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 24}], "config": {"lanes": 1, "fontsize": 10, "vspace": 90}}
```

|  Bits  |  Type  |  Reset  | Name    | Description                                                                             |
|:------:|:------:|:-------:|:--------|:----------------------------------------------------------------------------------------|
|  31:8  |        |         |         | Reserved                                                                                |
|   7    |  rw0c  |   0x0   | CAUSE_7 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |
|   6    |  rw0c  |   0x0   | CAUSE_6 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |
|   5    |  rw0c  |   0x0   | CAUSE_5 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |
|   4    |  rw0c  |   0x0   | CAUSE_4 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |
|   3    |  rw0c  |   0x0   | CAUSE_3 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |
|   2    |  rw0c  |   0x0   | CAUSE_2 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |
|   1    |  rw0c  |   0x0   | CAUSE_1 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |
|   0    |  rw0c  |   0x0   | CAUSE_0 | Set to 1 if the corresponding detector has detected a wakeup pattern. Write 0 to clear. |


<!-- END CMDGEN -->
