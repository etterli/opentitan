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
    pad_type_e [NDioPads-1:0] dio_pad_type;
    pad_type_e [NMioPads-1:0] mio_pad_type;
    scan_role_e [NDioPads-1:0] dio_scan_role;
    scan_role_e [NMioPads-1:0] mio_scan_role;
  } target_cfg_t;

  parameter target_cfg_t DefaultTargetCfg = '{
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
    14'h3fff, // 3: soc_proxy_soc_gpi[15]
    14'h3fff, // 2: soc_proxy_soc_gpi[14]
    14'h3fff, // 1: soc_proxy_soc_gpi[13]
    14'h3fff  // 0: soc_proxy_soc_gpi[12]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    8'hff, // 11: MIO11
    8'hff, // 10: MIO10
    8'hff, //  9: MIO9
    8'hff, //  8: MIO8
    8'hff, //  7: MIO7
    8'hff, //  6: MIO6
    8'hff, //  5: MIO5
    8'hff, //  4: MIO4
    8'hff, //  3: MIO3
    8'hff, //  2: MIO2
    8'hff, //  1: MIO1
    8'hff  //  0: MIO0
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
    MuxPartPrimary, // 3: soc_proxy_soc_gpi[15]
    MuxPartPrimary, // 2: soc_proxy_soc_gpi[14]
    MuxPartPrimary, // 1: soc_proxy_soc_gpi[13]
    MuxPartPrimary  // 0: soc_proxy_soc_gpi[12]
  };

  // Whether the source of each MIO_OUTSEL value is in the primary partition. LSB corresponds to
  // lowest index. Includes the static options, which exist in both partitions.
  parameter logic [AlignedMioOutMuxSize-1:0] MioOutselInPrimary = AlignedMioOutMuxSize'({
    1'b1, // 7: otp_macro_test[0]
    1'b1, // 6: soc_proxy_soc_gpo[15]
    1'b1, // 5: soc_proxy_soc_gpo[14]
    1'b1, // 4: soc_proxy_soc_gpo[13]
    1'b1, // 3: soc_proxy_soc_gpo[12]
    3'b111  // 2..0: static options
  });

  // Whether the output mux of each MIO pad is in the primary partition. This is the case if any
  // legal peripheral output of the pad is in the primary partition. LSB corresponds to lowest
  // index.
  parameter logic [NMioPads-1:0] MioPadMuxedInPrimary = {
    1'b1, // 11: MIO11
    1'b1, // 10: MIO10
    1'b1, //  9: MIO9
    1'b1, //  8: MIO8
    1'b1, //  7: MIO7
    1'b1, //  6: MIO6
    1'b1, //  5: MIO5
    1'b1, //  4: MIO4
    1'b1, //  3: MIO3
    1'b1, //  2: MIO2
    1'b1, //  1: MIO1
    1'b1  //  0: MIO0
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
    1'b1, // 72: soc_proxy_soc_gpo[11]
    1'b1, // 71: soc_proxy_soc_gpo[10]
    1'b1, // 70: soc_proxy_soc_gpo[9]
    1'b1, // 69: soc_proxy_soc_gpo[8]
    1'b1, // 68: soc_proxy_soc_gpo[7]
    1'b1, // 67: soc_proxy_soc_gpo[6]
    1'b1, // 66: soc_proxy_soc_gpo[5]
    1'b1, // 65: soc_proxy_soc_gpo[4]
    1'b1, // 64: soc_proxy_soc_gpo[3]
    1'b1, // 63: soc_proxy_soc_gpo[2]
    1'b1, // 62: soc_proxy_soc_gpo[1]
    1'b1, // 61: soc_proxy_soc_gpo[0]
    1'b1, // 60: uart0_tx
    1'b1, // 59: spi_host0_csb
    1'b1, // 58: spi_host0_sck
    1'b1, // 57: soc_proxy_soc_gpi[11]
    1'b1, // 56: soc_proxy_soc_gpi[10]
    1'b1, // 55: soc_proxy_soc_gpi[9]
    1'b1, // 54: soc_proxy_soc_gpi[8]
    1'b1, // 53: soc_proxy_soc_gpi[7]
    1'b1, // 52: soc_proxy_soc_gpi[6]
    1'b1, // 51: soc_proxy_soc_gpi[5]
    1'b1, // 50: soc_proxy_soc_gpi[4]
    1'b1, // 49: soc_proxy_soc_gpi[3]
    1'b1, // 48: soc_proxy_soc_gpi[2]
    1'b1, // 47: soc_proxy_soc_gpi[1]
    1'b1, // 46: soc_proxy_soc_gpi[0]
    1'b1, // 45: uart0_rx
    1'b1, // 44: spi_device_tpm_csb
    1'b1, // 43: spi_device_csb
    1'b1, // 42: spi_device_sck
    1'b1, // 41: gpio0_gpio[31]
    1'b1, // 40: gpio0_gpio[30]
    1'b1, // 39: gpio0_gpio[29]
    1'b1, // 38: gpio0_gpio[28]
    1'b1, // 37: gpio0_gpio[27]
    1'b1, // 36: gpio0_gpio[26]
    1'b1, // 35: gpio0_gpio[25]
    1'b1, // 34: gpio0_gpio[24]
    1'b1, // 33: gpio0_gpio[23]
    1'b1, // 32: gpio0_gpio[22]
    1'b1, // 31: gpio0_gpio[21]
    1'b1, // 30: gpio0_gpio[20]
    1'b1, // 29: gpio0_gpio[19]
    1'b1, // 28: gpio0_gpio[18]
    1'b1, // 27: gpio0_gpio[17]
    1'b1, // 26: gpio0_gpio[16]
    1'b1, // 25: gpio0_gpio[15]
    1'b1, // 24: gpio0_gpio[14]
    1'b1, // 23: gpio0_gpio[13]
    1'b1, // 22: gpio0_gpio[12]
    1'b1, // 21: gpio0_gpio[11]
    1'b1, // 20: gpio0_gpio[10]
    1'b1, // 19: gpio0_gpio[9]
    1'b1, // 18: gpio0_gpio[8]
    1'b1, // 17: gpio0_gpio[7]
    1'b1, // 16: gpio0_gpio[6]
    1'b1, // 15: gpio0_gpio[5]
    1'b1, // 14: gpio0_gpio[4]
    1'b1, // 13: gpio0_gpio[3]
    1'b1, // 12: gpio0_gpio[2]
    1'b1, // 11: gpio0_gpio[1]
    1'b1, // 10: gpio0_gpio[0]
    1'b1, //  9: i2c0_sda
    1'b1, //  8: i2c0_scl
    1'b1, //  7: spi_device_sd[3]
    1'b1, //  6: spi_device_sd[2]
    1'b1, //  5: spi_device_sd[1]
    1'b1, //  4: spi_device_sd[0]
    1'b1, //  3: spi_host0_sd[3]
    1'b1, //  2: spi_host0_sd[2]
    1'b1, //  1: spi_host0_sd[1]
    1'b1  //  0: spi_host0_sd[0]
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NMioPads-1:0] MioPadAttrResval = {
    pad_attr_t'{default: '0}, // 11: MIO11
    pad_attr_t'{default: '0}, // 10: MIO10
    pad_attr_t'{default: '0}, //  9: MIO9
    pad_attr_t'{default: '0}, //  8: MIO8
    pad_attr_t'{default: '0}, //  7: MIO7
    pad_attr_t'{default: '0}, //  6: MIO6
    pad_attr_t'{default: '0}, //  5: MIO5
    pad_attr_t'{default: '0}, //  4: MIO4
    pad_attr_t'{default: '0}, //  3: MIO3
    pad_attr_t'{default: '0}, //  2: MIO2
    pad_attr_t'{default: '0}, //  1: MIO1
    pad_attr_t'{default: '0}  //  0: MIO0
  };

  // Reset values of the DIO_PAD_ATTR CSRs defined by the top. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
    pad_attr_t'{default: '0}, // 72: SOC_GPO11
    pad_attr_t'{default: '0}, // 71: SOC_GPO10
    pad_attr_t'{default: '0}, // 70: SOC_GPO9
    pad_attr_t'{default: '0}, // 69: SOC_GPO8
    pad_attr_t'{default: '0}, // 68: SOC_GPO7
    pad_attr_t'{default: '0}, // 67: SOC_GPO6
    pad_attr_t'{default: '0}, // 66: SOC_GPO5
    pad_attr_t'{default: '0}, // 65: SOC_GPO4
    pad_attr_t'{default: '0}, // 64: SOC_GPO3
    pad_attr_t'{default: '0}, // 63: SOC_GPO2
    pad_attr_t'{default: '0}, // 62: SOC_GPO1
    pad_attr_t'{default: '0}, // 61: SOC_GPO0
    pad_attr_t'{default: '0}, // 60: UART_TX
    pad_attr_t'{default: '0}, // 59: SPI_HOST_CS_L
    pad_attr_t'{default: '0}, // 58: SPI_HOST_CLK
    pad_attr_t'{default: '0}, // 57: SOC_GPI11
    pad_attr_t'{default: '0}, // 56: SOC_GPI10
    pad_attr_t'{default: '0}, // 55: SOC_GPI9
    pad_attr_t'{default: '0}, // 54: SOC_GPI8
    pad_attr_t'{default: '0}, // 53: SOC_GPI7
    pad_attr_t'{default: '0}, // 52: SOC_GPI6
    pad_attr_t'{default: '0}, // 51: SOC_GPI5
    pad_attr_t'{default: '0}, // 50: SOC_GPI4
    pad_attr_t'{default: '0}, // 49: SOC_GPI3
    pad_attr_t'{default: '0}, // 48: SOC_GPI2
    pad_attr_t'{default: '0}, // 47: SOC_GPI1
    pad_attr_t'{default: '0}, // 46: SOC_GPI0
    pad_attr_t'{default: '0}, // 45: UART_RX
    pad_attr_t'{default: '0}, // 44: SPI_DEV_TPM_CS_L
    pad_attr_t'{default: '0}, // 43: SPI_DEV_CS_L
    pad_attr_t'{default: '0}, // 42: SPI_DEV_CLK
    pad_attr_t'{default: '0}, // 41: GPIO31
    pad_attr_t'{default: '0}, // 40: GPIO30
    pad_attr_t'{default: '0}, // 39: GPIO29
    pad_attr_t'{default: '0}, // 38: GPIO28
    pad_attr_t'{default: '0}, // 37: GPIO27
    pad_attr_t'{default: '0}, // 36: GPIO26
    pad_attr_t'{default: '0}, // 35: GPIO25
    pad_attr_t'{default: '0}, // 34: GPIO24
    pad_attr_t'{default: '0}, // 33: GPIO23
    pad_attr_t'{default: '0}, // 32: GPIO22
    pad_attr_t'{default: '0}, // 31: GPIO21
    pad_attr_t'{default: '0}, // 30: GPIO20
    pad_attr_t'{default: '0}, // 29: GPIO19
    pad_attr_t'{default: '0}, // 28: GPIO18
    pad_attr_t'{default: '0}, // 27: GPIO17
    pad_attr_t'{default: '0}, // 26: GPIO16
    pad_attr_t'{default: '0}, // 25: GPIO15
    pad_attr_t'{default: '0}, // 24: GPIO14
    pad_attr_t'{default: '0}, // 23: GPIO13
    pad_attr_t'{default: '0}, // 22: GPIO12
    pad_attr_t'{default: '0}, // 21: GPIO11
    pad_attr_t'{default: '0}, // 20: GPIO10
    pad_attr_t'{default: '0}, // 19: GPIO9
    pad_attr_t'{default: '0}, // 18: GPIO8
    pad_attr_t'{default: '0}, // 17: GPIO7
    pad_attr_t'{default: '0}, // 16: GPIO6
    pad_attr_t'{default: '0}, // 15: GPIO5
    pad_attr_t'{default: '0}, // 14: GPIO4
    pad_attr_t'{default: '0}, // 13: GPIO3
    pad_attr_t'{default: '0}, // 12: GPIO2
    pad_attr_t'{default: '0}, // 11: GPIO1
    pad_attr_t'{default: '0}, // 10: GPIO0
    pad_attr_t'{default: '0}, //  9: I2C_SDA
    pad_attr_t'{default: '0}, //  8: I2C_SCL
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
