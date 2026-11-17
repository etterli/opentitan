// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

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
    integer                   tck_idx;
    integer                   tms_idx;
    integer                   trst_idx;
    integer                   tdi_idx;
    integer                   tdo_idx;
    integer                   tap_strap0_idx;
    integer                   tap_strap1_idx;
    integer                   dft_strap0_idx;
    integer                   dft_strap1_idx;
    integer                   usb_dp_idx;
    integer                   usb_dn_idx;
    integer                   usb_sense_idx;
    pad_type_e [NDioPads-1:0] dio_pad_type;
    pad_type_e [NMioPads-1:0] mio_pad_type;
    scan_role_e [NDioPads-1:0] dio_scan_role;
    scan_role_e [NMioPads-1:0] mio_scan_role;
  } target_cfg_t;

  parameter target_cfg_t DefaultTargetCfg = '{
    tck_idx:           0,
    tms_idx:           0,
    trst_idx:          0,
    tdi_idx:           0,
    tdo_idx:           0,
    tap_strap0_idx:    0,
    tap_strap1_idx:    0,
    dft_strap0_idx:    0,
    dft_strap1_idx:    0,
    usb_dp_idx:        0,
    usb_dn_idx:        0,
    usb_sense_idx:     0,
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

  // Legal MIO_PERIPH_INSEL values for each MIO peripheral input. LSB corresponds to lowest index.
  // Includes static options.
  parameter logic [NMioPeriphIn-1:0][NMioPads+1:0] MioPeriphInselLegal = {
    49'h1ffffffffffff, // 37: usbdev_sense
    49'h1ffffffffffff, // 36: flash_ctrl_tdi
    49'h1ffffffffffff, // 35: flash_ctrl_tms
    49'h1ffffffffffff, // 34: flash_ctrl_tck
    49'h1ffffffffffff, // 33: uart1_rx
    49'h1ffffffffffff, // 32: uart0_rx
    49'h1ffffffffffff, // 31: gpio0_gpio[31]
    49'h1ffffffffffff, // 30: gpio0_gpio[30]
    49'h1ffffffffffff, // 29: gpio0_gpio[29]
    49'h1ffffffffffff, // 28: gpio0_gpio[28]
    49'h1ffffffffffff, // 27: gpio0_gpio[27]
    49'h1ffffffffffff, // 26: gpio0_gpio[26]
    49'h1ffffffffffff, // 25: gpio0_gpio[25]
    49'h1ffffffffffff, // 24: gpio0_gpio[24]
    49'h1ffffffffffff, // 23: gpio0_gpio[23]
    49'h1ffffffffffff, // 22: gpio0_gpio[22]
    49'h1ffffffffffff, // 21: gpio0_gpio[21]
    49'h1ffffffffffff, // 20: gpio0_gpio[20]
    49'h1ffffffffffff, // 19: gpio0_gpio[19]
    49'h1ffffffffffff, // 18: gpio0_gpio[18]
    49'h1ffffffffffff, // 17: gpio0_gpio[17]
    49'h1ffffffffffff, // 16: gpio0_gpio[16]
    49'h1ffffffffffff, // 15: gpio0_gpio[15]
    49'h1ffffffffffff, // 14: gpio0_gpio[14]
    49'h1ffffffffffff, // 13: gpio0_gpio[13]
    49'h1ffffffffffff, // 12: gpio0_gpio[12]
    49'h1ffffffffffff, // 11: gpio0_gpio[11]
    49'h1ffffffffffff, // 10: gpio0_gpio[10]
    49'h1ffffffffffff, //  9: gpio0_gpio[9]
    49'h1ffffffffffff, //  8: gpio0_gpio[8]
    49'h1ffffffffffff, //  7: gpio0_gpio[7]
    49'h1ffffffffffff, //  6: gpio0_gpio[6]
    49'h1ffffffffffff, //  5: gpio0_gpio[5]
    49'h1ffffffffffff, //  4: gpio0_gpio[4]
    49'h1ffffffffffff, //  3: gpio0_gpio[3]
    49'h1ffffffffffff, //  2: gpio0_gpio[2]
    49'h1ffffffffffff, //  1: gpio0_gpio[1]
    49'h1ffffffffffff  //  0: gpio0_gpio[0]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    38'h3fffffffff, // 46: IOR13
    38'h3fffffffff, // 45: IOR12
    38'h3fffffffff, // 44: IOR11
    38'h3fffffffff, // 43: IOR10
    38'h3fffffffff, // 42: IOR7
    38'h3fffffffff, // 41: IOR6
    38'h3fffffffff, // 40: IOR5
    38'h3fffffffff, // 39: IOR4
    38'h3fffffffff, // 38: IOR3
    38'h3fffffffff, // 37: IOR2
    38'h3fffffffff, // 36: IOR1
    38'h3fffffffff, // 35: IOR0
    38'h3fffffffff, // 34: IOC12
    38'h3fffffffff, // 33: IOC11
    38'h3fffffffff, // 32: IOC10
    38'h3fffffffff, // 31: IOC9
    38'h3fffffffff, // 30: IOC8
    38'h3fffffffff, // 29: IOC7
    38'h3fffffffff, // 28: IOC6
    38'h3fffffffff, // 27: IOC5
    38'h3fffffffff, // 26: IOC4
    38'h3fffffffff, // 25: IOC3
    38'h3fffffffff, // 24: IOC2
    38'h3fffffffff, // 23: IOC1
    38'h3fffffffff, // 22: IOC0
    38'h3fffffffff, // 21: IOB12
    38'h3fffffffff, // 20: IOB11
    38'h3fffffffff, // 19: IOB10
    38'h3fffffffff, // 18: IOB9
    38'h3fffffffff, // 17: IOB8
    38'h3fffffffff, // 16: IOB7
    38'h3fffffffff, // 15: IOB6
    38'h3fffffffff, // 14: IOB5
    38'h3fffffffff, // 13: IOB4
    38'h3fffffffff, // 12: IOB3
    38'h3fffffffff, // 11: IOB2
    38'h3fffffffff, // 10: IOB1
    38'h3fffffffff, //  9: IOB0
    38'h3fffffffff, //  8: IOA8
    38'h3fffffffff, //  7: IOA7
    38'h3fffffffff, //  6: IOA6
    38'h3fffffffff, //  5: IOA5
    38'h3fffffffff, //  4: IOA4
    38'h3fffffffff, //  3: IOA3
    38'h3fffffffff, //  2: IOA2
    38'h3fffffffff, //  1: IOA1
    38'h3fffffffff  //  0: IOA0
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
    MuxPartPrimary, // 37: usbdev_sense
    MuxPartPrimary, // 36: flash_ctrl_tdi
    MuxPartPrimary, // 35: flash_ctrl_tms
    MuxPartPrimary, // 34: flash_ctrl_tck
    MuxPartPrimary, // 33: uart1_rx
    MuxPartPrimary, // 32: uart0_rx
    MuxPartPrimary, // 31: gpio0_gpio[31]
    MuxPartPrimary, // 30: gpio0_gpio[30]
    MuxPartPrimary, // 29: gpio0_gpio[29]
    MuxPartPrimary, // 28: gpio0_gpio[28]
    MuxPartPrimary, // 27: gpio0_gpio[27]
    MuxPartPrimary, // 26: gpio0_gpio[26]
    MuxPartPrimary, // 25: gpio0_gpio[25]
    MuxPartPrimary, // 24: gpio0_gpio[24]
    MuxPartPrimary, // 23: gpio0_gpio[23]
    MuxPartPrimary, // 22: gpio0_gpio[22]
    MuxPartPrimary, // 21: gpio0_gpio[21]
    MuxPartPrimary, // 20: gpio0_gpio[20]
    MuxPartPrimary, // 19: gpio0_gpio[19]
    MuxPartPrimary, // 18: gpio0_gpio[18]
    MuxPartPrimary, // 17: gpio0_gpio[17]
    MuxPartPrimary, // 16: gpio0_gpio[16]
    MuxPartPrimary, // 15: gpio0_gpio[15]
    MuxPartPrimary, // 14: gpio0_gpio[14]
    MuxPartPrimary, // 13: gpio0_gpio[13]
    MuxPartPrimary, // 12: gpio0_gpio[12]
    MuxPartPrimary, // 11: gpio0_gpio[11]
    MuxPartPrimary, // 10: gpio0_gpio[10]
    MuxPartPrimary, //  9: gpio0_gpio[9]
    MuxPartPrimary, //  8: gpio0_gpio[8]
    MuxPartPrimary, //  7: gpio0_gpio[7]
    MuxPartPrimary, //  6: gpio0_gpio[6]
    MuxPartPrimary, //  5: gpio0_gpio[5]
    MuxPartPrimary, //  4: gpio0_gpio[4]
    MuxPartPrimary, //  3: gpio0_gpio[3]
    MuxPartPrimary, //  2: gpio0_gpio[2]
    MuxPartPrimary, //  1: gpio0_gpio[1]
    MuxPartPrimary  //  0: gpio0_gpio[0]
  };

  // Whether the source of each MIO_OUTSEL value is in the primary partition. LSB corresponds to
  // lowest index. Includes the static options, which exist in both partitions.
  parameter logic [AlignedMioOutMuxSize-1:0] MioOutselInPrimary = AlignedMioOutMuxSize'({
    1'b1, // 37: flash_ctrl_tdo
    1'b1, // 36: uart1_tx
    1'b1, // 35: uart0_tx
    1'b1, // 34: gpio0_gpio[31]
    1'b1, // 33: gpio0_gpio[30]
    1'b1, // 32: gpio0_gpio[29]
    1'b1, // 31: gpio0_gpio[28]
    1'b1, // 30: gpio0_gpio[27]
    1'b1, // 29: gpio0_gpio[26]
    1'b1, // 28: gpio0_gpio[25]
    1'b1, // 27: gpio0_gpio[24]
    1'b1, // 26: gpio0_gpio[23]
    1'b1, // 25: gpio0_gpio[22]
    1'b1, // 24: gpio0_gpio[21]
    1'b1, // 23: gpio0_gpio[20]
    1'b1, // 22: gpio0_gpio[19]
    1'b1, // 21: gpio0_gpio[18]
    1'b1, // 20: gpio0_gpio[17]
    1'b1, // 19: gpio0_gpio[16]
    1'b1, // 18: gpio0_gpio[15]
    1'b1, // 17: gpio0_gpio[14]
    1'b1, // 16: gpio0_gpio[13]
    1'b1, // 15: gpio0_gpio[12]
    1'b1, // 14: gpio0_gpio[11]
    1'b1, // 13: gpio0_gpio[10]
    1'b1, // 12: gpio0_gpio[9]
    1'b1, // 11: gpio0_gpio[8]
    1'b1, // 10: gpio0_gpio[7]
    1'b1, //  9: gpio0_gpio[6]
    1'b1, //  8: gpio0_gpio[5]
    1'b1, //  7: gpio0_gpio[4]
    1'b1, //  6: gpio0_gpio[3]
    1'b1, //  5: gpio0_gpio[2]
    1'b1, //  4: gpio0_gpio[1]
    1'b1, //  3: gpio0_gpio[0]
    3'b111  // 2..0: static options
  });

  // Whether the output mux of each MIO pad is in the primary partition. This is the case if any
  // legal peripheral output of the pad is in the primary partition. LSB corresponds to lowest
  // index.
  parameter logic [NMioPads-1:0] MioPadMuxedInPrimary = {
    1'b1, // 46: IOR13
    1'b1, // 45: IOR12
    1'b1, // 44: IOR11
    1'b1, // 43: IOR10
    1'b1, // 42: IOR7
    1'b1, // 41: IOR6
    1'b1, // 40: IOR5
    1'b1, // 39: IOR4
    1'b1, // 38: IOR3
    1'b1, // 37: IOR2
    1'b1, // 36: IOR1
    1'b1, // 35: IOR0
    1'b1, // 34: IOC12
    1'b1, // 33: IOC11
    1'b1, // 32: IOC10
    1'b1, // 31: IOC9
    1'b1, // 30: IOC8
    1'b1, // 29: IOC7
    1'b1, // 28: IOC6
    1'b1, // 27: IOC5
    1'b1, // 26: IOC4
    1'b1, // 25: IOC3
    1'b1, // 24: IOC2
    1'b1, // 23: IOC1
    1'b1, // 22: IOC0
    1'b1, // 21: IOB12
    1'b1, // 20: IOB11
    1'b1, // 19: IOB10
    1'b1, // 18: IOB9
    1'b1, // 17: IOB8
    1'b1, // 16: IOB7
    1'b1, // 15: IOB6
    1'b1, // 14: IOB5
    1'b1, // 13: IOB4
    1'b1, // 12: IOB3
    1'b1, // 11: IOB2
    1'b1, // 10: IOB1
    1'b1, //  9: IOB0
    1'b1, //  8: IOA8
    1'b1, //  7: IOA7
    1'b1, //  6: IOA6
    1'b1, //  5: IOA5
    1'b1, //  4: IOA4
    1'b1, //  3: IOA3
    1'b1, //  2: IOA2
    1'b1, //  1: IOA1
    1'b1  //  0: IOA0
  };

  // Whether any MIO peripheral input is muxed in the primary or secondary partition.
  parameter bit AnyMioInMuxedInPrimary   = |(MioPeriphInPart & {NMioPeriphIn{MuxPartPrimary}});
  parameter bit AnyMioInMuxedInSecondary = |(MioPeriphInPart & {NMioPeriphIn{MuxPartSecondary}});

  // Whether any MIO pad is muxed in the primary or secondary partition.
  parameter bit AnyMioPadMuxedInPrimary   = |MioPadMuxedInPrimary;
  parameter bit AnyMioPadMuxedInSecondary = !(&MioPadMuxedInPrimary);

  // Reset values of the MIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NMioPads-1:0] MioPadAttrResval = {
    pad_attr_t'{default: '0}, // 46: IOR13
    pad_attr_t'{default: '0}, // 45: IOR12
    pad_attr_t'{default: '0}, // 44: IOR11
    pad_attr_t'{default: '0}, // 43: IOR10
    pad_attr_t'{default: '0}, // 42: IOR7
    pad_attr_t'{default: '0}, // 41: IOR6
    pad_attr_t'{default: '0}, // 40: IOR5
    pad_attr_t'{default: '0}, // 39: IOR4
    pad_attr_t'{default: '0}, // 38: IOR3
    pad_attr_t'{default: '0}, // 37: IOR2
    pad_attr_t'{default: '0}, // 36: IOR1
    pad_attr_t'{default: '0}, // 35: IOR0
    pad_attr_t'{default: '0}, // 34: IOC12
    pad_attr_t'{default: '0}, // 33: IOC11
    pad_attr_t'{default: '0}, // 32: IOC10
    pad_attr_t'{default: '0}, // 31: IOC9
    pad_attr_t'{pull_en: 1'h1, default: '0}, // 30: IOC8
    pad_attr_t'{default: '0}, // 29: IOC7
    pad_attr_t'{default: '0}, // 28: IOC6
    pad_attr_t'{default: '0}, // 27: IOC5
    pad_attr_t'{default: '0}, // 26: IOC4
    pad_attr_t'{default: '0}, // 25: IOC3
    pad_attr_t'{default: '0}, // 24: IOC2
    pad_attr_t'{default: '0}, // 23: IOC1
    pad_attr_t'{default: '0}, // 22: IOC0
    pad_attr_t'{default: '0}, // 21: IOB12
    pad_attr_t'{default: '0}, // 20: IOB11
    pad_attr_t'{default: '0}, // 19: IOB10
    pad_attr_t'{default: '0}, // 18: IOB9
    pad_attr_t'{default: '0}, // 17: IOB8
    pad_attr_t'{default: '0}, // 16: IOB7
    pad_attr_t'{default: '0}, // 15: IOB6
    pad_attr_t'{default: '0}, // 14: IOB5
    pad_attr_t'{default: '0}, // 13: IOB4
    pad_attr_t'{default: '0}, // 12: IOB3
    pad_attr_t'{default: '0}, // 11: IOB2
    pad_attr_t'{default: '0}, // 10: IOB1
    pad_attr_t'{default: '0}, //  9: IOB0
    pad_attr_t'{default: '0}, //  8: IOA8
    pad_attr_t'{default: '0}, //  7: IOA7
    pad_attr_t'{default: '0}, //  6: IOA6
    pad_attr_t'{default: '0}, //  5: IOA5
    pad_attr_t'{default: '0}, //  4: IOA4
    pad_attr_t'{default: '0}, //  3: IOA3
    pad_attr_t'{default: '0}, //  2: IOA2
    pad_attr_t'{default: '0}, //  1: IOA1
    pad_attr_t'{default: '0}  //  0: IOA0
  };

  // Reset values of the DIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
    pad_attr_t'{default: '0}, // 13: SPI_HOST_CS_L
    pad_attr_t'{default: '0}, // 12: SPI_HOST_CLK
    pad_attr_t'{default: '0}, // 11: SPI_DEV_CS_L
    pad_attr_t'{default: '0}, // 10: SPI_DEV_CLK
    pad_attr_t'{default: '0}, //  9: usbdev_usb_dn
    pad_attr_t'{default: '0}, //  8: usbdev_usb_dp
    pad_attr_t'{default: '0}, //  7: SPI_DEV_D3
    pad_attr_t'{default: '0}, //  6: SPI_DEV_D2
    pad_attr_t'{default: '0}, //  5: SPI_DEV_D1
    pad_attr_t'{default: '0}, //  4: SPI_DEV_D0
    pad_attr_t'{default: '0}, //  3: SPI_HOST_D3
    pad_attr_t'{default: '0}, //  2: SPI_HOST_D2
    pad_attr_t'{default: '0}, //  1: SPI_HOST_D1
    pad_attr_t'{default: '0}  //  0: SPI_HOST_D0
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
