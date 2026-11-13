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
    49'h1ffffffffffff, // usbdev_sense
    49'h1ffffffffffff, // flash_ctrl_tdi
    49'h1ffffffffffff, // flash_ctrl_tms
    49'h1ffffffffffff, // flash_ctrl_tck
    49'h1ffffffffffff, // uart1_rx
    49'h1ffffffffffff, // uart0_rx
    49'h1ffffffffffff, // gpio0_gpio[31]
    49'h1ffffffffffff, // gpio0_gpio[30]
    49'h1ffffffffffff, // gpio0_gpio[29]
    49'h1ffffffffffff, // gpio0_gpio[28]
    49'h1ffffffffffff, // gpio0_gpio[27]
    49'h1ffffffffffff, // gpio0_gpio[26]
    49'h1ffffffffffff, // gpio0_gpio[25]
    49'h1ffffffffffff, // gpio0_gpio[24]
    49'h1ffffffffffff, // gpio0_gpio[23]
    49'h1ffffffffffff, // gpio0_gpio[22]
    49'h1ffffffffffff, // gpio0_gpio[21]
    49'h1ffffffffffff, // gpio0_gpio[20]
    49'h1ffffffffffff, // gpio0_gpio[19]
    49'h1ffffffffffff, // gpio0_gpio[18]
    49'h1ffffffffffff, // gpio0_gpio[17]
    49'h1ffffffffffff, // gpio0_gpio[16]
    49'h1ffffffffffff, // gpio0_gpio[15]
    49'h1ffffffffffff, // gpio0_gpio[14]
    49'h1ffffffffffff, // gpio0_gpio[13]
    49'h1ffffffffffff, // gpio0_gpio[12]
    49'h1ffffffffffff, // gpio0_gpio[11]
    49'h1ffffffffffff, // gpio0_gpio[10]
    49'h1ffffffffffff, // gpio0_gpio[9]
    49'h1ffffffffffff, // gpio0_gpio[8]
    49'h1ffffffffffff, // gpio0_gpio[7]
    49'h1ffffffffffff, // gpio0_gpio[6]
    49'h1ffffffffffff, // gpio0_gpio[5]
    49'h1ffffffffffff, // gpio0_gpio[4]
    49'h1ffffffffffff, // gpio0_gpio[3]
    49'h1ffffffffffff, // gpio0_gpio[2]
    49'h1ffffffffffff, // gpio0_gpio[1]
    49'h1ffffffffffff  // gpio0_gpio[0]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    38'h3fffffffff, // IOR13
    38'h3fffffffff, // IOR12
    38'h3fffffffff, // IOR11
    38'h3fffffffff, // IOR10
    38'h3fffffffff, // IOR7
    38'h3fffffffff, // IOR6
    38'h3fffffffff, // IOR5
    38'h3fffffffff, // IOR4
    38'h3fffffffff, // IOR3
    38'h3fffffffff, // IOR2
    38'h3fffffffff, // IOR1
    38'h3fffffffff, // IOR0
    38'h3fffffffff, // IOC12
    38'h3fffffffff, // IOC11
    38'h3fffffffff, // IOC10
    38'h3fffffffff, // IOC9
    38'h3fffffffff, // IOC8
    38'h3fffffffff, // IOC7
    38'h3fffffffff, // IOC6
    38'h3fffffffff, // IOC5
    38'h3fffffffff, // IOC4
    38'h3fffffffff, // IOC3
    38'h3fffffffff, // IOC2
    38'h3fffffffff, // IOC1
    38'h3fffffffff, // IOC0
    38'h3fffffffff, // IOB12
    38'h3fffffffff, // IOB11
    38'h3fffffffff, // IOB10
    38'h3fffffffff, // IOB9
    38'h3fffffffff, // IOB8
    38'h3fffffffff, // IOB7
    38'h3fffffffff, // IOB6
    38'h3fffffffff, // IOB5
    38'h3fffffffff, // IOB4
    38'h3fffffffff, // IOB3
    38'h3fffffffff, // IOB2
    38'h3fffffffff, // IOB1
    38'h3fffffffff, // IOB0
    38'h3fffffffff, // IOA8
    38'h3fffffffff, // IOA7
    38'h3fffffffff, // IOA6
    38'h3fffffffff, // IOA5
    38'h3fffffffff, // IOA4
    38'h3fffffffff, // IOA3
    38'h3fffffffff, // IOA2
    38'h3fffffffff, // IOA1
    38'h3fffffffff  // IOA0
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
    MuxPartPrimary, // usbdev_sense
    MuxPartPrimary, // flash_ctrl_tdi
    MuxPartPrimary, // flash_ctrl_tms
    MuxPartPrimary, // flash_ctrl_tck
    MuxPartPrimary, // uart1_rx
    MuxPartPrimary, // uart0_rx
    MuxPartPrimary, // gpio0_gpio[31]
    MuxPartPrimary, // gpio0_gpio[30]
    MuxPartPrimary, // gpio0_gpio[29]
    MuxPartPrimary, // gpio0_gpio[28]
    MuxPartPrimary, // gpio0_gpio[27]
    MuxPartPrimary, // gpio0_gpio[26]
    MuxPartPrimary, // gpio0_gpio[25]
    MuxPartPrimary, // gpio0_gpio[24]
    MuxPartPrimary, // gpio0_gpio[23]
    MuxPartPrimary, // gpio0_gpio[22]
    MuxPartPrimary, // gpio0_gpio[21]
    MuxPartPrimary, // gpio0_gpio[20]
    MuxPartPrimary, // gpio0_gpio[19]
    MuxPartPrimary, // gpio0_gpio[18]
    MuxPartPrimary, // gpio0_gpio[17]
    MuxPartPrimary, // gpio0_gpio[16]
    MuxPartPrimary, // gpio0_gpio[15]
    MuxPartPrimary, // gpio0_gpio[14]
    MuxPartPrimary, // gpio0_gpio[13]
    MuxPartPrimary, // gpio0_gpio[12]
    MuxPartPrimary, // gpio0_gpio[11]
    MuxPartPrimary, // gpio0_gpio[10]
    MuxPartPrimary, // gpio0_gpio[9]
    MuxPartPrimary, // gpio0_gpio[8]
    MuxPartPrimary, // gpio0_gpio[7]
    MuxPartPrimary, // gpio0_gpio[6]
    MuxPartPrimary, // gpio0_gpio[5]
    MuxPartPrimary, // gpio0_gpio[4]
    MuxPartPrimary, // gpio0_gpio[3]
    MuxPartPrimary, // gpio0_gpio[2]
    MuxPartPrimary, // gpio0_gpio[1]
    MuxPartPrimary  // gpio0_gpio[0]
  };

  // Whether the source of each MIO_OUTSEL value is in the primary partition. LSB corresponds to
  // lowest index. Includes the static options, which exist in both partitions.
  parameter logic [AlignedMioOutMuxSize-1:0] MioOutselInPrimary = AlignedMioOutMuxSize'({
    1'b1, // flash_ctrl_tdo
    1'b1, // uart1_tx
    1'b1, // uart0_tx
    1'b1, // gpio0_gpio[31]
    1'b1, // gpio0_gpio[30]
    1'b1, // gpio0_gpio[29]
    1'b1, // gpio0_gpio[28]
    1'b1, // gpio0_gpio[27]
    1'b1, // gpio0_gpio[26]
    1'b1, // gpio0_gpio[25]
    1'b1, // gpio0_gpio[24]
    1'b1, // gpio0_gpio[23]
    1'b1, // gpio0_gpio[22]
    1'b1, // gpio0_gpio[21]
    1'b1, // gpio0_gpio[20]
    1'b1, // gpio0_gpio[19]
    1'b1, // gpio0_gpio[18]
    1'b1, // gpio0_gpio[17]
    1'b1, // gpio0_gpio[16]
    1'b1, // gpio0_gpio[15]
    1'b1, // gpio0_gpio[14]
    1'b1, // gpio0_gpio[13]
    1'b1, // gpio0_gpio[12]
    1'b1, // gpio0_gpio[11]
    1'b1, // gpio0_gpio[10]
    1'b1, // gpio0_gpio[9]
    1'b1, // gpio0_gpio[8]
    1'b1, // gpio0_gpio[7]
    1'b1, // gpio0_gpio[6]
    1'b1, // gpio0_gpio[5]
    1'b1, // gpio0_gpio[4]
    1'b1, // gpio0_gpio[3]
    1'b1, // gpio0_gpio[2]
    1'b1, // gpio0_gpio[1]
    1'b1, // gpio0_gpio[0]
    3'b111  // static options
  });

  // Whether the output mux of each MIO pad is in the primary partition. This is the case if any
  // legal peripheral output of the pad is in the primary partition. LSB corresponds to lowest
  // index.
  parameter logic [NMioPads-1:0] MioPadMuxedInPrimary = {
    1'b1, // IOR13
    1'b1, // IOR12
    1'b1, // IOR11
    1'b1, // IOR10
    1'b1, // IOR7
    1'b1, // IOR6
    1'b1, // IOR5
    1'b1, // IOR4
    1'b1, // IOR3
    1'b1, // IOR2
    1'b1, // IOR1
    1'b1, // IOR0
    1'b1, // IOC12
    1'b1, // IOC11
    1'b1, // IOC10
    1'b1, // IOC9
    1'b1, // IOC8
    1'b1, // IOC7
    1'b1, // IOC6
    1'b1, // IOC5
    1'b1, // IOC4
    1'b1, // IOC3
    1'b1, // IOC2
    1'b1, // IOC1
    1'b1, // IOC0
    1'b1, // IOB12
    1'b1, // IOB11
    1'b1, // IOB10
    1'b1, // IOB9
    1'b1, // IOB8
    1'b1, // IOB7
    1'b1, // IOB6
    1'b1, // IOB5
    1'b1, // IOB4
    1'b1, // IOB3
    1'b1, // IOB2
    1'b1, // IOB1
    1'b1, // IOB0
    1'b1, // IOA8
    1'b1, // IOA7
    1'b1, // IOA6
    1'b1, // IOA5
    1'b1, // IOA4
    1'b1, // IOA3
    1'b1, // IOA2
    1'b1, // IOA1
    1'b1  // IOA0
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NMioPads-1:0] MioPadAttrResval = {
    pad_attr_t'{default: '0}, // IOR13
    pad_attr_t'{default: '0}, // IOR12
    pad_attr_t'{default: '0}, // IOR11
    pad_attr_t'{default: '0}, // IOR10
    pad_attr_t'{default: '0}, // IOR7
    pad_attr_t'{default: '0}, // IOR6
    pad_attr_t'{default: '0}, // IOR5
    pad_attr_t'{default: '0}, // IOR4
    pad_attr_t'{default: '0}, // IOR3
    pad_attr_t'{default: '0}, // IOR2
    pad_attr_t'{default: '0}, // IOR1
    pad_attr_t'{default: '0}, // IOR0
    pad_attr_t'{default: '0}, // IOC12
    pad_attr_t'{default: '0}, // IOC11
    pad_attr_t'{default: '0}, // IOC10
    pad_attr_t'{default: '0}, // IOC9
    pad_attr_t'{pull_en: 1'h1, default: '0}, // IOC8
    pad_attr_t'{default: '0}, // IOC7
    pad_attr_t'{default: '0}, // IOC6
    pad_attr_t'{default: '0}, // IOC5
    pad_attr_t'{default: '0}, // IOC4
    pad_attr_t'{default: '0}, // IOC3
    pad_attr_t'{default: '0}, // IOC2
    pad_attr_t'{default: '0}, // IOC1
    pad_attr_t'{default: '0}, // IOC0
    pad_attr_t'{default: '0}, // IOB12
    pad_attr_t'{default: '0}, // IOB11
    pad_attr_t'{default: '0}, // IOB10
    pad_attr_t'{default: '0}, // IOB9
    pad_attr_t'{default: '0}, // IOB8
    pad_attr_t'{default: '0}, // IOB7
    pad_attr_t'{default: '0}, // IOB6
    pad_attr_t'{default: '0}, // IOB5
    pad_attr_t'{default: '0}, // IOB4
    pad_attr_t'{default: '0}, // IOB3
    pad_attr_t'{default: '0}, // IOB2
    pad_attr_t'{default: '0}, // IOB1
    pad_attr_t'{default: '0}, // IOB0
    pad_attr_t'{default: '0}, // IOA8
    pad_attr_t'{default: '0}, // IOA7
    pad_attr_t'{default: '0}, // IOA6
    pad_attr_t'{default: '0}, // IOA5
    pad_attr_t'{default: '0}, // IOA4
    pad_attr_t'{default: '0}, // IOA3
    pad_attr_t'{default: '0}, // IOA2
    pad_attr_t'{default: '0}, // IOA1
    pad_attr_t'{default: '0}  // IOA0
  };

  // Reset values of the DIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
    pad_attr_t'{default: '0}, // SPI_HOST_CS_L
    pad_attr_t'{default: '0}, // SPI_HOST_CLK
    pad_attr_t'{default: '0}, // SPI_DEV_CS_L
    pad_attr_t'{default: '0}, // SPI_DEV_CLK
    pad_attr_t'{default: '0}, // usbdev_usb_dn
    pad_attr_t'{default: '0}, // usbdev_usb_dp
    pad_attr_t'{default: '0}, // SPI_DEV_D3
    pad_attr_t'{default: '0}, // SPI_DEV_D2
    pad_attr_t'{default: '0}, // SPI_DEV_D1
    pad_attr_t'{default: '0}, // SPI_DEV_D0
    pad_attr_t'{default: '0}, // SPI_HOST_D3
    pad_attr_t'{default: '0}, // SPI_HOST_D2
    pad_attr_t'{default: '0}, // SPI_HOST_D1
    pad_attr_t'{default: '0}  // SPI_HOST_D0
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
