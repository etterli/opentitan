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
    63'h1000000000000003, // sysrst_ctrl_lid_open
    63'h0002000000000003, // sysrst_ctrl_pwrb_in
    63'h0040000000000003, // sysrst_ctrl_key2_in
    63'h0010000000000003, // sysrst_ctrl_key1_in
    63'h0004000000000003, // sysrst_ctrl_key0_in
    63'h0008000000000003, // sysrst_ctrl_ac_present
    63'h1000000a00000003, // i3c1_rstdet_sda
    63'h0800000500000003, // i3c1_rstdet_scl
    63'h4000000800200003, // i3c0_rstdet_sda
    63'h2000000400400003, // i3c0_rstdet_scl
    63'h0010000000040003, // uart3_rx
    63'h0000400008000003, // uart2_rx
    63'h0040000000004003, // uart1_rx
    63'h0000008000010003, // uart0_rx
    63'h0000000000250003, // spi_device_tpm_csb
    63'h0000000000002003, // spi_device_csb
    63'h0000000000001003, // spi_device_sck
    63'h1001080000000003, // usbdev_sense
    63'h0400000000000003, // sysrst_ctrl_flash_wp_l
    63'h0200000000000003, // sysrst_ctrl_ec_rst_l
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
    63'h2000000000000003, // gpio1_gpio[31]
    63'h1000000000000003, // gpio1_gpio[30]
    63'h0800000000000003, // gpio1_gpio[29]
    63'h4000000000000003, // gpio1_gpio[28]
    63'h2000000000000003, // gpio1_gpio[27]
    63'h1000000000000003, // gpio1_gpio[26]
    63'h0800000000000003, // gpio1_gpio[25]
    63'h0400000000000003, // gpio1_gpio[24]
    63'h0200000000000003, // gpio1_gpio[23]
    63'h0100000000000003, // gpio1_gpio[22]
    63'h0080000000000003, // gpio1_gpio[21]
    63'h0040000000000003, // gpio1_gpio[20]
    63'h0020000000000003, // gpio1_gpio[19]
    63'h0010000000000003, // gpio1_gpio[18]
    63'h0008000000000003, // gpio1_gpio[17]
    63'h0004000000000003, // gpio1_gpio[16]
    63'h0002000000000003, // gpio1_gpio[15]
    63'h0001000000000003, // gpio1_gpio[14]
    63'h0000800000000003, // gpio1_gpio[13]
    63'h0000400000000003, // gpio1_gpio[12]
    63'h0000200000000003, // gpio1_gpio[11]
    63'h0000100000000003, // gpio1_gpio[10]
    63'h0000080000000003, // gpio1_gpio[9]
    63'h0000040000000003, // gpio1_gpio[8]
    63'h0000020000000003, // gpio1_gpio[7]
    63'h0000010000000003, // gpio1_gpio[6]
    63'h0000008000000003, // gpio1_gpio[5]
    63'h0000004000000003, // gpio1_gpio[4]
    63'h0000002000000003, // gpio1_gpio[3]
    63'h0000001000000003, // gpio1_gpio[2]
    63'h0000000800000003, // gpio1_gpio[1]
    63'h0000000400000003, // gpio1_gpio[0]
    63'h0000000200000003, // gpio0_gpio[31]
    63'h0000000100000003, // gpio0_gpio[30]
    63'h0000000080000003, // gpio0_gpio[29]
    63'h0000000040000003, // gpio0_gpio[28]
    63'h0000000020000003, // gpio0_gpio[27]
    63'h0000000010000003, // gpio0_gpio[26]
    63'h0000000008000003, // gpio0_gpio[25]
    63'h0000000004000003, // gpio0_gpio[24]
    63'h0000000002000003, // gpio0_gpio[23]
    63'h0000000001000003, // gpio0_gpio[22]
    63'h0000000000800003, // gpio0_gpio[21]
    63'h0000000000400003, // gpio0_gpio[20]
    63'h0000000000200003, // gpio0_gpio[19]
    63'h0000000000100003, // gpio0_gpio[18]
    63'h0000000000080003, // gpio0_gpio[17]
    63'h0000000000040003, // gpio0_gpio[16]
    63'h0000000000020003, // gpio0_gpio[15]
    63'h0000000000010003, // gpio0_gpio[14]
    63'h0000000000008003, // gpio0_gpio[13]
    63'h0000000000004003, // gpio0_gpio[12]
    63'h0000000000002003, // gpio0_gpio[11]
    63'h0000000000001003, // gpio0_gpio[10]
    63'h0000000000000803, // gpio0_gpio[9]
    63'h0000000000000403, // gpio0_gpio[8]
    63'h0000000000000203, // gpio0_gpio[7]
    63'h0000000000000103, // gpio0_gpio[6]
    63'h0000000000000083, // gpio0_gpio[5]
    63'h0000000000000043, // gpio0_gpio[4]
    63'h0000000000000023, // gpio0_gpio[3]
    63'h0000000000000013, // gpio0_gpio[2]
    63'h000000000000000b, // gpio0_gpio[1]
    63'h0000000000000007, // gpio0_gpio[0]
    63'h0000000000000803, // spi_device_sd[3]
    63'h0000000000000403, // spi_device_sd[2]
    63'h0000000000000203, // spi_device_sd[1]
    63'h0000000000000103, // spi_device_sd[0]
    63'h0000000020000003, // spi_host1_sd[3]
    63'h0000000008000003, // spi_host1_sd[2]
    63'h0000000002000003, // spi_host1_sd[1]
    63'h0000000001000003, // spi_host1_sd[0]
    63'h0000000000000023, // spi_host0_sd[3]
    63'h0000000000000013, // spi_host0_sd[2]
    63'h000000000000000b, // spi_host0_sd[1]
    63'h0000000000000007  // spi_host0_sd[0]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    120'h120000004088000000000000000007, // IOR13
    120'h060000002144000000000000000007, // IOR12
    120'h020000010222000000000000000007, // IOR11
    120'h420000008411000000000000000007, // IOR10
    120'h020000040000800000000000000007, // IOR9
    120'h020000020000400000000000000007, // IOR8
    120'h220080000000200000000000000007, // IOR7
    120'h0a0010000000100000000000000007, // IOR6
    120'h020000000000080000000000000007, // IOR5
    120'h820040000000040000000000000007, // IOR4
    120'h020000000000020000000000000007, // IOR3
    120'h020100000000010000000000000007, // IOR2
    120'h020000000000008000000000000007, // IOR1
    120'h020000000000004000000000000007, // IOR0
    120'h020000000800002000000000000007, // IOC12
    120'h020020000000001000000000000007, // IOC11
    120'h020000000000000800000000000007, // IOC10
    120'h020000001000000400000000000007, // IOC9
    120'h020000000000000200000000000007, // IOC8
    120'h020000000000000100000000000007, // IOC7
    120'h020000000000000080000000000007, // IOC6
    120'h020000000000000040000000000007, // IOC5
    120'h028008000000000020000000000007, // IOC4
    120'h030000000000000010000000000007, // IOC3
    120'h022000000000000008000000000007, // IOC2
    120'h021000000000000004000000000007, // IOC1
    120'h024000000000000002000000000007, // IOC0
    120'h020000014600000001000000000007, // IOB12
    120'h02000000a600000000800000000007, // IOB11
    120'h020100011880000000400000000007, // IOB10
    120'h020000009900000000200000000007, // IOB9
    120'h020084000000000000100000000007, // IOB8
    120'h020104000000000000080000000007, // IOB7
    120'h020000000000000000040000000407, // IOB6
    120'h020022000000000000020000000007, // IOB5
    120'h020000000000000000010000000207, // IOB4
    120'h020000800000000000008000000007, // IOB3
    120'h020000000000000000004000000107, // IOB2
    120'h020000000000000000002000000087, // IOB1
    120'h020001000000000000001000000007, // IOB0
    120'h020400003100000000000800000007, // IOA8
    120'h020200004880000000000400000007, // IOA7
    120'h020000000000000000000200000007, // IOA6
    120'h020040200000000000000100000007, // IOA5
    120'h020000400000000000000080000007, // IOA4
    120'h020008400000000000000040000007, // IOA3
    120'h020080200000000000000020000007, // IOA2
    120'h020010000000000000000010000007, // IOA1
    120'h020000000000000000000008000007, // IOA0
    120'h020000000000000000000004000007, // SPI_DEV_CS_L
    120'h020000000000000000000002000007, // SPI_DEV_CLK
    120'h020000000000000000000001004007, // SPI_DEV_D3
    120'h020000000000000000000000802007, // SPI_DEV_D2
    120'h020000000000000000000000401007, // SPI_DEV_D1
    120'h020000000000000000000000200807, // SPI_DEV_D0
    120'h020000100000000000000000100007, // SPI_HOST_CS_L
    120'h020000080000000000000000080007, // SPI_HOST_CLK
    120'h020800000000000000000000040047, // SPI_HOST_D3
    120'h020000000000000000000000020027, // SPI_HOST_D2
    120'h020000000000000000000000010017, // SPI_HOST_D1
    120'h02000000000000000000000000800f  // SPI_HOST_D0
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
    MuxPartPrimary, // sysrst_ctrl_lid_open
    MuxPartPrimary, // sysrst_ctrl_pwrb_in
    MuxPartPrimary, // sysrst_ctrl_key2_in
    MuxPartPrimary, // sysrst_ctrl_key1_in
    MuxPartPrimary, // sysrst_ctrl_key0_in
    MuxPartPrimary, // sysrst_ctrl_ac_present
    MuxPartPrimary, // i3c1_rstdet_sda
    MuxPartPrimary, // i3c1_rstdet_scl
    MuxPartPrimary, // i3c0_rstdet_sda
    MuxPartPrimary, // i3c0_rstdet_scl
    MuxPartPrimary, // uart3_rx
    MuxPartPrimary, // uart2_rx
    MuxPartPrimary, // uart1_rx
    MuxPartPrimary, // uart0_rx
    MuxPartPrimary, // spi_device_tpm_csb
    MuxPartPrimary, // spi_device_csb
    MuxPartPrimary, // spi_device_sck
    MuxPartPrimary, // usbdev_sense
    MuxPartPrimary, // sysrst_ctrl_flash_wp_l
    MuxPartPrimary, // sysrst_ctrl_ec_rst_l
    MuxPartPrimary, // i3c1_sda
    MuxPartPrimary, // i3c1_scl
    MuxPartPrimary, // i3c0_sda
    MuxPartPrimary, // i3c0_scl
    MuxPartPrimary, // i2c2_scl
    MuxPartPrimary, // i2c2_sda
    MuxPartPrimary, // i2c1_scl
    MuxPartPrimary, // i2c1_sda
    MuxPartPrimary, // i2c0_scl
    MuxPartPrimary, // i2c0_sda
    MuxPartPrimary, // gpio1_gpio[31]
    MuxPartPrimary, // gpio1_gpio[30]
    MuxPartPrimary, // gpio1_gpio[29]
    MuxPartPrimary, // gpio1_gpio[28]
    MuxPartPrimary, // gpio1_gpio[27]
    MuxPartPrimary, // gpio1_gpio[26]
    MuxPartPrimary, // gpio1_gpio[25]
    MuxPartPrimary, // gpio1_gpio[24]
    MuxPartPrimary, // gpio1_gpio[23]
    MuxPartPrimary, // gpio1_gpio[22]
    MuxPartPrimary, // gpio1_gpio[21]
    MuxPartPrimary, // gpio1_gpio[20]
    MuxPartPrimary, // gpio1_gpio[19]
    MuxPartPrimary, // gpio1_gpio[18]
    MuxPartPrimary, // gpio1_gpio[17]
    MuxPartPrimary, // gpio1_gpio[16]
    MuxPartPrimary, // gpio1_gpio[15]
    MuxPartPrimary, // gpio1_gpio[14]
    MuxPartPrimary, // gpio1_gpio[13]
    MuxPartPrimary, // gpio1_gpio[12]
    MuxPartPrimary, // gpio1_gpio[11]
    MuxPartPrimary, // gpio1_gpio[10]
    MuxPartPrimary, // gpio1_gpio[9]
    MuxPartPrimary, // gpio1_gpio[8]
    MuxPartPrimary, // gpio1_gpio[7]
    MuxPartPrimary, // gpio1_gpio[6]
    MuxPartPrimary, // gpio1_gpio[5]
    MuxPartPrimary, // gpio1_gpio[4]
    MuxPartPrimary, // gpio1_gpio[3]
    MuxPartPrimary, // gpio1_gpio[2]
    MuxPartPrimary, // gpio1_gpio[1]
    MuxPartPrimary, // gpio1_gpio[0]
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
    MuxPartPrimary, // gpio0_gpio[0]
    MuxPartPrimary, // spi_device_sd[3]
    MuxPartPrimary, // spi_device_sd[2]
    MuxPartPrimary, // spi_device_sd[1]
    MuxPartPrimary, // spi_device_sd[0]
    MuxPartPrimary, // spi_host1_sd[3]
    MuxPartPrimary, // spi_host1_sd[2]
    MuxPartPrimary, // spi_host1_sd[1]
    MuxPartPrimary, // spi_host1_sd[0]
    MuxPartPrimary, // spi_host0_sd[3]
    MuxPartPrimary, // spi_host0_sd[2]
    MuxPartPrimary, // spi_host0_sd[1]
    MuxPartPrimary  // spi_host0_sd[0]
  };

  // Whether the source of each MIO_OUTSEL value is in the primary partition. LSB corresponds to
  // lowest index. Includes the static options, which exist in both partitions.
  parameter logic [AlignedMioOutMuxSize-1:0] MioOutselInPrimary = AlignedMioOutMuxSize'({
    1'b1, // sysrst_ctrl_z3_wakeup
    1'b1, // sysrst_ctrl_pwrb_out
    1'b1, // sysrst_ctrl_key2_out
    1'b1, // sysrst_ctrl_key1_out
    1'b1, // sysrst_ctrl_key0_out
    1'b1, // sysrst_ctrl_bat_disable
    1'b1, // sensor_ctrl_ast_debug_out[8]
    1'b1, // sensor_ctrl_ast_debug_out[7]
    1'b1, // sensor_ctrl_ast_debug_out[6]
    1'b1, // sensor_ctrl_ast_debug_out[5]
    1'b1, // sensor_ctrl_ast_debug_out[4]
    1'b1, // sensor_ctrl_ast_debug_out[3]
    1'b1, // sensor_ctrl_ast_debug_out[2]
    1'b1, // sensor_ctrl_ast_debug_out[1]
    1'b1, // sensor_ctrl_ast_debug_out[0]
    1'b1, // i3c1_ctrl_sda_pu
    1'b1, // i3c0_ctrl_sda_pu
    1'b1, // uart3_tx
    1'b1, // uart2_tx
    1'b1, // uart1_tx
    1'b1, // uart0_tx
    1'b1, // spi_host1_csb[2]
    1'b1, // spi_host1_csb[1]
    1'b1, // spi_host1_csb[0]
    1'b1, // spi_host1_sck
    1'b1, // spi_host0_csb[2]
    1'b1, // spi_host0_csb[1]
    1'b1, // spi_host0_csb[0]
    1'b1, // spi_host0_sck
    1'b1, // sysrst_ctrl_flash_wp_l
    1'b1, // sysrst_ctrl_ec_rst_l
    1'b1, // i3c1_sda
    1'b1, // i3c1_scl
    1'b1, // i3c0_sda
    1'b1, // i3c0_scl
    1'b1, // i2c2_scl
    1'b1, // i2c2_sda
    1'b1, // i2c1_scl
    1'b1, // i2c1_sda
    1'b1, // i2c0_scl
    1'b1, // i2c0_sda
    1'b1, // gpio1_gpio[31]
    1'b1, // gpio1_gpio[30]
    1'b1, // gpio1_gpio[29]
    1'b1, // gpio1_gpio[28]
    1'b1, // gpio1_gpio[27]
    1'b1, // gpio1_gpio[26]
    1'b1, // gpio1_gpio[25]
    1'b1, // gpio1_gpio[24]
    1'b1, // gpio1_gpio[23]
    1'b1, // gpio1_gpio[22]
    1'b1, // gpio1_gpio[21]
    1'b1, // gpio1_gpio[20]
    1'b1, // gpio1_gpio[19]
    1'b1, // gpio1_gpio[18]
    1'b1, // gpio1_gpio[17]
    1'b1, // gpio1_gpio[16]
    1'b1, // gpio1_gpio[15]
    1'b1, // gpio1_gpio[14]
    1'b1, // gpio1_gpio[13]
    1'b1, // gpio1_gpio[12]
    1'b1, // gpio1_gpio[11]
    1'b1, // gpio1_gpio[10]
    1'b1, // gpio1_gpio[9]
    1'b1, // gpio1_gpio[8]
    1'b1, // gpio1_gpio[7]
    1'b1, // gpio1_gpio[6]
    1'b1, // gpio1_gpio[5]
    1'b1, // gpio1_gpio[4]
    1'b1, // gpio1_gpio[3]
    1'b1, // gpio1_gpio[2]
    1'b1, // gpio1_gpio[1]
    1'b1, // gpio1_gpio[0]
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
    1'b1, // spi_device_sd[3]
    1'b1, // spi_device_sd[2]
    1'b1, // spi_device_sd[1]
    1'b1, // spi_device_sd[0]
    1'b1, // spi_host1_sd[3]
    1'b1, // spi_host1_sd[2]
    1'b1, // spi_host1_sd[1]
    1'b1, // spi_host1_sd[0]
    1'b1, // spi_host0_sd[3]
    1'b1, // spi_host0_sd[2]
    1'b1, // spi_host0_sd[1]
    1'b1, // spi_host0_sd[0]
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
    1'b1, // IOR9
    1'b1, // IOR8
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
    1'b1, // IOA0
    1'b1, // SPI_DEV_CS_L
    1'b1, // SPI_DEV_CLK
    1'b1, // SPI_DEV_D3
    1'b1, // SPI_DEV_D2
    1'b1, // SPI_DEV_D1
    1'b1, // SPI_DEV_D0
    1'b1, // SPI_HOST_CS_L
    1'b1, // SPI_HOST_CLK
    1'b1, // SPI_HOST_D3
    1'b1, // SPI_HOST_D2
    1'b1, // SPI_HOST_D1
    1'b1  // SPI_HOST_D0
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
