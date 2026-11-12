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
    14'h3fff, // soc_proxy_soc_gpi[15]
    14'h3fff, // soc_proxy_soc_gpi[14]
    14'h3fff, // soc_proxy_soc_gpi[13]
    14'h3fff  // soc_proxy_soc_gpi[12]
  };

  // Legal MIO_OUTSEL values for each MIO pad. LSB corresponds to lowest index. Includes static
  // options.
  parameter logic [NMioPads-1:0][NMioPeriphOut+2:0] MioOutselLegal = {
    8'hff, // MIO11
    8'hff, // MIO10
    8'hff, // MIO9
    8'hff, // MIO8
    8'hff, // MIO7
    8'hff, // MIO6
    8'hff, // MIO5
    8'hff, // MIO4
    8'hff, // MIO3
    8'hff, // MIO2
    8'hff, // MIO1
    8'hff  // MIO0
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
    MuxPartPrimary, // soc_proxy_soc_gpi[15]
    MuxPartPrimary, // soc_proxy_soc_gpi[14]
    MuxPartPrimary, // soc_proxy_soc_gpi[13]
    MuxPartPrimary  // soc_proxy_soc_gpi[12]
  };

  // Whether the source of each MIO_OUTSEL value is in the primary partition. LSB corresponds to
  // lowest index. Includes the static options, which exist in both partitions.
  parameter logic [AlignedMioOutMuxSize-1:0] MioOutselInPrimary = AlignedMioOutMuxSize'({
    1'b1, // otp_macro_test[0]
    1'b1, // soc_proxy_soc_gpo[15]
    1'b1, // soc_proxy_soc_gpo[14]
    1'b1, // soc_proxy_soc_gpo[13]
    1'b1, // soc_proxy_soc_gpo[12]
    3'b111  // static options
  });

  // Whether the output mux of each MIO pad is in the primary partition. This is the case if any
  // legal peripheral output of the pad is in the primary partition. LSB corresponds to lowest
  // index.
  parameter logic [NMioPads-1:0] MioPadMuxedInPrimary = {
    1'b1, // MIO11
    1'b1, // MIO10
    1'b1, // MIO9
    1'b1, // MIO8
    1'b1, // MIO7
    1'b1, // MIO6
    1'b1, // MIO5
    1'b1, // MIO4
    1'b1, // MIO3
    1'b1, // MIO2
    1'b1, // MIO1
    1'b1  // MIO0
  };

  // Reset values of the MIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
  parameter pad_attr_t [NMioPads-1:0] MioPadAttrResval = {
    pad_attr_t'{default: '0}, // MIO11
    pad_attr_t'{default: '0}, // MIO10
    pad_attr_t'{default: '0}, // MIO9
    pad_attr_t'{default: '0}, // MIO8
    pad_attr_t'{default: '0}, // MIO7
    pad_attr_t'{default: '0}, // MIO6
    pad_attr_t'{default: '0}, // MIO5
    pad_attr_t'{default: '0}, // MIO4
    pad_attr_t'{default: '0}, // MIO3
    pad_attr_t'{default: '0}, // MIO2
    pad_attr_t'{default: '0}, // MIO1
    pad_attr_t'{default: '0}  // MIO0
  };

  // Reset values of the DIO_PAD_ATTR CSRs defined by top.hjson. LSB corresponds to lowest index.
  parameter pad_attr_t [NDioPads-1:0] DioPadAttrResval = {
    pad_attr_t'{default: '0}, // SOC_GPO11
    pad_attr_t'{default: '0}, // SOC_GPO10
    pad_attr_t'{default: '0}, // SOC_GPO9
    pad_attr_t'{default: '0}, // SOC_GPO8
    pad_attr_t'{default: '0}, // SOC_GPO7
    pad_attr_t'{default: '0}, // SOC_GPO6
    pad_attr_t'{default: '0}, // SOC_GPO5
    pad_attr_t'{default: '0}, // SOC_GPO4
    pad_attr_t'{default: '0}, // SOC_GPO3
    pad_attr_t'{default: '0}, // SOC_GPO2
    pad_attr_t'{default: '0}, // SOC_GPO1
    pad_attr_t'{default: '0}, // SOC_GPO0
    pad_attr_t'{default: '0}, // UART_TX
    pad_attr_t'{default: '0}, // SPI_HOST_CS_L
    pad_attr_t'{default: '0}, // SPI_HOST_CLK
    pad_attr_t'{default: '0}, // SOC_GPI11
    pad_attr_t'{default: '0}, // SOC_GPI10
    pad_attr_t'{default: '0}, // SOC_GPI9
    pad_attr_t'{default: '0}, // SOC_GPI8
    pad_attr_t'{default: '0}, // SOC_GPI7
    pad_attr_t'{default: '0}, // SOC_GPI6
    pad_attr_t'{default: '0}, // SOC_GPI5
    pad_attr_t'{default: '0}, // SOC_GPI4
    pad_attr_t'{default: '0}, // SOC_GPI3
    pad_attr_t'{default: '0}, // SOC_GPI2
    pad_attr_t'{default: '0}, // SOC_GPI1
    pad_attr_t'{default: '0}, // SOC_GPI0
    pad_attr_t'{default: '0}, // UART_RX
    pad_attr_t'{default: '0}, // SPI_DEV_TPM_CS_L
    pad_attr_t'{default: '0}, // SPI_DEV_CS_L
    pad_attr_t'{default: '0}, // SPI_DEV_CLK
    pad_attr_t'{default: '0}, // GPIO31
    pad_attr_t'{default: '0}, // GPIO30
    pad_attr_t'{default: '0}, // GPIO29
    pad_attr_t'{default: '0}, // GPIO28
    pad_attr_t'{default: '0}, // GPIO27
    pad_attr_t'{default: '0}, // GPIO26
    pad_attr_t'{default: '0}, // GPIO25
    pad_attr_t'{default: '0}, // GPIO24
    pad_attr_t'{default: '0}, // GPIO23
    pad_attr_t'{default: '0}, // GPIO22
    pad_attr_t'{default: '0}, // GPIO21
    pad_attr_t'{default: '0}, // GPIO20
    pad_attr_t'{default: '0}, // GPIO19
    pad_attr_t'{default: '0}, // GPIO18
    pad_attr_t'{default: '0}, // GPIO17
    pad_attr_t'{default: '0}, // GPIO16
    pad_attr_t'{default: '0}, // GPIO15
    pad_attr_t'{default: '0}, // GPIO14
    pad_attr_t'{default: '0}, // GPIO13
    pad_attr_t'{default: '0}, // GPIO12
    pad_attr_t'{default: '0}, // GPIO11
    pad_attr_t'{default: '0}, // GPIO10
    pad_attr_t'{default: '0}, // GPIO9
    pad_attr_t'{default: '0}, // GPIO8
    pad_attr_t'{default: '0}, // GPIO7
    pad_attr_t'{default: '0}, // GPIO6
    pad_attr_t'{default: '0}, // GPIO5
    pad_attr_t'{default: '0}, // GPIO4
    pad_attr_t'{default: '0}, // GPIO3
    pad_attr_t'{default: '0}, // GPIO2
    pad_attr_t'{default: '0}, // GPIO1
    pad_attr_t'{default: '0}, // GPIO0
    pad_attr_t'{default: '0}, // I2C_SDA
    pad_attr_t'{default: '0}, // I2C_SCL
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
