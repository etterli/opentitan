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
    63'h1000000000000003, // 105: sysrst_ctrl_lid_open
    63'h0002000000000003, // 104: sysrst_ctrl_pwrb_in
    63'h0040000000000003, // 103: sysrst_ctrl_key2_in
    63'h0010000000000003, // 102: sysrst_ctrl_key1_in
    63'h0004000000000003, // 101: sysrst_ctrl_key0_in
    63'h0008000000000003, // 100: sysrst_ctrl_ac_present
    63'h1000000a00000003, //  99: i3c1_rstdet_sda
    63'h0800000500000003, //  98: i3c1_rstdet_scl
    63'h4000000800200003, //  97: i3c0_rstdet_sda
    63'h2000000400400003, //  96: i3c0_rstdet_scl
    63'h0010000000040003, //  95: uart3_rx
    63'h0000400048000003, //  94: uart2_rx
    63'h0040000000004003, //  93: uart1_rx
    63'h0000008000010003, //  92: uart0_rx
    63'h0000000000250003, //  91: spi_device_tpm_csb
    63'h0000000000002003, //  90: spi_device_csb
    63'h0000000000001003, //  89: spi_device_sck
    63'h1001080000000003, //  88: usbdev_sense
    63'h0400000000000003, //  87: sysrst_ctrl_flash_wp_l
    63'h0200000000000003, //  86: sysrst_ctrl_ec_rst_l
    63'h1000000a00000003, //  85: i3c1_sda
    63'h0800000500000003, //  84: i3c1_scl
    63'h4000000800200003, //  83: i3c0_sda
    63'h2000000400400003, //  82: i3c0_scl
    63'h0000200300400003, //  81: i2c2_scl
    63'h0001000300200003, //  80: i2c2_sda
    63'h0800000c00000003, //  79: i2c1_scl
    63'h1000000c00000003, //  78: i2c1_sda
    63'h2000000100400003, //  77: i2c0_scl
    63'h4000000200200003, //  76: i2c0_sda
    63'h2000000000000003, //  75: gpio1_gpio[31]
    63'h1000000000000003, //  74: gpio1_gpio[30]
    63'h0800000000000003, //  73: gpio1_gpio[29]
    63'h4000000000000003, //  72: gpio1_gpio[28]
    63'h2000000000000003, //  71: gpio1_gpio[27]
    63'h1000000000000003, //  70: gpio1_gpio[26]
    63'h0800000000000003, //  69: gpio1_gpio[25]
    63'h0400000000000003, //  68: gpio1_gpio[24]
    63'h0200000000000003, //  67: gpio1_gpio[23]
    63'h0100000000000003, //  66: gpio1_gpio[22]
    63'h0080000000000003, //  65: gpio1_gpio[21]
    63'h0040000000000003, //  64: gpio1_gpio[20]
    63'h0020000000000003, //  63: gpio1_gpio[19]
    63'h0010000000000003, //  62: gpio1_gpio[18]
    63'h0008000000000003, //  61: gpio1_gpio[17]
    63'h0004000000000003, //  60: gpio1_gpio[16]
    63'h0002000000000003, //  59: gpio1_gpio[15]
    63'h0001000000000003, //  58: gpio1_gpio[14]
    63'h0000800000000003, //  57: gpio1_gpio[13]
    63'h0000400000000003, //  56: gpio1_gpio[12]
    63'h0000200000000003, //  55: gpio1_gpio[11]
    63'h0000100000000003, //  54: gpio1_gpio[10]
    63'h0000080000000003, //  53: gpio1_gpio[9]
    63'h0000040000000003, //  52: gpio1_gpio[8]
    63'h0000020000000003, //  51: gpio1_gpio[7]
    63'h0000010000000003, //  50: gpio1_gpio[6]
    63'h0000008000000003, //  49: gpio1_gpio[5]
    63'h0000004000000003, //  48: gpio1_gpio[4]
    63'h0000002000000003, //  47: gpio1_gpio[3]
    63'h0000001000000003, //  46: gpio1_gpio[2]
    63'h0000000800000003, //  45: gpio1_gpio[1]
    63'h0000000400000003, //  44: gpio1_gpio[0]
    63'h0000000200000003, //  43: gpio0_gpio[31]
    63'h0000000100000003, //  42: gpio0_gpio[30]
    63'h0000000080000003, //  41: gpio0_gpio[29]
    63'h0000000040000003, //  40: gpio0_gpio[28]
    63'h0000000020000003, //  39: gpio0_gpio[27]
    63'h0000000010000003, //  38: gpio0_gpio[26]
    63'h0000000008000003, //  37: gpio0_gpio[25]
    63'h0000000004000003, //  36: gpio0_gpio[24]
    63'h0000000002000003, //  35: gpio0_gpio[23]
    63'h0000000001000003, //  34: gpio0_gpio[22]
    63'h0000000000800003, //  33: gpio0_gpio[21]
    63'h0000000000400003, //  32: gpio0_gpio[20]
    63'h0000000000200003, //  31: gpio0_gpio[19]
    63'h0000000000100003, //  30: gpio0_gpio[18]
    63'h0000000000080003, //  29: gpio0_gpio[17]
    63'h0000000000040003, //  28: gpio0_gpio[16]
    63'h0000000000020003, //  27: gpio0_gpio[15]
    63'h0000000000010003, //  26: gpio0_gpio[14]
    63'h0000000000008003, //  25: gpio0_gpio[13]
    63'h0000000000004003, //  24: gpio0_gpio[12]
    63'h0000000000002003, //  23: gpio0_gpio[11]
    63'h0000000000001003, //  22: gpio0_gpio[10]
    63'h0000000000000803, //  21: gpio0_gpio[9]
    63'h0000000000000403, //  20: gpio0_gpio[8]
    63'h0000000000000203, //  19: gpio0_gpio[7]
    63'h0000000000000103, //  18: gpio0_gpio[6]
    63'h0000000000000083, //  17: gpio0_gpio[5]
    63'h0000000000000043, //  16: gpio0_gpio[4]
    63'h0000000000000023, //  15: gpio0_gpio[3]
    63'h0000000000000013, //  14: gpio0_gpio[2]
    63'h000000000000000b, //  13: gpio0_gpio[1]
    63'h0000000000000007, //  12: gpio0_gpio[0]
    63'h0000000000000803, //  11: spi_device_sd[3]
    63'h0000000000000403, //  10: spi_device_sd[2]
    63'h0000000000000203, //   9: spi_device_sd[1]
    63'h0000000000000103, //   8: spi_device_sd[0]
    63'h0000000020000003, //   7: spi_host1_sd[3]
    63'h0000000008000003, //   6: spi_host1_sd[2]
    63'h0000000002000003, //   5: spi_host1_sd[1]
    63'h0000000001000003, //   4: spi_host1_sd[0]
    63'h0000000000000023, //   3: spi_host0_sd[3]
    63'h0000000000000013, //   2: spi_host0_sd[2]
    63'h000000000000000b, //   1: spi_host0_sd[1]
    63'h0000000000000007  //   0: spi_host0_sd[0]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    119'h080000004088000000000000000007, // 60: IOR13
    119'h020000002144000000000000000007, // 59: IOR12
    119'h000000010222000000000000000007, // 58: IOR11
    119'h200000008411000000000000000007, // 57: IOR10
    119'h000000040000800000000000000007, // 56: IOR9
    119'h000000020000400000000000000007, // 55: IOR8
    119'h100080000000200000000000000007, // 54: IOR7
    119'h040010000000100000000000000007, // 53: IOR6
    119'h000000000000080000000000000007, // 52: IOR5
    119'h400040000000040000000000000007, // 51: IOR4
    119'h000000000000020000000000000007, // 50: IOR3
    119'h000100000000010000000000000007, // 49: IOR2
    119'h000000000000008000000000000007, // 48: IOR1
    119'h000000000000004000000000000007, // 47: IOR0
    119'h000000000800002000000000000007, // 46: IOC12
    119'h000020000000001000000000000007, // 45: IOC11
    119'h000000000000000800000000000007, // 44: IOC10
    119'h000000001000000400000000000007, // 43: IOC9
    119'h000000000000000200000000000007, // 42: IOC8
    119'h000000000000000100000000000007, // 41: IOC7
    119'h000000000000000080000000000007, // 40: IOC6
    119'h000000000000000040000000000007, // 39: IOC5
    119'h008008000000000020000000000007, // 38: IOC4
    119'h010000000000000010000000000007, // 37: IOC3
    119'h002000000000000008000000000007, // 36: IOC2
    119'h001000000000000004000000000007, // 35: IOC1
    119'h004000000000000002000000000007, // 34: IOC0
    119'h000000014600000001000000000007, // 33: IOB12
    119'h00000000a600000000800000000007, // 32: IOB11
    119'h000100011880000000400000000007, // 31: IOB10
    119'h000000009900000000200000000007, // 30: IOB9
    119'h000084000000000000100000000007, // 29: IOB8
    119'h000104000000000000080000000007, // 28: IOB7
    119'h000000000000000000040000000407, // 27: IOB6
    119'h000022000000000000020000000007, // 26: IOB5
    119'h000000000000000000010000000207, // 25: IOB4
    119'h000000800000000000008000000007, // 24: IOB3
    119'h000000000000000000004000000107, // 23: IOB2
    119'h000000000000000000002000000087, // 22: IOB1
    119'h000001000000000000001000000007, // 21: IOB0
    119'h000400003100000000000800000007, // 20: IOA8
    119'h000200004880000000000400000007, // 19: IOA7
    119'h000000000000000000000200000007, // 18: IOA6
    119'h000040200000000000000100000007, // 17: IOA5
    119'h000000400000000000000080000007, // 16: IOA4
    119'h000008400000000000000040000007, // 15: IOA3
    119'h000080200000000000000020000007, // 14: IOA2
    119'h000010000000000000000010000007, // 13: IOA1
    119'h000000000000000000000008000007, // 12: IOA0
    119'h000000000000000000000004000007, // 11: SPI_DEV_CS_L
    119'h000000000000000000000002000007, // 10: SPI_DEV_CLK
    119'h000000000000000000000001004007, //  9: SPI_DEV_D3
    119'h000000000000000000000000802007, //  8: SPI_DEV_D2
    119'h000000000000000000000000401007, //  7: SPI_DEV_D1
    119'h000000000000000000000000200807, //  6: SPI_DEV_D0
    119'h000000100000000000000000100007, //  5: SPI_HOST_CS_L
    119'h000000080000000000000000080007, //  4: SPI_HOST_CLK
    119'h000800000000000000000000040047, //  3: SPI_HOST_D3
    119'h000000000000000000000000020027, //  2: SPI_HOST_D2
    119'h000000000000000000000000010017, //  1: SPI_HOST_D1
    119'h00000000000000000000000000800f  //  0: SPI_HOST_D0
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
    MuxPartPrimary, // 105: sysrst_ctrl_lid_open
    MuxPartPrimary, // 104: sysrst_ctrl_pwrb_in
    MuxPartPrimary, // 103: sysrst_ctrl_key2_in
    MuxPartPrimary, // 102: sysrst_ctrl_key1_in
    MuxPartPrimary, // 101: sysrst_ctrl_key0_in
    MuxPartPrimary, // 100: sysrst_ctrl_ac_present
    MuxPartPrimary, //  99: i3c1_rstdet_sda
    MuxPartPrimary, //  98: i3c1_rstdet_scl
    MuxPartPrimary, //  97: i3c0_rstdet_sda
    MuxPartPrimary, //  96: i3c0_rstdet_scl
    MuxPartPrimary, //  95: uart3_rx
    MuxPartPrimary, //  94: uart2_rx
    MuxPartPrimary, //  93: uart1_rx
    MuxPartPrimary, //  92: uart0_rx
    MuxPartPrimary, //  91: spi_device_tpm_csb
    MuxPartPrimary, //  90: spi_device_csb
    MuxPartPrimary, //  89: spi_device_sck
    MuxPartPrimary, //  88: usbdev_sense
    MuxPartPrimary, //  87: sysrst_ctrl_flash_wp_l
    MuxPartPrimary, //  86: sysrst_ctrl_ec_rst_l
    MuxPartPrimary, //  85: i3c1_sda
    MuxPartPrimary, //  84: i3c1_scl
    MuxPartPrimary, //  83: i3c0_sda
    MuxPartPrimary, //  82: i3c0_scl
    MuxPartPrimary, //  81: i2c2_scl
    MuxPartPrimary, //  80: i2c2_sda
    MuxPartPrimary, //  79: i2c1_scl
    MuxPartPrimary, //  78: i2c1_sda
    MuxPartPrimary, //  77: i2c0_scl
    MuxPartPrimary, //  76: i2c0_sda
    MuxPartPrimary, //  75: gpio1_gpio[31]
    MuxPartPrimary, //  74: gpio1_gpio[30]
    MuxPartPrimary, //  73: gpio1_gpio[29]
    MuxPartPrimary, //  72: gpio1_gpio[28]
    MuxPartPrimary, //  71: gpio1_gpio[27]
    MuxPartPrimary, //  70: gpio1_gpio[26]
    MuxPartPrimary, //  69: gpio1_gpio[25]
    MuxPartPrimary, //  68: gpio1_gpio[24]
    MuxPartPrimary, //  67: gpio1_gpio[23]
    MuxPartPrimary, //  66: gpio1_gpio[22]
    MuxPartPrimary, //  65: gpio1_gpio[21]
    MuxPartPrimary, //  64: gpio1_gpio[20]
    MuxPartPrimary, //  63: gpio1_gpio[19]
    MuxPartPrimary, //  62: gpio1_gpio[18]
    MuxPartPrimary, //  61: gpio1_gpio[17]
    MuxPartPrimary, //  60: gpio1_gpio[16]
    MuxPartPrimary, //  59: gpio1_gpio[15]
    MuxPartPrimary, //  58: gpio1_gpio[14]
    MuxPartPrimary, //  57: gpio1_gpio[13]
    MuxPartPrimary, //  56: gpio1_gpio[12]
    MuxPartPrimary, //  55: gpio1_gpio[11]
    MuxPartPrimary, //  54: gpio1_gpio[10]
    MuxPartPrimary, //  53: gpio1_gpio[9]
    MuxPartPrimary, //  52: gpio1_gpio[8]
    MuxPartPrimary, //  51: gpio1_gpio[7]
    MuxPartPrimary, //  50: gpio1_gpio[6]
    MuxPartPrimary, //  49: gpio1_gpio[5]
    MuxPartPrimary, //  48: gpio1_gpio[4]
    MuxPartPrimary, //  47: gpio1_gpio[3]
    MuxPartPrimary, //  46: gpio1_gpio[2]
    MuxPartPrimary, //  45: gpio1_gpio[1]
    MuxPartPrimary, //  44: gpio1_gpio[0]
    MuxPartPrimary, //  43: gpio0_gpio[31]
    MuxPartPrimary, //  42: gpio0_gpio[30]
    MuxPartPrimary, //  41: gpio0_gpio[29]
    MuxPartPrimary, //  40: gpio0_gpio[28]
    MuxPartPrimary, //  39: gpio0_gpio[27]
    MuxPartPrimary, //  38: gpio0_gpio[26]
    MuxPartPrimary, //  37: gpio0_gpio[25]
    MuxPartPrimary, //  36: gpio0_gpio[24]
    MuxPartPrimary, //  35: gpio0_gpio[23]
    MuxPartPrimary, //  34: gpio0_gpio[22]
    MuxPartPrimary, //  33: gpio0_gpio[21]
    MuxPartPrimary, //  32: gpio0_gpio[20]
    MuxPartPrimary, //  31: gpio0_gpio[19]
    MuxPartPrimary, //  30: gpio0_gpio[18]
    MuxPartPrimary, //  29: gpio0_gpio[17]
    MuxPartPrimary, //  28: gpio0_gpio[16]
    MuxPartPrimary, //  27: gpio0_gpio[15]
    MuxPartPrimary, //  26: gpio0_gpio[14]
    MuxPartPrimary, //  25: gpio0_gpio[13]
    MuxPartPrimary, //  24: gpio0_gpio[12]
    MuxPartPrimary, //  23: gpio0_gpio[11]
    MuxPartPrimary, //  22: gpio0_gpio[10]
    MuxPartPrimary, //  21: gpio0_gpio[9]
    MuxPartPrimary, //  20: gpio0_gpio[8]
    MuxPartPrimary, //  19: gpio0_gpio[7]
    MuxPartPrimary, //  18: gpio0_gpio[6]
    MuxPartPrimary, //  17: gpio0_gpio[5]
    MuxPartPrimary, //  16: gpio0_gpio[4]
    MuxPartPrimary, //  15: gpio0_gpio[3]
    MuxPartPrimary, //  14: gpio0_gpio[2]
    MuxPartPrimary, //  13: gpio0_gpio[1]
    MuxPartPrimary, //  12: gpio0_gpio[0]
    MuxPartPrimary, //  11: spi_device_sd[3]
    MuxPartPrimary, //  10: spi_device_sd[2]
    MuxPartPrimary, //   9: spi_device_sd[1]
    MuxPartPrimary, //   8: spi_device_sd[0]
    MuxPartPrimary, //   7: spi_host1_sd[3]
    MuxPartPrimary, //   6: spi_host1_sd[2]
    MuxPartPrimary, //   5: spi_host1_sd[1]
    MuxPartPrimary, //   4: spi_host1_sd[0]
    MuxPartPrimary, //   3: spi_host0_sd[3]
    MuxPartPrimary, //   2: spi_host0_sd[2]
    MuxPartPrimary, //   1: spi_host0_sd[1]
    MuxPartPrimary  //   0: spi_host0_sd[0]
  };

  // Whether the source of each MIO_OUTSEL value is in the primary partition. LSB corresponds to
  // lowest index. Includes the static options, which exist in both partitions.
  parameter logic [AlignedMioOutMuxSize-1:0] MioOutselInPrimary = AlignedMioOutMuxSize'({
    1'b1, // 118: sysrst_ctrl_z3_wakeup
    1'b1, // 117: sysrst_ctrl_pwrb_out
    1'b1, // 116: sysrst_ctrl_key2_out
    1'b1, // 115: sysrst_ctrl_key1_out
    1'b1, // 114: sysrst_ctrl_key0_out
    1'b1, // 113: sysrst_ctrl_bat_disable
    1'b1, // 112: sensor_ctrl_ast_debug_out[7]
    1'b1, // 111: sensor_ctrl_ast_debug_out[6]
    1'b1, // 110: sensor_ctrl_ast_debug_out[5]
    1'b1, // 109: sensor_ctrl_ast_debug_out[4]
    1'b1, // 108: sensor_ctrl_ast_debug_out[3]
    1'b1, // 107: sensor_ctrl_ast_debug_out[2]
    1'b1, // 106: sensor_ctrl_ast_debug_out[1]
    1'b1, // 105: sensor_ctrl_ast_debug_out[0]
    1'b1, // 104: i3c1_ctrl_sda_pu
    1'b1, // 103: i3c0_ctrl_sda_pu
    1'b1, // 102: uart3_tx
    1'b1, // 101: uart2_tx
    1'b1, // 100: uart1_tx
    1'b1, //  99: uart0_tx
    1'b1, //  98: spi_host1_csb[2]
    1'b1, //  97: spi_host1_csb[1]
    1'b1, //  96: spi_host1_csb[0]
    1'b1, //  95: spi_host1_sck
    1'b1, //  94: spi_host0_csb[2]
    1'b1, //  93: spi_host0_csb[1]
    1'b1, //  92: spi_host0_csb[0]
    1'b1, //  91: spi_host0_sck
    1'b1, //  90: sysrst_ctrl_flash_wp_l
    1'b1, //  89: sysrst_ctrl_ec_rst_l
    1'b1, //  88: i3c1_sda
    1'b1, //  87: i3c1_scl
    1'b1, //  86: i3c0_sda
    1'b1, //  85: i3c0_scl
    1'b1, //  84: i2c2_scl
    1'b1, //  83: i2c2_sda
    1'b1, //  82: i2c1_scl
    1'b1, //  81: i2c1_sda
    1'b1, //  80: i2c0_scl
    1'b1, //  79: i2c0_sda
    1'b1, //  78: gpio1_gpio[31]
    1'b1, //  77: gpio1_gpio[30]
    1'b1, //  76: gpio1_gpio[29]
    1'b1, //  75: gpio1_gpio[28]
    1'b1, //  74: gpio1_gpio[27]
    1'b1, //  73: gpio1_gpio[26]
    1'b1, //  72: gpio1_gpio[25]
    1'b1, //  71: gpio1_gpio[24]
    1'b1, //  70: gpio1_gpio[23]
    1'b1, //  69: gpio1_gpio[22]
    1'b1, //  68: gpio1_gpio[21]
    1'b1, //  67: gpio1_gpio[20]
    1'b1, //  66: gpio1_gpio[19]
    1'b1, //  65: gpio1_gpio[18]
    1'b1, //  64: gpio1_gpio[17]
    1'b1, //  63: gpio1_gpio[16]
    1'b1, //  62: gpio1_gpio[15]
    1'b1, //  61: gpio1_gpio[14]
    1'b1, //  60: gpio1_gpio[13]
    1'b1, //  59: gpio1_gpio[12]
    1'b1, //  58: gpio1_gpio[11]
    1'b1, //  57: gpio1_gpio[10]
    1'b1, //  56: gpio1_gpio[9]
    1'b1, //  55: gpio1_gpio[8]
    1'b1, //  54: gpio1_gpio[7]
    1'b1, //  53: gpio1_gpio[6]
    1'b1, //  52: gpio1_gpio[5]
    1'b1, //  51: gpio1_gpio[4]
    1'b1, //  50: gpio1_gpio[3]
    1'b1, //  49: gpio1_gpio[2]
    1'b1, //  48: gpio1_gpio[1]
    1'b1, //  47: gpio1_gpio[0]
    1'b1, //  46: gpio0_gpio[31]
    1'b1, //  45: gpio0_gpio[30]
    1'b1, //  44: gpio0_gpio[29]
    1'b1, //  43: gpio0_gpio[28]
    1'b1, //  42: gpio0_gpio[27]
    1'b1, //  41: gpio0_gpio[26]
    1'b1, //  40: gpio0_gpio[25]
    1'b1, //  39: gpio0_gpio[24]
    1'b1, //  38: gpio0_gpio[23]
    1'b1, //  37: gpio0_gpio[22]
    1'b1, //  36: gpio0_gpio[21]
    1'b1, //  35: gpio0_gpio[20]
    1'b1, //  34: gpio0_gpio[19]
    1'b1, //  33: gpio0_gpio[18]
    1'b1, //  32: gpio0_gpio[17]
    1'b1, //  31: gpio0_gpio[16]
    1'b1, //  30: gpio0_gpio[15]
    1'b1, //  29: gpio0_gpio[14]
    1'b1, //  28: gpio0_gpio[13]
    1'b1, //  27: gpio0_gpio[12]
    1'b1, //  26: gpio0_gpio[11]
    1'b1, //  25: gpio0_gpio[10]
    1'b1, //  24: gpio0_gpio[9]
    1'b1, //  23: gpio0_gpio[8]
    1'b1, //  22: gpio0_gpio[7]
    1'b1, //  21: gpio0_gpio[6]
    1'b1, //  20: gpio0_gpio[5]
    1'b1, //  19: gpio0_gpio[4]
    1'b1, //  18: gpio0_gpio[3]
    1'b1, //  17: gpio0_gpio[2]
    1'b1, //  16: gpio0_gpio[1]
    1'b1, //  15: gpio0_gpio[0]
    1'b1, //  14: spi_device_sd[3]
    1'b1, //  13: spi_device_sd[2]
    1'b1, //  12: spi_device_sd[1]
    1'b1, //  11: spi_device_sd[0]
    1'b1, //  10: spi_host1_sd[3]
    1'b1, //   9: spi_host1_sd[2]
    1'b1, //   8: spi_host1_sd[1]
    1'b1, //   7: spi_host1_sd[0]
    1'b1, //   6: spi_host0_sd[3]
    1'b1, //   5: spi_host0_sd[2]
    1'b1, //   4: spi_host0_sd[1]
    1'b1, //   3: spi_host0_sd[0]
    3'b111  // 2..0: static options
  });

  // Whether the output mux of each MIO pad is in the primary partition. This is the case if any
  // legal peripheral output of the pad is in the primary partition. LSB corresponds to lowest
  // index.
  parameter logic [NMioPads-1:0] MioPadMuxedInPrimary = {
    1'b1, // 60: IOR13
    1'b1, // 59: IOR12
    1'b1, // 58: IOR11
    1'b1, // 57: IOR10
    1'b1, // 56: IOR9
    1'b1, // 55: IOR8
    1'b1, // 54: IOR7
    1'b1, // 53: IOR6
    1'b1, // 52: IOR5
    1'b1, // 51: IOR4
    1'b1, // 50: IOR3
    1'b1, // 49: IOR2
    1'b1, // 48: IOR1
    1'b1, // 47: IOR0
    1'b1, // 46: IOC12
    1'b1, // 45: IOC11
    1'b1, // 44: IOC10
    1'b1, // 43: IOC9
    1'b1, // 42: IOC8
    1'b1, // 41: IOC7
    1'b1, // 40: IOC6
    1'b1, // 39: IOC5
    1'b1, // 38: IOC4
    1'b1, // 37: IOC3
    1'b1, // 36: IOC2
    1'b1, // 35: IOC1
    1'b1, // 34: IOC0
    1'b1, // 33: IOB12
    1'b1, // 32: IOB11
    1'b1, // 31: IOB10
    1'b1, // 30: IOB9
    1'b1, // 29: IOB8
    1'b1, // 28: IOB7
    1'b1, // 27: IOB6
    1'b1, // 26: IOB5
    1'b1, // 25: IOB4
    1'b1, // 24: IOB3
    1'b1, // 23: IOB2
    1'b1, // 22: IOB1
    1'b1, // 21: IOB0
    1'b1, // 20: IOA8
    1'b1, // 19: IOA7
    1'b1, // 18: IOA6
    1'b1, // 17: IOA5
    1'b1, // 16: IOA4
    1'b1, // 15: IOA3
    1'b1, // 14: IOA2
    1'b1, // 13: IOA1
    1'b1, // 12: IOA0
    1'b1, // 11: SPI_DEV_CS_L
    1'b1, // 10: SPI_DEV_CLK
    1'b1, //  9: SPI_DEV_D3
    1'b1, //  8: SPI_DEV_D2
    1'b1, //  7: SPI_DEV_D1
    1'b1, //  6: SPI_DEV_D0
    1'b1, //  5: SPI_HOST_CS_L
    1'b1, //  4: SPI_HOST_CLK
    1'b1, //  3: SPI_HOST_D3
    1'b1, //  2: SPI_HOST_D2
    1'b1, //  1: SPI_HOST_D1
    1'b1  //  0: SPI_HOST_D0
  };

  // Whether any MIO peripheral input is muxed in the primary or secondary partition.
  parameter bit AnyMioInMuxedInPrimary   = |(MioPeriphInPart & {NMioPeriphIn{MuxPartPrimary}});
  parameter bit AnyMioInMuxedInSecondary = |(MioPeriphInPart & {NMioPeriphIn{MuxPartSecondary}});

  // Whether any MIO pad is muxed in the primary or secondary partition.
  parameter bit AnyMioPadMuxedInPrimary   = |MioPadMuxedInPrimary;
  parameter bit AnyMioPadMuxedInSecondary = !(&MioPadMuxedInPrimary);

  // Whether the peripheral connected to each DIO pad is in the primary partition. LSB corresponds
  // to lowest index.
  parameter logic [NDioPads-1:0] DioPadSourceInPrimary = {
    1'b1, // 1: usbdev_usb_dn
    1'b1  // 0: usbdev_usb_dp
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NMioPads-1:0] MioPadAttrResval = {
    pad_attr_t'{default: '0}, // 60: IOR13
    pad_attr_t'{default: '0}, // 59: IOR12
    pad_attr_t'{default: '0}, // 58: IOR11
    pad_attr_t'{default: '0}, // 57: IOR10
    pad_attr_t'{virt_od_en: 1'h1, default: '0}, // 56: IOR9
    pad_attr_t'{virt_od_en: 1'h1, default: '0}, // 55: IOR8
    pad_attr_t'{default: '0}, // 54: IOR7
    pad_attr_t'{default: '0}, // 53: IOR6
    pad_attr_t'{default: '0}, // 52: IOR5
    pad_attr_t'{default: '0}, // 51: IOR4
    pad_attr_t'{default: '0}, // 50: IOR3
    pad_attr_t'{default: '0}, // 49: IOR2
    pad_attr_t'{default: '0}, // 48: IOR1
    pad_attr_t'{default: '0}, // 47: IOR0
    pad_attr_t'{default: '0}, // 46: IOC12
    pad_attr_t'{default: '0}, // 45: IOC11
    pad_attr_t'{default: '0}, // 44: IOC10
    pad_attr_t'{default: '0}, // 43: IOC9
    pad_attr_t'{pull_en: 1'h1, pull_select: 1'h0, default: '0}, // 42: IOC8
    pad_attr_t'{default: '0}, // 41: IOC7
    pad_attr_t'{default: '0}, // 40: IOC6
    pad_attr_t'{default: '0}, // 39: IOC5
    pad_attr_t'{default: '0}, // 38: IOC4
    pad_attr_t'{default: '0}, // 37: IOC3
    pad_attr_t'{default: '0}, // 36: IOC2
    pad_attr_t'{default: '0}, // 35: IOC1
    pad_attr_t'{default: '0}, // 34: IOC0
    pad_attr_t'{default: '0}, // 33: IOB12
    pad_attr_t'{default: '0}, // 32: IOB11
    pad_attr_t'{default: '0}, // 31: IOB10
    pad_attr_t'{default: '0}, // 30: IOB9
    pad_attr_t'{default: '0}, // 29: IOB8
    pad_attr_t'{default: '0}, // 28: IOB7
    pad_attr_t'{default: '0}, // 27: IOB6
    pad_attr_t'{default: '0}, // 26: IOB5
    pad_attr_t'{default: '0}, // 25: IOB4
    pad_attr_t'{default: '0}, // 24: IOB3
    pad_attr_t'{default: '0}, // 23: IOB2
    pad_attr_t'{default: '0}, // 22: IOB1
    pad_attr_t'{default: '0}, // 21: IOB0
    pad_attr_t'{default: '0}, // 20: IOA8
    pad_attr_t'{default: '0}, // 19: IOA7
    pad_attr_t'{default: '0}, // 18: IOA6
    pad_attr_t'{default: '0}, // 17: IOA5
    pad_attr_t'{default: '0}, // 16: IOA4
    pad_attr_t'{default: '0}, // 15: IOA3
    pad_attr_t'{default: '0}, // 14: IOA2
    pad_attr_t'{default: '0}, // 13: IOA1
    pad_attr_t'{default: '0}, // 12: IOA0
    pad_attr_t'{default: '0}, // 11: SPI_DEV_CS_L
    pad_attr_t'{default: '0}, // 10: SPI_DEV_CLK
    pad_attr_t'{default: '0}, //  9: SPI_DEV_D3
    pad_attr_t'{default: '0}, //  8: SPI_DEV_D2
    pad_attr_t'{default: '0}, //  7: SPI_DEV_D1
    pad_attr_t'{default: '0}, //  6: SPI_DEV_D0
    pad_attr_t'{default: '0}, //  5: SPI_HOST_CS_L
    pad_attr_t'{default: '0}, //  4: SPI_HOST_CLK
    pad_attr_t'{default: '0}, //  3: SPI_HOST_D3
    pad_attr_t'{default: '0}, //  2: SPI_HOST_D2
    pad_attr_t'{default: '0}, //  1: SPI_HOST_D1
    pad_attr_t'{default: '0}  //  0: SPI_HOST_D0
  };

  // Reset values of the DIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
    pad_attr_t'{default: '0}, // 1: usbdev_usb_dn
    pad_attr_t'{default: '0}  // 0: usbdev_usb_dp
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
    logic [NDioPads-1:0] dio_to_periph;
    pinmux_reg2hw_t reg2hw;
  } p2s_t;

  typedef struct packed {
    logic [NMioPeriphOut-1:0] periph_data;
    logic [NMioPeriphOut-1:0] periph_oe;
    logic [NMioPads-1:0] pad_data;
    logic [NMioPads-1:0] pad_oe;
    logic [NDioPads-1:0] periph_to_dio;
    logic [NDioPads-1:0] periph_to_dio_oe;
  } s2p_t;

endpackage : pinmux_pkg
