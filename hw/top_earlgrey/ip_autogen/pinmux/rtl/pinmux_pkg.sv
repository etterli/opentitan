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
    49'h1ffffffffffff, // usbdev_sense
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
    49'h1ffffffffffff, // uart3_rx
    49'h1ffffffffffff, // uart2_rx
    49'h1ffffffffffff, // uart1_rx
    49'h1ffffffffffff, // uart0_rx
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
    49'h1ffffffffffff, // gpio_gpio[31]
    49'h1ffffffffffff, // gpio_gpio[30]
    49'h1ffffffffffff, // gpio_gpio[29]
    49'h1ffffffffffff, // gpio_gpio[28]
    49'h1ffffffffffff, // gpio_gpio[27]
    49'h1ffffffffffff, // gpio_gpio[26]
    49'h1ffffffffffff, // gpio_gpio[25]
    49'h1ffffffffffff, // gpio_gpio[24]
    49'h1ffffffffffff, // gpio_gpio[23]
    49'h1ffffffffffff, // gpio_gpio[22]
    49'h1ffffffffffff, // gpio_gpio[21]
    49'h1ffffffffffff, // gpio_gpio[20]
    49'h1ffffffffffff, // gpio_gpio[19]
    49'h1ffffffffffff, // gpio_gpio[18]
    49'h1ffffffffffff, // gpio_gpio[17]
    49'h1ffffffffffff, // gpio_gpio[16]
    49'h1ffffffffffff, // gpio_gpio[15]
    49'h1ffffffffffff, // gpio_gpio[14]
    49'h1ffffffffffff, // gpio_gpio[13]
    49'h1ffffffffffff, // gpio_gpio[12]
    49'h1ffffffffffff, // gpio_gpio[11]
    49'h1ffffffffffff, // gpio_gpio[10]
    49'h1ffffffffffff, // gpio_gpio[9]
    49'h1ffffffffffff, // gpio_gpio[8]
    49'h1ffffffffffff, // gpio_gpio[7]
    49'h1ffffffffffff, // gpio_gpio[6]
    49'h1ffffffffffff, // gpio_gpio[5]
    49'h1ffffffffffff, // gpio_gpio[4]
    49'h1ffffffffffff, // gpio_gpio[3]
    49'h1ffffffffffff, // gpio_gpio[2]
    49'h1ffffffffffff, // gpio_gpio[1]
    49'h1ffffffffffff  // gpio_gpio[0]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    73'h1ffffffffffffffffff, // IOR13
    73'h1ffffffffffffffffff, // IOR12
    73'h1ffffffffffffffffff, // IOR11
    73'h1ffffffffffffffffff, // IOR10
    73'h1ffffffffffffffffff, // IOR7
    73'h1ffffffffffffffffff, // IOR6
    73'h1ffffffffffffffffff, // IOR5
    73'h1ffffffffffffffffff, // IOR4
    73'h1ffffffffffffffffff, // IOR3
    73'h1ffffffffffffffffff, // IOR2
    73'h1ffffffffffffffffff, // IOR1
    73'h1ffffffffffffffffff, // IOR0
    73'h1ffffffffffffffffff, // IOC12
    73'h1ffffffffffffffffff, // IOC11
    73'h1ffffffffffffffffff, // IOC10
    73'h1ffffffffffffffffff, // IOC9
    73'h1ffffffffffffffffff, // IOC8
    73'h1ffffffffffffffffff, // IOC7
    73'h1ffffffffffffffffff, // IOC6
    73'h1ffffffffffffffffff, // IOC5
    73'h1ffffffffffffffffff, // IOC4
    73'h1ffffffffffffffffff, // IOC3
    73'h1ffffffffffffffffff, // IOC2
    73'h1ffffffffffffffffff, // IOC1
    73'h1ffffffffffffffffff, // IOC0
    73'h1ffffffffffffffffff, // IOB12
    73'h1ffffffffffffffffff, // IOB11
    73'h1ffffffffffffffffff, // IOB10
    73'h1ffffffffffffffffff, // IOB9
    73'h1ffffffffffffffffff, // IOB8
    73'h1ffffffffffffffffff, // IOB7
    73'h1ffffffffffffffffff, // IOB6
    73'h1ffffffffffffffffff, // IOB5
    73'h1ffffffffffffffffff, // IOB4
    73'h1ffffffffffffffffff, // IOB3
    73'h1ffffffffffffffffff, // IOB2
    73'h1ffffffffffffffffff, // IOB1
    73'h1ffffffffffffffffff, // IOB0
    73'h1ffffffffffffffffff, // IOA8
    73'h1ffffffffffffffffff, // IOA7
    73'h1ffffffffffffffffff, // IOA6
    73'h1ffffffffffffffffff, // IOA5
    73'h1ffffffffffffffffff, // IOA4
    73'h1ffffffffffffffffff, // IOA3
    73'h1ffffffffffffffffff, // IOA2
    73'h1ffffffffffffffffff, // IOA1
    73'h1ffffffffffffffffff  // IOA0
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
