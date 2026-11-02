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
    49'h1ffffffffffff, // sysrst_ctrl_lid_open
    49'h1ffffffffffff, // sysrst_ctrl_pwrb_in
    49'h1ffffffffffff, // sysrst_ctrl_key2_in
    49'h1ffffffffffff, // sysrst_ctrl_key1_in
    49'h1ffffffffffff, // sysrst_ctrl_key0_in
    49'h1ffffffffffff, // sysrst_ctrl_ac_present
    49'h1ffffffffffff, // rram_macro_tdi
    49'h1ffffffffffff, // rram_macro_tms
    49'h1ffffffffffff, // rram_macro_tck
    49'h1ffffffffffff, // spi_device_tpm_csb
    49'h1ffffffffffff, // i3c1_rstdet_sda
    49'h1ffffffffffff, // i3c1_rstdet_scl
    49'h1ffffffffffff, // i3c0_rstdet_sda
    49'h1ffffffffffff, // i3c0_rstdet_scl
    49'h1ffffffffffff, // uart3_rx
    49'h1ffffffffffff, // uart2_rx
    49'h1ffffffffffff, // uart1_rx
    49'h1ffffffffffff, // uart0_rx
    49'h1ffffffffffff, // usbdev_sense
    49'h1ffffffffffff, // spi_host1_sd[3]
    49'h1ffffffffffff, // spi_host1_sd[2]
    49'h1ffffffffffff, // spi_host1_sd[1]
    49'h1ffffffffffff, // spi_host1_sd[0]
    49'h1ffffffffffff, // i3c1_sda
    49'h1ffffffffffff, // i3c1_scl
    49'h1ffffffffffff, // i3c0_sda
    49'h1ffffffffffff, // i3c0_scl
    49'h1ffffffffffff, // i2c2_scl
    49'h1ffffffffffff, // i2c2_sda
    49'h1ffffffffffff, // i2c1_scl
    49'h1ffffffffffff, // i2c1_sda
    49'h1ffffffffffff, // i2c0_scl
    49'h1ffffffffffff, // i2c0_sda
    49'h1ffffffffffff, // gpio1_gpio[31]
    49'h1ffffffffffff, // gpio1_gpio[30]
    49'h1ffffffffffff, // gpio1_gpio[29]
    49'h1ffffffffffff, // gpio1_gpio[28]
    49'h1ffffffffffff, // gpio1_gpio[27]
    49'h1ffffffffffff, // gpio1_gpio[26]
    49'h1ffffffffffff, // gpio1_gpio[25]
    49'h1ffffffffffff, // gpio1_gpio[24]
    49'h1ffffffffffff, // gpio1_gpio[23]
    49'h1ffffffffffff, // gpio1_gpio[22]
    49'h1ffffffffffff, // gpio1_gpio[21]
    49'h1ffffffffffff, // gpio1_gpio[20]
    49'h1ffffffffffff, // gpio1_gpio[19]
    49'h1ffffffffffff, // gpio1_gpio[18]
    49'h1ffffffffffff, // gpio1_gpio[17]
    49'h1ffffffffffff, // gpio1_gpio[16]
    49'h1ffffffffffff, // gpio1_gpio[15]
    49'h1ffffffffffff, // gpio1_gpio[14]
    49'h1ffffffffffff, // gpio1_gpio[13]
    49'h1ffffffffffff, // gpio1_gpio[12]
    49'h1ffffffffffff, // gpio1_gpio[11]
    49'h1ffffffffffff, // gpio1_gpio[10]
    49'h1ffffffffffff, // gpio1_gpio[9]
    49'h1ffffffffffff, // gpio1_gpio[8]
    49'h1ffffffffffff, // gpio1_gpio[7]
    49'h1ffffffffffff, // gpio1_gpio[6]
    49'h1ffffffffffff, // gpio1_gpio[5]
    49'h1ffffffffffff, // gpio1_gpio[4]
    49'h1ffffffffffff, // gpio1_gpio[3]
    49'h1ffffffffffff, // gpio1_gpio[2]
    49'h1ffffffffffff, // gpio1_gpio[1]
    49'h1ffffffffffff, // gpio1_gpio[0]
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
    105'h1ffffffffffffffffffffffffff, // IOR13
    105'h1ffffffffffffffffffffffffff, // IOR12
    105'h1ffffffffffffffffffffffffff, // IOR11
    105'h1ffffffffffffffffffffffffff, // IOR10
    105'h1ffffffffffffffffffffffffff, // IOR7
    105'h1ffffffffffffffffffffffffff, // IOR6
    105'h1ffffffffffffffffffffffffff, // IOR5
    105'h1ffffffffffffffffffffffffff, // IOR4
    105'h1ffffffffffffffffffffffffff, // IOR3
    105'h1ffffffffffffffffffffffffff, // IOR2
    105'h1ffffffffffffffffffffffffff, // IOR1
    105'h1ffffffffffffffffffffffffff, // IOR0
    105'h1ffffffffffffffffffffffffff, // IOC12
    105'h1ffffffffffffffffffffffffff, // IOC11
    105'h1ffffffffffffffffffffffffff, // IOC10
    105'h1ffffffffffffffffffffffffff, // IOC9
    105'h1ffffffffffffffffffffffffff, // IOC8
    105'h1ffffffffffffffffffffffffff, // IOC7
    105'h1ffffffffffffffffffffffffff, // IOC6
    105'h1ffffffffffffffffffffffffff, // IOC5
    105'h1ffffffffffffffffffffffffff, // IOC4
    105'h1ffffffffffffffffffffffffff, // IOC3
    105'h1ffffffffffffffffffffffffff, // IOC2
    105'h1ffffffffffffffffffffffffff, // IOC1
    105'h1ffffffffffffffffffffffffff, // IOC0
    105'h1ffffffffffffffffffffffffff, // IOB12
    105'h1ffffffffffffffffffffffffff, // IOB11
    105'h1ffffffffffffffffffffffffff, // IOB10
    105'h1ffffffffffffffffffffffffff, // IOB9
    105'h1ffffffffffffffffffffffffff, // IOB8
    105'h1ffffffffffffffffffffffffff, // IOB7
    105'h1ffffffffffffffffffffffffff, // IOB6
    105'h1ffffffffffffffffffffffffff, // IOB5
    105'h1ffffffffffffffffffffffffff, // IOB4
    105'h1ffffffffffffffffffffffffff, // IOB3
    105'h1ffffffffffffffffffffffffff, // IOB2
    105'h1ffffffffffffffffffffffffff, // IOB1
    105'h1ffffffffffffffffffffffffff, // IOB0
    105'h1ffffffffffffffffffffffffff, // IOA8
    105'h1ffffffffffffffffffffffffff, // IOA7
    105'h1ffffffffffffffffffffffffff, // IOA6
    105'h1ffffffffffffffffffffffffff, // IOA5
    105'h1ffffffffffffffffffffffffff, // IOA4
    105'h1ffffffffffffffffffffffffff, // IOA3
    105'h1ffffffffffffffffffffffffff, // IOA2
    105'h1ffffffffffffffffffffffffff, // IOA1
    105'h1ffffffffffffffffffffffffff  // IOA0
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
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

  // Reset values of the DIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
    pad_attr_t'{default: '0}, // SPI_HOST_CS_L
    pad_attr_t'{default: '0}, // SPI_HOST_CLK
    pad_attr_t'{default: '0}, // SPI_DEV_CS_L
    pad_attr_t'{default: '0}, // SPI_DEV_CLK
    pad_attr_t'{virt_od_en: 1'h1, default: '0}, // IOR9
    pad_attr_t'{virt_od_en: 1'h1, default: '0}, // IOR8
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
