# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//rules/opentitan:defs.bzl", "opentitan_binary")
load("//hw/top:defs.bzl", "opentitan_require_top")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "ecc256_keygen_serial",
    srcs = ["ecc256_keygen_serial.c"],
    hdrs = ["ecc256_keygen_serial.h"],
    target_compatible_with = opentitan_require_top("earlgrey"),
    deps = [
        "//hw/top:top_lib",
        "//sw/device/lib/base:abs_mmio",
        "//sw/device/lib/base:memory",
        "//sw/device/lib/crypto/drivers:otbn",
        "//sw/device/lib/runtime:ibex",
        "//sw/device/lib/runtime:log",
        "//sw/device/lib/testing:entropy_testutils",
        "//sw/device/lib/testing/test_framework:ottf_ld_silicon_creator_slot_a",
        "//sw/device/lib/testing/test_framework:ottf_main",
        "//sw/device/sca/lib:prng",
        "//sw/device/sca/lib:simple_serial",
        "//sw/device/tests/penetrationtests/firmware/lib:pentest_lib",
        "//sw/otbn/crypto:p256_key_from_seed_sca",
    ],
)

cc_library(
    name = "ecc256_modinv_serial",
    srcs = ["ecc256_modinv_serial.c"],
    hdrs = ["ecc256_modinv_serial.h"],
    target_compatible_with = opentitan_require_top("earlgrey"),
    deps = [
        "//hw/top:top_lib",
        "//sw/device/lib/base:abs_mmio",
        "//sw/device/lib/base:memory",
        "//sw/device/lib/crypto/drivers:otbn",
        "//sw/device/lib/runtime:ibex",
        "//sw/device/lib/runtime:log",
        "//sw/device/lib/testing:entropy_testutils",
        "//sw/device/lib/testing/test_framework:ottf_ld_silicon_creator_slot_a",
        "//sw/device/lib/testing/test_framework:ottf_main",
        "//sw/device/sca/lib:prng",
        "//sw/device/sca/lib:simple_serial",
        "//sw/device/tests/penetrationtests/firmware/lib:pentest_lib",
        "//sw/otbn/crypto:p256_mod_inv_sca",
    ],
)

# TODO: The trigger GPIOs on IOB0/IOB1 meet the HyperDebug SPI2 outputs in the
# reinit window on the CW340, so this binary is not built for the CW340.
# Re-enable the CW340 build with a dedicated setup.
opentitan_binary(
    name = "otbn_vertical_serial",
    testonly = True,
    srcs = ["otbn_vertical_serial.c"],
    exec_env = [
        "//hw/top_earlgrey:fpga_cw305",
    ],
    target_compatible_with = opentitan_require_top("earlgrey"),
    deps = [
        "//hw/top:top_lib",
        "//sw/device/lib/base:abs_mmio",
        "//sw/device/lib/base:memory",
        "//sw/device/lib/crypto/drivers:otbn",
        "//sw/device/lib/runtime:ibex",
        "//sw/device/lib/runtime:log",
        "//sw/device/lib/testing:entropy_testutils",
        "//sw/device/lib/testing/test_framework:ottf_ld_silicon_creator_slot_a",
        "//sw/device/lib/testing/test_framework:ottf_main",
        "//sw/device/sca/lib:prng",
        "//sw/device/sca/lib:simple_serial",
        "//sw/device/sca/otbn_vertical:ecc256_keygen_serial",
        "//sw/device/sca/otbn_vertical:ecc256_modinv_serial",
        "//sw/device/tests/penetrationtests/firmware/lib:pentest_lib",
        "//sw/otbn/crypto:p256_mod_inv_sca",
    ],
)
