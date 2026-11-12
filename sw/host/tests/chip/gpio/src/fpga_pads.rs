// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//! Pads the gpio tests drive and read from both the chip and the host.

use ot_hal::top::earlgrey::PinmuxMioOut;

/// Pads with a plain HyperDebug GPIO behind them on the FPGA boards (CW310/340) and the teacup.
///
/// See the `top_earlgrey/data/pins_{cw310_hyperdebug,cw341}.xdc` files. On the CW340 none of
/// them is in the device side list of pads another device on the board can drive
/// (`pinmux_testutils_is_board_driven_pad`). Not used:
/// - IOA0, IOA1, IOA4-6: JTAG
/// - IOA7, IOA8, IOB0-2, IOB9-12: HyperDebug I2C and SPI2 pins
/// - IOB3-5: HyperDebug SPI2 and UART3 pins
/// - IOB7: I3C test board UART TX, driven permanently by the board
/// - IOC0-2: SW Strap 0-2
/// - IOC3-4: UART0 RX/TX (requires rework as test uses a UART console)
/// - IOC5: TAP Strap 1
/// - IOC6: PWM / EXT_CLK
/// - IOC7: USB VBUS DETECT
/// - IOC8: TAP Strap 0
/// - IOC9: PMOD2 IO2
/// - IOR3-6: HyperDebug UART4 and UART5 pins
/// - IOR8-9: sysrst_ctrl ec_rst_l and flash_wp_l
pub const GPIO_PADS: &[PinmuxMioOut] = &[
    PinmuxMioOut::Ioa2,
    PinmuxMioOut::Ioa3,
    PinmuxMioOut::Iob6,
    PinmuxMioOut::Iob8,
    PinmuxMioOut::Ioc10,
    PinmuxMioOut::Ioc11,
    PinmuxMioOut::Ioc12,
    PinmuxMioOut::Ior0,
    PinmuxMioOut::Ior1,
    PinmuxMioOut::Ior2,
    PinmuxMioOut::Ior7,
    PinmuxMioOut::Ior10,
    PinmuxMioOut::Ior11,
    PinmuxMioOut::Ior12,
    PinmuxMioOut::Ior13,
];

/// The pad each GPIO pin can reach in the sparse pinmux, as `GPIO_PIN_PADS[instance][pin]`.
///
/// Hand-kept copy of the `gpio0` and `gpio1` pads in `top_earlgrey.hjson`, like
/// `kPinmuxTestutilsGpioPads` in `pinmux_testutils.c`. gpio1 pins 29-31 repeat the pads of pins
/// 25-27 (IOR10-IOR12).
pub const GPIO_PIN_PADS: [[PinmuxMioOut; 32]; 2] = [
    [
        PinmuxMioOut::SpiHostD0,
        PinmuxMioOut::SpiHostD1,
        PinmuxMioOut::SpiHostD2,
        PinmuxMioOut::SpiHostD3,
        PinmuxMioOut::SpiHostClk,
        PinmuxMioOut::SpiHostCsL,
        PinmuxMioOut::SpiDevD0,
        PinmuxMioOut::SpiDevD1,
        PinmuxMioOut::SpiDevD2,
        PinmuxMioOut::SpiDevD3,
        PinmuxMioOut::SpiDevClk,
        PinmuxMioOut::SpiDevCsL,
        PinmuxMioOut::Ioa0,
        PinmuxMioOut::Ioa1,
        PinmuxMioOut::Ioa2,
        PinmuxMioOut::Ioa3,
        PinmuxMioOut::Ioa4,
        PinmuxMioOut::Ioa5,
        PinmuxMioOut::Ioa6,
        PinmuxMioOut::Ioa7,
        PinmuxMioOut::Ioa8,
        PinmuxMioOut::Iob0,
        PinmuxMioOut::Iob1,
        PinmuxMioOut::Iob2,
        PinmuxMioOut::Iob3,
        PinmuxMioOut::Iob4,
        PinmuxMioOut::Iob5,
        PinmuxMioOut::Iob6,
        PinmuxMioOut::Iob7,
        PinmuxMioOut::Iob8,
        PinmuxMioOut::Iob9,
        PinmuxMioOut::Iob10,
    ],
    [
        PinmuxMioOut::Iob11,
        PinmuxMioOut::Iob12,
        PinmuxMioOut::Ioc0,
        PinmuxMioOut::Ioc1,
        PinmuxMioOut::Ioc2,
        PinmuxMioOut::Ioc3,
        PinmuxMioOut::Ioc4,
        PinmuxMioOut::Ioc5,
        PinmuxMioOut::Ioc6,
        PinmuxMioOut::Ioc7,
        PinmuxMioOut::Ioc8,
        PinmuxMioOut::Ioc9,
        PinmuxMioOut::Ioc10,
        PinmuxMioOut::Ioc11,
        PinmuxMioOut::Ioc12,
        PinmuxMioOut::Ior0,
        PinmuxMioOut::Ior1,
        PinmuxMioOut::Ior2,
        PinmuxMioOut::Ior3,
        PinmuxMioOut::Ior4,
        PinmuxMioOut::Ior5,
        PinmuxMioOut::Ior6,
        PinmuxMioOut::Ior7,
        PinmuxMioOut::Ior8,
        PinmuxMioOut::Ior9,
        PinmuxMioOut::Ior10,
        PinmuxMioOut::Ior11,
        PinmuxMioOut::Ior12,
        PinmuxMioOut::Ior13,
        PinmuxMioOut::Ior10,
        PinmuxMioOut::Ior11,
        PinmuxMioOut::Ior12,
    ],
];

/// Returns the GPIO instance and pin that reach the pad, the lowest pin if several do.
pub fn gpio_pin_of_pad(pad: PinmuxMioOut) -> Option<(u8, u32)> {
    GPIO_PIN_PADS
        .iter()
        .enumerate()
        .find_map(|(instance, pads)| {
            pads.iter()
                .position(|&p| p == pad)
                .map(|pin| (instance as u8, pin as u32))
        })
}

/// Returns whether the pad with the given name (e.g. "IOA2") is one of the [`GPIO_PADS`].
pub fn is_gpio_pad(name: &str) -> bool {
    GPIO_PADS
        .iter()
        .any(|pad| pad.to_string().eq_ignore_ascii_case(name))
}
