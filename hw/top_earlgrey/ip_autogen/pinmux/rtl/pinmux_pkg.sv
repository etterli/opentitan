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
    63'h1000000000000003, // sysrst_ctrl_lid_open
    63'h0002000000000003, // sysrst_ctrl_pwrb_in
    63'h0040000000000003, // sysrst_ctrl_key2_in
    63'h0010000000000003, // sysrst_ctrl_key1_in
    63'h0004000000000003, // sysrst_ctrl_key0_in
    63'h0008000000000003, // sysrst_ctrl_ac_present
    63'h7fffffffffffffff, // rram_macro_tdi
    63'h7fffffffffffffff, // rram_macro_tms
    63'h7fffffffffffffff, // rram_macro_tck
    63'h7fffffffffffffff, // spi_device_tpm_csb
    63'h1000000a00000003, // i3c1_rstdet_sda
    63'h0800000500000003, // i3c1_rstdet_scl
    63'h4000000800200003, // i3c0_rstdet_sda
    63'h2000000400400003, // i3c0_rstdet_scl
    63'h0010000000040003, // uart3_rx
    63'h0000400008000003, // uart2_rx
    63'h0040000000004003, // uart1_rx
    63'h0000008000010003, // uart0_rx
    63'h0000000000002003, // spi_device_csb
    63'h0000000000001003, // spi_device_sck
    63'h7fffffffffffffff, // usbdev_sense
    63'h0400000000000003, // sysrst_ctrl_flash_wp_l
    63'h0200000000000003, // sysrst_ctrl_ec_rst_l
    63'h7fffffffffffffff, // spi_host1_sd[3]
    63'h7fffffffffffffff, // spi_host1_sd[2]
    63'h7fffffffffffffff, // spi_host1_sd[1]
    63'h7fffffffffffffff, // spi_host1_sd[0]
    63'h1000000a00000003, // i3c1_sda
    63'h0800000500000003, // i3c1_scl
    63'h4000000800200003, // i3c0_sda
    63'h2000000400400003, // i3c0_scl
    63'h0000200300400003, // i2c2_scl
    63'h0001000300200003, // i2c2_sda
    63'h0800000c00000003, // i2c1_scl
    63'h1000000c00000003, // i2c1_sda
    63'h2000000100400003, // i2c0_scl
    63'h4000000200200003, // i2c0_sda
    63'h7fffffffffffffff, // gpio1_gpio[31]
    63'h7fffffffffffffff, // gpio1_gpio[30]
    63'h7fffffffffffffff, // gpio1_gpio[29]
    63'h7fffffffffffffff, // gpio1_gpio[28]
    63'h7fffffffffffffff, // gpio1_gpio[27]
    63'h7fffffffffffffff, // gpio1_gpio[26]
    63'h7fffffffffffffff, // gpio1_gpio[25]
    63'h7fffffffffffffff, // gpio1_gpio[24]
    63'h7fffffffffffffff, // gpio1_gpio[23]
    63'h7fffffffffffffff, // gpio1_gpio[22]
    63'h7fffffffffffffff, // gpio1_gpio[21]
    63'h7fffffffffffffff, // gpio1_gpio[20]
    63'h7fffffffffffffff, // gpio1_gpio[19]
    63'h7fffffffffffffff, // gpio1_gpio[18]
    63'h7fffffffffffffff, // gpio1_gpio[17]
    63'h7fffffffffffffff, // gpio1_gpio[16]
    63'h7fffffffffffffff, // gpio1_gpio[15]
    63'h7fffffffffffffff, // gpio1_gpio[14]
    63'h7fffffffffffffff, // gpio1_gpio[13]
    63'h7fffffffffffffff, // gpio1_gpio[12]
    63'h7fffffffffffffff, // gpio1_gpio[11]
    63'h7fffffffffffffff, // gpio1_gpio[10]
    63'h7fffffffffffffff, // gpio1_gpio[9]
    63'h7fffffffffffffff, // gpio1_gpio[8]
    63'h7fffffffffffffff, // gpio1_gpio[7]
    63'h7fffffffffffffff, // gpio1_gpio[6]
    63'h7fffffffffffffff, // gpio1_gpio[5]
    63'h7fffffffffffffff, // gpio1_gpio[4]
    63'h7fffffffffffffff, // gpio1_gpio[3]
    63'h7fffffffffffffff, // gpio1_gpio[2]
    63'h7fffffffffffffff, // gpio1_gpio[1]
    63'h7fffffffffffffff, // gpio1_gpio[0]
    63'h7fffffffffffffff, // gpio0_gpio[31]
    63'h7fffffffffffffff, // gpio0_gpio[30]
    63'h7fffffffffffffff, // gpio0_gpio[29]
    63'h7fffffffffffffff, // gpio0_gpio[28]
    63'h7fffffffffffffff, // gpio0_gpio[27]
    63'h7fffffffffffffff, // gpio0_gpio[26]
    63'h7fffffffffffffff, // gpio0_gpio[25]
    63'h7fffffffffffffff, // gpio0_gpio[24]
    63'h7fffffffffffffff, // gpio0_gpio[23]
    63'h7fffffffffffffff, // gpio0_gpio[22]
    63'h7fffffffffffffff, // gpio0_gpio[21]
    63'h7fffffffffffffff, // gpio0_gpio[20]
    63'h7fffffffffffffff, // gpio0_gpio[19]
    63'h7fffffffffffffff, // gpio0_gpio[18]
    63'h7fffffffffffffff, // gpio0_gpio[17]
    63'h7fffffffffffffff, // gpio0_gpio[16]
    63'h7fffffffffffffff, // gpio0_gpio[15]
    63'h7fffffffffffffff, // gpio0_gpio[14]
    63'h7fffffffffffffff, // gpio0_gpio[13]
    63'h7fffffffffffffff, // gpio0_gpio[12]
    63'h7fffffffffffffff, // gpio0_gpio[11]
    63'h7fffffffffffffff, // gpio0_gpio[10]
    63'h7fffffffffffffff, // gpio0_gpio[9]
    63'h7fffffffffffffff, // gpio0_gpio[8]
    63'h7fffffffffffffff, // gpio0_gpio[7]
    63'h7fffffffffffffff, // gpio0_gpio[6]
    63'h7fffffffffffffff, // gpio0_gpio[5]
    63'h7fffffffffffffff, // gpio0_gpio[4]
    63'h7fffffffffffffff, // gpio0_gpio[3]
    63'h7fffffffffffffff, // gpio0_gpio[2]
    63'h7fffffffffffffff, // gpio0_gpio[1]
    63'h7fffffffffffffff, // gpio0_gpio[0]
    63'h0000000000000803, // spi_device_sd[3]
    63'h0000000000000403, // spi_device_sd[2]
    63'h0000000000000203, // spi_device_sd[1]
    63'h0000000000000103, // spi_device_sd[0]
    63'h0000000000000023, // spi_host0_sd[3]
    63'h0000000000000013, // spi_host0_sd[2]
    63'h000000000000000b, // spi_host0_sd[1]
    63'h0000000000000007  // spi_host0_sd[0]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    121'h027fff801e40ffffffffffffffff807, // IOR13
    121'h00ffff801e217fffffffffffffff807, // IOR12
    121'h007fff801f027fffffffffffffff807, // IOR11
    121'h087fff801e847fffffffffffffff807, // IOR10
    121'h007fff805e007fffffffffffffff807, // IOR9
    121'h007fff803e007fffffffffffffff807, // IOR8
    121'h047fffa01e007fffffffffffffff807, // IOR7
    121'h017fff841e007fffffffffffffff807, // IOR6
    121'h007fff801e007fffffffffffffff807, // IOR5
    121'h107fff901e007fffffffffffffff807, // IOR4
    121'h007fff801e007fffffffffffffff807, // IOR3
    121'h007fffc01e007fffffffffffffff807, // IOR2
    121'h007fff801e007fffffffffffffff807, // IOR1
    121'h007fff801e007fffffffffffffff807, // IOR0
    121'h007fff801e087fffffffffffffff807, // IOC12
    121'h007fff881e007fffffffffffffff807, // IOC11
    121'h007fff801e007fffffffffffffff807, // IOC10
    121'h007fff801e107fffffffffffffff807, // IOC9
    121'h007fff801e007fffffffffffffff807, // IOC8
    121'h007fff801e007fffffffffffffff807, // IOC7
    121'h007fff801e007fffffffffffffff807, // IOC6
    121'h007fff801e007fffffffffffffff807, // IOC5
    121'h007fff821e007fffffffffffffff807, // IOC4
    121'h007fff801e007fffffffffffffff807, // IOC3
    121'h007fff801e007fffffffffffffff807, // IOC2
    121'h007fff801e007fffffffffffffff807, // IOC1
    121'h007fff801e007fffffffffffffff807, // IOC0
    121'h007fff801f467fffffffffffffff807, // IOB12
    121'h007fff801ea67fffffffffffffff807, // IOB11
    121'h007fffc01f18ffffffffffffffff807, // IOB10
    121'h007fff801e997fffffffffffffff807, // IOB9
    121'h007fffa01e007fffffffffffffff807, // IOB8
    121'h007fffc01e007fffffffffffffff807, // IOB7
    121'h007fff801e007fffffffffffffff807, // IOB6
    121'h007fff881e007fffffffffffffff807, // IOB5
    121'h007fff801e007fffffffffffffff807, // IOB4
    121'h007fff801e007fffffffffffffff807, // IOB3
    121'h007fff801e007fffffffffffffff807, // IOB2
    121'h007fff801e007fffffffffffffff807, // IOB1
    121'h007fff801e007fffffffffffffff807, // IOB0
    121'h007fff801e317fffffffffffffff807, // IOA8
    121'h007fff801e48ffffffffffffffff807, // IOA7
    121'h007fff801e007fffffffffffffff807, // IOA6
    121'h007fff901e007fffffffffffffff807, // IOA5
    121'h007fff801e007fffffffffffffff807, // IOA4
    121'h007fff821e007fffffffffffffff807, // IOA3
    121'h007fffa01e007fffffffffffffff807, // IOA2
    121'h007fff841e007fffffffffffffff807, // IOA1
    121'h007fff801e007fffffffffffffff807, // IOA0
    121'h007fff801e007fffffffffffffff807, // SPI_DEV_CS_L
    121'h007fff801e007fffffffffffffff807, // SPI_DEV_CLK
    121'h007fff801e007fffffffffffffffc07, // SPI_DEV_D3
    121'h007fff801e007fffffffffffffffa07, // SPI_DEV_D2
    121'h007fff801e007fffffffffffffff907, // SPI_DEV_D1
    121'h007fff801e007fffffffffffffff887, // SPI_DEV_D0
    121'h007fff811e007fffffffffffffff807, // SPI_HOST_CS_L
    121'h007fff809e007fffffffffffffff807, // SPI_HOST_CLK
    121'h007fff801e007fffffffffffffff847, // SPI_HOST_D3
    121'h007fff801e007fffffffffffffff827, // SPI_HOST_D2
    121'h007fff801e007fffffffffffffff817, // SPI_HOST_D1
    121'h007fff801e007fffffffffffffff80f  // SPI_HOST_D0
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
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
    pad_attr_t'{default: '0}, // IOA0
    pad_attr_t'{default: '0}, // SPI_DEV_CS_L
    pad_attr_t'{default: '0}, // SPI_DEV_CLK
    pad_attr_t'{default: '0}, // SPI_DEV_D3
    pad_attr_t'{default: '0}, // SPI_DEV_D2
    pad_attr_t'{default: '0}, // SPI_DEV_D1
    pad_attr_t'{default: '0}, // SPI_DEV_D0
    pad_attr_t'{default: '0}, // SPI_HOST_CS_L
    pad_attr_t'{default: '0}, // SPI_HOST_CLK
    pad_attr_t'{default: '0}, // SPI_HOST_D3
    pad_attr_t'{default: '0}, // SPI_HOST_D2
    pad_attr_t'{default: '0}, // SPI_HOST_D1
    pad_attr_t'{default: '0}  // SPI_HOST_D0
  };

  // Reset values of the DIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
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
