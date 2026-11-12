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

  // Legal MIO_PERIPH_INSEL values for each MIO peripheral input. LSB corresponds to lowest index.
  // Includes static options.
  parameter logic [NMioPeriphIn-1:0][NMioPads+1:0] MioPeriphInselLegal = {
    51'h1000000000003, // sysrst_ctrl_lid_open
    51'h0002000000003, // sysrst_ctrl_pwrb_in
    51'h0040000000003, // sysrst_ctrl_key2_in
    51'h0010000000003, // sysrst_ctrl_key1_in
    51'h0004000000003, // sysrst_ctrl_key0_in
    51'h0008000000003, // sysrst_ctrl_ac_present
    51'h7ffffffffffff, // spi_device_tpm_csb
    51'h1000000a00003, // i3c1_rstdet_sda
    51'h0800000500003, // i3c1_rstdet_scl
    51'h4000000800203, // i3c0_rstdet_sda
    51'h2000000400403, // i3c0_rstdet_scl
    51'h0010000000043, // uart3_rx
    51'h0000400008003, // uart2_rx
    51'h0040000000007, // uart1_rx
    51'h0000008000013, // uart0_rx
    51'h7ffffffffffff, // usbdev_sense
    51'h0400000000003, // sysrst_ctrl_flash_wp_l
    51'h0200000000003, // sysrst_ctrl_ec_rst_l
    51'h7ffffffffffff, // spi_host1_sd[3]
    51'h7ffffffffffff, // spi_host1_sd[2]
    51'h7ffffffffffff, // spi_host1_sd[1]
    51'h7ffffffffffff, // spi_host1_sd[0]
    51'h1000000a00003, // i3c1_sda
    51'h0800000500003, // i3c1_scl
    51'h4000000800203, // i3c0_sda
    51'h2000000400403, // i3c0_scl
    51'h0000200300403, // i2c2_scl
    51'h0001000300203, // i2c2_sda
    51'h0800000c00003, // i2c1_scl
    51'h1000000c00003, // i2c1_sda
    51'h2000000100403, // i2c0_scl
    51'h4000000200203, // i2c0_sda
    51'h7ffffffffffff, // gpio1_gpio[31]
    51'h7ffffffffffff, // gpio1_gpio[30]
    51'h7ffffffffffff, // gpio1_gpio[29]
    51'h7ffffffffffff, // gpio1_gpio[28]
    51'h7ffffffffffff, // gpio1_gpio[27]
    51'h7ffffffffffff, // gpio1_gpio[26]
    51'h7ffffffffffff, // gpio1_gpio[25]
    51'h7ffffffffffff, // gpio1_gpio[24]
    51'h7ffffffffffff, // gpio1_gpio[23]
    51'h7ffffffffffff, // gpio1_gpio[22]
    51'h7ffffffffffff, // gpio1_gpio[21]
    51'h7ffffffffffff, // gpio1_gpio[20]
    51'h7ffffffffffff, // gpio1_gpio[19]
    51'h7ffffffffffff, // gpio1_gpio[18]
    51'h7ffffffffffff, // gpio1_gpio[17]
    51'h7ffffffffffff, // gpio1_gpio[16]
    51'h7ffffffffffff, // gpio1_gpio[15]
    51'h7ffffffffffff, // gpio1_gpio[14]
    51'h7ffffffffffff, // gpio1_gpio[13]
    51'h7ffffffffffff, // gpio1_gpio[12]
    51'h7ffffffffffff, // gpio1_gpio[11]
    51'h7ffffffffffff, // gpio1_gpio[10]
    51'h7ffffffffffff, // gpio1_gpio[9]
    51'h7ffffffffffff, // gpio1_gpio[8]
    51'h7ffffffffffff, // gpio1_gpio[7]
    51'h7ffffffffffff, // gpio1_gpio[6]
    51'h7ffffffffffff, // gpio1_gpio[5]
    51'h7ffffffffffff, // gpio1_gpio[4]
    51'h7ffffffffffff, // gpio1_gpio[3]
    51'h7ffffffffffff, // gpio1_gpio[2]
    51'h7ffffffffffff, // gpio1_gpio[1]
    51'h7ffffffffffff, // gpio1_gpio[0]
    51'h7ffffffffffff, // gpio0_gpio[31]
    51'h7ffffffffffff, // gpio0_gpio[30]
    51'h7ffffffffffff, // gpio0_gpio[29]
    51'h7ffffffffffff, // gpio0_gpio[28]
    51'h7ffffffffffff, // gpio0_gpio[27]
    51'h7ffffffffffff, // gpio0_gpio[26]
    51'h7ffffffffffff, // gpio0_gpio[25]
    51'h7ffffffffffff, // gpio0_gpio[24]
    51'h7ffffffffffff, // gpio0_gpio[23]
    51'h7ffffffffffff, // gpio0_gpio[22]
    51'h7ffffffffffff, // gpio0_gpio[21]
    51'h7ffffffffffff, // gpio0_gpio[20]
    51'h7ffffffffffff, // gpio0_gpio[19]
    51'h7ffffffffffff, // gpio0_gpio[18]
    51'h7ffffffffffff, // gpio0_gpio[17]
    51'h7ffffffffffff, // gpio0_gpio[16]
    51'h7ffffffffffff, // gpio0_gpio[15]
    51'h7ffffffffffff, // gpio0_gpio[14]
    51'h7ffffffffffff, // gpio0_gpio[13]
    51'h7ffffffffffff, // gpio0_gpio[12]
    51'h7ffffffffffff, // gpio0_gpio[11]
    51'h7ffffffffffff, // gpio0_gpio[10]
    51'h7ffffffffffff, // gpio0_gpio[9]
    51'h7ffffffffffff, // gpio0_gpio[8]
    51'h7ffffffffffff, // gpio0_gpio[7]
    51'h7ffffffffffff, // gpio0_gpio[6]
    51'h7ffffffffffff, // gpio0_gpio[5]
    51'h7ffffffffffff, // gpio0_gpio[4]
    51'h7ffffffffffff, // gpio0_gpio[3]
    51'h7ffffffffffff, // gpio0_gpio[2]
    51'h7ffffffffffff, // gpio0_gpio[1]
    51'h7ffffffffffff  // gpio0_gpio[0]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    110'h04fffe01e40fffffffffffffffff, // IOR13
    110'h01fffe01e217ffffffffffffffff, // IOR12
    110'h00fffe01f027ffffffffffffffff, // IOR11
    110'h10fffe01e847ffffffffffffffff, // IOR10
    110'h00fffe05e007ffffffffffffffff, // IOR9
    110'h00fffe03e007ffffffffffffffff, // IOR8
    110'h08fffe81e007ffffffffffffffff, // IOR7
    110'h02fffe11e007ffffffffffffffff, // IOR6
    110'h00fffe01e007ffffffffffffffff, // IOR5
    110'h20fffe41e007ffffffffffffffff, // IOR4
    110'h00fffe01e007ffffffffffffffff, // IOR3
    110'h00ffff01e007ffffffffffffffff, // IOR2
    110'h00fffe01e007ffffffffffffffff, // IOR1
    110'h00fffe01e007ffffffffffffffff, // IOR0
    110'h00fffe01e087ffffffffffffffff, // IOC12
    110'h00fffe21e007ffffffffffffffff, // IOC11
    110'h00fffe01e007ffffffffffffffff, // IOC10
    110'h00fffe01e107ffffffffffffffff, // IOC9
    110'h00fffe01e007ffffffffffffffff, // IOC8
    110'h00fffe01e007ffffffffffffffff, // IOC7
    110'h00fffe01e007ffffffffffffffff, // IOC6
    110'h00fffe01e007ffffffffffffffff, // IOC5
    110'h00fffe09e007ffffffffffffffff, // IOC4
    110'h00fffe01e007ffffffffffffffff, // IOC3
    110'h00fffe01e007ffffffffffffffff, // IOC2
    110'h00fffe01e007ffffffffffffffff, // IOC1
    110'h00fffe01e007ffffffffffffffff, // IOC0
    110'h00fffe01f467ffffffffffffffff, // IOB12
    110'h00fffe01ea67ffffffffffffffff, // IOB11
    110'h00ffff01f18fffffffffffffffff, // IOB10
    110'h00fffe01e997ffffffffffffffff, // IOB9
    110'h00fffe81e007ffffffffffffffff, // IOB8
    110'h00ffff01e007ffffffffffffffff, // IOB7
    110'h00fffe01e007ffffffffffffffff, // IOB6
    110'h00fffe21e007ffffffffffffffff, // IOB5
    110'h00fffe01e007ffffffffffffffff, // IOB4
    110'h00fffe01e007ffffffffffffffff, // IOB3
    110'h00fffe01e007ffffffffffffffff, // IOB2
    110'h00fffe01e007ffffffffffffffff, // IOB1
    110'h00fffe01e007ffffffffffffffff, // IOB0
    110'h00fffe01e317ffffffffffffffff, // IOA8
    110'h00fffe01e48fffffffffffffffff, // IOA7
    110'h00fffe01e007ffffffffffffffff, // IOA6
    110'h00fffe41e007ffffffffffffffff, // IOA5
    110'h00fffe01e007ffffffffffffffff, // IOA4
    110'h00fffe09e007ffffffffffffffff, // IOA3
    110'h00fffe81e007ffffffffffffffff, // IOA2
    110'h00fffe11e007ffffffffffffffff, // IOA1
    110'h00fffe01e007ffffffffffffffff  // IOA0
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NMioPads-1:0] MioPadAttrResval = {
    pad_attr_t'{default: '0}, // IOR13
    pad_attr_t'{default: '0}, // IOR12
    pad_attr_t'{default: '0}, // IOR11
    pad_attr_t'{default: '0}, // IOR10
    pad_attr_t'{virt_od_en: 1'h1, default: '0}, // IOR9
    pad_attr_t'{virt_od_en: 1'h1, default: '0}, // IOR8
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
    pad_attr_t'{default: '0}, // SPI_DEV_D3
    pad_attr_t'{default: '0}, // SPI_DEV_D2
    pad_attr_t'{default: '0}, // SPI_DEV_D1
    pad_attr_t'{default: '0}, // SPI_DEV_D0
    pad_attr_t'{default: '0}, // SPI_HOST_D3
    pad_attr_t'{default: '0}, // SPI_HOST_D2
    pad_attr_t'{default: '0}, // SPI_HOST_D1
    pad_attr_t'{default: '0}, // SPI_HOST_D0
    pad_attr_t'{default: '0}, // usbdev_usb_dn
    pad_attr_t'{default: '0}  // usbdev_usb_dp
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
