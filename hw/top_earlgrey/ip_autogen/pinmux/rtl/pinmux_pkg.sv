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
    67'h7ffffffffffffffff, // IOR13
    67'h7ffffffffffffffff, // IOR12
    67'h7ffffffffffffffff, // IOR11
    67'h7ffffffffffffffff, // IOR10
    67'h7ffffffffffffffff, // IOR7
    67'h7ffffffffffffffff, // IOR6
    67'h7ffffffffffffffff, // IOR5
    67'h7ffffffffffffffff, // IOR4
    67'h7ffffffffffffffff, // IOR3
    67'h7ffffffffffffffff, // IOR2
    67'h7ffffffffffffffff, // IOR1
    67'h7ffffffffffffffff, // IOR0
    67'h7ffffffffffffffff, // IOC12
    67'h7ffffffffffffffff, // IOC11
    67'h7ffffffffffffffff, // IOC10
    67'h7ffffffffffffffff, // IOC9
    67'h7ffffffffffffffff, // IOC8
    67'h7ffffffffffffffff, // IOC7
    67'h7ffffffffffffffff, // IOC6
    67'h7ffffffffffffffff, // IOC5
    67'h7ffffffffffffffff, // IOC4
    67'h7ffffffffffffffff, // IOC3
    67'h7ffffffffffffffff, // IOC2
    67'h7ffffffffffffffff, // IOC1
    67'h7ffffffffffffffff, // IOC0
    67'h7ffffffffffffffff, // IOB12
    67'h7ffffffffffffffff, // IOB11
    67'h7ffffffffffffffff, // IOB10
    67'h7ffffffffffffffff, // IOB9
    67'h7ffffffffffffffff, // IOB8
    67'h7ffffffffffffffff, // IOB7
    67'h7ffffffffffffffff, // IOB6
    67'h7ffffffffffffffff, // IOB5
    67'h7ffffffffffffffff, // IOB4
    67'h7ffffffffffffffff, // IOB3
    67'h7ffffffffffffffff, // IOB2
    67'h7ffffffffffffffff, // IOB1
    67'h7ffffffffffffffff, // IOB0
    67'h7ffffffffffffffff, // IOA8
    67'h7ffffffffffffffff, // IOA7
    67'h7ffffffffffffffff, // IOA6
    67'h7ffffffffffffffff, // IOA5
    67'h7ffffffffffffffff, // IOA4
    67'h7ffffffffffffffff, // IOA3
    67'h7ffffffffffffffff, // IOA2
    67'h7ffffffffffffffff, // IOA1
    67'h7ffffffffffffffff  // IOA0
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
